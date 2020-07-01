defmodule Api.Donation.Receipt do
  use Ecto.Schema

  import Ecto.Query
  import Ecto.Changeset
  alias Ecto.Multi

  alias Api.Repo

  alias Api.Donation.Receipt
  alias Api.Organization.ReceiptStack
  alias Api.Donation

  import IEx

  schema "receipts" do
    field :charitable_registration_number, :string
    field :receipt_number, :string
    field :payment_date, :string
    field :payment_amount, :integer
    field :first_name, :string
    field :last_name, :string
    field :address_1, :string
    field :address_2, :string
    field :postal_code, :string
    field :country, :string
    field :province, :string
    field :city, :string
    field :advantage_value, :integer
    field :amount_eligable_for_tax_purposes, :integer
    belongs_to :donation, Donation

    timestamps()
  end

  def changeset(receipt, attrs) do
    receipt
    |> cast(attrs, [
      :charitable_registration_number,
      :payment_amount,
      :receipt_number,
      :payment_date,
      :first_name,
      :last_name,
      :address_1,
      :address_2,
      :postal_code,
      :country,
      :province,
      :city,
      :advantage_value,
      :amount_eligable_for_tax_purposes,
      :donation_id
    ])
    |> validate_required([
      :charitable_registration_number,
      :receipt_number,
      :first_name,
      :last_name,
      :address_1,
      :postal_code,
      :country,
      :province,
      :city,
      :advantage_value,
      :amount_eligable_for_tax_purposes,
      :payment_amount,
      :donation_id
    ])
  end

  def create_receipt_and_update_stack(attrs \\ %{}) do
    Multi.new()
    |> create_receipt!(attrs)
    |> update_receipt_stack(attrs)
    |> Repo.transaction()
  end

  defp create_receipt!(multi, attrs \\ %{}) do
    Multi.run(multi, :created_receipt, fn repo, %{} ->
      receipt_number = Receipt.get_receipt_stack!(1).current_receipt_number + 1

      attrs =
        attrs
        |> Map.put("receipt_number", receipt_number)

      new_receipt =
        %Receipt{}
        |> Receipt.changeset(attrs)
        |> Repo.insert(Triplex.to_prefix("testing_tenant"))
    end)
  end

  def create_receipt_stack(attrs \\ %{}) do
    %ReceiptStack{}
    |> ReceiptStack.changeset(attrs)
    |> Repo.insert(prefix: Triplex.to_prefix("testing_tenant"))
  end

  def get_receipt_stack!(id) do
    ReceiptStack
    |> Repo.get!(id, Triplex.to_prefix("testing_tenant"))
  end

  def get_receipt!(id) do
    Receipt
    |> Repo.get!(id, Triplex.to_prefix("testing_tenant"))
  end

  def list_receipts(), do: Repo.all(Receipt)

  def search_receipts(search_term) do
    search_term = String.downcase(search_term)

    Receipt
    |> where([a], like(fragment("lower(?)", a.first_name), ^"%#{search_term}%"))
    |> or_where([a], like(fragment("lower(?)", a.last_name), ^"%#{search_term}%"))
    |> or_where([a], a.receipt_number == ^search_term)
    |> or_where([a], a.payment_amount == ^search_term * 100)
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  defp update_receipt_stack(multi, attrs \\ %{}) do
    Multi.run(multi, :updated_stack, fn repo, %{created_receipt: created_receipt} ->
      attrs = %{current_receipt_number: created_receipt.receipt_number}

      Receipt.get_receipt_stack!(1)
      |> ReceiptStack.changeset(attrs)
      |> Repo.update(Triplex.to_prefix("testing_tenant"))
    end)
  end
end
