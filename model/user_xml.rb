module UserXML
  require 'xml/mapping'

  class User; end
  class UserID; end
  class Device; end
  class Privileged; end
  class DeviceID; end
  class DID; end

  class CustomerResponse
    include XML::Mapping

    root_element_name "CustomerResponse"
    
    text_node :action, "@Action"
    text_node :xmlns, "@xmlns"
    text_node :procTime, "@ProcTime"

    object_node :user, "User", :class=>User
  end

  class User
    include XML::Mapping
    
    text_node :customerPK, "@CustomerPK"
    text_node :pk, "@PK"

    object_node :device, "Device", :class=>Device
    object_node :userID, "UserID", :class=>UserID
  end  

  class UserID
    class Identification; end
    class Security; end
    include XML::Mapping
    
    object_node :identification, "Identification", :class=>Identification
    object_node :security, "Security", :class=>Security

    class Identification
      include XML::Mapping
      
      text_node :firstName, "@FirstName"
      text_node :lastName, "@LastName"
      text_node :emailAddress, "@EmailAddress"
      text_node :commonName, "@CommonName"
    end  

    class Security
      include XML::Mapping
      
      text_node :maxLogin, "@MaxLogin"
      text_node :maxAttempts, "@MaxAttempts"
      text_node :maxInactivity, "@MaxInactivity"
      text_node :lastAccess, "@LastAccess"
    end  
  end

  class Device
    include XML::Mapping

    text_node :pk, "@PK"

    object_node :deviceID, "DeviceID", :class=>DeviceID
    object_node :privileged, "Privileged", :class=>Privileged

    array_node :numbers, "DID", :class=>DID, :default_value=>[]
  end

  class Privileged
    class Identification; end    
    include XML::Mapping

    object_node :identification, "Identification", :class=>Identification  

    class Identification
      include XML::Mapping
      text_node :location, "@Location"

      text_node :FirstName, "@FirstName"
      text_node :lastName, "@LastName"
      text_node :commonName, "@CommonName"
    end
  end

  class DeviceID
    include XML::Mapping

    text_node :username, "@DefaultDID"
    text_node :name, "@Name"

    text_node :blockCID, "@BlockCID"
    text_node :monitor, "@Monitor"
    text_node :rna, "@RNA"
    text_node :type, "@Type"
    text_node :vmDID, "@VMDID"
    text_node :vmPin, "@VMPin"
  end

  class DID
    include XML::Mapping

    text_node :number, "@E164"
    text_node :vnum_id, "@VNumID"
    text_node :starcode, "@StarCode"
    text_node :ring_pattern, "@RingPattern"

    text_node :pk, "@PK"
    text_node :cName, "@CName"
    text_node :multiRingLocal, "@MultiRingLocal"
    text_node :monitor, "@Monitor"
    text_node :rna, "@RNA"
    text_node :intlCIDAlias, "@IntlCIDAlias"
    text_node :vmAlias, "@VmAlias"
    text_node :ringTone, "@RingTone"   
  end
end