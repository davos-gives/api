defmodule ApiWeb.API.V1.OrganizationController do
  use ApiWeb, :controller 

  alias Api.Organization
  
  import IEx

  def create(conn, %{"data" => data = %{"type" => "organizations", "attributes" => _params}}) do
    data = data
    |> JaSerializer.Params.to_attributes
  
    case Organization.create_organization(data, conn.assigns.current_user) do
      {:ok, %Organization{} = organization} ->
        
        Triplex.create(organization.tenant_name)
        conn
        |> put_status(:created)
        |> render("show.json-api", data: organization)
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:bad_request)
        |> render(ApiWeb.ErrorView, "400.json-api", changeset)
    end
  end
end