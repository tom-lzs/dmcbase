$PBExportHeader$nv_dw_dbiu_pl_pt.sru
$PBExportComments$Interface Générale Datawindows/Bases de Données possédant un langage procédural pour les Update
forward
global type nv_dw_dbiu_pl_pt from nv_dw_dbiu
end type
end forward

global type nv_dw_dbiu_pl_pt from nv_dw_dbiu
end type
global nv_dw_dbiu_pl_pt nv_dw_dbiu_pl_pt

type variables
PROTECTED:

// The following variables control/audit database updating
Boolean i_b_batch_update		// batch update calls
Boolean i_b_procedure_update	// build stored procedure calls

String i_s_proc_name_expr		// Expression used to derive stored procedure name
String i_s_ins_proc_name		// Stored procedure name for Insert
String i_s_upd_proc_name		// Stored procedure name for Update
String i_s_del_proc_name		// Stored procedure name for Delete

String i_s_batch_sql		// SQL Syntax batched for update
Boolean i_b_preview_batch_sql	// preview syntax before sending to server
end variables

forward prototypes
public function int fnv_set_batch_update (boolean a_b_batch_update)
public function int fnv_set_procedure_update (boolean a_b_procedure_update)
public subroutine fnv_set_ins_proc_name (string a_s_ins_proc_name)
public subroutine fnv_set_upd_proc_name (string a_s_upd_proc_name)
public subroutine fnv_set_del_proc_name (string a_s_del_proc_name)
public subroutine fnv_set_procedure_names (string a_s_ins_proc_name, string a_s_upd_proc_name, string a_s_del_proc_name)
public function boolean fnv_get_batch_update ()
public function boolean fnv_get_procedure_update ()
public function integer fnv_update ()
public function boolean fnv_get_preview_batch_sql ()
public subroutine fnv_set_preview_batch_sql (boolean a_b_preview_batch_sql)
public subroutine fnv_set_proc_name_expr (string a_s_proc_name_expr)
protected subroutine fnv_append_batch (string a_s_sql_call)
protected function string fnv_build_del_proc_call (long a_l_row_num, dwbuffer a_e_buffer)
protected function string fnv_build_ins_proc_call (long a_l_row_num, dwbuffer a_e_buffer)
protected function string fnv_build_upd_proc_call (long a_l_row_num, dwbuffer a_e_buffer)
protected function string fnv_get_batch_sql ()
protected function string fnv_get_item_dbparm (long a_l_row_num, string a_s_col_name, dwbuffer a_e_buffer)
protected function string fnv_get_proc_name (string a_s_function, string a_s_table_name)
protected function string fnv_prepare_batch ()
protected subroutine fnv_reset_batch ()
protected subroutine fnv_set_autocommit ()
protected function boolean fnv_set_update_sql (string a_s_sql)
protected function boolean fnv_submit_batch ()
public function integer fnv_event_sqlpreview (SQLPreviewType a_e_sqltype, string a_s_sqlsyntax, dwbuffer a_e_buffer, long a_l_row)
end prototypes

public function int fnv_set_batch_update (boolean a_b_batch_update);// Set value of instance variable to value passed.

i_b_batch_update = a_b_batch_update

RETURN 1
end function

public function int fnv_set_procedure_update (boolean a_b_procedure_update);// Set value of instance variable to value passed.

i_b_procedure_update = a_b_procedure_update

RETURN 1
end function

public subroutine fnv_set_ins_proc_name (string a_s_ins_proc_name);// Set value of instance variable to value passed.

i_s_ins_proc_name = a_s_ins_proc_name
end subroutine

public subroutine fnv_set_upd_proc_name (string a_s_upd_proc_name);// Set value of instance variable to value passed.

i_s_upd_proc_name = a_s_upd_proc_name
end subroutine

public subroutine fnv_set_del_proc_name (string a_s_del_proc_name);// Set value of instance variable to value passed.

