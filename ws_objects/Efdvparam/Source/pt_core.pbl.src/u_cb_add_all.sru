$PBExportHeader$u_cb_add_all.sru
$PBExportComments$Bouton 'Ajouter Tout' standard
forward
global type u_cb_add_all from u_cba
end type
end forward

global type u_cb_add_all from u_cba
int Width=490
int Height=85
string Text="A&jouter Tout ->>"
end type
global u_cb_add_all u_cb_add_all

event constructor;call super::constructor;this.fu_setevent ("ue_addall")

this.fu_set_microhelp ("Ajoute tous les éléments.")

end event

