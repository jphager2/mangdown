require_relative '../../lib/mangdown'
require_relative '../chapter_script'

class CreateChapters9 < ActiveRecord::Migration
  def up
    DB.create_chapters!('k', 'o', 2)
  end

  def down
  end
end
 
