$PBExportHeader$w_fa_pt.srw
$PBExportComments$[MDI/MICROHELP] Ancêtre des fenêtre frame MDI
forward
global type w_fa_pt from window
end type
type mdi_1 from mdiclient within w_fa_pt
end type
end forward

shared variables
Integer s_i_frame_cnt	// Number of open frames
end variables

global type w_fa_pt from window
integer x = 768
integer y = 460
integer width = 1376
integer height = 996
boolean titlebar = true
string menuname = "m_frame_pt"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
windowtype windowtype = mdihelp!
windowstate windowstate = maximized!
long backcolor = 276856960
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
mdi_1 mdi_1
end type
global w_fa_pt w_fa_pt

type prototypes

end prototypes

type variables
PROTECTED:

nv_transaction i_tr_sql		// Transaction object for this window

str_pass i_str_pass			// Inter-window communication structure

Integer i_i_next_idx = 1		// Next index of i_str_open window array

Integer i_i_sheet_cnt = 0		// Number of sheets currently open
Integer i_i_max_sheets		// Maximum number of sheets allowed to be open

arrangeopen i_e_style		// Style for arranging sheets

String i_s_microhelp = "Ready"	// Default MicroHelp for Window focus
String i_s_helpkey			// Default key into Help file

strw_open_sheets	i_str_open []	// Array of information on currently open sheets

end variables

forward prototypes
public function int fw_get_sheet_cnt ()
public subroutine  fw_set_trans (ref nv_transaction a_trans)
public function int fw_get_max_sheets ()
public function integer fw_set_max_sheets (integer a_i_max_sheets)
public function arrangeopen fw_get_style ()
public function arrangeopen fw_set_style (arrangeopen a_e_style)
public function window fw_open_sheet (string a_s_win, integer a_i_mpos, integer a_i_maxopen, str_pass a_str_pass)
public function int fw_type_cnt (string a_s_win)
public function int fw_get_next_sheet_idx ()
public function window fw_open_window (string a_s_win, str_pass a_str_pass)
public function boolean fw_is_key_open (ref window a_w_win, string a_s_key)
public function int fw_dec_sheet_cnt ()
public function int fw_inc_sheet_cnt ()
public function string fw_set_sheet_key (int a_i_idx, string a_s_key)
public function window fw_open_sheet_simple (string a_s_win, int a_i_mpos)
public function boolean fw_next_sheet (ref window a_w_sheet, ref string a_s_key)
public function boolean fw_first_sheet (ref window a_w_sheet, ref string a_s_key)
public function boolean fw_is_sheet_valid (int a_i_idx, w_a a_win)
public function boolean fw_is_key_open_any (string a_s_key)
public function boolean fw_is_key_open_class (ref window a_w_win, string a_s_classname, string a_s_key)
public function string fw_get_sheet_key (int a_i_idx)
public function int fw_get_type_cnt (string a_s_win)
public subroutine  fw_set_microhelp (string a_s_microhelp)
public subroutine  fw_set_helpkey (string a_s_helpkey)
public function string fw_get_microhelp ()
public function string fw_get_helpkey ()
public function integer fw_setmicrohelp (string a_s_microhelp)
public subroutine fw_set_title (string a_s_title)
public function window fw_get_sheet (int a_i_idx)
public function nv_transaction fw_get_trans ()
public function window fw_open_sheet_keyed (string a_s_win, integer a_i_mpos, integer a_i_maxopen, str_pass a_str_pass, string a_s_key)
public function integer fw_nav_choose_style ()
public subroutine fw_nav_set_style (integer a_i_nav_style)
public subroutine fw_nav_set_custom (string a_s_classname)
public function string fw_nav_get_custom ()
public function integer fw_nav_get_style ()
public function integer fw_nav_init (integer a_i_nav_style, integer a_i_menu_pos, nv_transaction a_tr)
public subroutine fw_nav_init (integer a_i_nav_style, integer a_i_menu_pos)
end prototypes

event we_syscommand;// On a control menu close (ONLY), trigger "ue_close".

IF g_nv_env.fnv_control_menu_close (message) THEN
	this.PostEvent ("ue_close")
	message.processed = TRUE	// tell Windows we took care of it
END IF
end event

on we_nchittest;// Set MicroHelp.

this.fw_setmicrohelp (this.fw_get_microhelp ())
end on

