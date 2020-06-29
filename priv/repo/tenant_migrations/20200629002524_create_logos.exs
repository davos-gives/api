defmodule Api.Repo.Migrations.CreateLogos do
  use Ecto.Migration

  def change do 
    create table(:logos) do
      add(:url, :string)
    end
  end
end
