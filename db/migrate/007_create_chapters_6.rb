require_relative '../../lib/mangdown'
require_relative '../chapter_script'

class CreateChapters6 < ActiveRecord::Migration
  def up
    DB.create_chapters!('w', 'z', 1)
  end

  def down
  end
end
 
