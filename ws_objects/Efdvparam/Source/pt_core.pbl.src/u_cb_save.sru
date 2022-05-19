$PBExportHeader$u_cb_save.sru
$PBExportComments$Bouton 'Enregistrer' standard
forward
global type u_cb_save from u_cba
end type
end forward

global type u_cb_save from u_cba
string Text="&Enregistrer"
end type
global u_cb_save u_cb_save

event constructor;call super::constructor;this.fu_setevent ("ue_save")

this.fu_set_microhelp ("Enregitrer les modifications")
end event

