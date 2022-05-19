$PBExportHeader$u_slea_pt.sru
$PBExportComments$Ancêtre des SingleLineEdit
forward
global type u_slea_pt from singlelineedit
end type
end forward

global type u_slea_pt from singlelineedit
int Width=691
int Height=97
int TabOrder=1
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long TextColor=33554432
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
event we_keydown pbm_keydown
event we_keyup pbm_keyup
event we_nchittest pbm_nchittest
event we_char pbm_char
event ue_postchar ( unsignedlong wparam,  long lparam )
event ue_reserved4powertool ( unsignedlong wparam,  long lparam )
end type
global u_slea_pt u_slea_pt

type variables
PROTECTED:

Boolean i_b_autoselect	// Boolean indicating whether Test is automatically selected

String i_s_microhelp	// Default MicroHelp for Object focus
String i_s_helpkey		// Default key into Help file
end variables

forward prototypes
public function boolean fu_set_autoselect (boolean a_b_autoselect)
public function boolean fu_get_autoselect ()
public subroutine fu_set_microhelp (string a_s_microhelp)
public subroutine fu_set_helpkey (string a_s_helpkey)
public function string fu_get_microhelp ()
public function string fu_get_helpkey ()
public subroutine fu_select_all ()
end prototypes

on we_keydown;// The Delete key does not trigger the Char event

IF KeyDown (keyDelete!) THEN
	TriggerEvent ("we_char")
END IF
end on

on we_nchittest;// Set MicroHelp.

IF IsValid (g_w_frame) THEN
	g_w_frame.fw_setmicrohelp (this.fu_get_microhelp ())
END IF
end on

on we_char;// The Char event is triggered before the character is added to the text

PostEvent ("ue_postchar")
end on

public function boolean fu_set_autoselect (boolean a_b_autoselect);Boolean b_return


b_return = i_b_autoselect

i_b_autoselect = a_b_autoselect

Return b_return
end function

public function boolean fu_get_autoselect ();Return i_b_autoselect
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

public subroutine fu_select_all ();// Select all the text in the SLE

this.SelectText (1, Len (this.text))

end subroutine

on getfocus;// Select text if autoselect = TRUE.

IF i_b_autoselect THEN
	this.SelectText (1, Len (this.text))
END IF
end on

