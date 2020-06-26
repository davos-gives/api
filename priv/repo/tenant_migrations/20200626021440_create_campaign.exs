defmodule Api.Repo.Migrations.CreateCampaign do
  use Ecto.Migration

  def change do
    create table(:campaigns) do
      add(:name, :string)
      add(:description, :string)
      add(:slug, :string)
      add(:isActive, :boolean)
      add(:amountEligableForReceipt, :integer)
      timestamps()
    end
  end
end
