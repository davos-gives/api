defmodule ApiWeb.API.V1.CampaignController do
  use ApiWeb, :controller 

  plug :get_database_prefix

  def index(conn, params) do
    campaigns = Api.Organization.list_campaigns_for_organization(params.prefix)
    render(conn, "index.json-api", data: campaigns)
  end
end