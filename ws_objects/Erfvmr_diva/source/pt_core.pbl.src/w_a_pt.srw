$PBExportHeader$w_a_pt.srw
$PBExportComments$[MAIN] Ancêtre des fenêtres
forward
global type w_a_pt from Window
end type
end forward

global type w_a_pt from Window
int X=769
int Y=461
int Width=1377
int Height=997
boolean TitleBar=true
boolean ControlMenu=true
boolean MinBox=true
boolean MaxBox=true
boolean Resizable=true
event we_syscommand pbm_syscommand
event we_nchittest pbm_nchittest
event ue_about ( unsignedlong wparam,  long lparam )
event ue_add ( unsignedlong wparam,  long lparam )
event ue_browse ( unsignedlong wparam,  long lparam )
event ue_cancel ( unsignedlong wparam,  long lparam )
event ue_clear ( unsignedlong wparam,  long lparam )
event ue_close ( unsignedlong wparam,  long lparam )
event ue_copy ( unsignedlong wparam,  long lparam )
event ue_cut ( unsignedlong wparam,  long lparam )
event ue_delete ( unsignedlong wparam,  long lparam )
event ue_detect_change ( unsignedlong wparam,  long lparam )
event ue_empty ( unsignedlong wparam,  long lparam )
event ue_fileopen ( unsignedlong wparam,  long lparam )
event ue_filter ( unsignedlong wparam,  long lparam )
event ue_help ( unsignedlong wparam,  long lparam )
event ue_init ( unsignedlong wparam,  long lparam )
event ue_insert ( unsignedlong wparam,  long lparam )
event ue_nav ( unsignedlong wparam,  long lparam )
event ue_nav_add_menu ( unsignedlong wparam,  long lparam )
event ue_navigation ( unsignedlong wparam,  long lparam )
event ue_new ( unsignedlong wparam,  long lparam )
event ue_next ( unsignedlong wparam,  long lparam )
event ue_notify ( unsignedlong wparam,  long lparam )
event ue_ok ( unsignedlong wparam,  long lparam )
event ue_panel ( unsignedlong wparam,  long lparam )
event ue_paste ( unsignedlong wparam,  long lparam )
event ue_presave ( unsignedlong wparam,  long lparam )
event ue_print ( unsignedlong wparam,  long lparam )
event ue_printpreview ( unsignedlong wparam,  long lparam )
event ue_printsetup ( unsignedlong wparam,  long lparam )
event ue_prior ( unsignedlong wparam,  long lparam )
event ue_remove ( unsignedlong wparam,  long lparam )
event ue_retrieve ( unsignedlong wparam,  long lparam )
event ue_save ( unsignedlong wparam,  long lparam )
event ue_saveas ( unsignedlong wparam,  long lparam )
event ue_search ( unsignedlong wparam,  long lparam )
event ue_selectall ( unsignedlong wparam,  long lparam )
event ue_selectiondialog ( unsignedlong wparam,  long lparam )
event ue_sort ( unsignedlong wparam,  long lparam )
event ue_undo ( unsignedlong wparam,  long lparam )
event ue_reserved4powertool ( unsignedlong wparam,  long lparam )
event we_command pbm_command
end type
global w_a_pt w_a_pt

type prototypes

end prototypes

type variables
PROTECTED:

w_fa i_w_frame			// MDI Frame which owns this sheet

nv_transaction i_tr_sql		// local transaction

String i_s_basetitle			// base title for window

Boolean i_b_sheet			// whether Window is a MDI sheet
Boolean i_b_canceled		// user cancels action
Boolean i_b_update_status		// update successful

str_pass i_str_pass			// structure passed on window open
str_pass i_str_notify			// structure passed on task notify
str_nav i_str_nav			// structure passed by NAV

nv_win_proto i_nv_win_proto		// non visual object window protocol

String i_s_microhelp = "Ready"		// Default MicroHelp for Window focus
String i_s_helpkey			// Default key into Help file
String i_s_reason_msg = ""		// Default message for fw_ask_update()
	
