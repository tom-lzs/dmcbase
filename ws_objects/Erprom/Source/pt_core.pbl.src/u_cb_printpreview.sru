$PBExportHeader$u_cb_printpreview.sru
$PBExportComments$Bouton 'Aperçu' standard
forward
global type u_cb_printpreview from u_cba
end type
end forward

global type u_cb_printpreview from u_cba
string Text="&Aperçu..."
end type
global u_cb_printpreview u_cb_printpreview

event constructor;call super::constructor;this.fu_setevent ("ue_printpreview")

this.fu_set_microhelp ("Aperçu avant impression...")
end event

