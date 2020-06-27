defmodule ApiWeb.API.V1.RegistrationController do
  use ApiWeb, :controller

  alias Ecto.Changeset
  alias Plug.Conn
  alias Api.ErrorHelpers

  import IEx

  def create(conn, user_params) do

    conn
    |> Pow.Plug.create_user(user_params)
    |> case do
      {:ok, _user, conn} ->
        json(conn, %{data: %{access_token: conn.private[:api_access_token], renewal_token: conn.private[:api_renewal_token]}})

      {:error, changeset, conn} ->
        errors = Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)

        conn
        |> put_status(500)
        |> json(%{error: %{status: 500, message: "Couldn't create user", errors: errors}})
    end
  end
end