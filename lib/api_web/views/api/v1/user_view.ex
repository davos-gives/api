defmodule ApiWeb.API.V1.UserView do
  use ApiWeb, :view
  use JaSerializer.PhoenixView

  location("/api/v1/users/:id")
  attributes([:fname, :lname, :email])

  has_one :organization,
    serializer: ApiWeb.API.V1.OrganizationView,
    identifiers: :when_included,
    links: [
      related: "/api/v1/users/:id/organization"
    ]
end
