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
        begin
          fXML = File.new(file,"w")
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
    end

    desc "Get device"
    get :device do
      resp = loadXML()
      resp.to_json
    end

    desc "POST device"
    post :device do
      resp = loadXML()

      if device_valid?(params[:device])
        resp.device.username = params[:device][:username]
        resp.device.name = params[:device][:name]
        resp.device.location = params[:device][:location]

        {success: saveXML(resp)}
      else
        {success: false}
      end    

    end

  end
end