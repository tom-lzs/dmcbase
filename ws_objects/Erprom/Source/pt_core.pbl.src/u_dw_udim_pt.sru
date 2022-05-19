$PBExportHeader$u_dw_udim_pt.sru
$PBExportComments$Contrôle DataWindow pour les mises à jour multi-lignes
forward
global type u_dw_udim_pt from u_dwa
end type
end forward

global type u_dw_udim_pt from u_dwa
end type
global u_dw_udim_pt u_dw_udim_pt

type variables
PROTECTED Boolean i_b_req_only_at_update = TRUE	// check for required only on update
PROTECTED Boolean i_b_confirm_delete		// display confirmation message on delete
end variables

forward prototypes
public function boolean fu_check_required ()
public function boolean fu_updated ()
public subroutine fu_set_commit_on_update (boolean a_b_commit)
public function boolean fu_update ()
public function boolean fu_delete (long a_l_row)
public function int fu_get_update_status ()
public subroutine fu_set_confirm_delete (boolean a_b_confirm_delete)
public function long fu_insert (long a_l_row_num)
public function boolean fu_commit ()
public function boolean fu_rollback ()
public function boolean fu_validate ()
public function boolean fu_accepttext ()
public function boolean fu_pre_update ()
public subroutine fu_set_rollback_on_failure (boolean a_b_rollback_on_failure)
public subroutine fu_set_req_only_at_update (boolean a_b_req_only_at_update)
public function integer settransobject (nv_transaction a_trans)
public function boolean fu_get_req_only_at_update ()
public function boolean fu_get_confirm_delete ()
public function boolean fu_get_nilisnull (string a_s_col_name)
end prototypes

public function boolean fu_check_required ();// This function looks at the required attribute for each column.
// It returns TRUE if all required fields have values,
//            FALSE if not.
// If successful, it will call fu_check_required for the next
// datawindow in the chain.

Long l_row_num
Integer i_col_num, i_rc, i_pos
String s_colname, s_msg, s_expr, s_eval


// Display error and exit if ommitted data has been found in the
// Primary! buffer.

l_row_num = 1

i_col_num = 1

i_rc = this.FindRequired (Primary!, l_row_num, i_col_num, &
										s_colname, TRUE)

IF i_rc > 0 AND &
	l_row_num > 0 THEN
	this.ScrollToRow (l_row_num)
	this.SetColumn (s_colname)
	this.fu_display_validation_msg (l_row_num, s_colname, &
									"&Required Column", fu_get_error_title ())
	i_nv_dw_dbi.fnv_set_update_status (-3)
	this.SetFocus ()
	RETURN FALSE
END IF


// Display error and exit if ommitted data has been found in the
// Filter! buffer.

l_row_num = 1

i_col_num = 1

i_rc = this.FindRequired (Filter!, l_row_num, i_col_num, &
										s_colname, TRUE)

IF i_rc > 0 AND &
	l_row_num > 0 THEN
	this.fu_display_validation_msg (l_row_num, s_colname, &
									"&Required Column", fu_get_error_title ())
	i_nv_dw_dbi.fnv_set_update_status (-3)
	this.SetFocus ()
	RETURN FALSE
END IF


// Check required columns in the next datawindow, if it exists.
// An update status of -8 indicates that another datawindow in
// the chain generated the error.

IF IsValid (fu_get_next ()) THEN
	IF NOT fu_get_next ().function dynamic fu_check_required () THEN
		i_nv_dw_dbi.fnv_set_update_status (-8)
		RETURN FALSE
	END IF
END IF


RETURN TRUE
end function

public function boolean fu_updated ();// Return the success of the prior update

IF i_nv_dw_dbi.fnv_get_update_status () > 0 THEN
	RETURN TRUE
ELSE
	RETURN FALSE
END IF
end function

public subroutine fu_set_commit_on_update (boolean a_b_commit);// This OBSOLETE function is here for compatibility

i_nv_dw_dbi.fnv_set_commit_on_update (a_b_commit)
end subroutine

public function boolean fu_update ();// Return codes:
//
// Returns TRUE if update worked for itself and all datawindows in
// the chain, FALSE otherwise
//
// IF this is NOT the head datawindow then the fu_update () function
// will be called for the head datawindow.
//
// IF this the head datawindow in the chain then the pre-update
// process will be called before calling the non-visual object
// for the update.


// Route the call to the head datawindow if this is NOT the head.

IF IsValid (fu_get_prior ()) THEN
	RETURN this.fu_get_head_po ().function dynamic fu_update ()
END IF


// Perform pre-Update validation

IF NOT this.fu_pre_update () THEN
	RETURN FALSE
END IF


// Call Update of DataWindow via the DataWindow database interface.

IF this.fu_get_nv_dw_dbi ().fnv_update () > 0 THEN
	RETURN TRUE
ELSE
	RETURN FALSE
END IF
end function

public function boolean fu_delete (long a_l_row);// Trigger the pre-delete event.  If message.returnvalue is negative
// the delete is abandoned.

this.TriggerEvent ("ue_predelete")

