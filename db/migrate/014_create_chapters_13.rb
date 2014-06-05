require_relative '../../lib/mangdown'
require_relative '../chapter_script'

class CreateChapters13 < ActiveRecord::Migration
  def up
    DB.create_chapters!(' ', '@', 2)
    DB.create_chapters!('[', '_', 2)
    DB.create_chapters!('{', '}', 2)
  end

  def down
  end
end
 
