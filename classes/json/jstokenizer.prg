#INCLUDE C:\Webconnectionprojects\WebNode\devtools\json-fox\json-fox.h

* This component breaks the input JSON string into tokens.
* Each token represents a meaningful string element
* Such as special characters
*
*   {} for Object delimiters
*   [] for Array delimiters
*   : for key-value separator
*   , for value separator
*
*   White space and new lines are skipped
*
*   String values   : "value"
*   Numeric values  : 123 or -123 or 123.45
*   Boolean values  : true, false
*   Null values     : null
*   Date values     : "2025-01-15T13:45:30Z"
*                     "2025-01-15T13:45:30"
*                     "2025-01-15"
*                     "2025-01-15T13:45:30+02:00"
*
define class Tokenizer as jscustom
	tokens = .null.
	currentIndex = 0

	function tokenize(tcInput)

		local lcCurrentChar, lcString, i, lcValue
		lcValue = ""
		this.tokens = createobject("Collection")
		i = 1

		do while i <= len(tcInput)
			lcCurrentChar = substr(tcInput, i, 1)
			do case
				case empty(lcCurrentChar)
					* Skip whitespace
					i = i + 1
					loop
				case inlist(lcCurrentChar,CR,LF)
					* Skip new line
					i = i + 1
					loop
				case lcCurrentChar == '{'
					this.tokens.add(JS_LBRACE)
				case lcCurrentChar == '}'
					this.tokens.add(JS_RBRACE)
				case lcCurrentChar == '['
					this.tokens.add(JS_LBRACKET)
				case lcCurrentChar == ']'
					this.tokens.add(JS_RBRACKET)
				case lcCurrentChar == ':'
					this.tokens.add(JS_COLON)
				case lcCurrentChar == ','
					this.tokens.add(JS_COMMA)
				case lcCurrentChar == '"'
					lcValue = ""
					if this.isDate(lcCurrentChar, tcInput, @i, @lcValue)
						this.tokens.add(JS_DATE)
					else
						this.tokens.add(JS_STRING)
					endif
					i = i + 1
					lcCurrentChar = substr(tcInput, i, 1)
					do while lcCurrentChar != '"' and i <= len(tcInput)
						lcValue = lcValue + lcCurrentChar
						i = i + 1
						lcCurrentChar = substr(tcInput, i, 1)
					enddo
					this.tokens.add(lcValue)
				case this.isBoolean(lcCurrentChar, tcInput, @i, @lcValue)
					this.tokens.add(JS_BOOLEAN)
					this.tokens.add(lcValue)
				case this.isNumeric(lcCurrentChar, tcInput, @i, @lcValue)
					this.tokens.add(JS_NUMERIC)
					this.tokens.add(lcValue)
				case this.isnull(lcCurrentChar, tcInput, @i, @lcValue)
					this.tokens.add(JS_NULL)
					this.tokens.add(lcValue)
				otherwise
					this.tokens.add(lcCurrentChar)
			endcase
			i = i + 1
		enddo

		return this.tokens

	endfunc

	* There are only " values without quotes in JSON
	* Boolean, Numeric and Null values are not enclosed in quotes
	* So we need to check if the current character is part of a boolean, numeric or null value

	function isBoolean(char, tcInput, rnI, rcValue)
		do case
			case upper(char) == "T"
				rcValue = substr(tcInput, rnI, 4)
				if upper(rcValue) = "TRUE"
					rnI = rnI + 4
					return .t.
				else
					return .f.
				endif
			case upper(char) == "F"
				rcValue = substr(tcInput, rnI, 5)
				if upper(rcValue) = "FALSE"
					rnI = rnI + 5
					return .t.
				else
					return .f.
				endif
			otherwise
				return .f.
		endcase
	endfunc

	function isNumeric(char, tcInput, rnI, rcValue)
		if isdigit(char)
			local lcNumber, lcNextChar
			lcNumber = ""
			do while rnI <= len(tcInput) and (isdigit(substr(tcInput, rnI, 1)) or substr(tcInput, rnI, 1) == '.' or substr(tcInput, rnI, 1) == '-')
				lcNumber = lcNumber + substr(tcInput, rnI, 1)
				rnI = rnI + 1
			enddo
			rcValue = lcNumber
			return .t.
		else
			return .f.
		endif
	endfunc

	function isnull(char, tcInput, rnI, rcValue)
		* Implement logic to check if char is part of a null
		if upper(char) == "N" .and. upper(substr(tcInput, rnI, 4)) == "NULL"
			rnI =  rnI + 3
			rcValue = "null"
			return .t.
		else
			return .f.
		endif
	endfunc

	function isDate(char, tcInput, rnI, rcValue)
		if isdigit(substr(tcInput, rnI+1, 1)) .and. substr(tcInput, rnI+5, 1)="-"
			return .t.
		else
			return .f.
		endif
	endfunc



enddefine