// Window parent/child enabling variables
w_a i_w_parent			// Parent window ( logical)
w_a i_w_child[]			// Child windows ( logical)

end variables

forward prototypes
public subroutine fw_set_basetitle (string a_s_title)
public function nv_transaction fw_get_trans ()
public function string fw_get_basetitle ()
public subroutine fw_set_microhelp (string a_s_microhelp)
public subroutine fw_set_helpkey (string a_s_helpkey)
public function string fw_get_microhelp ()
public function string fw_get_helpkey ()
public subroutine fw_set_key (string a_s_key)
public function string fw_get_key ()
public subroutine fw_center_window ()
public subroutine fw_set_parent (w_a a_w_parent)
public function boolean fw_close_children ()
public function integer fw_add_child (w_a a_w_child)
public function integer fw_notify_siblings (w_a a_w_sheet, string a_s_event, str_pass a_str_pass)
public function integer fw_notify_window (w_a a_w_win, string a_s_event, str_pass a_str_pass)
public function integer fw_notify_children (string a_s_event, str_pass a_str_pass)
public function w_a fw_get_parent ()
public function integer fw_notify_parent (string a_s_event, str_pass a_str_pass)
public function integer fw_ask_update (string a_s_reason_msg)
public subroutine fw_set_trans (readonly nv_transaction a_trans)
end prototypes

event we_syscommand;// On a control menu close (ONLY), trigger either "ue_cancel" or
// "ue_close", depending on the type of the window.

IF g_nv_env.fnv_control_menu_close (message) THEN
	IF this.WindowType = Response! THEN
		this.PostEvent ("ue_cancel")
	ELSE
		this.PostEvent ("ue_close")
	END IF
	message.processed = TRUE	// tell Windows we took care of it
END IF
end event

on we_nchittest;// Set MicroHelp.

IF IsValid (g_w_frame) THEN
	g_w_frame.fw_setmicrohelp (this.fw_get_microhelp ())
END IF
end on

on ue_help;g_nv_msg_mgr.fnv_process_msg ("pt", "Help Not Available", "", "", 0, 0)

end on

event ue_nav;// Call the NAV manager, if it exists, to launch the next Window.
// Two assumptions are made:
//		1) Any items to be passed to the Window to open are loaded
//			into str_pass on the message object
//		2) The key of the sheet to be opened is in message.stringparm

String s_sheet_key
Window w_child
str_pass str_pass


// Bail out if NAV isn't enabled.

IF NOT IsValid (g_nv_nav_manager) THEN
	RETURN
END IF


// Retrieve the sheet key and str_pass from the message object.

s_sheet_key = message.stringparm

str_pass = message.fnv_get_str_pass ()

message.fnv_clear_str_pass ()


// Call the NAV manager to select the next Window to navigate to.

w_child = g_nv_nav_manager.FUNCTION DYNAMIC fnv_select_next_logical &
										(i_str_nav.l_node_skey, s_sheet_key, str_pass)


// Register the opened Window as a child.

IF IsValid (w_child) THEN
	this.fw_add_child (w_child)
END IF
end event

event ue_nav_add_menu;// Add menu to MDI Frame.

str_pass str_pass


// Bail out if NAV isn't enabled.

IF NOT IsValid (g_nv_nav_manager) THEN
	RETURN
END IF


// Add menu to the frame if this is a sheet on the frame.

IF IsValid (i_w_frame) THEN
	this.SetFocus ()
	IF i_w_frame.GetActiveSheet () = this THEN
		g_nv_nav_manager.FUNCTION DYNAMIC fnv_add_menu_to_window (i_w_frame)
	END IF
END IF
end event

on ue_notify;// Save passed structure.

i_str_notify = message.fnv_get_str_pass ()

message.fnv_clear_str_pass ()
end on

on ue_printsetup;PrintSetup ()
end on

event we_command;// Call NAV manager to open Logical Window associated with clicked
// menu item (node).

UInt ui_menu_key


// Bail out if this is a sheet.

