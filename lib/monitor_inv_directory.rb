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
      file = file.split("INV")
      # get rid of the / appearing before the filename
      file[1][0] = ""
      if !file[1].include? "$" # meaning its unprocessed
        files_in_directory.push(file[1])
      end
    end
    files_in_directory
  end
end
