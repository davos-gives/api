defmodule ApiWeb.ReceiptView do
  use ApiWeb, :view

  def cents_to_dollars(cents) do
    (cents / 100) |> Number.Currency.number_to_currency()
  end

  def datetime_to_date(datetime) do
    "#{datetime.day} - #{datetime.month} - #{datetime.year}"
  end
end
