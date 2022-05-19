$PBExportHeader$w_a_assoc_pt.srw
$PBExportComments$Ancêtre des fenêtres associatives
forward
global type w_a_assoc_pt from w_a_udim
end type
end forward

global type w_a_assoc_pt from w_a_udim
int Width=577
event ue_addall ( unsignedlong wparam,  long lparam )
event ue_removeall ( unsignedlong wparam,  long lparam )
end type
global w_a_assoc_pt w_a_assoc_pt

type variables
PROTECTED: 

u_dwa i_dw_main 
u_dwa i_dw_assoc 
u_dwa i_dw_choices 
str_assoc i_str_assoc
boolean i_b_remove_choices = FALSE 
boolean i_b_add_sorted = TRUE 
boolean i_b_select_moved_rows = TRUE 

end variables

forward prototypes
public subroutine fw_set_remove_choices (boolean a_b_remove_choices)
public subroutine fw_set_choices (u_dwa a_dw_choices)
public subroutine fw_set_main (u_dwa a_dw_main)
public subroutine fw_set_add_sorted (boolean a_b_add_sorted)
public subroutine fw_add_choice (long a_l_choices_row)
public subroutine fw_remove_assoc (long a_l_assoc_row)
public subroutine fw_define_assoc (str_assoc a_str_assoc)
public subroutine fw_set_assoc (u_dwa a_dw_assoc)
public function integer fw_filter_choices ()
public function boolean fw_get_add_sorted ()
public function boolean fw_get_remove_choices ()
public function u_dwa fw_get_assoc ()
public function u_dwa fw_get_main ()
public function u_dwa fw_get_choices ()
public subroutine fw_set_select_moved_rows (boolean a_b_select_moved_rows)
public function boolean fw_get_select_moved_rows ()
public function integer fw_delete_row (datawindow a_dw, long a_l_row)
end prototypes

on ue_addall;call w_a_udim::ue_addall;
// Adds all rows to the assoc datawindow.

long l_row , l_row_count 

IF NOT IsValid ( i_dw_choices ) THEN RETURN 
IF IsNull ( i_dw_choices ) THEN RETURN 

l_row_count = i_dw_choices.RowCount ( ) 
IF l_row_count < 1 THEN RETURN 

// this may take awhile
SetPointer ( HourGlass! ) 

IF IsValid ( i_dw_assoc ) THEN 
	IF NOT IsNull ( i_dw_assoc ) THEN 
		i_dw_assoc.SelectRow ( 0 , FALSE ) 
	END IF 
END IF 

FOR l_row = 1 TO l_row_count 
	IF i_b_remove_choices THEN 
		this.fw_add_choice ( 1 )
		//i_dw_choices.DeleteRow ( 1 ) // GPFs in PB 4.0.01.01 & 4.0.02!
		this.fw_delete_row ( i_dw_choices , 1 ) 
	ELSE 
		this.fw_add_choice ( l_row ) 
	END IF 
NEXT 

IF i_b_add_sorted THEN 
	IF IsValid ( i_dw_assoc ) THEN 
		IF NOT IsNull ( i_dw_assoc ) THEN 
			i_dw_assoc.Sort ( ) 
		END IF 
	END IF 
END IF 

IF NOT i_b_select_moved_rows THEN 
	IF IsValid ( i_dw_assoc ) THEN 
		IF NOT IsNull ( i_dw_assoc ) THEN 
			i_dw_assoc.SelectRow ( 0 , FALSE ) 
		END IF 
	END IF 
END IF 

end on

on ue_removeall;call w_a_udim::ue_removeall;
// Removes all rows from the assoc datawindow.

long l_row , l_row_count 

IF NOT IsValid ( i_dw_assoc ) THEN RETURN 
IF IsNull ( i_dw_assoc ) THEN RETURN 

l_row_count = i_dw_assoc.RowCount ( ) 
IF l_row_count < 1 THEN RETURN 

