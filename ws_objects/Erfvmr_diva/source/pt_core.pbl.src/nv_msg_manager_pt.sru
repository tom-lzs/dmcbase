$PBExportHeader$nv_msg_manager_pt.sru
$PBExportComments$Gestionnaire de messages (affichage et connexion) PowerTOOL
forward
global type nv_msg_manager_pt from nonvisualobject
end type
end forward

global type nv_msg_manager_pt from nonvisualobject
end type
global nv_msg_manager_pt nv_msg_manager_pt

type variables
nv_repo_manager i_nv_repo []	// Prioritized array of repositories

String i_s_language_id		// Current language

Integer i_i_display_level		// Level at which messages are displayed

Integer i_i_logging_level		// Level at which messages are logged

String i_s_dialog_class []		// Classnames of display dialogs, based on severity

end variables

forward prototypes
public function string fnv_get_language ()
protected function integer fnv_parse_parms (string a_s_parm_string, ref string a_s_parm[])
protected function string fnv_parmsub (string a_s_text, string a_s_parm_sting)
public subroutine fnv_set_display_level (integer a_i_display_level)
public subroutine fnv_set_logging_level (integer a_i_logging_level)
public function integer fnv_get_display_level ()
public function integer fnv_get_logging_level ()
public subroutine fnv_log_msg (string a_s_message_title, string a_s_message_text, integer a_i_severity_level)
public function string fnv_translate (string a_s_source)
public subroutine fnv_set_dialog_class (integer a_i_severity, string a_s_dialog_class)
public function string fnv_get_dialog_class (integer a_i_severity)
public function integer fnv_add_dw_repository (string a_s_dataobject)
public function integer fnv_add_file_repository (string a_s_dataobject, string a_s_file_name)
public function integer fnv_display_msg (string a_s_message_title, string a_s_message_text, integer a_i_severity_level, string a_s_dialog_classname, string a_s_response_classname, integer a_i_response_default)
protected function string fnv_get_frametitle ()
public subroutine fnv_initialize ()
public subroutine fnv_reset ()
public function long fnv_set_language (string a_s_language_id)
public subroutine fnv_retrieve_msg (string a_s_message_group, string a_s_message_id, ref string a_s_message_title, ref string a_s_message_text, ref integer a_i_severity_level, ref integer a_i_logging_ind, ref string a_s_dialog_classname, ref string a_s_response_classname, ref integer a_i_response_default)
public function integer fnv_process_msg (string a_s_message_group, string a_s_message_id, string a_s_parm_string, string a_s_message_title, integer a_i_severity_level, integer a_i_logging_ind)
public function integer fnv_add_db_repository (string a_s_dataobject, nv_transaction a_tr_trans)
end prototypes

public function string fnv_get_language ();// Return value of instance variable.

RETURN i_s_language_id
end function

protected function integer fnv_parse_parms (string a_s_parm_string, ref string a_s_parm[]);// Scan the passed parm string and extract each individual item,
// separated by commas.

Integer i_pos, i_cnt


// Loop through the parm string extracting each comma separated item.
// Embedded ',,' will be treated as a single comma.

i_pos = 1

DO WHILE Len (a_s_parm_string) > 0

	i_pos = Pos (a_s_parm_string, ",", i_pos)

	IF i_pos = 0 THEN		// No commas encountered - take entire string
		i_cnt ++
		a_s_parm [i_cnt] = f_str_transform (Trim (a_s_parm_string), &
																			",,", ",")
		a_s_parm_string = ""
		CONTINUE
	END IF

	IF Mid (a_s_parm_string, i_pos + 1, 1) = "," THEN
								// Embedded ',,' - skip over doublet
		i_pos = i_pos + 2
		CONTINUE
	END IF
	
	// Strip parm off of parm string and continue with loop.

	i_cnt ++

	a_s_parm [i_cnt] = f_str_transform (Trim (Left (a_s_parm_string, &
															i_pos - 1)), ",,", ",")

	a_s_parm_string = Mid (a_s_parm_string, i_pos + 1)

	i_pos = 1

