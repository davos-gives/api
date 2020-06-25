defmodule Api.Organization.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  import Ecto.Changeset
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
end
