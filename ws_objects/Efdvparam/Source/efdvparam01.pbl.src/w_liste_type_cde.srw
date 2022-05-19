$PBExportHeader$w_liste_type_cde.srw
$PBExportComments$Permet l'affichage de la liste des types de commande
forward
global type w_liste_type_cde from w_a_liste
end type
end forward

global type w_liste_type_cde from w_a_liste
integer width = 1257
string title = "Liste des types de commande"
end type
global w_liste_type_cde w_liste_type_cde

on w_liste_type_cde.create
call super::create
end on

on w_liste_type_cde.destroy
call super::destroy
end on

type cb_cancel from w_a_liste`cb_cancel within w_liste_type_cde
end type

type cb_ok from w_a_liste`cb_ok within w_liste_type_cde
end type

type dw_1 from w_a_liste`dw_1 within w_liste_type_cde
integer width = 1111
string dataobject = "d_liste_type_cde"
end type

