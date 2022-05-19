$PBExportHeader$nv_dsa_pt.sru
$PBExportComments$Ancêtre des Datastore
forward
global type nv_dsa_pt from datastore
end type
end forward

global type nv_dsa_pt from datastore
event ue_postitemchanged ( unsignedlong wparam,  long lparam )
event ue_postdelete ( unsignedlong wparam,  long lparam )
event ue_postinsert ( unsignedlong wparam,  long lparam )
event ue_predelete ( unsignedlong wparam,  long lparam )
event ue_preinsert ( unsignedlong wparam,  long lparam )
event ue_reserved4powertool ( )
end type
global nv_dsa_pt nv_dsa_pt

type variables
PROTECTED:

// The following variables control database access
nv_transaction i_tr			// current transaction datawindow is attached to
nv_dw_dbi i_nv_dw_dbi		// object for dbms access protocol

// The following variables control datawindow/store linked list
powerobject i_po_prior		// prior dw/ds in a series
powerobject i_po_next		// next dw/ds in a series

// The following variable are used by the ItemChanged! event
Long i_l_itemchanged_row_num	// row number involved in ItemChanged! event
String i_s_itemchanged_col_name	// column name involved in ItemChanged! event
String i_s_itemchanged_text		// item text involved in ItemChanged! event

// The following variables control "search as you type"
Long i_l_src_row_num		// Last row successfully found
String i_s_src_col_nme		// Last column searched on
String i_s_src_string		// Last string successfully found

end variables

forward prototypes
public function nv_dw_dbi fu_get_nv_dw_dbi ()
public function boolean fu_update ()
public function boolean fu_changed ()
public function boolean fu_validate ()
public function integer fu_append (powerobject a_po)
public function powerobject fu_get_head_po ()
public function powerobject fu_get_next ()
public function powerobject fu_get_prior ()
public function nv_transaction fu_get_trans ()
public function long fu_recover_deleted_row (long a_l_row_num)
public function powerobject fu_get_tail_po ()
public subroutine fu_set_next (powerobject a_po_next)
public subroutine fu_set_prior (powerobject a_po_prior)
public subroutine fu_unlink ()
public function integer reset ()
public function integer resetupdate ()
public function integer settrans (nv_transaction a_trans)
public function integer settransobject (nv_transaction a_trans)
public subroutine fu_reset_dberror ()
public function boolean fu_accepttext ()
public subroutine fu_set_null (long a_l_row_num, string a_s_col_name)
public function integer fu_set_error_title (string a_s_title)
public function integer fu_load_ddlb_code_num (string a_s_table, string a_s_code_col, string a_s_value_col, string a_s_dw_col, nv_transaction a_trans)
public function integer fu_load_dw_ddlb_code_string (string a_s_table, string a_s_code_col, string a_s_value_col, string a_s_dw_col, nv_transaction a_trans)
public function string fu_get_error_title ()
public function string fu_get_item_any (long a_l_row_num, string a_s_col_name)
public function string fu_get_item_changed_col_name ()
public function long fu_get_item_changed_row_num ()
public function string fu_get_itemchanged_text ()
public function string fu_evaluate (string a_s_request, long a_l_row_num)
public function long fu_str_search (string a_s_search, string a_s_search_col_nme)
public function integer fu_set_item_any (long a_l_row_num, string a_s_col_name, string a_s_item)
public function integer fu_display_validation_msg (long a_l_row_num, string a_s_col_name, string a_s_default_msg, string a_s_title)
public function integer fu_dw_printpreview ()
public function boolean fu_check_required ()
end prototypes

public function nv_dw_dbi fu_get_nv_dw_dbi ();// Return the database interface object

RETURN i_nv_dw_dbi
end function

public function boolean fu_update ();// Function Stub
Return FALSE
end function

public function boolean fu_changed ();// Determine whether any changes are pending on this datawindow or
// any datawindow down the chain

this.AcceptText ()

IF this.DeletedCount () + this.ModifiedCount () < 1 THEN
	IF IsValid (i_po_next) THEN
		RETURN i_po_next.function dynamic fu_changed ()
	ELSE
		RETURN FALSE
	END IF
ELSE
	RETURN TRUE
END IF
end function

public function boolean fu_validate ();// Function Stub
Return FALSE
end function

public function integer fu_append (powerobject a_po);// Append a_po (datastore or datawindow) to the end of the list that
// 'this' is a member of

