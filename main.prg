#INCLUDE json-fox.h

* Version 1.2.0.

lparameters tcRole,tvParm1,tvParm2,tvParm3

tcRole = IIF(VARTYPE(tcRole)="C",tcRole,"main")

=App_load_components(tcRole)

DO CASE 
	CASE LOWER(tcRole) = "test" 
		* Load libs is done in test procedure 
		* to indentify using of each prg 
		RETURN TestProg(tvParm1,tvParm2,tvParm3)
	CASE LOWER(tcRole) = "distrib"
		* Copy to the distrib repertory when new release 
		RETURN DistribProg()
	CASE LOWER(tcRole) = "loaddep"
		* Used for debuging
		ON ERROR DO ErrorHandler WITH ;
		   .NULL., MESSAGE( ), ERROR(), PROGRAM( ), LINENO( ) 
	CASE LOWER(tcRole) = "main" 
		* load libs only
		RETURN 
	OTHERWISE  
        RETURN CommonProg(tcRole,tvParm1,tvParm2,tvParm3)
ENDCASE 

function App_using_libs()

    * Load all root dependencies
    =load_librarys()

    * Current project dependencies 
    LOCAL loDependencies, lnI, lcFile
    loDependencies = GetDependencies(.T.)
    FOR lnI = 1 TO loDependencies.Count
        lcFile = loDependencies.Item(lnI)
        set procedure to (lcFile) additive
    ENDFOR
    
endfunc

function App_load_components(tcRole)

    =App_using_libs()

	public goApp
	goApp = createobject("empty")
	addproperty(goApp,"ldebugmode",.T.)
		
ENDFUNC

FUNCTION load_librarys 

	* DO json-fox\dependencies.prg 

ENDFUNC 

FUNCTION GetDependencies(tlAddLocalMain)
	
	
	loFiles = CREATEOBJECT("collection")
    
    loFiles.ADD('classes\bases\jsbases.prg')
	loFiles.ADD('classes\bases\jsbases_messages.prg')
    loFiles.ADD('classes\bases\jsbases_array.prg')
    loFiles.ADD('classes\bases\jsbases_factory.prg')
    
    loFiles.ADD('classes\json\json_Tokenizer.prg')
    loFiles.ADD('classes\json\json_Parser.prg')
    loFiles.ADD('classes\json\json_Stringify.prg')
    loFiles.ADD('classes\json\json_translateunicode.prg')
    
    loFiles.ADD('classes\tools\jstools_distribution.prg')

	* Add for debug purpose local main
	IF tlAddLocalMain
	    loFiles.ADD('main.prg')
   	ENDIF 
   	
	RETURN loFiles 

endfunc 


FUNCTION DistribProg()

        LOCAL loFiles, loDistribution,lcSourcepath,lcDestpath
        lcSourcepath = "classes"
        lcDestpath = "distrib"
        loFiles = GetDependencies()
        loDistribution = CREATEOBJECT("Distribution")
        loDistribution.Distribute(loFiles,lcSourcepath,lcDestpath)
        * #TODO Copy file *.md and *.h and do the test ( see current dest rep )   

ENDFUNC 

FUNCTION TestProg(tvParm1,tvParm2,tvParm3)

	do classes\test\jstest_bases.prg 
	do classes\test\jstest_messages.prg 

	do classes\test\jstest_Tokenizer.prg 
	do classes\test\jstest_Parser.prg
	do classes\test\jstest_Stringify.prg
		
ENDFUNC 

FUNCTION CommonProg(tcRole,tvParm1,tvParm2,tvParm3)

ENDFUNC 

*-* Here we have specific project interface creation 
DEFINE CLASS JsonHandler AS jsCustom OLEPUBLIC 

    cErrorMsg = ""
    nError = 0
	IsJsonLdObject = .F.
	rdFoxprofix = "object_"
	Unicode = .F.
	
	DIMENSION dependencies[1,2]

    FUNCTION serialize(loObject)
        LOCAL loStringify, lcJson

        loStringify = CREATEOBJECT("Stringify")
        WITH loStringify
            .IsJsonLdObject = THIS.IsJsonLdObject
            .rdFoxprofix = THIS.rdFoxprofix
            .Unicode = THIS.Unicode
        ENDWITH

        lcJson = loStringify.stringify(loObject)

        IF loStringify.nError = JS_FATAL_ERROR
            THIS.cErrorMsg = loStringify.cErrorMsg
            THIS.nError = JS_FATAL_ERROR
            RETURN .NULL.
        ENDIF

        RETURN lcJson
    ENDFUNC

    FUNCTION deserialize(lcJson)
        LOCAL loParser, loObject

        loParser = CREATEOBJECT("Parser")
		WITH loParser
            .IsJsonLdObject = THIS.IsJsonLdObject
            .rdFoxprofix = THIS.rdFoxprofix
            .Unicode = THIS.Unicode
        ENDWITH

        loObject = loParser.parseJson(lcJson)

        IF loParser.nError = JS_FATAL_ERROR
            THIS.cErrorMsg = loParser.cErrorMsg
            THIS.nError = JS_FATAL_ERROR
            RETURN .NULL.
        ENDIF

        RETURN loObject
    ENDFUNC

	FUNCTION GetDependencies 
		RETURN @THIS.dependencies
	ENDFUNC 
	
	
ENDDEFINE