// this may take awhile
SetPointer ( HourGlass! ) 

IF IsValid ( i_dw_choices ) THEN 
	IF NOT IsNull ( i_dw_choices ) THEN 
		i_dw_choices.SelectRow ( 0 , FALSE ) 
	END IF 
END IF 

FOR l_row = 1 to l_row_count 
	this.fw_remove_assoc ( 1 ) 
NEXT 

IF i_b_add_sorted AND i_b_remove_choices THEN 
	IF IsValid ( i_dw_choices ) THEN 
		IF NOT IsNull ( i_dw_choices ) THEN 
			i_dw_choices.Sort ( ) 
		END IF 
	END IF 
END IF 

IF NOT i_b_select_moved_rows THEN 
	IF IsValid ( i_dw_choices ) THEN 
		IF NOT IsNull ( i_dw_choices ) THEN 
			i_dw_choices.SelectRow ( 0 , FALSE ) 
		END IF 
	END IF 
END IF 

end on

public subroutine fw_set_remove_choices (boolean a_b_remove_choices);
i_b_remove_choices = a_b_remove_choices 

end subroutine

public subroutine fw_set_choices (u_dwa a_dw_choices);
i_dw_choices = a_dw_choices 

end subroutine

public subroutine fw_set_main (u_dwa a_dw_main);
i_dw_main = a_dw_main 

end subroutine

public subroutine fw_set_add_sorted (boolean a_b_add_sorted);
i_b_add_sorted = a_b_add_sorted 

end subroutine

public subroutine fw_add_choice (long a_l_choices_row);
// Adds the given row. 

int i_index , i_count 
long l_main_row , l_assoc_row 
string s_item , s_find, s_source
dwItemStatus e_item_status 

IF NOT IsValid ( i_dw_assoc ) THEN RETURN 
IF IsNull ( i_dw_assoc ) THEN RETURN 

i_dw_assoc.SetRedraw ( FALSE ) 

IF IsValid ( i_dw_main ) THEN 
	IF NOT IsNull ( i_dw_main ) THEN 
		l_main_row = i_dw_main.GetRow ( ) 
	END IF 
END IF 

l_assoc_row = i_dw_assoc.InsertRow ( 0 ) 

IF i_b_select_moved_rows THEN 
	i_dw_assoc.SelectRow ( l_assoc_row , TRUE ) 
END IF 

i_count = min ( min ( UpperBound ( i_str_assoc.s_column ) , & 
		UpperBound ( i_str_assoc.s_source ) ) , & 
		UpperBound ( i_str_assoc.s_item ) ) 

FOR i_index = 1 TO i_count 
	s_source = Lower ( Left ( i_str_assoc.s_source[i_index], 3 ) )
	CHOOSE CASE s_source
		CASE "cho" // "choices" datawindow column 
			IF a_l_choices_row < 1 THEN CONTINUE 
			IF NOT IsValid ( i_dw_choices ) THEN CONTINUE 
			IF IsNull ( i_dw_choices ) THEN CONTINUE 
			s_item = i_dw_choices.fu_get_item_any ( a_l_choices_row , & 
					i_str_assoc.s_item[i_index] ) 
		CASE "mai" // "main" datawindow column 
			IF l_main_row < 1 THEN CONTINUE 
			s_item = i_dw_main.fu_get_item_any ( l_main_row , & 
					i_str_assoc.s_item[i_index] ) 
		CASE "eve" // "event" on window 
			Message.StringParm = "" 
			Message.DoubleParm = a_l_choices_row 
			IF this.TriggerEvent ( i_str_assoc.s_item[i_index] ) < 0 THEN 
				CONTINUE 
			END IF 
			s_item = Message.StringParm 
		CASE "key" // "key" generated 
			s_item = String ( SQLCA.fnv_next_in_sequence ( & 
					i_str_assoc.s_item[i_index]) ) 
		CASE "val" // "value" given 
			s_item = i_str_assoc.s_item[i_index] 
		CASE ELSE // bad 
			CONTINUE 
	END CHOOSE 
	i_dw_assoc.fu_set_item_any ( l_assoc_row , i_str_assoc.s_column[i_index] , & 
			s_item ) 
