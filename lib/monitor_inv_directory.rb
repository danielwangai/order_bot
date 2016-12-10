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
end
