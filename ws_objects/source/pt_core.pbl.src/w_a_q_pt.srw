$PBExportHeader$w_a_q_pt.srw
$PBExportComments$[MAIN] Ancêtre des fenêtres de Consultation
forward
global type w_a_q_pt from w_a
end type
type dw_1 from u_dw_q within w_a_q_pt
end type
end forward

global type w_a_q_pt from w_a
int Width=1020
int Height=605
dw_1 dw_1
end type
global w_a_q_pt w_a_q_pt

type variables

end variables

on resize;call w_a::resize;// Resize the datawindow to take up the entire window.

dw_1.Resize (this.WorkSpaceWidth (), this.WorkSpaceHeight ())
end on

on ue_printpreview;call w_a::ue_printpreview;dw_1.fu_dw_printpreview ()
end on

on ue_saveas;call w_a::ue_saveas;dw_1.SaveAs ()
end on

on open;call w_a::open;// Set the data object, if passed as a parameter.

IF i_str_pass.s_dataobject <> "" AND &
	Lower (i_str_pass.s_dataobject) <> "x" THEN
	dw_1.dataobject = i_str_pass.s_dataobject
END IF


dw_1.SetTransObject (i_tr_sql)

dw_1.fu_set_error_title (this.title)

dw_1.Move (1, 1)
end on

on ue_close;call w_a::ue_close;Close (this)
end on

on w_a_q_pt.create
int iCurrent
call w_a::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=dw_1
end on

on w_a_q_pt.destroy
call w_a::destroy
destroy(this.dw_1)
end on

on ue_save;call w_a::ue_save;// This is an Inquiry Window; there is nothing to save.

end on

on ue_print;call w_a::ue_print;dw_1.Print()
end on

on ue_prior;call w_a::ue_prior;dw_1.ScrollPriorRow ()
end on

on ue_next;call w_a::ue_next;dw_1.ScrollNextRow ()
end on

type dw_1 from u_dw_q within w_a_q_pt
int X=69
int Y=33
end type

