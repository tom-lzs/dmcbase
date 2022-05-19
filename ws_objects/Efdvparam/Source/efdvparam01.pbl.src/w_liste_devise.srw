$PBExportHeader$w_liste_devise.srw
$PBExportComments$Permet l'affichage de la liste des devises
forward
global type w_liste_devise from w_a_liste
end type
end forward

global type w_liste_devise from w_a_liste
string title = "Liste des codes devises"
end type
global w_liste_devise w_liste_devise

on w_liste_devise.create
call super::create
end on

on w_liste_devise.destroy
call super::destroy
end on

type cb_cancel from w_a_liste`cb_cancel within w_liste_devise
end type

type cb_ok from w_a_liste`cb_ok within w_liste_devise
end type

type dw_1 from w_a_liste`dw_1 within w_liste_devise
string dataobject = "d_liste_devise"
end type

