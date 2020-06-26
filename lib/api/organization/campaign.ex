defmodule Api.Organization.Campaign do
  use Ecto.Schema
  alias Api.Organization.Campaign

  import Ecto.Query
  import Ecto.Changeset

  schema "campaigns" do
    field :name, :string
    field :description, :string 
    field :slug, :string
    field :isActive, :boolean
    field :amountEligableForReceipt, :integer
    timestamps()
  end

  def changeset(%Campaign{} = model, attrs) do
    model
    |> cast(attrs, [:name, :description, :slug, :isActive, :amountEligableForReceipt])
  end
end
