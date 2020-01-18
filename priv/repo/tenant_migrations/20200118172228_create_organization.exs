defmodule Api.Repo.Migrations.CreateOrganization do
  use Ecto.Migration

  def change do
    create table(:organizations) do
      add(:name, :string)
      add(:logo, :string)
      timestamps()
    end
  end
end
