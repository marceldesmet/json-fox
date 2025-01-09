#INCLUDE json-fox.h
Do main with "loaddep"
CLEAR

*-* SET COVERAGE TO C:/Webconnectionprojects/WebNode/devtools/json-fox/classes/jsonfox.log
LOCAL loTokenizer, lcJson, laTokens

* Create an instance of the Tokenizer class
loParser = CREATEOBJECT("Parser")
loTokenizer = CREATEOBJECT("Tokenizer")
loStringify = CREATEOBJECT("Stringify")

* Load the JSON file
lcJson =      FILETOSTR("C:/Webconnectionprojects/WebNode/devtools/json-fox/test/MyHtmlForm.json")
lcArrayJson = FILETOSTR("C:/Webconnectionprojects/WebNode/devtools/json-fox/test/testarrays.json") 

* Print to screen the 100 first step of the collection 
loObject = loTokenizer.tokenize(lcJson)

IF LOWER(loObject.Item(3)) <> "title" .OR. loObject.Count <> 374 
	? "Tokenize error"
	dumpTokensToFile(loObject)
ENDIF 
 
loObject = loParser.ParseJson(lcJson)

* Save the modified object back to a file
loStringify.saveToFile("C:/Webconnectionprojects/WebNode/devtools/json-fox/test/UpdatedMyHtmlForm.json", loObject,.T.)
 
  
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
	IF loObject.Fields.Count <> 8
		? "Error ! - Parser return ok but fields count is not " 
	ELSE 
		? "Fields count ok!" 
	ENDIF 
	 
	* Modify the object (example: change the title)
	loObject.title = "Updated User Registration"

	* Save the modified object back to a file
	loStringify.saveToFile("C:/Webconnectionprojects/WebNode/devtools/json-fox/test/UpdatedMyHtmlForm.json", loObject,.T.)

	* Parse the JSON
	lcUpdatedJson = FILETOSTR("C:/Webconnectionprojects/WebNode/devtools/json-fox/test/UpdatedMyHtmlForm.json")
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

function dumpTokensToFile(toToken)
	local lnI, lcToken, lcValue, lnTokenCount, lcOutput

	if vartype(toToken) <> "O" .or. toToken.count = 0
		return .f.
	endif

	lcOutput = ""

	for lnI = 1 to toToken.count
		lcToken = toToken.item(lnI)
		IF lcToken = ","
			llNelwLine = .T. 
		ELSE
			llNelwLine = .F.
		ENDIF
		lcOutput = lcOutput + " - " + transform(lni) + ":" + lcToken  + IIF(llNelwLine,CHR(10),"*") 
	endfor

	strtofile(lcOutput, "token-content.txt")
	return .t.
endfunc

