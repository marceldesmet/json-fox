#INCLUDE json-fox.h

* Version 1.1.0.

define class Parser as jscustom
	tokens = .null.
	currentIndex = 0
	nArrayLevel = 0 		&& Track the array level for error checking
	name = "Parser"
	Unicode  = .F. 			&& Set to .T. to decode Unicode escape sequences in the parsed object
	HandleComments = .F. 	&& Set to .T. to remove comments from the JSON string
	function parseJson(tcInput)

		local loTokenizer, loObject, loUnicodeObject


		if vartype(tcInput)<> T_CHARACTER .or. empty(tcInput)
			SetError(THIS,"Wrong input string",JS_FATAL_ERROR)
			return .null.
		endif

		IF THIS.HandleComments = .T. 
			* Remove comments
			tcInput = this.removeComments(tcInput)
		ENDIF

		* Clear some special characters
		tcInput = chrtran(tcInput, chr(9),'')			&& Tab
		tcInput = chrtran(tcInput, chr(10),'')			&& Linefeed
		tcInput = chrtran(tcInput, chr(13),'')			&& Carriage return
		* We don't remove space because they are part of the JSON string
		

		loTokenizer = createobject("Tokenizer")
		this.tokens = loTokenizer.tokenize(tcInput)

		if loTokenizer.nError = JS_FATAL_ERROR .or. vartype(this.tokens) <> T_OBJECT
			SetError(THIS,loTokenizer.cerrormsg,JS_FATAL_ERROR)
			return .null.
		endif

		* Setup for parsing
		this.currentIndex = 1
		* this.nArrayLevel = 0    #TODO Implement support for multi-dimensional arrays
		this.ResetError()

		loObject = this.parseObject()

		if this.nError = JS_FATAL_ERROR
			SetError(THIS,this.cerrormsg,JS_FATAL_ERROR)
			return .null.
		endif

		* Decode Unicode escape sequences in the parsed object
		IF Unicode = .T. 
			loUnicodeObject = createobject("JsonTranslateUnicode")
			loObject = loUnicodeObject.DecodeUnicodeInObject(loObject)
		endif 
		
		return loObject

	endfunc

	function parseObject()

		local loObject, lcToken, lcKey, lvValue, lcType, lcProperty, lcValuetype

		* Check where we are in the token list
		lcToken = this.tokens.item(this.currentIndex)

		* '{' token begins a object
		if lcToken != JS_LBRACE
			SetError(THIS,"Expected a '{' at current index " + transform(this.currentIndex),JS_FATAL_ERROR)
			RETURN .NULL.
		endif

		* Create an empty object
		loObject = createobject("Empty")

		* Check for empty object
		if this.tokens.item(this.currentIndex+1) == JS_RBRACE
			this.currentIndex = this.currentIndex + 2  && Skip '{' and '}'
			return loObject
		endif 

		this.currentIndex = this.currentIndex + 1  && Skip '{'

		do while this.currentIndex <= this.tokens.count .and. this.tokens.item(this.currentIndex) != JS_RBRACE
			* Next token is a string property name
			lcType = this.tokens.item(this.currentIndex)
			if lcType != JS_STRING
				SetError(THIS,"Expected a string property name",JS_FATAL_ERROR)
				exit
			else
				this.currentIndex = this.currentIndex + 1  		&& Skip type token set for properties and values
				lcProperty = this.tokens.item(this.currentIndex)
				this.currentIndex = this.currentIndex + 1  		&& Next token is a colon
			endif
			if this.tokens.item(this.currentIndex) == JS_COLON
				this.currentIndex = this.currentIndex + 1  		 && Skip ':'
			else
				SetError(THIS,"Expected a colon ':' at current index " + transform(this.currentIndex),JS_FATAL_ERROR)
				exit
			endif

			lcToken = this.tokens.item(this.currentIndex)
			* Don't skip the currentindex for recursive call to parseObject() or parseArray()

			do case
				case lcToken == JS_LBRACE
					lvValue = this.parseObject()
				case lcToken == JS_LBRACKET
					lvValue = this.parseArray(this.nArrayLevel + 1)
				otherwise
					* Value of the property is not a array or object we now expect a valuetype
					lcValuetype = lcToken
					this.currentIndex = this.currentIndex + 1  && Skip the valuetype token

					do case
						case lcValuetype == JS_BOOLEAN
							lvValue = this.tokens.item(this.currentIndex)
							if lower(lvValue) == "true"
								lvValue = .t.
							else
								lvValue = .f.
							endif
						case lcValuetype == JS_DATE
							lvValue = this.parseDate(this.tokens.item(this.currentIndex))
						case lcValuetype == JS_NULL
							lvValue = .null.
						case lcValuetype == JS_NUMERIC
							lvValue = val(this.tokens.item(this.currentIndex))
						case lcValuetype == JS_STRING
							lvValue = this.tokens.item(this.currentIndex)
						otherwise
							SetError(THIS,"Expected a valuetype not " + lcValuetype ,JS_FATAL_ERROR)
							exit
					endcase
					* Skip the value token
					this.currentIndex = this.currentIndex + 1

			endcase

			* Add the property and value to the object
			addproperty(loObject, lcProperty, lvValue)

			lcToken = this.tokens.item(this.currentIndex)

			if lctoken == JS_COMMA && Skip ',' for next property
				this.currentIndex = this.currentIndex + 1
			else
				* Here we have reached the end of the object
				IF lctoken != JS_RBRACE
					SetError(THIS,"Expected a '}' at current index " + transform(this.currentIndex),JS_FATAL_ERROR)
				ENDIF
			endif

		enddo

		this.currentIndex = this.currentIndex + 1  	&& Skip '}'	

		return loObject

	endfunc

	function parseArray(tnIndentLevel)

		* #TODO Implement support native VFP arrays and multi-dimensional arrays
		* Track the array level for error checking
		this.nArrayLevel = tnIndentLevel

		local loArray, lcToken, lvValue

		lcToken = this.tokens.item(this.currentIndex)

		if lcToken != JS_LBRACKET
			SetError(THIS,"Expected a '[' at current index " + transform(this.currentIndex),JS_FATAL_ERROR)
			RETURN .NULL.
		endif

		* Create an empty array object
		loArray = createobject("Collection")

		* Check for empty array
		if this.tokens.item(this.currentIndex+1) == JS_RBRACKET
			this.currentIndex = this.currentIndex + 2  && Skip '[' and ']'
			return loArray
		endif
		
		* Ok skip '[' we have a array with values
		this.currentIndex = this.currentIndex + 1  && Skip '['

		do while this.currentIndex <= this.tokens.count .and. this.tokens.item(this.currentIndex) != JS_RBRACKET

			lcToken = this.tokens.item(this.currentIndex)

			do case
				case lcToken == JS_LBRACE
					lvValue = this.parseObject()
				case lcToken == JS_LBRACKET
					lvValue = this.parseArray(this.nArrayLevel + 1)
				otherwise
					this.currentIndex = this.currentIndex + 1  && ready  to get the value
					do case
						case lcToken == JS_BOOLEAN
							lvValue = this.tokens.item(this.currentIndex)
							if lower(lcValue) == "true"
								lcValue = .t.
							else
								lcValue = .f.
							endif
						case lcToken == JS_DATE
							lvValue = this.parseDate(this.tokens.item(this.currentIndex))
						case lcToken == JS_NULL
							lvValue = .null.
						case lcToken == JS_NUMERIC
							lvValue = val(this.tokens.item(this.currentIndex))
						case lcToken == JS_STRING
							lvValue = this.tokens.item(this.currentIndex)
						otherwise
							lvValue = lcToken
					endcase
					this.currentIndex = this.currentIndex + 1  && ready  to get the comma
			endcase

			loArray.add(lvValue)
			
			* Skip comma
			if this.tokens.item(this.currentIndex) == JS_COMMA
				this.currentIndex = this.currentIndex + 1
			else
				* Here we have reached the end of the array
				if this.tokens.item(this.currentIndex) != JS_RBRACKET
					SetError(THIS,"Expected a ']' at current index " + transform(this.currentIndex),JS_FATAL_ERROR)
				endif
			endif

		enddo

		this.currentIndex = this.currentIndex + 1 		&& Skip ']'
		return loArray

	endfunc

	function parseDate(lcDateString)
		local lnYear, lnMonth, lnDay, lnHour, lnMinute, lnSecond, lcDatePart, lcTimePart, lcTimeZonePart

		* Initialize default values
		lnYear = 0
		lnMonth = 0
		lnDay = 0
		lnHour = 0
		lnMinute = 0
		lnSecond = 0

		* Split the date string into date and time parts
		lcDatePart = left(lcDateString, 10)
		lcTimePart = ""
		lcTimeZonePart = ""

		if len(lcDateString) > 10
			lcTimePart = substr(lcDateString, 12, 8)
			if len(lcDateString) > 19
				lcTimeZonePart = substr(lcDateString, 20)
			endif
		endif

		* Parse the date part
		lnYear = val(substr(lcDatePart, 1, 4))
		lnMonth = val(substr(lcDatePart, 6, 2))
		lnDay = val(substr(lcDatePart, 9, 2))

		* Parse the time part
		if not empty(lcTimePart)
			lnHour = val(substr(lcTimePart, 1, 2))
			lnMinute = val(substr(lcTimePart, 4, 2))
			lnSecond = val(substr(lcTimePart, 7, 2))
		endif

		* Return DATETIME() if time part is present, otherwise return DATE()
		if not empty(lcTimePart)
			return datetime(lnYear, lnMonth, lnDay, lnHour, lnMinute, lnSecond)
		else
			return date(lnYear, lnMonth, lnDay)
		endif
	endfunc

	function removeComments(tcInput)
		local lcOutput, lnPos, lcChar, lcNextChar, lnLength, lbInString

		lcOutput = ""
		lnPos = 1
		lnLength = len(tcInput)
		lbInString = .F.

		do while lnPos <= lnLength
			lcChar = substr(tcInput, lnPos, 1)
			lcNextChar = iif(lnPos < lnLength, substr(tcInput, lnPos + 1, 1), "")

			if lcChar = '"' .and. (lnPos = 1 .or. substr(tcInput, lnPos - 1, 1) # "\")
				lbInString = !lbInString
			endif

			if !lbInString
				if lcChar = "/" .and. lcNextChar = "/"
					* Single-line comment
					do while lnPos <= lnLength .and. substr(tcInput, lnPos, 1) # chr(10)
						lnPos = lnPos + 1
					enddo
				else
					if lcChar = "/" .and. lcNextChar = "*"
						* Multi-line comment
						lnPos = lnPos + 2
						do while lnPos <= lnLength - 1 .and. (substr(tcInput, lnPos, 2) # "*/")
							lnPos = lnPos + 1
						enddo
						lnPos = lnPos + 1
					else
						lcOutput = lcOutput + lcChar
					endif
				endif
			else
				lcOutput = lcOutput + lcChar
			endif

			lnPos = lnPos + 1
		enddo

		return lcOutput
	
	endfunc

enddefine
