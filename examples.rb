module Examples
	
	require './device'

	resp = CustomerResponse.load_from_file("task.xml")
	puts resp.inspect
	puts resp.to_json
	puts resp.to_hash

	resp.device.location = "SomeLocation"
	puts resp.to_hash
	resp.save_to_xml.write $stdout,2
end`