defmodule Api.Repo.Migrations.AddContactInfoToOrganization do
  use Ecto.Migration

  def change do
    alter table(:organizations) do
      add :phone, :string
      add :email, :string 
      add :website, :string
    end
  end
end
