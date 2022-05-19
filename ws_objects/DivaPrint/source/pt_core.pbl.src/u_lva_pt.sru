$PBExportHeader$u_lva_pt.sru
$PBExportComments$Ancêtre des ListView
forward
global type u_lva_pt from listview
end type
end forward

global type u_lva_pt from listview
int Width=490
int Height=357
int TabOrder=1
long LargePictureMaskColor=553648127
long SmallPictureMaskColor=553648127
long StatePictureMaskColor=536870912
long BackColor=16777215
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
event type integer ue_chg_listview ( string a_s_new_view )
event ue_edit_item ( )
event ue_delete ( )
event type integer ue_show_header ( string a_s_header )
event type integer ue_sort ( string a_s_sort_order )
end type
global u_lva_pt u_lva_pt

type variables
PROTECTED:

boolean	i_b_enable_ext_sel = TRUE 	// Enable Extended Selection
boolean	 i_b_enable_delete	= TRUE 	// Enable item deletion
boolean 	i_b_enable_edit = FALSE	// Enable label editing 
boolean 	i_b_confirm_on_delete  = FALSE // Confirm all deletes
boolean	i_b_updates		// Have updates been done
boolean	i_b_show_header = TRUE	// report header
string	i_s_microhelp		// Default microhelp for object focus
string	i_s_helpkey		// Default key into help file
alignment  i_e_label_align = Left!	// label alignment for report view

nv_ds_udi	i_ds		// DataStore for report style
integer		i_i_col_cnt		// column count for report style
string		i_s_col_name[]	// column names for report style
string		i_s_col_type[]
integer		i_i_col_width[]			
string		i_s_label_col
string		i_s_picture_col

boolean		i_b_sort_enabled = TRUE 	// Enable Sorting on labels
string		i_s_sort_order	// Current Sort Order
m_lva_rmb	i_m_rmb




end variables

forward prototypes
public function integer fu_add_columns ()
public function integer fu_delete_item (integer a_i_indx)
public function integer fu_build_keys (any a_any_keys[], ref string a_s_expression)
public function integer fu_generate_keys (string a_s_expression)
public function integer fu_get_row_for_item (integer a_i_index)
public function boolean fu_get_confirm_on_delete()
public function integer fu_get_large_picture_index (string a_s_large_picture)
public function integer fu_get_small_picture_index (string a_s_small_picture)
public function integer fu_get_statepicture_index (string a_s_statepicture)
public function boolean fu_get_enable_delete()
public function boolean fu_get_enable_edit()
public function boolean fu_get_enable_ext_selection()
public function string fu_get_microhelp ()
public function string fu_get_helpkey ()
public function integer fu_set_confirm_on_delete(boolean a_b_confirm)
public function integer fu_set_sort_on_label (boolean a_b_sort)
public function integer fu_set_enable_delete(boolean a_b_delete)
public function integer fu_set_enable_edit(boolean a_b_edit)
public function integer fu_set_enable_ext_selection(boolean a_b_ext_sel)
public subroutine fu_set_microhelp (string a_s_microhelp)
public subroutine fu_set_helpkey (string a_s_helpkey)
private function integer fu_parse_label (string a_s_label)
public function integer fu_set_alignment (alignment a_e_label_align)
public function alignment fu_get_alignment ()
public function integer fu_refresh ()
public function boolean fu_update ()
public function integer fu_get_key_for_item (integer a_i_item)
public function integer fu_set_update_performed (boolean a_b_update)
public function boolean fu_get_update_performed ()
private function boolean fu_do_delete (integer a_i_index)
public function integer fu_set_ds (nv_ds_udi a_ds_name, string a_s_label_col)
public function integer fu_set_ds (nv_ds_udi a_ds_name, string a_s_label_col, string a_s_picture_col)
public function integer fu_set_ds (nv_ds_udi a_ds_name, string a_s_label_col, string a_s_picture_col, any a_any_keys[])
public function integer fu_add_column (string a_s_col_name, alignment a_e_alignment, integer a_i_width)
public function integer fu_set_ds (nv_ds_udi a_ds_name, string a_s_label_col, string a_s_picture_col, any a_any_keys[], any a_any_sort_keys[])
public function integer fu_find_keys (ref string a_s_expression)
public function integer fu_build_item_labels (long a_l_row_nbr, ref string a_s_long_label)
public function integer fu_import_file (integer a_s_file_name)
public function integer fu_add_item (long a_l_row_nbr, string a_s_long_label, string a_s_picture)
public function integer fu_add_item (string a_s_long_label, string a_s_picture)
end prototypes

event ue_chg_listview;
//////////////////////////////////////////////////////////////////////////////
//
//	Event:  	   ue_chg_listview
//
//	Arguments:	   
//	string			a_s_New_View - the desired view for the listview control.
//
//	Returns:  		integer
//					1 - success
//
//	Description:	Change the list view according to the passed parameter.
//
//////////////////////////////////////////////////////////////////////////////

