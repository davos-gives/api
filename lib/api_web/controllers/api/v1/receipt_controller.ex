defmodule ApiWeb.API.V1.ReceiptController do
  use ApiWeb, :controller 

  plug :get_database_prefix

  def index(conn, params) do
    receipts = Api.Organization.list_receipts_for_organization(params.prefix)
    render(conn, "index.json-api", data: receipts)
  end
end