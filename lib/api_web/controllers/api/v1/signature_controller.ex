defmodule ApiWeb.API.V1.SignatureController do
  use ApiWeb, :controller 

  alias Api.Organization
  alias Api.Organization.Signature

  plug :get_database_prefix

  def index(conn, params) do
    signatures = Api.Organization.list_signatures_for_organization(params.prefix)
    render(conn, "index.json-api", data: signatures)
  end

  def create(conn, %{"data" => data = %{"type" => "signatures"}} = params) do
    data = data
    |> JaSerializer.Params.to_attributes

    case Organization.create_signature(data, params.prefix) do
      {:ok, %Signature{} = signature} -> 
        conn
        |> render("show.json-api", data: signature)
      {:error, %Ecto.Changeset{} = changeset} -> 
        conn 
        |> put_status(:unprocessable_entity)
        |> render(ApiWeb.ErrorView, "400.json-api", changeset)
    end
  end
end