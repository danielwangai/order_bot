require 'rufus-scheduler'
require 'monitor_inv_directory'

scheduler = Rufus::Scheduler.new

directory = ENV['INV_DIRECTORY_PATH'] + "*.TXT"
inventory = InventoryDirectory.get_all_files(directory)

# restaurant_name = InventoryDirectory.split_txt_file(inventory[3])
# sheduler to
scheduler.every '2s' do
  puts InventoryDirectory.split_txt_file(inventory[3]).count
  # puts inventory
end
