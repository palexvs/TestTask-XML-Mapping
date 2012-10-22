require 'xml/mapping'
require 'json'

class User; end
class Device; end
class DID; end

module ToJson
  def to_json(*a)
      to_hash.to_json(*a)
  end   
end

class CustomerResponse
  include XML::Mapping
  include ToJson

  object_node :device, "User/Device", :class=>Device

  def to_hash
      {
        device: device
      }
  end 
end

class Device
  include XML::Mapping
  include ToJson

  text_node :location, "Privileged/Identification/@Location"
  text_node :username, "DeviceID/@DefaultDID"
  text_node :name, "DeviceID/@Name" 

  array_node :numbers, "DID", :class=>DID, :default_value=>[]

  def to_hash
      {
        location: location,
        username: username,
        name: name,
        numbers: numbers,
      }
  end 
end

class DID
  include XML::Mapping
  include ToJson

  text_node :number, "@E164"
  text_node :vnum_id, "@VNumID"
  text_node :starcode, "@StarCode"
  text_node :ring_pattern, "@RingPattern"


  def to_hash
    {
      number: number,
      vnum_id: vnum_id,
      starcode: starcode,
      ring_pattern: ring_pattern,     
    }
  end 
end

# <CustomerResponse xmlns="http://corp.ooma.internal/namespaces/customer" ProcTime="287" Action="GET_ADMUSER">
#   <User PK="nxseuxhpdagiwipsbhjephprgbfsmdii" CustomerPK="yka5bkqu3hq8t5afcv2beryrtde63vxn">
#     <UserID>
#       <Identification FirstName="BOBBY" LastName="BIS" EmailAddress="bobby.biswal@oomanetworks.com" CommonName="BOBBY BIS"/>
#       <Security MaxLogin="1" MaxAttempts="8" MaxInactivity="60" LastAccess="2009-06-09T00:40:04.295Z"/>
#     </UserID>
#     <UserInfo Master="true"/>
#     <Device PK="85cnavzdtvsfyh2jfa5mjn5pqq4mdi4n">
#       <Privileged>
#         <Identification FirstName="" LastName="" Location="Shared" ID="" CommonName=""/>
#         <Security/>
#       </Privileged>
#       <DeviceID Name="" BlockCID="true" DefaultDID="6504335037" Monitor="true" RNA="24" Type="Virtual" VMDID="6508045104" VMPin="200804221349435796508045104@bam.ooma.com"/>
#       <DID PK="x7q6kd3phdq6i5cn8mu43bhjdy6feb3h" E164="16508045104" VNumID="0" CName="BOBBY BISWAL" StarCode="0" MultiRingLocal="false" Monitor="true" RNA="24" IntlCIDAlias="0" VmAlias="0" RingPattern="2" RingTone="">
#       </DID>
#       <DID PK="ykniyx95ezua9j58xefxkn9vu7ksq4bs" E164="16504335037" VNumID="1" CName="Bobby Biswal" StarCode="1" MultiRingLocal="false" Monitor="true" RNA="24" IntlCIDAlias="0" VmAlias="0" RingPattern="0" RingTone="">
#       </DID>
#       <DID PK="enx76myhqq5fkptp2z9jkyvd5b3rkg6m" E164="16504750480" VNumID="3" CName="Bobby B" StarCode="3" MultiRingLocal="false" Monitor="true" RNA="24" IntlCIDAlias="0" VmAlias="0" RingPattern="0" RingTone="">
#       </DID>
#     </Device>
#   </User>
# </CustomerResponse>