class PastieClient
	require 'net/http'
	require 'active_support'

	ADDRESS = "pastie.caboo.se"
	
  attr_accessor :nickname, :key
  
  def initialize(nick=nil, key=nil)
    @nick, @key = nick, key
    connect
  end
  
  def connect
    @connection = Net::HTTP.new(ADDRESS, 80)
  end
  
  def request(path, parameters = {})
    response = @connection.post(path, parameters.to_xml.gsub(/<\/?hash>/,""), 
    							"Content-Type" => "application/xml", "Accept" => "application/xml")
    
    if response.code =~ /20[01]/
      result=response.body
      result.empty? ? true : result
    else
      raise "Error occured (#{response.code}): #{response.body}"
    end
  end

  # returns the id if the paste was saved successfully
  def paste(body, syntax="ruby")
    id = request("/pastes/create", { :paste => { :body => body, :parser => syntax, :key => 'burger'}})
  	pastie_address + "/pastes/" + id
  end
  
  def self.pastie_address
  	"http://" + ADDRESS 
  end
end