powerobject po_pointer, po_hold


// Find the top of the list

po_pointer = this.fu_get_head_po ()


// Scroll through each member of the list to the end and append
// passed a_po to the end.
// If a_po is already in the list then return -2.

DO WHILE IsValid (po_pointer)
	IF po_pointer = a_po THEN
		RETURN -2
	END IF
	po_hold = po_pointer
	po_pointer = po_pointer.function dynamic fu_get_next ()
LOOP

po_pointer = po_hold


// Set the pointer to the next control

po_pointer.function dynamic fu_set_next (a_po)

a_po.function dynamic fu_set_prior (po_pointer)


RETURN 1
end function

public function powerobject fu_get_head_po ();// Find the head control of the list that 'this' is a member of

powerobject po_pointer, po_hold


// Find the top of the list

po_pointer = this

DO WHILE IsValid (po_pointer)
	po_hold = po_pointer
	po_pointer = po_pointer.function dynamic fu_get_prior ()
LOOP


RETURN po_hold
end function

public function powerobject fu_get_next ();
return i_po_next
end function

public function powerobject fu_get_prior ();
return i_po_prior
end function

public function nv_transaction fu_get_trans ();// Return the transaction object associated with this control

return i_tr
end function

public function long fu_recover_deleted_row (long a_l_row_num);// Return row in Delete! buffer, pointed to by a_l_row_num, to the
// Primary! buffer and return row number.

Long l_target_row


// Target the move to append to the Primary! buffer.

l_target_row = this.RowCount ()

IF l_target_row < 0 THEN
	RETURN -1
END IF

l_target_row ++


// Move the row in the Delete! buffer to the target row.

IF this.RowsMove (a_l_row_num, a_l_row_num, Delete!, &
							this, l_target_row, Primary!) > 0 THEN
	RETURN this.RowCount ()
ELSE
	RETURN -1
END IF
end function

public function powerobject fu_get_tail_po ();// Find the last DataWindow of the list that 'this' is a member of

powerobject po_pointer, po_hold


// Find the bottom of the list

po_pointer = this

DO WHILE IsValid (po_pointer)
	po_hold = po_pointer
	po_pointer = po_pointer.function dynamic fu_get_next ()
LOOP


RETURN po_hold
end function

public subroutine fu_set_next (powerobject a_po_next);// Set the Value of the instance variable to the value passed

i_po_next = a_po_next
end subroutine

public subroutine fu_set_prior (powerobject a_po_prior);// Set the Value of the instance variable to the value passed

i_po_prior = a_po_prior
end subroutine

public subroutine fu_unlink ();// Function to remove this Datastore from the list it is a member of.

powerobject po_null


// Set the prior datawindow/store of the next datawindow/store to this
// datastores's prior datawindow/store.

IF IsValid (this.fu_get_next ()) THEN
	this.fu_get_next ().function dynamic fu_set_prior (this.fu_get_prior ())
END IF


// Set the next datawindow/store of the prior datawindow/store to this
// datastore's next datawindow/store.

IF IsValid (this.fu_get_prior ()) THEN
	this.fu_get_prior ().function dynamic fu_set_next (this.fu_get_next ())
END IF


// Remove this datastore's links to prior and next.

SetNull (po_null)

this.fu_set_next (po_null)

this.fu_set_prior (po_null)
end subroutine

public function integer reset ();// Overrides the PowerBuilder Reset for objects that inherit from nv_ds_pt.
// Calls the PowerBuilder Reset function then calls this function again for
// its next data window/store if available.

int i_ret

i_ret = super::Reset ()

IF IsValid (fu_get_next ()) and i_ret = 1 THEN
	i_ret = fu_get_next ().function dynamic Reset ()
END IF

RETURN i_ret
end function

public function integer resetupdate ();// Overrides the PowerBuilder ResetUpdate for objects that 
// inherit from u_dwa_pt

Integer i_ret


// Reset the update flags on this and the next DataWindow in the list

i_ret = super::ResetUpdate ()

IF IsValid (fu_get_next ()) AND &
	i_ret > 0 THEN
	i_ret = fu_get_next ().function dynamic ResetUpdate ()
END IF


RETURN i_ret
end function

public function integer settrans (nv_transaction a_trans);// The name of this function necessarily violates the PowerTOOL
// naming conventions since it overrides a standard PowerBuilder
// function.

