require_relative '../../lib/mangdown'
require_relative '../chapter_script'

class CreateChapters7 < ActiveRecord::Migration
  def up
    DB.create_chapters!('a', 'e', 2)
  end

  def down
  end
end
 
