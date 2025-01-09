#INCLUDE json-fox.h

* Version 1.1.0.

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

function App_load_components()

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
	loFiles.ADD('classes\bases\jsmessages.prg')
    loFiles.ADD('classes\bases\jsarray.prg')
        
    loFiles.ADD('classes\json\jsTokenizer.prg')
    loFiles.ADD('classes\json\jsParser.prg')
    loFiles.ADD('classes\json\jsStringify.prg')

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

	do classes\test\jsbases_test.prg 
	do classes\test\jsmessages_test.prg 

	do classes\test\jsTokenizer_test.prg 
	do classes\test\jsParser_test.prg
	do classes\test\jsStringify_test.prg
		
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

    FUNCTION dumpTokensToFile(tcJson, tcFileName)
        LOCAL loParser

        loParser = CREATEOBJECT("Parser")
        loParser.parseJson(tcJson)

        IF loParser.nError = JS_FATAL_ERROR
            THIS.cErrorMsg = loParser.cErrorMsg
            THIS.nError = JS_FATAL_ERROR
            RETURN .F.
        ENDIF

        loParser.dumpTokensToFile(tcFileName)
        RETURN .T.
    ENDFUNC

	FUNCTION GetDependencies 
		RETURN @THIS.dependencies
	ENDFUNC 
	
	
ENDDEFINE

