defmodule Api.Repo.Migrations.AddTimestampsAndOrganizationToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :organization_id, references(:organizations)

      timestamps()
    end
  end
end
