class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.string :time
      t.string :item
      t.integer :quantity
      t.decimal :cost, :decimal, scale: 2
      t.decimal :total_cost, :decimal, scale: 2
      t.string :served_by

      t.timestamps
    end
  end
end
