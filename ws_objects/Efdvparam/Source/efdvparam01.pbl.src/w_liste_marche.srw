$PBExportHeader$w_liste_marche.srw
$PBExportComments$Permet l'affichage de la liste des marches
forward
global type w_liste_marche from w_a_liste
end type
end forward

global type w_liste_marche from w_a_liste
integer width = 1486
string title = "Liste des codes marchés"
boolean center = true
end type
global w_liste_marche w_liste_marche

on w_liste_marche.create
call super::create
end on

on w_liste_marche.destroy
call super::destroy
end on

type cb_cancel from w_a_liste`cb_cancel within w_liste_marche
end type

type cb_ok from w_a_liste`cb_ok within w_liste_marche
end type

type dw_1 from w_a_liste`dw_1 within w_liste_marche
string dataobject = "d_liste_marche"
end type

