$PBExportHeader$nv_dw_dbiu_pt.sru
$PBExportComments$Interface Générale Datawindows/Bases de Données pour les Update
forward
global type nv_dw_dbiu_pt from nv_dw_dbi
end type
end forward

global type nv_dw_dbiu_pt from nv_dw_dbi
end type
global nv_dw_dbiu_pt nv_dw_dbiu_pt

type variables
PROTECTED:

// The following variables control/audit database updating
Integer i_i_update_status			// status of last update

Boolean i_b_manage_transaction = TRUE	// manage transaction using trans.autocommit
Boolean i_b_save_autocommit		// saved value of trans.autocommit
Boolean i_b_commit_on_update = TRUE	// commit required on update
Boolean i_b_rollback_on_failure = TRUE	// rollback required on failure

// The following variables control reselect of rows after update
Boolean i_b_reselect_after_update		// reselect updated rows after update
Long i_l_reselect_row_cnt			// number of rows to be reselected
Long i_l_reselect_row []			// array of row number to be reselected
end variables

forward prototypes
public subroutine fnv_set_commit_on_update (boolean a_b_commit_on_update)
public subroutine fnv_set_rollback_on_failure (boolean a_b_rollback_on_failure)
public function int fnv_get_update_status ()
public function boolean fnv_get_commit_on_update ()
public function boolean fnv_get_rollback_on_failure ()
public function integer fnv_update ()
public function boolean fnv_get_reselect_after_update ()
public subroutine fnv_set_reselect_after_update (boolean a_b_reselect_after_update)
public function u_dw_udim fnv_get_error_dw ()
public subroutine fnv_set_manage_transaction (boolean a_b_manage_transaction)
public function boolean fnv_get_manage_transaction ()
protected subroutine fnv_reset_reselect_rows ()
protected subroutine fnv_set_autocommit ()
public subroutine fnv_set_update_status (integer a_i_update_status)
public function boolean fnv_commit ()
public subroutine fnv_rollback ()
public function integer fnv_reselect_rows ()
public subroutine fnv_restore_autocommit ()
public function integer fnv_event_sqlpreview (SQLPreviewType a_e_sqltype, string a_s_sqlsyntax, dwbuffer a_e_buffer, long a_l_row)
end prototypes

public subroutine fnv_set_commit_on_update (boolean a_b_commit_on_update);// Set instance variable to boolean value passed

i_b_commit_on_update = a_b_commit_on_update
end subroutine

public subroutine fnv_set_rollback_on_failure (boolean a_b_rollback_on_failure);// Set instance variable to boolean value passed

i_b_rollback_on_failure = a_b_rollback_on_failure
end subroutine

public function int fnv_get_update_status ();// Return value of the instance variable

RETURN i_i_update_status
end function

public function boolean fnv_get_commit_on_update ();// Return value of the instance variable

RETURN i_b_commit_on_update
end function

public function boolean fnv_get_rollback_on_failure ();// Return value of the instance variable

RETURN i_b_rollback_on_failure
end function

public function integer fnv_update ();// Returns i_i_update_status, which is set as follows:
//
//		 1	update ok
//		-1	db error
//		-5	commit failed
//		-6 ReselectRow failed
//    -7 dwResetUpdate failed
//		-8 Update failed for later datawindow/store in the chain
//
// If this dw updated okay but the update failed for a dw later in
// the chain, then i_b_update_status will be set to -8.
//
// Function will commit and reset all dws in a series as one
// transaction at the end of the process if all dws update ok and
// i_b_commit_on_update = TRUE for the head dw.

nv_dw_dbiu nv_dw_dbi_next
powerobject po_prior, po_next


// Set state of transaction.

fnv_set_autocommit ()


// Set the ReselectRow count to zero.

fnv_reset_reselect_rows ()


// Call Update of DataWindow/store.

if typeof(i_po_parent) = datawindow! then
	fnv_set_update_status (i_dw_parent.Update (FALSE, FALSE))
else
	fnv_set_update_status (i_ds_parent.Update (FALSE, FALSE))
end if

IF fnv_get_update_status () = 1 THEN
	// Update the next dw in the series.  Commit on Update will be set
	// to FALSE (since it can only be performed by the head dw) but
	// Rollback on Failure and Reselect After Update are controlled by
	// the head dw in series and are passed on down the list.
	po_next = i_po_parent.function dynamic fu_get_next ()
	IF IsValid (po_next) THEN
		// Get the DataWindow database interface object for the next dw.
		nv_dw_dbi_next = po_next.function dynamic fu_get_nv_dw_dbi ()
		nv_dw_dbi_next.fnv_set_commit_on_update (FALSE)
		nv_dw_dbi_next.fnv_set_rollback_on_failure (fnv_get_rollback_on_failure ())
		nv_dw_dbi_next.fnv_set_reselect_after_update (fnv_get_reselect_after_update ())
		IF nv_dw_dbi_next.fnv_update () < 0 THEN
			fnv_set_update_status (-8)
		END IF
	END IF
ELSE
	fnv_rollback ()
	fnv_restore_autocommit ()
	fnv_display_dberror ()
