$PBExportHeader$nv_environment_pt.sru
$PBExportComments$Services pour l'environement des objets
forward
global type nv_environment_pt from nonvisualobject
end type
end forward

global type nv_environment_pt from nonvisualobject
end type
global nv_environment_pt nv_environment_pt

type variables
PROTECTED:

	Environment	i_env		// Environment instance
	nv_gui_a		i_nv_gui_api	// GUI API object
	nv_os_api_a	i_nv_os_api	// OS API object

	// constants defined
	int	MAX_PATH = 260		// from windef.h
	int	MAX_DRIVE_SIZE = 128
	int	MAX_TIME_SIZE = 128
end variables

forward prototypes
public function integer fnv_get_os_api (ref nv_os_api_a a_nv_os_api)
protected function integer fnv_create_nv_os_api ()
public function integer fnv_get_gui_api (ref nv_gui_a a_nv_gui_api)
protected function integer fnv_create_nv_gui_api ()
public function string fnv_get_system_directory ()
public function string fnv_get_windowing_directory ()
public function long fnv_get_screen_width ()
public function long fnv_get_screen_height ()
public function long fnv_get_number_of_colors ()
public function int fnv_get_os_major_revision ()
public function int fnv_get_os_minor_revision ()
public function int fnv_get_os_fixes_revision ()
public function ostypes fnv_get_os_type ()
public function int fnv_get_pb_major_revision ()
public function int fnv_get_pb_minor_revision ()
public function int fnv_get_pb_fixes_revision ()
public function pbtypes fnv_get_pb_type ()
public function cputypes fnv_get_cpu_type ()
public function long fnv_send_window_lbutton_down (window a_w_win, integer a_i_area)
public function long fnv_get_system_color (integer a_i_type)
public function long fnv_get_line_startpos (graphicobject a_go_win, integer a_i_line)
public function boolean fnv_change_directory (string a_s_directory)
public function boolean fnv_change_drive (string a_s_drive)
public function boolean fnv_delete_file (string a_s_filename)
public function long fnv_disk_free_space (string a_s_drive)
public function long fnv_disk_space (string a_s_drive)
public function string fnv_get_directory ()
public function string fnv_get_drive ()
public function string fnv_get_environment_variable (string a_s_name)
public function boolean fnv_make_directory (string a_s_directory)
public function boolean fnv_move_file (string a_s_source, string a_s_target, boolean a_b_overwrite)
public function boolean fnv_remove_directory (string a_s_directory)
public function boolean fnv_rename_file (string a_s_original, string a_s_new)
public function string fnv_get_file_timestamp (string a_s_filename)
public function boolean fnv_copy_file (string a_s_source, string a_s_target, boolean a_b_overwrite)
public function string fnv_get_multi_filenames (window a_w_win, ref string a_s_filetypes, integer a_i_idx, ref string a_s_title)
public function long fnv_get_open_file_error ()
public function long fnv_get_menu (window a_w_win)
public subroutine fnv_draw_menu_bar (window a_w_win)
public function long fnv_create_menu ()
public function boolean fnv_destroy_menu (long a_l_hmenu)
public function boolean fnv_insert_menu (long a_l_hmenu, long a_l_pos, long a_l_flags, long a_l_newid, string a_s_menu_text)
public function boolean fnv_remove_menu (long a_l_hmenu, long a_l_itemid, long a_l_flags)
public function boolean fnv_control_menu_close (message a_m_msg)
public function boolean fnv_is_lbutton_down (message a_m_msg)
public function boolean fnv_user_wordparm (message a_m_msg)
public function boolean fnv_is_window_active (ref string a_s_title)
end prototypes

public function integer fnv_get_os_api (ref nv_os_api_a a_nv_os_api);
//*****************************************************************************
// function to return the appropriate OS API non-visual
//	Arguments:
//		nv_os_api_a		object passed by reference
//	Returns:
//		integer		1	: NVO successfully retrieved
//					-1	: Error encountered
//*****************************************************************************

IF this.fnv_create_nv_os_api () < 0 THEN
	RETURN -1
END IF

a_nv_os_api = i_nv_os_api

RETURN 1

end function

protected function integer fnv_create_nv_os_api ();
//*****************************************************************************
// function to create OS API object
//	Arguments:
//		none
//	Returns:
//		integer		1	: Object created successfully
//					-1	: Error encountered
//*****************************************************************************

IF IsValid (i_nv_os_api) THEN
	RETURN 1
END IF

IF NOT IsValid (i_env) THEN
	RETURN -1
