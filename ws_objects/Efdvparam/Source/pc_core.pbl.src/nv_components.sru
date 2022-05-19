$PBExportHeader$nv_components.sru
$PBExportComments$Component validatation and version info object
forward
global type nv_components from nonvisualobject
end type
end forward

global type nv_components from nonvisualobject
end type
global nv_components nv_components

type prototypes

end prototypes

type variables
PROTECTED:

  string		i_s_libraries[]			// library name
  boolean		i_b_lib_included[]		// found library in path?
  boolean		i_b_lib_access[]		// user access to lib
  string		i_s_version[]			// lib version number
  string		i_s_release[]			// lib release date
  string		i_s_description[]		// lib description

  // environment external versioning api
  nv_components_ext_a		i_nv_comp

  // constants (known components and descriptions)
  string		ic_s_libraries[]
  string		ic_s_description[]

  // known external library component ids
  integer		ic_i_pc_admin = 1		// version checking library
  integer		ic_i_pt_osd = 2			// OS disk/file services
  integer		ic_i_pt_orca = 3		// ORCA API services

end variables

forward prototypes
public function boolean fnv_external_library_exists (integer a_i_library_id)
public function string fnv_get_external_name (integer a_i_library_id)
public function string fnv_get_external_version (integer a_i_library_id)
protected subroutine fnv_store_external_version (integer a_i_library_id, integer a_i_idx)
public function boolean fnv_get_user_access (string a_s_library)
public subroutine fnv_init_component_list ()
public function boolean fnv_is_library_installed (string a_s_library)
public function string fnv_library_description (ref string a_s_library)
public function string fnv_library_list (boolean a_b_all)
public function string fnv_library_list_versions (boolean a_b_all)
public function string fnv_library_release (string a_s_library)
public function string fnv_library_version (string a_s_library)
public subroutine fnv_set_user_access (string a_s_library, ref str_user a_str_user, transaction a_trans)
end prototypes

public function boolean fnv_external_library_exists (integer a_i_library_id);
//*****************************************************************************
// Test for existence of external dll (convenience function)
//	  Assumes:
//		external component checker instantiated
//   Arguments:
//     a_i_library_id	constant integer id of non-PB component
//   Returns:
//     boolean			library exists: TRUE or FALSE
//*****************************************************************************
IF IsValid (i_nv_comp) THEN
	RETURN i_nv_comp.fnv_library_exists (a_i_library_id)
END IF
RETURN FALSE
end function

public function string fnv_get_external_name (integer a_i_library_id);
//*****************************************************************************
// Get external dll filename (convenience function)
//	  Assumes:
//		external component checker instantiated
//   Arguments:
//     a_i_library_id	constant integer id of non-PB component
//   Returns:
//     string			library name or empty string
//*****************************************************************************
IF IsValid (i_nv_comp) THEN
	RETURN i_nv_comp.fnv_get_library_name (a_i_library_id)
END IF
RETURN ""
end function

public function string fnv_get_external_version (integer a_i_library_id);
//*****************************************************************************
// Get external dll version info (convenience function)
//	  Assumes:
//		external component checker instantiated
//   Arguments:
//     a_i_library_id	constant integer id of non-PB component
//   Returns:
//     string			version block or empty string
//*****************************************************************************
IF IsValid (i_nv_comp) THEN
	RETURN i_nv_comp.fnv_get_library_version (a_i_library_id)
END IF
RETURN ""
end function

protected subroutine fnv_store_external_version (integer a_i_library_id, integer a_i_idx);
//*****************************************************************************
// stores external dll version info in list
//	  Assumes:
//		a) version info provided as DLL resource
//		b) local version info fields have been initialized before calling;
//        on error condition function returns without setting version info.
//   Arguments:
//     a_i_library_id	constant integer id of non-PB component
//     a_i_idx         index to use for storing version info
//   Returns:
//     none
//*****************************************************************************
string          s_buffer
int             i_start, i_pos, i_len

s_buffer = fnv_get_external_version (a_i_library_id)

IF s_buffer <> "" THEN

	i_start = 1
	i_pos = Pos (s_buffer, "~t", i_start)
	i_len = i_pos - i_start
	i_s_version[a_i_idx] = Mid (s_buffer, i_start, i_len)
	i_start = i_pos + 1

	i_pos = Pos (s_buffer, "~t", i_start)
	i_len = i_pos - i_start
	i_s_release[a_i_idx] = Mid (s_buffer, i_start, i_len)
	i_start = i_pos + 1

	i_pos = Pos (s_buffer, "~r~n", i_start)
	i_len = i_pos - i_start
	i_s_description[a_i_idx] = Mid (s_buffer, i_start, i_len)

