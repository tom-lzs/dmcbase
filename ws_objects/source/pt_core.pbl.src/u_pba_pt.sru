$PBExportHeader$u_pba_pt.sru
$PBExportComments$Ancêtre des PictureButton
forward
global type u_pba_pt from picturebutton
end type
end forward

global type u_pba_pt from picturebutton
int Width=100
int Height=84
int TabOrder=1
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
event we_nchittest pbm_nchittest
end type
global u_pba_pt u_pba_pt

type variables
PROTECTED:

Window i_w_parent		// Button's parent (Window)
UserObject i_u_parent	// Button's parent (UserObject)

Object i_o_parent_type	//Button's parent Type

String i_s_event		// Event to be triggered when button clicked

String i_s_microhelp	// Default MicroHelp for Object focus
String i_s_helpkey		// Default key into Help file
end variables

forward prototypes
public function string fu_getevent ()
public function window fu_getparent ()
public function string fu_setevent (string a_s_event)
public function window fu_setparent (window a_w_parent)
public subroutine fu_set_microhelp (string a_s_microhelp)
public subroutine fu_set_helpkey (string a_s_helpkey)
public function string fu_get_microhelp ()
public function string fu_get_helpkey ()
end prototypes

on we_nchittest;// Set MicroHelp.

IF IsValid (g_w_frame) THEN
	g_w_frame.fw_setmicrohelp (this.fu_get_microhelp ())
END IF
end on

public function string fu_getevent ();// Return the name of the event to be triggered by this button
RETURN i_s_event
end function

public function window fu_getparent ();// Return the parent window as stored in the instance variable
RETURN i_w_parent
end function

public function string fu_setevent (string a_s_event);// Set the event to be triggered by this button
i_s_event = a_s_event

RETURN i_s_event
end function

public function window fu_setparent (window a_w_parent);// Set the parent window for this button
i_w_parent = a_w_parent

RETURN i_w_parent
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

on constructor;// Button may be placed on either a Window or a Custom User Object

i_o_parent_type = TypeOf (parent)

CHOOSE CASE i_o_parent_type
CASE Window!
	i_w_parent = parent
CASE UserObject!
	i_u_parent = parent
END CHOOSE
end on

on clicked;// Button may be placed on either a Window or a Custom User Object

CHOOSE CASE i_o_parent_type
CASE Window!
	i_w_parent.TriggerEvent (i_s_event)
CASE UserObject!
	i_u_parent.TriggerEvent (i_s_event)
END CHOOSE
end on

