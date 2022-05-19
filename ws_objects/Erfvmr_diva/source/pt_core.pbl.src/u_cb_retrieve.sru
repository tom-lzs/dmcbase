$PBExportHeader$u_cb_retrieve.sru
$PBExportComments$Bouton 'Récupérer' standard
forward
global type u_cb_retrieve from u_cba
end type
end forward

global type u_cb_retrieve from u_cba
string Text="&Récupérer"
end type
global u_cb_retrieve u_cb_retrieve

event constructor;call super::constructor;this.fu_setevent ("ue_retrieve")

this.fu_set_microhelp ("Lecture des enregistrements")
end event

