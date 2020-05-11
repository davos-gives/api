defmodule Api.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  alias Api.Repo

  alias Api.Organization

  import Ecto.Query

  schema "organizations" do
    field :name, :string
    field :nationbuilder_id, :string
    field :tenant_name, :string
  end

  def changeset(%Organization{} = model, attrs) do
    model
    |> cast(attrs, [:name, :nationbuilder_id, :tenant_name])
    |> validate_required([:name, :nationbuilder_id, :tenant_name])
  end

  def list_organizations do
    Organization
    |> Repo.all()
  end
end