END IF

end subroutine

public function boolean fnv_get_user_access (string a_s_library);
//*****************************************************************************
// get user access rights to specified library
//	  Assumption:
//		fnv_set_user_access has been called
//   Arguments:
//     a_s_library		name of library
//   Returns:
//		boolean			access rights (TRUE or FALSE)
//*****************************************************************************
int	i, n
string	s_lib

s_lib = Lower (a_s_library)

// look for library in array
n = UpperBound ( i_s_libraries ) 
FOR i = 1 TO n 
	IF i_s_libraries[i] = s_lib THEN 
		RETURN i_b_lib_access[i] 
	END IF 
NEXT
RETURN FALSE
end function

public subroutine fnv_init_component_list ();
//********************************************************************
// initialize PB and external component list
//********************************************************************
int		i, n
string	s_null[]
boolean	b_null[]

// reset arrarys
i_s_libraries[] = s_null[]
i_b_lib_included[] = b_null[]
i_b_lib_access[] = b_null[]
i_s_version[] = s_null[]
i_s_release[] = s_null[]
i_s_description[] = s_null[]

n = UpperBound (ic_s_libraries)

FOR i = 1 TO n 
	i_s_description[i] = ic_s_description[i]
	this.fnv_is_library_installed (ic_s_libraries[i])
NEXT

// check external libraries
n = n + 1

i_s_libraries[n] = fnv_get_external_name (ic_i_pc_admin)
i_b_lib_included[n] = FALSE
i_b_lib_access[n] = FALSE
i_s_description[n] = "PowerCerv Administration Services Library"

i_s_libraries[n+1] = fnv_get_external_name (ic_i_pt_orca)
i_b_lib_included[n+1] = FALSE
i_b_lib_access[n+1] = FALSE
i_s_description[n+1] = "PowerTOOL ORCA API Services Library"

IF fnv_external_library_exists (ic_i_pt_orca) THEN
	i_b_lib_included[n+1] = TRUE
	i_s_version[n+1] = "N/A"
	i_s_release[n+1] = "N/A"
END IF

i_s_libraries[n+2] = fnv_get_external_name (ic_i_pt_osd)
i_b_lib_included[n+2] = FALSE
i_b_lib_access[n+2] = FALSE
i_s_description[n+2] = "PowerTOOL OS Disk Services Library"

IF fnv_external_library_exists (ic_i_pt_osd) THEN
	i_b_lib_included[n+2] = TRUE
	i_s_version[n+2] = "N/A"
	i_s_release[n+2] = "N/A"
END IF

// if version DLL present
IF fnv_external_library_exists (ic_i_pc_admin) THEN
	
	IF fnv_external_library_exists (ic_i_pt_osd) THEN
		fnv_store_external_version (ic_i_pt_osd, n+2)
	END IF
	
	IF fnv_external_library_exists (ic_i_pt_orca) THEN
		fnv_store_external_version (ic_i_pt_orca, n+1)
	END IF

	i_b_lib_included[n] = TRUE
	i_s_version[n] = "N/A"
	i_s_release[n] = "N/A"
	fnv_store_external_version (ic_i_pc_admin, n)

END IF
end subroutine

public function boolean fnv_is_library_installed (string a_s_library);
//*****************************************************************************
// Tests for installed products
//   Process:
//   	First check array to see if it has already been determined whether
//     product is installed.  Then look for presence of a datawindow object
//     in the form "d_" + library name + "_ver".  If found, also store
//     version information.
//   Arguments:
//     a_s_library             name of library
//   Returns:
//     boolean                 library is/is not installed
//*****************************************************************************
int			i, n 
boolean		b_return 
string		s_lib
DataStore	ds_components

s_lib = Lower (a_s_library)

// look for library in array
n = UpperBound ( i_s_libraries ) 
FOR i = 1 TO n 
	IF i_s_libraries[i] = s_lib THEN 
		RETURN i_b_lib_included[i] 
	END IF 
NEXT 

// look for library version datawindow
ds_components = CREATE DataStore
ds_components.dataobject = "d_" + s_lib + "_ver" 
IF ds_components.RowCount () > 0 THEN 
	b_return = TRUE 
ELSE 
	b_return = FALSE 
END IF 

// store this library and installed boolean
i_s_libraries[n+1] = s_lib 
i_b_lib_included[n+1] = b_return 
i_b_lib_access[n+1] = FALSE 

