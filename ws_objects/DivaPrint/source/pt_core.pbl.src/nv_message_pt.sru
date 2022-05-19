$PBExportHeader$nv_message_pt.sru
$PBExportComments$Objet message PowerTOOL
forward
global type nv_message_pt from message
end type
end forward

global type nv_message_pt from message
end type
global nv_message_pt nv_message_pt

type prototypes

end prototypes

type variables
PROTECTED:

// PowerBuilder workaround

Boolean i_b_initialized


// Custom message attributes

str_pass i_str_pass			// Window parms
str_nav i_str_nav			// NAV parms


// Message parm stack

Integer i_i_stack_ptr		// Stack height
Integer i_i_stack_handle []		// Stacked message handle
Integer i_i_stack_number []		// Stacked message number
UInt i_ui_stack_wordparm []		// Stacked message wordparm
Long i_l_stack_longparm []		// Stacked message longparm
Double i_d_stack_doubleparm []	// Stacked message doubleparm
String i_s_stack_stringparm []	// Stacked message stringparm
PowerObject i_po_stack_powerobjectparm []
				// Stacked message powerobjectparm
Boolean i_b_stack_processed []	// Stacked message processed ind
Long i_l_stack_returnvalue []		// Stacked message returnvalue
str_pass i_str_stack_str_pass []	// Stacked window parms
str_nav i_str_stack_str_nav []	// Stacked NAV parms


// Object set manager

Integer i_i_max_sets		// Maximum sets allowed
Integer i_i_max_members		// Maximum members of a set allowed

strnv_object_set	i_strnv_set []	// Array of sets

end variables

forward prototypes
public subroutine fnv_clear_str_pass ()
public subroutine fnv_set_str_pass (str_pass a_str_pass)
public function str_pass fnv_get_str_pass ()
public subroutine fnv_clear_str_nav ()
public function str_nav fnv_get_str_nav ()
public subroutine fnv_set_str_nav (str_nav a_str_nav)
public function integer fnv_push ()
public function integer fnv_pop ()
public subroutine fnv_set_max_sets (integer a_i_max_sets)
public subroutine fnv_set_max_members (integer a_i_max_members)
public function integer fnv_create_set (string a_s_set_name)
public function integer fnv_get_set_indx (string a_s_set_name)
public function integer fnv_destroy_set (string a_s_set_name)
public function boolean fnv_is_set_valid (string a_s_set_name)
public function integer fnv_get_set_size (string a_s_set_name)
public function integer fnv_get_set_handles (string a_s_set_name, ref long a_l_handle[])
public function integer fnv_get_set_members (string a_s_set_name, ref graphicobject a_go_member[])
public function integer fnv_enter_set (string a_s_set_name, graphicobject a_go_member, boolean a_b_active)
public function graphicobject fnv_get_set_member (string a_s_set_name, long a_l_handle)
public function integer fnv_set_active (string a_s_set_name, graphicobject a_go_member, boolean a_b_active)
public function integer fnv_leave_set (string a_s_set_name, graphicobject a_go_member)
public subroutine fnv_notify_set (string a_s_set_name, string a_s_event, str_pass a_str_pass)
public subroutine fnv_notify_others (string a_s_set_name, string a_s_event, str_pass a_str_pass, graphicobject a_go_member)
public subroutine fnv_show_set (string a_s_set_name, boolean a_b_visible)
public subroutine fnv_enable_set (string a_s_set_name, boolean a_b_enabled)
protected function integer fnv_enable_object (graphicobject a_go_object, boolean a_b_enabled)
protected subroutine fnv_init ()
protected subroutine fnv_show_object (graphicobject a_go_object, boolean a_b_enabled)
end prototypes

public subroutine fnv_clear_str_pass ();// Set i_str_pass to an empty structure.

this.fnv_init ()

str_pass str_pass_empty

i_str_pass = str_pass_empty
end subroutine

public subroutine fnv_set_str_pass (str_pass a_str_pass);// Set value of instance variable to passed parameter.

this.fnv_init ()

i_str_pass = a_str_pass
end subroutine

public function str_pass fnv_get_str_pass ();// Return value of instance variable.

this.fnv_init ()

