class AddConfirmedToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :confirmed, :boolean
  end
end
