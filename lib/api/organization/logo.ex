defmodule Api.Organization.Logo do
  use Ecto.Schema
  alias Api.Organization.Logo

  import Ecto.Changeset

  schema "logos" do
    field :url, :string
  end

  def changeset(%Logo{} = model, attrs) do
    model
    |> cast(attrs, [:url])
    |> validate_required([:url])
  end
end
