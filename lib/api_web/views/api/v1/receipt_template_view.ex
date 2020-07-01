defmodule ApiWeb.API.V1.ReceiptTemplateView do
  use ApiWeb, :view
  use JaSerializer.PhoenixView

  import IEx

  location("/api/v1/receipt-templates/:id")
  attributes([:logo_url, :name, :title, :description, :signature_url, :signature_footer, :date_format, :font, :published, :inserted_at, :updated_at])
  attributes([:primary_colour, :secondary_colour, :tertiary_colour, :quaterary_colour, :quinary_colour, :template_code])

  has_many :campaigns,
  serializer: ApiWeb.API.V1.CampaignView,
  identifiers: :when_included,
  links: [
    related: "/api/v1/receipt-templates/:id/campaigns"
  ]
end
