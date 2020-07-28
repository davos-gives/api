defmodule Api.Donation.Receipt do
  use Ecto.Schema

  import Ecto.Query
  import Ecto.Changeset
  alias Ecto.Multi

  alias Api.Repo

  alias Api.Donation.Receipt
  alias Api.Organization.ReceiptStack
  alias Api.Donation

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
    field :file_id, :string
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
      :donation_id,
      :file_id
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

  def create_receipt_and_update_stack(attrs \\ %{}, stack_id, tenant) do
    Multi.new()
    |> create_receipt!(attrs, tenant)
    |> update_receipt_stack(attrs, stack_id, tenant)
    |> Repo.transaction()
  end

  defp create_receipt!(multi, attrs \\ %{}, tenant) do
    Multi.run(multi, :created_receipt, fn repo, %{} ->
      %Receipt{}
      |> Receipt.changeset(attrs)
      |> repo.insert(prefix: Triplex.to_prefix(tenant))
    end)
  end

  def get_receipt_stack!(id, tenant) do
    ReceiptStack
    |> Repo.get!(id, prefix: Triplex.to_prefix(tenant))
  end

  def get_receipt!(id, tenant) do
    Receipt
    |> Repo.get!(id, prefix: Triplex.to_prefix(tenant))
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

  defp update_receipt_stack(multi, attrs \\ %{}, stack_id, tenant) do
    Multi.run(multi, :updated_stack, fn repo, %{created_receipt: created_receipt} ->

      number = Receipt.get_receipt_stack!(stack_id, tenant)
      attrs = %{current_number: number.current_number + 1}

      Receipt.get_receipt_stack!(stack_id, tenant)
      |> ReceiptStack.changeset(attrs)
      |> repo.update(prefix: Triplex.to_prefix(tenant))
    end)
  end
end
