Instalation

gem install mangdown


In irb:

$ require 'mangdown'
=> true


Mangdown

Commands

    M#find(string) - Will return an array of Mangdown::MDHash given a string 
                     which is matched to manga names of the 3000 most popular 
                     mangas on Mangareader.

    results = M.find('Naruto')



    *** Use Mangdown::MDHash#get_manga to get a Mangdown::Manga object ***

    naruto = results[0].get_manga



    M#download(manga, int = 0, int = -1) 
                  - Will download a manga (Mangdown::Manga object) from the 
                    first int (index of the first chapter) to the last int 
                    (index of the last chapter) to a subdirectory named 
                    #{manga.name}".  If no indexes are given, all chapters 
                    are downloaded.

    M.download(naruto, 500, 549)



    M#help         - Will display help for commands

==============================================================================

