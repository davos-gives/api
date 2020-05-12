defmodule ApiWeb.ReceiptController do
  use ApiWeb, :controller

  require IEx

  def show(conn, %{"receipt_id" => receipt_id}) do
    receipt = Receipt.get_receipt!(receipt_id)
    template = Fundraising.get_receipt_template!(1)
    render(conn, "show.html", receipt: receipt, template: template)
  end
end
