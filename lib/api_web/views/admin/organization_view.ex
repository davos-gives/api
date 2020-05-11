defmodule ApiWeb.Admin.OrganizationView do
  use ApiWeb, :view
  use JaSerializer.PhoenixView

  location("admin/organizations/:id")
  attributes([:name])
end
