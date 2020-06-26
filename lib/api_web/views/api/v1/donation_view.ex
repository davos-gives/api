defmodule ApiWeb.API.V1.DonationView do
  use ApiWeb, :view
  use JaSerializer.PhoenixView

  location("/api/v1/donations/:id")
  attributes([:email, :first_name, :last_name, :amount_in_cents, :address1, :address2, :city, :state, :country_code, :zip])
  attributes([:nationbuilder_created_at, :nationbuilder_id, :payment_type, :page_slug, :tracking_code_slug, :recurring_donation, :inserted_at, :updated_at])
end
