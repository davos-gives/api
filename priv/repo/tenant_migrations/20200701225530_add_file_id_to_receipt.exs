defmodule Api.Repo.Migrations.AddFileIdToReceipt do
  use Ecto.Migration

  def change do  
    alter table(:receipts) do
      add(:file_id, :string)
    end
  end
end
