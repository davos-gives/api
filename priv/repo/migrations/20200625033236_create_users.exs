defmodule Api.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :fname, :string
      add :lname, :string
      add :password_hash, :string
      add :organization_id, references(:organizations)
      
      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
