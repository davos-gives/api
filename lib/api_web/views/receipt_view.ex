defmodule ApiWeb.ReceiptView do
  use ApiWeb, :view
  
  def cents_to_dollars(cents) do
    (cents / 100) |> Number.Currency.number_to_currency()
  end

  def datetime_to_date(datetime) do
    "#{datetime.day} - #{datetime.month} - #{datetime.year}"
  end

  def format_date(date, "DD / MM / YY") do
    {:ok, date, _} = DateTime.from_iso8601(date)
    "#{date.day} / #{date.month} / #{date.year}"  
  end

  def format_date(date, "MM / DD / YY") do
    {:ok, date, _} = DateTime.from_iso8601(date)
    "#{date.month} / #{date.day} / #{date.year}"  
  end

  def format_date(date, "DD - MM - YY") do
    {:ok, date, _} = DateTime.from_iso8601(date)
    "#{date.day} - #{date.month} - #{date.year}"  
  end

  def format_date(date, "MM - DD - YY") do
    {:ok, date, _} = DateTime.from_iso8601(date)
    "#{date.month} - #{date.day} - #{date.year}"  
  end
end
