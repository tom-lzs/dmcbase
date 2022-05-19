$PBExportHeader$u_cb_remove_all.sru
$PBExportComments$Bouton 'Enlever Tout' standard
forward
global type u_cb_remove_all from u_cba
end type
end forward

global type u_cb_remove_all from u_cba
int Width=481
string Text="<<- En&lever Tout"
end type
global u_cb_remove_all u_cb_remove_all

event constructor;call super::constructor;this.fu_setevent ("ue_removeall")

this.fu_set_microhelp ("Enlève tous les enregitrements.")

end event

