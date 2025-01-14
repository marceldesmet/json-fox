#INCLUDE json-fox.h

* Version 1.0.0.

lparameters tcRole,tvParm1,tvParm2,tvParm3

tcRole = iif(vartype(tcRole)="C",tcRole,"main")

if application.startmode = 4
	_screen.visible = .f.
endif

public desk,dep

* Load
dep = createobject("dependencies")

desk = createobject("htmldata")

do case
	case lower(tcRole) = "test"
		* Load libs is done in test procedure
		* to indentify using of each prg
		TestProg(tvParm1,tvParm2,tvParm3)
	case lower(tcRole) = "distrib"
		* Copy to the distrib repertory when new release
		DistribProg()
	case lower(tcRole) = "loaddep"
		* Used for debuging
		on error do ErrorHandler with ;
			.null., message( ), error(), program( ), lineno( )
	case lower(tcRole) = "main"
		* load libs only

	otherwise
		desk.main(tcRole,tvParm1,tvParm2,tvParm3)
endcase


************* Start you application here

define class htmldata as jsHtmldata olepublic

	cConfig = "HtmlDataConfig"
	cMsg	= "LogMessages"
	ldebugmode = .t.

enddefine

define class jhtmldata_dependencies as custom 

	function load_librarys

		do json-fox\jsonfox_dependencies.prg
		do html-maker\htmlmaker_dependencies.prg
		*-* do webmove\j_classes_dependencies.prg

	endfunc

	function GetDependencies(tlAddLocalMain)

		loFiles = createobject("collection")

		loFiles.add('classes\bases\jsbases_desk_application.prg')
		loFiles.add('classes\collections\jscollections_messages.prg')
		loFiles.add('classes\toolboxes\jstools_textmerge.prg')
		loFiles.add('classes\toolboxes\jstools_config.prg')
		loFiles.add('classes\toolboxes\jstools_utility.prg')
		loFiles.add('classes\ui\jsui_view.prg')
		
		loFiles.add('classes\models\jsmodels_cursors.prg')
		loFiles.add('classes\models\jsmodels.prg')
		loFiles.add('classes\models\jsmodels_data.prg')
		loFiles.add('classes\models\jsmodels_factory.prg')
		loFiles.add('classes\models\jsmodels_relations.prg')
		loFiles.add('classes\models\jsmodels_sqlconnection.prg')
		loFiles.add('htmldata_node_to_move_brige.prg')

		* Add for debug purpose local main
		if tlAddLocalMain
			loFiles.add('htmldata_main.prg')
		endif

		return loFiles

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


*************  End of definition of the application

