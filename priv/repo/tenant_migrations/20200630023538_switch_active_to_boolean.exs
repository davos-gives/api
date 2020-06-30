defmodule Api.Repo.Migrations.SwitchActiveToBoolean do
  use Ecto.Migration

  def change do
    alter table("campaigns") do
      remove :is_active
      add :is_active, :boolean
    end
  end
end
