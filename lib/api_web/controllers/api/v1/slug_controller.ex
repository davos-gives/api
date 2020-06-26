defmodule ApiWeb.API.V1.SlugController do
  use ApiWeb, :controller 

  plug :get_database_prefix

  def index(conn, params) do
    slugs = Api.Organization.list_slugs_for_organization(params.prefix)
    render(conn, "index.json-api", data: slugs)
  end
end