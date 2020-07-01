defmodule Api.Repo.Migrations.CreateReceiptStack do
  use Ecto.Migration

  def change do
    alter table(:receipt_stacks) do
      remove(:name)
      remove(:current_receipt_number)
      add(:prefix, :string)
      add(:starting_number, :integer)
      add(:current_number, :integer)
      add(:suffix, :string)
      add :receipt_template_id, references(:receipt_templates)
    end
  end
end
