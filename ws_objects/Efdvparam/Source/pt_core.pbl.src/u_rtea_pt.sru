$PBExportHeader$u_rtea_pt.sru
$PBExportComments$Ancêtre des RichTextEdit
forward
global type u_rtea_pt from richtextedit
end type
end forward

global type u_rtea_pt from richtextedit
int Width=494
int Height=361
int TabOrder=1
event we_nchittest pbm_nchittest
end type
global u_rtea_pt u_rtea_pt

type variables
PROTECTED:

Boolean i_b_autoselect	// Indicates whether text is selected automatically
Boolean i_b_modified	// Indicates the text has been modified

Integer i_i_cur_pos		// Current position (offset) of the cursor
Integer i_i_line_num		// Line number where cursor is located
Integer i_i_col_num		// Column number where cursor is located

String i_s_microhelp		// Default MicroHelp for Object focus
String i_s_helpkey		// Default key into Help file
end variables

forward prototypes
public subroutine fu_set_microhelp (string a_s_microhelp)
public subroutine fu_set_helpkey (string a_s_helpkey)
public function string fu_get_microhelp ()
public function string fu_get_helpkey ()
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

public function string fu_get_microhelp ();RETURN i_s_microhelp
end function

public function string fu_get_helpkey ();RETURN i_s_helpkey
end function

on u_rtea_pt.create
BackColor=16777215
InputFieldBackColor=16777215
end on

