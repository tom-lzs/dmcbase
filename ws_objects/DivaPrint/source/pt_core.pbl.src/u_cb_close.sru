$PBExportHeader$u_cb_close.sru
$PBExportComments$Bouton 'Fermer' standard
forward
global type u_cb_close from u_cba
end type
end forward

global type u_cb_close from u_cba
string Text="&Fermer"
end type
global u_cb_close u_cb_close

event constructor;call super::constructor;this.fu_setevent ("ue_close")

this.fu_set_microhelp ("Ferme la fenêtre")
end event

