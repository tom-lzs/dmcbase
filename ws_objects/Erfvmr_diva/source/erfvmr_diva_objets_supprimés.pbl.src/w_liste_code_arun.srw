$PBExportHeader$w_liste_code_arun.srw
$PBExportComments$Permet l'affichage de la liste des codes Arun
forward
global type w_liste_code_arun from w_a_liste
end type
end forward

global type w_liste_code_arun from w_a_liste
string tag = "LISTE_CODE_ARUN"
integer width = 1691
integer height = 1040
string title = "Liste des codes validations Arun"
boolean controlmenu = false
end type
global w_liste_code_arun w_liste_code_arun

on w_liste_code_arun.create
call super::create
end on

on w_liste_code_arun.destroy
call super::destroy
end on

event open;call super::open; 
/* appel fonction de chargement des éléments multi langue de la table concernée */

fu_ini_param("COME9018",DBNAME_ARUN ,DBNAME_ARUN_INTITULE )
end event

type cb_cancel from w_a_liste`cb_cancel within w_liste_code_arun
end type

type cb_ok from w_a_liste`cb_ok within w_liste_code_arun
end type

type dw_1 from w_a_liste`dw_1 within w_liste_code_arun
string tag = "A_TRADUIRE"
integer x = 55
integer y = 84
integer width = 1527
integer height = 612
integer taborder = 1
string dataobject = "d_liste_code_arun"
end type

type pb_ok from w_a_liste`pb_ok within w_liste_code_arun
integer x = 55
integer y = 752
integer taborder = 0
string facename = "Arial"
end type

type pb_echap from w_a_liste`pb_echap within w_liste_code_arun
integer x = 1001
integer y = 752
integer taborder = 0
string facename = "Arial"
end type

