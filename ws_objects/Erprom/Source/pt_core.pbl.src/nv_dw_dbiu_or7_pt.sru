$PBExportHeader$nv_dw_dbiu_or7_pt.sru
$PBExportComments$Interface Générale Datawindows/Bases de Données pour les Update Oracle 7
forward
global type nv_dw_dbiu_or7_pt from nv_dw_dbiu_pl
end type
end forward

global type nv_dw_dbiu_or7_pt from nv_dw_dbiu_pl
end type
global nv_dw_dbiu_or7_pt nv_dw_dbiu_or7_pt

type variables
PROTECTED:

// The following variable controls database retrieval
Boolean i_b_reset_crlf		// reset CRLF on string columns after retrieve
end variables

forward prototypes
public function boolean fnv_get_reset_crlf ()
public function integer fnv_set_reset_crlf (boolean a_b_reset_crlf)
protected subroutine fnv_append_batch (string a_s_sql_call)
protected function string fnv_build_del_proc_call (long a_l_row_num, dwbuffer a_e_buffer)
protected function string fnv_build_ins_proc_call (long a_l_row_num, dwbuffer a_e_buffer)
protected function string fnv_build_upd_proc_call (long a_l_row_num, dwbuffer a_e_buffer)
protected function string fnv_get_item_dbparm (long a_l_row_num, string a_s_col_name, dwbuffer a_e_buffer, boolean a_b_origval)
protected function string fnv_prepare_batch ()
protected function long fnv_reset_crlf ()
protected function boolean fnv_set_update_sql (string a_s_sql)
public function integer fnv_event_retrieveend ()
end prototypes

public function boolean fnv_get_reset_crlf ();// Return value of the instance variable.

RETURN i_b_reset_crlf
end function

public function integer fnv_set_reset_crlf (boolean a_b_reset_crlf);// Set value of instance variable to value passed.

i_b_reset_crlf = a_b_reset_crlf

RETURN 1
end function

protected subroutine fnv_append_batch (string a_s_sql_call);// Format for readability and append syntax to any syntax previously
// built with a carriage return/line feed (~r~n) if this is a Batched
// SQL update.  Append ';' to the end of the syntax.

a_s_sql_call = "   " + a_s_sql_call + "; "

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

s_table_name = i_dw_parent.describe ("datawindow.Table.UpdateTable")

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
	// parameter list as necessary.  Oracle likes parentheses around
	// its parameter list.
	IF Len (s_prc_call) = 0 THEN
		s_prc_call = s_prc_name + " (" + s_item_stringval
	ELSE
		s_prc_call = s_prc_call + ", " + s_item_stringval
	END IF
NEXT


// Append ')' to the end of the parameter list, if it exists

IF Len (s_prc_call) > 0 THEN
	s_prc_call = s_prc_call + ")"
END IF

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
	// parameter list as necessary.  Oracle likes parentheses around
	// its parameter list.
	IF Len (s_prc_call) = 0 THEN
		s_prc_call = s_prc_name + " (" + s_item_stringval
	ELSE
		s_prc_call = s_prc_call + ", " + s_item_stringval
	END IF
NEXT


// Append ')' to the end of the parameter list, if it exists

IF Len (s_prc_call) > 0 THEN
	s_prc_call = s_prc_call + ")"
END IF

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
	// parameter list as necessary.  Oracle likes parentheses around
	// its parameter list.
	IF Len (s_prc_call) = 0 THEN
		s_prc_call = s_prc_name + " (" + s_item_stringval
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
	// parameter list as necessary.  Oracle likes parentheses around
	// its parameter list.
	IF Len (s_prc_call) = 0 THEN
		s_prc_call = s_prc_name + " (" + s_item_stringval
	ELSE
		s_prc_call = s_prc_call + ", " + s_item_stringval
	END IF
NEXT

// Append ')' to the end of the parameter list, if it exists

IF Len (s_prc_call) > 0 THEN
	s_prc_call = s_prc_call + ")"
END IF

RETURN s_prc_call
end function

protected function string fnv_get_item_dbparm (long a_l_row_num, string a_s_col_name, dwbuffer a_e_buffer, boolean a_b_origval);// Return the value of the column as a string which Oracle recognizes.

String s_coltype, s_coltype4, s_stringval
Double d_value
Date dte_value
Time tme_value
DateTime dt_value


// Convert Column Number if Column Name

IF IsNumber (a_s_col_name) THEN
	a_s_col_name = i_dw_parent.Describe ("#" + a_s_col_name + ".Name")
END IF


// Retrieve the data value of the column as a string.  Dates and
//	times will be returned in the dd/mm/yyyy hh:mm:ss format and
// null will be returned as the literal "null."  Note that embedded
// quotes (') will be doubled up ('').  Carriage return line feeds
// (~r~n) will be transformed into the sequence "|@crlf@|" until
// just before being passed to the DBMS since all carriage return
// line feeds in the PL/SQL will have to be converted to spaces
// before being passed to the DBMS (if we didn't do this then the
// carriage return line feeds in the data would also be converted!).

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
			// Single quotes must be doubled up and carriage return line
			// feeds are temporarily converted to the sequence "|@crlf@|."
			s_stringval = f_str_transform (s_stringval, "'", "''")
			s_stringval = f_str_transform (s_stringval, "~r~n", "|@crlf@|")
			s_stringval = "'" + s_stringval + "'"
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
				s_stringval = "TO_DATE ('" + &
									String (dte_value, "dd/mm/yyyy") + &
									"', 'DD/MM/YYYY')"
			END IF
		ELSE
			dt_value = i_dw_parent.GetItemDateTime (a_l_row_num, &
																	a_s_col_name, &
																	a_e_buffer, &
																	a_b_origval)
			IF IsNull (dt_value) THEN
				s_stringval = "null"
			ELSE
				s_stringval = "TO_DATE ('" + &
									String (dt_value, "dd/mm/yyyy hh:mm:ss") + &
									"', 'DD/MM/YYYY HH24:MI:SS')"
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

