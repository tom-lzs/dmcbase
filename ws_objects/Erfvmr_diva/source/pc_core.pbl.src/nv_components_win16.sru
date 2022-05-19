$PBExportHeader$nv_components_win16.sru
$PBExportComments$PowerCerv Win 16 components versioning (from nv_components_ext_a)
forward
global type nv_components_win16 from nv_components_ext_a
end type
end forward

global type nv_components_win16 from nv_components_ext_a
end type
global nv_components_win16 nv_components_win16

type prototypes
function integer PCADM_GetFileVersionInfo (REF string a_s_file, REF string s_ver_block) LIBRARY "pcadmw16.dll" alias for "PCADM_GetFileVersionInfo;Ansi"
end prototypes

type variables

end variables

forward prototypes
public function string fnv_get_library_version (integer a_i_library_id)
public function string fnv_get_library_name (integer a_i_library_id)
public function boolean fnv_library_exists (integer a_i_library_id)
end prototypes

public function string fnv_get_library_version (integer a_i_library_id);
//*****************************************************************************
// function to call external API for version information
//	Arguments:
//		a_i_library_id		integer constant external component id
//	Returns:
//		string				version block or empty string
//*****************************************************************************
string		s_name
string		s_buffer

// can't make external version call without pcadm library
IF NOT fnv_library_exists (ic_i_pc_admin) THEN
	RETURN ""
END IF

s_name = this.fnv_get_library_name (a_i_library_id)

IF s_name <> "" THEN
	s_buffer = Space (256)
	IF PCADM_GetFileVersionInfo (s_name, s_buffer) > 0 THEN
		RETURN s_buffer
	ELSE
		RETURN ""
	END IF
ELSE
	RETURN ""
END IF

end function

public function string fnv_get_library_name (integer a_i_library_id);
//*****************************************************************************
// function to return OS filename for specified library
//	Arguments:
//		a_i_library_id		integer constant external component id
//	Returns:
//		string				name of library or empty string
//*****************************************************************************
CHOOSE CASE a_i_library_id
	CASE ic_i_pc_admin
		RETURN "pcadmw16.dll"
	CASE ic_i_pt_osd
		RETURN "ptosdw16.dll"
	CASE ic_i_pt_orca
		RETURN "ptorcw16.dll"
	CASE ELSE 
		RETURN ""
END CHOOSE
end function

public function boolean fnv_library_exists (integer a_i_library_id);
//*****************************************************************************
// function to determine if external component exists
//	Arguments:
//		a_i_library_id		integer constant external component id
//	Returns:
//		boolean				TRUE or FALSE, does component exist?
//*****************************************************************************
string		s_name

s_name = this.fnv_get_library_name (a_i_library_id)
IF s_name <> "" THEN
	RETURN FileExists (s_name)
ELSE
	RETURN FALSE
END IF
end function

on nv_components_win16.create
TriggerEvent( this, "constructor" )
end on

on nv_components_win16.destroy
TriggerEvent( this, "destructor" )
end on

