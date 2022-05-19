$PBExportHeader$nv_dw_dbiu_syb_pt.sru
$PBExportComments$Interface Générale Datawindows/Bases de Données pour les Update Sybase
forward
global type nv_dw_dbiu_syb_pt from nv_dw_dbiu_pl
end type
end forward

global type nv_dw_dbiu_syb_pt from nv_dw_dbiu_pl
end type
global nv_dw_dbiu_syb_pt nv_dw_dbiu_syb_pt

type variables
PROTECTED:

// The following controls remote procedure update calls
String i_s_rpc_server	// RPC Server ID
String i_s_rpc_userid	// RPC User ID
end variables

forward prototypes
protected subroutine fnv_append_batch (string a_s_sql_call)
protected function string fnv_build_del_proc_call (long a_l_row_num, dwbuffer a_e_buffer)
protected function string fnv_build_ins_proc_call (long a_l_row_num, dwbuffer a_e_buffer)
protected function string fnv_build_upd_proc_call (long a_l_row_num, dwbuffer a_e_buffer)
protected function string fnv_get_item_dbparm (long a_l_row_num, string a_s_col_name, dwbuffer a_e_buffer, boolean a_b_origval)
protected function string fnv_prepare_batch ()
protected function boolean fnv_submit_batch ()
end prototypes

protected subroutine fnv_append_batch (string a_s_sql_call);// Format for readability and append syntax to any syntax previously
// built with a carriage return/line feed (~r~n) if this is a Batched
// SQL update.  Include exception handler.

String s_rollback


// Bail out if no SQL call is passed.

IF Len (Trim (a_s_sql_call)) = 0 THEN
	RETURN
END IF


// Include ROLLBACK in exception handler if Rollback on Failure
// flag is set.

IF i_b_rollback_on_failure THEN
	s_rollback = "      rollback tran ~r~n"
END IF

a_s_sql_call = "   " + a_s_sql_call + " ~r~n" + &
					"   if @@error != 0 ~r~n" + &
					"   begin ~r~n" + &
					s_rollback + &
					"      raiserror 20999 ~"Database Error...~" ~r~n" + &
					"      return ~r~n" + &
					"   end "

IF Len (i_s_batch_sql) > 0 THEN
	i_s_batch_sql = i_s_batch_sql + "~r~n" + a_s_sql_call
ELSE
	i_s_batch_sql = a_s_sql_call
END IF
end subroutine

protected function string fnv_build_del_proc_call (long a_l_row_num, dwbuffer a_e_buffer);String s_table_name, s_prc_name, s_item_stringval, s_prc_call
Integer i_col_num, i_col_cnt


// Get the Table Name for Update and the Number of Columns.  Only
// pass those columns which are Key columns and belong to the
// Update Table Name.

s_table_name = i_dw_parent.Describe ("datawindow.Table.UpdateTable")

s_prc_name = fnv_get_proc_name ("del", s_table_name)

i_col_cnt = Integer (i_dw_parent.Describe ("datawindow.Column.Count"))

FOR i_col_num = 1 TO i_col_cnt
	IF Upper (i_dw_parent.Describe ("#" + String (i_col_num) + ".Key")) <> "YES" THEN
		CONTINUE
	END IF
	// Get the string value of the column data.
	s_item_stringval = fnv_get_item_dbparm (a_l_row_num, &
														String (i_col_num), &
														a_e_buffer, & 
														TRUE) // use original value for key
	// Append data to the parameter list or start the call syntax/
	// parameter list as necessary.
	IF Len (s_prc_call) = 0 THEN
		s_prc_call = "exec " + s_prc_name + " " + s_item_stringval
	ELSE
		s_prc_call = s_prc_call + ", " + s_item_stringval
	END IF
NEXT


RETURN s_prc_call
end function

protected function string fnv_build_ins_proc_call (long a_l_row_num, dwbuffer a_e_buffer);String s_table_name, s_prc_name, s_item_stringval, s_prc_call
Integer i_col_num, i_col_cnt


// Get the Table Name for Update and the Number of Columns.  Only
// pass those columns which are Update columns and belong to the
// Update Table Name.

s_table_name = i_dw_parent.Describe ("datawindow.Table.UpdateTable")

s_prc_name = fnv_get_proc_name ("ins", s_table_name)

i_col_cnt = Integer (i_dw_parent.Describe ("datawindow.Column.Count"))