END IF

CHOOSE CASE i_env.OSType
	CASE WindowsNT!
		// CBE START
		// Update to 32 and 64 bit OS
		i_nv_os_api = CREATE nv_os_pb2019
		// CBE END	
	CASE ELSE
		RETURN -1
END CHOOSE

RETURN 1

end function

public function integer fnv_get_gui_api (ref nv_gui_a a_nv_gui_api);
//*****************************************************************************
// function to return the appropriate GUI API non-visual
//	Arguments:
//		nv_gui_a	object passed by reference
//	Returns:
//		integer		1	: NVO successfully retrieved
//					-1	: Error encountered
//*****************************************************************************

IF this.fnv_create_nv_gui_api () < 0 THEN
	RETURN -1
END IF

a_nv_gui_api = i_nv_gui_api

RETURN 1

end function

protected function integer fnv_create_nv_gui_api ();
//*****************************************************************************
// function to create GUI API object
//	Arguments:
//		none
//	Returns:
//		integer		1	: Object created successfully
//					-1	: Error encountered
//*****************************************************************************

IF IsValid (i_nv_gui_api) THEN
	RETURN 1
END IF

IF NOT IsValid (i_env) THEN
	RETURN -1
END IF

CHOOSE CASE i_env.OSType
	CASE WindowsNT!
		// CBE START
		// Update to 32 and 64 bit OS
		i_nv_gui_api = CREATE nv_gui_pb2019
		// CBE END
	CASE ELSE
		RETURN -1
END CHOOSE

RETURN 1

end function

public function string fnv_get_system_directory ();
//*****************************************************************************
// function to return the OS system directory
//	Arguments:
//		none
//	Returns
//		string		OS system directory or empty string
//*****************************************************************************

string	s_dir

// create instance of api object
IF this.fnv_create_nv_os_api () < 0 THEN
	RETURN ""
END IF

// allocate buffer for directory name
s_dir = Space (MAX_PATH)
IF s_dir = "" THEN
	RETURN ""
END IF

// invoke api function call and check return
IF i_nv_os_api.fnv_get_system_directory (s_dir, MAX_PATH) < 1 THEN
	RETURN ""
END IF

// receive a directory name, return it
RETURN s_dir

end function

public function string fnv_get_windowing_directory ();
//*****************************************************************************
// function to return the OS windowing directory
//	Arguments:
//		none
//	Returns
//		string		OS windowing directory or empty string
//*****************************************************************************

string	s_dir

// create instance of api object
IF this.fnv_create_nv_gui_api () < 0 THEN
	RETURN ""
END IF

// allocate buffer for directory name
s_dir = Space (MAX_PATH)
IF s_dir = "" THEN
	RETURN ""
END IF

// invoke api function call and check return
IF i_nv_gui_api.fnv_get_windowing_directory (s_dir, MAX_PATH) < 1 THEN
	RETURN ""
END IF

// receive a directory name, return it
RETURN s_dir

end function

public function long fnv_get_screen_width ();
//*****************************************************************************
RETURN i_env.ScreenWidth
end function

public function long fnv_get_screen_height ();
//*****************************************************************************
RETURN i_env.ScreenHeight
end function

public function long fnv_get_number_of_colors ();
//*****************************************************************************
RETURN i_env.NumberOfColors
end function

public function int fnv_get_os_major_revision ();
//*****************************************************************************
RETURN i_env.OSMajorRevision
end function

public function int fnv_get_os_minor_revision ();
//*****************************************************************************
RETURN i_env.OSMinorRevision
end function

public function int fnv_get_os_fixes_revision ();
//*****************************************************************************
RETURN i_env.OSFixesRevision
end function

public function ostypes fnv_get_os_type ();
//*****************************************************************************
RETURN i_env.OSType
end function

public function int fnv_get_pb_major_revision ();
//*****************************************************************************
RETURN i_env.PBMajorRevision
end function

public function int fnv_get_pb_minor_revision ();
//*****************************************************************************
RETURN i_env.PBMinorRevision
end function

public function int fnv_get_pb_fixes_revision ();
//*****************************************************************************
RETURN i_env.PBFixesRevision
end function

public function pbtypes fnv_get_pb_type ();
//*****************************************************************************
RETURN i_env.PBType
end function

public function cputypes fnv_get_cpu_type ();
//*****************************************************************************
RETURN i_env.CPUType
end function

