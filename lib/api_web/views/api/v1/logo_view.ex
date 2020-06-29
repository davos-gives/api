defmodule ApiWeb.API.V1.LogoView do
  use ApiWeb, :view
  use JaSerializer.PhoenixView

  location("/api/v1/signatures/:id")
  attributes([:url])
end
