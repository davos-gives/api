defmodule Api.Repo.Migrations.CreateSignatures do
  use Ecto.Migration

  def change do
    create table(:signatures) do
      add(:url, :string)
    end
  end
end
