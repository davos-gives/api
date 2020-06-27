defmodule ApiWeb.AuthController do
  use ApiWeb, :controller

  import IEx

  def index(conn, _params) do
    #need to pass organization_id in as params so that we can lookup and save this field against the user.
    redirect(conn, external: OAuth2.Client.authorize_url!(client("davosgives", 1)))
  end

  def callback(conn, %{"code" => code} = params) do
    token = OAuth2.Client.get_token!(client("davosgives", 1), code: code)
    IEx.pry()
  end


  defp client(name, organization_id) do
    OAuth2.Client.new([
      strategy: OAuth2.Strategy.AuthCode,
      client_id: "7f63a4ef4e8d0f10b4346a87b19829764362935b6d1a0116a14ee22b1fcc80f8",
      client_secret: "d3b14cbf2e86f341d2de2505751aa7cea3b63d1883141687eb0cd162362bd83b",
      site: "https://davosgives.nationbuilder.com",
      redirect_uri: "http://localhost:4000/auth/callback?organization_id=#{organization_id}"
    ])
  end
end