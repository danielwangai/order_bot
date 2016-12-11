class AddCustomerIdToTransaction < ActiveRecord::Migration[5.0]
  def change
    add_reference :transactions, :customer, foreign_key: true
  end
end
