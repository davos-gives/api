defmodule ApiWeb.API.V1.DonationController do
  use ApiWeb, :controller 

  plug :get_database_prefix

  def index(conn, params) do
    donations = Api.Donation.list_donations_for_organization(params.prefix)
    render(conn, "index.json-api", data: donations)
  end
end