LOOP


// Return the number of entries in the array.

RETURN i_cnt
end function

protected function string fnv_parmsub (string a_s_text, string a_s_parm_sting);// Substitute positional parameters in the passed text string.

String s_parm []		// List of parms for substitution
String s_substitution
Integer i_pos, i_digit_pos, i_parm_num


// Parse the parm string.

this.fnv_parse_parms (a_s_parm_sting, s_parm)


// Loop through the text item searching for all %# sequences (where
// # is an integer).  All occurrences of %% will be converted to %.

i_pos = 1

DO WHILE i_pos > 0

	i_pos = Pos (a_s_text, "%", i_pos)

	IF i_pos < 1 THEN			// No (more) occurrences found
		CONTINUE
	END IF

	IF Mid (a_s_text, i_pos + 1, 1) = "%" THEN
									// Found "%%" - replace the doublet
		a_s_text = Replace (a_s_text, i_pos, 2, "%")
		i_pos ++
		CONTINUE
	END IF

	IF NOT IsNumber (Mid (a_s_text, i_pos + 1, 1)) THEN
									// Found a lone "%" - pass by it
		i_pos ++
		CONTINUE
	END IF

	// Found a singleton "%" followed by a number - loop through the
	// digits to the right of the "%" to determine the parm number.

	i_parm_num = 0

	i_digit_pos = i_pos + 1

	DO WHILE IsNumber (Mid (a_s_text, i_digit_pos, 1))
		i_parm_num = i_parm_num * 10 + Integer (Mid (a_s_text, i_digit_pos, 1))
		i_digit_pos ++
	LOOP

	// Replace the item with the appropriate parameter (if not out of
	// range).

	IF i_parm_num > UpperBound (s_parm) THEN
		s_substitution = "?"
	ELSE
		s_substitution = s_parm [i_parm_num]
	END IF

	a_s_text = Replace (a_s_text, i_pos, i_digit_pos - i_pos, s_substitution)

	i_pos = i_digit_pos

LOOP


// Replace macro references to application name.

a_s_text = f_str_transform (a_s_text, "&appname", GetApplication ().appname)


// Replace macro references to frame title.

a_s_text = f_str_transform (a_s_text, "&frametitle", this.fnv_get_frametitle ())


// Return the resulting text item.

RETURN a_s_text
end function

public subroutine fnv_set_display_level (integer a_i_display_level);// Set value of instance variable to value passed.

i_i_display_level = a_i_display_level
end subroutine

public subroutine fnv_set_logging_level (integer a_i_logging_level);// Set value of instance variable to value passed.

i_i_logging_level = a_i_logging_level
end subroutine

public function integer fnv_get_display_level ();// Return value of instance variable.

RETURN i_i_display_level
end function

public function integer fnv_get_logging_level ();// Return value of instance variable.

RETURN i_i_logging_level
end function

public subroutine fnv_log_msg (string a_s_message_title, string a_s_message_text, integer a_i_severity_level);
// Log message to file specified in application .INI file.

string	s_log_entry, s_name1, s_name2, s_error_dir, s_error_log, s_error_old_log
integer	i_file_number
long	l_max_err_size

// Return if no instance of nv_ini.

IF NOT IsValid (g_nv_ini) THEN
	RETURN
END IF

// Get all the Initialization strings from the INI file.

IF g_nv_ini.fnv_is_valid () THEN
	s_error_dir = g_nv_ini.fnv_profile_string ("PowerTOOL", "ErrorLogDir", "")
	s_name1 = g_nv_ini.fnv_profile_string ("PowerTOOL", "ErrorLogName", "pwrtool.err")
	s_name2 = g_nv_ini.fnv_profile_string ("PowerTOOL", "ErrorOldLogName", "pwrtool.old")
	l_max_err_size = g_nv_ini.fnv_profile_int ("PowerTOOL", "ErrorMaxSize", 30000)
