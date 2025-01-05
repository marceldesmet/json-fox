#INCLUDE C:\Webconnectionprojects\WebNode\devtools\json-fox\json-fox.h 

FUNCTION ErrorHandler(toCallingObject, tcMessage, tnError, tcMethod, tnLine)

    LOCAL lnError,lcMethod,lnLine,lcMessage 

    * This procedure handles errors that occur in the class.
    * Parameters:
    *   nError  - Numeric error code
    *   cMethod - Name of the method where the error occurred
    *   nLine   - Line number where the error occurred
    lnError = IIF(VARTYPE(tnError)==T_NUMERIC,tnError,0)
    lcMethod = IIF(VARTYPE(tcMethod)==T_CHARACTER,tcMethod,"")
    lnLine = IIF(VARTYPE(tnLine)==T_NUMERIC,tnLine,0)
	lcMessage = IIF(VARTYPE(tcMessage)==T_CHARACTER .AND. !EMPTY(tcMessage),tcMessage,MESSAGE())

    IF VARTYPE(goApp) = T_OBJECT 
    	IF PEMSTATUS(goApp,"ldebugmode",5) .AND. goApp.ldebugmode
        	SET STEP ON 
    	ENDIF 
	ENDIF 
	
	IF VARTYPE(toCallingObject) = T_OBJECT
		WITH toCallingObject
			.nError = lnError
			.lError = .T.
			.cErrorMsg = lcMessage
			.cErrorMethod = tcMethod
		ENDWITH 
	ENDIF 
	    
	lcMessage ="Error "+ TRANSFORM(lnError) +" in "+ lcMethod + " at line " + TRANSFORM(lnLine) + " - Last Message() "+  + lcMessage
    SET TEXTMERGE TO error.log ADDITIVE NOSHOW
    SET TEXTMERGE DELIMITERS TO "<<",">>"
    SET TEXTMERGE ON
    _PRETEXT = ''
    \<<TRANSFORM(DATETIME()) + " - " + lcMessage>>
    SET TEXTMERGE TO
    SET TEXTMERGE OFF

ENDFUNC

	    
FUNCTION SetError(toCallingObject,tcErrorMsg, tnError)
	
	LOCAL lnError,lcErrorMsg

    lnError = IIF(VARTYPE(tnError)==T_NUMERIC,tnError,0)
    lcErrorMsg = IIF(VARTYPE(tcErrorMsg)==T_CHARACTER,tcErrorMsg,"")
	
	IF VARTYPE(toCallingObject)=T_OBJECT
		        
	    IF PCOUNT() = 1                 && If only one parameter is passed reset the error flag
	        WITH toCallingObject
	        	.cerrormsg = ""
	        	.lerror = .F.
	        	.nError = 0
	        ENDWITH
			RETURN
	    ENDIF
	    
	    WITH toCallingObject
	    	.cerrormsg = lcErrorMsg
	    	.lerror = .T.
	        .nError = lnError		
		ENDWITH 
		
	ENDIF
	
ENDFUNC 

FUNCTION log(tcMessage,tcLogFile) 
	
	lcLogFile = IIF(!EMPTY(tcLogFile),tcLogFile,"messages.log")
	lcMessage = IIF(!EMPTY(tcMessage),tcMessage,"Unknow message")

    SET TEXTMERGE TO (lcLogFile) ADDITIVE NOSHOW
    SET TEXTMERGE DELIMITERS
    SET TEXTMERGE ON
    _PRETEXT = ''
    \<<lcMessage>>
    SET TEXTMERGE TO
    SET TEXTMERGE OFF

ENDFUNC 

