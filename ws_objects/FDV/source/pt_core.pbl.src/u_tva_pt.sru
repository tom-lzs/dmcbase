$PBExportHeader$u_tva_pt.sru
$PBExportComments$Ancêtre des Treeview
forward
global type u_tva_pt from treeview
end type
end forward

shared variables

end variables

global type u_tva_pt from treeview
int Width=480
int Height=372
boolean DisableDragDrop=false
boolean LinesAtRoot=true
long PictureMaskColor=553648127
long StatePictureMaskColor=553648127
long BackColor=16777215
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
event we_nchittest pbm_nchittest
event type long ue_populate_root ( )
event type long ue_move_tree ( ref treeview a_tv_source,  ref treeviewitem a_tvi_source,  ref treeviewitem a_tvi_target )
event type integer ue_pre_move_tree ( ref treeview a_tv_source,  ref treeviewitem a_tvi_source,  ref treeviewitem a_tvi_target )
event ue_post_move_tree ( treeview a_tv_source,  treeviewitem a_tvi_source,  treeviewitem a_tvi_target )
event type integer ue_pre_dragdrop ( ref dragobject a_do_source,  long a_l_handle )
event ue_post_dragdrop ( dragobject a_do_source,  long a_l_handle )
event type long ue_dragdrop_pt ( ref dragobject a_do_source,  long a_l_handle )
event type long ue_copy_tree ( ref treeview a_tv_source,  ref treeviewitem a_tvi_source,  ref treeviewitem a_tvi_target )
event type integer ue_pre_copy_tree ( ref treeview a_tv_source,  ref treeviewitem a_tvi_source,  ref treeviewitem a_tvi_target )
event ue_post_copy_tree ( treeview a_tv_source,  treeviewitem a_tvi_source,  treeviewitem a_tvi_target )
event type integer ue_pre_add ( long a_l_handle_parent,  ref treeviewitem a_tvi )
event ue_post_add ( treeviewitem a_tvi )
event type integer ue_pre_delete ( ref treeviewitem a_tvi )
event ue_post_delete ( treeviewitem a_tvi )
end type
global u_tva_pt u_tva_pt

type variables
PROTECTED:

String i_s_microhelp		// Default MicroHelp for Object focus
String i_s_helpkey		// Default key into Help file

String i_s_attr_classname	// Classname of extended attribute object

Boolean i_b_level_lock	// A move/copy operation may not change an item's leve

any i_any_root_key[]	// Key(s) used to populate the root datastore

stru_ds i_stru_ds_root	// Datastore for populating root of TreeView
stru_ds i_stru_ds_level[]	// Datastores for populating each level of TreeView

end variables

forward prototypes
public subroutine fu_set_microhelp (string a_s_microhelp)
public subroutine fu_set_helpkey (string a_s_helpkey)
public function string fu_get_microhelp ()
public function string fu_get_helpkey ()
public function integer fu_get_picture_index (string a_s_picture)
public function integer fu_get_statepicture_index (string a_s_statepicture)
public function integer fu_print (string a_s_job_title, integer a_i_xloc, integer a_i_yloc, integer a_i_width, integer a_i_height)
public subroutine fu_sort_all (grsorttype a_e_sortorder)
public subroutine fu_sort_all ()
public subroutine fu_set_attr_classname (string a_s_attr_classname)
public function string fu_get_attr_classname ()
public function long fu_add_item (long a_l_parent, long a_l_prev_handle, string a_s_picture, string a_s_selected_picture, boolean a_b_expandable, string a_s_label, any a_any_key[], any a_any_data[], any a_any_sortkey[])
public function integer fu_get_ext_attr (long a_l_handle, ref any a_any_key[], ref any a_any_data[], ref any a_any_sortkey[])
public function integer fu_set_ext_attr (long a_l_handle, any a_any_key[], any a_any_data[], any a_any_sortkey[])
public subroutine fu_del_ext_attr (treeviewitem a_tvi)
public function integer fu_get_ext_attr (treeviewitem a_tvi, ref any a_any_key[], ref any a_any_data[], ref any a_any_sortkey[])
public subroutine fu_del_ext_attr (long a_l_handle)
public function integer fu_set_ext_attr (ref treeviewitem a_tvi, any a_any_key[], any a_any_data[], any a_any_sortkey[])
protected function integer fu_extract_key_cols (string a_s_data_object, ref string a_s_key_col[], ref string a_s_key_type[])
public function boolean fu_get_level_lock ()
public subroutine fu_set_level_lock (boolean a_b_level_lock)
protected function long fu_copy_tree (ref treeview a_tv_source, ref treeviewitem a_tvi_source, ref treeviewitem a_tvi_target)
public function long fu_get_root_key (ref any a_any_root_key[])
public subroutine fu_set_root_key (any a_any_root_key[])
protected function long fu_populate_ds (long a_l_parent, any a_any_key[], ref stru_ds a_stru_ds)
public function integer fu_delete_item (long a_l_handle)
public subroutine fu_reset ()
public subroutine fu_clear ()
public function integer fu_set_ds_level (integer a_i_level, transaction a_tr_object, string a_s_data_object, string a_s_picture_col, string a_s_selected_picture_col, string a_s_label_col, string a_s_key_col[], string a_s_key_type[], string a_s_data_col[], string a_s_sortkey_col[])
public function integer fu_set_ds_root (transaction a_tr_object, string a_s_data_object, string a_s_picture_col, string a_s_selected_picture_col, string a_s_label_col, string a_s_key_col[], string a_s_key_type[], string a_s_data_col[], string a_s_sortkey_col[])
public function integer fu_set_ds_level (integer a_i_level, transaction a_tr_object, string a_s_data_object, string a_s_picture_col, string a_s_selected_picture_col, string a_s_label_col, string a_s_data_col[], string a_s_sortkey_col[])
public function integer fu_set_ds_root (transaction a_tr_object, string a_s_data_object, string a_s_picture_col, string a_s_selected_picture_col, string a_s_label_col, string a_s_data_col[], string a_s_sortkey_col[])
public function integer fu_set_ds_level (integer a_i_level, transaction a_tr_object, string a_s_data_object, string a_s_picture_col, string a_s_selected_picture_col, string a_s_label_col, string a_s_data_col[])
public function integer fu_set_ds_level (integer a_i_level, transaction a_tr_object, string a_s_data_object, string a_s_picture_col, string a_s_selected_picture_col, string a_s_label_col)
public function integer fu_set_ds_root (transaction a_tr_object, string a_s_data_object, string a_s_picture_col, string a_s_selected_picture_col, string a_s_label_col, string a_s_data_col[])
public function integer fu_set_ds_root (transaction a_tr_object, string a_s_data_object, string a_s_picture_col, string a_s_selected_picture_col, string a_s_label_col)
protected function long fu_populate_ds_level (ref treeviewitem a_tvi_current)
protected function long fu_populate_ds_root ()
public function integer deletepictures ()
public function integer deletestatepictures ()
public function integer deletepicture (integer a_i_indx)
public function integer deletestatepicture (integer a_i_indx)
end prototypes

event we_nchittest;// Set MicroHelp.

IF IsValid (g_w_frame) THEN
	g_w_frame.fw_setmicrohelp (this.fu_get_microhelp ())
END IF
end event

event ue_populate_root;// If a datastore has been defined for the root then use it to
// populate the control.
//
// Returns:
//		  n	number of items added
//		 -1	no root datastore defined
//		-99	unable to retrieve into datastore with root keys
//		 -n	error retrieving data into datastore


// Determine whether a datastore is defined for the root.

IF NOT IsValid(i_stru_ds_root.ds_level) THEN
	RETURN -1
END IF


// Populate the item using the datastore for the level.

RETURN this.fu_populate_ds_root()
end event

event ue_move_tree;// Insert dragged (source) item beneath (as a child of) the
// target item and delete the source item.
//
// Returns:
//		  n	handle of beneath which tree was copied
//		 -1	error inserting TreeViewItem
//		 -n	return value from ue_pre_move_tree

Long l_rc



// Trigger the pre-move event to validate the move operation.

l_rc = this.EVENT ue_pre_move_tree(a_tv_source, a_tvi_source, a_tvi_target)

