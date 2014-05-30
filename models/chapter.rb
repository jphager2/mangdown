class Chapter < ActiveRecord::Base

  belongs_to :manga
  has_many :pages
end
