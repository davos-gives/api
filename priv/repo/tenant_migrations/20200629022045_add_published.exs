defmodule Api.Repo.Migrations.AddPublished do
  use Ecto.Migration

  def change do
    alter table(:receipt_templates) do
      add :published, :boolean
    end
  end
end
