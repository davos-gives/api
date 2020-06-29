defmodule Api.Organization.ReceiptTemplate do
  use Ecto.Schema

  import Ecto.Changeset

  alias Api.Organization.ReceiptTemplate

  schema "receipt_templates" do
    field :logo_url, :string
    field :name, :string
    field :title, :string
    field :description, :string
    field :signature_url, :string
    field :signature_footer, :string
    field :date_format, :string

    field :font, :string
    field :primary_colour, :string
    field :secondary_colour, :string
    field :tertiary_colour, :string
    field :quaternary_colour, :string
    field :quinary_colour, :string
    field :published, :boolean, default: true
    timestamps()
  end

  def changeset(%ReceiptTemplate{} = model, attrs) do
    model
    |> cast(attrs, [:logo_url, :name, :title, :description, :signature_url, :signature_footer, :date_format, :font, :primary_colour, :secondary_colour, :tertiary_colour, :quaternary_colour, :quinary_colour])
    |> validate_required([:logo_url, :name, :title, :description, :signature_url, :signature_footer, :date_format, :font, :primary_colour, :secondary_colour, :tertiary_colour, :quaternary_colour, :quinary_colour])
  end
end
