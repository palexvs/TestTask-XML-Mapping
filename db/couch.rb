require 'couchrest'

class Couch

  def initialize(server = '127.0.0.1', port = '5984', db_name = 'cache')
    @db = CouchRest.database!("http://#{server}:#{port}/#{db_name}")
  end

  # @return value/nil
  def get(key)
    begin
      @db.get(key)[:data]
    rescue RestClient::ResourceNotFound
      return nil
    end
  end

  # @return true/false
  def put(key, doc)
    response = @db.save_doc({"_id" => key, :data => doc})
    response[:ok]
  end

  # @return true/false
  def del(key)
    begin
      response = @db.get(key)
    rescue RestClient::ResourceNotFound
      return false
    end    
    response.destroy
  end
end