IF l_rc < 0 THEN
	RETURN l_rc
END IF


// Insert the new tree and delete the old.

l_rc = this.fu_copy_tree(a_tv_source, a_tvi_source, a_tvi_target)

IF l_rc < 0 THEN
	RETURN l_rc
END IF

a_tv_source.DeleteItem(a_tvi_source.itemhandle)


// Success -- post the post-move event.

this.EVENT POST ue_post_move_tree(a_tv_source, a_tvi_source, a_tvi_target)

RETURN l_rc
end event

event ue_pre_move_tree;// Determine the validity of the operation.
//
// Returns:
//		  1	success
//		 -2	move changing levels prohibited by level lock
//		 -3	attempt to move tree onto itself
//		 -4	attempt to move tree to its own parent

Integer i_level
Long l_handle


// A tree may only be moved to an immediately lower level (i.e.,
// a tree's level may not change) if i_b_drag_level_lock is TRUE.

IF i_b_level_lock THEN
	IF IsValid(a_tvi_target) THEN		// there is a target item
		IF a_tvi_target.level <> a_tvi_source.level - 1 THEN
			RETURN -2
		END IF
	ELSE										// dragged to root of TreeView
		IF a_tvi_source.level <> 1 THEN
			RETURN -2
		END IF
	END IF
END IF


// A tree may not be moved to itself or any of its own children.

IF a_tv_source = this AND &
	IsValid(a_tvi_target) THEN			// there is a target item
	i_level = a_tvi_target.level
	l_handle = a_tvi_target.itemhandle
	DO WHILE i_level > a_tvi_source.level
		l_handle = a_tv_source.FindItem(ParentTreeItem!, l_handle)
		i_level --
	LOOP
	IF l_handle = a_tvi_source.itemhandle THEN
		RETURN -3
	END IF
END IF


// An item may not be moved to its own parent as this would be a
// redundant operation.

IF a_tv_source = this THEN
	IF IsValid(a_tvi_target) THEN
		IF a_tvi_source.level = a_tvi_target.level + 1 THEN
			l_handle = a_tv_source.FindItem(ParentTreeItem!, &
													a_tvi_source.itemhandle)
			IF l_handle = a_tvi_target.itemhandle THEN
				RETURN -4
			END IF
		END IF
	ELSE
		IF a_tvi_source.level = 1 THEN
			RETURN -4
		END IF
	END IF
END IF


// Success!

RETURN 1
end event

event ue_dragdrop_pt;// PowerTOOL TreeView drag operation will move (default) or copy
// (CTRL key is down) the dragged tree beneath the target (drop)
// TreeViewItem.
//
// Returns:
//		  n	return value from ue_copy_tree or ue_move_tree
//		 -1	source item is not a TreeView
//		 -2	unable to get source TreeViewItem
//		 -3	unable to get target TreeViewItem

Long l_rc
TreeView tv_source
TreeViewItem tvi_source, tvi_target


// Get the the dragged TreeViewItem and ensure it is a TreeView.

IF a_do_source.TypeOf() <> TreeView! THEN
	RETURN -1
END IF

tv_source = a_do_source


// Get the source and target TreeViewItems.

IF tv_source.GetItem(tv_source.FindItem(CurrentTreeItem!, 0), &
															tvi_source) < 0 THEN
	RETURN -2
END IF

IF a_l_handle > 0 THEN
	IF this.GetItem(a_l_handle, tvi_target) < 0 THEN
		RETURN -3
	END IF
END IF


// Call user event to move or copy the tree.

IF KeyDown(KeyControl!) THEN
	l_rc = this.EVENT ue_copy_tree(tv_source, tvi_source, tvi_target)
ELSE
	l_rc = this.EVENT ue_move_tree(tv_source, tvi_source, tvi_target)
END IF

RETURN l_rc
end event

event ue_copy_tree;// Insert dragged (source) item beneath (as a child of) the
// target item.
//
// Returns:
//		  n	handle of beneath which tree was copied
//		 -1	error inserting TreeViewItem
//		 -n	return value from ue_pre_copy_tree

Long l_rc


// Trigger the pre-copy event to validate the copy operation.

l_rc = this.EVENT ue_pre_copy_tree(a_tv_source, a_tvi_source, a_tvi_target)

IF l_rc < 0 THEN
	RETURN l_rc
END IF


// Insert the new item.

l_rc = this.fu_copy_tree(a_tv_source, a_tvi_source, a_tvi_target)

IF l_rc < 0 THEN
	RETURN l_rc
END IF


// Success -- post the post-copy event.

this.EVENT POST ue_post_copy_tree(a_tv_source, a_tvi_source, a_tvi_target)

RETURN l_rc
end event

event ue_pre_copy_tree;// Determine the validity of the operation.
//
// Returns:
//		  1	success
//		 -2	copy changing levels prohibited by level lock
//		 -3	attempt to copy tree onto itself

Integer i_level
Long l_handle


// A tree may only be copied to an immediately lower level (i.e.,
// a tree's level may not change) if i_b_drag_level_lock is TRUE.

IF i_b_level_lock THEN
	IF IsValid(a_tvi_target) THEN		// there is a target item
		IF a_tvi_target.level <> a_tvi_source.level - 1 THEN
			RETURN -2
		END IF
	ELSE										// dragged to root of TreeView
		IF a_tvi_source.level <> 1 THEN
			RETURN -2
		END IF
	END IF
END IF


// A tree may not be copied to itself or any of its own children.

IF a_tv_source = this AND &
	IsValid(a_tvi_target) THEN			// there is a target item
	i_level = a_tvi_target.level
	l_handle = a_tvi_target.itemhandle
	DO WHILE i_level > a_tvi_source.level
		l_handle = a_tv_source.FindItem(ParentTreeItem!, l_handle)
		i_level --
	LOOP
	IF l_handle = a_tvi_source.itemhandle THEN
		RETURN -3
	END IF
END IF


// Success!

RETURN 1
end event

public subroutine fu_set_microhelp (string a_s_microhelp);//	Set value of instance variable to value passed.

i_s_microhelp = a_s_microhelp
end subroutine

public subroutine fu_set_helpkey (string a_s_helpkey);//	Set value of instance variable to value passed.

i_s_helpkey = a_s_helpkey
end subroutine

public function string fu_get_microhelp ();// Return value of instance variable.

RETURN i_s_microhelp
end function

public function string fu_get_helpkey ();// Return value of instance variable.

RETURN i_s_helpkey
end function

public function integer fu_get_picture_index (string a_s_picture);//	Get the list of available pictures and compare with the picture 
// passed as an argument.  If it exists, return its index, 
// otherwise create it.
//
// Returns:
//		  n	index of picture in picturename property
//		 -1	add of picture failed

Integer i_indx, i_ubound


// Find the picture in the array and return its index it it exists.

i_ubound = UpperBound(this.picturename)

FOR i_indx = 1 TO i_ubound
	IF this.picturename[i_indx] = a_s_picture THEN
		RETURN i_indx
	END IF
NEXT


// Add the picture and add it to the array it the add is successful.

i_indx = this.AddPicture(a_s_picture)

IF i_indx > 0 THEN
	this.picturename[i_indx] = a_s_picture
END IF

RETURN i_indx
end function

public function integer fu_get_statepicture_index (string a_s_statepicture);//	Get the list of available state pictures and compare with
// the state picture passed as an argument.  If it exists,
// return its index, otherwise create it.
//
// Returns:
//		  n	index of picture in statepicturename property
//		 -1	add of statepicture failed

Integer i_indx, i_ubound


// Find the picture in the array and return its index it it exists.

i_ubound = UpperBound(this.statepicturename)

FOR i_indx = 1 TO i_ubound
	IF this.statepicturename[i_indx] = a_s_statepicture THEN
		RETURN i_indx
	END IF
NEXT


// Add the picture and add it to the array it the add is successful.

i_indx = this.AddStatePicture(a_s_statepicture)

IF i_indx > 0 THEN
	this.statepicturename[i_indx] = a_s_statepicture
END IF

RETURN i_indx
end function

