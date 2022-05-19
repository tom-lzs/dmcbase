$PBExportHeader$u_cb_add.sru
$PBExportComments$Bouton 'Ajouter' standard
forward
global type u_cb_add from u_cba
end type
end forward

global type u_cb_add from u_cba
string Text="&Ajouter ->"
end type
global u_cb_add u_cb_add

event constructor;call super::constructor;this.fu_setevent ("ue_add")

this.fu_set_microhelp ("Ajoute les articles sélectionnés.")

end event

