module Proxy
  XML_DATA = "./xml/task.xml"

  class API < ::Grape::API
    version 'v1', :using => :header, :vendor => 'company'
    format :json

    cache = Cache.init

    # HELPERS
    helpers do
      def cache
        @cache
      end

      def loadXML
        UserXML::CustomerResponse.load_from_file(XML_DATA)
      end

      def saveXML(xmlObject, file = XML_DATA)
        xmlObject.action = "SET_ADMDID"
        
        begin
          fXML = File.new(file,"w")
          fXML.puts '<?xml version="1.0" encoding="UTF-8"?>'
          xmlObject.save_to_xml.write fXML
          fXML.close
        rescue
          return false
        end

        true        
      end

      def device_valid?(data)
        !data.empty? && data[:username].length >= 10
      end

      def xml_to_json(xmlObject)
        {:device => {
          :username => xmlObject.user.device.deviceID.username,
          :name => xmlObject.user.device.deviceID.name,
          :location => xmlObject.user.device.privileged.identification.location,
          :numbers => xmlObject.user.device.numbers.map do |did| 
                        { number: did.number, 
                          vnum_id: did.vnum_id, 
                          starcode: did.starcode, 
                          ring_pattern: did.ring_pattern } 
                      end
          }
        }        
      end
    end

    # API
    desc "Get device"
    get :device do
      if from_cache = cache.get('device')
        header("From-Cache", "true")
        from_cache
      else
        resp = loadXML()
        resp_json = xml_to_json(resp)
        cache.put('device', resp_json)
        resp_json
      end
    end

    desc "POST device"
    post :device do
      resp = loadXML()

      if device_valid?(params[:device])
        resp.user.device.deviceID.username = params[:device][:username]
        resp.user.device.deviceID.name = params[:device][:name]
        resp.user.device.privileged.identification.location = params[:device][:location]

        cache.del('device') if saved = saveXML(resp) 

        { success: saved }
      else
        { success: false }
      end    

    end

  end
end