IF i_b_sheet THEN
	RETURN
END IF


// Bail out if NAV isn't enabled.

IF NOT IsValid (g_nv_nav_manager) THEN
	RETURN
END IF

// Save the contents of the message object.

message.fnv_push ()

// Ask NAV manager whether clicked item is a NAV item.

ui_menu_key = message.wordparm

IF NOT g_nv_env.fnv_user_wordparm (message) THEN
	RETURN
END IF

g_nv_nav_manager.FUNCTION DYNAMIC fnv_event_we_command (ui_menu_key)

// Restore the contents of the message object.

message.fnv_pop ()
end event

public subroutine fw_set_basetitle (string a_s_title);// Set instance variable to value passed.

i_s_basetitle = a_s_title
end subroutine

public function nv_transaction fw_get_trans ();// Return value of instance variable.

RETURN i_tr_sql
end function

public function string fw_get_basetitle ();// Return value of instance variable.

RETURN i_s_basetitle
end function

public subroutine fw_set_microhelp (string a_s_microhelp);// Set value of instance variable to value passed.

i_s_microhelp = a_s_microhelp
end subroutine

public subroutine fw_set_helpkey (string a_s_helpkey);// Set value of instance variable to value passed.

i_s_helpkey = a_s_helpkey
end subroutine

public function string fw_get_microhelp ();// Return value of instance variable.

RETURN i_s_microhelp
end function

public function string fw_get_helpkey ();// Return value of instance variable.

RETURN i_s_helpkey
end function

public subroutine fw_set_key (string a_s_key);// Set the key of the sheet in the window manager.


// Make sure the frame exists!

IF NOT IsValid (i_w_frame) THEN
	RETURN
END IF


// Set the sheet in the window manager to the value passed.

i_w_frame.fw_set_sheet_key (i_nv_win_proto.fnv_get_win_idx (), a_s_key)
end subroutine

public function string fw_get_key ();// Return the value of the sheet for this sheet in the window manager.


// Make sure the frame exists!

IF NOT IsValid (i_w_frame) THEN
	RETURN ""
END IF


// Return the key for this sheet.

RETURN i_w_frame.fw_get_sheet_key (i_nv_win_proto.fnv_get_win_idx ())
end function

public subroutine fw_center_window ();//Center Window On Screen

Integer i_x, i_y
Environment env

//What's The Screen's Dimensions

GetEnvironment ( env )

i_x = ( PixelsToUnits ( env.ScreenWidth,  XPIXELSTOUNITS! )/2 )&
	 	- ( this.Width/2 )
i_y = ( PixelsToUnits ( env.ScreenHeight, YPIXELSTOUNITS! )/2 )&
		 - ( this.Height/2 )

this.Move ( i_x , i_y )
end subroutine

public subroutine fw_set_parent (w_a a_w_parent);// Set instance variable to value passed.

i_w_parent = a_w_parent
end subroutine

public function boolean fw_close_children ();// Close all logical children in array i_w_child.  Return FALSE if
// any sheet was not successfully closed.

Integer i_idx, i_child_count


// Close all children.

i_child_count = UpperBound (i_w_child)

if i_child_count > 0 then
	FOR i_idx = 1 TO i_child_count
		IF IsValid (i_w_child [i_idx]) THEN
			Close (i_w_child [i_idx])
			IF IsValid (i_w_child [i_idx]) THEN
				RETURN FALSE
			END IF
		END IF
	NEXT
END IF

RETURN TRUE
end function

public function integer fw_add_child (w_a a_w_child);// Add a_w_child to the logical child array.

Integer i_idx


// Verify that sheet is valid.

IF NOT IsValid (a_w_child) THEN
	RETURN -1
END IF


// Add child window to next available slot in the array and return
// the index used.

FOR i_idx = 1 TO UpperBound (i_w_child)
	IF NOT IsValid (i_w_child [i_idx]) THEN
		i_w_child [i_idx] = a_w_child
		RETURN i_idx
	END IF
NEXT