// if installed, also save version info
i_s_version[n+1] = ""
i_s_release[n+1] = ""
IF b_return = TRUE THEN
	i_s_version[n+1] = ds_components.GetItemString (1, "version")
	i_s_release[n+1] = String (ds_components.GetItemDate &
							(1, "release"), "dd/mm/yyyy")
	i_s_description[n+1] = ds_components.GetItemString (1, "description")
END IF

DESTROY ( ds_components )

RETURN b_return 

end function

public function string fnv_library_description (ref string a_s_library);
//*****************************************************************************
// Returns library description string
//   Assumption:
//     fnv_is_library_installed has been called and returned true,
//     otherwise this always returns empty string.
//   Arguments:
//     a_s_library		name of library
//   Returns:
//     string			instance variable with description or empty string
//*****************************************************************************
int		i, n 
string		s_lib

s_lib = Lower (a_s_library)

// look for library in array
n = UpperBound ( i_s_libraries ) 
FOR i = 1 TO n 
	IF i_s_libraries[i] = s_lib THEN 
		RETURN i_s_description[i] 
	END IF 
NEXT
RETURN ""
end function

public function string fnv_library_list (boolean a_b_all);
//*****************************************************************************
// Build list of all or installed product libraries
//   Assumes:
//     fnv_is_library_installed has been called
//   Process:
//     Determine number of products listed.  Check boolean request for all or
//     only installed and for each, add string to buffer in form:
//     	"library ~r~n"
//   Arguments:
//     boolean		a_b_all, if true request is for all libraries,
//                          if false request is for installed libraries
//   Returns:
//     string      Products library list
//*****************************************************************************
int             i, n
string          s_buffer

n = UpperBound (i_s_libraries)
IF n < 1 THEN
	RETURN ""
END IF

FOR i = 1 TO n
	IF a_b_all = TRUE THEN
		s_buffer =      s_buffer + i_s_libraries[i] + "~r~n"
	ELSE
		IF i_b_lib_included[i] = TRUE THEN
			s_buffer =      s_buffer + i_s_libraries[i] + "~r~n"
		END IF
	END IF
NEXT

RETURN s_buffer

end function

public function string fnv_library_list_versions (boolean a_b_all);
//*****************************************************************************
// Build list of installed products
//   Assumes:
//     fnv_is_library_installed has been called
//   Process:
//     Determine number of products listed.  For each installed, add string to
//     buffer in form: "library ~t version ~t release ~t description ~r~n
//   Arguments:
//     boolean        a_b_all, if true include all libraries and fill incomplete
//                             version information with " "
//                             if false only return installed library version info
//   Returns:
//     string         Products version list
//*****************************************************************************
int             i, n
string          s_buffer

n = UpperBound (i_s_libraries)
IF n < 1 THEN
	RETURN ""
END IF

IF a_b_all = TRUE THEN
	// list all libraries
	FOR i = 1 TO n
		IF i_b_lib_included[i] = TRUE THEN
			s_buffer =      s_buffer + &
					i_s_libraries[i] + "~t" + &
					i_s_version[i] + "~t" + &
					i_s_release[i] + "~t" + &
					i_s_description[i] + "~r~n"
		ELSE
			s_buffer =      s_buffer + &
					i_s_libraries[i] + "~t" + &
					" ~t" + " ~t" + i_s_description[i] + " : Not Found~r~n"
		END IF
	NEXT
ELSE
	// only return installed list
	FOR i = 1 TO n
		IF i_b_lib_included[i] = TRUE THEN
			s_buffer =      s_buffer + &
					i_s_libraries[i] + "~t" + &
					i_s_version[i] + "~t" + &
					i_s_release[i] + "~t" + &
					i_s_description[i] + "~r~n"
		END IF
	NEXT
END IF

RETURN s_buffer

end function

public function string fnv_library_release (string a_s_library);
//*****************************************************************************
// Returns library release date string
//   Assumption:
//     fnv_is_library_installed has been called and returned true,
//     otherwise this always returns empty string.
//   Arguments:
//     a_s_library     name of library
//   Returns:
//     string          instance variable with release date or empty string
//*****************************************************************************
int		i, n 
string		s_lib

s_lib = Lower (a_s_library)

// look for library in array
n = UpperBound ( i_s_libraries ) 
FOR i = 1 TO n 
	IF i_s_libraries[i] = s_lib THEN 
		RETURN i_s_release[i] 
	END IF 
NEXT
RETURN ""
end function

public function string fnv_library_version (string a_s_library);
//*****************************************************************************

// Returns library version string
//	  Assumption:
//   	fnv_is_library_installed has been called and returned true,
//     otherwise this always returns empty string.
//   Arguments:
//     a_s_library             name of library
//   Returns:
//     string                  instance variable with version or empty string
//*****************************************************************************
int		i, n 
string		s_lib

