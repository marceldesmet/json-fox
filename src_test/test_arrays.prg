Do json_main with "loaddep"
CLEAR 
LOCAL oArray 

oArray = CREATEOBJECT("jsArray")

oArray.Add("Test_col1,value1")
IF oArray.Item[1,1] <> "Test_col1,value1"
	? "Level 1.1 error ! "
ENDIF 
 
* Write to a new col 
oArray.nCol = oArray.nCol + 1
oArray.Add("Test_col2,value1")
oArray.Add("Test_col2,value2")
oArray.Add("Test_col2,value3")
IF oArray.Item[3,2] <> "Test_col2,value3"
	? "Level 3.2 error ! "
ELSE
	? "Level 3.2 ok ! "
ENDIF 
* Col 3
oArray.nCol = oArray.nCol + 1
oArray.Add("Test_col3,value1")
IF oArray.Item[1,3] <> "Test_col3,value1"
	? "Level 1.3 error ! "
ELSE 
	? "Level 1.3 ok ! "
ENDIF 
* Back to col 2 
oArray.nCol = oArray.nCol - 1
oArray.Add("Test_col2,value4")
IF oArray.Item[4,2] <> "Test_col2,value4"
	? "Level 2.4 error ! "
ELSE 
	? "Level 2.4 ok ! "
ENDIF 
* Back to col 1
oArray.nCol = oArray.nCol - 1
oArray.Add("Test_col1,value2")
oArray.Add("Test_col1,value3")
IF oArray.Item[3,1] <> "Test_col1,value3"
	? "Level 1.3 error ! "
ELSE 
	? "Level 1.3 ok ! "
ENDIF 

 

