$PBExportHeader$u_cb_help.sru
$PBExportComments$Bouton 'Aide' standard
forward
global type u_cb_help from u_cba
end type
end forward

global type u_cb_help from u_cba
string Text="&Aide"
end type
global u_cb_help u_cb_help

event constructor;call super::constructor;this.fu_setevent ("ue_help")

this.fu_set_microhelp ("Ouvre l~'aide")
end event