ELSE
	// No INI file exists or is open - use just the default values.
	s_error_dir = ""
	s_name1 = "pwrtool.err"
	s_name2 = "pwrtool.old"
	l_max_err_size = 30000
END IF

s_error_log = s_error_dir + "\" + s_name1
s_error_old_log = s_error_dir + "\" + s_name2

// Check to see if the file can be opened/created (e.g. path exists).
// If not, assume the path is bad is just just the file name on the
// root of the current drive.

i_file_number = FileOpen (s_error_log, LineMode!, Write!, LockReadWrite!, Append!)

IF i_file_number < 0 THEN
	s_error_log = "\" + s_name1
	s_error_old_log = "\" + s_name2
ELSE
	FileClose (i_file_number)
END IF

// Format log entry.  Don't get the date and time from the database as
// we may be reporting a database error.

s_log_entry = String (Today ()) + " " + String (Now ()) + "~r~n" + &
				"Severity: " + String (a_i_severity_level) + "~r~n" + &
				a_s_message_title + ":~r~n" + a_s_message_text

// Check the size of the existing file.  If it's greater than i_size_limit, move
// it to a backup file and start a new log file.

IF FileLength (s_error_log) > l_max_err_size THEN
	g_nv_env.fnv_copy_file (s_error_log, s_error_old_log, TRUE)
	FileDelete (s_error_log)
END IF


// Open the file, write the log entry, and then close the file for each entry.  This
// should ensure that each entry is flushed to the file.  Note that we do NOT want to
// display detected errors since this would generate recursive calls.

i_file_number = FileOpen (s_error_log, LineMode!, Write!, LockReadWrite!, Append!)

IF i_file_number < 0 THEN
	RETURN
END IF

FileWrite (i_file_number, s_log_entry)

FileClose (i_file_number)
end subroutine

public function string fnv_translate (string a_s_source);// Interface with transalation manager(s) to translate passed string
// into current language.

RETURN a_s_source
end function

public subroutine fnv_set_dialog_class (integer a_i_severity, string a_s_dialog_class);// Set value of instance variable array item to value passed.

i_s_dialog_class [a_i_severity] = a_s_dialog_class
end subroutine	

public function string fnv_get_dialog_class (integer a_i_severity);// Return value of instance variable associated with severity.


// Verify severity is within range.

IF a_i_severity < 1 OR &
	a_i_severity > UpperBound (i_s_dialog_class) THEN
	RETURN ""
END IF

RETURN i_s_dialog_class [a_i_severity]
end function

public function integer fnv_add_dw_repository (string a_s_dataobject);// Add a new datawindow repository to the array and set language.
// Returns:
//	 n	Index of new repository manager if successful
//	-1	Error encountered

Integer i_idx


//// Bail out if cache window doesn't exist.
//
//IF NOT IsValid (i_w_cache) THEN
//	RETURN -1
//END IF


// Create new repository at next available slot in the array.

i_idx = UpperBound (i_nv_repo) + 1

i_nv_repo [i_idx] = CREATE nv_repo_manager

i_nv_repo [i_idx].fnv_create_dw_repository (a_s_dataobject)

IF Len (i_s_language_id) > 0 THEN
	i_nv_repo [i_idx].fnv_set_language (i_s_language_id)
END IF

RETURN i_idx
end function

public function integer fnv_add_file_repository (string a_s_dataobject, string a_s_file_name);// Add a new file repository to the array and sets the language.
// Returns:
//	 n	Index of new repository manager if successful
//	-1	Error encountered

Integer i_idx


// Create new repository at next available slot in the array.

i_idx = UpperBound (i_nv_repo) + 1

i_nv_repo [i_idx] = CREATE nv_repo_manager

i_nv_repo [i_idx].fnv_create_file_repository (a_s_dataobject, &
												a_s_file_name)