Choose Case a_s_New_View
	Case "ListViewLargeIcon!"
		this.View = ListViewLargeIcon!
	Case "ListViewSmallIcon!"
		this.View = ListViewSmallIcon!
	Case "ListViewList!"
		this.View = ListViewList!
	Case "ListViewReport!"
		this.View = ListViewReport!
End Choose

RETURN 1


end event

event ue_edit_item;integer	index

index = this.SelectedIndex()
this.fu_delete_item(index)
end event

event ue_delete;
//////////////////////////////////////////////////////////////////////////////
//
//	Event:			ue_delete
//
//	(Arguments:		index
//
//	(Returns:  		None)
//
//	Description:	Delete a specific listview item.
//
//////////////////////////////////////////////////////////////////////////////
integer	lvi_index

lvi_index = this.SelectedIndex()
this.fu_delete_item(lvi_index)
end event

event ue_show_header;
//////////////////////////////////////////////////////////////////////////////
//
//	Event:  			ue_header_listview
//
//	(Arguments:		None)
//
//	(Returns:  		None)
//
//	Description:	If appropriate, notify the parent window that this
//						control got focus.
//
//////////////////////////////////////////////////////////////////////////////

this.SetRedraw(FALSE)

CHOOSE CASE a_s_header
	CASE "show!"
		this.showheader = TRUE
	CASE "hide!"
		this.view = ListViewLargeIcon!
		this.showheader = FALSE
		this.view = ListViewReport!
END CHOOSE

this.SetRedraw(TRUE)
RETURN 0
//
end event

event ue_sort;
//////////////////////////////////////////////////////////////////////////////
//
//	Event:  			ue_sort
//
//	(Arguments:		None)
//
//	(Returns:  		None)
//
//
//////////////////////////////////////////////////////////////////////////////

IF i_b_sort_enabled THEN
	IF a_s_sort_order = "descending!" THEN
		this.Sort(descending!)
		i_s_sort_order = "descending!"
	ELSE
		this.Sort(ascending!)
		i_s_sort_order = "ascending!"
	END IF
ELSE
	// do noting - sort is disabled
END IF

RETURN 1
end event

public function integer fu_add_columns ();
//////////////////////////////////////////////////////////////////////////////
//
//	Function:  	   	fu_add_columns	
//
//	Access:  	   	public
//
//	Arguments:		NONE		
//
//	Returns:  		Integer
//					1 -	success
//
//	Description:  	Build the report header for the "Report View" listview style
//
//////////////////////////////////////////////////////////////////////////////
integer		i_indx, i_loop_indx, i_col_cnt
string		s_col_name
nv_ds_udi	ds_report
alignment	e_alignment


ds_report = i_ds
i_col_cnt = Integer(ds_report.Describe("DataWindow.Column.Count"))
e_alignment = this.fu_get_alignment ( )

FOR i_loop_indx = 1 TO i_col_cnt
	s_col_name = ds_report.Describe("#" + String(i_loop_indx) + ".Name")
	IF s_col_name = i_s_picture_col THEN
	ELSE
		i_indx ++
		IF i_indx = 1 THEN
			i_i_col_width[i_indx] = Integer(ds_report.Describe("#" + String(i_loop_indx) + ".Width")) + 100
		ELSE
			i_i_col_width[i_indx] = Integer(ds_report.Describe("#" + String(i_loop_indx) + ".Width"))
		END IF	
		i_s_col_name[i_indx] = s_col_name
		i_s_col_type[i_indx] = ds_report.Describe(i_s_col_name[i_loop_indx] + ".ColType")
		//this.AddColumn(i_s_col_name[i_indx], Left!, i_i_col_width[i_loop_indx])
		this.fu_add_column(i_s_col_name[i_indx], e_alignment, i_i_col_width[i_loop_indx])
	END IF
NEXT
i_i_col_cnt = i_indx
RETURN 0
end function

public function integer fu_delete_item (integer a_i_indx);
//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		fu_delete_item
//
//	Access:  		public
//
//	Arguments:		
//	integer			a_i_indx - The index of the listview item to be deleted.	
//
//	Returns:  		Integer
//					1	success
//
//	Description:	If necessary confirm the delete, delete the associated 
//						datastore record, then the listviewitem.  
//
//////////////////////////////////////////////////////////////////////////////

integer 	i_ret_code
long		l_row_nbr 

// If the user has "confirm on delete" set, ask them if they are sure.
IF (this.fu_get_confirm_on_delete()) THEN
	i_ret_code = g_nv_msg_mgr.fnv_process_msg ("pt", "Confirm delete?", "", "", 0, 0)
	IF i_ret_code = 1 THEN
		this.fu_delete_item(a_i_indx)
	END IF
ELSE
	this.fu_do_delete(a_i_indx)
END IF

RETURN 1


end function

public function integer fu_build_keys (any a_any_keys[], ref string a_s_expression);
//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		fu_build_keys
//
//	Access:  		public
//
//	Arguments:		NONE		
//
//	Returns:  		Integer
//					1	success
//					-1 failure
//
//	Description:	Generate the a unique key for each row of the datastore.
//
//////////////////////////////////////////////////////////////////////////////
String	s_Exp, s_obj[], s_mod, s_work_str
Integer	i_indx, i_key_cnt
Boolean	b_First