i_s_del_proc_name = a_s_del_proc_name
end subroutine

public subroutine fnv_set_procedure_names (string a_s_ins_proc_name, string a_s_upd_proc_name, string a_s_del_proc_name);// Call the individual methods to set the Insert, Update and Delete
// stored procedure names.

fnv_set_ins_proc_name (a_s_ins_proc_name)

fnv_set_upd_proc_name (a_s_upd_proc_name)

fnv_set_del_proc_name (a_s_del_proc_name)
end subroutine

public function boolean fnv_get_batch_update ();// Return value of the instance variable.

RETURN i_b_batch_update
end function

public function boolean fnv_get_procedure_update ();// Return value of the instance variable.

RETURN i_b_procedure_update
end function

public function integer fnv_update ();// Returns i_b_update_status, which is set as follows:
//
//		 1	update ok
//		-1	db error
//		-5	commit failed
//		-6 ReselectRow failed
//    -7 dwResetUpdate failed
//		-8 Update failed for later datawindow in the chain
//
// If this dw updated okay but the update failed for a dw later in
// the chain, then i_b_update_status for this dw will be set to
// the i_b_update_status from the dw later in the chain that failed.
//
// Function will commit and reset all dws in a series as one
// transaction at the end of the process if all dws update ok and
// i_b_commit_on_update = TRUE for the head dw.
//
// DataWindow will batch all updates if i_b_batch_update is TRUE
// and function will send the batch to the server if this it the
// head dw and i_b_batch_update is TRUE.

String s_batch_sql
nv_dw_dbiu_pl_pt nv_dw_dbi_next
powerobject po_prior, po_next


// Clear the previous batch update SQL.

fnv_reset_batch ()


// Set state of transaction.

fnv_set_autocommit ()


// Set the ReselectRow count to zero.

fnv_reset_reselect_rows ()


// Call Update of DataWindow.  Note that if this is a batched SQL
// update (i_b_batch_update = TRUE) then this process will simply
// build the SQL Syntax in i_s_batch_sql.

if typeof(i_po_parent) = datawindow! then
	fnv_set_update_status (i_dw_parent.Update (FALSE, FALSE))
else
	fnv_set_update_status (i_ds_parent.Update (FALSE, FALSE))
end if

IF fnv_get_update_status () = 1 THEN
	// Update the next dw in the series.  Commit on Update will be set
	// to FALSE (since it can only be performed by the head dw) but
	// Rollback on Failure, Reselect After Update, Procedure Update and
	// Batch Update are controlled by the head dw in series and are
	// passed on down the list.
	po_next = i_po_parent.function dynamic fu_get_next ()
	IF IsValid (po_next) THEN
		// Get the DataWindow database interface object for the next dw.
		nv_dw_dbi_next = po_next.function dynamic fu_get_nv_dw_dbi ()
		nv_dw_dbi_next.fnv_set_commit_on_update (FALSE)
		nv_dw_dbi_next.fnv_set_rollback_on_failure (fnv_get_rollback_on_failure ())
		nv_dw_dbi_next.fnv_set_reselect_after_update (fnv_get_reselect_after_update ())
		nv_dw_dbi_next.fnv_set_batch_update (fnv_get_batch_update ())
		nv_dw_dbi_next.fnv_set_procedure_update (fnv_get_procedure_update ())
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


// If this is a Batched SQL update then submit it to the Server.
// The process will return FALSE if an error was encountered.

IF fnv_get_batch_update () THEN
	IF NOT fnv_submit_batch () THEN
		RETURN fnv_get_update_status ()
	END IF

ELSE

// If this is not a batched SQL update than all updates have been sent
// to the server so commit the transaction.

	IF NOT fnv_commit () THEN
		fnv_restore_autocommit ()
		fnv_set_update_status (-5)
		if isvalid(i_dw_parent) then
			i_dw_parent.SetFocus ()
		end if
		RETURN fnv_get_update_status ()
	END IF

