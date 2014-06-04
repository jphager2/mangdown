require_relative '../../lib/mangdown'
require_relative '../chapter_script'

class CreateChapters5 < ActiveRecord::Migration
  def up
    DB.create_chapters!('r', 'v', 1)
  end

  def down
  end
end
 
