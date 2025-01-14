#INCLUDE json-fox.h

* Version 1.3.0.

define class Stringify as jscustom
	tokens = .null.
	currentIndex = 0
	name = "Stringify"
	unicode  = .f.
	IsJsonLdObject = .f.    	&& Handle JSON-LD objects with @context and @type properties
	rdFoxprofix = "object_"		&& Prefix Json object for FoxPro object properties with "rd_"

	function stringify(loObject, tlBeautify, tnIndentLevel)
		local lcJson, lcKey, lcValue, i, lcIndent, lcNewLine, lcIndentStep

		if vartype(tnIndentLevel) # T_NUMERIC
			tnIndentLevel = 0
		endif

		lcIndentStep = iif(tlBeautify, "    ", "")

		if tnIndentLevel > 0
			lcIndent = replicate(lcIndentStep, tnIndentLevel)
		else
			lcIndent = ""
		endif

		lcNewLine = iif(tlBeautify, chr(13) + chr(10), "")

		lcJson = "{" + lcNewLine

		* "U" loop for user properties only
		for i = 1 to amembers(laMembers, loObject, 1, "U")
			if this.IsJsonLdObject
				lcKey = lower(laMembers[i, 1])
				* THe key is formatted as this.rdFoxprofix + "context" or this.rdFoxprofix + "type" etc..
				if left(lcKey, len(this.rdFoxprofix)) = this.rdFoxprofix
					lcKey = substr(lcKey, len(this.rdFoxprofix) + 1)
					lcValue = evaluate("loObject." + this.rdFoxprofix + lcKey)
					lcKey = "@" + lcKey
				else
					lcValue = evaluate("loObject." + lcKey)
				endif
			else
				lcKey = lower(laMembers[i, 1])
				lcValue = evaluate("loObject." + lcKey)
			endif
			if this.unicode
				lcJson = lcJson + lcIndent + lcIndentStep + '"' + this.escapeString(lcKey) + '":' + this.valueToString(lcValue, tlBeautify, tnIndentLevel + 1)
			else
				lcJson = lcJson + lcIndent + lcIndentStep + '"' + lcKey + '":' + this.valueToString(lcValue, tlBeautify, tnIndentLevel + 1)
			endif
			if i < amembers(laMembers, loObject, 1)
				lcJson = lcJson + ","
			endif
			lcJson = lcJson + lcNewLine
		endfor
		lcJson = lcJson + lcIndent + "}"
		return lcJson
	endfunc

	function valueToString(lcValue, tlBeautify, tnIndentLevel)
		local lcJsonValue

		do case
			case vartype(lcValue) = "C"
				* We add quotes to format strings data
				if this.unicode
					lcJsonValue = '"' + alltrim(this.escapeString(lcValue)) + '"'
				else
					lcJsonValue = '"' + alltrim(lcValue) + '"'
				endif
			case inlist(vartype(lcValue),"N","I")
				lcJsonValue = transform(lcValue)
			case vartype(lcValue) == "Q"
				* Handle VARBINARY values by encoding them in Base64
				lcJsonValue = '"' + strconv(lcValue,13) + '"'
			case vartype(lcValue) == "Y"
				* Handle currency values by adding the currency symbol
				* We add quotes to format currency data
				lcJsonValue = '"' + transform(lcValue) + '"'
			case vartype(lcValue) == "D" or vartype(lcValue) == "T"
				* We add quotes to format date and datetime data
				lcJsonValue = '"' + this.FormatDateToISO8601(lcValue) + '"'
			case vartype(lcValue) = "L"
				lcJsonValue = iif(lcValue, "true", "false")
			case vartype(lcValue) = "O"
				lcJsonValue = this.stringify(lcValue, tlBeautify, tnIndentLevel)
			case vartype(lcValue) = "A"
				lcJsonValue = this.arrayToString(@lcValue, tlBeautify, tnIndentLevel)
			otherwise
				* Can't handle General
				lcJsonValue = "null"
		endcase

		return lcJsonValue
	endfunc

	function escapeString(lcValue)
		local lcEscaped, lnPos, lcChar, lnCharCode

		lcEscaped = ""
		for lnPos = 1 to len(lcValue)
			lcChar = substr(lcValue, lnPos, 1)
			lnCharCode = asc(lcChar)
			do case
				case lnCharCode < 32 .or. lnCharCode > 126
					lcEscaped = lcEscaped + "\u" + padl(transform(lnCharCode, "@0"), 4, "0")
				case lcChar = '"'
					lcEscaped = lcEscaped + '\"'
				case lcChar = "\"
					lcEscaped = lcEscaped + "\\"
				case lcChar = "/"
					lcEscaped = lcEscaped + "\/"
				case lcChar = chr(8)
					lcEscaped = lcEscaped + "\b"
				case lcChar = chr(12)
					lcEscaped = lcEscaped + "\f"
				case lcChar = chr(10)
					lcEscaped = lcEscaped + "\n"
				case lcChar = chr(13)
					lcEscaped = lcEscaped + "\r"
				case lcChar = chr(9)
					lcEscaped = lcEscaped + "\t"
				otherwise
					lcEscaped = lcEscaped + lcChar
			endcase
		endfor

		return lcEscaped
	endfunc

	function arrayToString(laArray, tlBeautify, tnIndentLevel)
		local lcJson, i, lcValue, lcIndent, lcNewLine, lcIndentStep
		external array laArray

		lcIndentStep = iif(tlBeautify, "    ", "")

		if tnIndentLevel > 0
			lcIndent = replicate(lcIndentStep, tnIndentLevel)
		else
			lcIndent = ""
		endif

		lcNewLine = iif(tlBeautify, chr(13) + chr(10), "")

		lcJson = "[" + lcNewLine
		for i = 1 to alen(laArray, 1)
			lcValue = this.valueToString(laArray[i], tlBeautify, tnIndentLevel + 1)
			lcJson = lcJson + lcIndent + lcIndentStep + lcValue
			if i < alen(laArray, 1)
				lcJson = lcJson + ","
			endif
			lcJson = lcJson + lcNewLine
		endfor
		lcJson = lcJson + lcIndent + "]"
		return lcJson
	endfunc

	function saveToFile(lcFileName, loObject, tlBeautify)
		local lcJson
		lcJson = this.stringify(loObject, tlBeautify)
		strtofile(lcJson, lcFileName)
	endfunc

	function FormatDateToISO8601(ldDateTime)
		if empty(ldDateTime)
			return "null"
		endif
		if vartype(ldDateTime) == "D"
			return left(dtoc(ldDateTime, 1), 4) + "-" + substr(dtoc(ldDateTime, 1), 5, 2) + "-" + right(dtoc(ldDateTime, 1), 2) + "T00:00:00Z"
		else
			if vartype(ldDateTime) == "T"
				return left(ttoc(ldDateTime, 1), 4) + "-" + substr(ttoc(ldDateTime, 1), 5, 2) + "-" + right(ttoc(ldDateTime, 1), 2) + "T" + substr(ttoc(ldDateTime, 2), 1, 8) + "Z"
			endif
		endif
		return ""
	endfunc

enddefine
