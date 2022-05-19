$PBExportHeader$u_cb_select.sru
$PBExportComments$Bouton 'Sélectionner' standard
forward
global type u_cb_select from u_cba
end type
end forward

global type u_cb_select from u_cba
int Width=398
int Height=89
string Text="Se&lectioner..."
end type
global u_cb_select u_cb_select

event constructor;call super::constructor;this.fu_setevent ("ue_selectiondialog")

this.fu_set_microhelp ("Affiche la fenêtre de sélection...")
end event

