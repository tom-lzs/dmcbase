$PBExportHeader$nv_ini_pt.sru
$PBExportComments$Fonctions de sauvegarde et de lecture des fichiers .INI
forward
global type nv_ini_pt from nonvisualobject
end type
end forward

global type nv_ini_pt from nonvisualobject
end type
global nv_ini_pt nv_ini_pt

type variables
PROTECTED:

Boolean i_b_valid	// Indicates whether .ini file has been opened
String i_s_path	// Fully qualified .ini file
end variables

forward prototypes
public function boolean fnv_is_valid ()
public function integer fnv_profile_int (string a_s_section, string a_s_key, integer a_i_default)
public function string fnv_profile_string (string a_s_section, string a_s_key, string a_s_default)
public function integer fnv_set_profile_string (string a_s_section, string a_s_key, string a_s_value)
public function boolean fnv_open (string a_s_section, string a_s_app_name, boolean a_b_askuser)
public function boolean fnv_check_and_open (string a_s_app_name)
public function string fnv_get_name ()
public function integer fnv_profile_int_no_def (string a_s_section, string a_s_key, ref integer a_i_value)
public function integer fnv_profile_string_no_def (string a_s_section, string a_s_key, ref string a_s_value)
end prototypes

public function boolean fnv_is_valid ();// Return value of instance variable.

RETURN i_b_valid
end function

public function integer fnv_profile_int (string a_s_section, string a_s_key, integer a_i_default);// Calls ProfileInt () to get the integer from the .ini file.

IF NOT i_b_valid THEN
	g_nv_msg_mgr.fnv_process_msg ("pt", "INI Mgr Invalid", "", "", 0, 0)
	RETURN -1
END IF

RETURN ProfileInt (i_s_path, a_s_section, a_s_key, a_i_default)
end function

public function string fnv_profile_string (string a_s_section, string a_s_key, string a_s_default);// Calls ProfileString () to get the profile string.

IF NOT i_b_valid THEN
	g_nv_msg_mgr.fnv_process_msg ("pt", "INI Mgr Invalid", "", "", 0, 0)
	RETURN ""
END IF

RETURN ProfileString (i_s_path, a_s_section, a_s_key, a_s_default)
end function

public function integer fnv_set_profile_string (string a_s_section, string a_s_key, string a_s_value);// Sets the string into the .ini file using SetProfileString ().

IF NOT i_b_valid THEN
	g_nv_msg_mgr.fnv_process_msg ("pt", "INI Mgr Invalid", "", "", 0, 0)
	RETURN -1
END IF


RETURN SetProfileString (i_s_path, a_s_section, a_s_key, a_s_value)
end function

public function boolean fnv_open (string a_s_section, string a_s_app_name, boolean a_b_askuser);
//*****************************************************************************
// Open the .ini file.  If successful, s_ini_file contains name of
// .ini file.
//
// Search order for the .ini file is:
//		1. a_s_appname under [PowerTOOL] in WIN.INI
//		2. a_s_appname.INI (in current working directory)
//
// Example in the win.ini file:
//		[PowerTOOL]
//		sample=c:\sample\sample.ini
//*****************************************************************************

string	s_ini_file, s_filename, s_dir

// Attempt to locate path of .ini file in WIN.INI.

IF a_s_section <> "" THEN
	s_ini_file = ProfileString ("win.ini", a_s_section, a_s_app_name, "NOT FOUND")
	IF s_ini_file <> "NOT FOUND" THEN
		IF NOT FileExists (s_ini_file) THEN
			s_ini_file = "NOT FOUND"
		END IF
	END IF
ELSE
	s_ini_file = "NOT FOUND"
END IF

// Attempt to locate .ini file in current working directory if
// WIN.INI search was unsuccessful.

IF s_ini_file = "NOT FOUND" THEN
	s_ini_file =  Left (a_s_app_name, 8) + ".ini"
	IF FileExists (s_ini_file) THEN
		// if directory undefined, we must prompt
		// user below to get fully qualified path
		
		// CBE START
		// s_dir = g_nv_env.fnv_get_directory ()
		s_dir = GetCurrentDirectory ()
		// CBE END
		IF s_dir = "" THEN
			s_ini_file = "NOT FOUND"
		ELSE
			s_ini_file = s_dir + "\" + s_ini_file
		END IF
	ELSE
		s_ini_file = "NOT FOUND"
	END IF
