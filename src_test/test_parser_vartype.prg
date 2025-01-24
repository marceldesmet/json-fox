#INCLUDE json-fox.h
Do json_main with "loaddep"
CLEAR

loParser = CREATEOBJECT("Parser")
loStringify = CREATEOBJECT("Stringify")

* Parse the JSON
lcTypeJson =  FILETOSTR("C:/Webconnectionprojects/WebNode/devtools/json-fox/json-samples/VarTypeTest.json") 

loTypeObject = loParser.ParseJson(lcTypeJson)
* Modify the object (example: change the title)

IF VARTYPE(loTypeObject) <> "O" 
	* Print to screen the 100 first step of the collection 
	? "Last parser error message " + loParser.cErrorMsg
	loObject = loTokenizer.tokenize(lcTypeJson)
	IF VARTYPE(loObject) <> "O"
		? "Tokenize error for " + lcTypeJson
		? "Last error message " + loTokenizer.cErrorMsg
	ELSE 
		? "Tokenize ok ! for " + lcTypeJson
		? "Result write to file token-content.txt " 
	ENDIF 
	dumpTokensToFile(loObject)
	RETURN 
ENDIF 


IF VARTYPE(loTypeObject.name) == "C" .AND. loTypeObject.name == "John Doe"
	? "Parser Char TypeTest ok"
ELSE 
	? "Error ! - Parser Char TypeTest"
ENDIF
IF VARTYPE(loTypeObject.age) == "N" .AND. loTypeObject.age == 30
	? "Parser Integer TypeTest ok"
ELSE 
	? "Error ! - Parser Numeric TypeTest"
ENDIF
IF VARTYPE(loTypeObject.weight) == "N" .AND. loTypeObject.weight == 80.5
	? "Parser Numeric TypeTest ok"
ELSE 
	? "Error ! - Parser Numeric TypeTest"
ENDIF
IF VARTYPE(loTypeObject.isStudent) == "L" .AND. loTypeObject.isStudent == .F.
	? "Parser Logical TypeTest ok"
ELSE 
	? "Error ! - Parser Logical TypeTest"
ENDIF
SET DATE TO DMY
IF VARTYPE(loTypeObject.graduationDate) == "D" .AND. loTypeObject.graduationDate == CTOD("15/05/23")
	? "Parser Date TypeTest ok"
ELSE 
	? "Error ! - Parser Date TypeTest"
ENDIF
IF ISNULL(loTypeObject.nullValue)
	? "Parser Null TypeTest ok"
ELSE 
	? "Error ! - Parser Null TypeTest"
ENDIF

* Save the modified object back to a file
loStringify.saveToFile("C:/Webconnectionprojects/WebNode/devtools/json-fox/json-samples/UpdatedVarTypeTest.json", loTypeObject,.T.)

SET DATE TO FRENCH 
ON ERROR 