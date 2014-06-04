require_relative '../../lib/mangdown'
require_relative '../chapter_script'

class CreateChapters10 < ActiveRecord::Migration
  def up
    DB.create_chapters!('p', 't', 2)
  end

  def down
  end
end
 
