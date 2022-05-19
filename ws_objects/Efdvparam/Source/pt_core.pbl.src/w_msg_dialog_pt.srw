$PBExportHeader$w_msg_dialog_pt.srw
$PBExportComments$Fenêtre boîte de dialogue de message commun PowerTOOL
forward
global type w_msg_dialog_pt from w_a_dialog
end type
type cb_1 from u_cb_cancel within w_msg_dialog_pt
end type
type cb_2 from u_cb_print within w_msg_dialog_pt
end type
end forward

global type w_msg_dialog_pt from w_a_dialog
int Width=1582
int Height=741
boolean TitleBar=true
string Title=""
boolean ControlMenu=false
cb_1 cb_1
cb_2 cb_2
end type
global w_msg_dialog_pt w_msg_dialog_pt

on ue_print;call w_a_dialog::ue_print;// Print contents of the message on the current printer selection.

Long l_job_num


// Bail out if print job cannot be opened.

l_job_num = PrintOpen ()

IF l_job_num < 0 THEN
	RETURN
END IF


// Print contents of current window to the printer and close.

Print (l_job_num, this.title + ":~r~n~r~n" + mle_msg.text)

PrintClose (l_job_num)
end on

on ue_cancel;call w_a_dialog::ue_cancel;// Halt application.

HALT CLOSE
end on

on open;call w_a_dialog::open;// Prepare the Window for display.


// Center window.

this.fw_center_window ()


// Review passed parameters.

IF NOT Len (Trim (i_str_pass.s_win_title)) > 0 THEN
	i_str_pass.s_win_title = "Application Exception"
END IF

IF UpperBound (i_str_pass.s) > 0 THEN
	IF NOT Len (Trim (i_str_pass.s [1])) > 0 THEN
		i_str_pass.s [1] = "Unknown Exception"
	END IF
ELSE
	i_str_pass.s [1] = "Unknown Exception"
END IF


// Set Window title and message.

this.title = i_str_pass.s_win_title

mle_msg.text = i_str_pass.s [1]
end on

on w_msg_dialog_pt.create
int iCurrent
call w_a_dialog::create
this.cb_1=create cb_1
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=cb_1
this.Control[iCurrent+2]=cb_2
end on

on w_msg_dialog_pt.destroy
call w_a_dialog::destroy
destroy(this.cb_1)
destroy(this.cb_2)
end on

type cb_ok from w_a_dialog`cb_ok within w_msg_dialog_pt
int X=773
int Y=525
int TabOrder=10
string Text="Continuer"
end type

event cb_ok::constructor;call super::constructor;fu_set_microhelp ("Prendre en compte l~'erreur et continuer")
end event

type p_1 from w_a_dialog`p_1 within w_msg_dialog_pt
int X=33
int Y=33
string PictureName="pcerv2.bmp"
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
end type

type mle_msg from w_a_dialog`mle_msg within w_msg_dialog_pt
int X=206
int Y=33
int Width=1285
int Height=449
boolean Enabled=true
BorderStyle BorderStyle=StyleLowered!
boolean VScrollBar=true
string Text=""
end type

type cb_1 from u_cb_cancel within w_msg_dialog_pt
int X=403
int Y=525
int TabOrder=30
string Text="STOP"
end type

event constructor;call super::constructor;fu_set_microhelp ("Arreter l~'application")
end event

type cb_2 from u_cb_print within w_msg_dialog_pt
int X=1143
int Y=525
int TabOrder=20
end type

