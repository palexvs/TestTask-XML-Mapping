require 'dalli'

class Memcache

  def initialize(server = '127.0.0.1', port = '11211')
    @db = Dalli::Client.new("#{server}:#{port}")
  end

  # @return value/nil
  def get(key)
    @db.get(key)
  end

  # @return true/Exception
  def put(key, doc)
    @db.set(key, doc)
  end

  # @return true/nil  
  def del(key)
    @db.delete(key)
  end
end