END IF


// Restore transaction.autocommit to its original state.

fnv_restore_autocommit ()


// Reselect updated rows in the Primary! buffer (before resetting the
// update flags) if i_b_reselect_after_update is set to TRUE AND
// i_b_commit_on_update is set to TRUE.

IF fnv_get_reselect_after_update () AND &
	fnv_get_commit_on_update () THEN
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


// Reselect updated rows in the Primary! buffer (after resetting the
// update flags) if i_b_reselect_after_update is set to TRUE AND
// i_b_commit_on_updte is set to TRUE.

IF fnv_get_reselect_after_update () AND &
	fnv_get_commit_on_update () THEN
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


// Successful update!

RETURN fnv_get_update_status ()
end function

public function boolean fnv_get_preview_batch_sql ();// Return value of the instance variable.

RETURN i_b_preview_batch_sql
end function

public subroutine fnv_set_preview_batch_sql (boolean a_b_preview_batch_sql);// Set value of instance variable to value passed.

i_b_preview_batch_sql = a_b_preview_batch_sql
end subroutine

public subroutine fnv_set_proc_name_expr (string a_s_proc_name_expr);// Set value of instance variable to value passed.

i_s_proc_name_expr = a_s_proc_name_expr
end subroutine

protected subroutine fnv_append_batch (string a_s_sql_call);// Funtion stub.
end subroutine

protected function string fnv_build_del_proc_call (long a_l_row_num, dwbuffer a_e_buffer);// Function stub.

RETURN ""
end function

protected function string fnv_build_ins_proc_call (long a_l_row_num, dwbuffer a_e_buffer);// Function stub.

RETURN ""
end function

protected function string fnv_build_upd_proc_call (long a_l_row_num, dwbuffer a_e_buffer);// Function stub.

RETURN ""
end function

protected function string fnv_get_batch_sql ();String s_next_batch_sql
nv_dw_dbiu_pl_pt nv_dw_dbi_next
powerobject po_next


// Get the Batched SQL Syntax of the NEXT DataWindow (if so specified)

po_next = i_po_parent.function dynamic fu_get_next ()
IF IsValid (po_next) THEN
	// Get the DataWindow database interface object for the next dw
	nv_dw_dbi_next = po_next.function dynamic fu_get_nv_dw_dbi ()
	s_next_batch_sql = nv_dw_dbi_next.fnv_get_batch_sql ()
END IF


// Append Batched SQL Syntax of the NEXT DataWindow (if it exists)
// to the Batched SQL Syntax for THIS DataWindow (if it exists)

IF Len (i_s_batch_sql) > 0 THEN
	IF Len (s_next_batch_sql) > 0 THEN
		RETURN i_s_batch_sql + "~r~n" + s_next_batch_sql
	ELSE
		RETURN i_s_batch_sql
	END IF
ELSE
	IF Len (s_next_batch_sql) > 0 THEN
		RETURN s_next_batch_sql
	ELSE
		RETURN ""
	END IF
END IF
end function

protected function string fnv_get_item_dbparm (long a_l_row_num, string a_s_col_name, dwbuffer a_e_buffer);// Function stub.

RETURN ""
end function

protected function string fnv_get_proc_name (string a_s_function, string a_s_table_name);// Evaluate and return the stored procedure name.  Precedence is:
//
//		1) Explicit name, if specified (e.g. i_s_del_proc_name)
//		2) Derived name, from i_s_proc_name_expr
//		3) Derived name, from "sp_%tname_%func"

String s_prc_name, s_function


// Based on update function, a_function, determine whether an
// explicit procedure name exists and return it.

s_function = Upper (Left (Trim (a_s_function), 1))

