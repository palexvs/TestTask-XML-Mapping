require 'model/user_xml'
require 'active_support/json'

module Proxy
  XML_DATA_INPUT = "./xml/task.xml"
  XML_DATA_OUTPUT = "./xml/task_out.xml"

  class API < ::Grape::API
    version 'v1', :using => :header, :vendor => 'company'
    format :json

    helpers do
      def loadXML
        UserXML::CustomerResponse.load_from_file(XML_DATA_INPUT)
      end

      def saveXML(xmlObject, file = XML_DATA_OUTPUT)
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
        dids = []
        xmlObject.user.device.numbers.each do |did|
          dids << {number: did.number, vnum_id: did.vnum_id, starcode: did.starcode, ring_pattern: did.ring_pattern }
        end
        {:device => {
          :username => xmlObject.user.device.deviceID.username,
          :name => xmlObject.user.device.deviceID.name,
          :location => xmlObject.user.device.privileged.identification.location,
          :numbers => dids
          }
        }        
      end
    end

    desc "Get device"
    get :device do
      resp = loadXML()
      xml_to_json(resp)
    end

    desc "POST device"
    post :device do
      resp = loadXML()

      if device_valid?(params[:device])
        resp.user.device.deviceID.username = params[:device][:username]
        resp.user.device.deviceID.name = params[:device][:name]
        resp.user.device.privileged.identification.location = params[:device][:location]

        {success: saveXML(resp)}
      else
        {success: false}
      end    

    end

  end
end