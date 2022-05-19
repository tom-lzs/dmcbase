$PBExportHeader$u_cb_prior.sru
$PBExportComments$Bouton 'Précédent' standard
forward
global type u_cb_prior from u_cba
end type
end forward

global type u_cb_prior from u_cba
string Text="&Précédent"
end type
global u_cb_prior u_cb_prior

event constructor;call super::constructor;this.fu_setevent ("ue_prior")

this.fu_set_microhelp ("Enregistrement précédent")
end event

