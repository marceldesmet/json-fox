#INCLUDE json-fox.h

* Version 1.3.2.

define class jsmessageQueue as jsCollection
	lLogMode = .F. 

	function add(tcMessage, tcCategory)
		local loMessage
		loMessage = fac.Make_Message()
		dodefault(loMessage)
	endfunc

	* Not implemented yet
	* #TODO With observer pattern
	function Distribute(tcCategory, toSubject)
		local i, loMessage
		for i = 1 to this.count
			loMessage = this.item(i)
			if loMessage.category = tcCategory
				toSubject.NotifyObservers(loMessage.message)
			endif
		endfor
		this.clear(tcCategory)
	endfunc

	function clear(tcCategory)
		if empty(tcCategory)
			dodefault()
			return
		endif
		local i, loMessage
		for i = this.count to 1 step -1
			loMessage = this.item(i)
			if loMessage.category = tcCategory
				this.remove(i)
			endif
		endfor
	endfunc

	function read(tcCategory)

		local lnI, lvMessage,lcMessages
		tcCategory = iif(vartype(tcCategory) = "C", tcCategory, "")
		lcmessages = ""
		for lnI = 1 to this.count
			lvMessage = this.item(i)
			DO CASE 
				case  vartype(lvMessage) = "O"
					loMessage = lvMessage
					lcMessages = lcmessages + loMessage.message + CRLF
				case vartype(lvMessage) = "C"
					lcMessages = lcMessages + lvMessage + CRLF
				otherwise
					lcMessages = lcMessages + alltrim(transform(lvMessage)) + CRLF
			endcase
		endfor
		return lcMessages

	endfunc

enddefine
