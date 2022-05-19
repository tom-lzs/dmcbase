$PBExportHeader$w_a_pick_many_pt.srw
$PBExportComments$[RESPONSE] Ancêtre des fenêtres de Sélection Multi-lignes
forward
global type w_a_pick_many_pt from w_a
end type
type cb_cancel from u_cb_cancel within w_a_pick_many_pt
end type
type cb_ok from u_cb_ok within w_a_pick_many_pt
end type
type dw_1 from u_dw_q within w_a_pick_many_pt
end type
end forward

global type w_a_pick_many_pt from w_a
int Width=1060
int Height=820
WindowType WindowType=response!
long BackColor=79741120
boolean MinBox=false
boolean MaxBox=false
cb_cancel cb_cancel
cb_ok cb_ok
dw_1 dw_1
end type
global w_a_pick_many_pt w_a_pick_many_pt

type variables

end variables

on open;call w_a::open;// Set datawindow with passed dataobject (if it exists)

IF i_str_pass.s_dataobject <> "" AND &
	Lower (i_str_pass.s_dataobject) <> "x" THEN
	dw_1.dataobject = i_str_pass.s_dataobject
END IF


// Set the datawindow transaction and dbError title

dw_1.SetTransObject (i_tr_sql)

dw_1.fu_set_error_title (this.title)


// Put the datawindow in multiple row selecion mode (control required)
// and use rectangle to show focus

dw_1.SetRowFocusIndicator (FocusRect!)

dw_1.fu_set_selection_mode (2)


// Preload action to be returned to calling window to "cancel"

i_str_pass.s_action = "cancel"
end on

on ue_cancel;call w_a::ue_cancel;i_str_pass.s_action = "cancel"
end on

on w_a_pick_many_pt.create
int iCurrent
call w_a::create
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=cb_cancel
this.Control[iCurrent+2]=cb_ok
this.Control[iCurrent+3]=dw_1
end on

on w_a_pick_many_pt.destroy
call w_a::destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.dw_1)
end on

on ue_ok;call w_a::ue_ok;i_str_pass.s_action = "ok"
end on

on ue_new;call w_a::ue_new;i_str_pass.s_action = "new"
end on

type cb_cancel from u_cb_cancel within w_a_pick_many_pt
int X=537
int Y=567
int TabOrder=30
end type

type cb_ok from u_cb_ok within w_a_pick_many_pt
int X=114
int Y=567
int TabOrder=20
end type

type dw_1 from u_dw_q within w_a_pick_many_pt
int X=82
int Y=36
int Width=857
int Height=471
int TabOrder=10
BorderStyle BorderStyle=StyleLowered!
boolean VScrollBar=true
end type