RETURN i_str_pass
end function

public subroutine fnv_clear_str_nav ();// Set i_str_nav to an empty structure.

this.fnv_init ()

str_nav str_nav_empty

i_str_nav = str_nav_empty
end subroutine

public function str_nav fnv_get_str_nav ();// Return value of instance variable.

this.fnv_init ()

RETURN i_str_nav
end function

public subroutine fnv_set_str_nav (str_nav a_str_nav);// Set value of instance variable to passed parameter.

this.fnv_init ()

i_str_nav = a_str_nav
end subroutine

public function integer fnv_push ();// Push all message attributes onto the stack and return the stack
// index.

this.fnv_init ()

i_i_stack_ptr ++

i_i_stack_handle [i_i_stack_ptr] = this.handle

i_i_stack_number [i_i_stack_ptr] = this.number

i_ui_stack_wordparm [i_i_stack_ptr] = this.wordparm

i_l_stack_longparm [i_i_stack_ptr] = this.longparm

i_d_stack_doubleparm [i_i_stack_ptr] = this.doubleparm

i_s_stack_stringparm [i_i_stack_ptr] = this.stringparm

i_po_stack_powerobjectparm [i_i_stack_ptr] = this.powerobjectparm

i_b_stack_processed [i_i_stack_ptr] = this.processed

i_l_stack_returnvalue [i_i_stack_ptr] = this.returnvalue

i_str_stack_str_pass [i_i_stack_ptr] = this.i_str_pass

i_str_stack_str_nav [i_i_stack_ptr] = this.i_str_nav

RETURN i_i_stack_ptr
end function

public function integer fnv_pop ();// Pop all message attributes from the stack and return the stack
// index.

this.fnv_init ()

// Bail out if the stack is empty.

IF i_i_stack_ptr < 1 THEN
	RETURN i_i_stack_ptr
END IF


// Pop message attributes from the stack.

this.handle = i_i_stack_handle [i_i_stack_ptr]

this.number = i_i_stack_number [i_i_stack_ptr]

this.wordparm = i_ui_stack_wordparm [i_i_stack_ptr]

this.longparm = i_l_stack_longparm [i_i_stack_ptr]

this.doubleparm = i_d_stack_doubleparm [i_i_stack_ptr]

this.stringparm = i_s_stack_stringparm [i_i_stack_ptr]

// Workaround - if the message object and the stack both contain the
// same structure (e.g. str_pass) then the assignment statement clears
// them both.  I look forward to the day when PowerBuilder can effectively
// manage pointers.
IF this.powerobjectparm <> i_po_stack_powerobjectparm [i_i_stack_ptr] THEN
	this.powerobjectparm = i_po_stack_powerobjectparm [i_i_stack_ptr]
END IF

this.processed = i_b_stack_processed [i_i_stack_ptr]

this.returnvalue = i_l_stack_returnvalue [i_i_stack_ptr]

this.i_str_pass = i_str_stack_str_pass [i_i_stack_ptr]

this.i_str_nav = i_str_stack_str_nav [i_i_stack_ptr]

i_i_stack_ptr --

RETURN (i_i_stack_ptr + 1)
end function

public subroutine fnv_set_max_sets (integer a_i_max_sets);// Set the maximum number of sets that will be managed by this object.

// Bail out if a negative value is passed or if no changes is made.

this.fnv_init ()

IF a_i_max_sets < 0 THEN
	RETURN
END IF

IF a_i_max_sets = i_i_max_sets THEN
	RETURN
END IF


// Set the value of the instance variable and preallocate the last
// array entry if it exceeds the current array upper bound.

i_i_max_sets = a_i_max_sets

IF i_i_max_sets > UpperBound (i_strnv_set) THEN
	i_strnv_set [i_i_max_sets].s_set_name = ""
END IF
end subroutine

public subroutine fnv_set_max_members (integer a_i_max_members);// Set the maximum number of members per set that will be managed by
// this object.

Integer i_idx
GraphicObject go_empty

this.fnv_init ()


// Bail out if a negative value is passed or no change is indicated.

IF a_i_max_members < 0 THEN
	RETURN
END IF

IF i_i_max_members = a_i_max_members THEN
	RETURN
