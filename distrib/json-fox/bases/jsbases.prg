#INCLUDE json-fox.h

* Version 1.2.0.

* The baseCustom class is a custom class in Visual FoxPro designed to handle error management and reporting. 
* It includes properties and methods to manage errors that occur within the class or its subclasses.
DEFINE CLASS jsCustom AS CUSTOM 			    && relation is a lightware object for custom building but we need custom for 

	name = "Baseclass"
		
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

	* End of <- Common error handling routine 

ENDDEFINE

* The baseCollection class is a collection class in Visual FoxPro designed to handle error management and reporting. 
* It includes properties and methods to manage errors that occur within the class or its subclasses.
DEFINE CLASS jsCollection AS Collection 
 
 	name = "Basecollection" 
 	
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

    * End of <- Common error handling routine 

ENDDEFINE

DEFINE CLASS jsform AS form 

  	* Common error handling routine ->
	
	* These properties and methods are to add to all non child of this classes 
    * Properties for error handling
    lSendError = .T.                            && Flag to determine if errors should be sent
    oSendError = .NULL. 

    nError = 0                                  && Numeric code of the last error
    lError = .F.                                && Flag to indicate if an error has occurred
    cErrorMsg = "Message unknow"                && Stores the last error message
	cErrorMethod = ""
   
    ColorSource = 5 
    zoombox = .T. 
    borderstyle = 3 
    showwindows = 2               && As top level form
    viewformat =  1.618           &&  16:9 = 1.78 , 1:1 = 1 , Nombre d'or = 1.618
    minWith = 612
    viewsize = 1

    FUNCTION Init 
        * Set form size to viewformat 
        THIS.Width = THIS.MinWidth
        * Set form size to viewformat
        THIS.MinHeight = INT(THIS.MinWidth / THIS.ViewFormat)
    ENDFUNC 

    * Error handling procedure
	PROCEDURE Error(nError, cMethod, nLine)
        ErrorHandler(THIS,MESSAGE(),nError, cMethod, nLine)
    ENDPROC

  
ENDDEFINE 
