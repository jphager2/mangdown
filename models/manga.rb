class Manga < ActiveRecord::Base

  belongs_to :site
  has_many :chapters
end

