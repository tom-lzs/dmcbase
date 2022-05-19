$PBExportHeader$nv_components_ext_a.sru
$PBExportComments$PowerCerv External components versioning ancestor
forward
global type nv_components_ext_a from nonvisualobject
end type
end forward

global type nv_components_ext_a from nonvisualobject
end type
global nv_components_ext_a nv_components_ext_a

type variables
PROTECTED:

  // known external library component ids
  integer		ic_i_pc_admin = 1		// version checking library
  integer		ic_i_pt_osd = 2			// OS disk/file services
  integer		ic_i_pt_orca = 3		// ORCA API services

end variables

forward prototypes
public function string fnv_get_library_version (integer a_i_library_id)
public function string fnv_get_library_name (integer a_i_library_id)
public function boolean fnv_library_exists (integer a_i_library_id)
end prototypes

public function string fnv_get_library_version (integer a_i_library_id);
//*****************************************************************************
// stub function overridden on environment object
//*****************************************************************************
RETURN ""
end function

public function string fnv_get_library_name (integer a_i_library_id);
//*****************************************************************************
// stub function overridden on environment object
//*****************************************************************************
RETURN ""
end function

public function boolean fnv_library_exists (integer a_i_library_id);
//*****************************************************************************
// stub function overridden on environment object
//*****************************************************************************
RETURN FALSE
end function

on nv_components_ext_a.create
TriggerEvent( this, "constructor" )
end on

on nv_components_ext_a.destroy
TriggerEvent( this, "destructor" )
end on

