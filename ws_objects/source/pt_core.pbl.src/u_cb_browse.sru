$PBExportHeader$u_cb_browse.sru
$PBExportComments$Bouton 'Détail' standard
forward
global type u_cb_browse from u_cba
end type
end forward

global type u_cb_browse from u_cba
string Text="&Détail"
end type
global u_cb_browse u_cb_browse

event constructor;call super::constructor;this.fu_setevent ("ue_browse")

this.fu_set_microhelp ("Détail de la sélection")
end event

