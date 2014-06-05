require_relative '../../lib/mangdown'
require_relative '../pages_script'

class CreatePages2 < ActiveRecord::Migration
  def up
    (101..1000).each do |chapter_id|
      DB.create_pages!(chapter_id)
    end
  end

  def down
  end
end
 
