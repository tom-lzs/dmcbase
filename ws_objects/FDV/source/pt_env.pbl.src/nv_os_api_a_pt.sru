$PBExportHeader$nv_os_api_a_pt.sru
$PBExportComments$Services API
forward
global type nv_os_api_a_pt from nonvisualobject
end type
end forward

global type nv_os_api_a_pt from nonvisualobject
end type
global nv_os_api_a_pt nv_os_api_a_pt

type prototypes

end prototypes

forward prototypes
public function int fnv_change_dir (string a_s_directory)
public function int fnv_change_drive (char a_c_drive)
public function int fnv_copy_file (string a_s_source, string a_s_target, boolean a_b_overwrite)
public function int fnv_delete_file (string a_s_filename)
public function long fnv_disk_free_space (char a_c_drive)
public function long fnv_disk_space (char a_c_drive)
public function string fnv_get_env (string a_s_name)
public function int fnv_make_dir (string a_s_directory)
public function int fnv_move_file (string a_s_source, string a_s_target, boolean a_b_delete)
public function int fnv_remove_dir (string a_s_directory)
public function int fnv_rename_file (string a_s_original, string a_s_new)
public function int fnv_get_directory (ref string a_s_directory)
public function string fnv_time_file (ref string a_s_filename, integer a_i_size)
public function unsignedinteger fnv_get_drive (ref string a_s_drive)
public function long fnv_get_open_file_error ()
public function string fnv_get_multi_filenames (window a_w_win, ref string a_s_filetypes, integer a_i_idx, ref string a_s_title)
public function unsignedinteger fnv_get_system_directory (ref string a_s_directory, int a_i_size)
end prototypes

public function int fnv_change_dir (string a_s_directory);
//*****************************************************************************
// stub function to be overriden in specific environment OS NVO
//*****************************************************************************
RETURN -1
end function

public function int fnv_change_drive (char a_c_drive);
//*****************************************************************************
// stub function to be overriden in specific environment OS NVO
//*****************************************************************************
RETURN -1
end function

public function int fnv_copy_file (string a_s_source, string a_s_target, boolean a_b_overwrite);
//*****************************************************************************
// stub function to be overriden in specific environment OS NVO
//*****************************************************************************
RETURN -1
end function

public function int fnv_delete_file (string a_s_filename);
//*****************************************************************************
// stub function to be overriden in specific environment OS NVO
//*****************************************************************************
RETURN -1
end function

public function long fnv_disk_free_space (char a_c_drive);
//*****************************************************************************
// stub function to be overriden in specific environment OS NVO
//*****************************************************************************
RETURN -1
end function

public function long fnv_disk_space (char a_c_drive);
//*****************************************************************************
// stub function to be overriden in specific environment OS NVO
//*****************************************************************************
RETURN -1
end function

public function string fnv_get_env (string a_s_name);
//*****************************************************************************
// stub function to be overriden in specific environment OS NVO
//*****************************************************************************
RETURN ""
end function

public function int fnv_make_dir (string a_s_directory);
//*****************************************************************************
// stub function to be overriden in specific environment OS NVO
//*****************************************************************************
RETURN -1
end function

public function int fnv_move_file (string a_s_source, string a_s_target, boolean a_b_delete);
//*****************************************************************************
// stub function to be overriden in specific environment OS NVO
//*****************************************************************************
RETURN -1
end function

public function int fnv_remove_dir (string a_s_directory);
//*****************************************************************************
// stub function to be overriden in specific environment OS NVO
//*****************************************************************************
RETURN -1
end function

public function int fnv_rename_file (string a_s_original, string a_s_new);
//*****************************************************************************
// stub function to be overriden in specific environment OS NVO
//*****************************************************************************
RETURN -1
end function

public function int fnv_get_directory (ref string a_s_directory);
//*****************************************************************************
// stub function to be overriden in specific environment OS NVO
//*****************************************************************************
RETURN -1
end function

public function string fnv_time_file (ref string a_s_filename, integer a_i_size);
//*****************************************************************************
// stub function to be overriden in specific environment OS NVO
//*****************************************************************************
RETURN ""
end function

public function unsignedinteger fnv_get_drive (ref string a_s_drive);
//*****************************************************************************
// stub function to be overriden in specific environment OS NVO
//*****************************************************************************
RETURN -1
end function

public function long fnv_get_open_file_error ();
//*****************************************************************************
// stub function to be overriden in specific environment OS NVO
//*****************************************************************************
RETURN -1
end function

public function string fnv_get_multi_filenames (window a_w_win, ref string a_s_filetypes, integer a_i_idx, ref string a_s_title);
//*****************************************************************************
// stub function to be overriden in specific environment OS NVO
//*****************************************************************************
RETURN ""
end function

public function unsignedinteger fnv_get_system_directory (ref string a_s_directory, int a_i_size);
//*****************************************************************************
// stub function to be overriden in specific environment OS NVO
//*****************************************************************************
RETURN -1
end function

on nv_os_api_a_pt.create
TriggerEvent( this, "constructor" )
end on

on nv_os_api_a_pt.destroy
TriggerEvent( this, "destructor" )
end on

