defmodule Api.Repo.Migrations.CreateReceiptTemplate do
  use Ecto.Migration

  def change do
    create table(:receipt_templates) do
      add(:logo_url, :string)
      add(:name, :string)
      add(:title, :string)
      add(:description, :string)
      add(:signature_url, :string)
      add(:signature_footer, :string)
      add(:date_format, :string)
      add(:font, :string)
      add(:primary_colour, :string)
      add(:secondary_colour, :string)
      add(:tertiary_colour, :string)
      add(:quaternary_colour, :string)
      add(:quinary_colour, :string)
      timestamps()
    end
  end
end
