defmodule ApiWeb.API.V1.OrganizationView do
  use ApiWeb, :view
  use JaSerializer.PhoenixView

  location("/api/v1/organizations/:id")
  attributes([:name, :nationbuilder_id, :address1, :address2, :city, :province, :country, :postal_code, :charitable_number])
end
