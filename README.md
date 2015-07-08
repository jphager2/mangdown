_Note:_ Please use >= 0.8.3 instead of 0.8.0-2 (which have bugs with MF manga) 
_Note:_ Version 0.9.0 has a new api for downloading (see below)
        

Instalation
===========
Currently, this gem uses the libmagic library. Make sure you have the library, or the ruby-filemagic gem won't install correctly.

For ubuntu 14.04 (and others probably):

  sudo apt-get install libmagic-dev

Then install the gem:

  gem install mangdown


In irb:

  $ require 'mangdown'
  => true


##Mangdown

###Commands

    M#find(string) - Will return an array of Mangdown::MDHash given 
                     a string which is matched to manga names of the 
                     3000 most popular mangas on Mangareader.

    results = M.find('Naruto')



    **Use Mangdown::MDHash#to_manga to get a Mangdown::Manga object**

    naruto = results[0].to_manga



    Mangdown::Manga#download(int = 0, int = -1) 
                  - Will download a manga (Mangdown::Manga object) 
                    from the first int (index of the first chapter) 
                    to the last int  (index of the last chapter) to 
                    a subdirectory of the set DOWNLOAD_DIR which 
                    is the Dir.home directory by default named  
                    #{manga.name}".  If no indexes are given, all 
                    chapters are downloaded.

    # naruto is the Mangdown::Manga object from the example above
    naruto.download(500, 549)

    Mangdown::Manga#download_to(dir, int = 0, int = -1)
                   - Same as download above, but you can provide
                     the directory when the manga subdirectory 
                     will be downloaded

    # naruto is the Mangdown::Manga object from the example above
    naruto.download_to(Dir.home + '/manga', 500, 549)
    
    M#clean_up     - Will delete .manga_list.yml file from the home
                     directory

    M.clean_up


    M#help         - Will display help for commands



