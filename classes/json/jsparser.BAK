#INCLUDE C:\Webconnectionprojects\WebNode\devtools\json-fox\json-fox.h

define class Parser as jscustom
	tokens = .null.
	currentIndex = 0
	nArrayLevel = 0 		&& Track the array level for error checking

	function parseJson(tcInput)
		local loTokenizer, loObject
		loTokenizer = createobject("Tokenizer")
		this.tokens = loTokenizer.tokenize(tcInput)
		this.currentIndex = 1
		loObject = this.parseObject()
		return loObject
	endfunc

	function parseObject()
		
		local loObject, lcToken, lcKey, lvValue, lcType, lcProperty, lcValuetype

		* Create an empty object
		loObject = createobject("Empty")
		* Skip '{' token begins a object
		this.currentIndex = this.currentIndex + 1  && Skip '{'

		do while this.currentIndex <= this.tokens.count .and. this.tokens.item(this.currentIndex) != JS_RBRACE
			* Next token is a string property name
			lcType = this.tokens.item(this.currentIndex)
			this.currentIndex = this.currentIndex + 1  && Skip type token set for properties and values
			if lcType != JS_STRING
				* #TODO Fatal Error - Expected a string property name
				exit
			else
				lcProperty = this.tokens.item(this.currentIndex)
				this.currentIndex = this.currentIndex + 1  && Skip Property Name
			endif
			if this.tokens.item(this.currentIndex) == JS_COLON
				this.currentIndex = this.currentIndex + 1  && Skip ':'
			else
				* #TODO Fatal Error - Expected a colon
				exit
			endif

			lcToken = this.tokens.item(this.currentIndex)
			* Don't skip the currentindex for recursive call to parseObject() or parseArray()

			do case
				case lcToken == JS_LBRACE
					lvValue = this.parseObject()
				case lcToken == JS_LBRACKET
					lvValue = this.parseArray(THIS.nArrayLevel + 1)
				otherwise
					* Value of the property is not a array or object we now expect a valuetype
					this.currentIndex = this.currentIndex + 1
					lcValuetype = lcToken

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
							* #TODO Fatal Error - Expected a colon
							exit
					endcase

			endcase
			
			* Add the property to the object
			addproperty(loObject, lcProperty, lvValue)
			this.currentIndex = this.currentIndex + 1

			* Exit if we have reached the end of the tokens
			if this.currentIndex > this.tokens.count
				exit
			endif

			if this.tokens.item(this.currentIndex) == JS_COMMA && Skip ',' for next property
				this.currentIndex = this.currentIndex + 1
			endif

		enddo

		this.currentIndex = this.currentIndex + 1  && Skip '}'
		return loObject

	endfunc

	function parseArray(tnIndentLevel)

		THIS.nArrayLevel = tnIndentLevel	&& Track the array level for error checking
		
		local loArray, lcToken, lvValue
		
		* Create an empty array object
		loArray = createobject("Collection")
		this.currentIndex = this.currentIndex + 1  && Skip '['

		do while this.currentIndex <= this.tokens.count .and. this.tokens.item(this.currentIndex) != JS_RBRACKET

			lcToken = this.tokens.item(this.currentIndex)

			do case
				case lcToken == JS_LBRACE
					lvValue = this.parseObject()
				case lcToken == JS_LBRACKET
					lvValue = this.parseArray(THIS.nArrayLevel + 1)
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
			endcase

			loArray.add(lvValue)
			this.currentIndex = this.currentIndex + 1

			* Exit if we have reached the end of the tokens
			if this.currentIndex > this.tokens.count
				exit
			endif

			* Skip comma
			if this.tokens.item(this.currentIndex) == JS_COMMA  
				this.currentIndex = this.currentIndex + 1
			endif

		enddo
		* Skip ']'
		this.currentIndex = this.currentIndex + 1 

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

enddefine
