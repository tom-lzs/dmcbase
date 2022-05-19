$PBExportHeader$u_cb_print.sru
$PBExportComments$Bouton 'Imprimer' standard
forward
global type u_cb_print from u_cba
end type
end forward

global type u_cb_print from u_cba
string Text="&Imprimer"
end type
global u_cb_print u_cb_print

event constructor;call super::constructor;this.fu_setevent ("ue_print")

this.fu_set_microhelp ("Imprime sur l~'imprimante courante")
end event