public function integer fu_print (string a_s_job_title, integer a_i_xloc, integer a_i_yloc, integer a_i_width, integer a_i_height);// Prints the TreeView Control.  If a_i_width and a_i_height are omitted, the 
// original height and width are used.
//
// Returns:
//		  1	success
//		 -1	no root TreeViewItem found to print

Long l_printjob, l_handle


// Open the print job and print the title.

l_printjob = PrintOpen()

IF l_printjob < 0 THEN
	RETURN l_printjob
END IF

IF a_s_job_title <> "" THEN
	Print(l_printjob, a_s_job_title)
END IF


// Find the first root node in the Treeview and print it.

l_handle = this.FindItem(RootTreeItem!, 0)

IF l_handle < 1 THEN
	RETURN 0
END IF

IF (a_i_width = 0 or a_i_height = 0)  THEN
	this.SetFirstVisible(l_handle)
 	this.Print(l_printjob, a_i_xloc, a_i_yloc)
ELSE
	this.SetFirstVisible(l_handle)
	this.Print(l_printjob, a_i_xloc, a_i_yloc, a_i_width, a_i_height)
END IF	


PrintClose(l_printjob)

RETURN 1
end function

public subroutine fu_sort_all (grsorttype a_e_sortorder);// Sort the entire TreeView (all roots).

Long l_handle
TreeViewItem tvi_current


// Sort the root items.

SetPointer(HourGlass!)

this.Sort(0, a_e_sortorder)


// Sort each root item.

l_handle = this.FindItem(RootTreeItem!, 0)

DO WHILE l_handle > 0
	GetItem(l_handle, tvi_current)
	this.SortAll(l_handle, a_e_sortorder)
	l_handle = this.FindItem(NextTreeItem!, l_handle)
LOOP
end subroutine

public subroutine fu_sort_all ();// Sort TreeView ascending.

this.fu_sort_all(Ascending!)
end subroutine

public subroutine fu_set_attr_classname (string a_s_attr_classname);// Save passed value to instance variable.

i_s_attr_classname = Lower(Trim(a_s_attr_classname))
end subroutine

public function string fu_get_attr_classname ();// Return value of instance variable.

RETURN i_s_attr_classname
end function

public function long fu_add_item (long a_l_parent, long a_l_prev_handle, string a_s_picture, string a_s_selected_picture, boolean a_b_expandable, string a_s_label, any a_any_key[], any a_any_data[], any a_any_sortkey[]);// Insert the TreeViewItem and save the extended attributes.
//
// Returns:
//		  n	handle of the new item
//		 -1	unsuccessful insert
//		 -n	return value from ue_pre_add

Integer i_rc
Long l_handle
TreeViewItem tvi_new


// Create the TreeViewItem to be inserted.

tvi_new.children = a_b_expandable
tvi_new.pictureindex = this.fu_get_picture_index(a_s_picture)
tvi_new.selectedpictureindex = this.fu_get_picture_index(a_s_selected_picture)
tvi_new.label = a_s_label
this.fu_set_ext_attr(tvi_new, a_any_key, a_any_data, a_any_sortkey)


// Trigger the ue_pre_add event to allow the developer to
// terminate the add.

i_rc = this.EVENT ue_pre_add(a_l_parent, tvi_new)

IF i_rc < 0 THEN
	RETURN i_rc
END IF


// Add the item as a child of its parent and after the item it
// should follow, if passed.

IF a_l_prev_handle > 0 THEN
	l_handle = this.InsertItem(a_l_parent, a_l_prev_handle, tvi_new)
ELSE
	l_handle = this.InsertItemSort(a_l_parent, tvi_new)
END IF

IF l_handle < 0 THEN
	RETURN l_handle
END IF


// Post the post-add event and indicate success.

this.EVENT POST ue_post_delete(tvi_new)

RETURN l_handle
end function

public function integer fu_get_ext_attr (long a_l_handle, ref any a_any_key[], ref any a_any_data[], ref any a_any_sortkey[]);// Get the TreeViewItem of the passed handle and call the parent
// function.
//
// Returns:
//		  1	success
//		 -1	no TreeViewItem for handle found
//		 -2	TreeViewItem has no data property
//		 -3	unknown TreeViewItem data property encountered

TreeViewItem tvi_current


// Get the TreeViewItem pointed to by the passed handle.

IF this.GetItem(a_l_handle, tvi_current) < 0 THEN
	RETURN -1
END IF


// Call the parent function.

RETURN this.fu_get_ext_attr(tvi_current, a_any_key, a_any_data, a_any_sortkey)
end function

public function integer fu_set_ext_attr (long a_l_handle, any a_any_key[], any a_any_data[], any a_any_sortkey[]);// Get the TreeViewItem of the passed handle and call the parent
// function.
//
// Returns:
//		  1	success
//		 -1	no TreeViewItem found for handle passed

TreeViewItem tvi_current


// Get the TreeViewItem pointed to by the passed handle.

IF this.GetItem(a_l_handle, tvi_current) < 0 THEN
	RETURN -1
END IF


// Call the parent function.

RETURN this.fu_set_ext_attr(tvi_current, a_any_key, a_any_data, a_any_sortkey)
end function

public subroutine fu_del_ext_attr (treeviewitem a_tvi);// Destroy the extended attributes object associated with the
// current TreeViewItem.

IF ClassName(a_tvi.data) = i_s_attr_classname THEN
	DESTROY a_tvi.data
END IF


end subroutine

public function integer fu_get_ext_attr (treeviewitem a_tvi, ref any a_any_key[], ref any a_any_data[], ref any a_any_sortkey[]);// Return the extended attributes from the object on the TreeViewItem.
//
// Returns:
//		  1	success
//		 -2	TreeViewItem has no data property
//		 -3	unknown TreeViewItem data property encountered

nv_attr lnv_attr


// Get the extended attribute object on the TreeViewItem.

IF ClassName(a_tvi.data) = i_s_attr_classname THEN
	lnv_attr = a_tvi.data
ELSE
	RETURN -3
END IF


// Return the extended attributes to the caller.

lnv_attr.fnv_get_key(a_any_key)
lnv_attr.fnv_get_data(a_any_data)
lnv_attr.fnv_get_sortkey(a_any_sortkey)

RETURN 1
end function

public subroutine fu_del_ext_attr (long a_l_handle);// Get the TreeViewItem of the passed handle and call the parent
// function.

TreeViewItem tvi_current


// Get the associated TreeViewItem.

IF this.GetItem(a_l_handle, tvi_current) < 0 THEN
	RETURN
END IF


// Call the parent function.

this.fu_del_ext_attr(tvi_current)
end subroutine

public function integer fu_set_ext_attr (ref treeviewitem a_tvi, any a_any_key[], any a_any_data[], any a_any_sortkey[]);// Create an attribute object on the TreeViewItem and load the
// extended attributes into it.
//
// Returns:
//		  1	success
//		 -2	unable to create extended attribute object

nv_attr lnv_attr


// Destroy any existing attributes.

this.fu_del_ext_attr(a_tvi)


// Create new extended attribute object on the TreeViewItem and
// load it.

a_tvi.data = CREATE USING i_s_attr_classname

IF ClassName(a_tvi.data) <> i_s_attr_classname THEN
	RETURN -2
END IF

lnv_attr = a_tvi.data

lnv_attr.fnv_set_key(a_any_key)
lnv_attr.fnv_set_data(a_any_data)
lnv_attr.fnv_set_sortkey(a_any_sortkey)


RETURN 1
end function

protected function integer fu_extract_key_cols (string a_s_data_object, ref string a_s_key_col[], ref string a_s_key_type[]);// Store the list of key column names and types from the data object
// into the reference variable arrays.
//
// Returns:
//		  n	number of key columns found
//		 -1	datastore invalid
//		 -3	invalid datawindow column type encountered
//		 -4	timestamp column encountered

String s_col_type
Integer i_indx, i_col_num, i_col_cnt
DataStore ds_local


// Create and initialize the datastore.



ds_local = CREATE datastore

IF NOT IsValid(ds_local) THEN
	RETURN -1
END IF

ds_local.dataobject = a_s_data_object


// Loop through each column of the datastore and extract only those
// columns that are keys.

