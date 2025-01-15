#INCLUDE json-fox.h

* Version 1.3.2

lparameters tcRole,tvParm1,tvParm2,tvParm3

tcRole = iif(vartype(tcRole)="C",tcRole,"main")

if application.startmode = 4
	_screen.visible = .f.
endif

public json,dep,msg,fac

* Load
dep = createobject("dependencies")
json = createobject("JsonHandler")
msg = createobject("jsmessageQueue")
msg.lLogMode = .T. 
fac = createobject("jsfactory")

* Start here desktop or server
json.Initialize_MVC()

do case
	case lower(tcRole) = "test"
		* Load libs is done in test procedure
		* to indentify using of each prg
		return TestProg(tvParm1,tvParm2,tvParm3)
	case lower(tcRole) = "distrib"
		* Copy to the distrib repertory when new release
		return dep.CopytoDistribute()
	case lower(tcRole) = "debug" .or. lower(tcRole) = "loaddep"
		* Used for debuging
		if vartype(goApp) <> "O"
			public goApp
			goApp = createobject("empty")
		endif
		addproperty(goApp,'ldebugmode',.t.)
		on error do ErrorHandler with ;
			.null., message( ), error(), program( ), lineno( )
	case lower(tcRole) = "main"
		do form classes\ui\jsonviewer
		return
	otherwise
		return
endcase

************* Start your application here
* Here we have specific project interface creation

define class JsonHandler as jsApplication olepublic

	cErrorMsg = ""
	nError = 0
	IsJsonLdObject = .f.
	rdFoxprofix = "object_"
	unicode = .f.

	dimension dependencies[1,2]

	function serialize(loObject,tlBeautify)
		local loStringify, lcJson
		loStringify = createobject("Stringify")
		with loStringify
			.IsJsonLdObject = this.IsJsonLdObject
			.rdFoxprofix = this.rdFoxprofix
			.unicode = this.unicode
		endwith

		lcJson = loStringify.stringify(loObject,tlBeautify)

		if loStringify.nError = JS_FATAL_ERROR
			this.cErrorMsg = loStringify.cErrorMsg
			this.nError = JS_FATAL_ERROR
			return .null.
		endif

		return lcJson
	endfunc

	function deserialize(lcJson)
		local loParser, loObject

		loParser = createobject("Parser")
		with loParser
			.IsJsonLdObject = this.IsJsonLdObject
			.rdFoxprofix = this.rdFoxprofix
			.unicode = this.unicode
		endwith

		loObject = loParser.parseJson(lcJson)

		if loParser.nError = JS_FATAL_ERROR
			this.cErrorMsg = loParser.cErrorMsg
			this.nError = JS_FATAL_ERROR
			return .null.
		endif

		return loObject
	endfunc

	function GetDependencies
		return @this.dependencies
	endfunc

	function Initialize_MVC()

		release oFactory
		public oFactory
		oFactory = createobject("jsfactory")

	endfunc

	function dumpTokensToFile(toTokens,tcDumpFile)
		local loTokenizer
		loTokenizer =createobject("tokenizer")
		loTokenizer.dumpTokensToFile(toTokens,tcDumpFile)
	endfunc

	function FormatJson(tcJson)
		local loJson
		loJson = this.deSerialize(tcJson)
		tcFormattedJson = this.Serialize(loJson,.t.)
		return tcFormattedJson
	endfunc

enddefine

define class dependencies as custom

	function load_librarys

		*-* do webmove\j_classes_dependencies.prg
	endfunc

	function GetDependencies(tlAddLocalMain)

		loFiles = createobject("collection")

		loFiles.add('classes\bases\jsbases.prg')
		loFiles.add('classes\bases\jsbases_messages.prg')
		loFiles.add('classes\bases\jsbases_array.prg')
		loFiles.add('classes\bases\jsbases_factory.prg')
		loFiles.add('classes\bases\jsbases_cursors.prg')
		loFiles.add('classes\bases\jsbases_data.prg')
		loFiles.add('classes\bases\jsbases_application.prg')
		loFiles.add('classes\bases\jsbases_messages_queue.prg') 

		loFiles.add('classes\json\json_Tokenizer.prg')
		loFiles.add('classes\json\json_Parser.prg')
		loFiles.add('classes\json\json_Stringify.prg')
		loFiles.add('classes\json\json_translateunicode.prg')

		loFiles.add('classes\tools\jstools_distribution.prg')

		* Add for debug purpose local main
		if tlAddLocalMain
			loFiles.add('main.prg')
		endif

		return loFiles

	endfunc

	function TestProg(tvParm1,tvParm2,tvParm3)


		do classes\src_test\test_Tokenizer.prg
		do classes\src_test\test_Stringify.prg

	endfunc

	function init()

		* Load all root dependencies
		* Generaly configurated in childs
		this.load_librarys()

		* Current project dependencies
		local loDependencies, lnI, lcFile
		loDependencies = this.GetDependencies(.t.)
		for lnI = 1 to loDependencies.count
			lcFile = loDependencies.item(lnI)
			set procedure to (lcFile) additive
		endfor

	endfunc

enddefine



