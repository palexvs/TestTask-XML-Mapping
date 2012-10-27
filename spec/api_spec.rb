require 'spec_helper'

OUTER_APP = Rack::Builder.parse_file('config.ru').first

describe Proxy::API do
  include Rack::Test::Methods

  def app
    OUTER_APP
  end

  describe Proxy::API do
    describe "POST and GET /device" do
      it do
        # POST
        post "/device", '{"device":{"username":"New username","name":"New Name","location":"New Location"}}'
        last_response.status.should == 201
        last_response.body.should == {"success" => true}.to_json
        # GET
        get "/device"
        last_response.status.should == 200
        last_response.body.should == 
          {"device" => 
            {"username" => "New username",
              "name" => "New Name",
              "location" => "New Location",
              "numbers" => [
                {"number" => "16508045104","vnum_id" => "0","starcode" => "0","ring_pattern" => "2"},
                {"number" => "16504335037","vnum_id" => "1","starcode" => "1","ring_pattern" => "0"},
                {"number" => "16504750480","vnum_id" => "3","starcode" => "3","ring_pattern" => "0"}
              ]
            }
          }.to_json
      end
    end

    describe "POST /device" do
      describe "when :username.length < 10" do
        it do
          post "/device", '{"device":{"NewKey":"NewValue","username":"123","name":"Test Name","location":"Test Location"}}'
          last_response.body.should == {"success" => false}.to_json
        end
      end 

      describe "when without some key" do
        it do
          post "/device", '{"device":{"username":"123","name":"Test Name"}}'
          last_response.body.should == {"success" => false}.to_json
        end
      end 

      describe "when with some unnecessary key" do
        it do
          post "/device", '{"device":{"username":"123","name":"Test Name","location":"Test Location"}}'
          last_response.body.should == {"success" => false}.to_json
        end
      end             
    end

    describe "Caching" do
      it "should use cache" do
        # Clean cache
        post "/device", '{"device":{"username":"Not cached username","name":"Not cached Name","location":"Not cached Location"}}'        
        last_response.status.should == 201
        # First request
        get "/device"
        last_response.status.should == 200
        last_response.headers["From-Cache"].should be_nil
        last_response.body.should == 
          {"device" => 
            {"username" => "Not cached username",
              "name" => "Not cached Name",
              "location" => "Not cached Location",
              "numbers" => [
                {"number" => "16508045104","vnum_id" => "0","starcode" => "0","ring_pattern" => "2"},
                {"number" => "16504335037","vnum_id" => "1","starcode" => "1","ring_pattern" => "0"},
                {"number" => "16504750480","vnum_id" => "3","starcode" => "3","ring_pattern" => "0"}
              ]
            }
          }.to_json
        # Second request from cache
        get "/device"
        last_response.status.should == 200
        last_response.headers["From-Cache"].should be_true          
      end
    end    
  end
end