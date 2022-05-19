$PBExportHeader$w_liste_origine_cde.srw
$PBExportComments$Permet l'affichage de la liste des origines de commande
forward
global type w_liste_origine_cde from w_a_liste
end type
end forward

global type w_liste_origine_cde from w_a_liste
integer width = 1335
string title = "Liste des origines de commande"
end type
global w_liste_origine_cde w_liste_origine_cde

on w_liste_origine_cde.create
call super::create
end on

on w_liste_origine_cde.destroy
call super::destroy
end on

type cb_cancel from w_a_liste`cb_cancel within w_liste_origine_cde
end type

type cb_ok from w_a_liste`cb_ok within w_liste_origine_cde
end type

type dw_1 from w_a_liste`dw_1 within w_liste_origine_cde
integer width = 1184
string dataobject = "d_liste_origine_cde"
end type