i_col_cnt = Integer(ds_local.Describe("DataWindow.Column.Count"))

FOR i_col_num = 1 TO i_col_cnt
	IF Lower(ds_local.Describe("#" + String(i_col_num) + ".key")) &
																		<> "yes" THEN
		CONTINUE
	END IF
	i_indx++
	// Get column name from data object . . .
	a_s_key_col[i_indx] = ds_local.Describe &
										("#" + String(i_col_num) + ".name")
	// Derive type from data object . . .
	s_col_type = ds_local.Describe &
										("#" + String(i_col_num) + ".ColType")
	CHOOSE CASE Lower(Left(s_col_type,4))
		CASE "char"
			s_col_type = "string"
		CASE "date"
			IF Lower(s_col_type) = "date" THEN
				s_col_type = "date"
			ELSE
				s_col_type = "datetime"
			END IF
		CASE "deci", "long", "numb", "ulong", "real"
			s_col_type = "number"
		CASE "time"
			IF Lower(s_col_type) = "time" THEN
				s_col_type = "time"
			ELSE
				s_col_type = "?"
				DESTROY ds_local
				RETURN -3
			END IF
		CASE ELSE
			s_col_type = "?"
			DESTROY ds_local
			RETURN -4
	END CHOOSE
	a_s_key_type[i_indx] = s_col_type
NEXT


// Destroy the datastore and return the number of columns extracted.

DESTROY ds_local

RETURN i_indx
end function

public function boolean fu_get_level_lock ();// Return value of instance variable.

RETURN i_b_level_lock
end function

public subroutine fu_set_level_lock (boolean a_b_level_lock);// Save passed value to instance variable.

i_b_level_lock = a_b_level_lock
end subroutine

protected function long fu_copy_tree (ref treeview a_tv_source, ref treeviewitem a_tvi_source, ref treeviewitem a_tvi_target);// Copy the source TreeViewItem and all of its children to the
// target TreeViewItem.
//
// Returns:
//		  n	handle of the target item
//		 -1	unsuccessful item insert

Long l_handle_target, l_handle_source
TreeViewItem tvi_source_child, tvi_target_child


// Ensure the target item is already expanded -- PowerBuilder will
// choke if not.

this.ExpandItem(a_tvi_target.itemhandle)


// Insert the source item as a child of the target.

l_handle_target = this.InsertItemSort(a_tvi_target.itemhandle, &
																		a_tvi_source)

IF l_handle_target < 0 THEN
	RETURN l_handle_target
END IF


// Insert the source children as children of the newly inserted
// item.

IF this.GetItem(l_handle_target, tvi_target_child) < 0 THEN
	RETURN l_handle_target
END IF

l_handle_source = a_tv_source.FindItem(ChildTreeItem!, &
														a_tvi_source.itemhandle)

DO WHILE l_handle_source > 0
	IF a_tv_source.GetItem(l_handle_source, tvi_source_child) < 0 THEN
		RETURN l_handle_target
	END IF
	IF this.fu_copy_tree(a_tv_source, tvi_source_child, &
													tvi_target_child) < 0 THEN
		RETURN l_handle_target
	END IF
	l_handle_source = a_tv_source.FindItem(NextTreeItem!, &
																	l_handle_source)
LOOP


// Success.

RETURN l_handle_target
end function

public function long fu_get_root_key (ref any a_any_root_key[]);// Return the root key array and the number of entries.

a_any_root_key = i_any_root_key

RETURN UpperBound(i_any_root_key)
end function

public subroutine fu_set_root_key (any a_any_root_key[]);// Save the keys to the instance variable array.

i_any_root_key = a_any_root_key
end subroutine

protected function long fu_populate_ds (long a_l_parent, any a_any_key[], ref stru_ds a_stru_ds);// Populate the datastore and insert a TreeViewItem for each row
// retrieved.
//
// Returns:
//		  n	number of items added (rows retrieved)
//		-99	unable to retrieve datastore with keys passed
//		 -n	retrieve error

String s_item, s_picture, s_selected_picture, s_label, s_coltype
Date date_item
DateTime dt_item
Decimal dec_item
Double d_item
Time tme_item
Integer i_indx, i_ubound
Long l_row_num, l_row_cnt, l_handle
any any_key[], any_data[], any_sortkey[]


// Populate (retrieve) the datastore using the keys passed.

i_ubound = UpperBound(a_any_key)

CHOOSE CASE i_ubound
	CASE 0
		l_row_cnt = &
			a_stru_ds.ds_level.Retrieve()
	CASE 1
		l_row_cnt = &
			a_stru_ds.ds_level.Retrieve(a_any_key[1])
	CASE 2
		l_row_cnt = &
			a_stru_ds.ds_level.Retrieve(a_any_key[1],&
													a_any_key[2])
	CASE 3
		l_row_cnt = &
			a_stru_ds.ds_level.Retrieve(a_any_key[1],&
													a_any_key[2],&
													a_any_key[3])
	CASE 4
		l_row_cnt = &
			a_stru_ds.ds_level.Retrieve(a_any_key[1],&
													a_any_key[2],&
													a_any_key[3],&
													a_any_key[4])
	CASE 5
		l_row_cnt = &
			a_stru_ds.ds_level.Retrieve(a_any_key[1],&
													a_any_key[2],&
													a_any_key[3],&
													a_any_key[4],&
													a_any_key[5])
	CASE 6
		l_row_cnt = &
			a_stru_ds.ds_level.Retrieve(a_any_key[1],&
													a_any_key[2],&
													a_any_key[3],&
													a_any_key[4],&
													a_any_key[5],&
													a_any_key[6])
	CASE 7
		l_row_cnt = &
			a_stru_ds.ds_level.Retrieve(a_any_key[1],&
													a_any_key[2],&
													a_any_key[3],&
													a_any_key[4],&
													a_any_key[5],&
													a_any_key[6],&
													a_any_key[7])
	CASE 8
		l_row_cnt = &
			a_stru_ds.ds_level.Retrieve(a_any_key[1],&
													a_any_key[2],&
													a_any_key[3],&
													a_any_key[4],&
													a_any_key[5],&
													a_any_key[6],&
													a_any_key[7],&
													a_any_key[8])
	CASE 9
		l_row_cnt = &
			a_stru_ds.ds_level.Retrieve(a_any_key[1],&
													a_any_key[2],&
													a_any_key[3],&
													a_any_key[4],&
													a_any_key[5],&
													a_any_key[6],&
													a_any_key[7],&
													a_any_key[8],&
													a_any_key[9])
	CASE 10
		l_row_cnt = &
			a_stru_ds.ds_level.Retrieve(a_any_key[1],&
													a_any_key[2],&
													a_any_key[3],&
													a_any_key[4],&
													a_any_key[5],&
													a_any_key[6],&
													a_any_key[7],&
													a_any_key[8],&
													a_any_key[9],&
													a_any_key[10])
	CASE ELSE
		l_row_cnt = -99
END CHOOSE

IF l_row_cnt < 1 THEN
	RETURN l_row_cnt
END IF


// Loop through each row of the datastore and insert a new item
// into the TreeView.

