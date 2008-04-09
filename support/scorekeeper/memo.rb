# A change to a person's score.

class Memo < DataMapper::Base
  property :played, :boolean, :default => false
  property :text, :string
  property :person, :string
  property :created_at, :datetime
  
end
