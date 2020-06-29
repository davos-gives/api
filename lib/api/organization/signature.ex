defmodule Api.Organization.Signature do
  use Ecto.Schema
  alias Api.Organization.Signature

  import Ecto.Changeset

  schema "signatures" do
    field :url, :string
  end

  def changeset(%Signature{} = model, attrs) do
    model
    |> cast(attrs, [:url])
    |> validate_required([:url])
  end
end
