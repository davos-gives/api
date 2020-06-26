defmodule ApiWeb.API.V1.SlugView do
  use ApiWeb, :view
  use JaSerializer.PhoenixView

  location("/api/v1/slugs/:id")
  attributes([:name, :inserted_at, :updated_at])
end
