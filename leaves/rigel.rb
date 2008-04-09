class Rigel < Autumn::Leaf
  NAME = "Rigel"
  before_filter :authenticate, :only => [ :reload, :quit ]
  
  PRIVATE_COMMANDS = [ "kick" ]
  
  def about_command(stem, sender, reply_to, msg)
    msg = "I can do the following things for you:\n"
    COMMANDS.each do |cmd, dsc|
    	msg += ("#{color :orange}!" + cmd.ljust(10) + "#{uncolor}"). + " - " + dsc + "\n"
    end
    msg
  end
 	alias help_command about_command
 	alias introduce_command about_command
 	
  def hello_command(stem, sender, reply_to, msg)
  	"You said: #{msg}"
  end
  
  def suck_command(stem, sender, reply_to, msg)
  	case msg
		when /penis|cock|dick/i
			"No way, dude!"
		when /lolipop/i
			"Yea, i like sweets!"
		end
  end
  
  def yoMamma_command(stem, sender, reply_to, msg)
  	"Yo dude! What's crackin?"
  end
  
  def me_command(stem, sender, reply_to, msg)
  	values = ""
  	sender.each do |key,value|
  		values << "#{key} -> #{value}\n"
  	end	
  	values
  end

  def rubydoc_command(stem, sender, reply_to, msg)
  	search(msg.strip)
  end
  
  def search_command(stem, sender, reply_to, msg)
  	google(msg.strip)
  end
  
  def whats_command(stem, sender, reply_to, msg)
  	wikipedia(msg.strip)
  end
  
  def news_command(stem, sender, reply_to, msg)
  	news = news(msg.strip)
  	"#{color :blue}" + news[:title] + "#{uncolor}\n" + news[:link]
  end
  
  def pastie_command(stem, sender, reply_to, msg)
  	pastie
  end
  
  def gem_command(stem, sender, reply_to, msg)
  	msg ||= ''
  	rubyforge(msg.strip)
  end
  
  def roll_command(stem, sender, reply_to, msg)
  	roll(msg)
  end

  def quiz_command(stem, sender, reply_to, msg)
  	@open_quiz = quiz
  	@open_quiz[:question] if @open_quiz
  end
  
  def answer_command(stem, sender, reply_to, msg)
  	return NO_OPEN_QUIZ unless @open_quiz
  	supplied = msg.strip
  	correct = try_answer(supplied)
  	response = correct ? random(CORRECT_RESPONSES) : random(INCORRECT_RESPONSES)
    mycolor = correct ? :green : :red
  	"#{color mycolor}" + response + " #{sender[:nick]}" + "#{uncolor}"
  end
  alias a_command answer_command
  
  def leave_command(stem, sender, reply_to, msg)
  	if boss? sender
  		stems.message "Allright master, I'll go..."
  		Thread.new do 
  			sleep 2
  			stems.message "Bye guys"
  			sleep 1
  			exit
  		end
  		''
  	end
  end
  
  def addquiz_command(stem, sender, reply_to, msg)
  	"Input a new Question here: http://riddler.heroku.com/riddles/new"
  end
  
  def level_command(stem, sender, reply_to, msg)
  	return unless msg
  	level = msg.strip.to_i
  	return "Level must be between 1 - 5" unless level.between?(1,5)
  	@level = level
  	"Changed skill level of math questions to [#{@level}]"
  end
  
  def math_command(stem, sender, reply_to, msg)
  	@open_quiz = number_riddle(@level)
  	@open_quiz[:question] if @open_quiz
  end
  
  def solve_command(stem, sender, reply_to, msg)
		return NO_OPEN_QUIZ unless @open_quiz
  	stem.message "The answer is: #{@open_quiz[:answer]}"
  	@open_quiz = nil
  end
  
  def target_command(stem, sender, reply_to, msg)
  	msg ||= '';	msg.strip!
		puts reply_to
  	stem.ctcp_action reply_to, action(msg)
  end
  
  def learn_command(stem, sender, reply_to, msg)
  	learn(msg)
  end
  
  def shutup_command(stem, sender, reply_to, msg)
  	@shutup = !@shutup
  	@shutup ? "Ok, I won't say a word." : "I will consider you worth talking to again."
  end
    	
    	
  def did_receive_channel_message(stem, sender, reply_to, msg)
  	return if @shutup
  	msg ||= ''
  	msg = msg.strip
  	if /#{NAME}/i =~ msg
  		# greetings
  		if /^(hey|hi|yo)|hello|welcome|greet/i =~ msg
  			reply = GREETINGS[rand(GREETINGS.size)] + " #{sender[:nick]}"
  		# thanks
  		elsif /thanks?|thx|merci|danke/i =~ msg
  			reply = THANKS_RESPONSES[rand(THANKS_RESPONSES.size)]
			else
				# quiz answer
				if (@open_quiz && try_answer(msg))
					reply = random(CORRECT_RESPONSES)
				else
					# questions
					if /\?$/ =~ msg
  					reply = RESPONSES[rand(RESPONSES.size)]
  				# exclamation
  				elsif /\!$/ =~ msg
  					reply = HEAVY_RESPONSES[rand(HEAVY_RESPONSES.size)]
  				# default sentences
					else
						reply = sender[:nick] + ": " + SENTENCES[rand(SENTENCES.size)]
					end
				end
			end
			stems.message reply
  	end
  end
  	
  def did_receive_private_message(stem, sender, msg)
  	return if msg.empty?
  	unless PRIVATE_COMMANDS.select{|c| /^#{c}/i =~ msg.strip}.empty?
  		cmd, channel, user = *msg.strip.split(" ")
  		case msg.strip
  		when /^kick/i
  			stem.kick('#' + channel, user, "They made me do it")
  		end
  	else
  		stem.message "I am a Bot. What do you want, #{sender[:nick]} ?"
  	end
  end
  
  def someone_did_kick(stem, kicker, channel, victim, msg)
  	"Bye bye, #{victim[:nick]}, hehe"
	end
    
  def quit_command(stem, sender, reply_to, msg)
    stem.quit if boss?(sender)
  end

	def promote_command(stem, sender, reply_to, msg)
		nick = sender[:nick]
		stem.mode(reply_to, '+o', nick)
		"I like you, #{nick}"
	end
	
  def did_start_up
  	init
  	stems.message 'Hi, I am your fellow Bot. Type !help for more information on what I can do for you.'
	end

	def someone_did_quit(stem, person, msg)
		stems.message "Bye, #{person[:nick]}"	
	end
	
	def someone_did_join_channel(stem, person, channel)
		nick = person[:nick]
  	stems.message "#{random(GREETINGS)} #{nick}" unless /#{NAME}/ =~ nick
	end
	
		
private
  
  def authenticate_filter(stem, channel, sender, command, msg, opts)
    [ :operator, :admin, :founder, :channel_owner ].include? stem.privilege(channel, sender)
  end

	def init
		@level = 2
		@open_quiz = nil	
		@shutup = false
	end
	
	def boss?(sender)
		/sole/i =~ sender[:nick]	
	end
	
	def try_answer(supplied="")
		regexp = @open_quiz[:regexp]
  	if regexp && !regexp.empty?
  		correct = Regexp.new(regexp) =~ supplied
		else
			correct = Regexp.new(@open_quiz[:answer].downcase) =~ supplied
		end
		@open_quiz = nil if correct
		correct
	end


end
