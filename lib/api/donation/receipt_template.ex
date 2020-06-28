defmodule Api.Donation.ReceiptTemplate do
  use Ecto.Schema

  import Ecto.Query
  import Ecto.Changeset
  alias Ecto.Multi

  alias Api.Repo

  alias Api.Donation.Receipt
  alias Api.Donation.ReceiptStack
  alias Api.Donation

  import IEx

  schema "receipt_templates" do
    field :logoUrl, :string
    field :name, :string
    field :title, :string
    field :description, :string
    field :signatureUrl, :string
    field :signature_footer, :string
    fied :date_format, :string



    field :font, :string
    field :primary_colour, :string
    field :secondary_colour, :string
    field :tertiary_colour, :string
    field :quaternary_colour, :string
    field :quinary_colour, :string
    field :stored_template, :string 
    timestamps()
  end


end
