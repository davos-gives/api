defmodule Api.Repo.Migrations.CreateReceipts do
  use Ecto.Migration

  def change do
    create table(:receipts) do
      add(:charitable_registration_number, :string)
      add(:payment_amount, :integer)
      add(:receipt_number, :integer)
      add(:payment_date, :string)
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
      add(:donation_id, references(:donations))
      timestamps()
    end
  end
end
