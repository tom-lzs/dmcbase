$PBExportHeader$nv_os_pb2019_pt.sru
$PBExportComments$Système d'exploitation pour Win64
forward
global type nv_os_pb2019_pt from nv_os_api_a
end type
end forward

global type nv_os_pb2019_pt from nv_os_api_a
end type
global nv_os_pb2019_pt nv_os_pb2019_pt

type prototypes
Function uint GetSystemDirectoryA (REF string sBuff, uint uiSize) Library "kernel32.dll" alias for "GetSystemDirectoryA;Ansi"
Function boolean CopyFileA (REF string sSource, REF string sTarget) Library "kernel32.dll" alias for "CopyFileA;Ansi"
Function boolean DeleteFileA (REF string sSource) Library "kernel32.dll" alias for "DeleteFileA;Ansi"

Function string GetFileTime ( REF string s_FileName, REF string s_FileTime ) Library "win32api.dll"

Function long get_totalsize ( string s_Drive ) Library "driveInfo.dll"
Function long get_availablefreespace ( string s_Drive ) Library "driveInfo.dll"

Function string GetEnvironmentVariable ( string s_EnvVarName ) Library "runtime.dll"
Function string GetMultiFilenames ( int h_Wnd, REF string s_Specs, int i_Index, REF string s_Title) Library "win32api.dll"

end prototypes

type variables
PROTECTED:
	string		i_s_files
end variables

forward prototypes
public function integer fnv_change_dir (string a_s_directory)
public function integer fnv_change_drive (character a_c_drive)
protected function string fnv_construct_path (string a_s_directory, string a_s_file)
public function integer fnv_copy_file (string a_s_source, string a_s_target, boolean a_b_overwrite)
public function integer fnv_delete_file (string a_s_filename)
public function long fnv_disk_free_space (character a_c_drive)
public function long fnv_disk_space (character a_c_drive)
public function integer fnv_get_directory (ref string a_s_directory)
public function unsignedinteger fnv_get_drive (ref string a_s_drive)
public function string fnv_get_env (string a_s_name)
public function string fnv_get_multi_filenames (window a_w_win, ref string a_s_filetypes, integer a_i_idx, ref string a_s_title)
public function long fnv_get_open_file_error ()
public function unsignedinteger fnv_get_system_directory (ref string a_s_directory, integer a_i_size)
public function integer fnv_make_dir (string a_s_directory)
public function integer fnv_move_file (string a_s_source, string a_s_target, boolean a_b_delete)
public function integer fnv_remove_dir (string a_s_directory)
public function integer fnv_rename_file (string a_s_original, string a_s_new)
public function string fnv_time_file (ref string a_s_filename, integer a_i_size)
end prototypes

public function integer fnv_change_dir (string a_s_directory);
//*****************************************************************************
// function to change directory (and drive, if necessary)
//*****************************************************************************
string		s_cur_drive
string		s_req_drive

// check for drive designator and make current
IF Mid (a_s_directory, 2, 1) = ":" THEN
	
	s_req_drive = Space(2)
	s_cur_drive = Space(2)
	IF this.fnv_get_drive (s_cur_drive) = -1 THEN
		RETURN -1
	END IF

	s_cur_drive = Mid (s_cur_drive, 1, 1) + ": "
	s_req_drive = Mid (a_s_directory, 1, 1) + ": "

	IF NOT s_cur_drive = s_req_drive THEN
		s_req_drive = Mid (a_s_directory, 1, 1)
		IF this.fnv_change_drive (s_req_drive) = -1 THEN
			RETURN -1
		END IF
	END IF

END IF

IF ChangeDirectory (a_s_directory) = 1 THEN
	RETURN 0
END IF 

RETURN -1
end function

public function integer fnv_change_drive (character a_c_drive);
//*****************************************************************************
char	c_drive

c_drive = Upper (a_c_drive)
IF c_drive < 'A' OR c_drive > 'Z' THEN
	RETURN -1
END IF

