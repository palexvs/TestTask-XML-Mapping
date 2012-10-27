class Cache
 
  def self.init
    case Settings.db.adapter
      when 'couchdb'
        require './db/couch.rb'
        @db = Couch.new(Settings.db.server,Settings.db.port,Settings.db.database)
      when 'memcachedb'
        require './db/memcache.rb'
        @db = Memcache.new(Settings.db.server,Settings.db.port)
      else
      end
  end

end