on ue_close;Close (this)
end on

event ue_empty;// No sheets are open, so bring up Navigation Manager's display window.

this.TriggerEvent ("ue_panel")
end event

event ue_help;// By default, no help is available.

g_nv_msg_mgr.fnv_process_msg ("pt", "Help Not Available", "", "", 0, 0)

end event

event ue_panel;// Show the NAV display window.

IF IsValid (g_nv_nav_manager) THEN
	g_nv_nav_manager.FUNCTION DYNAMIC fnv_show_display ()
END IF
end event

event we_command;// Call NAV manager to open Logical Window associated with clicked
// menu item (node).

UInt ui_menu_key


// Bail out if NAV isn't enabled.

IF NOT IsValid (g_nv_nav_manager) THEN
	RETURN
END IF


// Ask NAV manager whether clicked item is a NAV item.

ui_menu_key = message.wordparm

IF NOT g_nv_env.fnv_user_wordparm (message) THEN
	RETURN
END IF

// Save the current contents of the message object.

message.fnv_push ()


g_nv_nav_manager.FUNCTION DYNAMIC fnv_event_we_command (ui_menu_key)


// Restore the contents of the message object.

message.fnv_pop ()


end event

public function int fw_get_sheet_cnt ();// Return the number of sheets currently open.

RETURN i_i_sheet_cnt
end function

public subroutine  fw_set_trans (ref nv_transaction a_trans);// Set the transaction to be associated with this window to the
// transaction passed.

i_tr_sql = a_trans
end subroutine

public function int fw_get_max_sheets ();// Returns the maximum number of sheets allowed to be open at a time.

RETURN i_i_max_sheets
end function

public function integer fw_set_max_sheets (integer a_i_max_sheets);// Set the maximum number of sheets allowed to be open concurrently
// to the value passed.

window	w_empty



//If the requested max sheets = currently defined max sheets, return i_i_max_sheets
IF a_i_max_sheets = i_i_max_sheets THEN
	RETURN i_i_max_sheets
END IF

IF a_i_max_sheets > 0 THEN

// Requested sheets > currently defined max sheets?
	IF a_i_max_sheets > UpperBound (i_str_open) THEN

		// Reallocate memory for new max sheets
		i_str_open [a_i_max_sheets].w_sheet = w_empty

		// Set the maximum number of sheets allowed to be open concurrently
		// to the value passed.
		i_i_max_sheets = a_i_max_sheets
	END IF

	RETURN i_i_max_sheets
ELSE
	RETURN -1
END IF

end function

public function arrangeopen fw_get_style ();// Return the default open style for sheets.

RETURN i_e_style
end function

public function arrangeopen fw_set_style (arrangeopen a_e_style);// Set and return the default open style for sheets.

i_e_style = a_e_style

RETURN i_e_style
end function

public function window fw_open_sheet (string a_s_win, integer a_i_mpos, integer a_i_maxopen, str_pass a_str_pass);// Open a sheet with classname a_s_win, reserving a spot for it in
// the window manager, and pass it a_str_pass

Integer i_idx
ArrangeOpen e_style
Window w_null


SetNull (w_null)


// Verify window class being passed.

a_s_win = Trim (a_s_win)

IF Len (a_s_win) < 1 THEN
	RETURN w_null
END IF


// Open the window and return it.


// Determine whether the maximum sheet limit has been reached.  Note
// that if the value for the maximum number of sheets (i_i_max_sheets)
// is negative the limit is bypassed.

//IF i_i_max_sheets >= 0 AND &
//	i_i_sheet_cnt >= i_i_max_sheets THEN
//		g_nv_msg_mgr.fnv_process_msg ("pt", "Max Open Sheets", "", "", 0, 0)
//	RETURN w_null
//END IF


// Determine whether the maximum sheet type limit has been reached.
// Note that if the value passed for the maximum number of sheets of
// this type (a_i_maxopen) is negative the limit is bypassed.

//IF a_i_maxopen >= 0 THEN
//	IF fw_get_type_cnt (a_s_win) >= a_i_maxopen THEN
//		g_nv_msg_mgr.fnv_process_msg("pt", "Max Open Class", "", "", 0, 0)
//		RETURN w_null
//	END IF
//END IF


// Reserve a spot in the window manager

i_idx = this.fw_get_next_sheet_idx ()

