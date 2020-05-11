defmodule Api.Repo.Migrations.CreateDonations do
  use Ecto.Migration

  def change do
    create table(:donations) do
      add(:email, :string)
      add(:first_name, :string)
      add(:last_name, :string)
      add(:amount_in_cents, :integer, null: false)
      add(:address1, :string)
      add(:address2, :string)
      add(:city, :string)
      add(:state, :string)
      add(:country_code, :string)
      add(:zip, :string)
      add(:nationbuilder_created_at, :string)
      add(:nationbuilder_id, :string)
      add(:payment_type, :string)
      add(:page_slug, :string)
      add(:tracking_code_slug, :string)
      add(:recurring_donation, :boolean)

      timestamps()
    end
  end
end