NEXT 

IF l_assoc_row > 1 THEN // not first row added 
	i_count = UpperBound ( i_str_assoc.s_key ) 
	IF i_count > 0 THEN // key columns defined 
		s_find = "" 
		FOR i_index = 1 TO i_count 
			s_item = i_dw_assoc.fu_get_item_any ( l_assoc_row , & 
					i_str_assoc.s_key[i_index] ) 
			IF Left ( i_dw_assoc.Describe ( i_str_assoc.s_key[i_index] + & 
					".ColType" ) , 4 ) = "char" THEN // string type 
				IF pos ( s_item , "'" ) > 0 THEN 
					s_item = '"' + s_item + '"' 
				ELSE 
					s_item = "'" + s_item + "'" 
				END IF 
			ELSEIF Left ( i_dw_assoc.Describe ( i_str_assoc.s_key[i_index] + & 
				".ColType" ) , 8 ) = "datetime" THEN // datetime type 
				s_item = "f_datetime('" + s_item + "')" 
			END IF 
			IF i_index > 1 THEN s_find = s_find + " AND " 
			s_find = s_find + i_str_assoc.s_key[i_index] + "=" + s_item 
		NEXT 
		IF i_dw_assoc.Find ( s_find , 1 , l_assoc_row - 1 ) > 0 THEN 
			//i_dw_assoc.DeleteRow ( l_assoc_row ) 
					// GPFs in PB 4.0.01.01 & 4.0.02! 
			this.fw_delete_row ( i_dw_assoc , l_assoc_row ) 
		END IF 
	END IF // keys defined 
END IF // first row 

i_dw_assoc.SetRedraw ( TRUE ) 

end subroutine

public subroutine fw_remove_assoc (long a_l_assoc_row);
// Removes the given row. 

int i_index , i_count 
long l_choices_row 
string s_item 
dwItemStatus e_item_status 

IF NOT IsValid ( i_dw_assoc ) THEN RETURN 
IF IsNull ( i_dw_assoc ) THEN RETURN 

IF a_l_assoc_row < 1 THEN RETURN 

IF i_b_remove_choices THEN // put the row back 
	IF IsValid ( i_dw_choices ) THEN 
		IF NOT IsNull ( i_dw_choices ) THEN 
			l_choices_row = i_dw_choices.InsertRow ( 0 ) 
			IF i_b_select_moved_rows THEN 
				i_dw_choices.SelectRow ( l_choices_row , TRUE ) 
			END IF 
			i_count = min ( min ( UpperBound ( i_str_assoc.s_column ) , & 
					UpperBound ( i_str_assoc.s_source ) ) , & 
					UpperBound ( i_str_assoc.s_item ) ) 
			FOR i_index = 1 TO i_count 
				IF Lower ( Left ( i_str_assoc.s_source[i_index] , 3 ) ) = & 
						"cho" THEN // "choices" datawindow column 
					s_item = i_dw_assoc.fu_get_item_any ( a_l_assoc_row , & 
							i_str_assoc.s_column[i_index] ) 
					i_dw_choices.fu_set_item_any ( l_choices_row , & 
							i_str_assoc.s_item[i_index] , s_item ) 
				END IF // choices source 
			NEXT // index 
		END IF // not null 
	END IF // is valid 
END IF // remove choices 

//i_dw_assoc.DeleteRow ( a_l_assoc_row ) 
		// GPFs in PB 4.0.01.01 & 4.0.02! 
this.fw_delete_row ( i_dw_assoc , a_l_assoc_row ) 

end subroutine

