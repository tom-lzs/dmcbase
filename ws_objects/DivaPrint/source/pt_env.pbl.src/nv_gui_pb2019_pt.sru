$PBExportHeader$nv_gui_pb2019_pt.sru
$PBExportComments$API  Win64
forward
global type nv_gui_pb2019_pt from nv_gui_a
end type
end forward

global type nv_gui_pb2019_pt from nv_gui_a
end type
global nv_gui_pb2019_pt nv_gui_pb2019_pt

type prototypes
Function long GetSysColor (integer i_type) LIBRARY "user32.dll"
Function long GetSystemMenu (long hWnd, boolean bRevert) LIBRARY "user32.dll"
Function uint GetWindowsDirectoryA (REF string sBuff, uint iLen) LIBRARY "kernel32.dll" alias for "GetWindowsDirectoryA;Ansi"

// menu functions
Function long CreateMenu () Library "user32.dll"
Function boolean DestroyMenu (long hmenu) Library "user32.dll"
Subroutine DrawMenuBar (long hwnd ) Library "user32.dll"
Function long GetMenu (long a_l_hwnd) Library "user32.dll"
Function boolean InsertMenuA (long hmenu, uint idItem, uint fuFlags, &
			 uint idNewItem, string lpNewItem) Library "user32.dll" alias for "InsertMenuA;Ansi"
Function boolean RemoveMenu (long hmenu, uint idItem, uint fuFlags) Library "user32.dll"
end prototypes

type variables
PROTECTED:
	// Windows constants
	uint	WM_LBUTTONDOWN = 513
	uint	EM_LINEINDEX = 1035		// (WM_USER (1024) + 11)
	uint	WM_MOUSEFIRST = 512
	uint	WM_MOUSELAST = 521
	uint	WM_NCLBUTTONDOWN = 161
	uint	WM_SYSCOMMAND = 274		// or 0x112
end variables

forward prototypes
public function boolean fnv_control_menu_close (message a_m_msg)
public function long fnv_create_menu ()
public function boolean fnv_destroy_menu (long a_l_hmenu)
public subroutine fnv_draw_menu_bar (window a_w_win)
public function long fnv_get_line_startpos (graphicobject a_go_win, integer a_i_line)
public function long fnv_get_menu (window a_w_win)
public function long fnv_get_system_color (integer a_i_type)
public function unsignedinteger fnv_get_windowing_directory (ref string a_s_directory, unsignedinteger a_i_size)
public function boolean fnv_insert_menu (long a_l_hmenu, long a_l_pos, long a_l_flags, long a_l_newid, string a_s_menu_text)
public function boolean fnv_is_lbutton_down (message a_m_msg)
public function boolean fnv_is_window_active (ref string a_s_title)
public function boolean fnv_remove_menu (long a_l_hmenu, long a_l_itemid, long a_l_flags)
public function long fnv_send_window_lbutton_down (window a_w_win, integer a_i_area)
public function boolean fnv_user_wordparm (message a_m_msg)
end prototypes

public function boolean fnv_control_menu_close (message a_m_msg);
//*****************************************************************************
// function to determine if user is closing window from control menu
//	Arguments:
//		a_m_msg		message object
//	Returns:
//		boolean
//*****************************************************************************
long	l_command

IF a_m_msg.Number <> WM_SYSCOMMAND THEN
	RETURN FALSE
END IF

// As per windows SDK documentation re: wm_syscommand,
// the four low-order bits are used internally by windows

l_command = a_m_msg.WordParm
l_command = l_command / 16			// Strip the internally used bits
l_command = l_command * 16

IF l_command <> 61536 THEN
	RETURN FALSE
END IF

RETURN TRUE
end function

public function long fnv_create_menu ();
//*****************************************************************************
// Win 32 Function For Creating New Menus
//*****************************************************************************

RETURN CreateMenu ()
end function

public function boolean fnv_destroy_menu (long a_l_hmenu);
//*****************************************************************************
// Win 32 Function For Destroying Menus
//*****************************************************************************

RETURN DestroyMenu (a_l_hmenu)
end function

public subroutine fnv_draw_menu_bar (window a_w_win);
//*****************************************************************************
// Win 32 Function For Drawing The Menu Bar
//*****************************************************************************
long a_l_hwnd

