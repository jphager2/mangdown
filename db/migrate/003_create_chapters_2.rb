require_relative '../../lib/mangdown'
require_relative '../chapter_script'

class CreateChapters2 < ActiveRecord::Migration
  def up
    DB.create_chapters!('d', 'g', 1)
  end

  def down
  end
end
 
