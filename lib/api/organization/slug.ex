defmodule Api.Organization.Slug do
  use Ecto.Schema
  alias Api.Organization.Slug

  import Ecto.Changeset

  schema "slugs" do
    field :name, :string
    timestamps()
  end

  def changeset(%Slug{} = model, attrs) do
    model
    |> cast(attrs, [:name])
  end
end
