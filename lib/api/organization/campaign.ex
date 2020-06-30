defmodule Api.Organization.Campaign do
  use Ecto.Schema
  alias Api.Organization.Campaign

  import Ecto.Query
  import Ecto.Changeset

  schema "campaigns" do
    field :name, :string
    field :description, :string 
    field :slug, :string
    field :is_active, :boolean, default: true
    field :amount_eligable_for_receipt, :integer
    
    belongs_to :receipt_template, Api.Organization.ReceiptTemplate
    timestamps()
  end

  def changeset(%Campaign{} = model, attrs) do
    model
    |> cast(attrs, [:name, :description, :slug, :is_active, :amount_eligable_for_receipt, :receipt_template_id])
  end
end
