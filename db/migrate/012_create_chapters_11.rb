require_relative '../../lib/mangdown'
require_relative '../chapter_script'

class CreateChapters11 < ActiveRecord::Migration
  def up
    DB.create_chapters!('u', 'z', 2)
  end

  def down
  end
end
 
