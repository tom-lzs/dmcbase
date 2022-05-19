$PBExportHeader$u_cb_new.sru
$PBExportComments$Bouton 'Nouveau' standard
forward
global type u_cb_new from u_cba
end type
end forward

global type u_cb_new from u_cba
string Text="&Nouveau"
end type
global u_cb_new u_cb_new

event constructor;call super::constructor;this.fu_setevent ("ue_new")

this.fu_set_microhelp ("Crée un nouvel enregistrement")
end event

