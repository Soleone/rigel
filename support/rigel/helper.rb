module RigelHelper
  def search(word)
  	Noobkit.search(word)
  end
  
  def google(phrase)
  	"http://www.google.com/search?q=" + URI.encode(phrase)
  end
  
  def wikipedia(phrase)
  	"http://en.wikipedia.org/wiki/" + URI.encode(phrase).gsub("%20", "_")
  end
  
  def rubyforge(phrase)
  	url = "http://rubyforge.org/search/?type_of_search=soft&words="
  	url += phrase.gsub(' ', '+')
  end
  
  def pastie
  	PastieClient.pastie_address
  end
  
  def news(phrase)
  	Noobkit.news(phrase)
  end
  
  def roll(max)
  	max ||= 6
  	(rand(max.to_i) + 1).to_s
  end
  
  def quiz
  	Noobkit.quiz
  end
  
  def number_riddle(skill=2, random=true)
  	Noobkit.number_riddle(skill, random)
  end
  
  def learn(context=nil)
  	context ||= "ruby"
  	context.donwcase!
  	case context
		when 'ruby'
			"http://rubylearning.org/class"
		when 'rails'
			"http://www.akitaonrails.com/2007/12/12/rolling-with-rails-2-0-the-first-full-tutorial"
		else
			"I don't know any good help for #{context} yet"
		end
  end
end
