#INCLUDE json-fox.h

* Version 1.3.0.

DEFINE CLASS jsfactory AS jscollection 

	lAddObjecttoCollection = .T.

	* In the context of programming languages and compilers, 
	* a token is a basic unit of code that the compiler or interpreter recognizes. 
	* Tokens are generated during the lexical analysis phase of compilation.
	* The lexical analyzer breaks the source code into a series of tokens
	* Here the token could be a json object... 
	* Token is model.users == make_model("users") 
    PROCEDURE make(tvToken,tvSchema)

		LOCAL loObject,;
			lcClass
			
		loObject = .NULL.
	
		DO CASE 
			CASE VARTYPE(tvToken) = "C" 
				IF tlNewInstance .OR. THIS.GETKEY(lower(tvToken)) = 0
					loObject =  THIS.Create(tvToken,tvSchema)
					IF VARTYPE(loObject)="O"
						* Save the factory name to create new instance of the same model
						IF THIS.lAddModeltoCollection .AND. !loModel.lUnPersistentModel
							THIS.ADD(loObject,lower(tvToken))
						ENDIF
						RETURN loObject
					ELSE
						RETURN .NULL.
					ENDIF
				ELSE
					loObject =  THIS.Create(tvToken,tvSchema)
					RETURN loObject
				ENDIF

		ENDCASE 
		RETURN .Null.

	ENDPROC

	PROCEDURE Create(tvToken,tvSchema)
		*-* To do parse Json and return the object 
		
	ENDPROC

ENDDEFINE
