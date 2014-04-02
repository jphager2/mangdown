module Mangdown
  module CBZ
    extend self
    extend ::Mangdown::Tools

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

    def all(main_dir)
			# Make sure all sub dirs are checked
			validate_file_or_dir_names(main_dir)
			# Make sure all sub dirs have files checked
			check_dir(main_dir) { |dir| validate_file_or_dir_names(dir)}
			# Create cbz files for all sub dirs
			cbz_sub_dirs(main_dir)
			# new line
			puts
    end
  end
end