public function long fnv_send_window_lbutton_down (window a_w_win, integer a_i_area);
//*****************************************************************************
// function to send a left mouse button down message to specified window
//	Arguments:
//		integer	representing area of window
//			0	: no where
//			1	: client
//			2	: caption
//			3	: system menu
//			4	: size
//			5	: menu
//			6	: horizontal scroll
//			7	: vertical scroll
//			8	: minimize button
//			9	: maximize button
//			10	: left
//			11	: right
//			12	: top
//			13	: top left
//			14	: top right
//			15	: bottom
//			16	: bottom left
//			17	: bottom right
//			18	: border
//			19	: growbox
//			20	: reduce
//			21	: zoom
//
//	Returns
//		long	-1 if error, long result if successful
//*****************************************************************************

// create instance of api object
IF this.fnv_create_nv_gui_api () < 0 THEN
	RETURN -1
END IF

// range check area request
IF a_i_area < 0 OR a_i_area > 21 THEN
	RETURN -1
END IF

RETURN i_nv_gui_api.fnv_send_window_lbutton_down (a_w_win, a_i_area)

end function

public function long fnv_get_system_color (integer a_i_type);
//*****************************************************************************
// function to return long RGB color value for windowing system colors
//	Arguments:
//		integer	type of system color
//			0	: scroll bar
//			1	: background
//			2	: active caption
//			3	: inactive caption
//			4	: menu
//			5	: window
//			6	: window frame
//			7	: menu text
//			8	: window text
//			9	: active caption text
//			10	: active border
//			11	: inactive border
//			12	: application workspace
//			13	: highlight
//			14	: highlight text
//			15	: button face
//			16	: button shadow
//			17	: gray text
//			18	: button text
//			19	: inactive caption text
//			20	: button highlight
//
//	Returns
//		long	-1 if error, RGB long value if successful
//*****************************************************************************

// create instance of api object
IF this.fnv_create_nv_gui_api () < 0 THEN
	RETURN -1
END IF

// range check type request
IF a_i_type < 0 OR a_i_type > 20 THEN
	RETURN -1
END IF

RETURN i_nv_gui_api.fnv_get_system_color (a_i_type)

end function

public function long fnv_get_line_startpos (graphicobject a_go_win, integer a_i_line);
//*****************************************************************************
// function to get line start position in multi-line edit
//	Arguments:
//		a_go_win	the graphicobject (multi-line edit)
//	Returns:
//		long		the result or -1 if error
//*****************************************************************************

// create instance of api object
IF this.fnv_create_nv_gui_api () < 0 THEN
	RETURN -1
END IF

// invoke api function call
RETURN i_nv_gui_api.fnv_get_line_startpos (a_go_win, a_i_line)
end function

public function boolean fnv_change_directory (string a_s_directory);
//*****************************************************************************
// function to change working directory
//	(changes drive/volume if new directory not on current drive/volume)
//	Arguments:
//		a_s_directory	string containing name of directory
//	Returns:
//		boolean			success of changing directory
//	Assumes:
//		OS function returns 0 if successful
//*****************************************************************************

IF this.fnv_create_nv_os_api () < 0 THEN
	RETURN FALSE
END IF

IF i_nv_os_api.fnv_change_dir (a_s_directory) <> 0 THEN
	RETURN FALSE
END IF

RETURN TRUE
end function

public function boolean fnv_change_drive (string a_s_drive);
//*****************************************************************************
// function to change drive
//	Arguments:
//		a_s_drive	string containing name of drive
//	Returns:
//		boolean		success of changing drive
//	Assumes:
//		OS function returns 0 if successful
//*****************************************************************************

IF this.fnv_create_nv_os_api () < 0 THEN
	RETURN FALSE
END IF

IF i_nv_os_api.fnv_change_drive (a_s_drive) <> 0 THEN
	RETURN FALSE
END IF

RETURN TRUE
end function

public function boolean fnv_delete_file (string a_s_filename);
//*****************************************************************************
// function to delete file
//	Arguments:
//		a_s_filename	string containing name of file to delete
//	Returns:
//		boolean			success of deleting filename
//	Assumes:
//		OS function returns 0 if successful
//*****************************************************************************

IF this.fnv_create_nv_os_api () < 0 THEN
	RETURN FALSE
END IF

IF i_nv_os_api.fnv_delete_file (a_s_filename) <> 0 THEN
	RETURN FALSE
END IF

RETURN TRUE
end function

public function long fnv_disk_free_space (string a_s_drive);
//*****************************************************************************
// function to check available space on drive
//	Arguments:
//		a_s_drive	string containing name of drive to check
//	Returns:
//		long		free space or -1 on error
//*****************************************************************************