END IF


// Exit process if any update has failed.

IF i_i_update_status < 0 THEN
	RETURN fnv_get_update_status ()
END IF


// Process is complete if this is not a head dw.

po_prior = i_po_parent.function dynamic fu_get_prior ()
IF IsValid (po_prior) THEN
	RETURN fnv_get_update_status ()
END IF


// All updates have been sent to the server so commit the transaction.

IF NOT fnv_commit () THEN
	fnv_restore_autocommit ()
	fnv_set_update_status (-5)
	if typeof(i_po_parent) = datawindow! then
		i_dw_parent.SetFocus ()
	end if
	RETURN fnv_get_update_status ()
END IF


// Restore transaction.autocommit to its original state.

fnv_restore_autocommit ()


// Reselect updated rows in the Primary! buffer (before resetting the
// update flags) if i_b_reselect_after_update is set to TRUE.

IF fnv_get_reselect_after_update () THEN
	IF fnv_reselect_rows () < 0 THEN
		fnv_set_update_status (-6)
		fnv_set_dberror (Primary!, 0, "", "&DW Reselect Failed", "", -6, &
								"Reselect after Update failed~r~n~r~n" + &
								"All database changes are complete~r~n~r~n" + &
								"Please contact your System Administrator")
		fnv_display_dberror ()
		RETURN fnv_get_update_status ()
	END IF
END IF


// Reset dws if i_b_commit_on_update is TRUE.
// dwResetUpdate has an override to call all dws in the series.

IF fnv_get_commit_on_update () THEN
	IF i_po_parent.function dynamic ResetUpdate () < 0 THEN
		fnv_set_update_status (-7)
		fnv_set_dberror (Primary!, 0, "", "&DW Reset Failed", "", -7, &
								"DataWindow reset after Update failed~r~n~r~n" + &
								"All database changes are complete~r~n~r~n" + &
								"Please contact your System Administrator")
		fnv_display_dberror ()
		RETURN fnv_get_update_status ()
	END IF
END IF


// Successful update!

RETURN fnv_get_update_status ()
end function

public function boolean fnv_get_reselect_after_update ();// Return value of the instance variable

RETURN i_b_reselect_after_update
end function

public subroutine fnv_set_reselect_after_update (boolean a_b_reselect_after_update);// Set instance variable to boolean value passed

i_b_reselect_after_update = a_b_reselect_after_update
end subroutine

public function u_dw_udim fnv_get_error_dw ();// Returns
//
//		u_dw_udim  DataWindow in the chain which encountered update error
//		null       No error encountered

nv_dw_dbiu nv_dw_dbi_next
u_dw_udim dw_null


// Return null if no errors were encountered.

SetNull (dw_null)

IF NOT fnv_get_update_status () < 0 THEN
	RETURN dw_null
END IF


// Return parent datawindow if it generated the error (update status
// is > -8).

IF fnv_get_update_status () > -8 THEN
	RETURN i_dw_parent
END IF


// Call next datawindow in the chain to retrieve error datawindow.

IF IsValid (i_dw_parent.fu_get_next ()) THEN
	// Get the DataWindow database interface object for the next dw.
	nv_dw_dbi_next = i_dw_parent.fu_get_next ().function dynamic fu_get_nv_dw_dbi ()
	RETURN  nv_dw_dbi_next.fnv_get_error_dw ()
END IF


// There is no next datawindow in the chain.

RETURN dw_null
end function

public subroutine fnv_set_manage_transaction (boolean a_b_manage_transaction);// Set instance variable to value passed.

i_b_manage_transaction = a_b_manage_transaction
end subroutine

public function boolean fnv_get_manage_transaction ();// Return value of instance variable.

RETURN i_b_manage_transaction
end function

protected subroutine fnv_reset_reselect_rows ();// Set the number of rows to be reselected to zero.

i_l_reselect_row_cnt = 0
end subroutine

protected subroutine fnv_set_autocommit ();// If this is a head datawindow, transaction management is required
// (i_b_manage_transaction = TRUE), and updates are to be commited
// then trans.autocommit must be set to FALSE.  The initial value
// must be saved, however, for later restoration.
powerobject po_prior

// Bail out if this is not a head datawindow.

po_prior = i_po_parent.function dynamic fu_get_prior ()

IF IsValid (po_prior) THEN
	RETURN
END IF


// Save current value of trans.autocommit.

i_b_save_autocommit = i_tr.autocommit


// Bail out if transaction management is not requested.

IF NOT i_b_manage_transaction THEN
	RETURN
END IF


// Bail out if updates aren't committed.

IF NOT i_b_commit_on_update THEN
	RETURN
END IF


// Set value of trans.autocommit to FALSE if it isn't already set
// (original value was saved earlier).

IF i_tr.autocommit THEN
	i_tr.autocommit = FALSE		// Begin transaction is sent to server
END IF
end subroutine

public subroutine fnv_set_update_status (integer a_i_update_status);// Set value of instance variable to value passed

i_i_update_status = a_i_update_status
end subroutine

public function boolean fnv_commit ();// COMMIT will be bypassed if PowerBuilder is not managing
// transaction processing (autocommit = TRUE).