IF i_idx < 1 THEN
	g_nv_msg_mgr.fnv_process_msg ("pt", "Sheet Alloc Error", "", "", 0, 0)
	RETURN w_null
END IF


// Open the sheet and pass a_str_pass.  The default open style is
// used unless a style is passed in a_str_pass.s_action.

a_str_pass.w_frame = this

a_str_pass.i_idx = i_idx

CHOOSE CASE a_str_pass.s_open_style
	CASE 'O'
		e_style = Original!
	CASE 'L'
		e_style = Layered!
	CASE 'C'
		e_style = Cascaded!
	CASE ELSE
		e_style = i_e_style
END CHOOSE

message.fnv_set_str_pass (a_str_pass)

OpenSheet (i_str_open [i_idx].w_sheet, a_s_win, this, a_i_mpos, e_style)


// Workaround for PB3.0a defect whereby a layered sheet is not sized
// properly (does not allow for MicroHelp) when it is the first sheet
// opened on an empty frame.

IF i_i_sheet_cnt = 1 AND &
	e_style = Layered! THEN
	this.ArrangeSheets (Layer!)
END IF


// Return the opened sheet.

RETURN i_str_open [i_idx].w_sheet
end function

public function int fw_type_cnt (string a_s_win);// This OBSOLETE function is here for compatibility.

RETURN fw_get_type_cnt (a_s_win)
end function

public function int fw_get_next_sheet_idx ();// Returns the next available slot in the window manager array

Integer i_idx


// Search the open sheet array for an empty slot

FOR i_idx = 1 TO i_i_max_sheets
	IF NOT IsValid (i_str_open[i_idx].w_sheet) THEN
		EXIT
	END IF
NEXT


// Return the index of the empty slot

i_str_open[i_idx].s_key = ""

RETURN i_idx
end function

public function window fw_open_window (string a_s_win, str_pass a_str_pass);// Open and return a window with the classname passed.

Window w_win


// Verify window class being passed.

a_s_win = Trim (a_s_win)

IF Len (a_s_win) < 1 THEN
	SetNull (w_win)
	RETURN w_win
END IF


// Open the window and return it.

message.fnv_set_str_pass (a_str_pass)

Open (w_win, a_s_win)

RETURN w_win
end function

public function boolean fw_is_key_open (ref window a_w_win, string a_s_key);// Determine whether a sheet with the same class as the passed
// window, having the same key in the window manager as that
// passed, is known to the window manager and, if so, pass that
// window back via the passed window (by reference).

Integer i_idx, i_upper


// Return FALSE if the passed window isn't valid.

IF NOT IsValid (a_w_win) THEN
	RETURN FALSE
END IF


// Search the open sheet structure.

FOR i_idx = 1 TO i_i_max_sheets
	IF NOT IsValid (i_str_open [i_idx].w_sheet) THEN
		CONTINUE
	END IF
	IF a_w_win.ClassName () = i_str_open [i_idx].w_sheet.ClassName () THEN
		IF a_s_key = i_str_open [i_idx].s_key THEN
			a_w_win = i_str_open [i_idx].w_sheet
			RETURN TRUE
		END IF
	END IF
NEXT


// Fallthrough - no sheet found with the same key and classname.

RETURN FALSE
end function

public function int fw_dec_sheet_cnt ();// Decrement and return the window manager sheet count

i_i_sheet_cnt --

RETURN i_i_sheet_cnt
end function

public function int fw_inc_sheet_cnt ();// Increment and return the window manager sheet count.

i_i_sheet_cnt ++

RETURN i_i_sheet_cnt
end function

public function string fw_set_sheet_key (int a_i_idx, string a_s_key);// Set the key of the sheet in the window manager at the location
// passed.

i_str_open [a_i_idx].s_key =  a_s_key

RETURN a_s_key
end function

public function window fw_open_sheet_simple (string a_s_win, int a_i_mpos);// function to open a sheet without any parameters.  fw_open_sheet ()
// is called with an empty str_pass.

str_pass str_pass


// Call fw_open_sheet with the empty str_pass.

RETURN this.fw_open_sheet (a_s_win, a_i_mpos, -1, str_pass)
end function

public function boolean fw_next_sheet (ref window a_w_sheet, ref string a_s_key);// Returns the next open window and key values in the arguments passed in
//	from the i_str_open structure.  Used to sequentially examine all
// open sheets.  i_i_next_idx points to the last sheet retrieved.

