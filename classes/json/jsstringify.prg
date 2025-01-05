#INCLUDE C:\Webconnectionprojects\WebNode\devtools\json-fox\json-fox.h

define class Stringify as jscustom
	tokens = .null.
	currentIndex = 0

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
			lcJson = lcJson + lcIndent + lcIndentStep + '"' + lcKey + '":' + this.valueToString(lcValue, tlBeautify, tnIndentLevel + 1)
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
			case vartype(lcValue) == T_CHARACTER
				lcJsonValue = '"' + lcValue + '"'
			case vartype(lcValue) == T_NUMERIC
				lcJsonValue = transform(lcValue)
			case vartype(lcValue) == "L"
				lcJsonValue = iif(lcValue, "true", "false")
			case vartype(lcValue) == "O"
				if pemstatus(lcValue, "Count", 5)
					lcJsonValue = this.arrayToString(lcValue, tlBeautify, tnIndentLevel)
				else
					lcJsonValue = this.stringify(lcValue, tlBeautify, tnIndentLevel)
				endif
			otherwise
				lcJsonValue = "null"
		endcase
		return lcJsonValue
	endfunc

	function arrayToString(loArray, tlBeautify, tnIndentLevel)
		local lcJson, i, lcIndent, lcNewLine, lcIndentStep
		if type("tlBeautify") = "U"
			tlBeautify = .f.
		endif
		if type("tnIndentLevel") = "U"
			tnIndentLevel = 0
		endif

		lcIndentStep = iif(tlBeautify, "    ", "")
		lcIndent = replicate(lcIndentStep, tnIndentLevel)
		lcNewLine = iif(tlBeautify, chr(13) + chr(10), "")

		lcJson = "[" + lcNewLine
		for i = 1 to loArray.count
			lcJson = lcJson + lcIndent + lcIndentStep + this.valueToString(loArray.item(i), tlBeautify, tnIndentLevel + 1)
			if i < loArray.count
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
