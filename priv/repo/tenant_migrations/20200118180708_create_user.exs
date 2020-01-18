defmodule Api.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:fname, :string)
      add(:lname, :string)
      add(:email, :string)
      add(:password_hash, :string)
      timestamps()
    end
  end
end
