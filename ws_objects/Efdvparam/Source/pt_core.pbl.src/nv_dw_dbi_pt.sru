$PBExportHeader$nv_dw_dbi_pt.sru
$PBExportComments$Ancêtre des objets interface DataWindow/Base de données
forward
global type nv_dw_dbi_pt from nonvisualobject
end type
end forward

global type nv_dw_dbi_pt from nonvisualobject
end type
global nv_dw_dbi_pt nv_dw_dbi_pt

type variables
PROTECTED:

// The following variables describe the DataWindow environment
powerobject i_po_parent	// parent object
u_dwa i_dw_parent		// parent datawindow
nv_dsa i_ds_parent	// parent datastore
nv_transaction i_tr	// transaction (must be set by parent)

// The following variables control/audit database access
str_dberror	i_str_dberror	// last database error info

end variables

forward prototypes
public function boolean fnv_get_dberror ()
public function long fnv_get_dberror_row_num ()
public function string fnv_get_dberror_col_name ()
public function dwbuffer fnv_get_dberror_buffer ()
public function string fnv_get_dberror_msg ()
public subroutine fnv_set_transaction (nv_transaction a_tr)
public function int fnv_set_batch_update (boolean a_b_batch_update)
public function int fnv_set_procedure_update (boolean a_b_procedure_update)
public subroutine fnv_set_commit_on_update (boolean a_b_commit_on_update)
public subroutine fnv_set_rollback_on_failure (boolean a_b_rollback_on_failure)
public subroutine fnv_set_ins_proc_name (string a_s_ins_proc_name)
public subroutine fnv_set_upd_proc_name (string a_s_upd_proc_name)
public subroutine fnv_set_del_proc_name (string a_s_del_proc_name)
public subroutine fnv_set_procedure_names (string a_s_ins_proc_name, string a_s_upd_proc_name, string a_s_del_proc_name)
public function int fnv_get_update_status ()
public function boolean fnv_get_procedure_update ()
public function boolean fnv_get_commit_on_update ()
public function boolean fnv_get_rollback_on_failure ()
public function int fnv_update ()
public function boolean fnv_get_preview_batch_sql ()
public subroutine fnv_set_preview_batch_sql (boolean a_b_preview_batch_sql)
public function int fnv_set_reset_crlf (boolean a_b_batch_update)
public function boolean fnv_get_reselect_after_update ()
public subroutine fnv_set_reselect_after_update (boolean a_b_commit_on_update)
protected function string fnv_get_batch_sql ()
public function boolean fnv_get_manage_transaction ()
public subroutine fnv_set_manage_transaction (boolean a_b_manage_transaction)
public function boolean fnv_get_batch_update ()
protected function string fnv_build_dbms_msg (long a_l_sqlcode, string a_s_sqlerrtext)
public function boolean fnv_get_reset_crlf ()
public function integer fnv_event_retrieveend ()
public subroutine fnv_reset_dberror ()
public subroutine fnv_set_update_status (integer a_i_update_status)
public function boolean fnv_commit ()
public subroutine fnv_rollback ()
public function string fnv_get_dberror_sql ()
public function integer fnv_get_dberror_dberrorcode ()
public function string fnv_get_dberror_dberrormessage ()
public subroutine fnv_set_dberror (dwbuffer a_e_buffer, long a_l_row_num, string a_s_col_name, string a_s_msg, string a_s_sql, integer a_i_dberrorcode, string a_s_dberrormessage)
public function integer fnv_event_sqlpreview (SQLPreviewType a_e_sqltype, string a_s_sqlsyntax, dwbuffer a_e_buffer, long a_l_row)
public function integer fnv_event_dberror (long a_l_sqldbcode, string a_s_sqlerrtext, string a_s_sqlsyntax, dwbuffer a_e_buffer, long a_l_row)
public function boolean fnv_display_dberror ()
public subroutine fnv_set_parent (readonly u_dwa a_dw_parent)
public subroutine fnv_set_parent (ref nv_dsa a_ds_parent)
end prototypes