s_exp = "expression='"
i_key_cnt = UpperBound(a_any_keys)
FOR i_indx = 1 TO i_key_cnt
   s_Exp = s_Exp + "String(" + a_any_keys[i_indx] + ")"	 
NEXT
a_s_expression = s_exp + "'"
RETURN 1
end function

public function integer fu_generate_keys (string a_s_expression);
//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		fu_generate_keys
//
//	Access:  		public
//
//	Arguments:		
//	string			a_s_expression - The modify string that will be used to
//					append the "key" column to the datastore.		
//
//	Returns:  		Integer
//					1	success
//					-1 failure
//
//	Description:	Generate the a unique key for each row of the datastore.
//
//////////////////////////////////////////////////////////////////////////////
String	s_Exp, s_obj[], s_mod, s_work_str
Integer	i_obj_cnt, i_indx
Boolean	b_First

s_exp = a_s_expression

s_mod = i_ds.Modify("create compute(band=detail x='0' y='0' visible='0' " + &
			 		"height='0' width='0' name= lvi_key " + s_Exp + ")")
if Len (s_mod) > 0 then
	return -1
else
	return 1
end if

end function

public function integer fu_get_row_for_item (integer a_i_index);
//////////////////////////////////////////////////////////////////////////////
//
//	Function:		fu_get_row_for_item  		
//
//	Access:  		public
//
//	Arguments:		
//	integer			a_i_index - index of the listview item	
//
//	Returns:  		Integer
//					 >1 - The row number of the datastore row
//					 0 datatore row not found
//					-1 failure
//
//	Description:  	Retrieve the row in number in the datastore associated
//					with the listview item.
//
//////////////////////////////////////////////////////////////////////////////
string 			s_row_key, s_exp
long			l_row_max, l_ds_row
listviewitem	lvi_item

this.GetItem (a_i_index, lvi_item)
s_row_key =  lvi_item.data


l_row_max = i_ds.RowCount()
s_exp = "lvi_key = '" + s_row_key +"'"
l_ds_row = i_ds.Find(s_exp, 1,l_row_max)
				
CHOOSE CASE l_ds_row 
	CASE IS < 0
		RETURN -1
	CASE 0
		RETURN 0
	CASE IS > 1
		RETURN l_ds_row
	CASE ELSE				// In case we get a NULL returned from FIND
		RETURN -1
END CHOOSE

RETURN -1
		  
end function

public function boolean fu_get_confirm_on_delete()
//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		fu_get_confirm_on_delete
//
//	Access:  		public
//
//	Arguments:		NONE
//
//	Returns:  		Boolean
//
//	Description:	Return the value of instance variable.
//
/////////////////////////////////////////////////////////////////////////////

RETURN i_b_confirm_on_delete

end function

public function integer fu_get_large_picture_index (string a_s_large_picture);
//////////////////////////////////////////////////////////////////////////////
//
//	Function:  	   fu_get_large_picture_index	
//
//	Access:  	   public
//
//	Arguments:		
//	string		   a_s_large_picture - String containing name of large picture
//
//
//	Returns:  		Integer
//				    1	success
//
//	Description:	Check for the picure in the array of large pictures.  If
//					it is not found, add it to the end of the array.  
//
//////////////////////////////////////////////////////////////////////////////
Integer i_indx, i_picture_max

i_picture_max = UpperBound(this.largepicturename)
	
IF i_picture_max = 0 THEN
	RETURN this.AddLargePicture(a_s_large_picture)
ELSE	
	FOR i_indx = 1 TO i_picture_max
		IF this.largepicturename[i_indx] = a_s_large_picture THEN
			RETURN i_indx
		END IF
	NEXT	
	RETURN this.AddLargePicture(a_s_large_picture)
END IF
end function

public function integer fu_get_small_picture_index (string a_s_small_picture);
//////////////////////////////////////////////////////////////////////////////
//
//	Function:  	   fu_get_small_picture_index	
//
//	Access:  		public
//
//	Arguments:		
//	string			a_s_small_picture
//	
//
//	Returns:  		Integer
//					1 - success
//
//	Description:  	Get picture passed as an argument.  If it exists, return
// 					its index, otherwise create it.
//
//////////////////////////////////////////////////////////////////////////////
Integer i_indx, i_picture_max

i_picture_max = UpperBound(this.smallpicturename)
	
IF i_picture_max = 0 THEN
	RETURN this.AddSmallPicture(a_s_small_picture)
ELSE	
	FOR i_indx = 1 TO i_picture_max
		IF this.smallpicturename[i_indx] = a_s_small_picture THEN
			RETURN i_indx
		END IF
	NEXT	
	RETURN this.AddSmallPicture(a_s_small_picture)
END IF
end function

public function integer fu_get_statepicture_index (string a_s_statepicture);
//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		fu_get_statepicture_index
//
//	Access:  		public
//
//	Arguments:		
//	string 			a_s_statepicture
//	
//	Returns:  		Integer
//					1 -	success
//
//	Description:  	Get picture passed as an argument.  If it exists, return
// 					its index, otherwise create it.
//
//////////////////////////////////////////////////////////////////////////////
Integer i_indx

