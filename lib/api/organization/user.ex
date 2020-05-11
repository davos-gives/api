defmodule Api.Organization.User do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias Comeonin.Bcrypt
  alias Ecto.Multi

  alias Api.Repo
  alias Api.Organization
  alias Api.Organization.User

  import Ecto.Query

  schema "users" do
    field :email, :string
    field :fname, :string
    field :lname, :string

    belongs_to :organization, Organization
    timestamps()
  end

  def hash_password(changeset = %{valid?: false}), do: changeset

  def hash_password(changeset) do
    hash = Bcrypt.hashpwsalt(get_field(changeset, :password))
    put_change(changeset, :password_hash, hash)
  end

  def changeset(%User{} = user, attrs = %{reset: _}) do
    user
    |> cast(attrs, [:password, :password_confirmation])
    |> validate_confirmation(:password, message: "confirmation does not match password")
    |> hash_password()
  end

  def changeset(%User{} = user, attrs = %{"password" => _, "password_confirmation" => _}) do
    user
    |> cast(attrs, [:fname, :lname, :email, :password, :password_confirmation])
    |> validate_required([:fname, :lname, :email, :password, :password_confirmation])
    |> validate_confirmation(:password, message: "confirmation does not match password")
    |> validate_format(:email, ~r/@/)
    |> unsafe_validate_unique([:email], DavosCharityApi.Repo)
    |> hash_password()
  end

  def changeset(%User{} = user, attrs = %{"password" => _}) do
    user
    |> cast(attrs, [:fname, :lname, :email, :password, :verified])
    |> validate_required([:fname, :lname, :email, :password])
    |> validate_format(:email, ~r/@/)
    |> unsafe_validate_unique([:email], DavosCharityApi.Repo)
    |> hash_password()
  end
end