String s_batch_sql, s_commit, s_rollback


// fnv_get_batch_sql () calls all dws in the chain recursively.

s_batch_sql = fnv_get_batch_sql ()

IF Len (s_batch_sql) < 1 THEN
	RETURN ""
END IF


// Embed Commit in Syntax if Commit on Update flag is set.

IF i_b_commit_on_update THEN
	s_commit = "   COMMIT WORK; ~r~n"
END IF


// Embed Rollback in exception handler if Rollback on Failure flag
// is set.

IF i_b_rollback_on_failure THEN
	s_rollback = "      ROLLBACK; ~r~n"
END IF


// Append the exception handler.

s_batch_sql = "BEGIN ~r~n" + &
					s_batch_sql + "~r~n" + &
					s_commit + &
					"EXCEPTION ~r~n" + &
					"   WHEN OTHERS THEN ~r~n" + &
					s_rollback + &
					"      RAISE; ~r~n" + &
					"END; "


// View Syntax for DEBUGGING ONLY!

IF fnv_get_preview_batch_sql () THEN
	s_batch_sql = f_str_dialog (s_batch_sql)
END IF


// Oracle does not like Carriage Returns (~r) so kill them.

s_batch_sql = f_str_transform (s_batch_sql, "~r", "")


RETURN s_batch_sql
end function

protected function long fnv_reset_crlf ();// Transform all carriage return blanks ("~r ") to carriage return
// line feeds ("~r~n") if the controlling boolean, i_b_reset_crlf,
// is set to TRUE.  This ONLY works in the Primary! buffer.

String s_col_type, s_oldstring, s_newstring
Boolean b_row_modified
Long l_row_num, l_row_cnt, l_chg_cnt
Integer i_col_num, i_col_cnt


// Bail out if the i_b_reset_crlf is not set.

IF NOT fnv_get_reset_crlf () THEN
	RETURN 0
END IF


// Retrieve the number of columns and rows in the datawindow.

i_col_cnt = Integer (i_dw_parent.Describe ("DataWindow.Column.Count"))

l_row_cnt = i_dw_parent.RowCount ()


// For each row and each column, retrieve the data value of the
// column (if it is a string) and convert all "~r " to "~r~n".

FOR l_row_num = 1 TO l_row_cnt
	FOR i_col_num = 1 to i_col_cnt
		s_col_type = Upper (i_dw_parent.Describe ("#" + &
									String (i_col_num) + ".ColType"))
		IF Left (s_col_type, 4) = "CHAR" THEN
			s_oldstring = i_dw_parent.GetItemString (l_row_num, &
																				i_col_num)
			IF Len (s_oldstring) > 0 THEN
				s_newstring = f_str_transform (s_oldstring, "~r ", "~r~n")
				IF s_newstring <> s_oldstring THEN
					l_chg_cnt ++
					b_row_modified = TRUE
					i_dw_parent.SetItem (l_row_num, i_col_num, s_newstring)
					i_dw_parent.SetItemStatus (l_row_num, i_col_num, &
															Primary!, NotModified!)
				END IF
			END IF
		END IF
	NEXT
	IF b_row_modified THEN
		i_dw_parent.SetItemStatus (l_row_num, 0, Primary!, NotModified!)
		b_row_modified = FALSE
	END IF
NEXT


// Return the number of items changed.

RETURN l_chg_cnt
end function

protected function boolean fnv_set_update_sql (string a_s_sql);// Set the SQL syntax to the stored procedure call passed as a
// parameter (this is not a batched SQL update).  PowerBuilder
// requires the procedure name is preceded by "execute."

IF i_po_parent.function dynamic SetSQLPreview ("execute " + a_s_sql) < 1 THEN
	RETURN FALSE
ELSE
	RETURN TRUE
END IF
end function

public function integer fnv_event_retrieveend ();// This function is called by the parent DataWindow on a RetrieveEnd!
// event.  It will return -1 if a dberror was encountered and 1
// otherwise.


// Display dberror.

IF this.fnv_display_dberror () THEN
	RETURN -1
END IF


// Reset Carriage Return/Line Feeds

this.fnv_reset_crlf ()


RETURN 1
end function

on constructor;call nv_dw_dbiu_pl::constructor;//
//	Maintenance
//		3/30/95	#37	Protected the following methods:
//								fnv_append_batch,
//								fnv_build_del_proc_call,
//								fnv_build_ins_proc_call,
//								fnv_build_upd_proc_call,
//								fnv_get_item_dbparm,
//								fnv_prepare_batch,
//								fnv_reset_crlf,
//								fnv_set_update_sql.
end on

on nv_dw_dbiu_or7_pt.create
TriggerEvent( this, "constructor" )
end on

on nv_dw_dbiu_or7_pt.destroy
TriggerEvent( this, "destructor" )
end on

