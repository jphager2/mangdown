module Mangdown
  module CBZ
    extend self
    extend ::Mangdown::Tools

    def all(main_dir)
      main_dir = String(main_dir)
			# Make sure all sub dirs are checked
			validate_file_or_dir_names(main_dir)
			# Make sure all sub dirs have files checked
			each_dir_or_page(main_dir) { |dir| validate_file_or_dir_names(dir)}
			# Create cbz files for all sub dirs
			cbz_sub_dirs(main_dir)
    end

    def one(dir)
      dir = String(dir)
			validate_file_or_dir_names(dir)
			cbz_dir(dir)
    end

    private
    def cbz_dir(dir)
      dir = dir.to_s.sub(/\/*$/, "")
      
      zip_file_name = dir + '.cbz'
      return if File.exist?(zip_file_name)

      ::Zip::File.open(zip_file_name, ::Zip::File::CREATE) do |zip|
        file_matcher = File.join(dir, '**', '**')
        dir << "/"

        Dir.glob(file_matcher).each do |file|
          filename = file.sub(dir, '')
          zip.add(filename, file)
        end
      end
    end

    def cbz_sub_dirs(dir)
      each_dir_or_page(dir) do |sub_dir|
        cbz_dir(sub_dir)
      end
    end 

    def each_dir_or_page(dir)
      Dir.glob(dir + '/*').each do |filename| 
        next if filename.include?('.cbz')
        yield(filename)
      end
    end 

    def validate_file_or_dir_names(dir)
      each_dir_or_page(dir) do |file_name|
        checked_name = check_file_or_dir_name(file_name)
        File.rename(file_name, checked_name)
      end
    end

    def check_file_or_dir_name(name)
      number_matcher = /(\d+)(\.\w+)*\Z/
      num = name.slice(number_matcher, 1)

      if num
        num = num.rjust(5, "0")
        name.sub(number_matcher, num + '\2')
      else
        name
      end
    end 
  end
end
