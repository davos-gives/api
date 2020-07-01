defmodule ApiWeb.Admin.ReceiptView do
  use ApiWeb, :view
  use JaSerializer.PhoenixView

  location("/admin/receipts/:id")
  attributes([:url, :first_name, :last_name, :payment_amount, :inserted_at, :receipt_number])

  def attributes(model, conn) do
    model
    |> Map.put(:created_at, model.inserted_at)
    |> super(conn)
  end
end
