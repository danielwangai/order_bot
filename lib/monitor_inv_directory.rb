class InventoryDirectory
  # we add a $ tag to the TXT filename to signify that the data in it has been pushed to db
  # this is to avoid double entry
  def self.get_all_files(directory)
    # this method gets all the files in the directory without the $ tag in the file name
    # get the directory
    # directory = ENV['INV_DIRECTORY_PATH'] + "*.TXT"
    # array that will hold new file(s)
      files_in_directory = []

    # loop through all files
    Dir.glob(directory) do |file|
      # file = file.split("INV")
      # get rid of the / appearing before the filename
      # file[1][0] = ""
      if !file.include? "$" # meaning its unprocessed
        files_in_directory.push(file)
      end
    end
    files_in_directory
  end

  def self.split_txt_file(inventory_file)
    # rip the contents of transaction recorded in the inventory file.
    # this method returns an array of inventory contents

    inventory_data = []
    current_file = File.read(inventory_file)
    current_file = current_file.split(/\n/)

    current_file.each do |content|
      inventory_data.push(content.strip)
    end

    # get rid of array elements containing _
    inventory_data.each do |param|
      if param.include? '_'
        inventory_data.delete(param)
      end
    end

    inventory_data.each do |param|
  		if param.include? '-------'
  			inventory_data.delete(param)
  		end
  	end
    inventory_data
  end

  def self.get_account_details(split_txt_file)
  	acc_key = ""
  	acc_no = ""
  	acc_name = ""
  	re = /(\d+)/

  	split_txt_file.each do |account|
  		if account.include? "ACCOUNT N0"
  			acc_key = account
  		end
  	end
  	acc_no = acc_key.strip.split(re).last

  	# get index of transaction keys
  	index = split_txt_file.index(acc_key)

  	# get the array element of the values, comes after transaction_keys
  	acc_name = split_txt_file[index + 1]
  	account_array = acc_name.split(' ')
  	name = ""

  	account_array.each do |value|
  		if account_array.index(value) > 1
  			name.concat(" #{value}")
  		end
  	end
  	[acc_no, name]
  end


  def self.get_date(inventory_data)
    # date regex - dd/mm/yyyy
    date_regex = /(\d{2})\/(\d{2})\/(\d{4})/
  	transaction_date = ""
    transaction_time = ""
    transaction__time = []
    item = ""
    inventory_data.each do |date|
      if date[date_regex]
  			transaction_date = date
        item = date
  		end
    end
    # clean date
  	# remove spaces
  	transaction_date = transaction_date.strip
  	# returning trasaction_date
  	# trasaction_date
    item_array = item.split(date_regex)
    item_array.last[0] = ""
    transaction_time = item_array.last

    # return array containting date and time
    transaction__time = [transaction_date, transaction_time]
    transaction__time
  end

  def self.transation_items(inventory_data)
    transaction_keys = ""
  	transaction_values = ""
    transaction_details = []

    inventory_data.each do |transaction|
      if transaction.include? "Item                Qty"
  			transaction_keys = transaction
  		end
    end
    # get index of transaction keys
    transaction_values_index = inventory_data.index(transaction_keys)

    # get the array element of the values, comes after transaction_keys
  	transaction_values = inventory_data[transaction_values_index + 1]

    transaction_details = [transaction_keys, transaction_values]
    transaction_details
  end

  def self.transation_items_hash(transaction_items)
    transaction_keys = transaction_items[0]
  	transaction_values = transaction_items[1]

    # regular expression identifying
    re = /(\d+)/
    # this is the name of the item bought
    item_name = transaction_values.split(re)[0]

    transaction_header = transaction_keys.split(" ")
    transaction_val = transaction_items[1].split(" ")
    values_of_transaction = []
    transaction_val.each do |s|
      values_of_transaction.push(s.to_i)
    end

    values_of_transaction.each do |item|
      until item > 0 do
        values_of_transaction.delete(item)
        break
      end
    end

    values_of_transaction.insert(0, item_name.strip)
    values_of_transaction.push(transaction_val.last)

    # create a hash using the two arrays
  	transaction_hash = Hash[transaction_header.zip values_of_transaction]
  	transaction_hash

  end

  def self.get_item(transaction_hash)
    item = transaction_hash["Item"]
  end

  def self.get_quantity(transaction_hash)
  	transaction_hash["Qty"]
  end

  def self.get_cost(transaction_hash)
  	transaction_hash["Self"]
  end

  def self.get_total_cost(inventory_data)
    total_cost = ""
  	inventory_data.each do |total|
  		if total.include? "TOTAL"
  			total_cost = total
  		end
  	end
  	# split to get rid of spaces
  	total_cost = total_cost.split(' ')
  	total_cost[1]
  end

  def self.get_served_by(inventory_data)
    served_by = ""
  	inventory_data.each do |user|
  		if user.include? "Served by"
  			served_by = user
  		end
  	end
  	served_by = served_by.split(' ')
  	# since servername could be longer i.e. more than one string
  	server_name = ""
  	if served_by.length > 2
  		server = served_by.drop(2)
  		server.each do |name|
  			server_name.concat(" #{name}")
  		end
  	end

  	server_name
  end
end