FOR l_row_num = 1 TO l_row_cnt

	// Extract picture, selected picture and label from datastore if
	// the first character is '&' (indicating a column name).

	s_picture = a_stru_ds.ds_level.GetItemString(l_row_num, &
													a_stru_ds.s_picture_col)

	s_selected_picture = a_stru_ds.ds_level.GetItemString(l_row_num, &
													a_stru_ds.s_selected_picture_col)

	s_label = a_stru_ds.ds_level.GetItemString(l_row_num, &
													a_stru_ds.s_label_col)

	// Extract the key(s) from the datastore and convert them to
	// the target type (used for later retrieval).

	i_ubound = UpperBound(a_stru_ds.s_key_col)

	FOR i_indx = 1 TO i_ubound
		CHOOSE CASE a_stru_ds.s_key_from_type[i_indx]
			CASE "string"
				s_item = a_stru_ds.ds_level.GetItemString(l_row_num, &
												a_stru_ds.s_key_col[i_indx])
				CHOOSE CASE a_stru_ds.s_key_to_type[i_indx]
					CASE "date"
						date_item = Date(s_item)
						any_key[i_indx] = date_item
					CASE "datetime"
						dt_item = DateTime(s_item)
						any_key[i_indx] = dt_item
					CASE "number"
						d_item = Double(s_item)
						any_key[i_indx] = d_item
					CASE "string"
						any_key[i_indx] = s_item
					CASE "time"
						tme_item = Time(s_item)
						any_key[i_indx] = tme_item
				END CHOOSE
			CASE "date"
				date_item = a_stru_ds.ds_level.GetItemDate(l_row_num, &
												a_stru_ds.s_key_col[i_indx])
				CHOOSE CASE a_stru_ds.s_key_to_type[i_indx]
					CASE "date"
						any_key[i_indx] = date_item
					CASE "datetime"
						dt_item = DateTime(date_item)
						any_key[i_indx] = dt_item
					CASE "string"
						s_item = String(date_item)
						any_key[i_indx] = s_item
				END CHOOSE
			CASE "datetime"
				dt_item = a_stru_ds.ds_level.GetItemDateTime(l_row_num, &
												a_stru_ds.s_key_col[i_indx])
				CHOOSE CASE a_stru_ds.s_key_to_type[i_indx]
					CASE "date"
						date_item = Date(dt_item)
						any_key[i_indx] = date_item
					CASE "datetime"
						any_key[i_indx] = dt_item
					CASE "string"
						s_item = String(dt_item)
						any_key[i_indx] = s_item
					CASE "time"
						tme_item = Time(dt_item)
						any_key[i_indx] = tme_item
				END CHOOSE
			CASE "decimal"
				dec_item = a_stru_ds.ds_level.GetItemDecimal(l_row_num, &
												a_stru_ds.s_key_col[i_indx])
				CHOOSE CASE a_stru_ds.s_key_to_type[i_indx]
					CASE "number"
						d_item = dec_item
						any_key[i_indx] = d_item
					CASE "string"
						s_item = String(dec_item)
						any_key[i_indx] = s_item
				END CHOOSE
			CASE "number"
				d_item = a_stru_ds.ds_level.GetItemNumber(l_row_num, &
												a_stru_ds.s_key_col[i_indx])
				CHOOSE CASE a_stru_ds.s_key_to_type[i_indx]
					CASE "number"
						any_key[i_indx] = d_item
					CASE "string"
						s_item = String(d_item)
						any_key[i_indx] = s_item
				END CHOOSE
			CASE "time"
				tme_item = a_stru_ds.ds_level.GetItemTime(l_row_num, &
												a_stru_ds.s_key_col[i_indx])
				CHOOSE CASE a_stru_ds.s_key_to_type[i_indx]
					CASE "string"
						s_item = String(tme_item)
						any_key[i_indx] = s_item
					CASE "time"
						any_key[i_indx] = tme_item
				END CHOOSE
		END CHOOSE
	NEXT

	// Extract the data item(s) from the datastore and convert them
	// to an appropriate data type.

	i_ubound = UpperBound(a_stru_ds.s_data_col)

	FOR i_indx = 1 TO i_ubound
		CHOOSE CASE a_stru_ds.s_data_from_type[i_indx]
			CASE "string"
				s_item = a_stru_ds.ds_level.GetItemString(l_row_num, &
												a_stru_ds.s_data_col[i_indx])
				any_data[i_indx] = s_item
			CASE "date"
				date_item = a_stru_ds.ds_level.GetItemDate(l_row_num, &
												a_stru_ds.s_data_col[i_indx])
				any_data[i_indx] = date_item
			CASE "datetime"
				dt_item = a_stru_ds.ds_level.GetItemDateTime(l_row_num, &
												a_stru_ds.s_data_col[i_indx])
				any_data[i_indx] = dt_item
			CASE "decimal"
				dec_item = a_stru_ds.ds_level.GetItemDecimal(l_row_num, &
												a_stru_ds.s_data_col[i_indx])
				d_item = dec_item
				any_data[i_indx] = d_item
			CASE "number"
				d_item = a_stru_ds.ds_level.GetItemNumber(l_row_num, &
												a_stru_ds.s_data_col[i_indx])
				any_data[i_indx] = d_item
			CASE "time"
				tme_item = a_stru_ds.ds_level.GetItemTime(l_row_num, &
												a_stru_ds.s_data_col[i_indx])
				any_data[i_indx] = tme_item
		END CHOOSE
	NEXT

	// Extract the sort key(s) from the datastore and convert them
	// to an appropriate data type.

	i_ubound = UpperBound(a_stru_ds.s_sortkey_col)

	FOR i_indx = 1 TO i_ubound
		CHOOSE CASE a_stru_ds.s_sortkey_from_type[i_indx]
			CASE "string"
				s_item = a_stru_ds.ds_level.GetItemString(l_row_num, &
												a_stru_ds.s_sortkey_col[i_indx])
				any_sortkey[i_indx] = s_item
			CASE "date"
				date_item = a_stru_ds.ds_level.GetItemDate(l_row_num, &
												a_stru_ds.s_sortkey_col[i_indx])
				any_sortkey[i_indx] = date_item
			CASE "datetime"
				dt_item = a_stru_ds.ds_level.GetItemDateTime(l_row_num, &
												a_stru_ds.s_sortkey_col[i_indx])
				any_sortkey[i_indx] = dt_item
			CASE "decimal"
				dec_item = a_stru_ds.ds_level.GetItemDecimal(l_row_num, &
												a_stru_ds.s_sortkey_col[i_indx])
				d_item = dec_item
				any_sortkey[i_indx] = d_item
			CASE "number"
				d_item = a_stru_ds.ds_level.GetItemNumber(l_row_num, &
												a_stru_ds.s_sortkey_col[i_indx])
				any_sortkey[i_indx] = d_item
			CASE "time"
				tme_item = a_stru_ds.ds_level.GetItemTime(l_row_num, &
												a_stru_ds.s_sortkey_col[i_indx])
				any_sortkey[i_indx] = tme_item
		END CHOOSE
	NEXT

	// Insert the new item into the TreeView.

	l_handle = this.fu_add_item(a_l_parent, 0, s_picture, &
										s_selected_picture, TRUE, s_label, &
										any_key[], any_data[], any_sortkey[])

NEXT

RETURN l_row_cnt
end function

public function integer fu_delete_item (long a_l_handle);// Delete all the children for the item to be deleted and, if
// successful, delete the item.
//
// Returns:
//		  1	delete successful
//		 -1	delete of item or its children unsuccessful

Integer i_rc
Long l_handle_child
TreeNavigation e_nav_code
TreeViewItem tvi_current


// Delete all the children of the current item.  If the current
// item is 0 then delete all roots of the TreeView.

IF a_l_handle > 0 THEN
	e_nav_code = ChildTreeItem!
ELSE
	e_nav_code = RootTreeItem!
END IF

l_handle_child = this.FindItem(e_nav_code, a_l_handle)

DO WHILE l_handle_child > 0
	i_rc = this.fu_delete_item(l_handle_child)
	IF i_rc < 0 THEN
		RETURN i_rc
	END IF
	l_handle_child = this.FindItem(e_nav_code, a_l_handle)
LOOP


// Get the current item (if it exists).

IF a_l_handle > 0 THEN
	IF this.GetItem(a_l_handle, tvi_current) < 0 THEN
		RETURN -1
	END IF
ELSE					// no item to delete
	RETURN 1
END IF


// Trigger the ue_pre_delete event to allow the developer to
// terminate the delete.

i_rc = this.EVENT ue_pre_delete(tvi_current)

IF i_rc < 0 THEN
	RETURN i_rc
END IF


// Delete the extended attributes and the item.

this.fu_del_ext_attr(tvi_current)

IF this.DeleteItem(a_l_handle) < 0 THEN
	RETURN -1
END IF


// Post the post-delete event and indicate success.

this.EVENT POST ue_post_delete(tvi_current)

RETURN 1
end function

public subroutine fu_reset ();// Reset (clear) the TreeView and destroy any datastores.

Integer i_indx, i_ubound
Any any_empty[]
stru_ds stru_empty[], stru_empty_item



