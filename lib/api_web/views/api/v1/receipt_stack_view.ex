defmodule ApiWeb.API.V1.ReceiptStackView do
  use ApiWeb, :view
  use JaSerializer.PhoenixView

  location("/api/v1/receipt-stacks/:id")
  attributes([:prefix, :starting_number, :current_number, :suffix])
end
