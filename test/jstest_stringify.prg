#INCLUDE json-fox.h
Do main with "loaddep"
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

* Try with a cursor 
CREATE CURSOR testCursor (;
    cString C(50), ;
    nNumber N(10,2), ;
    lBoolean L, ;
    dDate D, ;
    tDateTime T, ;
    mMemo M, ;
    gGeneral G, ;
    bBlob B, ;
    yCurrency Y, ;
    iInteger I, ;
    fFloat F, ;
    dDouble B, ;
    qVarbinary Q(50), ;
    vVarchar V(50))

* Insert a record with sample data
INSERT INTO testCursor (cString, nNumber, lBoolean, dDate, tDateTime, mMemo, yCurrency, iInteger, fFloat, dDouble, qVarbinary, vVarchar) ;
VALUES ("Sample String", 123.45, .T., DATE(), DATETIME(), "Sample Memo", 123.4512, 123, 123.45, 123.45, "Sample Varbinary", "Sample Varchar")

* Scatter the cursor to an object
SCATTER MEMO NAME loObject

LOCAL loJsonHandler, lcJson

* Create an instance of the JsonHandler class
loJsonHandler = CREATEOBJECT("JsonHandler")

* Serialize the object to JSON
lcJson = loJsonHandler.serialize(loObject)

IF loJsonHandler.nError = JS_FATAL_ERROR
    ? "Error during serialization: " + loJsonHandler.cErrorMsg
    RETURN
ENDIF

* Output the serialized JSON string
? "Serialized JSON:"
? lcJson

LOCAL loParsedObject

* Parse the JSON string back to an object
loParsedObject = loJsonHandler.deserialize(lcJson)

IF loJsonHandler.nError = JS_FATAL_ERROR
    ? "Error during deserialization: " + loJsonHandler.cErrorMsg
    RETURN
ENDIF

* Output the deserialized object properties
? "Deserialized Object:"
? "String: " + loParsedObject.cString
? "Number: " + TRANSFORM(loParsedObject.nNumber)
? "Boolean: " + TRANSFORM(loParsedObject.lBoolean)
? "Date: " + IIF(ISNULL(loParsedObject.dDate), "null", DTOC(loParsedObject.dDate))
? "DateTime: " + IIF(ISNULL(loParsedObject.tDateTime), "null", TTOC(loParsedObject.tDateTime))
? "Memo: " + loParsedObject.mMemo
? "Currency: " + TRANSFORM(loParsedObject.yCurrency)
? "Integer: " + TRANSFORM(loParsedObject.iInteger)
? "Float: " + TRANSFORM(loParsedObject.fFloat)
? "Double: " + TRANSFORM(loParsedObject.dDouble)
? "Varbinary: " + TRANSFORM(loParsedObject.qVarbinary)
? "Varchar: " + loParsedObject.vVarchar

* Verify the results
IF loParsedObject.cString == "Sample String" AND ;
   loParsedObject.nNumber == 123.45 AND ;
   loParsedObject.lBoolean == .T. AND ;
   DTOC(loParsedObject.dDate) == DTOC(DATE()) AND ;
   TTOC(loParsedObject.tDateTime) == TTOC(DATETIME()) AND ;
   loParsedObject.mMemo == "Sample Memo" AND ;
   loParsedObject.yCurrency == 123.45 AND ;
   loParsedObject.iInteger == 123 AND ;
   loParsedObject.fFloat == 123.45 AND ;
   loParsedObject.dDouble == 123.45 AND ;
   loParsedObject.qVarbinary == "Sample Varbinary" AND ;
   loParsedObject.vVarchar == "Sample Varchar"
    ? "The deserialized object matches the original object. Test passed ! "
ELSE
    ? "The deserialized object does not match the original object. Test failed ! "
ENDIF