$PBExportHeader$u_cb_printsetup.sru
$PBExportComments$Bouton 'Configurer' standard
forward
global type u_cb_printsetup from u_cba
end type
end forward

global type u_cb_printsetup from u_cba
int Width=380
string Text="Confi&gurer..."
end type
global u_cb_printsetup u_cb_printsetup

event constructor;call super::constructor;this.fu_setevent ("ue_printsetup")

this.fu_set_microhelp ("Configuration de l~'impression")
end event

