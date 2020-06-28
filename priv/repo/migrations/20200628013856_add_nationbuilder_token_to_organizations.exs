defmodule Api.Repo.Migrations.AddNationbuilderTokenToOrganizations do
  use Ecto.Migration

  def change do
    alter table(:organizations) do
      add :nationbuilder_token, :string 
    end
  end
end
