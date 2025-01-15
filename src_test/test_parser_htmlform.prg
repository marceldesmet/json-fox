#INCLUDE json-fox.h
Do main WITH "debug"
CLEAR

loParser = CREATEOBJECT("Parser")
loStringify = CREATEOBJECT("Stringify")
loJsonHandler = CREATEOBJECT("JsonHandler")

* Parse the JSON
lcFormJson =  FILETOSTR("C:/Webconnectionprojects/WebNode/devtools/json-fox/json-samples/MyHtmlForm.json") 

loFormObject = loParser.ParseJson(lcFormJson)
SET STEP ON 
IF VARTYPE(loFormObject) <> "O" 
	? "Last parser error message " + loParser.cErrorMsg
	loObject = loTokenizer.tokenize(lcTypeJson)
	IF VARTYPE(loObject) <> "O"
		? "Tokenize error for " + lcFormJson
		? "Last error message " + loTokenizer.cErrorMsg
	ELSE 
		? "Tokenize ok ! for " + lcFormJson
		? "Result write to file token-content.txt " 
	ENDIF 
	* Dump tokens to text file to test
	dumpTokensToFile(loFormObject)
	RETURN 
ELSE 
	? "* Parse ok "
	? "See UpdatedMyHtmlForm.json for comparaison" 
ENDIF 
 
* Save the modified object back to a file
loStringify.saveToFile("C:/Webconnectionprojects/WebNode/devtools/json-fox/json-samples/UpdatedMyHtmlForm.json", loFormObject,.T.)

ON ERROR 