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
    plug :accepts, ["json", "json-api"]
    plug ApiWeb.APIAuthPlug, otp_app: :api
  end

  pipeline :api_protected do
    plug :accepts, ["json-api"]
    plug JaSerializer.ContentTypeNegotiation 
    plug JaSerializer.Deserializer
    plug Pow.Plug.RequireAuthenticated, error_handler: ApiWeb.APIAuthErrorHandler
  end


  scope "/" do
    pipe_through(:browser)

    get "/auth", ApiWeb.AuthController, :index
    get "/auth/callback", ApiWeb.AuthController, :callback
    live_dashboard("/dashboard")
  end

  scope "/api/v1", ApiWeb.API.V1, as: :api_v1 do
    pipe_through :api

    # resources "/registration", RegistrationController, singleton: true, only: [:create]
    post "/registrations", RegistrationController, :create
    resources "/session", SessionController, singleton: true, only: [:create, :delete]
    post "/session/renew", SessionController, :renew
  end

  scope "/api/v1", ApiWeb.API.V1, as: :api_v1 do
    pipe_through [:api, :api_protected]

    get "/users/me", UserController, :current_user
    resources "/signatures",SignatureController, except: [:new, :edit]
    resources "/receipt-templates", ReceiptTemplateController, except: [:new, :edit]
    resources "/receipt-stacks", ReceiptStackController, except: [:new, :edit]
    resources "/signatures", SignatureController, except: [:new, :edit]
    resources "/logos", LogoController, except: [:new, :edit]
    resources "/users", UserController, except: [:new, :edit]
    resources "/campaigns", CampaignController, except: [:new, :edit]
    resources "/organizations", OrganizationController, except: [:new, :edit]
    resources "/donations", DonationController, except: [:new, :edit]
    resources "/receipts", ReceiptController, except: [:new, :edit]
    resources "/slugs", SlugController, except: [:new, :edit]

    get "/users/:user_id/organization", OrganizationController, :organization_for_user
    get "/receipt-templates/:receipt_template_id/campaigns", CampaignController, :campaigns_for_receipt
    get "/receipt-templates/:receipt_template_id/receipt-stack", ReceiptStackController, :stack_for_receipt

    # Your protected API endpoints here
  end

  # Other scopes may use custom stacks.
  # scope "/api", ApiWeb do
  #   pipe_through :api
  # end
end