Integer i_idx


// Return FALSE if i_i_next_idx is out of range (no more sheets)

IF i_i_next_idx < 1 OR &
	i_i_next_idx > i_i_max_sheets THEN
	RETURN FALSE
END IF


// Search through the array of windows for the next opened window.

DO WHILE i_i_next_idx <= i_i_max_sheets
	IF IsValid (i_str_open [i_i_next_idx].w_sheet) THEN
		a_w_sheet = i_str_open [i_i_next_idx].w_sheet
		a_s_key = i_str_open [i_i_next_idx].s_key
		i_i_next_idx++	
		RETURN TRUE
	END IF
	i_i_next_idx++
LOOP


// Falthrough - No more open sheets.

RETURN FALSE
end function

public function boolean fw_first_sheet (ref window a_w_sheet, ref string a_s_key);// Return the first open sheet and its key by reference - sets the
// instance variable to 1 and calls fw_next_sheet

i_i_next_idx = 1

RETURN this.fw_next_sheet (a_w_sheet, a_s_key)
end function

public function boolean fw_is_sheet_valid (int a_i_idx, w_a a_win);// Determine whether the passed window occupies the index passed.

Integer i_upper, i_lower


// Return FALSE if the passed window is not valid.

IF NOT IsValid (a_win) THEN
	RETURN FALSE
END IF


// Return FALSE if the passed index in not in range.

IF a_i_idx > UpperBound (i_str_open) OR &
	a_i_idx < LowerBound (i_str_open) THEN
	RETURN FALSE
END IF


// Is the window at the slot in the open sheet array the same as
// that passed?

IF i_str_open [a_i_idx].w_sheet = a_win THEN
	RETURN TRUE
ELSE
	RETURN FALSE
END IF
end function

public function boolean fw_is_key_open_any (string a_s_key);// Determine whether a sheet having the same key in the window
// manager as that passed, is known to the window manager.

Integer i_idx, i_upper


// Search the open sheet structure

FOR i_idx = 1 TO i_i_max_sheets
	IF NOT IsValid (i_str_open [i_idx].w_sheet) THEN
		CONTINUE
	END IF
	IF a_s_key = i_str_open [i_idx].s_key THEN
		RETURN TRUE
	END IF
NEXT


// Fallthrough - no sheet found with the passed key.

RETURN FALSE
end function

public function boolean fw_is_key_open_class (ref window a_w_win, string a_s_classname, string a_s_key);// Determine whether a sheet in the window manager, having the same
// key and classname as the key and classname passed, is known
// to the window manager and, if so, pass that window back via the
// passed window (by reference).

Integer i_idx, i_upper

a_s_classname = lower(a_s_classname)

// Search the open sheet structure.

FOR i_idx = 1 TO i_i_max_sheets
	IF NOT IsValid (i_str_open [i_idx].w_sheet) THEN
		CONTINUE
	END IF
	IF a_s_classname = i_str_open [i_idx].w_sheet.ClassName () THEN
		IF a_s_key = i_str_open [i_idx].s_key THEN
			a_w_win = i_str_open [i_idx].w_sheet
			RETURN TRUE
		END IF
	END IF
NEXT


// Fallthrough - no sheet found with the passed key and classname.

RETURN FALSE
end function

public function string fw_get_sheet_key (int a_i_idx);// Get the key of the sheet in the window manager at the location
// passed.

RETURN i_str_open [a_i_idx].s_key
end function

public function int fw_get_type_cnt (string a_s_win);// Return the number of open sheets with the classname passed.

Integer i_idx, i_open_cnt = 0


// Search the open sheet array.

FOR i_idx =1 TO i_i_max_sheets
	IF NOT IsValid (i_str_open [i_idx].w_sheet) THEN
		CONTINUE
	END IF
	IF i_str_open [i_idx].w_sheet.ClassName () = a_s_win THEN
		i_open_cnt++
	END IF
NEXT


// Return the number of sheets encountered.

RETURN i_open_cnt
end function

public subroutine  fw_set_microhelp (string a_s_microhelp);// Set instance variable to value passed.

i_s_microhelp = a_s_microhelp
end subroutine

public subroutine  fw_set_helpkey (string a_s_helpkey);// Set instance variable to value passed.

i_s_helpkey = a_s_helpkey
end subroutine

