defmodule ApiWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use ApiWeb, :controller
      use ApiWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: ApiWeb

      import Plug.Conn
      import ApiWeb.Gettext
      alias ApiWeb.Router.Helpers, as: Routes

      def authenticate_user(conn, _params) do
        try do
          ["Bearer " <> token] = get_req_header(conn, "authorization")

          verified_token =
            token
            |> Joken.token()
            |> Joken.with_signer(
              Joken.hs512(Application.get_env(:davos_charity_api, :jwt_secret))
            )
            |> Joken.verify()

          %{"sub" => user_id} = verified_token.claims

          IO.puts(user_id)

          user = Management.get_user!(user_id)

          params =
            Map.get(conn, :params)
            |> Map.put(:current_user, user)

          conn
          |> Map.put(:params, params)
        rescue
          _err ->
            conn
            |> put_status(:unauthorized)
            |> render(DavosCharityApiWeb.ErrorView, "401.json-api", %{
              detail: "User must be logged in to view this resource"
            })
            |> halt
        end
      end
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/api_web/templates",
        namespace: ApiWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import ApiWeb.ErrorHelpers
      import ApiWeb.Gettext
      alias ApiWeb.Router.Helpers, as: Routes
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import ApiWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
