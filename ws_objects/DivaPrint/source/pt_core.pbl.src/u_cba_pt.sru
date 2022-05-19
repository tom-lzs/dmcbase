$PBExportHeader$u_cba_pt.sru
$PBExportComments$Ancêtre de tous les boutons
forward
global type u_cba_pt from commandbutton
end type
end forward

global type u_cba_pt from commandbutton
int Width=353
int Height=97
int TabOrder=1
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
event we_nchittest pbm_nchittest
end type
global u_cba_pt u_cba_pt

type variables
PROTECTED:

Window i_w_parent		// Button's parent (Window)
UserObject i_u_parent	// Button's parent (UserObject)

Object i_o_parent_type	// Button's parent Type

String i_s_event		// Event to be triggered when button clicked

String i_s_microhelp	// Default MicroHelp for Object focus
String i_s_helpkey		// Default key into Help file
end variables

forward prototypes
public function string fu_setevent (string a_s_event)
public function string fu_getevent ()
public subroutine fu_set_microhelp (string a_s_microhelp)
public subroutine fu_set_helpkey (string a_s_helpkey)
public function string fu_get_microhelp ()
public function string fu_get_helpkey ()
public function graphicobject fu_getparent ()
public subroutine fu_setparent (graphicobject a_go_parent)
end prototypes

on we_nchittest;// Set MicroHelp.

IF IsValid (g_w_frame) THEN
	g_w_frame.fw_setmicrohelp (this.fu_get_microhelp ())
END IF
end on

public function string fu_setevent (string a_s_event);// Set the event to be triggered by this button
i_s_event = a_s_event

RETURN i_s_event
end function

public function string fu_getevent ();// Return the name of the event to be triggered by this button
RETURN i_s_event
end function

public subroutine fu_set_microhelp (string a_s_microhelp);// Set value of instance variable to value passed.

i_s_microhelp = a_s_microhelp
end subroutine

public subroutine fu_set_helpkey (string a_s_helpkey);// Set value of instance variable to value passed.

i_s_helpkey = a_s_helpkey
end subroutine

public function string fu_get_microhelp ();// Return value of instance variable.

RETURN i_s_microhelp
end function

public function string fu_get_helpkey ();// Return value of instance variable.

RETURN i_s_helpkey
end function

public function graphicobject fu_getparent ();// Return the parent (window or user object) as stored in the
// appropriate instance variable.

IF i_o_parent_type = Window! THEN
	RETURN i_w_parent
ELSE
	RETURN i_u_parent
END IF
end function

public subroutine fu_setparent (graphicobject a_go_parent);// Set the parent (window or user object) for this button based on
// the type of the object.

i_o_parent_type = a_go_parent.TypeOf ()

CHOOSE CASE i_o_parent_type
	CASE Window!
		i_w_parent = a_go_parent
	CASE UserObject!
		i_u_parent = a_go_parent
END CHOOSE
end subroutine

on clicked;// Button may be placed on either a Window or a Custom User Object

CHOOSE CASE i_o_parent_type
CASE Window!
	i_w_parent.TriggerEvent (i_s_event)
CASE UserObject!
	i_u_parent.TriggerEvent (i_s_event)
END CHOOSE
end on

on constructor;// Button may be placed on either a Window or a Custom User Object

i_o_parent_type = TypeOf (parent)

CHOOSE CASE i_o_parent_type
CASE Window!
	i_w_parent = parent
CASE UserObject!
	i_u_parent = parent
END CHOOSE
end on

