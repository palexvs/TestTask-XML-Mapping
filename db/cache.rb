require './db/couch.rb'

class Cache
 
  def self.init
    @db = Couch.new()
  end

end