defmodule ApiWeb.API.V1.LogoController do
  use ApiWeb, :controller 

  alias Api.Organization
  alias Api.Organization.Logo

  import IEx

  plug :get_database_prefix

  def index(conn, params) do
    logos = Api.Organization.list_logos_for_organization(params.prefix)
    render(conn, "index.json-api", data: logos)
  end

  def create(conn, %{"data" => data = %{"type" => "logos"}} = params) do
    data = data
    |> JaSerializer.Params.to_attributes

    case Organization.create_logo(data, params.prefix) do
      {:ok, %Logo{} = logo} -> 
        conn
        |> render("show.json-api", data: logo)
      {:error, %Ecto.Changeset{} = changeset} -> 
        conn 
        |> put_status(:unprocessable_entity)
        |> render(ApiWeb.ErrorView, "400.json-api", changeset)
    end
  end
end