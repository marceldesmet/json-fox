#INCLUDE json-fox.h
Do json_main with "loaddep"
CLEAR

* IN debug mode we have a set step on 
goApp.lDebugMode = .F. 


* Run the tests
Test_jsCustom()
Test_jsCollection()


	
* Test procedure for jsCustom class
PROCEDURE Test_jsCustom

    LOCAL loCustom
    loCustom = CREATEOBJECT("jsCustom")

    * Simulate an error
    loCustom.Error(1001, "TestMethod", 10) 

    * Check if the error properties are set correctly
    IF loCustom.lError AND loCustom.nError == 1001  AND loCustom.cErrorMethod == "TestMethod"
        ? "jsCustom Error Handling Test Passed"
    ELSE
        ? "jsCustom Error Handling Test Failed"
    ENDIF

    * Test SetError method
    SetError(loCustom,"Custom error message", 2002)

    * Check if the error properties are updated correctly
    IF loCustom.lError AND loCustom.nError == 2002 AND loCustom.cErrorMsg == "Custom error message"
        ? "jsCustom SetError Method Test Passed"
    ELSE
        ? "jsCustom SetError Method Test Failed"
    ENDIF
ENDPROC

* Test procedure for jsCollection class
PROCEDURE Test_jsCollection
    LOCAL loCollection
    loCollection = CREATEOBJECT("jsCollection")

    * Simulate an error
    loCollection.Error(3003, "TestMethod", 20)

    * Check if the error properties are set correctly
    IF loCollection.lError AND loCollection.nError == 3003 AND loCollection.cErrorMethod == "TestMethod"
        ? "jsCollection Error Handling Test Passed"
    ELSE
        ? "jsCollection Error Handling Test Failed"
    ENDIF

    * Test SetError method
    SetError(loCollection,"Another custom error message", 4004)

    * Check if the error properties are updated correctly
    IF loCollection.lError AND loCollection.nError == 4004 AND loCollection.cErrorMsg == "Another custom error message"
        ? "jsCollection SetError Method Test Passed"
    ELSE
        ? "jsCollection SetError Method Test Failed"
    ENDIF
ENDPROC
