defmodule Api.Repo.Migrations.AddNameIndexToOrganizations do
  use Ecto.Migration

  def change do
    create unique_index(:organizations, [:name])
  end
end
