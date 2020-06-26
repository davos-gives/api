defmodule Api.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  alias Api.Repo

  alias Api.Organization
  alias Api.Organization.Campaign
  alias Api.Organization.Slug
  alias Api.Donation.Receipt

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

  def list_campaigns_for_organization(prefix) do
    Repo.all(Campaign, prefix: Triplex.to_prefix(prefix))
  end

  def list_receipts_for_organization(prefix) do
    Repo.all(Receipt, prefix: Triplex.to_prefix(prefix))
  end

  def list_slugs_for_organization(prefix) do
    Repo.all(Slug, prefix: Triplex.to_prefix(prefix))
  end  
end
