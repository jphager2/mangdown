# frozen_string_literal: true

module Mangdown
  # Package manga or chapter directories into .cbz archive files
  module CBZ
    class << self
      extend Tools

      def all(main_dir)
        main_dir = String(main_dir)
        main_dir = validate_file_or_dir_names(main_dir)
        each_dir_or_page(main_dir) { |dir| validate_file_or_dir_names(dir) }
        cbz_sub_dirs(main_dir)
      end

      def one(dir, validate_main_dir = true)
        dir = String(dir)
        dir = validate_file_or_dir_names(dir, validate_main_dir)
        cbz_dir(dir)
      end

      private

      def cbz_dir(dir)
        dir = dir.to_s.sub(/\/*$/, '')

        zip_filename = dir + '.cbz'
        return if File.exist?(zip_filename)

        ::Zip::File.open(zip_filename, ::Zip::File::CREATE) do |zip|
          file_matcher = File.join(dir, '**', '**')
          dir << '/'

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

      def validate_file_or_dir_names(dir, validate_main_dir = true)
        each_dir_or_page(dir) do |filename|
          rename_with_valid_name(filename)
        end
        validate_main_dir ? rename_with_valid_name(dir) : dir
      end

      def rename_with_valid_name(filename)
        checked_name = Tools.valid_path_name(filename)
        File.rename(filename, checked_name)
        checked_name
      end
    end
  end
end
