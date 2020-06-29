defmodule ApiWeb.API.V1.SignatureView do
  use ApiWeb, :view
  use JaSerializer.PhoenixView

  location("/api/v1/signatures/:id")
  attributes([:url])
end
