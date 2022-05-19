$PBExportHeader$w_liste_code_manquant.srw
$PBExportComments$Permet l'affichage des codes manquants
forward
global type w_liste_code_manquant from w_a_liste
end type
end forward

global type w_liste_code_manquant from w_a_liste
string tag = "LISTE_CODE_MANQUANT"
integer width = 1509
integer height = 1040
string title = "Liste des codes manquants"
boolean controlmenu = false
end type
global w_liste_code_manquant w_liste_code_manquant

on w_liste_code_manquant.create
call super::create
end on

on w_liste_code_manquant.destroy
call super::destroy
end on

event open;call super::open; 
/* appel fonction de chargement des éléments multi langue de la table concernée */

fu_ini_param("COME9007",DBNAME_CODE_MANQUANT ,DBNAME_CODE_MANQUANT_INTITULE )
end event

type cb_cancel from w_a_liste`cb_cancel within w_liste_code_manquant
end type

type cb_ok from w_a_liste`cb_ok within w_liste_code_manquant
end type

type dw_1 from w_a_liste`dw_1 within w_liste_code_manquant
string tag = "A_TRADUIRE"
integer x = 55
integer y = 84
integer width = 1344
integer height = 612
integer taborder = 1
string dataobject = "d_liste_code_manquant"
end type

type pb_ok from w_a_liste`pb_ok within w_liste_code_manquant
integer x = 55
integer y = 752
integer taborder = 0
string facename = "Arial"
end type

type pb_echap from w_a_liste`pb_echap within w_liste_code_manquant
integer x = 1001
integer y = 752
integer taborder = 0
string facename = "Arial"
end type

