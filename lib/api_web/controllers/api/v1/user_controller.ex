defmodule ApiWeb.API.V1.UserController do
  use ApiWeb, :controller

  import IEx

  def current_user(conn, %{}) do
    conn 
    |> render("show.json-api", data: conn.assigns.current_user)
  end
end