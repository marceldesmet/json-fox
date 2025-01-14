#INCLUDE json-fox.h

* Version 1.3.0.
define class jsArray as jscustom

	name = "jsArray"
	
	IsColumnData	= .F.

	dimension item[1,1]
	item[1,1] = .f.

	
	nRow = 1
	nCol = 1

	* The current push row level in a column
	* To handle recursion and nested structures correctly, the size of the aPushLevel array should match the number of columns in the main array. This ensures
	* that each column can track its own depth level independently.
	dimension aPushLevel[1]
	aPushLevel[1] = 1

	*  col1 [ row1 row2 row3 ]
	*  col2 [ row1 row2 row3 ]
	*  col3 [ row1 row2 row3 ]

	procedure IsArray()
		return type("This.item[1]") != T_UNDEFINED
	endproc

	function push(tvItem)
		* Set the current row to the last row in the column
		this.nRow = this.aPushLevel[THIS.nCol]
		IF VARTYPE(this.item[THIS.nRow,THIS.nCol])=T_OBJECT
			this.nRow = this.nRow + 1
		ENDIF 	
		if empty(this.item[THIS.nRow,THIS.nCol])
			this.item[THIS.nRow,THIS.nCol] = tvItem
			this.aPushLevel[THIS.nCol] = this.nRow
			return
		endif
		this.nRow = this.nRow + 1
		this.item[THIS.nRow,THIS.nCol] = tvItem
		this.aPushLevel[THIS.nCol] = this.nRow
	endfunc

	function nRow_assign(tnRow)
		local lnRows,lnCols
		lnRows = alen(this.item,1)
		if tnRow > lnRows
			lnCols = alen(this.item,2)
			dimension this.item[ tnRow, lnCols]
		endif
		this.nRow = tnRow
	endfunc

	function GetArray(roArray)
		ACOPY(THIS.item,roArray.Item)
	endfunc

	function add(tvItem)
		this.push(tvItem)
	endfunc

	* InsertCols Method - Add columns to the array (re-size it larger)
	*   Parameters: n
	*   Returns: The new number of columns in the array
	*   Note: All elements in the new columns are initialized to .NULL.
	function ncol_assign(tnCol)

		* Check for valid parameters
		assert pcount() = 1 and tnCol > 0

		* Only incremental
		if tnCol > this.nCol

			local lnNewCols,lnI,lnII,laTemp,lnRows,lnCols

			lnRows = alen(this.item,1)
			lnCols = alen(this.item,2)

			dimension laTemp[ lnRows, lnCols]

			* Copy the current array to laTemp[]
			= acopy( this.item, laTemp )

			* Re-dimension our array
			dimension this.item[ lnRows, tnCol]

			* Initialize new columns to .NULL.
			for lnI = 1 to lnRows
				for lnII = lnCols + 1 to tnCol
					this.item[lnI, lnII] = .f.			&& Foxpro don't ccept null value in arrays
				endfor
			endfor

			* Copy everything from the temporary array into the new array
			for lnI = 1 to lnRows
				for lnII = 1 to lnCols
					this.item[lnI, lnII] = laTemp[lnI, lnII]
				endfor
			endfor

			* Set colum to the current / new column count
			this.nCol = alen(this.item,2)
			this.nRow = 1
			dimension this.aPushLevel[tnCol]
			this.aPushLevel[tnCol] = 1
		else
			this.nCol = tnCol
		endif
	endproc

enddefine

* Jsdata is array wrapepr for json-fox
* It is used to store data in array format
* and then convert it to json
* There are a lot of hidden properties and methods
* because the serialization is done by json-fox
* See "+GA" in json-fox stringify method 
DEFINE CLASS jsdata AS jsArray

	* exposed property
	DIMENSION Item[1,1]
	
	* hidden properties
	HIDDEN name
	HIDDEN classlibrary
	HIDDEN addobject
	HIDDEN baseclass
	HIDDEN class
	HIDDEN addproperty
	HIDDEN writemethod
	HIDDEN writeexpression
	HIDDEN width
	HIDDEN whatsthishelpid
	HIDDEN tag
	HIDDEN showwhatsthis
	HIDDEN saveasclass
	HIDDEN resettodefault
	HIDDEN removeobject
	HIDDEN readmethod
	HIDDEN readexpression
	HIDDEN picture
	HIDDEN parentclass
	HIDDEN parent
	HIDDEN objects
	HIDDEN newobject
	HIDDEN init
	HIDDEN helpcontextid
	HIDDEN height
	HIDDEN error
	HIDDEN destroy
	HIDDEN controls
	HIDDEN controlcount
	HIDDEN comment
	HIDDEN cloneobject
	HIDDEN top
	HIDDEN left
	HIDDEN IsColumnData
	HIDDEN nRow 
	HIDDEN nCol
	HIDDEN aPushLevel
	HIDDEN lSendError
	HIDDEN oSendError 
	HIDDEN nError 
	HIDDEN lError
	HIDDEN cErrorMsg
	HIDDEN cErrorMethod
	HIDDEN add
	HIDDEN getarray
	HIDDEN isarray
	HIDDEN push 
	HIDDEN cName
	
ENDDEFINE 