CHOOSE CASE s_function
	CASE "I"
		IF Len (Trim (i_s_ins_proc_name)) > 0 THEN
			RETURN i_s_ins_proc_name
		END IF
	CASE "U"
		IF Len (Trim (i_s_upd_proc_name)) > 0 THEN
			RETURN i_s_upd_proc_name
		END IF
	CASE "D"
		IF Len (Trim (i_s_del_proc_name)) > 0 THEN
			RETURN i_s_del_proc_name
		END IF
	CASE ELSE
		RETURN ""
END CHOOSE


// Derive procedure name based on the expression in i_s_proc_name_expr.
// Perform symbolic substitution, replacing %tname with the table name
// (passed as a parameter) and %func with the function (passed as a
// parameter).  The default expression is sp_%tname_%func.

IF Len (Trim (i_s_proc_name_expr)) > 0 THEN
	s_prc_name = i_s_proc_name_expr
ELSE
	s_prc_name = "sp_%tname_%func"
END IF

// Perform the symbolic substitution and return the result.

s_prc_name = f_str_transform (s_prc_name, "%tname", a_s_table_name)

s_prc_name = f_str_transform (s_prc_name, "%func", a_s_function)

RETURN s_prc_name
end function

protected function string fnv_prepare_batch ();// Function stub.

RETURN ""
end function

protected subroutine fnv_reset_batch ();// Clear the instance variable.

i_s_batch_sql = ""
end subroutine

protected subroutine fnv_set_autocommit ();// If this is a head datawindow, transaction management is required
// (i_b_manage_transaction = TRUE), the transaction is not batched
// (i_b_batch_update = FALSE), and updates are to be commited
// then trans.autocommit must be set to FALSE.  
// If this is a head datawindow, transaction management is required
// (i_b_manage_transaction = TRUE), the transaction IS batched
// (i_b_batch_update = TRUE), and updates are to be commited
// then trans.autocommit must be set to TRUE.  The initial value
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


// If updates are to be batched then set value of trans.autocommit to
// TRUE if it isn't already set (original value was saved earlier).

IF i_b_batch_update THEN
	IF NOT i_tr.autocommit THEN
		i_tr.autocommit = TRUE	// Current transaction is committed
	END IF
	RETURN
END IF


// Otherwise, set value of trans.autocommit to FALSE if it isn't
// already set (original value was saved earlier).

IF i_tr.autocommit THEN
	i_tr.autocommit = FALSE		// Begin transaction is sent to server
END IF
end subroutine

protected function boolean fnv_set_update_sql (string a_s_sql);// Set the SQL syntax to the stored procedure call passed as a
// parameter (this is not a batched SQL update).

IF i_po_parent.function dynamic SetSQLPreview (a_s_sql) < 1 THEN
	RETURN FALSE
ELSE
	RETURN TRUE
END IF
end function

protected function boolean fnv_submit_batch ();// Build and submit the batch to the DBMS server.
// Returns:
//		FALSE if an error has occured
//		TRUE otherwise

String s_batch_sql


// Retrieve the batch sql and bail out it it's empty.

s_batch_sql = fnv_prepare_batch ()

IF Len (s_batch_sql) < 0 THEN
	fnv_set_dberror (Primary!, 0, "", "&Batch Prep Failed", "", -1, &
		"Unable to successfully prepare a batch for submission to DBMS")
	RETURN FALSE
END IF

IF Len (s_batch_sql) = 0 THEN
	RETURN TRUE
END IF


// Submit the sql to the server and process any errors encountered.

 EXECUTE IMMEDIATE :s_batch_sql &
   USING i_tr;

IF i_tr.SQLCode < 0 THEN
	fnv_set_update_status (-1)
	fnv_set_dberror (Primary!, 0, "", i_tr.SQLErrText, "", &
										i_tr.SQLDBCode, i_tr.SQLErrText)
	fnv_restore_autocommit ()
	fnv_display_dberror ()
	RETURN FALSE
END IF


// Update successful.

RETURN TRUE
end function

