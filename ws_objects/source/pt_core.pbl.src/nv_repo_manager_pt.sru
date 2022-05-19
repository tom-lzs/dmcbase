$PBExportHeader$nv_repo_manager_pt.sru
$PBExportComments$Gestionnaire de répertoire de messages PowerTOOL
forward
global type nv_repo_manager_pt from nonvisualobject
end type
end forward

global type nv_repo_manager_pt from nonvisualobject
end type
global nv_repo_manager_pt nv_repo_manager_pt

type variables
nv_dsa i_ds_repo		// Repository DataStore

String i_s_repo_style	// Type of repository ('db' 'dw' or 'file')

String i_s_language_id	// Current language
end variables

forward prototypes
public function string fnv_get_language ()
public function boolean fnv_retrieve_msg (string a_s_message_group, string a_s_message_id, ref string a_s_message_title, ref string a_s_message_text, ref integer a_i_severity_level, ref integer a_i_logging_ind, ref string a_s_dialog_classname, ref string a_s_response_classname, ref integer a_i_response_default)
public function long fnv_set_language (string a_s_language_id)
protected function integer fnv_create_repository ()
public function integer fnv_create_db_repository (string a_s_dataobject, nv_transaction a_tr_trans)
public function integer fnv_create_file_repository (string a_s_dataobject, string a_s_file_name)
public function integer fnv_create_dw_repository (string a_s_dataobject)
end prototypes

public function string fnv_get_language ();// Return value of instance variable.

RETURN i_s_language_id
end function

public function boolean fnv_retrieve_msg (string a_s_message_group, string a_s_message_id, ref string a_s_message_title, ref string a_s_message_text, ref integer a_i_severity_level, ref integer a_i_logging_ind, ref string a_s_dialog_classname, ref string a_s_response_classname, ref integer a_i_response_default);// Retrieve (translated) message from the repository.

Long l_row_num


// Bail out if repository is invalid.

IF NOT IsValid (i_ds_repo) THEN
	RETURN FALSE
END IF


// Search for the row containing message ID.

a_s_message_group = Lower (Trim (a_s_message_group))

a_s_message_id = Lower (Trim (a_s_message_id))

l_row_num = i_ds_repo.Find ("message_group = ~"" + &
									a_s_message_group + "~"" + &
									" and message_id = ~"" + &
									a_s_message_id + "~"", &
									1, i_ds_repo.RowCount ())

IF l_row_num < 1 THEN
	RETURN FALSE
END IF


// Return the data on the row found.

a_s_message_title = i_ds_repo.GetItemString (l_row_num, "message_title")

a_s_message_text = i_ds_repo.GetItemString (l_row_num, "message_text")

a_i_severity_level = i_ds_repo.GetItemNumber (l_row_num, "severity_level")

a_i_logging_ind = i_ds_repo.GetItemNumber (l_row_num, "logging_ind")

a_s_dialog_classname = i_ds_repo.GetItemString (l_row_num, "dialog_classname")

a_s_response_classname = i_ds_repo.GetItemString (l_row_num, "response_classname")

a_i_response_default = i_ds_repo.GetItemNumber (l_row_num, "response_default")

RETURN TRUE
end function

public function long fnv_set_language (string a_s_language_id);// Set the current language id and return the number of rows in the
// DataStore after the filter/retrieve.
// Returns:
//	 l	Number of rows in DataStore
//	-1	An error occured


// Bail out if no change is detected.

a_s_language_id = Lower (Trim (a_s_language_id))

IF a_s_language_id = i_s_language_id THEN
	RETURN i_ds_repo.RowCount ()
END IF


// Bail out if no language is specified.

IF Len (a_s_language_id) < 1 THEN
	RETURN -1
END IF


// Set the current language ID and retrieve/filter the repository
// DataStore, depending on repository style.

i_s_language_id = a_s_language_id

