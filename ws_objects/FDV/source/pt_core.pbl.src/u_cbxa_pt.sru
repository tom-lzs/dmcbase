$PBExportHeader$u_cbxa_pt.sru
$PBExportComments$Ancêtre des CheckBox
forward
global type u_cbxa_pt from checkbox
end type
end forward

global type u_cbxa_pt from checkbox
int Width=243
int Height=69
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=75530240
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
event we_nchittest pbm_nchittest
end type
global u_cbxa_pt u_cbxa_pt

type variables
PROTECTED:

String i_s_microhelp	// Default MicroHelp for Object focus
String i_s_helpkey		// Default key into Help file
end variables

forward prototypes
public subroutine fu_set_microhelp (string a_s_microhelp)
public subroutine fu_set_helpkey (string a_s_helpkey)
public function string fu_get_helpkey ()
public function string fu_get_microhelp ()
end prototypes

on we_nchittest;// Set microhelp

IF IsValid (g_w_frame) THEN
	g_w_frame.fw_setmicrohelp (this.fu_get_microhelp())
END IF

end on

public subroutine fu_set_microhelp (string a_s_microhelp);i_s_microhelp = a_s_microhelp
end subroutine

public subroutine fu_set_helpkey (string a_s_helpkey);i_s_helpkey = a_s_helpkey
end subroutine

public function string fu_get_helpkey ();RETURN i_s_helpkey
end function

public function string fu_get_microhelp ();RETURN i_s_microhelp
end function