FOR i_col_num = 1 TO i_col_cnt
	IF Upper (i_dw_parent.Describe ("#" + String (i_col_num) + ".Update")) <> "YES" THEN
		CONTINUE
	END IF
	// Get the string value of the column data.
	s_item_stringval = fnv_get_item_dbparm (a_l_row_num, &
														String (i_col_num), &
														a_e_buffer, & 
														FALSE) // use current value for data
	// Append the data to the parameter list or start the call syntax/
	// parameter list as necessary
	IF Len (s_prc_call) = 0 THEN
		s_prc_call = "exec " + s_prc_name + " " + s_item_stringval
	ELSE
		s_prc_call = s_prc_call + ", " + s_item_stringval
	END IF
NEXT


RETURN s_prc_call
end function

protected function string fnv_build_upd_proc_call (long a_l_row_num, dwbuffer a_e_buffer);String s_table_name, s_prc_name, s_item_stringval, s_prc_call
Integer i_col_num, i_col_cnt


// Get the Table Name for Update and the Number of Columns.  Only
// pass those columns which are Update columns and belong to the
// Update Table Name.

s_table_name = i_dw_parent.Describe ("datawindow.Table.UpdateTable")

s_prc_name = fnv_get_proc_name ("upd", s_table_name)

i_col_cnt = Integer (i_dw_parent.Describe ("datawindow.Column.Count"))

// Pass keys first.

FOR i_col_num = 1 TO i_col_cnt
	IF Upper (i_dw_parent.Describe ("#" + String (i_col_num) + ".Key")) <> "YES" THEN
		CONTINUE
	END IF
	// Get the string value of the column data.
	s_item_stringval = fnv_get_item_dbparm (a_l_row_num, &
														String (i_col_num), &
														a_e_buffer, & 
														TRUE) // use original values for key
	// Append data to the parameter list or start the call syntax/
	// parameter list as necessary
	IF Len (s_prc_call) = 0 THEN
		s_prc_call = "exec " + s_prc_name + " " + s_item_stringval
	ELSE
		s_prc_call = s_prc_call + ", " + s_item_stringval
	END IF
NEXT

// Then pass data.  Don't pass keys if UpdateKeyInPlace <> YES.

FOR i_col_num = 1 TO i_col_cnt
	IF Upper (i_dw_parent.Describe ("#" + String (i_col_num) + ".Update")) <> "YES" THEN
		CONTINUE
	END IF
	IF Upper (i_dw_parent.Describe ("DataWindow.Table.UpdateKeyInPlace")) <> "YES" THEN
		IF Upper (i_dw_parent.Describe ("#" + String (i_col_num) + ".Key")) = "YES" THEN
			CONTINUE
		END IF
	END IF
	// Get the string value of the column data.
	s_item_stringval = fnv_get_item_dbparm (a_l_row_num, &
														String (i_col_num), &
														a_e_buffer, & 
														FALSE) // use current values for data
	// Append data to the parameter list or start the call syntax/
	// parameter list as necessary
	IF Len (s_prc_call) = 0 THEN
		s_prc_call = "exec " + s_prc_name + " " + s_item_stringval
	ELSE
		s_prc_call = s_prc_call + ", " + s_item_stringval
	END IF
NEXT


RETURN s_prc_call
end function

protected function string fnv_get_item_dbparm (long a_l_row_num, string a_s_col_name, dwbuffer a_e_buffer, boolean a_b_origval);// Return the value of the column as a string which Sybase recognizes.

String s_coltype, s_coltype4, s_stringval
Double d_value
Date dte_value
Time tme_value
DateTime dt_value


// Convert Column Number if Column Name.

IF IsNumber (a_s_col_name) THEN
	a_s_col_name = i_dw_parent.Describe ("#" + a_s_col_name + ".Name")
END IF


// Retrieve the data value of the column as a string.  DateTimes
// will be returned in the dd/mm/yyyy hh:mm:ss.fff format and
// null will be returned as the string "null."  Note that embedded
// quotes (") will be doubled up ("").

s_coltype = Upper (i_dw_parent.Describe (a_s_col_name + ".ColType"))

s_coltype4 = Left (s_coltype, 4)