a_l_hwnd = Handle (a_w_win)

DrawMenuBar (a_l_hwnd)
end subroutine

public function long fnv_get_line_startpos (graphicobject a_go_win, integer a_i_line);
//*****************************************************************************
RETURN Send (Handle (a_go_win), EM_LINEINDEX, a_i_line - 1, 0)
end function

public function long fnv_get_menu (window a_w_win);
//*****************************************************************************
// Win 32 Function For Obtaining The Menu Handle For A Window
//*****************************************************************************
long	a_l_window_handle

a_l_window_handle = Handle (a_w_win)

RETURN GetMenu (a_l_window_handle)
end function

public function long fnv_get_system_color (integer a_i_type);
//*****************************************************************************
// Win32 call to get Windows system color
//*****************************************************************************
RETURN GetSysColor (a_i_type)
end function

public function unsignedinteger fnv_get_windowing_directory (ref string a_s_directory, unsignedinteger a_i_size);
//*****************************************************************************
// Win32 SDK call to get Windows directory
//*****************************************************************************
RETURN GetWindowsDirectoryA (a_s_directory, a_i_size)
end function

public function boolean fnv_insert_menu (long a_l_hmenu, long a_l_pos, long a_l_flags, long a_l_newid, string a_s_menu_text);
//*****************************************************************************
// Win 32 Function For Inserting Menus Into An Existing Menu
//*****************************************************************************

RETURN InsertMenuA (a_l_hmenu, a_l_pos, a_l_flags, a_l_newid, a_s_menu_text)
end function

public function boolean fnv_is_lbutton_down (message a_m_msg);
//*****************************************************************************
// function to determine if left button down during mouse input
//	Arguments:
//		a_m_msg		message object
//	Returns:
//		boolean
//*****************************************************************************
long	l_flag

// is this a mouse input message?
IF a_m_msg.Number < WM_MOUSEFIRST OR a_m_msg.Number < WM_MOUSELAST THEN
	RETURN FALSE
END IF

// say no more
IF a_m_msg.Number = WM_LBUTTONDOWN THEN
	RETURN TRUE
END IF

// strip off key states
l_flag = a_m_msg.WordParm
DO WHILE NOT l_flag < 10	// middle button
	l_flag = l_flag - 10
LOOP
DO WHILE NOT l_flag < 8		// control key
	l_flag = l_flag - 8
LOOP
DO WHILE NOT l_flag < 4		// shift key
	l_flag = l_flag - 4
LOOP
DO WHILE NOT l_flag < 2		// right button
	l_flag = l_flag - 2
LOOP

// check result (should be 0 or 1)
IF l_flag = 1 THEN			// left button
	RETURN TRUE
ELSE
	RETURN FALSE
END IF
end function

public function boolean fnv_is_window_active (ref string a_s_title);
//*****************************************************************************
//CBE TODO
RETURN TRUE
end function

public function boolean fnv_remove_menu (long a_l_hmenu, long a_l_itemid, long a_l_flags);
//*****************************************************************************
// Win 32 Function For Removing Menus From An Existing Menu
//*****************************************************************************

RETURN RemoveMenu (a_l_hmenu, a_l_itemid, a_l_flags)
end function

public function long fnv_send_window_lbutton_down (window a_w_win, integer a_i_area);
//*****************************************************************************
// must convert some areas and long parm x,y position

int	i_area
long	l_x_y

i_area = a_i_area
IF i_area = 19 THEN
	i_area= 5
ELSEIF i_area = 20 THEN
	i_area= 8
ELSEIF i_area = 21 THEN
	i_area= 9
END IF

RETURN Send ( Handle (a_w_win), WM_NCLBUTTONDOWN, i_area, l_x_y)
end function

public function boolean fnv_user_wordparm (message a_m_msg);
//*****************************************************************************
// function to determine if message wordparm is user defined value
//	Arguments:
//		a_m_msg		message object
//	Returns:
//		boolean
//*****************************************************************************

IF a_m_msg.WordParm < 32767 THEN
	RETURN FALSE
END IF

RETURN TRUE
end function

on nv_gui_pb2019_pt.create
call super::create
end on

on nv_gui_pb2019_pt.destroy
call super::destroy
end on

