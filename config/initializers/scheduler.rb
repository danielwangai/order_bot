require 'rufus-scheduler'
require 'monitor_inv_directory'
require 'telegram'
scheduler = Rufus::Scheduler.new

directory = ENV['INV_DIRECTORY_PATH'] + "*.TXT"

# data = inventory_files[1]

# directory containing inventory files
Dir.chdir ENV['INV_DIRECTORY_PATH']

scheduler.every '5s' do
  # sheduler to save transaction details
  inventory_files = InventoryDirectory.get_all_files(directory)

  inventory_files.each do |inventory|
    # check if customer exists
    data = InventoryDirectory.split_txt_file(inventory)
    cust_details = InventoryDirectory.get_account_details(data)
    customer = Customer.find_or_create_by!(account_number: cust_details[0], name: cust_details[1])

    transation_items = InventoryDirectory.transation_items(data)
    transaction_hash = InventoryDirectory.transation_items_hash(transation_items)
    transaction = Transaction.new

    transaction.time = InventoryDirectory.get_date(data)[1]
    transaction.item = InventoryDirectory.get_item(transaction_hash)
    transaction.quantity = InventoryDirectory.get_quantity(transaction_hash)
    transaction.cost = InventoryDirectory.get_cost(transaction_hash).to_f
    transaction.total_cost = InventoryDirectory.get_total_cost(data).to_f
    transaction.served_by = InventoryDirectory.get_served_by(data)
    transaction.customer_id = customer.id
    transaction.is_paid = false
    transaction.save!

    # rename current file
    invoice_file = inventory.split("/").last
    File.rename(invoice_file, File.join(Dir.pwd, "$"+invoice_file))
  end
end
