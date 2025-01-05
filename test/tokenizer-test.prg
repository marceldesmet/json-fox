#INCLUDE C:\Webconnectionprojects\WebNode\devtools\json-fox\json-fox.h

*-* SET COVERAGE TO C:/Webconnectionprojects/WebNode/devtools/json-fox/classes/jsonfox.log

CLEAR
* Path is relative to the project root
SET PROCEDURE TO classes\json\jsTokenizer ADDITIVE
SET PROCEDURE TO classes\json\jsParser ADDITIVE
SET PROCEDURE TO classes\json\jsStringify ADDITIVE
SET PROCEDURE TO classes\bases\jsmessages ADDITIVE
SET PROCEDURE TO classes\bases\jsbases ADDITIVE


LOCAL loTokenizer, lcJson, laTokens

* Create an instance of the Tokenizer class
loParser = CREATEOBJECT("Parser")
loTokenizer = CREATEOBJECT("Tokenizer")
loStringify = CREATEOBJECT("Stringify")

* Load the JSON file
lcJson = FILETOSTR("C:/Webconnectionprojects/WebNode/devtools/json-fox/test/MyHtmlForm.json")
lcTypeJson = FILETOSTR("C:/Webconnectionprojects/WebNode/devtools/json-fox/test/TypeTest.json") 

* Print to screen the 100 first step of the collection 
loObject = loTokenizer.tokenize(lcJson)

*-*FOR lnI = 240 TO 270
*-*	?? TRANSFORM(lnI) + loObject.Item(lnI) + " ... "
*-*ENDFOR 
 
IF LOWER(loObject.Item(3)) <> "title" .OR. loObject.Count <> 367 
	? "Tokenize error"
ENDIF 

lcArrayJson = FILETOSTR("C:/Webconnectionprojects/WebNode/devtools/json-fox/test/testarrays.json") 

SET STEP ON 
* Parse the JSON
loObject = loParser.ParseJson(lcArrayJson)


* Parse the JSON
loObject = loParser .ParseJson(lcJson)

* Modify the object (example: change the title)
loObject.title = "Updated User Registration"

* Save the modified object back to a file
loStringify.saveToFile("C:/Webconnectionprojects/WebNode/devtools/json-fox/classes/test/UpdatedMyHtmlForm.json", loObject,.T.)

 
* Parse the JSON
loObject = loParser.ParseJson(lcTypeJson)
* Modify the object (example: change the title)

? TRANSFORM(loObject.name)
? TRANSFORM(loObject.age)
? TRANSFORM(loObject.weight)
? TRANSFORM(loObject.isStudent)
? TRANSFORM(loObject.graduationDate)
? TRANSFORM(loObject.nullValue)


* Save the modified object back to a file
loStringify.saveToFile("C:/Webconnectionprojects/WebNode/devtools/json-fox/classes/UpdatedMyHtmlForm.json", loObject,.T.)


