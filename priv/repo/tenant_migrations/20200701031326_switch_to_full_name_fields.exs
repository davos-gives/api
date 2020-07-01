defmodule Api.Repo.Migrations.SwitchToFullNameFields do
  use Ecto.Migration

  def change do 
    alter table(:receipts) do
      remove(:fname)
      remove(:lname)
      add(:last_name, :string)
      add(:first_name, :string)
    end
  end
end