public subroutine fw_define_assoc (str_assoc a_str_assoc);
i_str_assoc = a_str_assoc 

end subroutine

public subroutine fw_set_assoc (u_dwa a_dw_assoc);
i_dw_assoc = a_dw_assoc 

end subroutine

public function integer fw_filter_choices ();
// Filters the choices datawindow to remove choices that are already
// included in the assoc datawindow.
//
// Call this function in the "retrieveend" event of the choices datawindow
// if the SELECT statement doesn't explicitly filter out these rows.
//
// Returns -1 if the mapping defined in i_str_assos is insufficient 
// to determine what constitutes being "included", else returns 1.


int i_rc = 1 
int i_key_count , i_key_index 
int i_col_count , i_col_index 
int i_map_count , i_map_index 
long l_assoc_count , l_assoc_row , l_choices_count , l_choices_row 
string s_choices_map[] , s_assoc_map[] , s_item , s_find 
dwItemStatus e_item_status 

// verify choices datawindow is valid 
IF NOT IsValid ( i_dw_choices ) THEN RETURN -1 
IF IsNull ( i_dw_choices ) THEN RETURN -1 

// verify assoc datawindow is valid 
IF NOT IsValid ( i_dw_assoc ) THEN RETURN -1 
IF IsNull ( i_dw_assoc ) THEN RETURN -1 

// get and verify number of keys defined 
i_key_count = UpperBound ( i_str_assoc.s_key ) 
IF i_key_count < 1 THEN RETURN -1 

// get and verify number of columns mapped 
i_col_count = min ( min ( UpperBound ( i_str_assoc.s_column ) , & 
		UpperBound ( i_str_assoc.s_source ) ) , & 
		UpperBound ( i_str_assoc.s_item ) ) 
IF i_col_count < 1 THEN RETURN -1 

// get and verify count of rows in choices datawindow 
l_choices_count = i_dw_choices.RowCount ( ) 
IF l_choices_count < 1 THEN RETURN 1 

// get and verify count of rows in choices assoc 
l_assoc_count = i_dw_assoc.RowCount ( ) 
IF l_assoc_count < 1 THEN RETURN 1 

SetPointer ( Hourglass! ) // this may take a while 

// loop through keys and get column mapped to choices datawindow 
i_map_count = 0 
FOR i_key_index = 1 TO i_key_count 
	FOR i_col_index = 1 TO i_col_count 
		IF i_str_assoc.s_column[i_col_index] = & 
				i_str_assoc.s_key[i_key_index] AND & 
				Lower ( Left ( i_str_assoc.s_source[i_col_index] , & 
				3 ) ) = "cho" THEN 
				// the key column is mapped to a choices column 
			i_map_count ++ 
			s_choices_map[i_map_count] = i_str_assoc.s_item[i_col_index] 
			s_assoc_map[i_map_count] = i_str_assoc.s_key[i_key_index] 
			EXIT 
		END IF 
	NEXT 
NEXT // i_key_index 

IF i_map_count < 1 THEN RETURN -1 // no mappings found 

i_dw_choices.SetRedraw ( FALSE ) // make deletes paint fast 

// loop through all rows in assoc datawindow 
FOR l_assoc_row = 1 TO l_assoc_count 

	// build search string  
	s_find = "" 
	FOR i_map_index = 1 TO i_map_count 
		s_item = i_dw_assoc.fu_get_item_any ( l_assoc_row , & 
				s_assoc_map[i_map_index] ) 
		IF Left ( i_dw_choices.Describe ( s_choices_map[i_map_index] + & 
				".ColType" ) , 4 ) = "char" THEN // string type 
			IF pos ( s_item , "'" ) > 0 THEN 
				s_item = '"' + s_item + '"' 
			ELSE 
				s_item = "'" + s_item + "'" 
			END IF 
		ELSEIF Left ( i_dw_choices.Describe ( s_choices_map[i_map_index] + & 
			".ColType" ) , 8 ) = "datetime" THEN // datetime type 
			s_item = "f_datetime('" + s_item + "')"
		END IF 
		IF i_map_index > 1 THEN s_find = s_find + " AND " 
		s_find = s_find + s_choices_map[i_map_index] + "=" + s_item 
	NEXT 

	// find and delete rows matching search 
	l_choices_row = 1 
	DO WHILE TRUE 
		l_choices_row = i_dw_choices.Find ( s_find , & 
				l_choices_row , l_choices_count ) 
		IF l_choices_row < 1 THEN EXIT 
		//i_dw_choices.DeleteRow ( l_choices_row ) 
				// GPFs in PB 4.0.01.01 & 4.0.02! 
		this.fw_delete_row ( i_dw_choices , l_choices_row ) 
	LOOP 

