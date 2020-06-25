defmodule ApiWeb.API.V1.SessionController do
  use ApiWeb, :controller

  alias ApiWeb.APIAuthPlug
  alias Plug.Conn

  require IEx

  def create(conn, %{"password" => password, "username" => email}) do

    user_params = %{"email" => email, "password" => password}

    # IEx.pry()

    conn
    |> Pow.Plug.authenticate_user(user_params)
    |> case do
      {:ok, conn} ->
        json(conn, %{access_token: conn.private[:api_access_token], token_type: "bearer"})

      {:error, conn} ->
        conn
        |> put_status(400)
        |> json(%{error: "invalid_grant"})
    end
  end

  def renew(conn, _params) do
    config = Pow.Plug.fetch_config(conn)

    conn
    |> APIAuthPlug.renew(config)
    |> case do
      {conn, nil} ->
        conn
        |> put_status(401)
        |> json(%{error: %{status: 401, message: "Invalid token"}})

      {conn, _user} ->
        json(conn, %{data: %{access_token: conn.private[:api_access_token], renewal_token: conn.private[:api_renewal_token]}})
    end
  end

  @spec delete(Conn.t(), map()) :: Conn.t()
  def delete(conn, _params) do
    conn
    |> Pow.Plug.delete()
    |> json(%{data: %{}})
  end
end