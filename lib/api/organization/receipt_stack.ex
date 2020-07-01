defmodule Api.Organization.ReceiptStack do
  use Ecto.Schema
  alias Api.Organization.ReceiptStack
  alias Api.Organization.ReceiptTemplate

  import Ecto.Changeset

  schema "receipt_stacks" do
    field :prefix, :string
    field :starting_number, :integer
    field :current_number, :integer
    field :suffix, :string
    belongs_to :receipt_template, ReceiptTemplate
    timestamps()
  end

  def changeset(%ReceiptStack{} = model, attrs) do
    model
    |> cast(attrs, [:prefix, :starting_number, :current_number, :suffix, :receipt_template_id])
    |> validate_required([:starting_number, :receipt_template_id])
  end
end