IF Len (i_s_language_id) > 0 THEN
	i_nv_repo [i_idx].fnv_set_language (i_s_language_id)
END IF

RETURN i_idx
end function

public function integer fnv_display_msg (string a_s_message_title, string a_s_message_text, integer a_i_severity_level, string a_s_dialog_classname, string a_s_response_classname, integer a_i_response_default);
String s_dialog_class
icon e_icon
button e_button
Window w_dialog
str_pass str_pass


// Clean up input parameters.

a_s_message_title = Trim (a_s_message_title)
a_s_message_text = Trim (a_s_message_text)
a_s_dialog_classname = Lower (Trim (a_s_dialog_classname))
a_s_response_classname = Lower (Trim (a_s_response_classname))


// Get default dialog and response classes if dialog class is "Default!"

IF a_s_dialog_classname = "default!" THEN
	s_dialog_class = Lower (Trim (i_s_dialog_class [a_i_severity_level]))
	IF Right (s_dialog_class, 1) = "!" THEN			// Message box (has !)
		a_s_dialog_classname = s_dialog_class
		IF a_s_dialog_classname = "question!" THEN	// Question
			a_s_response_classname = "yesno!"
			a_i_response_default = 2
		ELSE														// Statement
			a_s_response_classname = "ok!"
			a_i_response_default = 1
		END IF
	ELSE															// Custom dialog (no !)
		a_s_dialog_classname = "custom!"
		a_s_response_classname = s_dialog_class
		a_i_response_default = 0
	END IF
elseif a_s_dialog_classname = "custom!" THEN 
		s_dialog_class = a_s_response_classname
END IF


// Format str_pass with title and text to be passed to dialog and open
// custom dialog if dialog class is "Custom!"
// Custom windows should set str_pass.i_idx to indicate action
// taken (i.e. which button pushed)

IF a_s_dialog_classname = "custom!" THEN
	str_pass.s_win_title = a_s_message_title
	str_pass.s [1] = a_s_message_text
	str_pass.d[1] = a_i_response_default
	IF a_s_response_classname = "" THEN
		a_s_response_classname = "w_msg_dialog"
	END IF
	message.fnv_set_str_pass (str_pass)
	Open (w_dialog, s_dialog_class)
	str_pass = message.fnv_get_str_pass()
	RETURN str_pass.i_idx
END IF


// If message is not found, display w_msg_dialog.

IF a_s_dialog_classname = "not found!" THEN
	str_pass.s_win_title = a_s_message_title
	str_pass.s [1] = "Unknown Message:~r~n~r~n" + a_s_message_text
	s_dialog_class = "w_msg_dialog"
	message.fnv_set_str_pass (str_pass)
	Open (w_dialog, s_dialog_class)
	RETURN -1
END IF


// Display MessageBox depending on dialog and response classes.

CHOOSE CASE a_s_dialog_classname
	CASE "none!"
		e_icon = None!
	CASE "information!"
		e_icon = Information!
	CASE "exclamation!"
		e_icon = Exclamation!
	CASE "stopsign!"
		e_icon = StopSign!
	CASE "question!"
		e_icon = Question!
	CASE ELSE
		e_icon = Information!
END CHOOSE

CHOOSE CASE a_s_response_classname
	CASE "abortretryignore!"
		e_button = AbortRetryIgnore!
	CASE "ok!"
		e_button = OK!
	CASE "okcancel!"
		e_button = OKCancel!
	CASE "retrycancel!"
		e_button = RetryCancel!
	CASE "yesno!"
		e_button = YesNo!
	CASE "yesnocancel!"
		e_button = YesNoCancel!
	CASE ELSE
		e_button = OK!
END CHOOSE

IF a_i_response_default < 1 THEN
	a_i_response_default = 1
END IF

RETURN MessageBox (a_s_message_title, a_s_message_text, e_icon, &
													e_button, a_i_response_default)

end function