END IF

// If no .ini file is found, ask whether the user wants to hunt for
// one, unless a_b_askuser parameter is set to FALSE.

IF s_ini_file = "NOT FOUND" THEN
	g_nv_msg_mgr.fnv_log_msg (a_s_app_name, "Unable to locate INI file in fnv_open", 4)
	IF NOT a_b_askuser THEN
		// INI file selection prompt is not an option if a_b_askuser is
		// set to FALSE.
		RETURN FALSE
	END IF
	IF g_nv_msg_mgr.fnv_process_msg("pt", "Choose INI File?", "", "", 0, 0) = 1 THEN
		IF GetFileOpenName ("Choose Initialization File", s_ini_file, &
				s_filename, "INI", "Init Files (*.INI),*.INI") < 1 THEN
			// Response window was cancelled or an error occured.
			RETURN FALSE
		END IF
	ELSE
		// User doesn't want to choose an initialzation file.
		RETURN FALSE
	END IF
END IF

// Store name of file in the path string and mark the file valid.

i_s_path = s_ini_file

i_b_valid = TRUE

RETURN TRUE
end function

public function boolean fnv_check_and_open (string a_s_app_name);// Checks to see if the .ini file is already open.  If not, trys to
// open it.

IF fnv_is_valid () THEN
	RETURN TRUE
END IF


// Open the .ini file.

RETURN fnv_open ("PowerTOOL", a_s_app_name, TRUE)
end function

public function string fnv_get_name ();// Return fully qualified .ini file from instance variable.

IF i_b_valid THEN
	RETURN i_s_path
ELSE
	RETURN ""
END IF
end function

public function integer fnv_profile_int_no_def (string a_s_section, string a_s_key, ref integer a_i_value);// Calls ProfileString () to get the profile string.  Note that we
// have to check for the value twice because the value might be
// the default we specify in the first try.

IF NOT i_b_valid THEN
	g_nv_msg_mgr.fnv_process_msg ("pt", "INI Mgr Invalid", "", "", 0, 0)
	RETURN -1
END IF


// Call ProfileInt () to get the integer value.  If the value returned
// is the default then try again with another default to verify that
// ProfileInt () is not simply returning the default.

a_i_value = ProfileInt (i_s_path, a_s_section, a_s_key, -9876)

IF a_i_value = -9876 THEN
	a_i_value = ProfileInt (i_s_path, a_s_section, a_s_key, -9875)
	IF a_i_value = -9875 THEN
		g_nv_msg_mgr.fnv_process_msg ("pt", "Missing INI Key", &
				i_s_path + "," + a_s_key + "," + a_s_section, "", 0, 0)
		RETURN -1
	END IF
END IF


// A value was successfully retrieved.

RETURN 1
end function

public function integer fnv_profile_string_no_def (string a_s_section, string a_s_key, ref string a_s_value);// Calls ProfileString () to get the profile string.  Note that we
// have to check twice, in case the default value we supply the
// first time matches the value in the INI file.

IF NOT i_b_valid THEN
	g_nv_msg_mgr.fnv_process_msg ("pt", "INI Mgr Invalid", "", "", 0, 0)
	RETURN -1
END IF


// Call ProfileString () to get the integer value.  If the value returned
// is the default then try again with another default to verify that
// ProfileString () is not simply returning the default.

a_s_value = ProfileString (i_s_path, a_s_section, a_s_key, "No Default String")

IF a_s_value = "No Default String" THEN
	a_s_value = ProfileString (i_s_path, a_s_section, a_s_key, &
						"No Default Str")
	IF a_s_value = "No Default Str" THEN
		g_nv_msg_mgr.fnv_process_msg ("pt", "Missing INI Key", &
				i_s_path + "," + a_s_key + "," + a_s_section, "", 0, 0)
		RETURN -1
	END IF
END IF


// A value was successfully retrieved.

RETURN 1
end function

on nv_ini_pt.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nv_ini_pt.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

