require_relative '../../lib/mangdown'
require_relative '../chapter_script'

class CreateChapters8 < ActiveRecord::Migration
  def up
    DB.create_chapters!('f', 'j', 2)
  end

  def down
  end
end
 