FOR i_indx = 1 TO UpperBound(this.statepicturename)
	IF this.statepicturename[i_indx] = a_s_statepicture THEN
		RETURN i_indx
	END IF
NEXT	

RETURN this.AddStatePicture(a_s_statepicture)
end function

public function boolean fu_get_enable_delete();
//////////////////////////////////////////////////////////////////////////////
//
//	Function:		fu_get_enable_delete()  		
//
//	Access:  		public
//
//	Arguments:		NONE		
//
//	Returns:  		Boolean - Value of i_b_enable_delete
//
//	Description:	Return Value of Instance Variable	  
//
///////////////////////////////////////////////////////////////////////////
RETURN i_b_enable_delete

END FUNCTION

public function boolean fu_get_enable_edit();
//////////////////////////////////////////////////////////////////////////////
//
//	Function:		fu_get_enable_edit()  		
//
//	Access:  		public
//
//	Arguments:		NONE		
//
//	Returns:  		Boolean - Value of i_b_enable_edit
//
//	Description:	Return Value of Instance Variable	  
//
///////////////////////////////////////////////////////////////////////////
RETURN i_b_enable_edit

END FUNCTION

public function boolean fu_get_enable_ext_selection();
//////////////////////////////////////////////////////////////////////////////
//
//	Function:		fu_get_enable_ext_selection()  		
//
//	Access:  		public
//
//	Arguments:		NONE		
//
//	Returns:  		Boolean - Value of i_b_enable_ext_sel
//
//	Description:	Return Value of Instance Variable	  
//
///////////////////////////////////////////////////////////////////////////
RETURN i_b_enable_ext_sel

END FUNCTION

public function string fu_get_microhelp ();
//////////////////////////////////////////////////////////////////////////////
//
//	Function:		fu_get_microhelp  		
//
//	Access:  		public
//
//	Arguments:		NONE
//
//	Returns:  		String
//					i_s_microhelp
//
//	Description:	Return value of instance variable  
//
//////////////////////////////////////////////////////////////////////////////

RETURN i_s_microhelp
end function

public function string fu_get_helpkey ();
//////////////////////////////////////////////////////////////////////////////
//
//	Function:		fu_get_helpkey  		
//
//	Access:  		public
//
//	Arguments:		NONE		
//
//	Returns:  		String
//					i_s_helpkey
//
//	Description:  	Return value of instance variable
//
//////////////////////////////////////////////////////////////////////////////

RETURN i_s_helpkey
end function

public function integer fu_set_confirm_on_delete(boolean a_b_confirm)
//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		fu_set_confirm_on_delete
//
//	Access:  		public
//
//	Arguments:		NONE
//	boolean			a_b_confirm

//	Returns:  		Integer
//					 1	success
//
//	Description:	Set the value of instance variable.
//
/////////////////////////////////////////////////////////////////////////////

i_b_confirm_on_delete = a_b_confirm
RETURN 1
end function

public function integer fu_set_sort_on_label (boolean a_b_sort);
//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		fu_set_sort_on_label
//
//	Access:  		public
//
//	Arguments:		
//	boolean			a_b_sort -  TRUE - Enables sorting on labels.
//										FALSE - The listview can not be sorted.
//	
//
//////////////////////////////////////////////////////////////////////////////

i_b_sort_enabled = a_b_sort
i_s_sort_order = "ascending!"

RETURN 0
end function

public function integer fu_set_enable_delete(boolean a_b_delete)
//////////////////////////////////////////////////////////////////////////////
//
//	Function:		fu_set_enable_delete()  		
//
//	Access:  		public
//
//	Arguments:		
//	boolean			a_b_delete - Set this to i_b_enable_delete.		
//
//	Returns:  		Integer
//					1 - Sucess
//
//	Description:	Set Value of Instance Variable	  
//
///////////////////////////////////////////////////////////////////////////
i_b_enable_delete = a_b_delete
RETURN 1

END FUNCTION

public function integer fu_set_enable_edit(boolean a_b_edit)
//////////////////////////////////////////////////////////////////////////////
//
//	Function:		fu_set_enable_edit()  		
//
//	Access:  		public
//
//	Arguments:		
//	boolean			a_b_edit - Set this to i_b_enable_edit.		
//
//	Returns:  		Integer
//					1 - Sucess
//
//	Description:	Set Value of Instance Variable	  
//
///////////////////////////////////////////////////////////////////////////
i_b_enable_edit = a_b_edit
RETURN 1

END FUNCTION

public function integer fu_set_enable_ext_selection(boolean a_b_ext_sel)
//////////////////////////////////////////////////////////////////////////////
//
//	Function:		fu_set_enable_ext_selection()  		
//
//	Access:  		public
//
//	Arguments:		
//	boolean			a_b_ext_sel - Set this to i_b_enable_ext_sel.		
//
//	Returns:  		Integer
//					1 - Sucess
//
//	Description:	Set Value of Instance Variable	  
//
///////////////////////////////////////////////////////////////////////////
i_b_enable_ext_sel = a_b_ext_sel
RETURN 1