END IF


// Set the value of the instance variable.  Spin through all used sets
// and preallocate the last entry if the new value exceeds the current
// upper bound.

i_i_max_members = a_i_max_members

FOR i_idx = 1 TO UpperBound (i_strnv_set)

	IF Len (i_strnv_set [i_idx].s_set_name) > 0 THEN
		IF i_i_max_members > UpperBound (i_strnv_set [i_idx].strnv_member) THEN
			i_strnv_set [i_idx].strnv_member [i_i_max_members].go_member = go_empty
		END IF
	END IF

NEXT
end subroutine

public function integer fnv_create_set (string a_s_set_name);// Creates an object set.
// Return values:
//  1	Created successfully
// -1	Invalid name
// -2	Set already exists
// -3	No slots available for creating a new set

Integer i_idx_set, i_idx_avail
GraphicObject go_empty

this.fnv_init ()


// Bail out if no set name was passed.

IF Len (Trim (a_s_set_name)) = 0 THEN
	RETURN -1
END IF


// Loop through each set looking for an empty slot and to verify that
// the set doesn't already exist.

a_s_set_name = Lower (Trim (a_s_set_name))

FOR i_idx_set = 1 TO i_i_max_sets
	// Check for empty set if we're still looking for an empty slot.
	IF i_idx_avail < 1 THEN
		IF Len (i_strnv_set [i_idx_set].s_set_name) > 0 THEN
		ELSE
			i_idx_avail = i_idx_set		// found an empty slot
		END IF
	END IF
	// Check each entry for duplicates.
	IF i_strnv_set [i_idx_set].s_set_name = a_s_set_name THEN
		RETURN -2
	END IF
NEXT


// Bail out if no slot is available for a new set.

IF i_idx_avail < 1 THEN
	RETURN -3
END IF


// Create the set, access it last entry and return the index to its slot.

i_strnv_set [i_idx_avail].s_set_name = a_s_set_name
i_strnv_set [i_idx_avail].strnv_member [i_i_max_members].go_member = go_empty

RETURN i_idx_set
end function

public function integer fnv_get_set_indx (string a_s_set_name);// Returns:
//	 n	Index in array of sets occupied by set passed as a parameter
//	-1	Set not found

Integer i_idx_set


// Bail out of no set name was passed.

IF Len (Trim (a_s_set_name)) = 0 THEN
	RETURN -1
END IF


// Loop through each set looking for the set passed as a parameter.

a_s_set_name = Lower (Trim (a_s_set_name))

FOR i_idx_set = 1 TO i_i_max_sets
	IF i_strnv_set [i_idx_set].s_set_name = a_s_set_name THEN
		RETURN i_idx_set
	END IF
NEXT


// Set not found.

RETURN -1
end function

public function integer fnv_destroy_set (string a_s_set_name);// Remove the set identified by the passed name.
// Returns:
//	 1	Destroyed successfully
//	-1	Set not found

Integer i_idx_set
strnv_member strnv_empty []

this.fnv_init ()


// Get set index.  Bail out if set not found.

i_idx_set = this.fnv_get_set_indx (a_s_set_name)

IF i_idx_set < 0 THEN
	RETURN -1
END IF


// Remove set entry from set array.

i_strnv_set [i_idx_set].s_set_name = ""
i_strnv_set [i_idx_set].strnv_member = strnv_empty

RETURN 1
end function

public function boolean fnv_is_set_valid (string a_s_set_name);// Returns:
//	 TRUE	Set passed as a parameter exists
//	FALSE	Set not found

Integer i_idx_set

this.fnv_init ()


// Get set index.  Bail out if set not found.

i_idx_set = this.fnv_get_set_indx (a_s_set_name)

IF i_idx_set < 0 THEN
	RETURN FALSE
END IF

RETURN TRUE
end function

public function integer fnv_get_set_size (string a_s_set_name);// Returns:
//	 n	Number of members in set passed as a parameter
//	-1	Set not found

Integer i_idx_set, i_idx_mem, i_count

this.fnv_init ()


// Get set index.  Bail out if set not found.

i_idx_set = this.fnv_get_set_indx (a_s_set_name)

