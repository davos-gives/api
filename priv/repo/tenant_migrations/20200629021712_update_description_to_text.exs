defmodule Api.Repo.Migrations.UpdateDescriptionToText do
  use Ecto.Migration

  def change do
    alter table(:receipt_templates) do
      modify :description, :text
    end
  end
end
