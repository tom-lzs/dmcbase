$PBExportHeader$u_ddplba_pt.sru
$PBExportComments$Ancêtre des DropDownPictureListBox
forward
global type u_ddplba_pt from dropdownpicturelistbox
end type
end forward

global type u_ddplba_pt from dropdownpicturelistbox
int Width=302
int Height=237
int TabOrder=1
boolean VScrollBar=true
long BackColor=16777215
int TextSize=-8
int Weight=700
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
string PictureName[]={"Custom039!"}
long PictureMaskColor=536870912
event we_nchittest pbm_nchittest
end type
global u_ddplba_pt u_ddplba_pt

type variables
PROTECTED:

String i_s_microhelp		// Default MicroHelp for Object focus
String i_s_helpkey		// Default key into Help file
end variables

forward prototypes
public function string fu_get_help_key ()
public function string fu_get_microhelp ()
public subroutine fu_set_microhelp (string a_s_microhelp)
public subroutine fu_set_help_key (string a_s_help_key)
end prototypes

event we_nchittest;// Set Microhelp

IF IsValid(g_w_frame) THEN
	g_w_frame.fw_setmicrohelp (this.fu_get_microhelp())
END IF

end event

public function string fu_get_help_key ();RETURN i_s_helpkey
end function

public function string fu_get_microhelp ();RETURN i_s_microhelp
end function

public subroutine fu_set_microhelp (string a_s_microhelp);i_s_microhelp = a_s_microhelp
end subroutine

public subroutine fu_set_help_key (string a_s_help_key);i_s_helpkey = a_s_help_key
end subroutine

