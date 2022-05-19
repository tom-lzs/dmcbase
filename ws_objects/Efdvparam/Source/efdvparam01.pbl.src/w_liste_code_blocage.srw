$PBExportHeader$w_liste_code_blocage.srw
$PBExportComments$Permet l'affichage de la liste des codes blocages
forward
global type w_liste_code_blocage from w_a_liste
end type
end forward

global type w_liste_code_blocage from w_a_liste
string tag = "BLOCAGE_COMMANDE"
integer width = 1422
integer height = 1000
string title = "Blocage de la commande"
end type
global w_liste_code_blocage w_liste_code_blocage

on w_liste_code_blocage.create
call super::create
end on

on w_liste_code_blocage.destroy
call super::destroy
end on

type cb_cancel from w_a_liste`cb_cancel within w_liste_code_blocage
end type

type cb_ok from w_a_liste`cb_ok within w_liste_code_blocage
end type

type dw_1 from w_a_liste`dw_1 within w_liste_code_blocage
string tag = "A_TRADUIRE"
integer x = 78
integer width = 1225
string dataobject = "d_liste_code_blocage"
end type

