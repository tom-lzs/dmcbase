$PBExportHeader$w_a_dialog_pt.srw
$PBExportComments$[RESPONSE]  Ancêtre des fenêtres de Dialogue
forward
global type w_a_dialog_pt from w_a
end type
type cb_ok from u_cb_ok within w_a_dialog_pt
end type
type p_1 from picture within w_a_dialog_pt
end type
type mle_msg from multilineedit within w_a_dialog_pt
end type
end forward

global type w_a_dialog_pt from w_a
int X=823
int Y=581
int Width=1258
int Height=757
WindowType WindowType=response!
boolean TitleBar=true
string Title="Boîte de message"
long BackColor=79741120
boolean MinBox=false
boolean MaxBox=false
cb_ok cb_ok
p_1 p_1
mle_msg mle_msg
end type
global w_a_dialog_pt w_a_dialog_pt

type variables

end variables

on ue_cancel;call w_a::ue_cancel;Close (this)
end on

on ue_ok;call w_a::ue_ok;Close (this)
end on

on w_a_dialog_pt.create
int iCurrent
call w_a::create
this.cb_ok=create cb_ok
this.p_1=create p_1
this.mle_msg=create mle_msg
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=cb_ok
this.Control[iCurrent+2]=p_1
this.Control[iCurrent+3]=mle_msg
end on

on w_a_dialog_pt.destroy
call w_a::destroy
destroy(this.cb_ok)
destroy(this.p_1)
destroy(this.mle_msg)
end on

type cb_ok from u_cb_ok within w_a_dialog_pt
int X=467
int Y=545
end type

type p_1 from picture within w_a_dialog_pt
int X=51
int Y=197
int Width=142
int Height=129
boolean Enabled=false
boolean OriginalSize=true
end type

type mle_msg from multilineedit within w_a_dialog_pt
int X=275
int Y=37
int Width=910
int Height=453
boolean Enabled=false
boolean DisplayOnly=true
string Text="Message"
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