IF i_idx_set < 0 THEN
	RETURN -1
END IF


// Loop through each member of the set counting valid members.

FOR i_idx_mem = 1 TO i_i_max_members
	IF IsValid (i_strnv_set [i_idx_set].strnv_member [i_idx_mem].go_member) THEN
		i_count ++
	END IF
NEXT

RETURN i_count
end function

public function integer fnv_get_set_handles (string a_s_set_name, ref long a_l_handle[]);// Function to return the Windows handles of all the members of the
// set passed as an argument.
// Returns:
//	 n	Number of handles returned in the reference array
//	-1	Set not found

Integer i_idx_set, i_idx_mem, i_cnt

this.fnv_init ()


// Get set index.  Bail out if set not found.

i_idx_set = this.fnv_get_set_indx (a_s_set_name)

IF i_idx_set < 0 THEN
	RETURN -1
END IF


// Loop through each member of the set loading the array passed by
// reference with the handles of those valid members.

FOR i_idx_mem = 1 TO i_i_max_members
	IF IsValid (i_strnv_set [i_idx_set].strnv_member [i_idx_mem].go_member) THEN
		i_cnt ++
		a_l_handle [i_cnt] = Handle (i_strnv_set [i_idx_set].strnv_member [i_idx_mem].go_member)
	END IF
NEXT

RETURN i_cnt
end function

public function integer fnv_get_set_members (string a_s_set_name, ref graphicobject a_go_member[]);// Function to return all the members of the set passed as an argument.
// Returns:
//	 n	Number of members returned
//	-1	Set not found

Integer i_idx_set, i_idx_mem, i_cnt

this.fnv_init ()


// Get set index.  Bail out if set not found.

i_idx_set = this.fnv_get_set_indx (a_s_set_name)

IF i_idx_set < 0 THEN
	RETURN -1
END IF


// Loop through each member of the set loading the array passed by
// reference with the handles of those valid members.

FOR i_idx_mem = 1 TO i_i_max_members
	IF IsValid (i_strnv_set [i_idx_set].strnv_member [i_idx_mem].go_member) THEN
		i_cnt ++
		a_go_member [i_cnt] = i_strnv_set [i_idx_set].strnv_member [i_idx_mem].go_member
	END IF
NEXT

RETURN i_cnt
end function

public function integer fnv_enter_set (string a_s_set_name, graphicobject a_go_member, boolean a_b_active);// Return codes:
//	 1	Object successfully entered
//	-1	Set not found
//	-2	Object is already in the set
//	-3	No empty slots are available in the set
//	-4	Object is not valid

Integer i_idx_set, i_idx_mem, i_idx_avail	

this.fnv_init ()


// Bail out if no object was passed.

IF NOT IsValid (a_go_member) THEN
	RETURN -4
END IF


// Get set index.  Bail out if set not found.

i_idx_set = this.fnv_get_set_indx (a_s_set_name)

IF i_idx_set < 0 THEN
	RETURN -1
END IF


// Loop through each member looking for an empty slot and to verify
// that the member doesn't already exist in the set.

FOR i_idx_mem = 1 TO i_i_max_members
	// Check for empty slot if we're still looking for a slot.
	IF i_idx_avail < 1 THEN
		IF NOT IsValid (i_strnv_set [i_idx_set].strnv_member [i_idx_mem].go_member) THEN
			i_idx_avail = i_idx_mem		// Found an empty slot
		END IF
	END IF
	// Check for duplicate object.
	IF i_strnv_set [i_idx_set].strnv_member [i_idx_mem].go_member = a_go_member THEN
		RETURN -2
	END IF
NEXT


// Bail out if no slot is available in the set.

IF i_idx_avail < 1 THEN
	RETURN -3
END IF


// Enter the object passed as a parameter into the set along with the
// notify option passed as a parameter.

i_strnv_set [i_idx_set].strnv_member [i_idx_avail].go_member = a_go_member
i_strnv_set [i_idx_set].strnv_member [i_idx_avail].b_active = a_b_active

RETURN 1
end function

public function graphicobject fnv_get_set_member (string a_s_set_name, long a_l_handle);// Return the object from the set passed as a parameter whose Windows
// handle is that passed as a parameter.

