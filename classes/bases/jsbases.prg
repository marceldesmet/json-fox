#INCLUDE C:\Webconnectionprojects\WebNode\devtools\json-fox\json-fox.h

* The baseCustom class is a custom class in Visual FoxPro designed to handle error management and reporting. 
* It includes properties and methods to manage errors that occur within the class or its subclasses.
DEFINE CLASS jsCustom AS CUSTOM 			    && relation is a lightware object for custom building but we need custom for 

	* Common error handling routine ->
	
	* These properties and methods are to add to all non child of this classes 
    * Properties for error handling
    lSendError = .T.                            && Flag to determine if errors should be sent
    oSendError = .NULL. 

    nError = 0                                  && Numeric code of the last error
 
    lError = .F.                                && Flag to indicate if an error has occurred
    cErrorMsg = "Message unknow"                && Stores the last error message
    cErrorMethod = ""
 
    * Error handling procedure
	PROCEDURE Error(nError, cMethod, nLine)
        ErrorHandler(THIS,MESSAGE(),nError, cMethod, nLine)
    ENDPROC

    FUNCTION SetError(tcErrorMsg, tnError)
        SetError(THIS,tcErrorMsg, tnError)
    ENDFUNC

	* End of <- Common error handling routine 

ENDDEFINE

* The baseCollection class is a collection class in Visual FoxPro designed to handle error management and reporting. 
* It includes properties and methods to manage errors that occur within the class or its subclasses.
DEFINE CLASS jsCollection AS Collection 
 
 	* Common error handling routine ->
	
	* These properties and methods are to add to all non child of this classes 
    * Properties for error handling
    lSendError = .T.                            && Flag to determine if errors should be sent
    oSendError = .NULL. 

    nError = 0                                  && Numeric code of the last error
 
    lError = .F.                                && Flag to indicate if an error has occurred
    cErrorMsg = "Message unknow"                && Stores the last error message
	cErrorMethod = ""
     
    * Error handling procedure
	PROCEDURE Error(nError, cMethod, nLine)
        ErrorHandler(THIS,MESSAGE(),nError, cMethod, nLine)
    ENDPROC

    FUNCTION SetError(tcErrorMsg, tnError)
        SetError(THIS,tcErrorMsg, tnError)
    ENDFUNC

	* End of <- Common error handling routine 

ENDDEFINE