CHOOSE CASE i_s_repo_style

	CASE 'db'

		RETURN i_ds_repo.Retrieve (i_s_language_id)

	CASE 'dw', 'file'

		i_ds_repo.SetFilter ("Lower (language_id) = ~"" + i_s_language_id + "~"")
		i_ds_repo.Filter ()
		RETURN i_ds_repo.RowCount ()

	CASE ELSE

		RETURN -1	// Unknown style

END CHOOSE
end function

protected function integer fnv_create_repository ();// Create a repository cache.
// Returns:
//	 1 DataStore successfully created
//	-1 Error occured

Integer i_rc


// Bail out if cache already exists.

IF IsValid (i_ds_repo) THEN
	RETURN 1
END IF


// Add database repository to cache window.

i_ds_repo = CREATE nv_dsa

IF NOT IsValid (i_ds_repo) THEN
	RETURN -1
END IF


// Success!

RETURN 1
end function

public function integer fnv_create_db_repository (string a_s_dataobject, nv_transaction a_tr_trans);// Create a database message repository.
// Returns:
//	 1 Repository successfully created
//	-1 Error occured


// Bail out if no transaction is passed.

IF NOT IsValid (a_tr_trans) THEN
	RETURN -1
END IF


// Bail out if cache can not be created.

IF this.fnv_create_repository () < 0 THEN
	RETURN -1
END IF


// Set dataobject and transaction.  Default data object is PowerCerv
// Admin data object.

IF Len (Trim (a_s_dataobject)) > 0 THEN
	a_s_dataobject = Trim (a_s_dataobject)
ELSE
	a_s_dataobject = "d_repo_cache_pc_db"
END IF

i_ds_repo.dataobject = a_s_dataobject

i_ds_repo.SetTransObject (a_tr_trans)


// Populate the DataWindow if language has been set.

IF Len (i_s_language_id) > 0 THEN
	i_ds_repo.Retrieve (i_s_language_id)
END IF


// Success!

i_s_repo_style = 'db'

RETURN 1
end function

public function integer fnv_create_file_repository (string a_s_dataobject, string a_s_file_name);// Create a file message repository.
// Returns:
//	 1 Repository successfully created
//	-1 Error occured


// Bail out if cache can not be created.

IF this.fnv_create_repository () < 0 THEN
	RETURN -1
END IF


// Set dataobject.  Default data object is PowerCerv data object.

IF Len (Trim (a_s_dataobject)) > 0 THEN
	a_s_dataobject = Trim (a_s_dataobject)
ELSE
	a_s_dataobject = "d_repo_cache"
END IF

i_ds_repo.dataobject = a_s_dataobject


// Import file into DataWindow.

IF i_ds_repo.ImportFile (a_s_file_name) < 0 THEN
	RETURN -1
END IF


// Filter the DataWindow if language has been set.

IF Len (i_s_language_id) > 0 THEN
	i_ds_repo.SetFilter ("language_id = ~"" + i_s_language_id + "~"")
	i_ds_repo.Filter ()
END IF


// Success!

i_s_repo_style = 'file'

RETURN 1
end function

public function integer fnv_create_dw_repository (string a_s_dataobject);// Create a DataWindow message repository.
// Returns:
//	 1 Repository successfully created
//	-1 Error occured


// Bail out if cache can not be created.

IF this.fnv_create_repository () < 0 THEN
	RETURN -1
END IF


// Set dataobject.  Default data object is PowerTOOL data object.

IF Len (Trim (a_s_dataobject)) > 0 THEN
	a_s_dataobject = Trim (a_s_dataobject)
ELSE
	a_s_dataobject = "d_repo_cache_pt_dw"
END IF

i_ds_repo.dataobject = a_s_dataobject


// Filter the DataWindow if language has been set.

IF Len (i_s_language_id) > 0 THEN
	i_ds_repo.SetFilter ("language_id = ~"" + i_s_language_id + "~"")
	i_ds_repo.Filter ()
END IF


// Success!

i_s_repo_style = 'dw'

RETURN 1
end function

on nv_repo_manager_pt.create
TriggerEvent( this, "constructor" )
end on

on nv_repo_manager_pt.destroy
TriggerEvent( this, "destructor" )
end on