END FUNCTION

public subroutine fu_set_microhelp (string a_s_microhelp);

//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		fu_set_microhelp
//
//	Access:  		public
//
//	Arguments:		
//	string			a_s_microhelp - The microhelp string	
//
//	Returns:  		Integer
//					1	success
//
//	Description:	Set the microhelp instance variable.  
//
//////////////////////////////////////////////////////////////////////////////
i_s_microhelp = a_s_microhelp
end subroutine

public subroutine fu_set_helpkey (string a_s_helpkey);
//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		fu_set_helpkey
//
//	Access:  		public
//
//	Arguments:		
//	string			a_s_helpkey
//	
//
//	Returns:  		Integer
//					1	success
//
//	Description:  	Set the microhelp instance variable.
//					
//////////////////////////////////////////////////////////////////////////////
i_s_helpkey = a_s_helpkey
end subroutine

private function integer fu_parse_label (string a_s_label);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		fu_parse_label
//
//	Access:  		private
//
//	Arguments:		
//	string			a_s_label - Label to be parsed.
//	
//
//	Returns:  		Integer
//						1	success
//
//	Description:	This function is called by fu_add_item, only if fu_add_item
//						has been called before columns have been added to the 
//						listview.  This necessary in case the listview control
//						control comes in report view.  Without adding columns before
//						adding listview items, the report would be empty.
//
//////////////////////////////////////////////////////////////////////////////

long		l_stop_pos, l_start_pos
integer 	i_col_cnt, i_col_indx

i_col_cnt = 0
l_stop_pos = 1
l_start_pos = 1
DO UNTIL (l_stop_pos = 0)
	l_stop_pos = Pos(a_s_label, "~t", l_start_pos)
	i_col_cnt ++
	l_start_pos = l_stop_pos + 1
LOOP

FOR i_col_indx= 1 TO i_col_cnt
	i_i_col_cnt = i_col_indx
	this.AddColumn("Column " + String(i_col_indx), fu_get_alignment(), 400)
NEXT

RETURN 1
end function

public function integer fu_set_alignment (alignment a_e_label_align);
//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		fu_set_alignment
//
//	Access:  		public
//
//	Arguments:		
//	alignemnt		a_e_alignment
//	
//
//	Returns:  		Integer
//						 1	success
//
//	Description:  Set the Instance variable
//
//////////////////////////////////////////////////////////////////////////////

i_e_label_align = a_e_label_align

RETURN 1
end function

public function alignment fu_get_alignment ();
//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		fu_get_alignment
//
//	Access:  		public
//
//	Arguments:		NONE		
//	
//
//	Returns:  		alignment - i_e_label_align
//
//	Description:  	Return the Instance variable
//
//////////////////////////////////////////////////////////////////////////////

RETURN i_e_label_align
end function

public function integer fu_refresh ();
//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		fu_refresh
//
//	Access:  		public
//
//	Arguments:		NONE
//	
//
//	Returns:  		Integer
//						1	success
//						-1 No datastore
//
//	Description:	Refresh the ListView from the datastore if a datastore is
//						being used.  This function has no effect if the listview was
//						populated from a source other than the datastore.
//
//////////////////////////////////////////////////////////////////////////////

long 		l_row_cnt
integer	i_row_indx

IF NOT IsValid(i_ds) THEN
	RETURN -1						// listview not using datastore.
END IF

DeleteItems()						// delete all items in the listview.

l_row_cnt = i_ds.RowCount()

FOR i_row_indx = 1 TO l_row_cnt
	//
NEXT

end function

public function boolean fu_update ();
//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		fu_update
//
//	Access:  		public
//
//	Arguments:		NONE	
//
//	Returns:  		Boolean
//					   TRUE - success
//						FALSE - failure
//
//	Description:	Update the datastore associated with the listview.
//
//////////////////////////////////////////////////////////////////////////////

RETURN i_ds.fu_update()

end function

public function integer fu_get_key_for_item (integer a_i_item);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		fu_get_key_for_item
//
//	Access:  		public
//
//	Arguments:		
//	integer			a_i_item - The index of the item.
//	
//	Description:  Given an item, retrieve the unique for that item.
//
//////////////////////////////////////////////////////////////////////////////

//this.FindItem

RETURN -1
end function

public function integer fu_set_update_performed (boolean a_b_update);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		fu_set_update_performed
//
//	Access:  		public
//
//	Returns:  		Integer
//						 1	success
//
//	Description:  Set the value of the instance variable
//
//////////////////////////////////////////////////////////////////////////////

i_b_updates = a_b_update
RETURN 1
end function

public function boolean fu_get_update_performed ();
//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		fu_get_updates_performed	
//
//	Access:  		public
//
//	Arguments:		NONE		
//	
//
//	Returns:  		Integer
//						 1	success
//
//	Description:	Return the value of the instance variable.  
//
//////////////////////////////////////////////////////////////////////////////

RETURN i_b_updates
end function

