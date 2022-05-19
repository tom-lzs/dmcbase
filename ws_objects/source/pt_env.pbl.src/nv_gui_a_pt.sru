$PBExportHeader$nv_gui_a_pt.sru
$PBExportComments$Services GUI
forward
global type nv_gui_a_pt from nonvisualobject
end type
end forward

global type nv_gui_a_pt from nonvisualobject
end type
global nv_gui_a_pt nv_gui_a_pt

forward prototypes
public function unsignedinteger fnv_get_windowing_directory (ref string a_s_directory, unsignedinteger a_i_size)
public function long fnv_send_window_lbutton_down (window a_w_win, int a_i_area)
public function long fnv_get_system_color (integer a_i_type)
public function long fnv_get_line_startpos (graphicobject a_go_win, integer a_i_line)
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

public function unsignedinteger fnv_get_windowing_directory (ref string a_s_directory, unsignedinteger a_i_size);
//*****************************************************************************
// stub function to be overriden in specific environment gui NVO
//*****************************************************************************
RETURN -1
end function

public function long fnv_send_window_lbutton_down (window a_w_win, int a_i_area);
//*****************************************************************************
// stub function to be overriden in specific environment gui NVO
//*****************************************************************************
RETURN -1
end function

public function long fnv_get_system_color (integer a_i_type);
//*****************************************************************************
// stub function to be overriden in specific environment gui NVO
//*****************************************************************************
RETURN -1
end function

public function long fnv_get_line_startpos (graphicobject a_go_win, integer a_i_line);
//*****************************************************************************
// stub function to be overriden in specific environment gui NVO
//*****************************************************************************
RETURN -1
end function

public function long fnv_get_menu (window a_w_win);
//*****************************************************************************
// stub function to override on GUI API
//*****************************************************************************

RETURN 0
end function

public subroutine fnv_draw_menu_bar (window a_w_win);
//*****************************************************************************
// stub function to override on GUI API
//*****************************************************************************

RETURN
end subroutine

public function long fnv_create_menu ();
//*****************************************************************************
// stub function to override on GUI API
//*****************************************************************************

RETURN 0
end function

public function boolean fnv_destroy_menu (long a_l_hmenu);
//*****************************************************************************
// stub function to override on GUI API
//*****************************************************************************

RETURN FALSE
end function

public function boolean fnv_insert_menu (long a_l_hmenu, long a_l_pos, long a_l_flags, long a_l_newid, string a_s_menu_text);
//*****************************************************************************
// stub function to override on GUI API
//*****************************************************************************

RETURN FALSE
end function

public function boolean fnv_remove_menu (long a_l_hmenu, long a_l_itemid, long a_l_flags);
//*****************************************************************************
// stub function to override on GUI API
//*****************************************************************************

RETURN FALSE
end function

public function boolean fnv_control_menu_close (message a_m_msg);
//*****************************************************************************
// stub function to override in GUI API object
//*****************************************************************************

RETURN FALSE
end function

public function boolean fnv_is_lbutton_down (message a_m_msg);
//*****************************************************************************
// stub function to override in GUI API object
//*****************************************************************************

RETURN FALSE
end function

public function boolean fnv_user_wordparm (message a_m_msg);
//*****************************************************************************
// stub function to override on GUI API
//*****************************************************************************

RETURN FALSE
end function

public function boolean fnv_is_window_active (ref string a_s_title);
//*****************************************************************************
// stub function to be overriden in specific environment gui NVO
//*****************************************************************************
RETURN FALSE
end function

on nv_gui_a_pt.create
TriggerEvent( this, "constructor" )
end on

on nv_gui_a_pt.destroy
TriggerEvent( this, "destructor" )
end on

