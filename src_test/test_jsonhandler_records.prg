#INCLUDE json-fox.h
Do main with "loaddep"
CLEAR

* IN debug mode we have a set step on 
goApp.lDebugMode = .F. 


* Try with a cursor 
oCursor = oFactory.Make('AllfieldTYpes')

loData = oCursor.BuildSampleREcord()

LOCAL lcAlias 
lcAlias = oCursor.cAlias 	    
* Insert sample data into the cursor

LOCAL loJsonHandler, lcJson

* Create an instance of the JsonHandler class
loJsonHandler = CREATEOBJECT("JsonHandler")

* Serialize the object to JSON
lcDataJson = loJsonHandler.serialize(loData)

IF loJsonHandler.nError = JS_FATAL_ERROR
    ? "Error during serialization: " + loJsonHandler.cErrorMsg
    RETURN
ENDIF

* Output the serialized JSON string
? "Serialized JSON :"
?  lcDataJson

LOCAL loParsedObject

* Parse the JSON string back to an object
loParsedObject = loJsonHandler.deserialize(lcDataJson)

IF loJsonHandler.nError = JS_FATAL_ERROR
    ? "Error during deserialization: " + loJsonHandler.cErrorMsg
    RETURN
ENDIF

* Output the deserialized object properties
? "* Deserialized Object:"
? "String: " + loParsedObject.cString + " - " + IIF(loParsedObject.cString == ALLTRIM(loData.cString),"Ok","Error !")
? "Number: " + TRANSFORM(loParsedObject.nNumber) + " - " + IIF(loParsedObject.nNumber == loData.nNumber,"Ok","Error !")
? "Boolean: " + TRANSFORM(loParsedObject.lBoolean)+ " - " + IIF(loParsedObject.lBoolean == loData.lBoolean,"Ok","Error !")
? "Date: " + IIF(ISNULL(loParsedObject.dDate), "null", DTOC(loParsedObject.dDate)) + " - " + IIF(loParsedObject.dDate == loData.dDate,"Ok","Error !")
? "DateTime: " + IIF(ISNULL(loParsedObject.tDateTime), "null", TTOC(loParsedObject.tDateTime))+ " - " + IIF(loParsedObject.tDateTime == loData.tDateTime,"Ok","Error !")
? "Memo: " + loParsedObject.mMemo + " - " + IIF(loParsedObject.mMemo == loData.mMemo,"Ok","Error !")
? "Integer: " + TRANSFORM(loParsedObject.iInteger)+ " - " + IIF(loParsedObject.iInteger == loData.iInteger,"Ok","Error !")
? "Float: " + TRANSFORM(loParsedObject.fFloat)+ " - " + IIF(loParsedObject.fFloat == loData.fFloat,"Ok","Error !")
? "Double: " + TRANSFORM(loParsedObject.dDouble)+ " - " + IIF( loParsedObject.dDouble == loData.dDouble,"Ok","Error !")
? "Varchar: " + loParsedObject.vVarchar+ " - " + IIF(loParsedObject.vVarchar == loData.vVarchar,"Ok","Error !")

* Verify the results
IF loParsedObject.cString == ALLTRIM(loData.cString) AND ;
   loParsedObject.nNumber == loData.nNumber AND ;
   loParsedObject.lBoolean == loData.lBoolean AND ;
   loParsedObject.dDate == loData.dDate AND ;
   loParsedObject.tDateTime == loData.tDateTime AND ;
   loParsedObject.mMemo == loData.mMemo AND ;
   loParsedObject.iInteger == loData.iInteger AND ;
   loParsedObject.fFloat == loData.fFloat AND ;
   loParsedObject.dDouble == loData.dDouble AND ;
   loParsedObject.vVarchar == loData.vVarchar
    ? "* The deserialized object matches the original object. Test passed ! "
ELSE
    ? "* The deserialized object does not match the original object. Test failed ! "
ENDIF