private function boolean fu_do_delete (integer a_i_index);
//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		fu_do_delete	
//
//	Access:  		private
//
//	Arguments:		
//	integer			a_index - index of the item to be deleted.
//	
//
//	Returns:  		Integer
//						 1	success
//
//	Description:  
//
//////////////////////////////////////////////////////////////////////////////

long 		l_row_nbr
boolean	b_delete_ok

b_delete_ok = TRUE
// Delete the listview item
IF (this.DeleteItem(a_i_index)) < 0 THEN
	b_delete_ok = FALSE
END IF	
this.fu_set_update_performed(TRUE)

// Delete the row from the datastore.  Update will be committed by fu_update
l_row_nbr = this.fu_get_row_for_item(a_i_index)
IF l_row_nbr > 0 THEN
	IF (i_ds.DeleteRow(l_row_nbr) < 0) THEN
		b_delete_ok = FALSE
	END IF
	b_delete_ok = FALSE
END IF

IF b_delete_ok THEN
	RETURN TRUE
ELSE
	RETURN FALSE
END IF

end function

public function integer fu_set_ds (nv_ds_udi a_ds_name, string a_s_label_col);
//////////////////////////////////////////////////////////////////////////////
//
//	Function:		fu_set_ds	
//
//	Access:  	   public
//
//	Arguments:		
//  nv_ds_udi		a_ds_name - The datastore that will be used for the listview
//	 string			a_s_key_col - The column in the datastore to be used as a label.
//
//	Returns:  		Integer
// 					1 -	success
//
//	Description:	Set the datastore that will be used for the listview.  
//
//////////////////////////////////////////////////////////////////////////////

this.fu_set_ds(a_ds_name, a_s_label_col, " ")


RETURN 1

end function

public function integer fu_set_ds (nv_ds_udi a_ds_name, string a_s_label_col, string a_s_picture_col);
//////////////////////////////////////////////////////////////////////////////
//
//	Function:		fu_set_ds	
//
//	Access:  	   public
//
//	Arguments:		
//  nv_ds_udi		a_ds_name - The datastore that will be used for the listview
//	 string			a_s_key_col - The column in the datastore to be used as a label.
//
//	Returns:  		Integer
// 					1 -	success
//
//	Description:	Set the datastore that will be used for the listview.  
//
//////////////////////////////////////////////////////////////////////////////

string	s_key_cols[]
this.fu_set_ds(a_ds_name, a_s_label_col, a_s_picture_col, s_key_cols)

RETURN 1

end function

public function integer fu_set_ds (nv_ds_udi a_ds_name, string a_s_label_col, string a_s_picture_col, any a_any_keys[]);
//////////////////////////////////////////////////////////////////////////////
//
//	Function:		fu_set_ds	
//
//	Access:  	   public
//
//	Arguments:		
//  nv_ds_udi		a_ds_name - The datastore that will be used for the listview
//	 string			a_s_key_col - The column in the datastore to be used as a label.
//
//	Returns:  		Integer
// 					1 -	success
//
//	Description:	Set the datastore that will be used for the listview.  
//
//////////////////////////////////////////////////////////////////////////////


string	s_sort_keys[]
this.fu_set_ds(a_ds_name, a_s_label_col, a_s_picture_col, a_any_keys[], s_sort_keys)

RETURN 1

end function

public function integer fu_add_column (string a_s_col_name, alignment a_e_alignment, integer a_i_width);
//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		fu_add_column			
//
//	Access:  		public
//
//
//	Description:  
//
//////////////////////////////////////////////////////////////////////////////

this.AddColumn(a_s_col_name, a_e_alignment, a_i_width)

RETURN 1

end function

public function integer fu_set_ds (nv_ds_udi a_ds_name, string a_s_label_col, string a_s_picture_col, any a_any_keys[], any a_any_sort_keys[]);
//////////////////////////////////////////////////////////////////////////////
//
//	Function:		fu_set_ds	
//
//	Access:  	   public
//
//	Arguments:		
//  nv_ds_udi		a_ds_name - The datastore that will be used for the listview
//	 string			a_s_key_col - The column in the datastore to be used as a label.
//
//	Returns:  		Integer
// 					1 -	success
//
//	Description:	Set the datastore that will be used for the listview.  
//
//////////////////////////////////////////////////////////////////////////////

integer i_nbr_keys
string	s_expression

i_ds = a_ds_name
i_s_picture_col = a_s_picture_col
i_s_label_col = a_s_label_col
this.fu_add_columns()

i_nbr_keys = UpperBound(a_any_keys)
IF i_nbr_keys > 0 THEN
	this.fu_build_keys(a_any_keys[], s_expression)			// build key form passed keys
	this.fu_generate_keys(s_expression)
ELSE
	this.fu_find_keys(s_expression)				// find ".key" columns in DW
	this.fu_generate_keys(s_expression)
END IF

RETURN 1

end function

public function integer fu_find_keys (ref string a_s_expression);
//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		fu_find_keys
//
//	Access:  		public
//
//	Arguments:		
//	string			a_s_expression - DataStore Modify String		
//
//	Returns:  		Integer
//					1	success
//					-1 failure
//
//	Description:	Generate the a unique key for each row of the datastore.
//
//////////////////////////////////////////////////////////////////////////////
String	s_Exp, s_obj[], s_mod, s_work_str
Integer	i_obj_cnt, i_indx
Boolean	b_First