// Not slots are available so add one.

i_idx ++

i_w_child [i_idx] = a_w_child

RETURN i_idx
end function

public function integer fw_notify_siblings (w_a a_w_sheet, string a_s_event, str_pass a_str_pass);// Notify valid windows in array i_w_child other than current window.


Integer i_rc, i_idx


// Notify all valid windows in the child array and return the lowest
// return code.

i_rc = 1

FOR i_idx = 1 TO UpperBound (i_w_child)
	IF IsValid (i_w_child [i_idx]) THEN
		IF i_w_child [i_idx] <> this THEN
			IF fw_notify_window (i_w_child [i_idx], a_s_event, a_str_pass) < 0 THEN
				i_rc = -1
			END IF
		END IF
	END IF
NEXT


// Return the lowest return code.

RETURN i_rc
end function

public function integer fw_notify_window (w_a a_w_win, string a_s_event, str_pass a_str_pass);// Trigger a_s_event on a_w_win and pass a_str_pass.


// Default event is "ue_notify"

IF Len (Trim (a_s_event)) < 1 THEN
	a_s_event = "ue_notify"
END IF


// Trigger a_s_event on a_w_win, if it exists.

IF IsValid (a_w_win) THEN
	message.fnv_set_str_pass (a_str_pass)
	RETURN a_w_win.TriggerEvent (a_s_event)
ELSE
	RETURN -1
END IF
end function

public function integer fw_notify_children (string a_s_event, str_pass a_str_pass);// Notify valid windows in array i_w_child.


Integer i_rc, i_idx


// Notify all valid windows in the child array and return the lowest
// return code.

i_rc = 1

FOR i_idx = 1 TO UpperBound (i_w_child)
	IF IsValid (i_w_child [i_idx]) THEN
		IF fw_notify_window (i_w_child [i_idx], a_s_event, a_str_pass) < 0 THEN
			i_rc = -1
		END IF
	END IF
NEXT


// Return the lowest return code.

RETURN i_rc
end function

public function w_a fw_get_parent ();// Return value of instance variable

RETURN i_w_parent
end function

public function integer fw_notify_parent (string a_s_event, str_pass a_str_pass);// Trigger a_s_event on logical parent and pass a_str_pass.

RETURN this.fw_notify_window (i_w_parent, a_s_event, a_str_pass)
end function

public function integer fw_ask_update (string a_s_reason_msg);// Possible return codes and their general meaning in context:
//  1 - "Yes" -	Database was successfully updated
//  2 - "No" -		Database could not be updated, and the user indicated
//						that pending updates should be discarded
//  3 - "Can" -	Database could not be updated and the user indicated
//						that the update operation should be canceled without 
//						discarding the data.

Integer i_return_code


// Trigger "ue_detect_change" and examine returned message.doubleparm.
// 1 will indicate that changes are pending.

i_s_reason_msg = a_s_reason_msg

this.TriggerEvent ("ue_detect_change")

i_return_code = message.doubleparm

IF i_return_code <> 1 THEN
	RETURN i_return_code		// no changes to save
END IF


// Changes are pending so, ask the user what to do (e.g., "Close anyway?",
// "Open anyway", or (default) "Proceed anyway?"

i_return_code = g_nv_msg_mgr.fnv_process_msg ("pt", "Save Changes?", &
																"", this.title, 0, 0)

CHOOSE CASE i_return_code

	CASE 2, 3

		RETURN i_return_code

	CASE 1

		this.TriggerEvent ("ue_save")

		IF NOT i_b_update_status THEN
			RETURN 3		// Save was not successful
		END IF

		RETURN 1			// Success!
		
	CASE ELSE
		
		RETURN 3			//PROCESS MESSAGE FAILED - ERROR ALREADY NOTED

END CHOOSE
end function

public subroutine fw_set_trans (readonly nv_transaction a_trans);// Set the transaction to be associated with this window to the
// transaction passed.

i_tr_sql = a_trans

end subroutine

event close;// Clean up user objects and dynamic menus.

