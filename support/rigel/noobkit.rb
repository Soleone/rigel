# Retrieve Ruby documentation online for a keyword
module Noobkit
	require 'rubygems'
	require 'hpricot'
	require 'open-uri'
	require 'riddler'
	require 'cgi'

  URL = "http://www.noobkit.com/search?q="
	
	# Extracts search data from the HTML page at www.noobit.com
  def self.search(word)
    return "" unless valid_search_phrase?(word)
    doc = Hpricot(open(URL + URI.encode(word.to_s)))
    all_results = doc.search("html/body/div[@id='page']/div[@class='content search-results']")
    results = all_results.at("div[@class='search-result']")
    begin
    	(results/'div').remove
    	text = results/'text()'

    	message = word + 
    		"\n----------------------\n" +
    		text.to_s.strip
    rescue Exception => e
    	puts "Error: " + e
    	message = "No result found at Noobkit for " + word
    end
    message
  end

	# Searches for RubyInside posts
  def self.news(word)
    return "You need a search phrase after !news (example: !news merb tutorial)" unless valid_search_phrase?(word)
    puts "Searching for '#{word}'"
  	url = "http://www.rubyinside.com/?s="
    doc = Hpricot( open(url + URI.encode(word.to_s)) )
    items = doc.search("html/body/div[@id='page']/div[@id='content']/div[@class='post']")
    
    item = items[rand(items.size)]
    create_post(item)
  end
	
	
	def self.quiz(phrase=nil)
		url = "http://riddler.heroku.com/riddles.xml"
    doc = Hpricot::XML(open(url))
    riddles = doc.search("riddles/riddle")
    riddle = riddles[rand(riddles.size)]
    create_riddle(riddle)
	end
	
	def self.number_riddle(skill_level=2, random=true)
		riddle = Riddler::NumberRiddle.new(skill_level, random)
		{:question => riddle.text, :answer => riddle.result.to_s}
	end
	
private
  def self.create_post(element)
  	post = {}
  	link = element.at('h3').at('a')
  	post[:title] = link.inner_html
  	post[:link]  = link[:href]
  	post
  end
  
   def self.create_riddle(element)
  	riddle = {}
  	elements = [:question, :answer, :regexp]
  	elements.each do |name|
  		riddle[name] = element.at(name).inner_html	
  	end
  	riddle
  end

  def self.valid_search_phrase?(word)
    return false if !word || word.strip.empty?
    return false unless /^[\w '"]+$/i
    word.each_byte do |byte|
      return false if byte > 128
      puts "#{byte.chr} <--> #{byte}"
    end
    puts "-----> Validating '#{word}'"
    true
  end
end
