require 'rufus-scheduler'
require 'monitor_inv_directory'

scheduler = Rufus::Scheduler.new

directory = ENV['INV_DIRECTORY_PATH'] + "*.TXT"
inventory = InventoryDirectory.get_all_files(directory)

data = InventoryDirectory.split_txt_file(inventory[3])
transation_items = InventoryDirectory.transation_items(data)
transaction_hash = InventoryDirectory.transation_items_hash(transation_items)

scheduler.every '2s' do
  # sheduler to save transaction details
  transaction = Transaction.new
  # save time
  transaction.time = InventoryDirectory.get_date(data)[1]
  transaction.item = InventoryDirectory.get_item(transaction_hash)
  transaction.quantity = InventoryDirectory.get_quantity(transaction_hash)
  transaction.cost = InventoryDirectory.get_cost(transaction_hash).to_f
  transaction.total_cost = InventoryDirectory.get_total_cost(data).to_f
  transaction.served_by = InventoryDirectory.get_served_by(data)
  transaction.save!
end