// This function overrides PowerBuilder's SetTrans in order to
// capture the transaction object specified for descendents of nv_dsa.
// Since a datastore must have a transaction set, the application
// will at some point call SetTrans or SetTransObject.  For
// datastores descended from u_dwa, this call will be overridden by
// this function, which captures the transaction to a local instance
// variable.  Of course, we still call PowerBuilder's SetTrans;
// this works because 'super' of u_dwa is datastore.  Having
// captured the transaction, we can then refer to it locally in such
// user-object functions as fu_update.  

// This function will set the transaction for the datastore and, if
// successful, save the transaction to an instance variable,
// instantiate the appropriate dbms protocol non-visual user object
// and call SetTrans for the next dw in the chain.


// Call PowerBuilder SetTrans

IF super::SetTrans (a_trans) < 0 THEN
	RETURN -1
END IF


// Save the transaction

i_tr = a_trans


// Call SetTransObject for the next object in the chain, if it exist

IF IsValid (fu_get_next ()) THEN
	RETURN fu_get_next ().function dynamic SetTrans (i_tr)
ELSE
	RETURN 1
END IF
end function

public function integer settransobject (nv_transaction a_trans);// The name of this function necessarily violates the PowerTOOL
// naming conventions since it overrides a standard PowerBuilder
// function.

// This function overrides PowerBuilder's SetTransObject in order to
// capture the transaction object specified for descendents of u_dwa.
// Since a datastore must have a transaction set, the application
// will at some point call SetTrans or SetTransObject.  For
// datastores descended from u_dwa, this call will be overridden by
// this function, which captures the transaction to a local instance
// variable.  Of course, we still call PowerBuilder's SetTransObject;
// this works because 'super' of u_dwa is datastore.  Having
// captured the transaction, we can then refer to it locally in such
// user-object functions as fu_update. 

// This function will set the transaction for the datastore and, if
// successful, save the transaction to an instance variable,
// instantiate the appropriate dbms protocol non-visual user object
// and call SetTransObject for the next object in the chain.


// Call PowerBuilder SetTransObject

IF super::SetTransObject (a_trans) < 0 THEN
	RETURN -1
END IF


// Save the transaction

i_tr = a_trans


// Call SetTransObject for the next dw in the chain, if it exists.

IF IsValid (fu_get_next ()) THEN
	RETURN fu_get_next ().function dynamic SetTransObject (i_tr)
ELSE
	RETURN 1
END IF
end function

public subroutine fu_reset_dberror ();// Reset the dbError structure for this and the next object in
// the chain.


// Reset the dbError structure for this 

i_nv_dw_dbi.fnv_reset_dberror ()


// Reset the dbError structure on the next object in the chain,
// if it exists.

IF IsValid (fu_get_next ()) THEN
	this.fu_get_next ().function dynamic fu_reset_dberror ()
END IF
end subroutine

public function boolean fu_accepttext ();// Function stub

RETURN FALSE
end function

public subroutine fu_set_null (long a_l_row_num, string a_s_col_name);// Set the item at the passed row and column to null.

String s_null, s_coltype, s_coltype4
Integer i_null
Date dte_null
Time tme_null
DateTime dt_null


// Get the column type.

s_coltype = Lower (Trim (this.Describe (a_s_col_name + ".coltype")))


// Set the column to null, based on column type.

s_coltype4 = Left (s_coltype, 4)

CHOOSE CASE s_coltype4

	CASE "char"
		SetNull (s_null)
		this.SetItem (a_l_row_num, a_s_col_name, s_null)

	CASE "deci", "numb"
		SetNull (i_null)
		this.SetItem (a_l_row_num, a_s_col_name, i_null)

	CASE "date"
		IF s_coltype = "date" THEN
			SetNull (dte_null)
			this.SetItem (a_l_row_num, a_s_col_name, dte_null)
		ELSE
			SetNull (dt_null)
			this.SetItem (a_l_row_num, a_s_col_name, dt_null)
		END IF

	CASE "time"
		IF s_coltype = "time" THEN
			SetNull (tme_null)
			this.SetItem (a_l_row_num, a_s_col_name, tme_null)
		END IF

END CHOOSE
end subroutine

public function integer fu_set_error_title (string a_s_title);// Set the title that PowerBuilder will display in the error dialog
// box.

