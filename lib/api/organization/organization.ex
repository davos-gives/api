defmodule Api.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  alias Api.Repo

  alias Api.Organization
  alias Api.Organization.Campaign
  alias Api.Organization.User
  alias Api.Organization.Slug
  alias Api.Organization.Logo
  alias Api.Organization.Signature
  alias Api.Organization.ReceiptStack
  alias Api.Organization.ReceiptTemplate
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

  def creation_changeset(%Organization{} = model, attrs, current_user) do
    model
    |> cast(attrs, [:name, :nationbuilder_id, :address1, :address2, :city, :province, :country, :postal_code, :charitable_number])
    |> put_assoc(:users, [current_user])
    |> create_tenant
    |> validate_required([:name, :nationbuilder_id, :tenant_name])
  end

  def nationbuilder_changeset(%Organization{} = model, attrs) do
    model
    |> cast(attrs, [:nationbuilder_token])
    |> validate_required([:nationbuilder_token])
  end

  def update_changeset(%Organization{} = model, attrs) do
    model
    |> cast(attrs, [:name, :nationbuilder_id, :address1, :address2, :city, :province, :country, :postal_code, :charitable_number])
    |> validate_required([:name, :nationbuilder_id, :address1, :city, :province, :country, :postal_code, :charitable_number])
  end

  def create_campaign(attrs \\ %{}, prefix) do
    %Campaign{}
    |> Campaign.changeset(attrs)
    |> Repo.insert(prefix: Triplex.to_prefix(prefix))
  end

  def get_receipt!(id, prefix), do: Repo.get!(Receipt, id, prefix: Triplex.to_prefix(prefix));


  def get_receipt_template!(id, prefix), do: Repo.get!(ReceiptTemplate, id, prefix: Triplex.to_prefix(prefix));

  def create_receipt_template(attrs \\ %{}, prefix) do
    %ReceiptTemplate{}
    |> ReceiptTemplate.changeset(attrs)
    |> Repo.insert(prefix: Triplex.to_prefix(prefix))
  end

  def create_logo(attrs \\ %{}, prefix) do
    %Logo{}
    |> Logo.changeset(attrs)
    |> Repo.insert(prefix: Triplex.to_prefix(prefix))
  end

  def create_signature(attrs \\ %{}, prefix) do
    %Signature{}
    |> Signature.changeset(attrs)
    |> Repo.insert(prefix: Triplex.to_prefix(prefix))
  end

  def create_receipt_stack(attrs \\ %{}, prefix) do
    %ReceiptStack{}
    |> ReceiptStack.changeset(attrs)
    |> Repo.insert(prefix: Triplex.to_prefix(prefix))
  end

  def create_organization(attrs \\ %{}, current_user) do
   %Organization{}
   |> Organization.creation_changeset(attrs, current_user)
   |> Repo.insert
  end

  def nationbuilder_update_organization(%Organization{} = organization, attrs) do
    organization 
    |> Organization.nationbuilder_changeset(attrs)
    |> Repo.update
  end

  def update_organization(%Organization{} = organization, attrs) do
    organization 
    |> Organization.update_changeset(attrs)
    |> Repo.update
  end

  def get_organization!(id), do: Repo.get!(Organization, id);

  def get_user_with_organization!(id) do
    user = Repo.get!(User, id)
    user = Repo.preload(user, [:organization])
  end

  def get_organization_for_user(id) do
    user = Organization.get_user!(id) 
    user = Repo.preload(user, [:organization])
    user.organization
  end

  def get_stack_for_receipt_id(id, prefix) do
    stack = Organization.get_receipt_template!(id) 
    stack = Repo.preload(stack, [:receipt_stack], prefix: Triplex.to_prefix(prefix))
    stack.receipt_stack
  end

  def update_or_create_slug(tenant_name, attrs \\ %{}) do
    %Slug{}
    |> Slug.changeset(attrs)
    |> Repo.insert_or_update(prefix: Triplex.to_prefix(tenant_name))
  end

  def list_organizations do
    Organization
    |> Repo.all()
  end

  def get_user!(id), do: Repo.get!(User, id);

  def update_user(%User{} = user, attrs) do
    user
    |> User.simple_changeset(attrs)
    |> Repo.update
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

  def list_logos_for_organization(prefix) do
    Repo.all(Logo, prefix: Triplex.to_prefix(prefix))
  end

  def list_receipt_templates_for_organization(prefix) do
    Repo.all(ReceiptTemplate, prefix: Triplex.to_prefix(prefix))
  end

  def list_signatures_for_organization(prefix) do
    Repo.all(Signature, prefix: Triplex.to_prefix(prefix))
  end

  def list_campaigns_for_receipt(id, prefix) do
    receipt = Organization.get_receipt_template!(id, prefix)
    receipt = Repo.preload(receipt, :campaigns)
    receipt.campaigns
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
