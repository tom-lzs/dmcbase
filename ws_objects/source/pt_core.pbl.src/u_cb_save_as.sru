$PBExportHeader$u_cb_save_as.sru
$PBExportComments$Bouton 'Enregistrer Tout' standard
forward
global type u_cb_save_as from u_cba
end type
end forward

global type u_cb_save_as from u_cba
string Text="E&xporter..."
end type
global u_cb_save_as u_cb_save_as

event constructor;call super::constructor;this.fu_setevent ("ue_saveas")

this.fu_set_microhelp ("Exportation des enregistrements...")
end event

