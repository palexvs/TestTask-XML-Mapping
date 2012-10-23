TestTask-XML-Mapping
====================

Run server
----------

`rackup -p 9292`

Test
----

Get device in JSON

`curl http://localhost:9292/device`

Update device by sending JSON in POST

`curl -X POST -d '{"device":{"username":"Testa User Name","name":"Test Name","location":"Test Location"}}' http://localhost:9292/device`
