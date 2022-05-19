$PBExportHeader$w_str_dialog_pt.srw
$PBExportComments$Fenêtre générale comportant une MultiLineEdit
forward
global type w_str_dialog_pt from w_a_dialog
end type
type cb_1 from u_cb_cancel within w_str_dialog_pt
end type
end forward

global type w_str_dialog_pt from w_a_dialog
int Width=1601
int Height=789
boolean TitleBar=true
string Title="Aperçu Application"
cb_1 cb_1
end type
global w_str_dialog_pt w_str_dialog_pt

on ue_ok;// Override!

// Return string in MultiLineEdit via message.i_str_pass.

str_pass str_pass


str_pass.s [1] = mle_msg.text

message.fnv_set_str_pass (str_pass)

Close (this)
end on

on open;call w_a_dialog::open;// Center Window and display passed String.

this.fw_center_window ()

IF UpperBound (i_str_pass.s) < 1 THEN
	Close (this)
	RETURN
END IF

mle_msg.text = i_str_pass.s [1]
end on

on w_str_dialog_pt.create
int iCurrent
call w_a_dialog::create
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=cb_1
end on

on w_str_dialog_pt.destroy
call w_a_dialog::destroy
destroy(this.cb_1)
end on

type cb_ok from w_a_dialog`cb_ok within w_str_dialog_pt
int X=503
int TabOrder=10
end type

type p_1 from w_a_dialog`p_1 within w_str_dialog_pt
int X=33
int Y=33
string PictureName="pcerv2.bmp"
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
end type

type mle_msg from w_a_dialog`mle_msg within w_str_dialog_pt
int X=211
int Y=33
int Width=1290
int Height=449
int TabOrder=30
boolean Enabled=true
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean DisplayOnly=false
string Text=""
end type

type cb_1 from u_cb_cancel within w_str_dialog_pt
int X=883
int Y=545
int TabOrder=20
end type

