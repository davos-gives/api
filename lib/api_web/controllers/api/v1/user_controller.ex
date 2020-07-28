defmodule ApiWeb.API.V1.UserController do
  use ApiWeb, :controller

  alias Api.Organization.User
  alias Api.Organization

  def current_user(conn, %{}) do    
    conn 
    |> render("show.json-api", data: conn.assigns.current_user)
  end

  def show(conn, %{"id" => id}) do
    donor = Api.Organization.get_user_with_organization!(id)
    render(conn, "show.json-api", data: donor, opts: [include: "organization"])
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "users", "attributes" => _params}}) do
    data = JaSerializer.Params.to_attributes(data)
    user = Organization.get_user!(id)

    case Organization.update_user(user, data) do
      {:ok, %User{} = user} -> 
        conn
        |> render("show.json-api", data: user)
      {:error, %Ecto.Changeset{} = changeset} -> 
        conn
        |> put_status(:unprocessable_entity)
        |> render(ApiWeb.ErrorView, "400.json-api", changeset)
    end
  end
end