s_exp = "expression='"
b_First = True
i_obj_cnt = Integer(i_ds.Describe("DataWindow.column.Count"))

For i_indx = 1 To i_obj_cnt
	If i_ds.Describe("#" + String(i_indx) + ".key") = "yes" Then
		If Not b_First Then
			s_exp = s_exp + " + "
		Else
			b_First = False
		End if
		s_work_str	= i_ds.Describe("#" + String(i_indx) + ".Name")
		s_exp = s_exp + "String(" + s_work_str + ")"
	End if
Next

If b_First Then
	// No key columns were defined
	Return -1
Else
	s_exp = s_exp + "'"
End if
a_s_expression = s_exp


return 1


end function

public function integer fu_build_item_labels (long a_l_row_nbr, ref string a_s_long_label);
//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		fu_build_item_labels
//
//	Access:  		public
//
//	Arguments:		
//	long 				a_l_row_nbr	- The row from the datastore
//	string 			i_s_label_col - The column from the datastore that is desired for the 
//											label column.  It then becomes the short label.
//	ref string 		a_s_short_label - Return the short labels.
//	ref string 		a_s_long_label - Return the long labels.
//
//	Returns:  		Integer
//					1 -	success
//
//	Description:	Build the data attribute for the item for the "Report View" listview style.  A datawindow
// 					is passed as an arugment, and all columns are put in the data attribute.  
//
//////////////////////////////////////////////////////////////////////////////

integer	i_col_indx
string	s_row_col_val, s_col_name, s_work_string

FOR i_col_indx= 1 TO i_i_col_cnt
	
	CHOOSE CASE TRUE
		CASE MID(i_s_col_type[i_col_indx], 1,6) = "number"
			s_row_col_val = String(i_ds.GetItemNumber(a_l_row_nbr, i_col_indx))
		CASE MID(i_s_col_type[i_col_indx], 1,4) = "long"
			s_row_col_val = String(i_ds.GetItemNumber(a_l_row_nbr, i_col_indx))
		CASE MID(i_s_col_type[i_col_indx], 1,5) = "ulong"
			s_row_col_val = String(i_ds.GetItemNumber(a_l_row_nbr, i_col_indx))
		CASE MID(i_s_col_type[i_col_indx], 1,7) = "decimal"
			s_row_col_val = String(i_ds.GetItemDecimal(a_l_row_nbr, i_col_indx))
		CASE MID(i_s_col_type[i_col_indx], 1,4)= "date"
			s_row_col_val = String(i_ds.GetItemDate(a_l_row_nbr, i_col_indx))
		CASE MID(i_s_col_type[i_col_indx], 1,8) = "datetime"
			s_row_col_val = String(i_ds.GetItemDateTime(a_l_row_nbr, i_col_indx))
		CASE MID(i_s_col_type[i_col_indx], 1,4)= "real"
			s_row_col_val = String(i_ds.GetItemNumber(a_l_row_nbr, i_col_indx))
		CASE MID(i_s_col_type[i_col_indx], 1,4) = "char"
			s_row_col_val = String(i_ds.GetItemString(a_l_row_nbr, i_col_indx))
		CASE ELSE
			s_row_col_val = i_ds.GetItemString(a_l_row_nbr, i_col_indx)
	END CHOOSE
	
	IF IsNull(s_row_col_val) THEN
		// do noting - ignore???
	ELSE
		IF i_col_indx =  1 THEN
			s_work_string = s_row_col_val
		ELSE
			s_work_string = s_work_string + "~t" + s_row_col_val
		END IF
	END IF
NEXT 

a_s_long_label = s_work_string

RETURN 0
end function

public function integer fu_import_file (integer a_s_file_name);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		fu_import_file
//
//	Access:  		public
//
//	Arguments:		
//	ARG1				The .ini file.
//	
//
//	Returns:  		Integer
//						 1	success
//
//	Description:  
//
//////////////////////////////////////////////////////////////////////////////

RETURN 1
end function

public function integer fu_add_item (long a_l_row_nbr, string a_s_long_label, string a_s_picture);
//////////////////////////////////////////////////////////////////////////////
//
//	Function:		fu_add_item  		
//
//	Access:  		public
//
//	Arguments:		
//	string 			a_s_short_label - The label used for report view.
//	string 			a_s_long_label - The label used for small, large icon and list views.
//	string 			a_s_small_icon - The icon used for samll icon view.
//	string 			a_s_large_icon - The icon used for large icon view.
//	any 				a_any_key - The key for the item.
//	any 				a_any_data - Any other item for the item.
//
//	Returns:  		Integer
//						1	success
//
//	Description:  	Create the listview item, and insert it in the listview control.
//
//////////////////////////////////////////////////////////////////////////////

ListViewItem	lvi_new, lvi_item
integer			i_indx,i_width
string			s_label
alignment		e_alignment


