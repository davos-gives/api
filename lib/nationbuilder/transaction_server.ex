defmodule Api.Nationbuilder.TransactionServer do
  @name :transaction_server
  @refresh_interval :timer.seconds(3)

  use GenServer

  alias Api.Nationbuilder.Nationbuilder
  alias Api.Donation
  alias Api.Donation.Receipt
  alias Api.Organization
  alias Api.Organization.Campaign
  alias Api.Organization.Slug

  import Logger

  defmodule State do
    defstruct token: nil,
              backloaded: false,
              tenant_name: nil,
              last_transaction_datetime: nil,
              pagination_token: nil,
              pagination_nonce: nil
  end

  def start_link(organization) do
    GenServer.start_link(
      __MODULE__,
      %State{
        token: organization.nationbuilder_token,
        tenant_name: organization.tenant_name
      },
      name: String.to_atom(organization.tenant_name)
    )
  end

  def get_transaction_data do
    GenServer.call(@name, :get_transaction_data)
  end

  # Server Callbacks

  def init(%{token: token, tenant_name: tenant_name} = initial_state) do
    number_of_donations = Donation.has_existing_transactions_for_organization?(tenant_name)

    state =
      if number_of_donations == 0 do
        schedule_backfill()
        initial_state
      else
        last_transaction = Donation.most_recent_transaction(tenant_name)
        {:ok, datetime, _} = DateTime.from_iso8601(last_transaction.nationbuilder_created_at)

        state = %{
          initial_state
          | backloaded: true,
            last_transaction_datetime: datetime
        }

        schedule_search()
        state
      end

    {:ok, state}
  end

  def handle_info(:backfill, state) do
    new_state = backfill(state)
    {:noreply, new_state}
  end

  def handle_info(:search, state) do
    new_state = search(state)
    {:noreply, new_state}
  end

  def schedule_backfill do
    Process.send_after(self(), :backfill, @refresh_interval)
  end

  def schedule_search do
    Process.send_after(self(), :search, @refresh_interval)
  end

  def search(
        %{
          token: token,
          last_transaction_datetime: last_transaction_datetime,
          pagination_nonce: pagination_nonce,
          pagination_token: pagination_token
        } = state
      )
      when byte_size(pagination_token) > 0 do
    client = Nationbuilder.client(token)

    {:ok, results} =
      Nationbuilder.search_organization_donations_with_pagination(
        client,
        last_transaction_datetime,
        pagination_nonce,
        pagination_token
      )

    reversedResults = Enum.reverse(results.body["results"])

    {:ok, state} = create_transactions(reversedResults, state)

    [nonce, token] = extract_pagination_data(results.body["next"])

    new_state = %{state | pagination_token: token, pagination_nonce: nonce}
    schedule_search()
    new_state
  end

  def search(
        %{
          token: token,
          last_transaction_datetime: last_transaction_datetime
        } = state
      ) do
    client = Nationbuilder.client(token)

    {:ok, results} =
      Nationbuilder.search_organization_donations(client, last_transaction_datetime)

    reversedResults = Enum.reverse(results.body["results"])

    {:ok, state} = create_transactions(reversedResults, state)

    [nonce, token] = extract_pagination_data(results.body["next"])

    new_state = %{state | pagination_token: token, pagination_nonce: nonce}
    schedule_search()
    new_state
  end

  def backfill(
        %{
          pagination_token: pagination_token,
          pagination_nonce: pagination_nonce,
          backloaded: backloaded
        } = state
      )
      when byte_size(pagination_token) > 0 and backloaded == true do
    client = Nationbuilder.client(state.token)

    {:ok, results} = Nationbuilder.paginated_donations(client, pagination_nonce, pagination_token)

    reversedResults = Enum.reverse(results.body["results"])

    {:ok, state} = create_transactions(reversedResults, state)

    [nonce, token] = extract_pagination_data(results.body["next"])
    new_state = %{state | pagination_token: token, pagination_nonce: nonce}
    schedule_backfill()
    new_state
  end

  def backfill(%{backloaded: backloaded} = state) when backloaded == false do
    client = Nationbuilder.client(state.token)

    {:ok, results} = Nationbuilder.organization_donations(client)

    reversedResults = Enum.reverse(results.body["results"])

    {:ok, state} = create_transactions(reversedResults, state)

    [nonce, token] = extract_pagination_data(results.body["next"])

    new_state = %{state | pagination_token: token, pagination_nonce: nonce, backloaded: true}
    schedule_backfill()
    new_state
  end

  def backfill(
        %{
          pagination_token: pagination_token,
          pagination_nonce: pagination_nonce,
          backloaded: backloaded
        } = state
      )
      when byte_size(pagination_token) > 0 and backloaded == true do
    client = Nationbuilder.client(state.token)

    {:ok, results} = Nationbuilder.paginated_donations(client, pagination_nonce, pagination_token)

    reversedResults = Enum.reverse(results.body["results"])

    {:ok, state} = create_transactions(reversedResults, state)

    [nonce, token] = extract_pagination_data(results.body["next"])
    new_state = %{state | pagination_token: token, pagination_nonce: nonce}
    schedule_backfill()
    new_state
  end

  def backfill(
        %{
          pagination_token: pagination_token,
          pagination_nonce: pagination_nonce,
          backloaded: backloaded
        } = state
      )
      when byte_size(pagination_token) == 0 and backloaded == true do
    schedule_search()
  end

  defp extract_pagination_data(url) when is_nil(url) do
    ["", ""]
  end

  defp extract_pagination_data(url) do
    token = List.first(Regex.run(~r/(?<=_token=)([^&;]*)/, url))
    nonce = List.first(Regex.run(~r/(?<=_nonce=)([^&;]*)/, url))
    [nonce, token]
  end

  defp create_transactions([head | tail], state) do
    head = flatten(head)
    {:ok, donation} = Donation.create_donation(state.tenant_name, head)
    case Organization.update_or_create_slug(state.tenant_name, slug_attrs(head)) do
      {:ok, %Slug{} = slug} ->
        Logger.info("created slug: #{inspect(slug)}")
      {:error, _} ->
    end
    new_state = %{state | last_transaction_datetime: head["created_at"]}
    organization = Organization.get_organization_by_tenant_name(state.tenant_name)

    create_receipt(donation, donation.page_slug, state, organization)
    create_transactions(tail, new_state)
  end

  defp create_transactions([], state) do
    {:ok, state}
  end

  defp create_receipt(donation, nil, state, organization) do
  end

  defp create_receipt(donation, slug, state, organization) do
    case Organization.find_campaign_by_slug(slug, state.tenant_name) do
      %Campaign{} = campaign -> 
        receipt_params = %{
          charitable_registration_number: organization.charitable_number,
          receipt_number: generate_receipt_number_string(campaign),
          payment_date: donation.nationbuilder_created_at,
          payment_amount: donation.amount_in_cents,
          first_name: donation.first_name,
          last_name: donation.last_name,
          address_1: donation.address1, 
          address_2: donation.address2, 
          postal_code: donation.zip,
          country: donation.country_code,
          province: donation.state,
          city: donation.city,
          advantage_value: Kernel.trunc(donation.amount_in_cents * ((100 - campaign.amount_eligable_for_receipt) / 100)),
          amount_eligable_for_tax_purposes: Kernel.trunc(donation.amount_in_cents * (campaign.amount_eligable_for_receipt / 100)),
          donation_id: donation.id
        }

        {:ok, file_id} = Api.Receipt.generate_receipt(receipt_params, campaign.receipt_template, organization)

        new_receipt_params = receipt_params
        |> Map.put(:file_id, file_id)

        {:ok, created_receipt} = Api.Donation.Receipt.create_receipt_and_update_stack(new_receipt_params, campaign.receipt_template.receipt_stack.id, state.tenant_name)
    end
  end

  defp generate_receipt_number_string(campaign) do
    receipt_stack = campaign.receipt_template.receipt_stack
    "#{receipt_stack.prefix}#{receipt_stack.current_number + 1}#{receipt_stack.suffix}"
  end

  defp flatten(attrs) do
    donation = %{
      email: attrs["donor"]["email"],
      first_name: attrs["donor"]["first_name"],
      last_name: attrs["donor"]["last_name"],
      amount_in_cents: attrs["amount_in_cents"],
      address1: attrs["donor"]["primary_address"]["address1"],
      address2: attrs["donor"]["primary_address"]["address2"],
      city: attrs["donor"]["primary_address"]["city"],
      state: attrs["donor"]["primary_address"]["state"],
      country_code: attrs["donor"]["primary_address"]["country_code"],
      zip: attrs["donor"]["primary_address"]["zip"],
      nationbuilder_created_at: attrs["created_at"],
      nationbuilder_id: Integer.to_string(attrs["id"]),
      payment_type: attrs["payment_type_name"],
      page_slug: attrs["page_slug"],
      tracking_code_slug: attrs["tracking_code_slug"],
      recurring_donation: false
    }
  end

  defp slug_attrs(attrs) do
    slug = %{
      name: attrs.page_slug
    }
  end
end
