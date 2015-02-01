module Mangdown
  module CBZ
    extend self
    extend ::Mangdown::Tools

    def all(main_dir)
			# Make sure all sub dirs are checked
			validate_file_or_dir_names(main_dir)
			# Make sure all sub dirs have files checked
			check_dir(main_dir) { |dir| validate_file_or_dir_names(dir)}
			# Create cbz files for all sub dirs
			cbz_sub_dirs(main_dir)
    end

    private
    def cbz_dir(dir)
      zip_file_name = dir + '.cbz'
      dir += '/' unless dir[-1] == '/'

      ::Zip::File.open(zip_file_name, ::Zip::File::CREATE) do |zip|
        Dir[File.join(dir, '**', '**')].each do |file|
          zip.add(file.sub(dir, ''), file)
        end
      end
    end

    def cbz_sub_dirs(dir)
      check_dir(dir) do |sub_dir|
        cbz_dir(sub_dir)
      end
    end 

    def check_dir(dir)
      Dir.glob(dir + '/*').each do |file_name| 
        #do block on each file name, but skip .cbz files
        next if file_name.include?('.cbz')
        yield(file_name)
      end
    end 

    def validate_file_or_dir_names(dir)
      check_dir(dir) do |file_name|
        checked_name = check_file_or_dir_name(file_name)
        File.rename(file_name, checked_name)
      end
    end

    def check_file_or_dir_name(name)
      # slice the last number in the file or directory name,
      # which will be either the page number or the chapter number
      num = name.slice(/(\d+)(\.jpg)*\Z/, 1)
      return name unless num

      zeros_to_add = (3-num.length) > 0 ? (3-num.length) : 0
      num = "0" * zeros_to_add + num
      name.sub(/(\d+)(\.jpg)*\Z/, num + '\2')
    end 
  end
end
