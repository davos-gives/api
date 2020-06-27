defmodule Api.Nationbuilder.Authorization do

  import IEx

  def get_client do
    client = OAuth2.Client.new([
      strategy: OAuth2.Strategy.AuthCode,
      client_id: "7f63a4ef4e8d0f10b4346a87b19829764362935b6d1a0116a14ee22b1fcc80f8",
      client_secret: "d3b14cbf2e86f341d2de2505751aa7cea3b63d1883141687eb0cd162362bd83b",
      site: "https://davosgives.nationbuilder.com/oauth/token",
      redirect_uri: "http://localhost:4000/oauth2/callback"
    ])

    token = OAuth2.Client.authorize_url!(client)

    IEx.pry()
  end

end