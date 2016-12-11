class ChangeCostDataTypeInTransaction < ActiveRecord::Migration[5.0]
  def change
    change_column :transactions, :cost, :string
    change_column :transactions, :total_cost, :string
  end
end
