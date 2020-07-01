defmodule ApiWeb.API.V1.ReceiptController do
  use ApiWeb, :controller 

  plug :get_database_prefix

  import IEx

  def index(conn, params) do
    receipts = Api.Organization.list_receipts_for_organization(params.prefix)
    render(conn, "index.json-api", data: receipts)
  end

  def download_receipt(conn, %{"receipt_id" => receipt_id} = params) do
    receipt = Api.Organization.get_receipt!(receipt_id, params.prefix)
    {:ok, file} = File.read("demo-receipt.pdf")
    response = Base.encode64(file)

    new_receipt = receipt 
    |> Map.put(:receipt_binary, response)
    render(conn, "show.json-api", data: new_receipt)
  end
end