public function integer fnv_event_sqlpreview (SQLPreviewType a_e_sqltype, string a_s_sqlsyntax, dwbuffer a_e_buffer, long a_l_row);// Function will examine the call built by PowerBuilder.
//
// Return codes (the Action Code for the PowerBuilder SQLPreview! event):
//
//		0 No modifications - let PowerBuilder continue
//		1 Stop the process - tell PowerBuilder to abort
//		2 Ignore SQL - tell PowerBuilder not to send SQL to server
//
// If the stored procedure update boolean is set then process will
// convert call to a stored procedure call.
//
// If the batched SQL boolean is set then the call be be packaged
// and appended to the SQL batch.
String s_sql_call, s_action


// Call the function that this function overrides (super::).  That
// function handles the ReselectRow stuff.

super::fnv_event_sqlpreview (a_e_sqltype, a_s_sqlsyntax, a_e_buffer, &
		a_l_row)


// Bail out if this is NOT a Stored Procedure update and this is NOT
// a Batched SQL update.

IF NOT fnv_get_procedure_update () AND &
	NOT fnv_get_batch_update () THEN
	RETURN 0
END IF


// Bail out if this is a dwRetrieve (SELECT or EXECUTE call).
s_sql_call = a_s_sqlsyntax
IF Len (a_s_sqlsyntax) = 0 THEN
	RETURN 0
END IF

s_action = Left (Upper (a_s_sqlsyntax), 6)

IF s_action = "SELECT" OR &
	s_action = "1 EXEC" THEN
	RETURN 0
END IF


// Call appropriate User Object Function to build Stored Procedure
// Call Syntax based on type of update if this is a Store Procedure
// update.

IF i_b_procedure_update THEN
	CHOOSE CASE a_e_sqltype
		CASE PreviewInsert!
			s_sql_call = fnv_build_ins_proc_call (a_l_row, a_e_buffer)
		CASE PreviewUpdate!
			s_sql_call = fnv_build_upd_proc_call (a_l_row, a_e_buffer)
		CASE PreviewDelete!
			s_sql_call = fnv_build_del_proc_call (a_l_row, a_e_buffer)
		CASE ELSE
			RETURN 0
	END CHOOSE
	IF Len (s_sql_call) < 1 THEN
		fnv_set_dberror (a_e_buffer, 0, "", "&No DW Proc Syntax", "", -1, &
									"No stored procedure syntax generated")
		RETURN 1
	END IF
END IF

// Append syntax to the batch if boolean for batch update is set.
IF fnv_get_batch_update () THEN
	fnv_append_batch (s_sql_call)
	RETURN 2
END IF

// Set the SQL syntax to the stored procedure call (this is not a
// batched SQL update).
IF NOT fnv_set_update_sql (s_sql_call) THEN
	fnv_set_dberror (a_e_buffer, 0, "", "&DW Set SQL Failed", "", -1, &
												"Unable to set SQL Syntax")
	RETURN 1
END IF

RETURN 0
end function

on constructor;call nv_dw_dbiu::constructor;//
//	Maintenance
//		3/30/95	#37	Added  autocommit set function for automatic
//							transaction management (to override ancestor).
//							Removed batch submit functionality from fnv_update
//							to fnv_submit_batch.
//							Protected the following methods:
//								fnv_append_batch,
//								fnv_build_del_proc_call,
//								fnv_build_ins_proc_call,
//								fnv_build_upd_proc_call,
//								fnv_get_batch_sql,
//								fnv_get_item_dbparm,
//								fnv_get_proc_name,
//								fnv_prepare_batch,
//								fnv_reset_batch,
//								fnv_set_update_sql,
//								fnv_submit_batch.
end on

on nv_dw_dbiu_pl_pt.create
TriggerEvent( this, "constructor" )
end on

on nv_dw_dbiu_pl_pt.destroy
TriggerEvent( this, "destructor" )
end on

