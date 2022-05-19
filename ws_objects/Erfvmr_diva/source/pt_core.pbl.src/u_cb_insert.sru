$PBExportHeader$u_cb_insert.sru
$PBExportComments$Bouton 'Insérer' standard
forward
global type u_cb_insert from u_cba
end type
end forward

global type u_cb_insert from u_cba
string Text="&Insérer"
end type
global u_cb_insert u_cb_insert

event constructor;call super::constructor;this.fu_setevent ("ue_insert")

this.fu_set_microhelp ("Insère un enregistrement")
end event

