#INCLUDE json-fox.h
Do main with "loaddep"
CLEAR

loParser = CREATEOBJECT("Parser")
loStringify = CREATEOBJECT("Stringify")

* Parse the JSON
lcScriptJson =  FILETOSTR("C:/Webconnectionprojects/WebNode/devtools/json-fox/json-samples/Scripts.json") 
loJsonHandler = CREATEOBJECT('JsonHandler')

loTypeObject = loParser.ParseJson(lcScriptJson)
* Modify the object (example: change the title)
 
IF VARTYPE(loTypeObject) <> "O" 
	* Print to screen the 100 first step of the collection 
	? "Last parser error message " + loParser.cErrorMsg
	loTokenizer = CREATEOBJECT("Tokenizer")
	loTokens = loTokenizer.tokenize(lcScriptJson)
	IF VARTYPE(loTokens) <> "O"
		? "Tokenize error for " + lcScriptJson
		loTokenizer.tokenize(lcScriptJson,"script_content_tokenizer.err")
		? "Last error message " + loTokenizer.cErrorMsg
		? "See file : " + "script_content_tokenizer.err"
	ELSE 
		? "Tokenize returns a object ok ! for " + lcScriptJson
		? "Last error message " + loTokenizer.cErrorMsg
		loParser.dumpTokensToFile(loTokens,"script_content_tokenizer.err")

		? "See file : " + "script_content_tokenizer.err"
	ENDIF 
	RETURN 
ELSE 
	? "Parse is ok ! "
	IF loParser.lError = .T. 
		 ? "But there are errors : " + loParser.cErrorMsg
		 loParser.dumpTokensToFile(loTypeObject,"script_content_tokenizer.err")
		? "See : " + "script_content_tokenizer.err"
	ELSE 
		? loTypeObject.name
		? loTypeObject.description
		EXECSCRIPT(loTypeObject.script)
	ENDIF 
ENDIF 