public function boolean fnv_get_dberror ();// Return boolean indicating whether dberror structure has been populated.

RETURN i_str_dberror.b_encountered
end function

public function long fnv_get_dberror_row_num ();// Return row number where dberror occured.

RETURN i_str_dberror.l_row_num
end function

public function string fnv_get_dberror_col_name ();// Return column name where dberror occured.

RETURN i_str_dberror.s_col_name
end function

public function dwbuffer fnv_get_dberror_buffer ();// Return buffer where dberror occured.

RETURN i_str_dberror.e_buffer
end function

public function string fnv_get_dberror_msg ();// Return message contained in dberror structure.

RETURN i_str_dberror.s_msg
end function

public subroutine fnv_set_transaction (nv_transaction a_tr);// Set the transaction associated with the parent dw

i_tr = a_tr
end subroutine

public function int fnv_set_batch_update (boolean a_b_batch_update);// Function stub.

RETURN -1
end function

public function int fnv_set_procedure_update (boolean a_b_procedure_update);// Function stub.

RETURN -1
end function

public subroutine fnv_set_commit_on_update (boolean a_b_commit_on_update);// Function stub.
end subroutine

public subroutine fnv_set_rollback_on_failure (boolean a_b_rollback_on_failure);// Function stub.
end subroutine

public subroutine fnv_set_ins_proc_name (string a_s_ins_proc_name);// Function stub.
end subroutine

public subroutine fnv_set_upd_proc_name (string a_s_upd_proc_name);// Function stub.
end subroutine

public subroutine fnv_set_del_proc_name (string a_s_del_proc_name);// Function stub.
end subroutine

public subroutine fnv_set_procedure_names (string a_s_ins_proc_name, string a_s_upd_proc_name, string a_s_del_proc_name);// Function stub.
end subroutine

public function int fnv_get_update_status ();// Function stub.

RETURN 0
end function

public function boolean fnv_get_procedure_update ();// Function stub.

RETURN FALSE
end function

public function boolean fnv_get_commit_on_update ();// Function stub.

RETURN FALSE
end function

public function boolean fnv_get_rollback_on_failure ();// Function stub.

RETURN FALSE
end function

public function int fnv_update ();// Function stub.

RETURN -1
end function

public function boolean fnv_get_preview_batch_sql ();// Function stub

RETURN FALSE
end function

public subroutine fnv_set_preview_batch_sql (boolean a_b_preview_batch_sql);// Function stub.
end subroutine

public function int fnv_set_reset_crlf (boolean a_b_batch_update);// Function stub.

RETURN -1
end function

public function boolean fnv_get_reselect_after_update ();// Function stub.

RETURN FALSE
end function

public subroutine fnv_set_reselect_after_update (boolean a_b_commit_on_update);// Function stub.
end subroutine

protected function string fnv_get_batch_sql ();// Function stub

RETURN ""
end function

public function boolean fnv_get_manage_transaction ();// Function stub.

RETURN FALSE
end function

public subroutine fnv_set_manage_transaction (boolean a_b_manage_transaction);// Function stub.
end subroutine

public function boolean fnv_get_batch_update ();// Function stub.

RETURN FALSE
end function

protected function string fnv_build_dbms_msg (long a_l_sqlcode, string a_s_sqlerrtext);// Function to format DBMS error message for display.

Integer i_pos


// To make WATCOM error message a little nicer, strip "[WATCOM SQL]"
// from the message.

i_pos = Pos (a_s_sqlerrtext, "[WATCOM SQL]: ")

IF i_pos > 1 THEN
	a_s_sqlerrtext = Mid (a_s_sqlerrtext, i_pos + 14)
END IF

i_pos = Pos (a_s_sqlerrtext, "[WATCOM SQL]")

IF i_pos > 1 THEN
	a_s_sqlerrtext = Mid (a_s_sqlerrtext, i_pos + 12)
END IF


// Format DBMS error message with code and message

