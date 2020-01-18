defmodule Api.Repo.Migrations.CreateReceiptStack do
  use Ecto.Migration

  def change do
    create table(:receipt_stacks) do
      add(:current_receipt_number, :integer)
      add(:name, :string)
      timestamps()
    end
  end
end