// Clear the TreeView.

this.fu_clear()


// Destroy any datastores.

IF IsValid(i_stru_ds_root.ds_level) THEN
	DESTROY i_stru_ds_root.ds_level
END IF

i_ubound = UpperBound(i_stru_ds_level)

FOR i_indx = 1 TO i_ubound
	IF IsValid(i_stru_ds_level[i_indx].ds_level) THEN
		DESTROY i_stru_ds_level[i_indx].ds_level
	END IF
NEXT


// Clear the datastore root/level references.

i_any_root_key = any_empty
i_stru_ds_root = stru_empty_item
i_stru_ds_level = stru_empty
end subroutine

public subroutine fu_clear ();// Clear the TreeView.

this.fu_delete_item(0)
end subroutine

public function integer fu_set_ds_level (integer a_i_level, transaction a_tr_object, string a_s_data_object, string a_s_picture_col, string a_s_selected_picture_col, string a_s_label_col, string a_s_key_col[], string a_s_key_type[], string a_s_data_col[], string a_s_sortkey_col[]);// Store the datastore, transaction object, and key and label columns
// for that level in the datastore level structure.
//
// Returns:
//		  1	success
//		 -1	unable to create datastore
//		 -2	unable to set transaction on datastore
//		 -3	timestamp datawindow column type encountered
//		 -4	unknown datawindow column type encountered

String s_col_type
Integer i_indx, i_ubound


// Create and initialize the datastore.

IF UpperBound(i_stru_ds_level) < a_i_level THEN
ELSE
	IF IsValid(i_stru_ds_level[a_i_level].ds_level) THEN
		DESTROY i_stru_ds_level[a_i_level].ds_level
	END IF
END IF

i_stru_ds_level[a_i_level].ds_level = CREATE datastore

IF NOT IsValid(i_stru_ds_level[a_i_level].ds_level) THEN
	RETURN -1
END IF

i_stru_ds_level[a_i_level].ds_level.dataobject = a_s_data_object

IF	i_stru_ds_level[a_i_level].ds_level.SetTransObject(a_tr_object) < 0 THEN
	RETURN -2
END IF


// Populate the structure for the level passed.

i_stru_ds_level[a_i_level].s_picture_col = Lower(Trim(a_s_picture_col))

i_stru_ds_level[a_i_level].s_selected_picture_col = Lower(Trim(a_s_selected_picture_col))

i_stru_ds_level[a_i_level].s_label_col = Lower(Trim(a_s_label_col))

i_ubound = UpperBound(a_s_key_col)

FOR i_indx = 1 TO i_ubound
	i_stru_ds_level[a_i_level].s_key_col[i_indx] = &
											Lower(Trim(a_s_key_col[i_indx]))
	i_stru_ds_level[a_i_level].s_key_to_type[i_indx] = &
											Lower(Trim(a_s_key_type[i_indx]))
	// Derive 'from' type from data object . . .
	s_col_type = i_stru_ds_level[a_i_level].ds_level.Describe &
			(i_stru_ds_level[a_i_level].s_key_col[i_indx] + ".ColType")
	CHOOSE CASE Lower(Left(s_col_type,4))
		CASE "char"
			s_col_type = "string"
		CASE "date"
			IF Lower(s_col_type) = "date" THEN
				s_col_type = "date"
			ELSE
				s_col_type = "datetime"
			END IF
		CASE "deci"
			s_col_type = "decimal"
		CASE "long"
			s_col_type = "number"
		CASE "numb"
			s_col_type = "number"
		CASE "time"
			IF Lower(s_col_type) = "time" THEN
				s_col_type = "time"
			ELSE
				s_col_type = "?"
				RETURN -3
			END IF
		CASE "ulong"
			s_col_type = "number"
		CASE "real"
			s_col_type = "number"
		CASE ELSE
			s_col_type = "?"
			RETURN -4
	END CHOOSE
	i_stru_ds_level[a_i_level].s_key_from_type[i_indx] = s_col_type
NEXT

i_ubound = UpperBound(a_s_data_col)

FOR i_indx = 1 TO i_ubound
	i_stru_ds_level[a_i_level].s_data_col[i_indx] = &
											Lower(Trim(a_s_data_col[i_indx]))
	// Derive 'from' type from data object . . .
	s_col_type = i_stru_ds_level[a_i_level].ds_level.Describe &
			(i_stru_ds_level[a_i_level].s_data_col[i_indx] + ".ColType")
	CHOOSE CASE Lower(Left(s_col_type,4))
		CASE "char"
			s_col_type = "string"
		CASE "date"
			IF Lower(s_col_type) = "date" THEN
				s_col_type = "date"
			ELSE
				s_col_type = "datetime"
			END IF
		CASE "deci"
			s_col_type = "decimal"
		CASE "long"
			s_col_type = "number"
		CASE "numb"
			s_col_type = "number"
		CASE "time"
			IF Lower(s_col_type) = "time" THEN
				s_col_type = "time"
			ELSE
				s_col_type = "?"
				RETURN -3
			END IF
		CASE "ulong"
			s_col_type = "number"
		CASE "real"
			s_col_type = "number"
		CASE ELSE
			s_col_type = "?"
			RETURN -4
	END CHOOSE
	i_stru_ds_level[a_i_level].s_data_from_type[i_indx] = s_col_type
NEXT

i_ubound = UpperBound(a_s_sortkey_col)

FOR i_indx = 1 TO i_ubound
	i_stru_ds_level[a_i_level].s_sortkey_col[i_indx] = &
											Lower(Trim(a_s_sortkey_col[i_indx]))
	// Derive 'from' type from data object . . .
	s_col_type = i_stru_ds_level[a_i_level].ds_level.Describe &
			(i_stru_ds_level[a_i_level].s_sortkey_col[i_indx] + ".ColType")
	CHOOSE CASE Lower(Left(s_col_type,4))
		CASE "char"
			s_col_type = "string"
		CASE "date"
			IF Lower(s_col_type) = "date" THEN
				s_col_type = "date"
			ELSE
				s_col_type = "datetime"
			END IF
		CASE "deci"
			s_col_type = "decimal"
		CASE "long"
			s_col_type = "number"
		CASE "numb"
			s_col_type = "number"
		CASE "time"
			IF Lower(s_col_type) = "time" THEN
				s_col_type = "time"
			ELSE
				s_col_type = "?"
				RETURN -3
			END IF
		CASE "ulong"
			s_col_type = "number"
		CASE "real"
			s_col_type = "number"
		CASE ELSE
			s_col_type = "?"
			RETURN -4
	END CHOOSE
	i_stru_ds_level[a_i_level].s_sortkey_from_type[i_indx] = s_col_type
NEXT

RETURN 1
end function

public function integer fu_set_ds_root (transaction a_tr_object, string a_s_data_object, string a_s_picture_col, string a_s_selected_picture_col, string a_s_label_col, string a_s_key_col[], string a_s_key_type[], string a_s_data_col[], string a_s_sortkey_col[]);// Store the datastore, transaction object, and key column for the
// root datastore structure.
//
// Returns:
//		  1	success
//		 -1	unable to create datastore
//		 -2	unable to set transaction on datastore
//		 -3	timestamp datawindow column type encountered
//		 -4	unknown datawindow column type encountered

String s_col_type
Integer i_indx, i_ubound


// Create and initialize the datastore.

IF IsValid(i_stru_ds_root.ds_level) THEN
	DESTROY i_stru_ds_root.ds_level
END IF

i_stru_ds_root.ds_level = CREATE datastore

IF NOT IsValid(i_stru_ds_root.ds_level) THEN
	RETURN -1
END IF

i_stru_ds_root.ds_level.dataobject = a_s_data_object

IF	i_stru_ds_root.ds_level.SetTransObject(a_tr_object) < 0 THEN
	RETURN -2
END IF


// Populate the structure for the level passed.

i_stru_ds_root.s_picture_col = Lower(Trim(a_s_picture_col))

i_stru_ds_root.s_selected_picture_col = Lower(Trim(a_s_selected_picture_col))

i_stru_ds_root.s_label_col = Lower(Trim(a_s_label_col))

