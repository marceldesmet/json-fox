#INCLUDE json-fox.h
Do main with "loaddep"
CLEAR

*-* SET COVERAGE TO C:/Webconnectionprojects/WebNode/devtools/json-fox/classes/jsonfox.log
LOCAL loTokenizer, lcJson, laTokens
LOCAL loParseObject,loObject

* Create an instance of the Tokenizer class
loParser = CREATEOBJECT("Parser")
loTokenizer = CREATEOBJECT("Tokenizer")
loStringify = CREATEOBJECT("Stringify")

* Load the JSON file with 3D array 
lcArrayJson = FILETOSTR("C:/Webconnectionprojects/WebNode/devtools/json-fox/json-samples/Testarrays.json") 

loObject = loTokenizer.tokenize(lcArrayJson)
IF VARTYPE(loObject) <> "O" 
	? "Tokenize error"
	? loTokenizer.cErrormsg 
ELSE 
	loTokenizer.dumpTokensToFile(loObject,"Testarrays.err")
ENDIF 

loParseObject = loParser.ParseJson(lcArrayJson)
IF VARTYPE(loParseObject) <> "O" 
	? "Parser error "
	? loParser.cErrormsg 
ENDIF
* Save the modified object back to a file
loStringify.saveToFile("C:/Webconnectionprojects/WebNode/devtools/json-fox/json-samples/UpdatedTestarrays.json", loParseObject,.T.)
