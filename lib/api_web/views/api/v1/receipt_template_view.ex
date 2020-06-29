defmodule ApiWeb.API.V1.ReceiptTemplateView do
  use ApiWeb, :view
  use JaSerializer.PhoenixView

  location("/api/v1/receipts-templates/:id")
  attributes([:logo_url, :name, :title, :description, :signature_url, :signature_footer, :date_format, :font, :published, :inserted_at, :updated_at])
  attributes([:primary_colour, :secondary_colour, :tertiary_colour, :quaterary_colour, :quinary_colour])
end
