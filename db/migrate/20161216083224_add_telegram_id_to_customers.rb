class AddTelegramIdToCustomers < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :telegram_id, :string
  end
end
