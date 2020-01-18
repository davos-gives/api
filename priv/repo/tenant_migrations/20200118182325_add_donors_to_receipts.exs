defmodule Api.Repo.Migrations.AddDonorsToReceipts do
  use Ecto.Migration

  def change do
    alter table(:receipts) do
      add(:donor_id, references(:donors))
    end
  end
end