NEXT // row in assoc datawindow 

i_dw_choices.SetRedraw ( TRUE ) 

RETURN i_rc 

end function

public function boolean fw_get_add_sorted ();
RETURN i_b_add_sorted 

end function

public function boolean fw_get_remove_choices ();
RETURN i_b_remove_choices 

end function

public function u_dwa fw_get_assoc ();
RETURN i_dw_assoc 

end function

public function u_dwa fw_get_main ();
RETURN i_dw_main 

end function

public function u_dwa fw_get_choices ();
RETURN i_dw_choices 

end function

public subroutine fw_set_select_moved_rows (boolean a_b_select_moved_rows);
i_b_select_moved_rows = a_b_select_moved_rows 

end subroutine

public function boolean fw_get_select_moved_rows ();
RETURN i_b_select_moved_rows 

end function

public function integer fw_delete_row (datawindow a_dw, long a_l_row);
// This function was created in order to work around a bug in PowerBuilder
// version 4.0.01(.01) and 4.0.02 which causes a GPF when deleting a row
// from a DataWindow which is referenced via an instance variable pointer.

int i_return 
dwItemStatus e_item_status 

e_item_status = a_dw.GetItemStatus ( a_l_row , 0 , & 
		Primary! ) 
IF e_item_status = New! OR e_item_status = NewModified! THEN 
	i_return = a_dw.RowsDiscard ( a_l_row , a_l_row , Primary! ) 
ELSE 
	i_return = a_dw.RowsMove ( a_l_row , a_l_row , Primary! , & 
			a_dw , 1 , Delete! ) 
END IF 

RETURN i_return 

end function

on open;call w_a_udim::open;
// Checks to see if any pointers were passed in via i_str_pass:
// s[] is used to indicate the type of information, 
// po[] is used to pass the information.

int i_index , i_count 
string s_dw

IF not IsValid ( i_str_pass ) THEN RETURN 
IF IsNull ( i_str_pass ) THEN RETURN 

i_count = UpperBound ( i_str_pass.po ) 
FOR i_index = 1 TO i_count 
	IF ClassName ( i_str_pass.po[i_index] ) = "str_assoc" THEN 
		i_str_assoc = i_str_pass.po[i_index] 
	ELSE 
		IF UpperBound ( i_str_pass.s ) < i_index THEN EXIT 
		s_dw = Lower ( Left ( i_str_pass.s[i_index] , 4 ) )
		CHOOSE CASE s_dw
			CASE "choi" // "choices" datawindow 
				i_dw_choices = i_str_pass.po[i_index] 
			CASE "main" // "main" datawindow 
				i_dw_main = i_str_pass.po[i_index] 
			CASE "asso" // "assoc" datawindow 
				i_dw_assoc = i_str_pass.po[i_index] 
		END CHOOSE 
	END IF 
NEXT 

end on

on ue_add;call w_a_udim::ue_add;
// Adds selected rows to the assoc datawindow.

long l_row , l_selected_rows[] , l_count , l_index 

IF NOT IsValid ( i_dw_choices ) THEN RETURN 
IF IsNull ( i_dw_choices ) THEN RETURN 

