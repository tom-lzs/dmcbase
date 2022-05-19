$PBExportHeader$u_cb_remove.sru
$PBExportComments$Bouton 'Enlever' standard
forward
global type u_cb_remove from u_cba
end type
end forward

global type u_cb_remove from u_cba
string Text="<- &Enlever"
end type
global u_cb_remove u_cb_remove

event constructor;call super::constructor;this.fu_setevent ("ue_remove")

this.fu_set_microhelp ("Enlève les enregistrements sélectionnés.")

end event

