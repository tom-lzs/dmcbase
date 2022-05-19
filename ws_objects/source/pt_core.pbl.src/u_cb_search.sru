$PBExportHeader$u_cb_search.sru
$PBExportComments$Bouton 'Rechercher' standard
forward
global type u_cb_search from u_cba
end type
end forward

global type u_cb_search from u_cba
string Text="&Rechercher"
end type
global u_cb_search u_cb_search

event constructor;call super::constructor;this.fu_setevent ("ue_search")

this.fu_set_microhelp ("Affiche la fenêtre de recherche...")
end event

