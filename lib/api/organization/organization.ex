defmodule Api.Organization do
  use Ecto.Schema
  import Ecto.Changeset
  alias Api.Repo

  alias Api.Organization
  alias Api.Organization.User

  import Ecto.Query

  schema "organizations" do
    field :name, :string
    field :logo, :string

    timestamps()
  end

  def changeset(%Organization{} = model, attrs) do
    model
    |> cast(attrs, [:name, :logo])
    |> validate_required([:name, :logo])
  end

  def get_organization!(id),
    do: Repo.get!(Organization, id, prefix: Triplex.to_prefix("testing_tenant"))

  def create_organization(attrs \\ %{}) do
    %Organization{}
    |> Organization.changeset(attrs)
    |> Repo.insert(prefix: Triplex.to_prefix("testing_tenant"))
  end
end
