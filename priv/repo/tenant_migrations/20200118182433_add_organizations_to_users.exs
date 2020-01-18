defmodule Api.Repo.Migrations.AddOrganizationsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:organization_id, references(:organizations))
    end
  end
end
