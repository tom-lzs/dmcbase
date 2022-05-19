$PBExportHeader$w_msg_dialog_pt.srw
$PBExportComments$Fenêtre boîte de dialogue de message commun PowerTOOL
forward
global type w_msg_dialog_pt from w_a_dialog
end type
type cb_stop from u_cb_cancel within w_msg_dialog_pt
end type
type cb_imprimer from u_cb_print within w_msg_dialog_pt
end type
end forward

global type w_msg_dialog_pt from w_a_dialog
integer width = 1582
integer height = 740
string title = ""
boolean controlmenu = false
cb_stop cb_stop
cb_imprimer cb_imprimer
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
call super::create
this.cb_stop=create cb_stop
this.cb_imprimer=create cb_imprimer
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_stop
this.Control[iCurrent+2]=this.cb_imprimer
end on

on w_msg_dialog_pt.destroy
call super::destroy
destroy(this.cb_stop)
destroy(this.cb_imprimer)
end on

type cb_ok from w_a_dialog`cb_ok within w_msg_dialog_pt
integer x = 773
integer y = 524
integer taborder = 10
string text = "Continuer"
end type

event cb_ok::constructor;call super::constructor;fu_set_microhelp ("Prendre en compte l~'erreur et continuer")
end event

type p_1 from w_a_dialog`p_1 within w_msg_dialog_pt
integer x = 32
integer y = 32
string picturename = "pcerv2.bmp"
boolean border = true
borderstyle borderstyle = styleraised!
end type

type mle_msg from w_a_dialog`mle_msg within w_msg_dialog_pt
integer x = 206
integer y = 32
integer width = 1285
integer height = 448
boolean enabled = true
string text = ""
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type cb_stop from u_cb_cancel within w_msg_dialog_pt
integer x = 402
integer y = 524
integer width = 352
integer height = 96
integer taborder = 30
string text = "STOP"
end type

event constructor;call super::constructor;fu_set_microhelp ("Arreter l~'application")
end event

type cb_imprimer from u_cb_print within w_msg_dialog_pt
integer x = 1143
integer y = 524
integer width = 352
integer height = 96
integer taborder = 20
end type