IF message.returnvalue < 0 THEN
	this.SetFocus ()
	RETURN FALSE
END IF


// Delete the record pointed to by the passed row number.

IF this.DeleteRow (a_l_row) < 0 THEN
	this.SetFocus ()
	RETURN FALSE
END IF


// Trigger the post-delete event and set focus to this DataWindow.

this.TriggerEvent ("ue_postdelete")

this.SetFocus ()

RETURN TRUE
end function

public function int fu_get_update_status ();// This OBSOLETE function is here for compatibility

RETURN i_nv_dw_dbi.fnv_get_update_status ()
end function

public subroutine fu_set_confirm_delete (boolean a_b_confirm_delete);// Set value of instance variable to value passed

i_b_confirm_delete = a_b_confirm_delete
end subroutine

public function long fu_insert (long a_l_row_num);// Insert new row into datawindow.  The row number of the new row
// will be returned, -1 otherwise.

Long l_row_cnt


// Trigger the pre-insert event.  If message.returnvalue is negative
// the insert is abandoned.

this.TriggerEvent ("ue_preinsert")

IF message.returnvalue < 0 THEN
	this.SetFocus ()
	RETURN -1
END IF


l_row_cnt = this.RowCount ()

this.SetRedraw (FALSE)


// a_l_row_num = row AFTER which you want the insert to occur.

CHOOSE CASE a_l_row_num
	CASE IS < 0
		a_l_row_num = 1
	CASE IS > l_row_cnt
		a_l_row_num = l_row_cnt
END CHOOSE


// Insert row and scroll to it.

a_l_row_num = this.InsertRow (a_l_row_num)

IF a_l_row_num > 0 THEN
	this.ScrollToRow (a_l_row_num)
END IF


// Trigger the post-insert event and set focus back on the DataWindow.

this.TriggerEvent ("ue_postinsert")

this.SetFocus ()

this.SetRedraw (TRUE)

RETURN a_l_row_num
end function

public function boolean fu_commit ();// This OBSOLETE function is here for compatibility

RETURN (i_nv_dw_dbi.fnv_commit ())
end function

public function boolean fu_rollback ();// This OBSOLETE function is here for compatibility

i_nv_dw_dbi.fnv_rollback ()

RETURN TRUE
end function

public function boolean fu_validate ();// This triggers the "ue_validate" event to allow application
// specific validations to be performed.
// It returns FALSE if message.returnvalue is less than zero,
//            TRUE otherwise.
// If successful, it will call fu_validate for the next
// datawindow in the chain.


// Trigger "ue_validate" and exit if message.returnvalue < 0.

this.TriggerEvent ("ue_validate")

IF message.returnvalue < 0 THEN
	i_nv_dw_dbi.fnv_set_update_status (-4)
	this.SetFocus ()
	RETURN FALSE
END IF


// Validate the next datawindow in the chain, if it exists.
// An update status of -8 indicates that another datawindow in
// the chain generated the error.

IF IsValid (this.fu_get_next ()) THEN
	IF NOT this.fu_get_next ().function dynamic fu_validate () THEN
		i_nv_dw_dbi.fnv_set_update_status (-8)
		RETURN FALSE
	END IF
END IF


RETURN TRUE
end function

public function boolean fu_accepttext ();// AcceptText on the datawindow.
// It returns FALSE if it fails,
//            TRUE otherwise.
// If successful, it will call fu_accepttext for the next
// datawindow in the chain.


// Exit if AcceptText () < 0.

IF this.AcceptText () < 0 THEN
	i_nv_dw_dbi.fnv_set_update_status (-2)
	this.SetFocus ()
	RETURN FALSE
END IF


// AcceptText on the next datawindow in the chain, if it exists.
// An update status of -8 indicates that another datawindow in
// the chain generated the error.

IF IsValid (fu_get_next ()) THEN
	IF NOT fu_get_next ().function dynamic fu_accepttext () THEN
		i_nv_dw_dbi.fnv_set_update_status (-8)
		RETURN FALSE
	END IF
END IF


RETURN TRUE
end function

public function boolean fu_pre_update ();// Reset the DataWindow dbError Structure

this.fu_reset_dberror ()


// Perform AcceptText on DataWindows to flush out Type Validation Errors

IF NOT this.fu_accepttext () THEN
	RETURN FALSE
END IF


// Make sure all required fields have been entered on DataWindows

IF NOT this.fu_check_required () THEN
	RETURN FALSE
END IF


// Do any additional validations on DataWindows (Specific to Context)

IF NOT this.fu_validate () THEN
	RETURN FALSE
END IF


RETURN TRUE
end function

public subroutine fu_set_rollback_on_failure (boolean a_b_rollback_on_failure);// This OBSOLETE function is here for compatibility

i_nv_dw_dbi.fnv_set_rollback_on_failure (a_b_rollback_on_failure)
end subroutine

public subroutine fu_set_req_only_at_update (boolean a_b_req_only_at_update);// Set value of instance variable to value passed

i_b_req_only_at_update = a_b_req_only_at_update
end subroutine

