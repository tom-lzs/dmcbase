$PBExportHeader$u_plba_pt.sru
$PBExportComments$Ancêtre des PictureListBox
forward
global type u_plba_pt from picturelistbox
end type
end forward

global type u_plba_pt from picturelistbox
int Width=494
int Height=361
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
global u_plba_pt u_plba_pt

type variables
PROTECTED:

String i_s_microhelp		// Default MicroHelp for Object focus
String i_s_helpkey		// Default key into Help file
end variables

forward prototypes
public subroutine fu_set_microhelp (string a_s_microhelp)
public subroutine fu_set_helpkey (string a_s_helpkey)
public function string fu_get_microhelp ()
public function string fu_get_helpkey ()
public subroutine fu_deselect_all ()
public subroutine fu_select_all ()
end prototypes

event we_nchittest;// Set Microhelp

IF IsValid(g_w_frame) THEN
	g_w_frame.fw_setmicrohelp (this.fu_get_microhelp())
END IF

end event

public subroutine fu_set_microhelp (string a_s_microhelp);i_s_microhelp = a_s_microhelp
end subroutine

public subroutine fu_set_helpkey (string a_s_helpkey);i_s_helpkey = a_s_helpkey
end subroutine

public function string fu_get_microhelp ();RETURN i_s_microhelp
end function

public function string fu_get_helpkey ();RETURN i_s_helpkey
end function

public subroutine fu_deselect_all ();// Deselect every item in a listbox.

// DeSelectAll can not be accomplished if MultiSelect attribute is not
// set to TRUE.

IF NOT this.MultiSelect THEN
	RETURN
END IF


// DeSelect all items.

this.SetState (0, FALSE)
end subroutine

public subroutine fu_select_all ();// Select every item in the listbox.

// SelectAll can not be accomplished if MultiSelect attribute is not
// set to TRUE.

IF NOT this.MultiSelect THEN
	RETURN
END IF


// Select all items.

this.SetState (0, TRUE)
end subroutine