Integer i_idx_set, i_idx_mem
GraphicObject go_empty

this.fnv_init ()


// Get set index.  Bail out if set not found.

i_idx_set = this.fnv_get_set_indx (a_s_set_name)

IF i_idx_set < 0 THEN
	RETURN go_empty
END IF


// Loop through each member of the set looking for the member whose
// Windows handle is that passed as a parameter.

FOR i_idx_mem = 1 TO i_i_max_members
	IF IsValid (i_strnv_set [i_idx_set].strnv_member [i_idx_mem].go_member) THEN
		IF a_l_handle = Handle (i_strnv_set [i_idx_set].strnv_member [i_idx_mem].go_member) THEN
			RETURN i_strnv_set[i_idx_set].strnv_member[i_idx_mem].go_member
		END IF
	END IF
NEXT


// Member not found.

RETURN go_empty
end function

public function integer fnv_set_active (string a_s_set_name, graphicobject a_go_member, boolean a_b_active);// Set the value of the 'active' instance variable for the passed member
// of the set identified by the passed name.
// Returns:
//	 1	Active status successfully changed
//	-1	Set or member not found

Integer i_idx_set, i_idx_mem

this.fnv_init ()


// Get set index.  Bail out if set not found.

i_idx_set = this.fnv_get_set_indx (a_s_set_name)

IF i_idx_set < 0 THEN
	RETURN -1
END IF


// Loop through each member of the set looking for the member with the
// object passed as a parameter and change its active status to that
// passed as a parameter.

FOR i_idx_mem = 1 TO i_i_max_members
	IF IsValid (i_strnv_set [i_idx_set].strnv_member [i_idx_mem].go_member) THEN
		IF i_strnv_set [i_idx_set].strnv_member [i_idx_mem].go_member = a_go_member THEN
			i_strnv_set [i_idx_set].strnv_member [i_idx_mem].b_active = a_b_active
			RETURN 1
		END IF
	END IF
NEXT


// Member not found.

RETURN -1
end function

public function integer fnv_leave_set (string a_s_set_name, graphicobject a_go_member);// Returns:
//	 1	Member was successfully removed from the set
//	-1	Set or member not found

Integer i_idx_set, i_idx_mem
GraphicObject go_empty

this.fnv_init ()


// Get set index.  Bail out if set not found.

i_idx_set = this.fnv_get_set_indx (a_s_set_name)

IF i_idx_set < 0 THEN
	RETURN -1
END IF


// Loop through each member of the set looking for the window passed
// as a parameter and remove it from the set.

FOR i_idx_mem = 1 TO i_i_max_members
	IF IsValid (i_strnv_set [i_idx_set].strnv_member [i_idx_mem].go_member) THEN
		IF i_strnv_set [i_idx_set].strnv_member [i_idx_mem].go_member = a_go_member THEN
			i_strnv_set [i_idx_set].strnv_member [i_idx_mem].go_member = go_empty
			i_strnv_set [i_idx_set].strnv_member [i_idx_mem].b_active = FALSE
			RETURN 1
		END IF
	END IF
NEXT


// Member not found.

RETURN -1
end function

public subroutine fnv_notify_set (string a_s_set_name, string a_s_event, str_pass a_str_pass);// Notify other members of the set passed as a parameter by triggering
// the event passed as a parameter with the passing structure passed
// as a parameter.

Integer i_idx_set, i_idx_mem

this.fnv_init ()


// The default event is "ue_notify".

IF Len (Trim (a_s_event)) = 0 THEN
	a_s_event = "ue_notify"
ELSE
	a_s_event = Lower (Trim (a_s_event))
END IF


// Get set index.  Bail out if set not found.

i_idx_set = this.fnv_get_set_indx (a_s_set_name)

IF i_idx_set < 0 THEN
	RETURN
END IF


// Loop through the members of the set triggering event a_s_event
// with a_str_pass for each valid member.

a_str_pass.s_action = a_s_set_name