CHOOSE CASE s_coltype4
	CASE "CHAR"
		s_stringval = Trim (i_dw_parent.GetItemString (a_l_row_num, &
																		a_s_col_name, &
																		a_e_buffer, &
																		a_b_origval))
		IF IsNull (s_stringval) THEN
			s_stringval = "null"
		ELSE
			// Double quotes must be doubled up.
			s_stringval = f_str_transform (s_stringval, "~"", "~"~"")
			s_stringval = "~"" + s_stringval + "~""
		END IF
	CASE "DATE"
		IF s_coltype = "DATE" THEN
			dte_value = i_dw_parent.GetItemDate (a_l_row_num, &
																a_s_col_name, &
																a_e_buffer, &
																a_b_origval)
			IF IsNull (dte_value) THEN
				s_stringval = "null"
			ELSE
				s_stringval = "~"" + &
									String (dte_value, "dd/mm/yyyy") + &
									"~""
			END IF
		ELSE
			dt_value = i_dw_parent.GetItemDateTime (a_l_row_num, &
																	a_s_col_name, &
																	a_e_buffer, &
																	a_b_origval)
			IF IsNull (dt_value) THEN
				s_stringval = "null"
			ELSE
				s_stringval = "~"" + &
							String (dt_value, "dd/mm/yyyy hh:mm:ss.fff") + &
							"~""
			END IF
		END IF
	CASE "DECI", "NUMB"
		d_value = i_dw_parent.GetItemNumber (a_l_row_num, a_s_col_name, &
															a_e_buffer, a_b_origval)
		IF IsNull (d_value) THEN
			s_stringval = "null"
		ELSE
			s_stringval = String (d_value)
		END IF
	CASE ELSE
		s_stringval = ""
END CHOOSE


// Return the resulting string value.

RETURN s_stringval

end function

protected function string fnv_prepare_batch ();// Retrieve Syntax from all DataWindows in the series and prepare
// the batch for shipment to the server.

String s_batch_sql, s_commit


// fnv_get_batch_sql () calls all dws in the chain recursively.

s_batch_sql = fnv_get_batch_sql ()

IF Len (s_batch_sql) < 1 THEN
	RETURN ""
END IF


// Embed Commit in Syntax if Commit on Update flag is set.

IF i_b_commit_on_update THEN
	s_batch_sql = "begin tran ~r~n" + &
						s_batch_sql + "~r~n" + &
						"commit tran "
END IF


// View Syntax for DEBUGGING ONLY!

IF fnv_get_preview_batch_sql () THEN
	s_batch_sql = f_str_dialog (s_batch_sql)
END IF


RETURN s_batch_sql
end function

protected function boolean fnv_submit_batch ();// Build and submit the batch to the DBMS server.  This performs the
// same functions of the ancestor function with the exception that the
// SQL Server results must be flushed by 'bouncing' transaction.autocommit.
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
// IF transaction.autocommit is TRUE after an error is encountered
// then the SQL Server results must be flushed by bouncing the value
// of transaction.autocommit.

 EXECUTE IMMEDIATE :s_batch_sql &
   USING i_tr;

IF i_tr.SQLCode < 0 THEN
	fnv_set_update_status (-1)
	fnv_set_dberror (Primary!, 0, "", i_tr.SQLErrText, "", &
										i_tr.SQLDBCode, i_tr.SQLErrText)
	fnv_restore_autocommit ()
	IF i_b_manage_transaction AND &
		i_tr.autocommit THEN				// Bounce value to flush results
		i_tr.autocommit = FALSE
		i_tr.autocommit = TRUE
	END IF
	fnv_display_dberror ()
	RETURN FALSE
END IF


// Update successful.

RETURN TRUE
end function

on constructor;call nv_dw_dbiu_pl::constructor;//
//	Maintenance
//		3/30/95	#37	Override ancestor function fnv_submit_batch to
//							clear SQLServer results if an error was encountered
//							and autocommit is not to be set to FALSE.
//							Protected the following methods:
//								fnv_append_batch,
//								fnv_build_del_proc_call,
//								fnv_build_ins_proc_call,
//								fnv_build_upd_proc_call,
//								fnv_get_item_dbparm,
//								fnv_prepare_batch,
//								fnv_submit_batch.
end on

on nv_dw_dbiu_syb_pt.create
TriggerEvent( this, "constructor" )
end on

on nv_dw_dbiu_syb_pt.destroy
TriggerEvent( this, "destructor" )
end on

