#INCLUDE json-fox.h

* Version 1.2.0.
define class jsArray as jsCustom
	dimension aArray[1]
	nRow = 0
	nCol = 1

	function push(tvItem,tnCol)
		tnCol = iif(vartype(tnCol) = "N",tnCol,1)
		this.nRow = this.nRow + 1
		dimension this.aArray[this.nRow,this.nCol]
		this.aArray[this.nIndex,tnCol] = tvItem
	endfunc

	function GetArray
		return @this.aArray
	endfunc
enddefine
