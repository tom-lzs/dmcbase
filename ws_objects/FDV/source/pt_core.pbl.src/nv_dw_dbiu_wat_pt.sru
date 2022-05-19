$PBExportHeader$nv_dw_dbiu_wat_pt.sru
$PBExportComments$Interface Générale Datawindows/Bases de Données pour les Update Watcom
forward
global type nv_dw_dbiu_wat_pt from nv_dw_dbiu_pl
end type
end forward

global type nv_dw_dbiu_wat_pt from nv_dw_dbiu_pl
end type
global nv_dw_dbiu_wat_pt nv_dw_dbiu_wat_pt

type variables

end variables

forward prototypes
protected function string fnv_build_del_proc_call (long a_l_row_num, dwbuffer a_e_buffer)
protected function string fnv_build_ins_proc_call (long a_l_row_num, dwbuffer a_e_buffer)
protected function string fnv_build_upd_proc_call (long a_l_row_num, dwbuffer a_e_buffer)
protected function string fnv_get_item_dbparm (long a_l_row_num, string a_s_col_name, dwbuffer a_e_buffer, boolean a_b_origval)
public function integer fnv_set_batch_update (boolean a_b_batch_update)
end prototypes

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
		s_prc_call = "CALL " + s_prc_name + " (" + s_item_stringval
	ELSE
		s_prc_call = s_prc_call + ", " + s_item_stringval
	END IF
NEXT

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
	// parameter list as necessary
	IF Len (s_prc_call) = 0 THEN
		s_prc_call = "CALL " + s_prc_name + " (" + s_item_stringval
	ELSE
		s_prc_call = s_prc_call + ", " + s_item_stringval
	END IF
NEXT

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
	// parameter list as necessary
	IF Len (s_prc_call) = 0 THEN
		s_prc_call = "CALL " + s_prc_name + " (" + s_item_stringval
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
		s_prc_call = "CALL " + s_prc_name + " (" + s_item_stringval
	ELSE
		s_prc_call = s_prc_call + ", " + s_item_stringval
	END IF
NEXT

IF Len (s_prc_call) > 0 THEN
	s_prc_call = s_prc_call + ")"
END IF


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
// null will be returned as the string "NULL."  Note that embedded
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
			s_stringval = "NULL"
		ELSE
			// Single quotes must be doubled up.
			s_stringval = f_str_transform (s_stringval, "'", "''")
			s_stringval = "'" + s_stringval + "'"
		END IF
	CASE "DATE"
		IF s_coltype = "DATE" THEN
			dte_value = i_dw_parent.GetItemDate (a_l_row_num, &
																a_s_col_name, &
																a_e_buffer, &
																a_b_origval)
			IF IsNull (dte_value) THEN
				s_stringval = "NULL"
			ELSE
				s_stringval = "'" + &
									String (dte_value, "dd/mm/yyyy") + &
									"'"
			END IF
		ELSE
			dt_value = i_dw_parent.GetItemDateTime (a_l_row_num, &
																	a_s_col_name, &
																	a_e_buffer, &
																	a_b_origval)
			IF IsNull (dt_value) THEN
				s_stringval = "NULL"
			ELSE
				s_stringval = "'" + &
							String (dt_value, "dd/mm/yyyy hh:mm:ss.fff") + &
							"'"
			END IF
		END IF
	CASE "DECI", "NUMB"
		d_value = i_dw_parent.GetItemNumber (a_l_row_num, a_s_col_name, &
															a_e_buffer, a_b_origval)
		IF IsNull (d_value) THEN
			s_stringval = "NULL"
		ELSE
			s_stringval = String (d_value)
		END IF
	CASE "TIME"
		tme_value = i_dw_parent.GetItemTime (a_l_row_num, &
															a_s_col_name, &
															a_e_buffer, &
															a_b_origval)
		IF IsNull (tme_value) THEN
			s_stringval = "NULL"
		ELSE
			s_stringval = "'" + &
								String (tme_value, "hh:mm:ss.fff") + &
								"'"
		END IF
	CASE ELSE
		s_stringval = ""
END CHOOSE


// Return the resulting string value.

RETURN s_stringval

end function

public function integer fnv_set_batch_update (boolean a_b_batch_update);// Watcom does not allow for batching of SQL.

RETURN -1
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

on nv_dw_dbiu_wat_pt.create
TriggerEvent( this, "constructor" )
end on

on nv_dw_dbiu_wat_pt.destroy
TriggerEvent( this, "destructor" )
end on