IF this.fnv_create_nv_os_api () < 0 THEN
	RETURN -1
END IF

RETURN i_nv_os_api.fnv_disk_free_space (a_s_drive)
end function

public function long fnv_disk_space (string a_s_drive);
//*****************************************************************************
// function to check total space on drive
//	Arguments:
//		a_s_drive	string containing name of drive to check
//	Returns:
//		long		total space or -1 on error
//*****************************************************************************

IF this.fnv_create_nv_os_api () < 0 THEN
	RETURN -1
END IF

RETURN i_nv_os_api.fnv_disk_space (a_s_drive)
end function

public function string fnv_get_directory ();
//*****************************************************************************
// function to return the current directory from OS
//	Arguments:
//		none
//	Returns
//		string		OS directory or empty string
//*****************************************************************************

string	s_dir

// create instance of api object
IF this.fnv_create_nv_os_api () < 0 THEN
	RETURN ""
END IF

// allocate buffer for directory name
s_dir = Space (MAX_PATH)
IF s_dir = "" THEN
	RETURN ""
END IF

// invoke api function call and check return
IF i_nv_os_api.fnv_get_directory (s_dir) < 1 THEN
	RETURN ""
END IF

// received a directory name, return it
RETURN s_dir

end function

public function string fnv_get_drive ();
//*****************************************************************************
// function to return the current drive from OS
//	Arguments:
//		none
//	Returns
//		string		OS drive or empty string
//*****************************************************************************

string	s_drive

// create instance of api object
IF this.fnv_create_nv_os_api () < 0 THEN
	RETURN ""
END IF

// allocate buffer for drive name
s_drive = Space (MAX_DRIVE_SIZE)
IF s_drive = "" THEN
	RETURN ""
END IF

// invoke api function call and check return
IF i_nv_os_api.fnv_get_drive (s_drive) < 1 THEN
	RETURN ""
END IF

// received a drive name, return it
RETURN s_drive

end function

public function string fnv_get_environment_variable (string a_s_name);
//*****************************************************************************
// function to return the string value of OS environment variable
//	Arguments:
//		string		name of OS environment variable
//	Returns
//		string		value of OS environment variable or empty string
//*****************************************************************************

// create instance of api object
IF this.fnv_create_nv_os_api () < 0 THEN
	RETURN ""
END IF

// invoke api function to get variable value
RETURN i_nv_os_api.fnv_get_env (a_s_name)
end function

public function boolean fnv_make_directory (string a_s_directory);
//*****************************************************************************
// function to create a directory
//	Arguments:
//		a_s_directory	string containing name of directory to create
//	Returns:
//		boolean			success of creating directory
//	Assumes:
//		OS function returns 0 if successful
//*****************************************************************************

IF this.fnv_create_nv_os_api () < 0 THEN
	RETURN FALSE
END IF

IF i_nv_os_api.fnv_make_dir (a_s_directory) <> 0 THEN
	RETURN FALSE
END IF

RETURN TRUE
end function

public function boolean fnv_move_file (string a_s_source, string a_s_target, boolean a_b_overwrite);
//*****************************************************************************
// function to move a file
//	Arguments:
//		a_s_source		string containing name of source file
//		a_s_target		string containing name of target file
//		a_b_overwrite	boolean indicating delete source on success
//	Returns:
//		boolean			success of moving file
//*****************************************************************************

IF this.fnv_create_nv_os_api () < 0 THEN
	RETURN FALSE
END IF

IF i_nv_os_api.fnv_move_file (a_s_source, a_s_target, a_b_overwrite) < 1 THEN
	RETURN FALSE
END IF

RETURN TRUE
end function

public function boolean fnv_remove_directory (string a_s_directory);
//*****************************************************************************
// function to remove a directory
//	Arguments:
//		a_s_directory	string containing name of directory to remove
//	Returns:
//		boolean			success of removing directory
//	Assumes:
//		OS function returns 0 if successful
//*****************************************************************************

IF this.fnv_create_nv_os_api () < 0 THEN
	RETURN FALSE
END IF

IF i_nv_os_api.fnv_remove_dir (a_s_directory) <> 0 THEN
	RETURN FALSE
END IF

RETURN TRUE
end function

public function boolean fnv_rename_file (string a_s_original, string a_s_new);
//*****************************************************************************
// function to rename a file
//	Arguments:
//		a_s_original	string containing original name of file
//		a_s_new			string containing new name of file
//	Returns:
//		boolean			success of renaming directory
//	Assumes:
//		OS function returns 0 if successful
//*****************************************************************************

