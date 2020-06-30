defmodule Api.Repo.Migrations.RenameReceiptAmountField do
  use Ecto.Migration

  def change do
    alter table("campaigns") do
      remove :amountEligableForReceipt
      add :amount_eligable_for_receipt, :integer
    end
  end
end
