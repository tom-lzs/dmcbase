$PBExportHeader$pt_template.sra
$PBExportComments$PowerTOOL Template Application.
forward
global nv_transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global nv_error error
global nv_message message
end forward

global variables
// User info structure
str_user		g_str_user

// Current MDI frame
w_fa		g_w_frame

// INI file manager
nv_ini		g_nv_ini

// Message manager
nv_msg_manager	g_nv_msg_mgr

// Component Checker
nv_components	g_nv_components

// Environment object
nv_environment	g_nv_env

// PADLock security manager
nonvisualobject	g_nv_security

// NAV navigation manager
nonvisualobject	g_nv_nav_manager
end variables

global type pt_template from application
 end type
global pt_template pt_template

type prototypes

end prototypes

type variables

end variables

event open;
// Open! script for PowerTOOL Template application.
//
// 1) Ensure that the folling libraries are in the search path:
//		pt_core.pbl
//    pv_core.pbl
//    pt_env.pbl
//    pv_env.pbl
//		pc_core.pbl
//
// 2) Ensure that the Default Global Variable Types are set as follows:
//		SQLCA:	nv_transaction
//		message:	nv_message
//		error:	nv_error
//
// 3)	Ensure that the following global variables are defined:
//		str_user				g_str_user
//		w_fa					g_w_frame
//		nv_ini				g_nv_ini
//		nv_msg_manager		g_nv_msg_mgr
//		nv_components		g_nv_components
//		nv_environment		g_nv_env
//		nonvisualobject	g_nv_security
//		nonvisualobject	g_nv_nav_manager

str_pass str_pass

// Create the environment services object.  This should
// be done before either components or msg_manager.
g_nv_env = CREATE nv_environment

// Create PowerCerv component checker.  This must be opened before
// ANY window is opened (including response dialogs).
g_nv_components = CREATE nv_components

// Create the message manager.
g_nv_msg_mgr = CREATE nv_msg_manager

// Bail out if the application is already running.
IF Handle (this, TRUE) > 0 THEN
	g_nv_msg_mgr.fnv_process_msg ("pt", "Already Running", "", "", 0, 0)
	HALT CLOSE
END IF

// Open the application .INI file.
g_nv_ini = CREATE nv_ini
IF NOT g_nv_ini.fnv_check_and_open (GetApplication ().AppName) THEN
	HALT CLOSE
END IF

// Log into DBMS and bail out if login fails.
Open (w_a_login)				// YOUR login window goes here!

str_pass = message.fnv_get_str_pass ()
message.fnv_clear_str_pass ()

IF str_pass.s_action <> "ok" THEN
	HALT CLOSE
END IF

// Add PowerCerv message table repository to the message manager.
g_nv_msg_mgr.fnv_add_db_repository ("d_repo_cache_pc_db", SQLCA)

// Initialize security.
IF g_nv_components.fnv_is_library_installed ("pl_core") THEN
	g_nv_security = CREATE USING "nv_security"
	IF IsValid (g_nv_security) THEN
		String s_bogus				// this is required to
		s_bogus = this.appname	// shut the compiler up
		g_nv_security.FUNCTION DYNAMIC fnv_init_security (s_bogus, &
																g_str_user.s_userid, &
																				SQLCA, TRUE)
	END IF
END IF

// Open frame.
Open (w_fa)						// YOUR MDI frame window goes here!

end event

event close;
// Close! script for PowerTOOL Template application.

// Rollback any pending updates.
ROLLBACK USING SQLCA;

// Disconnect the current transaction.
DISCONNECT USING SQLCA;

// Destroy the global non-visual user objects.
IF IsValid (g_nv_ini) THEN
	DESTROY g_nv_ini
END IF

IF IsValid (g_nv_components) THEN
	DESTROY g_nv_components
END IF

IF IsValid (g_nv_msg_mgr) THEN
	DESTROY g_nv_msg_mgr
END IF

IF IsValid (g_nv_env) THEN
	DESTROY g_nv_env
END IF

IF IsValid (g_nv_nav_manager) THEN
	DESTROY g_nv_nav_manager
END IF

IF IsValid (g_nv_security) THEN
	g_nv_security.FUNCTION DYNAMIC fnv_close_security () // TEMPORARY
	DESTROY g_nv_security
END IF

end event

event systemerror;
// SystemError! script for PowerTOOL Template application.

// Call upon error object to process the error.
error.fnv_process_error ()

end event

on pt_template.create
appname = "pt_template"
message = create nv_message
sqlca = create nv_transaction
sqlda = create dynamicdescriptionarea
sqlsa = create dynamicstagingarea
error = create nv_error
end on

on pt_template.destroy
destroy( sqlca )
destroy( sqlda )
destroy( sqlsa )
destroy( error )
destroy( message )
end on

