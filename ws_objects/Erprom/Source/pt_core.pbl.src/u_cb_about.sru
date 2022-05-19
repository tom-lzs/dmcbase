$PBExportHeader$u_cb_about.sru
$PBExportComments$Bouton 'A propos' standard
forward
global type u_cb_about from u_cba
end type
end forward

global type u_cb_about from u_cba
string Text="&A Propos"
end type
global u_cb_about u_cb_about

event constructor;call super::constructor;this.fu_setevent ("ue_about")

this.fu_set_microhelp ("Affiche des informations sur l~'application")
end event

