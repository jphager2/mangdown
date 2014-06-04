require_relative '../../lib/mangdown'
require_relative '../chapter_script'

class CreateChapters3 < ActiveRecord::Migration
  def up
    DB.create_chapters!('h', 'l', 1)
  end

  def down
  end
end
 