FOR i_idx_mem = 1 TO i_i_max_members
	IF IsValid (i_strnv_set [i_idx_set].strnv_member [i_idx_mem].go_member) THEN
		IF i_strnv_set [i_idx_set].strnv_member [i_idx_mem].b_active THEN
			this.fnv_set_str_pass (a_str_pass)
			i_strnv_set [i_idx_set].strnv_member [i_idx_mem].go_member.TriggerEvent (a_s_event)
		END IF
	END IF
NEXT
end subroutine

public subroutine fnv_notify_others (string a_s_set_name, string a_s_event, str_pass a_str_pass, graphicobject a_go_member);// Notify other members of the set passed as a parameter by triggering
// the event passed as a parameter with the passing structure passed
// as a parameter.

Integer i_idx_set, i_idx_mem

this.fnv_init ()


// The default event is "ue_notify".

IF Len (Trim (a_s_event)) = 0 THEN
	a_s_event = "ue_notify"
ELSE
	a_s_event = Lower (Trim (a_s_event))
END IF


// Get set index.  Bail out if set not found.

i_idx_set = this.fnv_get_set_indx (a_s_set_name)

IF i_idx_set < 0 THEN
	RETURN
END IF


// Loop through the members of the set triggering event a_s_event
// with a_str_pass for each valid member other than the object
// passed as a parameter.

a_str_pass.s_action = a_s_set_name

FOR i_idx_mem = 1 TO i_i_max_members
	IF IsValid (i_strnv_set [i_idx_set].strnv_member [i_idx_mem].go_member) THEN
		IF i_strnv_set [i_idx_set].strnv_member [i_idx_mem].go_member <> a_go_member AND &
			i_strnv_set [i_idx_set].strnv_member [i_idx_mem].b_active THEN
			this.fnv_set_str_pass (a_str_pass)
			i_strnv_set [i_idx_set].strnv_member [i_idx_mem].go_member.TriggerEvent (a_s_event)
		END IF
	END IF
NEXT
end subroutine

public subroutine fnv_show_set (string a_s_set_name, boolean a_b_visible);// Show/hide the object members of the set passed, based on the boolean
// passed and whether the members are active.

Integer i_idx_set, i_idx_mem

this.fnv_init ()


// Get set index.  Bail out if set not found.

i_idx_set = this.fnv_get_set_indx (a_s_set_name)

IF i_idx_set < 0 THEN
	RETURN
END IF


// Loop through the members of the set hiding/showing each active member.

FOR i_idx_mem = 1 TO i_i_max_members
	IF IsValid (i_strnv_set [i_idx_set].strnv_member [i_idx_mem].go_member) THEN
		IF i_strnv_set [i_idx_set].strnv_member [i_idx_mem].b_active THEN
			this.fnv_show_object (i_strnv_set [i_idx_set].strnv_member [i_idx_mem].go_member, &
																				a_b_visible)
		END IF
	END IF
NEXT
end subroutine

public subroutine fnv_enable_set (string a_s_set_name, boolean a_b_enabled);// Enable/disable the object members of the set passed, based on the
// boolean passed and whether the members are active.

Integer i_idx_set, i_idx_mem

this.fnv_init ()


// Get set index.  Bail out if set not found.

i_idx_set = this.fnv_get_set_indx (a_s_set_name)

IF i_idx_set < 0 THEN
	RETURN
END IF


// Loop through the members of the set enabling/disabling each active
// member.

FOR i_idx_mem = 1 TO i_i_max_members
	IF IsValid (i_strnv_set [i_idx_set].strnv_member [i_idx_mem].go_member) THEN
		IF i_strnv_set [i_idx_set].strnv_member [i_idx_mem].b_active THEN
			this.fnv_enable_object &
				(i_strnv_set [i_idx_set].strnv_member [i_idx_mem].go_member, &
																						a_b_enabled)
		END IF
	END IF
NEXT
end subroutine

protected function integer fnv_enable_object (graphicobject a_go_object, boolean a_b_enabled);// Interface with PADLock, if installed, to enable/disable passed
// GraphicObject, if possible.
// Returns:
//	 1	Object successfully enabled/disabled
//	-1	Invalid objects (can not enable/disable)

object e_type

