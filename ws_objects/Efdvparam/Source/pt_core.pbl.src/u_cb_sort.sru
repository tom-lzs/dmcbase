$PBExportHeader$u_cb_sort.sru
$PBExportComments$Bouton 'Trier' standard
forward
global type u_cb_sort from u_cba
end type
end forward

global type u_cb_sort from u_cba
string Text="&Trier"
end type
global u_cb_sort u_cb_sort

event constructor;call super::constructor;this.fu_setevent ("ue_sort")

this.fu_set_microhelp ("Tri des enregistrements")
end event

