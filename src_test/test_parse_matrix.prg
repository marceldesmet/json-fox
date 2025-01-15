#INCLUDE json-fox.h
Do main with "loaddep"
CLEAR

*-* SET COVERAGE TO C:/Webconnectionprojects/WebNode/devtools/json-fox/classes/jsonfox.log
LOCAL loTokenizer, lcJson, laTokens
PUBLIC loParseObject,loObject

* Create an instance of the Tokenizer class
loParser = CREATEOBJECT("Parser")
loTokenizer = CREATEOBJECT("Tokenizer")
loStringify = CREATEOBJECT("Stringify")

* Load the JSON file with complex and 2D arrays 
lcArrayJson = FILETOSTR("C:/Webconnectionprojects/WebNode/devtools/json-fox/json-samples/Testarraysmatrix.json") 

loObject = loTokenizer.tokenize(lcArrayJson)
IF VARTYPE(loObject) <> "O" 
	? "Testarraysmatrix Tokenize error"
	? loTokenizer.cErrormsg 
ELSE 
	? "Testarraysmatrix Tokenize ok !"
	loTokenizer.dumpTokensToFile(loObject,"Testarraysmatrix.err")
ENDIF 

loParseObject = loParser.ParseJson(lcArrayJson)
IF VARTYPE(loParseObject) <> "O" 
	? "Testarraysmatrix Parser error "
	? loParser.cErrormsg 
ELSE 
	? "Testarraysmatrix Parser ok ! "
ENDIF
* Save the modified object back to a file
? " Check UpdatedTestarraysmatrix.json for reverse build "

loStringify.saveToFile("C:/Webconnectionprojects/WebNode/devtools/json-fox/json-samples/UpdatedTestarraysmatrix.json", loParseObject,.T.)


