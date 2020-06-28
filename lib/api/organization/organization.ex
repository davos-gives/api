defmodule Api.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  alias Api.Repo

  alias Api.Organization
  alias Api.Organization.Campaign
  alias Api.Organization.User
  alias Api.Organization.Slug
  alias Api.Donation.Receipt
  alias Ecto.Multi

  import Ecto.Query
  import IEx

  schema "organizations" do
    field :name, :string
    field :nationbuilder_id, :string
    field :address1, :string
    field :address2, :string
    field :city, :string 
    field :province, :string
    field :country, :string
    field :postal_code, :string 
    field :charitable_number, :string
    field :tenant_name, :string
    field :nationbuilder_token, :string

    has_many :users, User
  end

  def changeset(%Organization{} = model, attrs, current_user) do
    model
    |> cast(attrs, [:name, :nationbuilder_id, :address1, :address2, :city, :province, :country, :postal_code, :charitable_number])
     |> put_assoc(:users, [current_user])
    |> create_tenant
    |> validate_required([:name, :nationbuilder_id, :tenant_name])
  end

  def changeset(%Organization{} = model, attrs) do
    model
    |> cast(attrs, [:nationbuilder_token])
    |> validate_required([:nationbuilder_token])
  end

  def create_organization(attrs \\ %{}, current_user) do
   %Organization{}
   |> Organization.changeset(attrs, current_user)
   |> Repo.insert
  end

  def update_organization(%Organization{} = organization, attrs) do
    organization 
    |> Organization.changeset(attrs)
    |> Repo.update
  end

  def get_organization(id), do: Repo.get!(Organization, id);

  def list_organizations do
    Organization
    |> Repo.all()
  end

  def list_campaigns_for_organization(prefix) do
    Repo.all(Campaign, prefix: Triplex.to_prefix(prefix))
  end

  def list_receipts_for_organization(prefix) do
    Repo.all(Receipt, prefix: Triplex.to_prefix(prefix))
  end

  def list_slugs_for_organization(prefix) do
    Repo.all(Slug, prefix: Triplex.to_prefix(prefix))
  end  

  defp create_tenant(changeset) do
    name = get_change(changeset, :name)
    |> slugify_name

    put_change(changeset, :tenant_name, name)
  end

  defp slugify_name(name) do
    name
    |> String.downcase 
    |> String.replace(~r/[^a-z0-9\s-]/, "")
    |> String.replace(~r/(\s|-)+/, "-")
  end
end