RETURN "SQL Code " + String (a_l_sqlcode) + &
		" encountered~r~n~r~n" + a_s_sqlerrtext
end function

public function boolean fnv_get_reset_crlf ();// Function stub.

RETURN FALSE
end function

public function integer fnv_event_retrieveend ();// This function is called by the parent DataWindow on a RetrieveEnd!
// event.  It will return -1 if a dberror was encountered and 1
// otherwise.


// Display dberror.

IF this.fnv_display_dberror () THEN
	RETURN -1
END IF


RETURN 1
end function

public subroutine fnv_reset_dberror ();// Clear out the dberror structure

i_str_dberror.b_encountered = FALSE

i_str_dberror.e_buffer = Primary!

i_str_dberror.l_row_num = 0

i_str_dberror.s_col_name = ""

i_str_dberror.s_sql = ""

i_str_dberror.i_dberrorcode = 0

i_str_dberror.s_dberrormessage = ""

i_str_dberror.s_msg = ""
end subroutine

public subroutine fnv_set_update_status (integer a_i_update_status);// Function stub.
end subroutine

public function boolean fnv_commit ();// Function stub.

RETURN FALSE
end function

public subroutine fnv_rollback ();// Function stub.
end subroutine

public function string fnv_get_dberror_sql ();// Return sql which caused the error.

RETURN i_str_dberror.s_sql
end function

public function integer fnv_get_dberror_dberrorcode ();// Return DataWindow dbErrorCode.

RETURN i_str_dberror.i_dberrorcode
end function

public function string fnv_get_dberror_dberrormessage ();// Return DataWindow dbErrorMessage.

RETURN i_str_dberror.s_dberrormessage
end function

public subroutine fnv_set_dberror (dwbuffer a_e_buffer, long a_l_row_num, string a_s_col_name, string a_s_msg, string a_s_sql, integer a_i_dberrorcode, string a_s_dberrormessage);// Populate the dberror structure with the values passed

i_str_dberror.b_encountered = TRUE

i_str_dberror.e_buffer = a_e_buffer

i_str_dberror.l_row_num = a_l_row_num

i_str_dberror.s_col_name = a_s_col_name

i_str_dberror.s_sql = a_s_sql

i_str_dberror.i_dberrorcode = a_i_dberrorcode

i_str_dberror.s_dberrormessage = a_s_dberrormessage

i_str_dberror.s_msg = a_s_msg
end subroutine

public function integer fnv_event_sqlpreview (SQLPreviewType a_e_sqltype, string a_s_sqlsyntax, dwbuffer a_e_buffer, long a_l_row);// Function stub.

RETURN 0
end function

public function integer fnv_event_dberror (long a_l_sqldbcode, string a_s_sqlerrtext, string a_s_sqlsyntax, dwbuffer a_e_buffer, long a_l_row);// This function is called by the parent DataWindow on a dbError! event.
// It will return the action code to be set by the calling event.

// If the dberror structure is already populated then simply return
// an action of 1 to tell PowerBuilder not to display the message.

IF fnv_get_dberror () THEN
	RETURN 1
END IF

// Populate the dberror structure.

fnv_set_dberror (a_e_buffer, a_l_row, "", &
	fnv_build_dbms_msg (a_l_sqldbcode, &
								a_s_sqlerrtext), &								
								a_s_sqlsyntax, &
								a_l_sqldbcode, &
								a_s_sqlerrtext)


// Return an action of 1 to tell PowerBuilder not to display the
// message.

RETURN 1
end function

public function boolean fnv_display_dberror ();// Display the message contained in the dberror structure, if it is
// populated.  This function will also:
//
//		- Recover an error row from the Delete! buffer
//		- Set focus to the row pointed to by l_row_num if
//			it is > 0 and the row is in the Primary! buffer
//		- Set focus to the column pointed to by s_col_name if
//			it is specified and the row is in the Primary! buffer
//		- Set focus to the DataWindow

Long l_row_num


// Return FALSE if the structure isn't populated

