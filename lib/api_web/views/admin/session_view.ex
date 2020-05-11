defmodule ApiWeb.Admin.SessionView do
  use ApiWeb, :view

  def render("token.json", user) do
    data = %{id: user.id, email: user.email}

    jwt =
      %{data: data, sub: user.id}
      |> Joken.token()
      |> Joken.with_signer(Joken.hs512(Application.get_env(:api, :jwt_secret)))
      |> Joken.sign()

    %{token: jwt.token}
  end

  def render("json-token.json", user) do
    data = %{id: user.id, email: user.email}

    jwt =
      %{data: data, sub: user.id}
      |> Joken.token()
      |> Joken.with_signer(Joken.hs512(Application.get_env(:api, :jwt_secret)))
      |> Joken.sign()

    %{
      "data" => %{
        "attributes" => %{"token" => jwt.token},
        "links" => %{"self" => "/api/session"},
        "type" => "session"
      },
      "jsonapi" => %{"version" => "1.0"}
    }
  end
end
