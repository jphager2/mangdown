require_relative '../../lib/mangdown'
require_relative '../chapter_script'

class CreateChapters4 < ActiveRecord::Migration
  def up
    DB.create_chapters!('m', 'q', 1)
  end

  def down
  end
end
 