public function integer settransobject (nv_transaction a_trans);// The name of this function necessarily violates the PowerTOOL
// naming conventions since it overrides a standard PowerBuilder
// function.

// This function overrides PowerBuilder's SetTransObject in order to
// capture the transaction object specified for descendents of u_dwa.
//
// This objects 'super' is u_dwa which captures the transaction
// object.

// This function will instantiate the appropriate dbms protocol
// non-visual user object.

u_dwa dw_this


// Call Ancestor's SetTransObject

IF super::SetTransObject (a_trans) < 0 THEN
	RETURN -1
END IF


// Destroy the current DataWindow database interface user object and
// create and verify the appropriate one based on DBMS.

IF IsValid ( i_nv_dw_dbi ) THEN

	DESTROY i_nv_dw_dbi

END IF

CHOOSE CASE Upper (Left (i_tr.fnv_get_dbms (), 3))
	CASE "INF"
//	Informix support is not available for this release of PowerTOOL.
//		i_nv_dw_dbi = CREATE nv_dw_dbiu_inf		// Informix object
		i_nv_dw_dbi = CREATE nv_dw_dbiu			// Generic update object
	CASE "OR6"
		i_nv_dw_dbi = CREATE nv_dw_dbiu			// Generic update object
	CASE "OR7", "ORA"
		i_nv_dw_dbi = CREATE nv_dw_dbiu_or7		// Oracle object
	CASE "SYB", "SYC"
		i_nv_dw_dbi = CREATE nv_dw_dbiu_syb		// Sybase object
	CASE "WAT", "SQL"
		i_nv_dw_dbi = CREATE nv_dw_dbiu_wat		// Watcom object
	CASE ELSE
		i_nv_dw_dbi = CREATE nv_dw_dbiu			// Generic update object
END CHOOSE

IF NOT IsValid (i_nv_dw_dbi) THEN
	g_nv_msg_mgr.fnv_process_msg ("pt", "DBI Create Error", "", "", 0, 0)
	RETURN -1
END IF


// Tell the user object who its parent is.

dw_this = this

i_nv_dw_dbi.fnv_set_parent (dw_this)


// Set the transaction on the DataWindow database interface object

i_nv_dw_dbi.fnv_set_transaction (i_tr)


RETURN 1
end function

public function boolean fu_get_req_only_at_update ();// Return value of instance variable.

RETURN i_b_req_only_at_update
end function

public function boolean fu_get_confirm_delete ();// Return value of instance variable.

RETURN i_b_confirm_delete
end function

public function boolean fu_get_nilisnull (string a_s_col_name);// Determine whether 'set empty string to null' has been selected for
// the passed column.
// Returns:
//	 TRUE	nilisnull is 'yes'
//	FALSE nilisnull is 'no'


// Check column name.

IF IsNumber (a_s_col_name) THEN
	a_s_col_name = this.Describe ("#" + a_s_col_name)
END IF


// Check edit style.

IF Lower (this.Describe (a_s_col_name + ".edit.nilisnull")) = "yes" THEN
	RETURN TRUE
END IF


// Check dddw style.

IF Lower (this.Describe (a_s_col_name + ".dddw.nilisnull")) = "yes" THEN
	RETURN TRUE
END IF


// Check ddlb style.

IF Lower (this.Describe (a_s_col_name + ".ddlb.nilisnull")) = "yes" THEN
	RETURN TRUE
END IF


// Fallthrough - nilisnull is not set.

RETURN FALSE
end function

event itemerror;call super::itemerror;// Bypass the error if this is an item required problem.  It will
// trapped later by fu_check_required ().

// If an empty required column is generating the error and the 'empty
//	string is null' attribute is checked for the column, then set the
// item to null (if it isn't null already).

IF this.GetText () = "" AND &
	i_b_req_only_at_update THEN
	IF Len (Trim (this.fu_get_item_any (row, dwo.Name))) > 0 AND &
		this.fu_get_nilisnull (dwo.Name) THEN
		this.fu_set_null (row, dwo.Name)
		RETURN 3
	ELSE
		RETURN 2
	END IF
END IF
end event

on ue_predelete;call u_dwa::ue_predelete;// Confirm delete if the switch is set.  Set message.returnvalue to -1
// if the delete is to be aborted.

IF i_b_confirm_delete THEN
		IF g_nv_msg_mgr.fnv_process_msg ("pt", "Confirm Delete?", "", &
																	"", 0, 0) <> 1 THEN
		message.returnvalue = -1
		RETURN
	END IF
END IF
end on

on ue_reserved4powertool;call u_dwa::ue_reserved4powertool;//
//	Maintenance
//		2/24/95	#24	Changed CASE statement in SetTransObject () to
//							recognize Sybase System 10 CTLLIB (SYC).
//		2/24/95	#30	Added call to fu_reset_dberror () as first
//							action in fu_pre_update ().
end on

event sqlpreview;call u_dwa::sqlpreview;// Call the event processor on the DataWindow database interface object.

RETURN i_nv_dw_dbi.fnv_event_sqlpreview (sqltype, sqlsyntax, buffer, row)
end event