IF this.fnv_create_nv_os_api () < 0 THEN
	RETURN FALSE
END IF

IF i_nv_os_api.fnv_rename_file (a_s_original, a_s_new) <> 0 THEN
	RETURN FALSE
END IF

RETURN TRUE
end function

public function string fnv_get_file_timestamp (string a_s_filename);
//*****************************************************************************
// function to return the timestamp of file from OS
//		(provided for backward compatibilty with nv_diskfile fnv_time_file(),
//		returns timestamp in format: Day Mon dd hh:mm:ss yyyy)
//	Arguments:
//		none
//	Returns
//		string		file timestamp or empty string
//*****************************************************************************

string	s_time

// create instance of api object
IF this.fnv_create_nv_os_api () < 0 THEN
	RETURN ""
END IF

// allocate buffer for directory name
s_time = Space (MAX_TIME_SIZE)
IF s_time = "" THEN
	RETURN ""
END IF

// invoke api function call and check return
s_time =  i_nv_os_api.fnv_time_file (a_s_filename, MAX_TIME_SIZE)
IF IsNull (s_time) OR s_time = "" THEN
	RETURN ""
END IF

// received a timestamp, trim spaces and return it
RETURN (Trim (s_time))

end function

public function boolean fnv_copy_file (string a_s_source, string a_s_target, boolean a_b_overwrite);
//*****************************************************************************
// function to copy a file
//	Arguments:
//		a_s_source		string containing name of source file
//		a_s_target		string containing name of target file
//		a_b_overwrite	boolean indicating overwrite target if it exists
//	Returns:
//		boolean			success of copying file
//*****************************************************************************

IF this.fnv_create_nv_os_api () < 0 THEN
	RETURN FALSE
END IF

IF i_nv_os_api.fnv_copy_file (a_s_source, a_s_target, a_b_overwrite) < 1 THEN
	RETURN FALSE
END IF

RETURN TRUE

end function

public function string fnv_get_multi_filenames (window a_w_win, ref string a_s_filetypes, integer a_i_idx, ref string a_s_title);
//*****************************************************************************
// function to select multiple filenames and return as a string
//	Arguments:
//		a_w_win			window owning dialog (or NULL)
//		a_s_filetypes	string containing types of files to prompt for
//		a_i_idx			integer default index of type
//		a_s_title		optional title of dialog window
//	Returns:
//		string			list of filenames (tab delimited)
//*****************************************************************************

IF this.fnv_create_nv_os_api () < 0 THEN
	RETURN ""
END IF

RETURN i_nv_os_api.fnv_get_multi_filenames (a_w_win, &
				a_s_filetypes, a_i_idx, a_s_title)
end function

public function long fnv_get_open_file_error ()
//*****************************************************************************
// function to to return error code from OS file open call
//	Arguments:
//		none
//	Returns:
//		long		error code
//*****************************************************************************

IF this.fnv_create_nv_os_api () < 0 THEN
	RETURN -1
END IF

RETURN i_nv_os_api.fnv_get_open_file_error ()
end function

public function long fnv_get_menu (window a_w_win);
//*****************************************************************************
// function to return handle to menu for window
//	Arguments:
//		a_w_win		window to obtain menu handle for
//	Returns:
//		long		menu handle or 0
//*****************************************************************************

// create instance of api object
IF this.fnv_create_nv_gui_api () < 0 THEN
	RETURN 0
END IF

// invoke api function call
RETURN i_nv_gui_api.fnv_get_menu (a_w_win)
end function

public subroutine fnv_draw_menu_bar (window a_w_win);
//*****************************************************************************
// function to draw menu bar for window
//	Arguments:
//		a_w_win		window for which to draw menu bar
//	Returns:
//		none
//*****************************************************************************

// create instance of api object
IF this.fnv_create_nv_gui_api () < 0 THEN
	RETURN
END IF

// invoke api function call
i_nv_gui_api.fnv_draw_menu_bar (a_w_win)
end subroutine

public function long fnv_create_menu ();
//*****************************************************************************
// function to create a menu
//	Arguments:
//		None
//	Returns:
//		long		handle of menu or 0
//*****************************************************************************

// create instance of api object
IF this.fnv_create_nv_gui_api () < 0 THEN
	RETURN 0
END IF

// invoke api function call
RETURN i_nv_gui_api.fnv_create_menu ()
end function

