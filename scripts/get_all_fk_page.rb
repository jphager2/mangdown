require_relative '../lib/mangdown'

module Mangdown

  extend self

  def fk_uri(uri)
    "http://www.fakku.net#{uri}"
  end

  def find_chapters(num)
    t = 0
    fk_list = []
    while fk_list.length < num
      page = fk_uri("/page/#{t + 1}")
  
      doc = Mangdown::Tools.get_doc(page)

      doc.css('h2 a.content-title').each do |ch|
       fk_list.push([ch.text, ch[:href]])
      end
      
      t += 1
    end

    fk_list[0..num-1]
  end

  def get_chapters(num)
    fk_list = []

   # t.times do |num|

   #   page = "http://www.fakku.net/page/#{num + 1}"
  
   #   doc = Mangdown::Tools.get_doc(page)

   #   fk_list = doc.css('h2 a.content-title').map {|ch| [ch.text, ch[:href]]}
   # end
    fk_list = find_chapters(num)

    chapters_list = []

    fk_list.each do |ch|
      ch_uri = fk_uri(ch[1])
      name = ch[0]

      doc = Mangdown::Tools.get_doc(ch_uri)

      # uri = fk_uri(doc.css('div.images a')[0][:href]) 
      uri = ch_uri + '/read#page=1'

      pages = doc.css('div#right div.left b')[0].text.to_i

      chapters_list.push([uri, name, pages])
    end

    chapters_list

  end
end


if __FILE__ == $0
  t = ARGV[0].to_i
  t = 1 if t <= 0

  Mangdown.get_chapters(t)
else
  puts "Script loaded"
end