IF i_tr.autocommit THEN
	RETURN TRUE
END IF


// COMMIT will be bypassed if instance variable is not set.

IF NOT fnv_get_commit_on_update () THEN
	RETURN TRUE
END IF


// COMMIT and check return code.

  COMMIT &
   USING i_tr;

IF i_tr.SQLCode < 0 THEN
	g_nv_msg_mgr.fnv_process_msg ("pt", "Commit Failed", &
			String (i_tr.SQLDBCode) + ", " + i_tr.SQLErrText, "", 0, 0)
	RETURN FALSE
END IF


RETURN TRUE
end function

public subroutine fnv_rollback ();// ROLLBACK will be bypassed if PowerBuilder is not managing
// transaction processing (autocommit = TRUE).

IF i_tr.autocommit THEN
	RETURN
END IF


// ROLLBACK will be bypassed if instance variable is not set.

IF NOT fnv_get_rollback_on_failure () THEN
	RETURN
END IF


// ROLLBACK and check return code.

ROLLBACK &
   USING i_tr;

IF i_tr.SQLCode < 0 THEN
	g_nv_msg_mgr.fnv_log_msg ("Transaction ROLLBACK Failed", &
		this.fnv_build_dbms_msg (i_tr.SQLDBCode, i_tr.SQLErrText), 4)
END IF
end subroutine

public function integer fnv_reselect_rows ();// Reselect each row pointed to in the array i_l_reselect_row [].
// Returns the lowest return code returned by ReselectRow () or by
// calling fnv_reselect_rows () for the next datawindow in the chain.

Integer i_rc = 1
Long l_indx
nv_dw_dbiu nv_dw_dbi_next


// Reselect each row pointed to by array i_l_reselect_row [].

FOR l_indx = 1 TO i_l_reselect_row_cnt
	if i_po_parent.typeof() = datawindow! then
		IF this.i_dw_parent.ReselectRow (i_l_reselect_row [l_indx]) < 0 THEN
			i_rc = -1
		END IF
	elseif i_po_parent.typeof() = datastore! then
		IF this.i_ds_parent.ReselectRow (i_l_reselect_row [l_indx]) < 0 THEN
			i_rc = -1
		END IF
	end if
NEXT


// Reselect rows for the next datawindow in the chain.

IF IsValid (i_dw_parent.fu_get_next ()) THEN
	nv_dw_dbi_next = i_dw_parent.fu_get_next ().function dynamic fu_get_nv_dw_dbi ()
	IF nv_dw_dbi_next.fnv_reselect_rows () < 0 THEN
		i_rc = -1
	END IF
END IF


// Return the least return code encountered.

RETURN i_rc

end function

public subroutine fnv_restore_autocommit ();// trans.autocommit may have been altered and must be restored to its
// original value.  This will be done here if this is a head
// datawindow.  Otherwise, this call must be bubbled up the to the
// head datawindow.

nv_dw_dbiu nv_dw_dbiu_head
powerobject po_prior, po_head


// Bubble this call to the head datawindow if this is not the head
// datawindow.

po_prior = i_po_parent.function dynamic fu_get_prior ()
IF IsValid (po_prior) THEN
	po_head = i_po_parent.function dynamic fu_get_head_po ()
	nv_dw_dbiu_head = po_head.function dynamic fu_get_nv_dw_dbi ()
	nv_dw_dbiu_head.fnv_restore_autocommit ()
	RETURN
END IF


// Otherwise, set value of trans.autocommit to its original value
// if it differs from the saved value.

IF i_tr.autocommit <> i_b_save_autocommit THEN
	i_tr.autocommit = i_b_save_autocommit
END IF
end subroutine

public function integer fnv_event_sqlpreview (SQLPreviewType a_e_sqltype, string a_s_sqlsyntax, dwbuffer a_e_buffer, long a_l_row);// If the row being updated is in the Primary! buffer then save its
// row to the ReselectRow array.

String s_sql

// Get the SQL.  Bail out if this is not an update call.
s_sql = a_s_sqlsyntax
s_sql = Upper (Left (s_sql, 6))

IF s_sql = "SELECT" OR &
	s_sql = "1 EXEC" THEN
	RETURN 0
END IF


// Bail out if other than the Primary! buffer.
IF a_e_buffer <> Primary! THEN
	RETURN 0
END IF


// Save the row number to the ReselectRow array.
i_l_reselect_row_cnt ++
i_l_reselect_row [i_l_reselect_row_cnt] = a_l_row


RETURN 0
end function

event constructor;call super::constructor;//
//	Maintenance
//		3/30/95	#37	Added functionality for automatic transaction
//							management - i_b_manage_transaction, get and set
//							functions, autocommit set and restore functions
//							and modifications to fnv_update.
//							Protected the following methods:
//								fnv_reselect_rows,
//								fnv_reset_reselect_rows.
end event

on nv_dw_dbiu_pt.create
TriggerEvent( this, "constructor" )
end on

on nv_dw_dbiu_pt.destroy
TriggerEvent( this, "destructor" )
end on