Integer i_display_mode


// Clean up NAV dynamic menus.

IF IsValid (g_nv_nav_manager) THEN
	i_display_mode = g_nv_nav_manager.FUNCTION DYNAMIC fnv_get_display_mode ()
	IF i_display_mode = 3 THEN		// Dynamic menu style
		IF i_b_sheet THEN				// Menu is on MDI Frame
			IF IsValid (menuid) THEN
				this.SetFocus ()
				g_nv_nav_manager.FUNCTION DYNAMIC fnv_remove_menu_from_window (i_w_frame)
			END IF
		ELSE								// Menu is on the Window
			g_nv_nav_manager.FUNCTION DYNAMIC fnv_remove_menu_from_window (this)
		END IF
	END IF
END IF


// Non-visual will clean up window manager if this is MDI.

i_nv_win_proto.fnv_closing ()

IF IsValid (i_nv_win_proto) THEN
	DESTROY i_nv_win_proto
END IF
end event

event open;// Any code that should be executed before the window is displayed
// goes here in the open event (e.g. changing the window's title).

Integer i_display_style
Window w_this

w_this = this


// Set the default transaction.

this.fw_set_trans (SQLCA)


// Extract str_pass structure if one is there.  Examine powerobjectparm
// for backward compatibility.

i_str_pass = message.fnv_get_str_pass ()

message.fnv_clear_str_pass ()

IF IsValid (message.powerobjectparm) THEN
	IF message.powerobjectparm.ClassName () = "str_pass" THEN
		i_str_pass = message.powerobjectparm
	END IF
END IF


// Extract str_nav structure if one is there.

i_str_nav = message.fnv_get_str_nav ()

message.fnv_clear_str_nav ()


// Reset the transaction object if a transaction was passed

IF IsValid (i_str_pass.tr_trans) THEN
	this.fw_set_trans (i_str_pass.tr_trans)
END IF


// Instantiate the MDI non-visual if this window is a sheet.

IF IsValid (i_str_pass.w_frame) AND &
	i_str_pass.i_idx > 0 THEN
	i_b_sheet = TRUE
	i_w_frame = i_str_pass.w_frame
	i_nv_win_proto = CREATE nv_win_proto_mdi
ELSE
	i_b_sheet = FALSE
	i_nv_win_proto = CREATE nv_win_proto
END IF


// Non-visual will coordinate with window manager if this is MDI.

i_nv_win_proto.fnv_opening (w_this, i_str_pass)


// Interface with PADLock, if installed.

IF IsValid (g_nv_security) THEN
	g_nv_security.FUNCTION DYNAMIC fnv_secure_window (this)
END IF


// Extract logical parent from i_str_pass

IF IsValid (i_str_pass.po_caller) THEN
	IF i_str_pass.po_caller.TypeOf () = Window! THEN
		this.fw_set_parent (i_str_pass.po_caller)
	END IF
END IF


// Interface with NAV and save instance of NAV manager.  Build dynamic
// NAV menu if style is set.

IF IsValid (g_nv_nav_manager) THEN
	i_display_style = g_nv_nav_manager.FUNCTION DYNAMIC fnv_get_display_mode ()
	IF i_display_style = 3 THEN		// Dynamic menu style
		IF i_b_sheet THEN					// Menu is added to Frame menu
			IF IsValid (menuid) THEN
				this.PostEvent ("ue_nav_add_menu")
			END IF
		ELSE								// Menu is added to Window menu
			g_nv_nav_manager.FUNCTION DYNAMIC fnv_add_menu_to_window (this)
		END IF
	END IF
END IF


// Any code that should be executed after the window is displayed
// goes in the "ue_init" event (e.g. dynamically populating a list
// box).

this.PostEvent ("ue_init")
end event

on w_a_pt.create
end on

on w_a_pt.destroy
end on

on closequery;// Close children and continue with the close only if all children
// were successfully closed.

IF this.fw_close_children () THEN
	RETURN
END IF

message.returnvalue = 1
end on