protected function string fnv_get_frametitle ();// Get the frame's title as the value in the application .INI file, &
// if it exists and perform symbolic substitution.

String s_title


// Check the INI file first.

IF IsValid (g_nv_ini) THEN
	IF g_nv_ini.fnv_is_valid () THEN
		s_title = g_nv_ini.fnv_profile_string ("PowerTOOL", &
																	"FrameTitle","")
		IF Len (s_title) > 0 THEN
			s_title = f_str_transform (s_title, "&appname", &
														GetApplication ().appname)
			RETURN s_title
		END IF
	END IF
END IF


// Default is the literal "Application " + the application name.

s_title = "Application " + GetApplication ().appname

RETURN s_title
end function

public subroutine fnv_initialize ();// Set default display dialog classes.

this.fnv_set_dialog_class (1, "w_msg_dialog")

this.fnv_set_dialog_class (2, "Information!")

this.fnv_set_dialog_class (3, "Exclamation!")

this.fnv_set_dialog_class (4, "StopSign!")

this.fnv_set_dialog_class (5, "w_msg_dialog")

this.fnv_set_dialog_class (6, "w_msg_dialog")


// Set default language and display level.

this.fnv_set_language ("english")

this.fnv_set_display_level (0)

this.fnv_set_logging_level (0)


// Add default PowerTOOL DataWindow repository.

this.fnv_add_dw_repository ("d_repo_cache_pt_dw")

end subroutine

public subroutine fnv_reset ();// Destroy objects.

Integer i_idx


// Destroy remaining repository managers.

FOR i_idx = 1 TO UpperBound (i_nv_repo)
	IF IsValid (i_nv_repo [i_idx]) THEN
		DESTROY i_nv_repo [i_idx]
	END IF
NEXT

end subroutine

public function long fnv_set_language (string a_s_language_id);// Set instance variable and set language in each repository.
// Returns:
//	 l	total number of rows in all repositories
//	-1	an error occured

Integer i_idx
Long l_row_cnt, l_tot_row_cnt


// Set value of instance variable.

i_s_language_id = Lower (Trim (a_s_language_id))


// Set language in cache window.

FOR i_idx = 1 TO UpperBound (i_nv_repo)
	l_row_cnt = i_nv_repo [i_idx].fnv_set_language (i_s_language_id)
	IF l_row_cnt < 0 THEN
		RETURN l_row_cnt
	END IF
	l_tot_row_cnt += l_row_cnt
NEXT


// Return total number of rows in all DataWindows.

RETURN l_tot_row_cnt
end function		

public subroutine fnv_retrieve_msg (string a_s_message_group, string a_s_message_id, ref string a_s_message_title, ref string a_s_message_text, ref integer a_i_severity_level, ref integer a_i_logging_ind, ref string a_s_dialog_classname, ref string a_s_response_classname, ref integer a_i_response_default);// Scan each reposity, in turn, for the message identified by message
// ID.  Any passed title, severity or logging indicator must be preserved.

String s_message_title
Integer i_severity_level, i_logging_ind, i_idx


// Save title, severity and logging indicator.

s_message_title = a_s_message_title

i_severity_level = a_i_severity_level

i_logging_ind = a_i_logging_ind


// Scan each repository, in turn, for the message.

FOR i_idx = 1 TO UpperBound (i_nv_repo)
	IF IsValid (i_nv_repo [i_idx]) THEN
		IF i_nv_repo [i_idx].fnv_retrieve_msg (a_s_message_group, &
															a_s_message_id, &
															a_s_message_title, &
															a_s_message_text, &
															a_i_severity_level, &
															a_i_logging_ind, &
															a_s_dialog_classname, &
															a_s_response_classname, &
															a_i_response_default) THEN
			// Successfully got message
			EXIT
		END IF
		IF i_idx = UpperBound (i_nv_repo) THEN
			// At the end - message will not be found - use message ID
			a_s_message_text = a_s_message_id
			a_s_dialog_classname = "Not Found!"
		END IF
	END IF
