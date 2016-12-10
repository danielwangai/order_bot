require 'rufus-scheduler'
require 'monitor_inv_directory'

scheduler = Rufus::Scheduler.new

directory = ENV['INV_DIRECTORY_PATH'] + "*.TXT"
inventory = InventoryDirectory.get_all_files(directory)

data = InventoryDirectory.split_txt_file(inventory[3])
transaction_hash = InventoryDirectory.transation_items_hash(data)
# sheduler to
scheduler.every '2s' do
  # puts InventoryDirectory.split_txt_file(data)
  # puts inventory
  puts InventoryDirectory.get_item(transaction_hash)
end
