$PBExportHeader$u_cb_cancel.sru
$PBExportComments$Bouton 'Annuler' standard
forward
global type u_cb_cancel from u_cba
end type
end forward

global type u_cb_cancel from u_cba
string Text="Annuler"
boolean Cancel=true
end type
global u_cb_cancel u_cb_cancel

event constructor;call super::constructor;this.fu_setevent ("ue_cancel")

this.fu_set_microhelp ("Annule sans sauvegarder les modifications")
end event

