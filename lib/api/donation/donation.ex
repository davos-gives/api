defmodule Api.Donation do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query, only: [last: 1]
  import IEx

  alias Api.Repo
  alias Api.Donation

  schema "donations" do
    field(:email, :string)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:amount_in_cents, :integer)
    field(:address1, :string)
    field(:address2, :string)
    field(:city, :string)
    field(:state, :string)
    field(:country_code, :string)
    field(:zip, :string)
    field(:nationbuilder_created_at, :string)
    field(:nationbuilder_id, :string)
    field(:payment_type, :string)
    field(:page_slug, :string)
    field(:tracking_code_slug, :string)
    field(:recurring_donation, :boolean)

    timestamps()
  end

  def changeset(donor, attrs) do
    donor
    |> cast(attrs, [
      :email,
      :first_name,
      :last_name,
      :amount_in_cents,
      :address1,
      :address2,
      :city,
      :state,
      :country_code,
      :zip,
      :nationbuilder_created_at,
      :nationbuilder_id,
      :payment_type,
      :page_slug,
      :tracking_code_slug,
      :recurring_donation
    ])
  end

  def create_donation(tenant_name, attrs \\ %{}) do
    ## Clean up donation as it comes through (flatten objects and map to correct names)

    %Donation{}
    |> Donation.changeset(attrs)
    |> Repo.insert(prefix: Triplex.to_prefix(tenant_name))
  end

  def has_existing_transactions_for_organization?(tenant_name) do
    Donation
    |> Repo.all(prefix: Triplex.to_prefix(tenant_name))
    |> Enum.count()
  end

  def most_recent_transaction(tenant_name) do
    Donation
    |> last()
    |> Repo.one(prefix: Triplex.to_prefix(tenant_name))
  end
end
