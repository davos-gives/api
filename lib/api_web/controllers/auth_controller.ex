defmodule ApiWeb.AuthController do
  use ApiWeb, :controller

  alias Api.Organization

  import IEx

  def index(conn, %{"organization_id" => organization_id} = params) do
    organization = Organization.get_organization(organization_id)
    redirect(conn, external: OAuth2.Client.authorize_url!(client(organization.nationbuilder_id, organization_id)))
  end

  def callback(conn, %{"code" => code, "organization_id" => organization_id} = params) do
    organization = Organization.get_organization(organization_id)
    token = OAuth2.Client.get_token!(client(organization.nationbuilder_id, organization_id), code: code)

    new_token = Jason.decode!(token.token.access_token)

    Organization.update_organization(organization, %{nationbuilder_token: new_token["access_token"]})
    redirect(conn, external: "http://localhost:4200")
  end

  defp client(name, organization_id) do
    OAuth2.Client.new([
      strategy: OAuth2.Strategy.AuthCode,
      client_id: "7f63a4ef4e8d0f10b4346a87b19829764362935b6d1a0116a14ee22b1fcc80f8",
      client_secret: "d3b14cbf2e86f341d2de2505751aa7cea3b63d1883141687eb0cd162362bd83b",
      site: "https://#{name}.nationbuilder.com",
      redirect_uri: "http://localhost:4000/auth/callback?organization_id=#{organization_id}"
    ])
  end
end