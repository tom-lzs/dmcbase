$PBExportHeader$u_ole2a_pt.sru
$PBExportComments$Ancêtre des contrôles OLE2.0
forward
global type u_ole2a_pt from olecontrol
end type
end forward

global type u_ole2a_pt from olecontrol
int Width=494
int Height=361
int TabOrder=1
long BackColor=16777215
boolean FocusRectangle=false
omActivation Activation=ActivateOnDoubleClick!
omContentsAllowed ContentsAllowed=ContainsAny!
omDisplayType DisplayType=DisplayAsContent!
event we_nchittest pbm_nchittest
end type
global u_ole2a_pt u_ole2a_pt

type variables
PROTECTED:

String i_s_microhelp		// Default MicroHelp for Object focus
String i_s_helpkey		// Default key into Help file
end variables

forward prototypes
public subroutine fu_set_microhelp (string a_s_microhelp)
public subroutine fu_set_helpkey (string a_s_helpkey)
public function string fu_get_helpkey ()
public function string fu_get_microhelp ()
end prototypes

event we_nchittest;// Set MicroHelp.

IF IsValid (g_w_frame) THEN
	g_w_frame.fw_setmicrohelp (this.fu_get_microhelp ())
END IF
end event

public subroutine fu_set_microhelp (string a_s_microhelp);i_s_microhelp = a_s_microhelp
end subroutine

public subroutine fu_set_helpkey (string a_s_helpkey);i_s_helpkey = a_s_helpkey
end subroutine

public function string fu_get_helpkey ();RETURN i_s_helpkey
end function

public function string fu_get_microhelp ();RETURN i_s_microhelp
end function