IF a_s_picture > " " THEN
	i_indx = this.fu_get_small_picture_index (a_s_picture)
	i_indx = this.fu_get_large_picture_index (a_s_picture)
	IF i_indx < 0 THEN
		i_indx = 1
	END IF
ELSE
	a_s_picture = i_ds.GetItemString(a_l_row_nbr, i_s_picture_col)
	i_indx = this.fu_get_small_picture_index (a_s_picture)
	i_indx = this.fu_get_large_picture_index (a_s_picture)
END IF	

IF a_s_long_label > " " THEN
ELSE
	this.fu_build_item_labels (a_l_row_nbr, a_s_long_label)
END IF
// Check to see if columns have been added to the listview

//IF (this.TotalItems() = 0) THEN
IF i_i_col_cnt = 0 THEN
	fu_parse_label(a_s_long_label)
END IF


lvi_new.label = a_s_long_label
//lvi_new.data  = a_s_short_label
//lvi_new.data = a_any_data
lvi_new.pictureindex = i_indx
this.AddItem(lvi_new)


RETURN 1
end function

public function integer fu_add_item (string a_s_long_label, string a_s_picture);
//////////////////////////////////////////////////////////////////////////////
//
//	Function:		fu_add_item  		
//
//	Access:  		public
//
//	Arguments:		
//	string 			a_s_long_label - The label used for small, large icon and list views.
//	string 			a_s_picture - The icon or bitmap to be used for the item.
//
//	Returns:  		Integer
//						1	success
//
//	Description:  	Create the listview item, and insert it in the listview control.
//
//////////////////////////////////////////////////////////////////////////////

ListViewItem	lvi_new, lvi_item
integer			i_indx,i_width
string			s_label
alignment		e_alignment



i_indx = this.fu_get_small_picture_index (a_s_picture)
i_indx = this.fu_get_large_picture_index (a_s_picture)
IF i_indx < 0 THEN
	i_indx = 1
END IF

//IF i_i_col_cnt = 0 THEN
//	fu_parse_label(a_s_long_label)
//END IF


lvi_new.label = a_s_long_label
lvi_new.pictureindex = i_indx
this.AddItem(lvi_new)


RETURN 1
end function

event constructor;
//////////////////////////////////////////////////////////////////////////////
//
//	Event:  			Constructor
//
//	(Arguments:		None)
//
//	(Returns:  		None)
//
//	Description:	Setup default behavior for control.
//
//////////////////////////////////////////////////////////////////////////////


i_m_rmb = CREATE m_lva_rmb
i_m_rmb.fm_set_parent(this)
this.sorttype = Ascending!
this.editlabels = FAlSE

end event

event rightclicked;
//////////////////////////////////////////////////////////////////////////////
//
//	Event:  			rightclicked
//
//	(Arguments:		None)
//
//	(Returns:  		None)
//
//	Description:	If appropriate, notify the parent window that this
//						control got focus.
//
//////////////////////////////////////////////////////////////////////////////
boolean	b_attr[]
string	s_view

CHOOSE CASE this.View
	CASE ListViewReport!
		s_view = "ListViewReport!"
	CASE ListViewLargeIcon!
		s_view = "ListViewLargeIcon!"
		CASE ListViewSmallIcon!
		s_view = "ListViewSmallIcon!"
		CASE ListViewList!
		s_view = "ListViewList!"
END CHOOSE

// Should the Show Header item be enabled.
IF this.View = ListViewReport! THEN
	b_attr[2] = TRUE
ELSE
	b_attr[2] = FALSE
END IF

// Should the Show Header item be checked.
IF this.ShowHeader THEN
	b_attr[1] = TRUE
ELSE
	b_attr[1] = FALSE
END IF
//
i_m_rmb.fm_set_attributes(b_attr[], s_view)
i_m_rmb.m_properties.PopMenu(g_w_frame.PointerX(), 	g_w_frame.PointerY())



end event

event columnclick;
//////////////////////////////////////////////////////////////////////////////
//
//	Event:  			ColumnClick
//
//	Arguments:		column
//
//	(Returns:  		None)
//
//	Description:	If appropriate, notify the parent window that this
//						control got focus.
//
//////////////////////////////////////////////////////////////////////////////


IF i_b_sort_enabled THEN
	IF i_s_sort_order = "ascending!" THEN
		this.Sort(descending!,column)
		i_s_sort_order = "descending!"
	ELSE
		this.Sort(ascending!,column)
		i_s_sort_order = "ascending!"
	END IF
ELSE
	// do noting - sort is disabled
END IF

end event

event doubleclicked;
//////////////////////////////////////////////////////////////////////////////
//
//	Event:  			DoubleClicked
//
//	Arguments:		index - The index of the item that was clicked.
//
//	(Returns:  		None)
//
//
//////////////////////////////////////////////////////////////////////////////

end event

event destructor;
//////////////////////////////////////////////////////////////////////////////
//
//	Event:  			Destructor
//
//	(Arguments:		None)
//
//	(Returns:  		None)
//
//	Description:	Setup default behavior for control.
//
//////////////////////////////////////////////////////////////////////////////

DESTROY i_m_rmb


end event

