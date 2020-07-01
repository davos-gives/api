defmodule Api.Repo.Migrations.UpdateReceipt do
  use Ecto.Migration

  def change do 
    alter table(:receipts) do
      remove(:receipt_number)
      add(:receipt_number, :string)
    end
  end
end
