defmodule ApiWeb.API.V1.CampaignView do
  use ApiWeb, :view
  use JaSerializer.PhoenixView

  location("/api/v1/campaigns/:id")
  attributes([:name, :description, :slug, :is_active, :amount_eligable_for_receipt, :inserted_at, :updated_at])
end