l_count = 0 
l_row = 0 
DO WHILE TRUE 
	l_row = i_dw_choices.GetSelectedRow ( l_row ) 
	IF l_row < 1 THEN EXIT 
	l_count ++ 
	l_selected_rows[l_count] = l_row 
LOOP 

IF l_count < 1 THEN RETURN // Nothing to add. 

IF IsValid ( i_dw_assoc ) THEN 
	IF NOT IsNull ( i_dw_assoc ) THEN 
		i_dw_assoc.SelectRow ( 0 , FALSE ) 
	END IF 
END IF 

FOR l_index = 1 TO l_count 
	l_row = l_selected_rows[l_index] 
	this.fw_add_choice ( l_row ) 
NEXT 

IF i_b_remove_choices THEN 
	FOR l_index = l_count TO 1 STEP -1 
		l_row = l_selected_rows[l_index] 
		//i_dw_choices.DeleteRow ( l_row ) 
				// GPFs in PB 4.0.01.01 & PB 4.0.02! 
		this.fw_delete_row ( i_dw_choices , l_row ) 
	NEXT 
END IF 

IF i_b_add_sorted THEN 
	IF IsValid ( i_dw_assoc ) THEN 
		IF NOT IsNull ( i_dw_assoc ) THEN 
			i_dw_assoc.Sort ( ) 
		END IF 
	END IF 
END IF 

IF NOT i_b_select_moved_rows THEN 
	IF IsValid ( i_dw_assoc ) THEN 
		IF NOT IsNull ( i_dw_assoc ) THEN 
			i_dw_assoc.SelectRow ( 0 , FALSE ) 
		END IF 
	END IF 
END IF 

end on

on ue_remove;call w_a_udim::ue_remove;
// Removes selected rows from the assoc datawindow.

long l_row , l_selected_rows[] , l_count , l_index 

IF NOT IsValid ( i_dw_assoc ) THEN RETURN 
IF IsNull ( i_dw_assoc ) THEN RETURN 

l_row = 0 
l_count = 0 
DO WHILE TRUE 
	l_row = i_dw_assoc.GetSelectedRow ( l_row ) 
	IF l_row < 1 THEN EXIT 
	l_count ++ 
	l_selected_rows[l_count] = l_row 
LOOP 

IF l_count < 1 THEN RETURN // Nothing to add. 

IF IsValid ( i_dw_choices ) THEN 
	IF NOT IsNull ( i_dw_choices ) THEN 
		i_dw_choices.SelectRow ( 0 , FALSE ) 
	END IF 
END IF 

FOR l_index = 1 TO l_count 
	l_row = l_selected_rows[l_index] - l_index + 1 
			// accounts for rows removed 
	this.fw_remove_assoc ( l_row ) 
NEXT 

IF i_b_add_sorted AND i_b_remove_choices THEN 
	IF IsValid ( i_dw_choices ) THEN 
		IF NOT IsNull ( i_dw_choices ) THEN 
			i_dw_choices.Sort ( ) 
		END IF 
	END IF 
END IF 

IF NOT i_b_select_moved_rows THEN 
	IF IsValid ( i_dw_choices ) THEN 
		IF NOT IsNull ( i_dw_choices ) THEN 
			i_dw_choices.SelectRow ( 0 , FALSE ) 
		END IF 
	END IF 
END IF 

end on

on w_a_assoc_pt.create
call w_a_udim::create
end on

on w_a_assoc_pt.destroy
call w_a_udim::destroy
end on

type dw_1 from w_a_udim`dw_1 within w_a_assoc_pt
int X=33
int Width=485
int TabOrder=20
end type

on dw_1::constructor;call w_a_udim`dw_1::constructor;
parent.fw_set_assoc ( this ) // point assoc dw to here 

this.fu_set_selection_mode ( 3 ) // default to multi (w/o cntrl) 

end on

