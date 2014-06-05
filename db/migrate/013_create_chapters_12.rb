require_relative '../../lib/mangdown'
require_relative '../chapter_script'

class CreateChapters12 < ActiveRecord::Migration
  def up
    DB.create_chapters!(' ', '@', 1)
    DB.create_chapters!('[', '_', 1)
    DB.create_chapters!('{', '}', 1)
  end

  def down
  end
end
 
