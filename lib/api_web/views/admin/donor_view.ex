defmodule ApiWeb.Admin.DonorView do
  use ApiWeb, :view
  use JaSerializer.PhoenixView

  location("/api/admin/donors/:id")
  attributes([:fname, :lname, :email, :inserted_at, :updated_at])
end
