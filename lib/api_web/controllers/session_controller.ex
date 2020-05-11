defmodule ApiWeb.SessionController do
  use ApiWeb, :controller

  alias Comeonin.Bcrypt
  alias Api.{User, Donor}

  def create(conn, %{"email" => email, "password" => password}) do
    try do
      donor = Donor.get_donor_by_email!(email)

      if donor.verified do
        if Bcrypt.checkpw(password, donor.password_hash) do
          conn
          |> render("token.json", donor)
        else
          conn
          |> put_status(:unauthorized)
          |> render(DavosCharityApiWeb.ErrorView, "401.json-api", %{
            detail: "Error logging in a user with that email and password"
          })
        end
      else
        conn
        |> put_status(:unauthorized)
        |> render(DavosCharityApiWeb.ErrorView, "401.json-api", %{
          detail:
            "Account has yet to be verified, please check your email for a verification link"
        })
      end
    rescue
      e ->
        Bcrypt.dummy_checkpw()

        conn
        |> put_status(:unauthorized)
        |> render(DavosCharityApiWeb.ErrorView, "401.json-api", %{
          detail: "Error logging in a user with that email and password"
        })
    end
  end

  def create(conn, %{"data" => data = %{"type" => "session", "attributes" => _params}}) do
    data =
      data
      |> JaSerializer.Params.to_attributes()

    try do
      donor = Donor.get_donor_by_email!(data["email"])

      if donor.verified do
        if Bcrypt.checkpw(data["password"], donor.password_hash) do
          conn
          |> render("json-token.json", donor)
        else
          conn
          |> put_status(:unauthorized)
          |> render(DavosCharityApiWeb.ErrorView, "401.json-api", %{
            detail: "Error logging in a user with that email and password"
          })
        end
      else
        conn
        |> put_status(:unauthorized)
        |> render(DavosCharityApiWeb.ErrorView, "401.json-api", %{
          detail:
            "Account has yet to be verified, please check your email for a verification link"
        })
      end
    rescue
      e ->
        Bcrypt.dummy_checkpw()

        conn
        |> put_status(:unauthorized)
        |> render(DavosCharityApiWeb.ErrorView, "401.json-api", %{
          detail: "Error logging in a user with that email and password"
        })
    end
  end
end
