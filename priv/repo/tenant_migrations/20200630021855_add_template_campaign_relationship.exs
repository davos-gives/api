defmodule Api.Repo.Migrations.AddTemplateCampaignRelationship do
  use Ecto.Migration

  def change do
    alter table(:campaigns) do
      add :receipt_template_id, references(:receipt_templates)
    end
  end
end
