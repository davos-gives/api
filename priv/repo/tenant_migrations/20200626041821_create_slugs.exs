defmodule Api.Repo.Migrations.CreateSlugs do
  use Ecto.Migration

  def change do
    create table(:slugs) do
      add(:name, :string)
      timestamps()
    end

    create unique_index("slugs", [:name])
  end
end
