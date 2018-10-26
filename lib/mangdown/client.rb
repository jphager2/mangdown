# frozen_string_literal: true

require_relative '../mangdown'

# Simple client for Mangdown
module M
  DATA_FILE_PATH = Dir.home + '/.manga_list.yml'
  HELP_FILE_PATH = File.expand_path(
    '../../README.md', File.dirname(__FILE__)
  )

  DEFAULT_MANGA_PAGES = ['https://www.mangareader.net/alphabetical'].freeze

  class << self
    # return a list of hash with :uri and :name of mangas found in list
    def find(search)
      search = Regexp.new(/^#{search}$/) if search.respond_to?(:to_str)

      current_manga_list.select { |manga| manga[:name] =~ search }
    end

    # cbz all subdirectories in a directory
    def cbz(dir)
      Mangdown::CBZ.all(dir)
    rescue StandardError => error
      raise Mangdown::Error, "Failed to package #{dir}: #{error.message}"
    end

    # display help file
    def help
      puts File.read(HELP_FILE_PATH)
    end

    # delete data file
    def clean_up
      File.delete(DATA_FILE_PATH) if File.exist?(DATA_FILE_PATH)
    end

    def manga_pages
      @manga_pages ||= DEFAULT_MANGA_PAGES.dup
    end

    private

    # convenience method to access the data file path
    def path
      DATA_FILE_PATH
    end

    # check if the data file is current
    def file_current?(file)
      File.exist?(file) && File.mtime(file) > (Time.now - 604_800)
    end

    # attempt to get the list from the data file
    def data_from_file
      YAML.load(File.read(path)) if file_current?(path)
    end

    # get saved current manga list, if data is less than a week old
    # otherwise fetch new data and write it to the data file
    def current_manga_list
      data = data_from_file
      return Mangdown::MangaList.from_data(data) if data

      list = manga_pages.inject([]) do |manga, uri|
        list = Mangdown::MDHash.new(uri: uri).to_manga_list
        list.merge(manga)
      end
      File.open(path, 'w+') { |f| f.write(list.to_yaml) }
      list
    rescue StandardError => error
      raise Mangdown::Error, "#{path} may be corrupt: #{error.message}"
    end
  end
end
