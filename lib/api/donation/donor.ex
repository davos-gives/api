defmodule Api.Donation.Donor do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias Ecto.Multi

  alias Api.Repo
  alias Api.Donation.Donor

  import Ecto.Query
  import IEx

  schema "donors" do
    field :email, :string
    field :fname, :string
    field :lname, :string

    timestamps()
  end

  def changeset(donor, attrs) do
    donor
    |> cast(attrs, [:fname, :lname, :email])
  end

  def list_donors do
    Donor
    |> order_by(desc: :updated_at)
    |> Repo.all()
  end

  def search_donors(search_term) do
    search_term = String.downcase(search_term)

    Donor
    |> where([a], like(fragment("lower(?)", a.fname), ^"%#{search_term}%"))
    |> or_where([a], like(fragment("lower(?)", a.lname), ^"%#{search_term}%"))
    |> order_by(desc: :updated_at)
    |> Repo.all()
  end

  def find_donors_by_ids(ids) do
    Donor
    |> where([d], d.id in ^ids)
    |> Repo.all()
  end

  def get_donor!(id) do
    Repo.get!(Donor, id)
  end

  def get_donor_by_email!(email), do: Repo.get_by!(Donor, email: email)

  def create_donor(attrs \\ %{}) do
    %Donor{}
    |> Donor.changeset(attrs)
    |> Repo.insert()
  end

  def update_donor(%Donor{} = donor, attrs) do
    donor
    |> Donor.changeset(attrs)
    |> Repo.update()
  end
end
