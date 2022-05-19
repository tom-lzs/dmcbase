$PBExportHeader$u_cb_filter.sru
$PBExportComments$Bouton 'Filtre' standard
forward
global type u_cb_filter from u_cba
end type
end forward

global type u_cb_filter from u_cba
string Text="&Filtre"
end type
global u_cb_filter u_cb_filter

event constructor;call super::constructor;this.fu_setevent ("ue_filter")

this.fu_set_microhelp ("Filtre les enregistrements")
end event

