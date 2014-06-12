require_relative '../../lib/mangdown'
require_relative '../pages_script'

class CreatePages3 < ActiveRecord::Migration
  def up
    (1001..2000).each do |chapter_id|
      DB.create_pages!(chapter_id)
    end
  end

  def down
  end
end
 
