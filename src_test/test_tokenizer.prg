#INCLUDE json-fox.h
Do json_main with "loaddep"
CLEAR

*-* SET COVERAGE TO C:/Webconnectionprojects/WebNode/devtools/json-fox/classes/jsonfox.log
LOCAL loTokenizer, lcJson, laTokens
LOCAL loParseObject,loObject

* Create an instance of the Tokenizer class
loParser = CREATEOBJECT("Parser")
loTokenizer = CREATEOBJECT("Tokenizer")
loStringify = CREATEOBJECT("Stringify")

* Load the JSON file
lcJson =      FILETOSTR("C:/Webconnectionprojects/WebNode/devtools/json-fox/json-samples/MyHtmlForm.json")
lcArrayJson = FILETOSTR("C:/Webconnectionprojects/WebNode/devtools/json-fox/json-samples/Testarrays.json") 


* Print to screen the 100 first step of the collection 
loObject = loTokenizer.tokenize(lcJson)

IF LOWER(loObject.Item(3)) <> "title"  .OR. loObject.Count <> 374 
	? "Tokenize error see file MyHtmlForm.err"
	loTokenizer.dumpTokensToFile(loObject,"MyHtmlForm.err")
	RETURN 
ELSE 
	? "Ok for " + TRANSFORM(loObject.Count) + " tokens "
	? "Try to parse to a object now "
ENDIF 

loParseObject = loParser.ParseJson(lcJson)
IF VARTYPE(loObject) <> "O" 
	? "Parse error"
	? loParser.cErrormsg 
ENDIF 
* Save the modified object back to a file
loStringify.saveToFile("C:/Webconnectionprojects/WebNode/devtools/json-fox/json-samples/UpdatedMyHtmlForm.json", loParseObject,.T.)
 
  
* Parse the JSON
loObject = loParser.ParseJson(lcArrayJson)

*Expected null and error message
IF loParser.cerrormsg = "Multi-dimensional arrays are not supported"
	? "Tokenizer forwarding errors ok..!"
ELSE 
	? "Error ! - Tokenizer Error forwarding"
ENDIF 

IF ISNULL(loObject)
	? "Parser .NULL. return if error ok !" 
ELSE 
	? "Error ! - Parser .NULL. return if error" 
ENDIF 
  
* Parse the JSON
loObject = loParser.ParseJson(lcJson)

IF VARTYPE(loObject)="O"
	IF ALEN(loObject.Fields.Item,1) <> 8
		? "Error ! - Parser return ok but fields count is not " 
	ELSE 
		? "Fields count ok!" 
	ENDIF 
	 
	* Modify the object (example: change the title)
	loObject.title = "Updated User Registration"

	* Save the modified object back to a file
	loStringify.saveToFile("C:/Webconnectionprojects/WebNode/devtools/json-fox/json-samples/UpdatedMyHtmlForm.json", loObject,.T.)

	* Parse the JSON
	lcUpdatedJson = FILETOSTR("C:/Webconnectionprojects/WebNode/devtools/json-fox/json-samples/UpdatedMyHtmlForm.json")
	loObject = loParser.ParseJson(lcUpdatedJson)

	* Modify the object (example: change the title)
	IF loObject.title = "Updated User Registration"
			
	ELSE 
	
	ENDIF 
ELSE 
	? "Error ! parsing object from MyHtmlForm.json"
	RETURN 
ENDIF 


* Parse the JSON
loUpdatedObject = loParser.ParseJson(lcUpdatedJson)
IF loObject.title == loUpdatedObject.title
	? "Stringify MyHymlForm ok"
ELSE 
	? "Error ! - Stringify MyHtmlForm"
ENDIF 



