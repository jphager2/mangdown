require_relative '../../lib/mangdown'
require_relative '../chapter_script'

class CreateChapters < ActiveRecord::Migration
  def up
    DB.create_chapters!('a', 'c', 1)
  end

  def down
  end
end
 
