defmodule ApiWeb.Router do
  use ApiWeb, :router
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug ApiWeb.APIAuthPlug, otp_app: :api
  end

  pipeline :api_protected do
    plug Pow.Plug.RequireAuthenticated, error_handler: ApiWeb.APIAuthErrorHandler
  end

  scope "/api/v1", ApiWeb.API.V1, as: :api_v1 do
    pipe_through :api

    resources "/registration", RegistrationController, singleton: true, only: [:create]
    resources "/session", SessionController, singleton: true, only: [:create, :delete]
    post "/session/renew", SessionController, :renew
  end

  scope "/api/v1", ApiWeb.API.V1, as: :api_v1 do
    pipe_through [:api, :api_protected]

    # Your protected API endpoints here
    # install JA Serializer and add it here.
  end

  # (if Mix.env) == :dev do
  #   scope "/" do
  #     pipe_through(:browser)
  #     live_dashboard("/dashboard")
  #   end
  # end

  # Other scopes may use custom stacks.
  # scope "/api", ApiWeb do
  #   pipe_through :api
  # end
end
