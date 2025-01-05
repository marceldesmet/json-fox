lparameters tcRole,tvParm1,tvParm2,tvParm3

tcRole = IIF(VARTYPE(tcRole)="C",tcRole,"main")

public goApp
goApp = createobject("empty")

=App_load_components()

IF tcRole = "test" 
	* Load libs is done in test procedure 
	* to indentify using of each prg 
	RETURN TestProg(tvParm1,tvParm2,tvParm3)
ELSE 
	=App_using_libs()
	RETURN CommonProg(tcRole,tvParm1,tvParm2,tvParm3)
ENDIF 

function App_using_libs()

	set procedure to classes\bases\jsbases.prg additive
	set procedure to classes\bases\jsmessages.prg additive
		
	set procedure to classes\json\jsTokenizer.prg additive
	set procedure to classes\json\jsParser.prg additive
	set procedure to classes\json\jsStringify.prg additive

endfunc

function App_load_components()

	addproperty(goApp,"log",createobject("jjlog"))
	addproperty(goApp,"ldebugmode",.T.)
		
endfunc

FUNCTION TestProg(tvParm1,tvParm2,tvParm3)

	do classes\test\jsbases_test.prg 
	do classes\test\jsmessages_test.prg 
		
	do classes\test\jsTokenizer_test.prg 
	do classes\test\jsParser_test.prg
	do classes\test\jsStringify_test.prg
		
ENDFUNC 

FUNCTION CommonProg(tcRole,tvParm1,tvParm2,tvParm3)

ENDFUNC 