IF ChangeDirectory (String (c_drive) + ":\")  = 1 THEN
	RETURN 0
END IF

RETURN -1
end function

protected function string fnv_construct_path (string a_s_directory, string a_s_file);
//*****************************************************************************
// Construct path from dir and file arguments
// 	Check for full and relative paths in a_s_file; if not either, 
//		use a_s_directory to construct full path.
//		(This function called by fnv_parse_filenames.)
//	Arguments:
//		string	a_s_directory		Directory name (without trailing '\')
//		string	a_s_file	File name (may be full or relative pathname)
//	Returns:
//		string	s_path		Full pathname or empty string
//*****************************************************************************

string	s_path, s_parent
string	s_first_char
int		i_pos, i_len, i_start, i_slash_pos

// check for colon and assume full path
i_pos = Pos (a_s_file, ":", 1)
IF i_pos > 0 THEN
	
	s_path = a_s_file

ELSE
	
	i_len = Len (a_s_file)
	s_first_char = Mid (a_s_file, 1, 1)

	IF s_first_char = "." THEN				//relative to parent directory

		// find last "\"
		i_start = 1
		i_slash_pos = 0
		i_pos = Pos (a_s_directory, "\", i_start)
		DO WHILE i_pos > 0
			i_slash_pos = i_pos
			i_start = i_pos + 1
			i_pos = Pos (a_s_directory, "\", i_start)
		LOOP

		// if not found assume a_s_directory is volume
		IF i_slash_pos = 0 THEN
			s_parent = a_s_directory
		ELSE
			// don't include slash
			s_parent = Mid (a_s_directory, 1, i_slash_pos - 1)
		END IF

		// parent does not include slash, file does
		s_path = s_parent + Mid (a_s_file, 3, i_len - 2)

	ELSEIF s_first_char = "\" THEN			// relative to root directory

		s_path = Mid (a_s_directory, 1, 2) + a_s_file

	ELSE									// relative to current directory

		s_path = a_s_directory + "\" + a_s_file

	END IF
	
END IF

// confirm file still exists
IF NOT FileExists (s_path) THEN
	s_path = ""
END IF

RETURN s_path
end function

public function integer fnv_copy_file (string a_s_source, string a_s_target, boolean a_b_overwrite);
//*****************************************************************************
IF FileCopy (a_s_source, a_s_target, a_b_overwrite) <> 1 THEN
	RETURN -1
END IF
RETURN 1
end function

public function integer fnv_delete_file (string a_s_filename);
//*****************************************************************************
IF FileDelete (a_s_filename) THEN
	RETURN 0
END IF

RETURN -1
end function

public function long fnv_disk_free_space (character a_c_drive);
//*****************************************************************************
char	c_drive

// upper case drive and check for blank
c_drive = Upper (a_c_drive)
IF c_drive < 'A' OR c_drive > 'Z' THEN
	RETURN -1
END IF

// call DLL for disk free space
RETURN get_availablefreespace(String (c_drive) + ":\")
end function

public function long fnv_disk_space (character a_c_drive);
//*****************************************************************************
char	c_drive

// upper case drive and check for blank
c_drive = Upper (a_c_drive)
IF c_drive < 'A' OR c_drive > 'Z' THEN
	RETURN -1
END IF

// call DLL for disk space
// CBE
RETURN get_totalsize (String (c_drive) + ":\")
end function

public function integer fnv_get_directory (ref string a_s_directory);
//*****************************************************************************
// call DLL function
IF ChangeDirectory (a_s_directory) < 1 THEN
	RETURN -1
END IF

RETURN 1

end function

public function unsignedinteger fnv_get_drive (ref string a_s_drive);
//*****************************************************************************
// CBE
//a_s_drive = PTOSD_GetDrive (a_s_drive)
//IF IsNull (a_s_drive) OR a_s_drive = " " THEN
//	RETURN -1
//END IF

IF (DirectoryExists (a_s_drive)) = False THEN
	RETURN -1
END IF

RETURN 1
end function

public function string fnv_get_env (string a_s_name);
//*****************************************************************************
string s_var
s_var = GetEnvironmentVariable (a_s_name)
IF IsNull (s_var) or s_var = " " THEN
	RETURN ""
END IF

RETURN s_var
end function

public function string fnv_get_multi_filenames (window a_w_win, ref string a_s_filetypes, integer a_i_idx, ref string a_s_title);
//*****************************************************************************
// Call DLL to select multiple filenames
//	Arguments:
//		a_w_win			window owning dialog box
//		a_s_filetypes	string containing filetypes
//		a_i_idx			integer index of default filetype
//		a_s_title		optional title for dialog window
//	Returns
//		string			tab-delimited list of names or empty string
//********************************F*********************************************
string		s_files
string		s_file[]
int		i_count, i
uint	ui_h_wnd

i_count = 0
ui_h_wnd = Handle (a_w_win)
// CBE
//i_s_files = PTOSD_GetMultiFilenames (ui_h_wnd, &
//				a_s_filetypes, a_i_idx, a_s_title)
//IF i_s_files <> "" THEN
//	// must parse titles
//	i_count = this.fnv_parse_filenames (s_file[])
//END IF

s_files = ""
FOR i = 1 TO i_count
	s_files = s_files + s_file[i] + "~t"
NEXT

RETURN s_files

end function

public function long fnv_get_open_file_error ();
//*****************************************************************************
// CBE 
RETURN 1
//RETURN PTOSD_GetOpenFileError()
end function

public function unsignedinteger fnv_get_system_directory (ref string a_s_directory, integer a_i_size);
//*****************************************************************************
// Win32 SDK call to get Windows system directory
//*****************************************************************************
RETURN GetSystemDirectoryA (a_s_directory, a_i_size)
end function

public function integer fnv_make_dir (string a_s_directory);
//*****************************************************************************
IF CreateDirectory (a_s_directory) = 1 THEN
	RETURN 0
END IF

RETURN -1
end function

public function integer fnv_move_file (string a_s_source, string a_s_target, boolean a_b_delete);
//*****************************************************************************
IF a_b_delete THEN
	IF CopyFileA (a_s_source, a_s_target) THEN
		DeleteFileA (a_s_source)
	ELSE
		RETURN -1
	END IF
	RETURN 1
END IF

// no delete source
IF CopyFileA (a_s_source, a_s_target) THEN
	RETURN 1
END IF
RETURN -1
end function

public function integer fnv_remove_dir (string a_s_directory);
//*****************************************************************************
IF RemoveDirectory (a_s_directory) = 1 THEN
	RETURN 0
END IF

RETURN -1
end function

public function integer fnv_rename_file (string a_s_original, string a_s_new);
//*****************************************************************************
IF FileMove (a_s_original, a_s_new) = 1 THEN
	RETURN 0
END IF

RETURN -1
end function

public function string fnv_time_file (ref string a_s_filename, integer a_i_size);
//*****************************************************************************
string	s_timestamp

s_timestamp = Space (a_i_size)

s_timestamp = GetFileTime (a_s_filename, s_timestamp)
IF IsNull (s_timestamp) OR s_timestamp = "" THEN
	RETURN ""
END IF
RETURN (s_timestamp)

end function

on nv_os_pb2019_pt.create
call super::create
end on

on nv_os_pb2019_pt.destroy
call super::destroy
end on

