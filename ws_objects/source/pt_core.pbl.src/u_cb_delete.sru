$PBExportHeader$u_cb_delete.sru
$PBExportComments$Bouton 'Supprimer' standard
forward
global type u_cb_delete from u_cba
end type
end forward

global type u_cb_delete from u_cba
string Text="&Supprimer"
end type
global u_cb_delete u_cb_delete

event constructor;call super::constructor;this.fu_setevent ("ue_delete")

this.fu_set_microhelp ("Supprime l~'enregistrement")
end event

