defmodule ApiWeb.Admin.UserView do
  use ApiWeb, :view
  use JaSerializer.PhoenixView

  location("/admin/users/:id")
  attributes([:fname, :lname])

  has_one :organization,
    serializer: ApiWeb.Admin.OrganizationView,
    identifiers: :when_included,
    links: [
      related: "/api/admin/users/:id/organization"
    ]
end
