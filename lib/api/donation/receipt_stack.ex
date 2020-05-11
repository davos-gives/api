defmodule Api.Donation.ReceiptStack do
  use Ecto.Schema

  import Ecto.Changeset

  schema "receipt_stacks" do
    field :name, :string
    field :current_receipt_number, :integer
    timestamps()
  end

  def changeset(receipt_stack, attrs) do
    receipt_stack
    |> cast(attrs, [:current_receipt_number, :name])
    |> validate_required([:current_receipt_number])
  end
end