IF NOT this.fnv_get_dberror () THEN
	RETURN FALSE
END IF


// Recover row from Delete! buffer, if necessary.

IF i_str_dberror.e_buffer = Delete! THEN
	l_row_num = i_po_parent.function dynamic fu_recover_deleted_row (i_str_dberror.l_row_num)
	IF l_row_num > 0 THEN
		i_str_dberror.e_buffer = Primary!
		i_str_dberror.l_row_num = l_row_num
	END IF
END IF


// Scroll to the row if it's in the Primary! buffer

IF i_po_parent.typeof() = datawindow! then
	IF i_str_dberror.e_buffer = Primary! AND &
		i_str_dberror.l_row_num > 0 THEN
		i_dw_parent.ScrollToRow (i_str_dberror.l_row_num)
	END IF
END IF


// Set the column if in the Primary! buffer
   
IF i_str_dberror.e_buffer = Primary! AND &
	Len (Trim (i_str_dberror.s_col_name)) > 0 THEN
	i_po_parent.function dynamic SetColumn (i_str_dberror.s_col_name)
END IF


// Guarantee there is a message to display.

IF Len (Trim (i_str_dberror.s_msg)) <= 0 OR &
	IsNull (i_str_dberror.s_msg) THEN
	i_str_dberror.s_msg = "Unknown Database Error~r~n~r~n" + &
								"Contact your System Administrator."
	g_nv_msg_mgr.fnv_process_msg ("pt", "Unknown DB Error", "", "", 0, 0)
	if typeof(i_po_parent) = datawindow! then
		i_dw_parent.SetFocus ()
	end if
	RETURN TRUE
END IF

g_nv_msg_mgr.fnv_log_msg("DBerror ",f_str_transform (i_str_dberror.s_dberrormessage, ",", ",,") + ", " + &
				f_str_transform (i_str_dberror.s_msg, ",", ",,") + " Dans l'object " + i_po_parent.className() , 99)
				
// Display the message and set focus to the parent DataWindow.  If the
// message begins with "&" then it should be passed to the message
// manager as a message ID.

IF Left (i_str_dberror.s_msg, 1) = "&" THEN
	g_nv_msg_mgr.fnv_process_msg ("pt", Mid (i_str_dberror.s_msg, 2), &
				String (i_str_dberror.i_dberrorcode) + ", " + &
				f_str_transform (i_str_dberror.s_dberrormessage, ",", ",,") + ", " + &
				f_str_transform (i_str_dberror.s_msg, ",", ",,") + " Dans l'object " + i_po_parent.className() , &
																	"", 0, 0)
ELSE
	g_nv_msg_mgr.fnv_process_msg ("pt", "DataWindow DB Error", &
				String (i_str_dberror.i_dberrorcode) + ", " + &
				f_str_transform (i_str_dberror.s_dberrormessage, ",", ",,") + ", " + &
				f_str_transform (i_str_dberror.s_msg, ",", ",,") +  " Dans l'object " + i_po_parent.className() , &
																	"", 0, 0)
END IF

if typeof(i_po_parent) = datawindow! then
	i_dw_parent.SetFocus ()
end if

RETURN TRUE
end function

public subroutine fnv_set_parent (readonly u_dwa a_dw_parent);// Save the parent into an instance variable for later reference.

i_po_parent = a_dw_parent
i_dw_parent = a_dw_parent
end subroutine

public subroutine fnv_set_parent (ref nv_dsa a_ds_parent);// Save the parent into an instance variable for later reference.

i_po_parent = a_ds_parent
i_ds_parent = a_ds_parent
end subroutine

event constructor;//
//	Maintenance
//		3/30/95	#37	Added function stubs for the get and set functions
//							for automatic transaction management.
//							Protected the following methods:
//								fnv_build_dbms_msg,
//								fnv_get_batch_sql.
boolean b_junk
b_junk = fnv_get_commit_on_update()

end event

on nv_dw_dbi_pt.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nv_dw_dbi_pt.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