Menu m_object
Window w_object
CheckBox cbx_object
CommandButton cb_object
PictureButton pb_object
DataWindow dw_object
DropDownListBox ddlb_object
Graph gr_object
GroupBox gb_object
ListBox lb_object
MultiLineEdit mle_object
EditMask em_object
OLEControl ole_object
Picture p_object
RadioButton rb_object
SingleLineEdit sle_object
StaticText st_object
UserObject uo_object


this.fnv_init()


// If PADLock is installed, get it to do the work.

IF g_nv_components.fnv_is_library_installed ("pl_core") THEN
	g_nv_security.function dynamic fnv_enable_object (a_go_object, a_b_enabled)
	RETURN 1
END IF


// Cast and set enabled attribute of object, based on type.

e_type = a_go_object.TypeOf ()

CHOOSE CASE e_type

	CASE Menu!

		m_object = a_go_object
		m_object.enabled = a_b_enabled
		RETURN 1

	CASE Window!

		w_object = a_go_object
		w_object.enabled = a_b_enabled
		RETURN 1

	CASE CheckBox!

		cbx_object = a_go_object
		cbx_object.enabled = a_b_enabled
		RETURN 1

	CASE CommandButton!

		cb_object = a_go_object
		cb_object.enabled = a_b_enabled
		RETURN 1

	CASE PictureButton!

		pb_object = a_go_object
		pb_object.enabled = a_b_enabled
		RETURN 1

	CASE DataWindow!

		dw_object = a_go_object
		dw_object.enabled = a_b_enabled
		RETURN 1

	CASE DropDownListBox!

		ddlb_object = a_go_object
		ddlb_object.enabled = a_b_enabled
		RETURN 1

	CASE Graph!

		gr_object = a_go_object
		gr_object.enabled = a_b_enabled
		RETURN 1

	CASE GroupBox!

		gb_object = a_go_object
		gb_object.enabled = a_b_enabled
		RETURN 1

	CASE ListBox!

		lb_object = a_go_object
		lb_object.enabled = a_b_enabled
		RETURN 1

	CASE MultiLineEdit!

		mle_object = a_go_object
		mle_object.enabled = a_b_enabled
		RETURN 1

	CASE EditMask!

		em_object = a_go_object
		em_object.enabled = a_b_enabled
		RETURN 1

	CASE OLEControl!

		ole_object = a_go_object
		ole_object.enabled = a_b_enabled
		RETURN 1

	CASE Picture!

		p_object = a_go_object
		p_object.enabled = a_b_enabled
		RETURN 1

	CASE RadioButton!

		rb_object = a_go_object
		rb_object.enabled = a_b_enabled
		RETURN 1

	CASE SingleLineEdit!

		sle_object = a_go_object
		sle_object.enabled = a_b_enabled
		RETURN 1

	CASE StaticText!

		st_object = a_go_object
		st_object.enabled = a_b_enabled
		RETURN 1

	CASE UserObject!

		uo_object = a_go_object
		uo_object.enabled = a_b_enabled
		RETURN 1

	CASE ELSE

		RETURN 1

END CHOOSE
end function

protected subroutine fnv_init ();// This is a workaround because PowerBuilder doesn't fire the constructor
// event on a message object.  This function must be called MANUALLY.

IF NOT i_b_initialized THEN
	this.TriggerEvent ("constructor")
END IF
end subroutine

protected subroutine fnv_show_object (graphicobject a_go_object, boolean a_b_enabled);// Interface with PADLock, if installed, to show/hide the passed
// GraphicObject, if possible.

this.fnv_init ()

// If PADLock is installed, get it to do the work.

IF g_nv_components.fnv_is_library_installed ("pl_core") THEN
	g_nv_security.function dynamic fnv_show_object (a_go_object, a_b_enabled)
	RETURN
END IF


// Show or hide the passed GraphicObject.

a_go_object.visible = a_b_enabled
end subroutine

on constructor;// PowerBuilder workaround.

i_b_initialized = TRUE


// Set the default max for sets and members to 15.

this.fnv_set_max_members (15)

this.fnv_set_max_sets (15)
end on

on nv_message_pt.create
call message::create
TriggerEvent( this, "constructor" )
end on

on nv_message_pt.destroy
call message::destroy
TriggerEvent( this, "destructor" )
end on

