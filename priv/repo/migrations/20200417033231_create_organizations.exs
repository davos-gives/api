defmodule Api.Repo.Migrations.CreateOrganizations do
  use Ecto.Migration

  def change do
    create table(:organizations) do
      add :name, :string
      add :nationbuilder_id, :string
      add :tenant_name, :string
    end
  end
end
