defmodule Api.Repo.Migrations.CreateReceipt do
  use Ecto.Migration

  def change do
    create table(:receipts) do
      add(:charitable_registration_number, :string)
      add(:receipt_number, :integer)
      add(:payment_date, :date)
      add(:payment_amount, :integer)
      add(:fname, :string)
      add(:lname, :string)
      add(:address_1, :string)
      add(:address_2, :string)
      add(:postal_code, :string)
      add(:country, :string)
      add(:province, :string)
      add(:city, :string)
      add(:advantage_value, :integer)
      add(:amount_eligable_for_tax_purposes, :integer)
      timestamps()
    end
  end
end
