$PBExportHeader$u_cb_open.sru
$PBExportComments$Bouton 'Ouvrir' standard
forward
global type u_cb_open from u_cba
end type
end forward

global type u_cb_open from u_cba
string Text="&Ouvrir..."
end type
global u_cb_open u_cb_open

event constructor;call super::constructor;this.fu_setevent ("ue_fileopen")

this.fu_set_microhelp ("Affiche la fenêtre d~'ouverture...")
end event