public function string fw_get_microhelp ();// Return value of instance variable.

RETURN i_s_microhelp
end function

public function string fw_get_helpkey ();// Return value of instance variable.

RETURN i_s_helpkey
end function

public function integer fw_setmicrohelp (string a_s_microhelp);// Wrapper for the SetMicroHelp () function.  Frame microhelp will be
// set to:
//		1) the value passed, if it exists,
//		2) application microhelp default, if it exists, or
//		3) "Ready" otherwise.

IF Len (Trim (a_s_microhelp)) > 0 THEN
	RETURN this.SetMicroHelp (Trim (a_s_microhelp))
END IF

IF Len (Trim (GetApplication ().microhelpdefault)) > 0 THEN
	RETURN this.SetMicroHelp (GetApplication ().microhelpdefault)
ELSE
	RETURN this.SetMicroHelp ("Ready")
END IF
end function

public subroutine fw_set_title (string a_s_title);// Set the title of the window (frame) to:
//   1) The title passed as an argument (if it exists)
//   2) The title specified in the application's .INI file
//   3) The literal "Application " + the application name.


// Set the title to the argument passed (if it exists).

IF Len (Trim (a_s_title)) > 0 THEN
	this.title = Trim (a_s_title)
	RETURN
END IF


// Set the title to the value in the application .INI file, if it
// exists and perform symbolic substitution.

IF IsValid (g_nv_ini) THEN
	IF g_nv_ini.fnv_is_valid () THEN
		a_s_title = g_nv_ini.fnv_profile_string ("PowerTOOL", &
																	"FrameTitle","")
		IF Len (a_s_title) > 0 THEN
			this.title = f_str_transform (a_s_title, "&appname", &
														GetApplication ().appname)
			RETURN
		END IF
	END IF
END IF


// Set the title to the literal "Application " + the application name.

this.title = "Application " + GetApplication ().appname
end subroutine

public function window fw_get_sheet (int a_i_idx);// Get the sheet in the window manager at the location passed.

RETURN i_str_open [a_i_idx].w_sheet
end function

public function nv_transaction fw_get_trans ();// Return value of instance variable.

RETURN i_tr_sql
end function

public function window fw_open_sheet_keyed (string a_s_win, integer a_i_mpos, integer a_i_maxopen, str_pass a_str_pass, string a_s_key);// Determine whether a sheet with classname a_s_win and key a_s_key
// is already open and bring it to the top of the z-order if so or
// open it if not.

w_a w_curr_sheet


// Determine whether the sheet is already open and bring it to the
// top if so.

IF this.fw_is_key_open_class (w_curr_sheet, a_s_win, a_s_key) THEN
	w_curr_sheet.BringToTop = TRUE
	RETURN w_curr_sheet
END IF


// Open the sheet otherwise.

w_curr_sheet = fw_open_sheet (a_s_win, a_i_mpos, a_i_maxopen, a_str_pass)

IF IsValid (w_curr_sheet) THEN
	// Set the sheet key to the value passed.
	w_curr_sheet.fw_set_key (a_s_key)
END IF



// Return the opened or null sheet.

RETURN w_curr_sheet
end function

public function integer fw_nav_choose_style ();// Prompt user to select NAV display style.
// Returns:
//	 n	NAV style
//	-1	if an error occurs

Integer i_nav_style
Window w_temp
str_pass str_pass


// Bail out if NAV isn't initialized.

IF NOT IsValid (g_nv_nav_manager) THEN
	RETURN -1
END IF


// Open selection dialog with current display style.

SetPointer (HourGlass!)

i_nav_style = this.fw_nav_get_style ()

str_pass.d [1] = i_nav_style

OpenWithParm (w_temp, str_pass, "w_nav_chooser")

SetPointer (HourGlass!)

str_pass = message.fnv_get_str_pass ()

message.fnv_clear_str_pass ()

IF str_pass.s_action = "ok" THEN
	i_nav_style = str_pass.d [1]
END IF

RETURN i_nav_style
end function

public subroutine fw_nav_set_style (integer a_i_nav_style);// Set NAV display style to style passed.


// Bail out if NAV isn't enabled.

IF NOT IsValid (g_nv_nav_manager) THEN
	RETURN
END IF


// Set NAV style.

SetPointer (HourGlass!)		// Minimize flicker