IF this.Modify ("datawindow.message.title='" + a_s_title + "'") = "" THEN
	RETURN 1
ELSE
	RETURN -1
END IF
end function

public function integer fu_load_ddlb_code_num (string a_s_table, string a_s_code_col, string a_s_value_col, string a_s_dw_col, nv_transaction a_trans);// Load DropDownListBox column with numeric data value and string
// display value from table and columns passed as arguments.
// Even though this is a datastore and 'non visual', the dw can 
// still be printed, and might need the dropdowns loaded

String s_value, s_select_string
Integer i_code, i_indx

 DECLARE dyn_cursor &
 DYNAMIC CURSOR FOR SQLSA;


// Set up select statement using passed parameters

s_select_string = "  SELECT " + a_s_code_col + ", " + &
											a_s_value_col + " " + &
						"    FROM " + a_s_table + " " + &
						"ORDER BY " + a_s_code_col + " "

 PREPARE SQLSA
    FROM :s_select_string
   USING a_trans;

IF a_trans.SqlCode < 0 THEN
	a_trans.fnv_sql_error ("u_dwa_pt", "fu_load_dw_ddlb_code_num (Prepare)")
	RETURN a_trans.SQLCode
END IF

    OPEN DYNAMIC dyn_cursor;

IF a_trans.SqlCode < 0 THEN
	a_trans.fnv_sql_error ("u_dwa_pt", "fu_load_dw_ddlb_code_num (Open)")
	RETURN a_trans.SQLCode
END IF


// Cursor through table values and load DropDownListBox.

this.ClearValues (a_s_dw_col)

i_indx = 1

