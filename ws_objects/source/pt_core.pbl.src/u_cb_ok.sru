$PBExportHeader$u_cb_ok.sru
$PBExportComments$Standard "OK" button
forward
global type u_cb_ok from u_cba
end type
end forward

global type u_cb_ok from u_cba
string Text="OK"
boolean Default=true
end type
global u_cb_ok u_cb_ok

event constructor;call super::constructor;this.fu_setevent ("ue_ok")

this.fu_set_microhelp ("Sauvegarde et ferme")
end event

