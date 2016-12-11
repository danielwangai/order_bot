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


  def self.get_date(inventory_data)
    # date regex - dd/mm/yyyy
    date_regex = /(\d{2})\/(\d{2})\/(\d{4})/
  	trasaction_date = ""
    inventory_data.each do |date|
      if date[date_regex]
  			trasaction_date = date
  		end
    end
    # clean date
  	# remove spaces
  	trasaction_date = trasaction_date.strip
  	# returning trasaction_date
  	trasaction_date
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

    # split the string by a space to form an array
  	# transaction_keys = transaction_keys.split(' ')
    # transaction_values = transaction_values.split(' ')

    transaction_details = [transaction_keys, transaction_values]
    transaction_details

    # # ------------------------------------------------------
    # # regular expression identifying
    # re = /(\d+)/
    # item_name = ""
    # transaction_values.each do |value|
    #   if !value[re]
    #     item_name.concat(value + " ")
    #   end
    # end
    #
    # # create a hash using the two arrays
  	# transaction_hash = Hash[transaction_keys.zip transaction_values]
  	# transaction_hash
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
  #
  # def self.get_item(transaction_hash)
  #   item = transaction_hash["Item"]
  # end
  #
  # def self.get_quantity(transaction_hash)
  # 	transaction_hash["Qty"]
  # end
  #
  # def self.get_cost(transaction_hash)
  # 	transaction_hash["Self"]
  # end
end
