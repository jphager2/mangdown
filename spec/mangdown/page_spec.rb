require 'spec_helper'

module Mangdown
  describe Page do
    before(:all) do
      @dir = Dir.pwd
      @page_hash = MDHash.new(
        uri: 'http://i25.mangareader.net/bleach/537/bleach-4149721.jpg',
        name: "Bleach 537 - Page 1" 
      )

      @page = @page_hash.to_page
      @page.download
      PAGE_STUB_PATH = File.expand_path('../../objects/page.yml', 
                                        __FILE__)

      File.open(PAGE_STUB_PATH, 'w+') do |file| 
        file.write(@page.to_yaml)
      end
      @page2 = YAML.load(File.open(PAGE_STUB_PATH, 'r').read)
    end

    context "when page is downloaded" do
      it "should download itself to the current directory" do
        expect(Dir.glob(@dir + '/*')).to include(@dir + '/' + @page.name)
      end
    end

    context "when a page is compared with a page loaded from a .yml file" do
      it "should compare with #eql?" do
        expect(@page.eql?(@page2))
      end 

      it "should not compare with ==" do
        expect(!@page == @page2)
      end
    end
  end
end
