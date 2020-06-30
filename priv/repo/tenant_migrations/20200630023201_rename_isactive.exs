defmodule Api.Repo.Migrations.RenameIsactive do
  use Ecto.Migration

  def change do
    alter table("campaigns") do
      remove :isActive
      add :is_active, :string
    end
  end
end