DO WHILE a_trans.SQLCode = 0

	   FETCH dyn_cursor
	    INTO :i_code,
				:s_value;

	IF a_trans.SQLCode < 0 THEN
		a_trans.fnv_sql_error ("u_dwa_pt", "fu_load_dw_ddlb_code_num (Fetch)")
		RETURN a_trans.SQLCode
	END IF

	IF a_trans.SQLCode = 100 THEN
		EXIT
	END IF

	this.SetValue (a_s_dw_col, i_indx, s_value + "~t" + String (i_code))

	IF i_indx = 1 THEN
		this.Modify (a_s_dw_col + ".initial = " + "~"" + &
								String (i_code)+"~"")
	END IF

	i_indx ++

LOOP


   CLOSE dyn_cursor;


RETURN 0
end function

public function integer fu_load_dw_ddlb_code_string (string a_s_table, string a_s_code_col, string a_s_value_col, string a_s_dw_col, nv_transaction a_trans);// Load DropDownListBox column with string data value and string
// display value from table and columns passed as arguments.

String s_code, s_value, s_select_string
Integer i_indx

 DECLARE dyn_cursor &
 DYNAMIC CURSOR FOR SQLSA;


// Set up select statement using passed parameters

s_select_string = "  SELECT " + a_s_code_col + ", " + &
											a_s_value_col + " " + &
						"    FROM " + a_s_table + " " + &
						"ORDER BY " + a_s_code_col + " "

 PREPARE SQLSA
    FROM :s_select_string
   USING a_trans;

IF a_trans.SqlCode < 0 THEN
	a_trans.fnv_sql_error ("u_ds_a_pt", "fu_load_dw_ddlb_code_num (Prepare)")
	RETURN a_trans.SQLCode
END IF

    OPEN DYNAMIC dyn_cursor;

IF a_trans.SqlCode < 0 THEN
	a_trans.fnv_sql_error ("u_ds_a_pt", "fu_load_dw_ddlb_code_num (Open)")
	RETURN a_trans.SQLCode
END IF


// Cursor through table values and load DropDownListBox.

this.ClearValues (a_s_dw_col)

i_indx = 1

DO WHILE a_trans.SQLCode = 0

	   FETCH dyn_cursor
	    INTO :s_code,
				:s_value;

	IF a_trans.SQLCode < 0 THEN
		a_trans.fnv_sql_error ("u_ds_a_pt", "fu_load_dw_ddlb_code_num (Fetch)")
		RETURN a_trans.SQLCode
	END IF

	IF a_trans.SQLCode = 100 THEN
		EXIT
	END IF

	this.SetValue (a_s_dw_col, i_indx, s_value + "~t" + s_code)

	IF i_indx = 1 THEN
		this.Modify (a_s_dw_col + ".initial = " + "~"" + &
								s_code + "~"")
	END IF

	i_indx ++

LOOP


   CLOSE dyn_cursor;


RETURN 0
end function

public function string fu_get_error_title ();// Get the title that PowerBuilder will display in the error dialog
// box.

String s_title


// Retrieve the title from the DataWindow and set default if it
// doesn't exist

s_title = this.Describe ("DataWindow.Message.Title")

IF s_title = "!" OR &
	s_title = "?" THEN
	s_title = "DataWindow Error"
END IF


RETURN s_title
end function

public function string fu_get_item_any (long a_l_row_num, string a_s_col_name);// Returns a string representation of the item 
//	at the given row and column.
//	Returns "!" on an illegal column or data type.

String s_expression, s_type, s_coltype, s_item
Char c_quote


s_type = this.Describe (a_s_col_name + ".type")

CHOOSE CASE s_type

	CASE "column"
		s_coltype = Left (this.Describe (a_s_col_name + ".coltype"), 5)
		CHOOSE CASE s_coltype
			CASE "char("
				s_item = this.GetItemString (a_l_row_num, a_s_col_name)
			CASE "numbe", "long", "ulong", "real"
				s_item = String (this.GetItemNumber (a_l_row_num, a_s_col_name))
			CASE "decim"
				s_item = String (this.GetItemDecimal (a_l_row_num, a_s_col_name))
			CASE "datet"
				s_item = String (this.GetItemDateTime (a_l_row_num, a_s_col_name))
			CASE "date"
				s_item = String (Date (DateTime (&
						this.GetItemDate (a_l_row_num, a_s_col_name))))
			CASE "time"
				s_item = String (Time (DateTime (0000-01-01, &
						this.GetItemTime (a_l_row_num, a_s_col_name))))
			CASE ELSE
				s_item = "!"
		END CHOOSE

	CASE "compute"
		s_expression = this.Describe (a_s_col_name + ".expression")
		IF pos (s_expression, "'") > 0 THEN
			c_quote = '"'
		ELSE
			c_quote = "'"
		END IF
		s_item = this.Describe ("evaluate(" + c_quote + &
				s_expression + c_quote + "," + String (a_l_row_num) + ")")

	CASE "text"
		s_item = this.Describe (a_s_col_name + ".text")

	CASE ELSE
		s_item = "!"

END CHOOSE


RETURN s_item
end function

public function string fu_get_item_changed_col_name ();// Return value of instance variable.

RETURN i_s_itemchanged_col_name
end function

public function long fu_get_item_changed_row_num ();// Return value of instance variable.

RETURN i_l_itemchanged_row_num
end function

public function string fu_get_itemchanged_text ();// Return value of instance variable.

RETURN i_s_itemchanged_text
end function

public function string fu_evaluate (string a_s_request, long a_l_row_num);// This function is intended to be a "wrapper" for Describe.
// It will return the result of the Describe "a_s_request" and
// evaluate it if it contains an expression.

Integer i_pos
String s_result, s_expr, s_eval


// Call Describe to describe a_s_request and simply return if it
// returns "?" or "!".

s_result = this.Describe (a_s_request)

IF s_result = "?" OR &
	s_result = "!" THEN
	RETURN s_result
END IF


// If the returned string contains an expression, try to evaluate it
// and return the evaluated expression, if successful.

i_pos = Pos (s_result, "~t")

IF i_pos > 0 THEN
	s_expr = Mid (s_result, i_pos + 1)
	s_expr = "evaluate(~"" + s_expr + ", " + String (a_l_row_num) + ")"
	s_expr = this.Describe (s_expr)
	IF s_expr <> "!" THEN
		RETURN s_expr
	END IF
END IF


// The string may still contain an expression so try to evaluate it
// and return the evaluated expression, if successful.

s_expr = "evaluate(" + s_result + ", " + String (a_l_row_num) + ")"

s_expr = this.Describe (s_expr)

IF s_expr <> "!" THEN
	RETURN s_expr
END IF


// Return the evaluated result.

RETURN s_result
end function

public function long fu_str_search (string a_s_search, string a_s_search_col_nme);// Function to perform a dwFind on the Column name passed as
// a parameter for the String passed as a parameter (works only
// on strings!).  The function will progressively "strip off"
// characters from the right of the search string until a matching
// row is found.  If the last successful search string is embedded
// in the left of the passed search string then the search will
// start from the last successfully found row (helps speed up the
// search).

String s_find_string
Long l_curr_row_num, l_find_row_num, l_start_row_num, l_row_cnt


// Bug out if this DataWindow has no rows.

l_row_cnt = this.RowCount ()

IF l_row_cnt = 0 THEN
	RETURN 0
END IF


// Convert column number to column name.

IF IsNumber (a_s_search_col_nme) THEN
	a_s_search_col_nme = this.Describe ("#" + a_s_search_col_nme + &
														".Name")
	IF a_s_search_col_nme = "!" OR &
		a_s_search_col_nme = "?" THEN
		RETURN 0
	END IF
END IF


// If the last matched string is embedded in the search string
// (i.e. characters have been added to the last string) and the
// last search was on the same column in the datawindow then
// the last matched row is the start row.

a_s_search = Upper (a_s_search)

IF a_s_search_col_nme = i_s_src_col_nme THEN
	IF Left (a_s_search, Len (i_s_src_string)) = i_s_src_string THEN
		l_start_row_num = i_l_src_row_num
	END IF
END IF


// Continually search, stripping off characters from the left of the
// search string, until a row is located.

DO WHILE Len (a_s_search) > 0
	// Build the search string.  Note that any entered quotes (") must
	// be changed to tilde + quote (~") and any entered tildes (~) must
	// be changed to tilde + tilde (~~).  The f_str_transform function can
	// be used for this but ORDER IS IMPORTANT (i.e., calling the function
	// in the wrong order could change " to ~" and then ~" to ~~"!).
	s_find_string = "Upper (Left (" + a_s_search_col_nme + ", " + &
						 String (Len (a_s_search)) + ")) = ~"" + &
						f_str_transform ( f_str_transform (a_s_search, &
							"~~", "~~~~"), "~"", "~~~"") + "~""
	l_find_row_num = this.Find (s_find_string, l_start_row_num, l_row_cnt)
	IF l_find_row_num < 0 THEN
		RETURN -1
	END IF
	IF l_find_row_num > 0 THEN
		EXIT
	END IF
	a_s_search = Left (a_s_search, Len (a_s_search) - 1)
LOOP


IF l_find_row_num = 0 THEN
	l_find_row_num = 1
END IF


// Scroll to the found row, if it is not the current row, and select
// only the found row if selection is indicated.

l_curr_row_num = GetSelectedRow (0)

// Save the search string and row and column number and pass back
// the length of the find string (hint: this could be used to
// highlight the 'bad' characters using a SelectText).

i_l_src_row_num = l_find_row_num

i_s_src_col_nme = a_s_search_col_nme

i_s_src_string = a_s_search

RETURN Len (a_s_search)
end function

public function integer fu_set_item_any (long a_l_row_num, string a_s_col_name, string a_s_item);// Set the given row and column with the appropriate data type given 
//	a string representation.

Integer i_rc
String s_expression, s_type, s_coltype
Char c_quote


s_type = this.Describe (a_s_col_name + ".type")

CHOOSE CASE s_type

	CASE "column"

		s_coltype = Left (this.Describe (a_s_col_name + ".coltype"), 5)

		CHOOSE CASE s_coltype

			CASE "char("
				i_rc = this.SetItem (a_l_row_num, a_s_col_name, a_s_item)

			CASE "numbe", "long", "ulong", "real"
				IF IsNumber (a_s_item) THEN
					IF Pos (a_s_item, ".") > 0 OR &
						Pos (a_s_item, "e") > 0 OR &
						Pos (a_s_item, "E") > 0 THEN // float
						i_rc = this.SetItem (a_l_row_num, a_s_col_name, &
								Double (a_s_item))
					ELSE // integer -> use long to avoid loss of precision
						i_rc = this.SetItem (a_l_row_num, a_s_col_name, &
								Long (a_s_item))
					END IF
				ELSE
					i_rc = -1
				END IF

			CASE "decim"
				IF IsNumber (a_s_item) THEN
					i_rc = this.SetItem (a_l_row_num, a_s_col_name, &
							Dec (a_s_item))
				ELSE
					i_rc = -1
				END IF

			CASE "datet"
				IF f_IsDateTime (a_s_item) THEN
					i_rc = this.SetItem (a_l_row_num, a_s_col_name, &
							f_DateTime (a_s_item))
				ELSE
					i_rc = -1
				END IF

			CASE "date"
				IF IsDate (a_s_item) THEN
					i_rc = this.SetItem (a_l_row_num, a_s_col_name, &
							Date (a_s_item))
				ELSE
					i_rc = -1
				END IF

			CASE "time"
				IF IsTime (a_s_item) THEN
					i_rc = this.SetItem (a_l_row_num, a_s_col_name, &
							Time (a_s_item))
				ELSE
					i_rc = -1
				END IF

			CASE ELSE
				a_s_item = ""

		END CHOOSE

	CASE "text"
		IF Pos (a_s_item, "'") > 0 THEN
			c_quote = '"'
		ELSE
			c_quote = "'"
		END IF
		IF Len (this.Modify (a_s_col_name + ".text=" + &
				c_quote + a_s_item + c_quote)) > 0 THEN
			i_rc = -1
		END IF

	CASE ELSE
		i_rc = -1

END CHOOSE


RETURN i_rc
end function

public function integer fu_display_validation_msg (long a_l_row_num, string a_s_col_name, string a_s_default_msg, string a_s_title);// Display the validation message for the passed column (name) and
// row.  If the first character of the validation message is '&' then
// the message is assumed to be a message id and it is passed to the
// message manager.

String s_msg
Integer i_rc


// Retrieve and evaluate the validation message.

s_msg = this.fu_evaluate (a_s_col_name + ".ValidationMsg", a_l_row_num)

IF s_msg = "?" THEN
	s_msg = Trim (a_s_default_msg)
END IF


// The message itself is a message id if the first character is '&'.

IF Left (s_msg, 1) = "&" THEN
	i_rc = g_nv_msg_mgr.fnv_process_msg ("pt", Mid (s_msg, 2), &
														a_s_col_name, &
														a_s_title, 0, 0)
ELSE
	i_rc = g_nv_msg_mgr.fnv_process_msg ("pt", "Validation Error", &
														s_msg, &
														a_s_title, 0, 0)
END IF

RETURN i_rc
end function

public function integer fu_dw_printpreview ();// Open the print preview response window for the DataWindow.

str_pass str_pass


// Open the PrintPreview response window and return the doubleparm.

str_pass.po [1] = this

message.fnv_set_str_pass (str_pass)

Open (w_dw_printpreview)

str_pass = message.fnv_get_str_pass ()

message.fnv_clear_str_pass ()

RETURN str_pass.d [1]
end function

public function boolean fu_check_required ();//Function Stub		

Return False
end function

on nv_dsa_pt.create
call datastore::create
TriggerEvent( this, "constructor" )
end on

on nv_dsa_pt.destroy
call datastore::destroy
TriggerEvent( this, "destructor" )
end on

event constructor;// Set transaction default.

i_tr = SQLCA


// Create the default database interface object and tell it
// who its parent is.

nv_dsa ds_this


// Create and verify the DataWindow database interface user object

i_nv_dw_dbi = CREATE nv_dw_dbi

IF NOT IsValid (i_nv_dw_dbi) THEN
	g_nv_msg_mgr.fnv_process_msg ("pt", "DBI Create Error", "", "", 0, 0)
	RETURN
END IF


// Tell the user object who its parent is (there is no parent
// attribute or function of a non-visual user object).

ds_this = this

i_nv_dw_dbi.fnv_set_parent (ds_this)
end event

event dberror;// Call the event processor on the DataWindow database interface object.

RETURN (fu_get_nv_dw_dbi ().fnv_event_dberror (sqldbcode, sqlerrtext, &
	sqlsyntax, buffer, row))
end event

event destructor;// Cancel retrieve if in progress.

this.DBCancel ()


// Destroy database interface non-visual user object.

IF IsValid (i_nv_dw_dbi) THEN
	DESTROY i_nv_dw_dbi
END IF
end event

event itemchanged;// Post the standard event for processing after the item is accepted.

i_l_itemchanged_row_num = row

i_s_itemchanged_col_name = this.GetColumnName ()

i_s_itemchanged_text = this.GetText ()

this.PostEvent ("ue_postitemchanged")
end event

event retrieveend;// Call the event processor on the database interface object.

this.fu_get_nv_dw_dbi ().fnv_event_retrieveend ()

end event

event retrievestart;// Reset the dberror structure in the DataWindow database interface object.

this.fu_get_nv_dw_dbi ().fnv_reset_dberror ()

end event

