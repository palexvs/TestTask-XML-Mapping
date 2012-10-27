require 'couchrest'

class Couch
  SERVER = '127.0.0.1'
  PORT = '5984'
  DB_NAME = 'cache'

  def initialize
    @db = CouchRest.database!("http://#{SERVER}:#{PORT}/#{DB_NAME}")
  end

  def get(key)
    begin
      @db.get(key)
    rescue RestClient::ResourceNotFound
      return nil
    end
  end

  def put(key, doc)
    response = @db.save_doc({"_id" => key, :data => doc})
    response[:ok]
  end

  def del(key)
    begin
      response = @db.get(key)
    rescue RestClient::ResourceNotFound
      return false
    end    
    response.destroy
  end
end