public function boolean fnv_destroy_menu (long a_l_hmenu);
//*****************************************************************************
// function to destroy a menu
//	Arguments:
//		a_l_hmenu		handle to menu to destroy
//	Returns:
//		boolean			success or failure of destroying menu
//*****************************************************************************

// create instance of api object
IF this.fnv_create_nv_gui_api () < 0 THEN
	RETURN FALSE
END IF

// invoke api function call
RETURN i_nv_gui_api.fnv_destroy_menu (a_l_hmenu)
end function

public function boolean fnv_insert_menu (long a_l_hmenu, long a_l_pos, long a_l_flags, long a_l_newid, string a_s_menu_text);
//*****************************************************************************
// function to insert item in a menu
//	Arguments:
//		a_l_hmenu	handle to menu in which to insert item
//		a_l_pos		position in which to insert item
//		a_l_flags	flags for insert
//		a_l_newid
//		a_s_menu_text
//	Returns:
//		boolean		success or failure of inserting item
//*****************************************************************************

// create instance of api object
IF this.fnv_create_nv_gui_api () < 0 THEN
	RETURN FALSE
END IF

// invoke api function call
RETURN i_nv_gui_api.fnv_insert_menu (a_l_hmenu, &
				a_l_pos, a_l_flags, a_l_newid, a_s_menu_text)
end function

public function boolean fnv_remove_menu (long a_l_hmenu, long a_l_itemid, long a_l_flags);
//*****************************************************************************
// function to remove an item from a menu
//	Arguments:
//		a_l_hmenu		handle to menu from which to remove item
//		a_l_itemid		id of item to remove
//		a_l_flags		flags
//	Returns:
//		boolean			success or failure of removing item
//*****************************************************************************


// create instance of api object
IF this.fnv_create_nv_gui_api () < 0 THEN
	RETURN FALSE
END IF

// invoke api function call
RETURN i_nv_gui_api.fnv_remove_menu (a_l_hmenu, a_l_itemid, a_l_flags)
end function

public function boolean fnv_control_menu_close (message a_m_msg);
//*****************************************************************************
// function to determine if close requested from conrol menu
//	Arguments:
//		a_m_msg		message object
//	Returns:
//		boolean
//*****************************************************************************

// create instance of api object
IF this.fnv_create_nv_gui_api () < 0 THEN
	RETURN FALSE
END IF

// invoke api function call
RETURN i_nv_gui_api.fnv_control_menu_close (a_m_msg)
end function

public function boolean fnv_is_lbutton_down (message a_m_msg);
//*****************************************************************************
// function to inquire of GUI if left mouse button is down
//	Arguments:
//		a_m_msg		Message object
//	Returns:
//		boolean			success of changing directory
//	Assumes:
//		OS function returns 0 if successful
//*****************************************************************************

IF this.fnv_create_nv_gui_api () < 0 THEN
	RETURN FALSE
END IF

RETURN i_nv_gui_api.fnv_is_lbutton_down (a_m_msg)

end function

public function boolean fnv_user_wordparm (message a_m_msg);
//*****************************************************************************
// function to determine is message object wordparm is user-defined value
//	Arguments:
//		a_m_msg		message object
//	Returns:
//		boolean
//*****************************************************************************

// create instance of api object
IF this.fnv_create_nv_gui_api () < 0 THEN
	RETURN FALSE
END IF

// invoke api function call
RETURN i_nv_gui_api.fnv_user_wordparm (a_m_msg)

end function

public function boolean fnv_is_window_active (ref string a_s_title);
//*****************************************************************************
// function to check for existence of window with specified title
//	Arguments:
//		a_s_title		window title (or 1st portion of title)
//							to use for comparison
//	Returns:
//		boolean			TRUE if a window exists with matching title
//							FALSE if title does not match active window
//*****************************************************************************

// create instance of api object
IF this.fnv_create_nv_gui_api () < 0 THEN
	RETURN FALSE
END IF

// invoke api function call
RETURN i_nv_gui_api.fnv_is_window_active (a_s_title)
end function

on destructor;
///////////////////////////////////////////////////////////////////////////////
// destroy valid api objects
///////////////////////////////////////////////////////////////////////////////

IF IsValid (i_nv_gui_api) THEN
	DESTROY (i_nv_gui_api)
END IF

IF IsValid (i_nv_os_api) THEN
	DESTROY (i_nv_os_api)
END IF
end on

on constructor;
//*****************************************************************************
// initialize environment instance variable
//*****************************************************************************

GetEnvironment (i_env)

end on

on nv_environment_pt.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nv_environment_pt.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

