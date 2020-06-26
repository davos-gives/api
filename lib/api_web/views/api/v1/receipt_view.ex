defmodule ApiWeb.API.V1.ReceiptView do
  use ApiWeb, :view
  use JaSerializer.PhoenixView

  location("/api/v1/receipts/:id")
  attributes([:charitable_registration_number, :receipt_number, :payment_date, :payment_amount, :fname, :lname, :inserted_at, :updated_at])
  attributes([:address_1, :address_2, :postal_code, :country, :provice, :city, :advantage_value, :amount_eligable_for_tax_purposes])
end
