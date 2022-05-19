$PBExportHeader$w_liste_code_langue.srw
$PBExportComments$Permet l'affichage de la liste des codes langues
forward
global type w_liste_code_langue from w_a_liste
end type
end forward

global type w_liste_code_langue from w_a_liste
string tag = "LISTE_CODE_LANGUE"
integer width = 1440
integer height = 920
string title = "Liste des codes langue"
end type
global w_liste_code_langue w_liste_code_langue

on w_liste_code_langue.create
call super::create
end on

on w_liste_code_langue.destroy
call super::destroy
end on

event open;call super::open; 
/* appel fonction de chargement des éléments multi langue de la table concernée */

fu_ini_param("COME9010",DBNAME_CODE_LANGUE ,DBNAME_CODE_LANGUE_INTITULE )
end event

type cb_cancel from w_a_liste`cb_cancel within w_liste_code_langue
end type

type cb_ok from w_a_liste`cb_ok within w_liste_code_langue
end type

type dw_1 from w_a_liste`dw_1 within w_liste_code_langue
string tag = "A_TRADUIRE"
integer x = 96
integer width = 1221
integer height = 532
integer taborder = 1
string dataobject = "d_liste_code_langue"
end type

type pb_ok from w_a_liste`pb_ok within w_liste_code_langue
integer x = 197
integer y = 604
integer taborder = 0
string facename = "Arial"
end type

type pb_echap from w_a_liste`pb_echap within w_liste_code_langue
integer x = 850
integer y = 604
integer taborder = 0
string facename = "Arial"
end type

