module UserXML
  require 'xml/mapping'

  class Device; end
  class DID; end

  class CustomerResponse
    include XML::Mapping

    object_node :device, "User/Device", :class=>Device 
  end

  class Device
    include XML::Mapping

    text_node :location, "Privileged/Identification/@Location"
    text_node :username, "DeviceID/@DefaultDID"
    text_node :name, "DeviceID/@Name" 

    array_node :numbers, "DID", :class=>DID, :default_value=>[]
  end

  class DID
    include XML::Mapping

    text_node :number, "@E164"
    text_node :vnum_id, "@VNumID"
    text_node :starcode, "@StarCode"
    text_node :ring_pattern, "@RingPattern"
  end
end