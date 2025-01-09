#INCLUDE json-fox.h

* Version 1.1.0.

define class Stringify as jscustom
	tokens = .null.
	currentIndex = 0
	name = "Stringify"
	Unicode  = .F. 
	
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
		for i = 1 to amembers(laMembers, loObject, 1)
			lcKey = lower(laMembers[i, 1])
			lcValue = evaluate("loObject." + lcKey)
			if this.Unicode
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
				if this.Unicode
					lcJsonValue = '"' + this.escapeString(lcValue) + '"'
				else
					lcJsonValue = '"' + lcValue + '"'
				endif
			case vartype(lcValue) = "N" .or. vartype(lcValue) = "I"
				lcJsonValue = transform(lcValue)
			case vartype(lcValue) = "L"
				lcJsonValue = iif(lcValue, "true", "false")
			case vartype(lcValue) = "O"
				lcJsonValue = this.stringify(lcValue, tlBeautify, tnIndentLevel)
			case vartype(lcValue) = "A"
				lcJsonValue = this.arrayToString(@lcValue, tlBeautify, tnIndentLevel)
			otherwise
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
		EXTERNAL ARRAY laArray
		
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

enddefine