i_ubound = UpperBound(a_s_key_col)

FOR i_indx = 1 TO i_ubound
	i_stru_ds_root.s_key_col[i_indx] = &
											Lower(Trim(a_s_key_col[i_indx]))
	i_stru_ds_root.s_key_to_type[i_indx] = &
											Lower(Trim(a_s_key_type[i_indx]))
	// Derive 'from' type from data object . . .
	s_col_type = i_stru_ds_root.ds_level.Describe &
			(i_stru_ds_root.s_key_col[i_indx] + ".ColType")
	CHOOSE CASE Lower(Left(s_col_type,4))
		CASE "char"
			s_col_type = "string"
		CASE "date"
			IF Lower(s_col_type) = "date" THEN
				s_col_type = "date"
			ELSE
				s_col_type = "datetime"
			END IF
		CASE "deci"
			s_col_type = "decimal"
		CASE "long"
			s_col_type = "number"
		CASE "numb"
			s_col_type = "number"
		CASE "time"
			IF Lower(s_col_type) = "time" THEN
				s_col_type = "time"
			ELSE
				s_col_type = "?"
				RETURN -3
			END IF
		CASE "ulong"
			s_col_type = "number"
		CASE "real"
			s_col_type = "number"
		CASE ELSE
			s_col_type = "?"
			RETURN -4
	END CHOOSE
	i_stru_ds_root.s_key_from_type[i_indx] = s_col_type
NEXT

i_ubound = UpperBound(a_s_sortkey_col)

FOR i_indx = 1 TO i_ubound
	i_stru_ds_root.s_sortkey_col[i_indx] = &
											Lower(Trim(a_s_sortkey_col[i_indx]))
	// Derive 'from' type from data object . . .
	s_col_type = i_stru_ds_root.ds_level.Describe &
			(i_stru_ds_root.s_sortkey_col[i_indx] + ".ColType")
	CHOOSE CASE Lower(Left(s_col_type,4))
		CASE "char"
			s_col_type = "string"
		CASE "date"
			IF Lower(s_col_type) = "date" THEN
				s_col_type = "date"
			ELSE
				s_col_type = "datetime"
			END IF
		CASE "deci"
			s_col_type = "decimal"
		CASE "long"
			s_col_type = "number"
		CASE "numb"
			s_col_type = "number"
		CASE "time"
			IF Lower(s_col_type) = "time" THEN
				s_col_type = "time"
			ELSE
				s_col_type = "?"
				RETURN -3
			END IF
		CASE "ulong"
			s_col_type = "number"
		CASE "real"
			s_col_type = "number"
		CASE ELSE
			s_col_type = "?"
			RETURN -4
	END CHOOSE
	i_stru_ds_root.s_sortkey_from_type[i_indx] = s_col_type
NEXT

i_ubound = UpperBound(a_s_data_col)

FOR i_indx = 1 TO i_ubound
	i_stru_ds_root.s_data_col[i_indx] = &
											Lower(Trim(a_s_data_col[i_indx]))
	// Derive 'from' type from data object . . .
	s_col_type = i_stru_ds_root.ds_level.Describe &
			(i_stru_ds_root.s_data_col[i_indx] + ".ColType")
	CHOOSE CASE Lower(Left(s_col_type,4))
		CASE "char"
			s_col_type = "string"
		CASE "date"
			IF Lower(s_col_type) = "date" THEN
				s_col_type = "date"
			ELSE
				s_col_type = "datetime"
			END IF
		CASE "deci"
			s_col_type = "decimal"
		CASE "long"
			s_col_type = "number"
		CASE "numb"
			s_col_type = "number"
		CASE "time"
			IF Lower(s_col_type) = "time" THEN
				s_col_type = "time"
			ELSE
				s_col_type = "?"
				RETURN -3
			END IF
		CASE "ulong"
			s_col_type = "number"
		CASE "real"
			s_col_type = "number"
		CASE ELSE
			s_col_type = "?"
			RETURN -4
	END CHOOSE
	i_stru_ds_root.s_data_from_type[i_indx] = s_col_type
NEXT

RETURN 1
end function

public function integer fu_set_ds_level (integer a_i_level, transaction a_tr_object, string a_s_data_object, string a_s_picture_col, string a_s_selected_picture_col, string a_s_label_col, string a_s_data_col[], string a_s_sortkey_col[]);// Invoke fu_set_ds_level to set up a level datastore that has
// key columns that match the key columns of the data object.
//
// Returns:
//		  1	success
//		 -1	unable to create datastore
//		 -2	unable to set transaction on datastore
//		 -3	timestamp datawindow column type encountered
//		 -4	unknown datawindow column type encountered

Integer i_rc
String s_key_col[], s_key_type[]


// Extract  key columns from the data object.

i_rc = this.fu_extract_key_cols(a_s_data_object, s_key_col, &
																	s_key_type)


IF i_rc < 0 THEN
	RETURN i_rc
END IF


// Call the 'parent' function to set the level datastore.

RETURN this.fu_set_ds_level(a_i_level, a_tr_object, a_s_data_object, &
									a_s_picture_col, a_s_selected_picture_col, &
									a_s_label_col, s_key_col, s_key_type, &
												a_s_data_col, a_s_sortkey_col)
end function

public function integer fu_set_ds_root (transaction a_tr_object, string a_s_data_object, string a_s_picture_col, string a_s_selected_picture_col, string a_s_label_col, string a_s_data_col[], string a_s_sortkey_col[]);// Invoke fu_set_ds_root to set up a root datastore that has
// key columns that match the key columns of the data object.
//
// Returns:
//		  1	success
//		 -1	unable to create datastore
//		 -2	unable to set transaction on datastore
//		 -3	timestamp datawindow column type encountered
//		 -4	unknown datawindow column type encountered

Integer i_rc
String s_key_col[], s_key_type[]


// Extract  key columns from the data object.

i_rc = this.fu_extract_key_cols(a_s_data_object, s_key_col, &
																	s_key_type)


IF i_rc < 0 THEN
	RETURN i_rc
END IF


// Call the 'parent' function to set the root datastore.

RETURN this.fu_set_ds_root(a_tr_object, a_s_data_object, &
					a_s_picture_col, a_s_selected_picture_col, &
					a_s_label_col, s_key_col, s_key_type, &
									a_s_data_col, a_s_sortkey_col)
end function

public function integer fu_set_ds_level (integer a_i_level, transaction a_tr_object, string a_s_data_object, string a_s_picture_col, string a_s_selected_picture_col, string a_s_label_col, string a_s_data_col[]);// Invoke fu_set_ds_level to set up a level datastore that has
// sort key columns that match the key columns of the data object.
//
// Returns:
//		  1	success
//		 -1	unable to create datastore
//		 -2	unable to set transaction on datastore
//		 -3	timestamp datawindow column type encountered
//		 -4	unknown datawindow column type encountered

Integer i_rc
String s_sortkey_col[], s_sortkey_type[]


// Extract sort key columns from the data object.

i_rc = this.fu_extract_key_cols(a_s_data_object, s_sortkey_col, &
																	s_sortkey_type)


IF i_rc < 0 THEN
	RETURN i_rc
END IF


// Call the 'parent' function to set the level datastore.

RETURN this.fu_set_ds_level(a_i_level, a_tr_object, a_s_data_object, &
									a_s_picture_col, a_s_selected_picture_col, &
									a_s_label_col, a_s_data_col, s_sortkey_col)
end function

public function integer fu_set_ds_level (integer a_i_level, transaction a_tr_object, string a_s_data_object, string a_s_picture_col, string a_s_selected_picture_col, string a_s_label_col);// Invoke fu_set_ds_level to set up a level datastore that has
// no data columns.
//
// Returns:
//		  1	success
//		 -1	unable to create datastore
//		 -2	unable to set transaction on datastore
//		 -3	timestamp datawindow column type encountered
//		 -4	unknown datawindow column type encountered

String s_data_col[]


// Call the 'parent' function to set the level datastore.

RETURN this.fu_set_ds_level(a_i_level, a_tr_object, a_s_data_object, &
									a_s_picture_col, a_s_selected_picture_col, &
														a_s_label_col, s_data_col)
