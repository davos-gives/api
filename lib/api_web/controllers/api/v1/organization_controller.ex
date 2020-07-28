defmodule ApiWeb.API.V1.OrganizationController do
  use ApiWeb, :controller 

  alias Api.Organization
  
  def show(conn, %{"id" => id}) do
    organization = Organization.get_organization!(id)
    render(conn, "show.json-api", data: organization)
  end

  def organization_for_user(conn, %{"user_id" => user_id}) do
    organization = Organization.get_organization_for_user(user_id)
    render(conn, "show.json-api", data: organization)
  end

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

  def update(conn, %{"id" => id, "data" => data = %{"type" => "organizations", "attributes" => _params}}) do
    data = JaSerializer.Params.to_attributes(data)
    organization = Organization.get_organization!(id)

    case Organization.update_organization(organization, data) do
      {:ok, %Organization{} = organization} -> 
        conn
        |> render("show.json-api", data: organization)
      {:error, %Ecto.Changeset{} = changeset} -> 
        conn
        |> put_status(:unprocessable_entity)
        |> render(ApiWeb.ErrorView, "400.json-api", changeset) 
    end
  end
end