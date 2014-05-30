require 'active_record'
require 'yaml'
require 'erb'

require_relative '../db/mangdown_db.rb'

require_relative '../models/site.rb' 
require_relative '../models/manga.rb' 
require_relative '../models/chapter.rb' 
require_relative '../models/page.rb' 

Mangdown::DB.establish_connection