g_nv_nav_manager.FUNCTION DYNAMIC fnv_set_display_mode (a_i_nav_style)
end subroutine

public subroutine fw_nav_set_custom (string a_s_classname);// Set NAV display style to classname passed.


// Bail out if NAV isn't enabled.

IF NOT IsValid (g_nv_nav_manager) THEN
	RETURN
END IF


// Set NAV classname.

g_nv_nav_manager.FUNCTION DYNAMIC fnv_set_custom_display (a_s_classname)
end subroutine

public function string fw_nav_get_custom ();// Return current NAV display classname.

str_pass str_pass


// Bail out if NAV isn't initialized.

IF NOT IsValid (g_nv_nav_manager) THEN
	RETURN ""
END IF


// Return current display classname.

RETURN g_nv_nav_manager.FUNCTION DYNAMIC fnv_get_custom_display ()
end function

public function integer fw_nav_get_style ();// Return current NAV display style.


// Bail out if NAV isn't initialized.

IF NOT IsValid (g_nv_nav_manager) THEN
	RETURN -1
END IF


// Call proxy to retrieve current display style.

RETURN g_nv_nav_manager.FUNCTION DYNAMIC fnv_get_display_mode ()
end function

public function integer fw_nav_init (integer a_i_nav_style, integer a_i_menu_pos, nv_transaction a_tr);// Initialize NAV.
// Returns:
//  1 Success
// -1 An error occurred

str_pass str_pass


// Bail out if NAV isn't installed.

IF NOT g_nv_components.fnv_is_library_installed ("pt_nav") THEN
	RETURN -1
END IF


// Create the NAV manager if not already created.

IF NOT IsValid (g_nv_nav_manager) THEN
	g_nv_nav_manager = CREATE USING "nv_nav_manager"
	//g_nv_nav_manager = CREATE nv_nav_manager
END IF

IF NOT IsValid (g_nv_nav_manager) THEN
	RETURN -1	// error creating NAV manager
END IF


// Initialize NAV.

SetPointer (HourGlass!)		// Minimize flicker

this.SetMicrohelp ("Initializing NAV...")

RETURN g_nv_nav_manager.FUNCTION DYNAMIC fnv_initialize (this, a_i_nav_style, a_i_menu_pos, a_tr)
end function

public subroutine fw_nav_init (integer a_i_nav_style, integer a_i_menu_pos);// Included for compatibility.  Call new init function.

this.fw_nav_init (a_i_nav_style, a_i_menu_pos, i_tr_sql)
end subroutine

event open;// Any code that should be executed before the window is displayed
// goes here in the open event (e.g. changing the window's title).

Window w_empty
str_nav str_nav


// Set Global reference and increment frame count.

g_w_frame = this

s_i_frame_cnt ++


// Get the passing structure from the message object.

i_str_pass = message.fnv_get_str_pass ()

message.fnv_clear_str_pass ()


// Set the default transaction.

this.fw_set_trans (SQLCA)


// Set frame title (default is current window title).

this.fw_set_title (this.title)


// Set Window Manager defaults and allocate memory for the sheet array.

i_e_style = Layered!

i_i_max_sheets = 10

i_str_open [i_i_max_sheets].w_sheet = w_empty


// Get the NAV structure from the message object.

str_nav = message.fnv_get_str_nav ()

message.fnv_clear_str_nav ()


// Any code that could be executed after the window is displayed
// goes in the "ue_init" event (e.g. dynamically populating a list
// box).

this.PostEvent ("ue_init")
end event

event close;// Decrement frame count.

s_i_frame_cnt --


// Remove NAV dynamic menu.

IF IsValid (g_nv_nav_manager) THEN
	IF g_nv_nav_manager.FUNCTION DYNAMIC fnv_get_display_mode () &
											= 3 THEN		// Dynamic menu style
		g_nv_nav_manager.FUNCTION DYNAMIC fnv_remove_menu_from_window (this)
	END IF
END IF


// *TEMPORARY* Close app if this is the last frame to force
// hidden windows into disgrace . . .

//HALT CLOSE
end event

on w_fa_pt.create
if this.MenuName = "m_frame_pt" then this.MenuID = create m_frame_pt
this.mdi_1=create mdi_1
this.Control[]={this.mdi_1}
end on

on w_fa_pt.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.mdi_1)
end on

type mdi_1 from mdiclient within w_fa_pt
long BackColor=276856960
end type

