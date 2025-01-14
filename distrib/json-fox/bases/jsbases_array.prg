#INCLUDE json-fox.h

* Version 1.3.0.
Define Class jsArray As jsCustom
	Dimension aArray[1]
	nRow = 0
	nCol = 1

	Function Push(tvItem,tnCol)
        tnCol = IIF(VARTYPE(tnCol) = "N",tnCol,1)
		this.nRow = this.nRow + 1
		Dimension this.aArray[this.nRow,this.nCol]
		this.aArray[this.nIndex,tnCol] = tvItem
	Endfunc
	
	Function GetArray
		Return @this.aArray
	EndFunc
Enddefine