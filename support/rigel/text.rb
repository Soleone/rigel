class Rigel
	COMMANDS = {
  	'rubydoc' => "Get the first definition of a ruby method or object from Noobkit.com",
  	'news' => "Pick a random post from RubyInside.com containing a search phrase",
  	'gem' => "Search at RubyForge for Gems or Ruby libraries",
  	'search' => "Search at google for a search phrase",
  	'whats' => "Look up a word in wikipedia",
  	'pastie' => "Create a URL to quickly paste some code",
  	'roll' => "Roll a die (default is 6 sided)",
  	'quiz' => "Let me ask you a question",
  	'math' => "I will ask you a math question",
  	'level' => "Set the difficulty of the math questions (1 - 5)",
  	'answer' => "Try to answer a question I asked you (alias: a!)",
  	'solve' => "I'll show you the correct answer to the current quiz question",
  	'addquiz' => "Upload a new question that other people can answer"
	}
	
  GREETINGS = [
		"Hi", "Howdy", "What's up", "Yo", "Greetings", "Good day",
		"Welcome"
	]
	
  RESPONSES = [
  	"Shut up, please", "Uhum", "Yes", "No",	"You're talking to me?",
  	"I don't know", "Hmm", "Not sure", "Happened to me once"
	]
	
	SENTENCES = [
		"Tell me more", "Yea", "If you think so...", 
		"Hm, why am I suddenly so bored?", "Hang on...", "I like dog food!", "Type !help to play with me", "Please, type !math to let me ask you a quiz", "Wanna play? Type !quiz"
	]

	QUESTIONS = [
		"What do you mean?"
	]
	
	THANKS_RESPONSES = [
		"You're welcome", "That's why I live, dude", "For you I'd do it again", "For you I'd do everything!"
	]
	
	BYE_RESPONSES = [
		"Bye", "Goodbye", "Peace", "See ya", "See you"
	]
	
	HEAVY_RESPONSES = [
		"Allright... let it go", "kk", "I see", "Thanks!"
	]
	
	ACTIONS = [
		"takes a look at TARGET", "throws a can of oil at TARGET", "saves the coordinates of TARGET", "laughs at TARGET", "wants to talk to TARGET", "takes a another look at TARGET", "says hello to TARGET", "wants to play with TARGET"
	]
	
	CORRECT_RESPONSES = ["Yes", "Right", "Correct", "Indeed", "True", "That's correct"]
	
	INCORRECT_RESPONSES = ["No", "Wrong", "Sorry, that's not correct", "Nope"]
	
	NO_OPEN_QUIZ = "I have no open quiz at the moment, use !quiz or !math first."
	
	def random(enum)
		enum[rand(enum.size)]
	end
	
	def action(target)
		msg = random(ACTIONS)
		msg.gsub!("TARGET", target)
	end	
end