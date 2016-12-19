class AddIsPaidToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :is_paid, :boolean
  end
end
