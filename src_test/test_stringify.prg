#INCLUDE json-fox.h
Do json_main with "loaddep"
CLEAR

LOCAL loJsonHandler, loObject, lcJson, loDeserializedObject

* Create an instance of the JsonHandler class
loJsonHandler = CREATEOBJECT("JsonHandler")
loStringify = CREATEOBJECT("Stringify")

* Create a test object
loObject = CREATEOBJECT("Empty")
ADDPROPERTY(loObject, "name", "John Doe")
ADDPROPERTY(loObject, "age", 30)
ADDPROPERTY(loObject, "email", "john.doe@example.com")

* Add JSON-LD properties
* Default rdFoxprofix is "object_"
ADDPROPERTY(loObject, "object_context", "http://schema.org")
ADDPROPERTY(loObject, "object_type", "Person")

* Serialize the object to JSON
loJsonHandler.IsJsonLdObject = .T.
lcJson = loJsonHandler.serialize(loObject)

IF loJsonHandler.nError = JS_FATAL_ERROR
    ? "Error during serialization: " + loJsonHandler.cErrorMsg
    RETURN
ENDIF

* Output the serialized JSON string
? "Serialized JSON:"
? lcJson

* Deserialize the JSON string back to an object
loDeserializedObject = loJsonHandler.deserialize(lcJson)

IF loJsonHandler.nError = JS_FATAL_ERROR
    ? "Error during deserialization: " + loJsonHandler.cErrorMsg
    RETURN
ENDIF

* Output the deserialized object properties
? "Deserialized Object:"
? "Name: " + loDeserializedObject.name
? "Age: " + TRANSFORM(loDeserializedObject.age)
? "Email: " + loDeserializedObject.email
? "Context: " + loDeserializedObject.object_context
? "Type: " + loDeserializedObject.object_type

* Verify the results
IF loDeserializedObject.name == "John Doe" AND ;
   loDeserializedObject.age == 30 AND ;
   loDeserializedObject.email == "john.doe@example.com" AND ;
   loDeserializedObject.object_context == "http://schema.org" AND ;
   loDeserializedObject.object_type == "Person"
    ? "The deserialized object matches the original object. Test ok ! "
ELSE
    ? "The deserialized object does not match the original object. Test failed ! "
ENDIF