s_lib = Lower (a_s_library)

// look for library in array
n = UpperBound ( i_s_libraries ) 
FOR i = 1 TO n 
	IF i_s_libraries[i] = s_lib THEN 
		RETURN i_s_version[i] 
	END IF 
NEXT
RETURN ""
end function

public subroutine fnv_set_user_access (string a_s_library, ref str_user a_str_user, transaction a_trans);
//*****************************************************************************
// Set user access rights to specified library
//	  Assumption:
//		fnv_is_library_installed has been called and connection to 
//		common products database is established.
//   Arguments:
//		a_s_library		name of library
//		a_str_user		user structure for logged on user
//		a_trans			transaction object
//   Returns:
//		none
//*****************************************************************************
int		i, n, idx
string		s_lib

s_lib = Lower (a_s_library)

// look for library in array
n = UpperBound ( i_s_libraries ) 
idx = 0
FOR i = 1 TO n 
	IF i_s_libraries[i] = s_lib THEN 
		idx = i
		EXIT
	END IF 
NEXT
IF idx = 0 THEN
	RETURN
END IF

// default to no access
i_b_lib_access[idx] = FALSE

// check for "super user"
IF a_str_user.l_user_skey = 0 THEN
	i_b_lib_access[idx] = TRUE
	RETURN
END IF

// only certain libraries (products) have security
CHOOSE CASE s_lib

	CASE "pt_admin"										// PowerTOOL navigation
		i_b_lib_access[idx] = TRUE


	CASE "pl_admin"										// object security

		SELECT DISTINCT pl_group_def.sec_admin_ind 
	       INTO :i
	       FROM pl_group_def, pl_profile_group  
	      WHERE (pl_group_def.group_skey = pl_profile_group.group_skey) 
			AND (pl_profile_group.profile_skey = :a_str_user.l_profile_skey) 
		    AND (pl_group_def.sec_admin_ind = 1) 
		  USING a_trans
		 ; 

		IF (a_trans.SQLcode <> 0) THEN
			RETURN
		END IF
		i_b_lib_access[idx] = TRUE


	CASE "fb_admin"										// FLOWBuilder

		SELECT DISTINCT fb_role_def.fb_admin_ind 
	       INTO :i
	       FROM fb_role_def, fb_profile_role 
	      WHERE (fb_role_def.role_nbr = fb_profile_role.role_nbr) 
			AND (fb_profile_role.profile_skey = :a_str_user.l_profile_skey) 
			AND (fb_role_def.fb_admin_ind = 1) 
			USING a_trans
		 ; 

		IF (a_trans.SQLcode <> 0) THEN
			RETURN
		END IF
		i_b_lib_access[idx] = TRUE

END CHOOSE
end subroutine

event constructor;
//*****************************************************************************
int	n
Environment	env

// initialize constants for known PB components
n = 1
ic_s_libraries[n] = "fb_admin"
ic_s_description[n] = "FLOWBuilder Administration"
n++
ic_s_libraries[n] = "fb_async"
ic_s_description[n] = "FLOWBuilder Async Server"
n++
ic_s_libraries[n] = "fb_synch"
ic_s_description[n] = "FLOWBuilder Sync Server"
n++
ic_s_libraries[n] = "fb_wflow"
ic_s_description[n] = "FLOWBuilder Workflow Component"
n++
ic_s_libraries[n] = "pc_admin"
ic_s_description[n] = "PowerPerformance Administration"
n++
ic_s_libraries[n] = "pl_admin"
ic_s_description[n] = "PADLock Administration"
n++
ic_s_libraries[n] = "pl_cntxt"
ic_s_description[n] = "PADLock Context-sensitive Security Component"
n++
ic_s_libraries[n] = "pl_core"
ic_s_description[n] = "PADLock Core Library"
n++
ic_s_libraries[n] = "pt_admin"
ic_s_description[n] = "PowerTOOL NAV Administration"
n++
ic_s_libraries[n] = "pt_nav"
ic_s_description[n] = "PowerTOOL NAV Library"

// instantiate appropriate external interface
//  (used local rather than g_nv_env to avoid dependence)
GetEnvironment (env)
CHOOSE CASE env.OSType
	CASE WindowsNT!
		i_nv_comp = CREATE nv_components_win32
END CHOOSE

end event

on nv_components.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nv_components.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

on destructor;
//*****************************************************************************
// destroy valid external components api object
//*****************************************************************************

IF IsValid (i_nv_comp) THEN
	DESTROY (i_nv_comp)
END IF

end on

