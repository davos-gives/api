defmodule Api.Repo.Migrations.CreateReceiptStacks do
  use Ecto.Migration

  def change do
    create table(:receipt_stacks) do
      add(:name, :string)
      add(:current_receipt_number, :integer)
      timestamps()
    end
  end
end
