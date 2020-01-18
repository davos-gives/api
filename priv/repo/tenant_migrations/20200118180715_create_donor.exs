defmodule Api.Repo.Migrations.CreateDonor do
  use Ecto.Migration

  def change do
    create table(:donors) do
      add(:fname, :string)
      add(:lname, :string)
      add(:email, :string)
    end
  end
end
