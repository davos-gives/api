defmodule Api.Organization.User do
  use Ecto.Schema
  use Pow.Ecto.Schema
  import Ecto.Query

  alias Comeonin.Bcrypt
  alias Ecto.Multi

  alias Api.Repo
  alias Api.Organization
  alias Api.Organization.User

  import Ecto.Query

  schema "users" do
    field :fname, :string
    field :lname, :string
    belongs_to :organization, Organization

    pow_user_fields()
    timestamps()
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset 
    |> pow_changeset(attrs)
    |> Ecto.Changeset.cast(attrs, [:fname, :lname, :email])
    |> Ecto.Changeset.validate_required([:fname, :email])
  end

  def simple_changeset(user_or_changeset, attrs) do
    user_or_changeset 
    |> Ecto.Changeset.cast(attrs, [:fname, :lname, :email])
    |> Ecto.Changeset.validate_required([:fname, :email])
  end  
end

