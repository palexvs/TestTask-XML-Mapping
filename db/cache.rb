require './db/couch.rb'

class Cache
 
  def self.init
    @db = Couch.new(Settings.db.server,Settings.db.port,Settings.db.database)
  end

end