#INCLUDE json-fox.h
Do json_main with "loaddep"
CLEAR

*-* SET COVERAGE TO C:/Webconnectionprojects/WebNode/devtools/json-fox/classes/jsonfox.log
LOCAL loTokenizer, lcJson, laTokens
PUBLIC loParseObject,loObject

* Create an instance of the Tokenizer class
loParser = CREATEOBJECT("Parser")
loTokenizer = CREATEOBJECT("Tokenizer")
loStringify = CREATEOBJECT("Stringify")

* Load the JSON file with complex and 2D arrays 
lcArrayJson = FILETOSTR("C:/Webconnectionprojects/WebNode/devtools/json-fox/json-samples/Testarrays2.json") 

loObject = loTokenizer.tokenize(lcArrayJson)
IF VARTYPE(loObject) <> "O" 
	? "Tokenize error"
	? loTokenizer.cErrormsg 
ELSE 
	? "Tokenize ok !"
	loTokenizer.dumpTokensToFile(loObject,"Testarrays2.err")
ENDIF 

loParseObject = loParser.ParseJson(lcArrayJson)
IF VARTYPE(loParseObject) <> "O" 
	? "Parser error "
	? loParser.cErrormsg 
ELSE 
	? "Parser ok ! "
ENDIF
* Save the modified object back to a file
loStringify.saveToFile("C:/Webconnectionprojects/WebNode/devtools/json-fox/json-samples/UpdatedTestarrays.json", loParseObject,.T.)


