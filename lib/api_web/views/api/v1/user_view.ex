defmodule ApiWeb.API.V1.UserView do
  use ApiWeb, :view
  use JaSerializer.PhoenixView

  location("/api/v1/users/:id")
  attributes([:fname, :lname])

  # has_one :organization,
  #   serializer: ApiWeb.Admin.OrganizationView,
  #   identifiers: :when_included,
  #   links: [
  #     related: "/api/admin/users/:id/organization"
  #   ]
end
