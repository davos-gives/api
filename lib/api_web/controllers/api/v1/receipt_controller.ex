defmodule ApiWeb.API.V1.ReceiptController do
  use ApiWeb, :controller 

  plug :get_database_prefix

  import IEx

  alias Api.Organization

  def index(conn, params) do
    receipts = Api.Organization.list_receipts_for_organization(params.prefix)
    render(conn, "index.json-api", data: receipts)
  end

  def download_receipt(conn, %{"receipt_id" => receipt_id} = params) do
    receipt = Api.Organization.get_receipt!(receipt_id, params.prefix)
    file = Api.FileStore.get_file(Path.absname("receipts"), receipt.file_id)
    response = Base.encode64(file)

    new_receipt = receipt 
    |> Map.put(:receipt_binary, response)
    render(conn, "show.json-api", data: new_receipt)
  end

  def resend(conn, %{"receipt_id" => receipt_id} = params) do
    receipt = Api.Organization.get_receipt!(receipt_id, params.prefix)
    file = Api.FileStore.get_file(Path.absname("receipts"), receipt.file_id)
    organization = Organization.get_organization!(conn.assigns.current_user.organization_id)
    
    Api.Email.create_receipt_email(file, receipt, %{description: "Here is the receipt that you requested from #{organization.name}"}, organization)
    |> Api.Mailer.deliver_later()

    conn
    |> put_status(200)
    |> render("show.json-api", data: receipt)
  end
end