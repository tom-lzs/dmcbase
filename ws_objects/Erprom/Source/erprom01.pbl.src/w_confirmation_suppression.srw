$PBExportHeader$w_confirmation_suppression.srw
$PBExportComments$Confirmation de la suppression d'une promotion
forward
global type w_confirmation_suppression from w_a
end type
type mle_1 from u_mlea within w_confirmation_suppression
end type
type cb_1 from u_cb_ok within w_confirmation_suppression
end type
type cb_2 from u_cb_cancel within w_confirmation_suppression
end type
end forward

global type w_confirmation_suppression from w_a
integer x = 769
integer y = 461
integer width = 1377
integer height = 736
string title = "Confirmation Suppression Promotion"
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
long backcolor = 8388608
mle_1 mle_1
cb_1 cb_1
cb_2 cb_2
end type
global w_confirmation_suppression w_confirmation_suppression

on ue_init;call w_a::ue_init;mle_1.Text = "Vous avez demandé la suppression de la promotion " + i_str_pass.s[01] + &
             " ~r~n " + &
             "Veuillez confirmer en cliquant su OK "
end on

event ue_cancel;call super::ue_cancel;i_str_pass.s_action = ACTION_CANCEL
Message.fnv_set_str_pass(i_str_pass)
Close (This)


end event

event ue_ok;call super::ue_ok;i_str_pass.s_action = ACTION_OK
Message.fnv_set_str_pass(i_str_pass)
Close (This)


end event

on w_confirmation_suppression.create
int iCurrent
call super::create
this.mle_1=create mle_1
this.cb_1=create cb_1
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.mle_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.cb_2
end on

on w_confirmation_suppression.destroy
call super::destroy
destroy(this.mle_1)
destroy(this.cb_1)
destroy(this.cb_2)
end on

type mle_1 from u_mlea within w_confirmation_suppression
integer x = 37
integer y = 44
integer width = 1248
integer height = 352
integer taborder = 20
long backcolor = 12632256
end type

type cb_1 from u_cb_ok within w_confirmation_suppression
integer x = 142
integer y = 484
integer width = 352
integer height = 96
integer taborder = 30
string text = "&OK"
end type

type cb_2 from u_cb_cancel within w_confirmation_suppression
integer x = 800
integer y = 484
integer width = 352
integer height = 96
integer taborder = 10
string text = "&Annuler"
end type