end function

public function integer fu_set_ds_root (transaction a_tr_object, string a_s_data_object, string a_s_picture_col, string a_s_selected_picture_col, string a_s_label_col, string a_s_data_col[]);// Invoke fu_set_ds_root to set up a root datastore that has
// sort key columns that match the key columns of the data object.
//
// Returns:
//		  1	success
//		 -1	unable to create datastore
//		 -2	unable to set transaction on datastore
//		 -3	timestamp datawindow column type encountered
//		 -4	unknown datawindow column type encountered

Integer i_rc
String s_sortkey_col[], s_sortkey_type[]


// Extract sort key columns from the data object.

i_rc = this.fu_extract_key_cols(a_s_data_object, s_sortkey_col, &
																	s_sortkey_type)


IF i_rc < 0 THEN
	RETURN i_rc
END IF


// Call the 'parent' function to set the root datastore.

RETURN this.fu_set_ds_root(a_tr_object, a_s_data_object, &
					a_s_picture_col, a_s_selected_picture_col, &
					a_s_label_col, a_s_data_col, s_sortkey_col)
end function

public function integer fu_set_ds_root (transaction a_tr_object, string a_s_data_object, string a_s_picture_col, string a_s_selected_picture_col, string a_s_label_col);// Invoke fu_set_ds_root to set up a root datastore that has
// no data columns.
//
// Returns:
//		  1	success
//		 -1	unable to create datastore
//		 -2	unable to set transaction on datastore
//		 -3	timestamp datawindow column type encountered
//		 -4	unknown datawindow column type encountered

String s_data_col[]


// Call the 'parent' function to set the root datastore.

RETURN this.fu_set_ds_root(a_tr_object, a_s_data_object, &
					a_s_picture_col, a_s_selected_picture_col, &
											a_s_label_col, s_data_col)
end function

protected function long fu_populate_ds_level (ref treeviewitem a_tvi_current);//	Populate the current item using the datastore for its level.

Long l_row_cnt
any any_key[]		// keys for the current item
any any_data[]		// data for the current item (not used)
any any_sortkey[]	// sort keys for the current item (not used)


// Extract the keys from the current item.

this.fu_get_ext_attr(a_tvi_current, any_key, any_data, any_sortkey)


// Insert a TreeViewItem for each row in the datastore.

l_row_cnt = this.fu_populate_ds(a_tvi_current.itemhandle, any_key, &
											i_stru_ds_level[a_tvi_current.level])

IF l_row_cnt < 1 THEN
	a_tvi_current.children = FALSE
	this.SetItem(a_tvi_current.itemhandle, a_tvi_current)
END IF

RETURN l_row_cnt
end function

protected function long fu_populate_ds_root ();//	Populate the root item(s) using the datastore and any defined
// root keys.

RETURN this.fu_populate_ds(0, i_any_root_key, i_stru_ds_root)
end function

public function integer deletepictures ();// Call the parent function and clear the picturename array.

String s_empty
Integer i_rc, i_indx, i_ubound


i_rc = super::deletepictures()

IF i_rc > 0 THEN
	i_ubound = UpperBound(this.picturename)
	FOR i_indx = 1 to i_ubound
		this.picturename[i_indx] = s_empty
	NEXT
END IF

RETURN i_rc
end function

public function integer deletestatepictures ();// Call the parent function and clear the statepicturename array.

String s_empty
Integer i_rc, i_indx, i_ubound


i_rc = super::deletestatepictures()

IF i_rc > 0 THEN
	i_ubound = UpperBound(this.statepicturename)
	FOR i_indx = 1 to i_ubound
		this.statepicturename[i_indx] = s_empty
	NEXT
END IF

RETURN i_rc
end function

public function integer deletepicture (integer a_i_indx);// Remove the entry from the picturename array if the picture is
// successfully removed by the parent function.

String s_empty
Integer i_rc, i_indx, i_ubound


i_rc = super::deletepicture(a_i_indx)

IF i_rc > 0 THEN
	i_ubound = UpperBound(this.picturename)
	FOR i_indx = a_i_indx TO i_ubound
		IF i_indx = i_ubound THEN
			this.picturename[i_indx] = s_empty
		ELSE
			this.picturename[i_indx] = this.picturename[i_indx + 1]
		END IF
	NEXT
END IF

RETURN i_rc
end function

public function integer deletestatepicture (integer a_i_indx);// Remove the entry from the statepicturename array if the picture is
// successfully removed by the parent function.

String s_empty
Integer i_rc, i_indx, i_ubound


i_rc = super::deletestatepicture(a_i_indx)

IF i_rc > 0 THEN
	i_ubound = UpperBound(this.statepicturename)
	FOR i_indx = a_i_indx TO i_ubound
		IF i_indx = i_ubound THEN
			this.statepicturename[i_indx] = s_empty
		ELSE
			this.statepicturename[i_indx] = this.statepicturename[i_indx + 1]
		END IF
	NEXT
END IF

RETURN i_rc
end function

event dragdrop;// Call user event allowing developer to validate the operation.

IF this.EVENT ue_pre_dragdrop(source, handle) < 0 THEN
	RETURN -1
END IF


// Call user event to execute PowerTOOL default dragdrop operation.

IF this.EVENT ue_dragdrop_pt(source, handle) < 0 THEN
	RETURN -1
END IF


// Post event to handle post-dragdrop processing.

this.EVENT POST ue_post_dragdrop(source, handle)
end event

event destructor;// Destroy any datastores.

Integer i_indx, i_ubound


IF IsValid(i_stru_ds_root.ds_level) THEN
	DESTROY i_stru_ds_root.ds_level
END IF

i_ubound = UpperBound(i_stru_ds_level)

FOR i_indx = 1 TO i_ubound
	IF IsValid(i_stru_ds_level[i_indx].ds_level) THEN
		DESTROY i_stru_ds_level[i_indx].ds_level
	END IF
NEXT
end event

event itempopulate;// If a datastore has been defined for this level then
// use it to populate this item.

TreeViewItem tvi_current


// Get the current TreeViewItem and determine whether a
// datastore is defined for its level.

IF this.GetItem(handle, tvi_current) < 0 THEN
	RETURN
END IF

IF tvi_current.level > UpperBound(i_stru_ds_level) THEN
	tvi_current.children = FALSE
	this.SetItem(handle, tvi_current)
	RETURN
END IF

IF NOT IsValid(i_stru_ds_level[tvi_current.level]) THEN
	tvi_current.children = FALSE
	this.SetItem(handle, tvi_current)
	RETURN
END IF


// Populate the item using the datastore for the level.

this.fu_populate_ds_level(tvi_current)
end event

event constructor;// Initialize extended attribute class.

this.fu_set_attr_classname("nv_attr")
end event

event sort;// Sort the TreeView items based on the sort key extended attributes.

Long l_indx, l_ubound1, l_ubound2
any any_key1[], any_key2[]				// Item keys (not used)
any any_data1[], any_data2[]			// Item data (not used)
any any_sortkey1[], any_sortkey2[]	// Item sort keys


// Get the extended attributes of the items to sort.

IF this.fu_get_ext_attr(handle1, any_key1, &
										any_data1, any_sortkey1) < 0 THEN
	RETURN 0
END IF

IF this.fu_get_ext_attr(handle2, any_key2, &
										any_data2, any_sortkey2) < 0 THEN
	RETURN 0
END IF


// Compare sort keys from left to right.

l_ubound1 = UpperBound(any_sortkey1)

l_ubound2 = UpperBound(any_sortkey2)

FOR l_indx = 1 TO l_ubound1
	IF l_indx > l_ubound2 THEN
		RETURN 1		// First item has more keys ==> is > second item
	END IF
	IF any_sortkey1[l_indx] > any_sortkey2[l_indx] THEN
		RETURN 1
	END IF
	IF any_sortkey1[l_indx] < any_sortkey2[l_indx] THEN
		RETURN -1
	END IF
NEXT


// Fallthrough -- all keys are equal (so far).

IF l_ubound2 > l_ubound1 THEN
	RETURN -1	// Second item has more keys ==> is > first item
END IF


// All keys are equal.

RETURN 0
end event