NEXT


// Restore title, severity and logging indicator, if necessary.

IF Len (s_message_title) > 0 THEN
	a_s_message_title = s_message_title
END IF

IF i_severity_level > 0 THEN
	a_i_severity_level = i_severity_level
END IF

IF i_logging_ind > 0 THEN
	a_i_logging_ind = i_logging_ind
END IF


// Ensure that neither title nor text is null.

IF Len (Trim (a_s_message_title)) > 0 THEN
	// Okay, there's a title
ELSE
	a_s_message_title = GetApplication ().appname
END IF

IF Len (Trim (a_s_message_text)) > 0 THEN
	// Okay, there's text
ELSE
	a_s_message_text = "Unknown"
END IF


// Transform special characters.

a_s_message_text = f_str_transform (a_s_message_text, "~~n", "~n")

a_s_message_text = f_str_transform (a_s_message_text, "~~r", "~r")

a_s_message_text = f_str_transform (a_s_message_text, "~~t", "~t")

end subroutine

public function integer fnv_process_msg (string a_s_message_group, string a_s_message_id, string a_s_parm_string, string a_s_message_title, integer a_i_severity_level, integer a_i_logging_ind);// Retrieve the message identified by message ID, perform any parm
// substitution and optionally display and/or log the message, depending
// on severity.

String s_message_text, s_dialog_classname, s_response_classname
Integer i_response_default


// Retrieve the message from the repository.

this.fnv_retrieve_msg (a_s_message_group, &
								a_s_message_id, &
								a_s_message_title, &
								s_message_text, &
								a_i_severity_level, &
								a_i_logging_ind, &
								s_dialog_classname, &
								s_response_classname, &
								i_response_default)


// Perform macro and parm substitution on the message title and text.

a_s_message_title = this.fnv_parmsub (a_s_message_title, "")

s_message_text = this.fnv_parmsub (s_message_text, a_s_parm_string)


// An unknown severity will be treated as a fatal error.

IF a_i_severity_level < 1 OR &
	IsNull (a_i_severity_level) THEN
	a_i_severity_level = 6
END IF


// Log the message if severity is high enough or the logging
// indicator is greater than 1 (force logging).

IF a_i_logging_ind > 1 OR &
	a_i_severity_level >= this.fnv_get_logging_level () THEN
	this.fnv_log_msg (a_s_message_title, s_message_text, a_i_severity_level)
END IF


// Display the message if severity is high enough.

IF a_i_severity_level >= this.fnv_get_display_level () THEN
	RETURN this.fnv_display_msg (a_s_message_title, s_message_text, &
										a_i_severity_level, s_dialog_classname, &
										s_response_classname, i_response_default)
ELSE
	RETURN i_response_default
END IF
end function

public function integer fnv_add_db_repository (string a_s_dataobject, nv_transaction a_tr_trans);// Add a new database repository to the array and sets the language.
// Returns:
//	 n	Index of new repository manager if successful
//	-1	Error encountered

Integer i_idx


// Create new repository at next available slot in the array.

i_idx = UpperBound (i_nv_repo) + 1

i_nv_repo [i_idx] = CREATE nv_repo_manager

i_nv_repo [i_idx].fnv_create_db_repository (a_s_dataobject, &
															a_tr_trans)

IF Len (i_s_language_id) > 0 THEN
	i_nv_repo [i_idx].fnv_set_language (i_s_language_id)
END IF

RETURN i_idx
end function

on constructor;// Initialize the message manager.

this.fnv_initialize ()


// Force w_msg_dialog into any standalone EXE.

IsValid (w_msg_dialog)
end on

on destructor;// Reset (close) the message manager.

this.fnv_reset ()
end on

on nv_msg_manager_pt.create
TriggerEvent( this, "constructor" )
end on

on nv_msg_manager_pt.destroy
TriggerEvent( this, "destructor" )
end on

