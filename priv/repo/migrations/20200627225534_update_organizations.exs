defmodule Api.Repo.Migrations.UpdateOrganizations do
  use Ecto.Migration

  def change do
    alter table(:organizations) do
      add :address1, :string 
      add :address2, :string
      add :city, :string
      add :province, :string
      add :country, :string 
      add :postal_code, :string 
      add :charitable_number, :string
    end
  end
end
