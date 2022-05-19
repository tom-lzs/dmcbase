$PBExportHeader$w_liste_pays.srw
$PBExportComments$Permet l'affichage de la liste des pays
forward
global type w_liste_pays from w_a_liste
end type
end forward

global type w_liste_pays from w_a_liste
integer width = 1458
integer height = 1108
string title = "Liste des pays"
end type
global w_liste_pays w_liste_pays

on w_liste_pays.create
call super::create
end on

on w_liste_pays.destroy
call super::destroy
end on

type cb_cancel from w_a_liste`cb_cancel within w_liste_pays
end type

type cb_ok from w_a_liste`cb_ok within w_liste_pays
end type

type dw_1 from w_a_liste`dw_1 within w_liste_pays
integer height = 736
string dataobject = "d_liste_pays"
end type

