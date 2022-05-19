$PBExportHeader$u_cb_next.sru
$PBExportComments$Bouton 'Suivant' standard
forward
global type u_cb_next from u_cba
end type
end forward

global type u_cb_next from u_cba
string Text="&Suivant"
end type
global u_cb_next u_cb_next

event constructor;call super::constructor;this.fu_setevent ("ue_next")

this.fu_set_microhelp ("Enregistrement suivant")
end event

