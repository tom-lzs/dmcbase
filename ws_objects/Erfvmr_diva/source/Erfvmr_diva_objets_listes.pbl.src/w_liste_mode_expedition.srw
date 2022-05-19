$PBExportHeader$w_liste_mode_expedition.srw
$PBExportComments$Permet l'affichage de la liste des modes d'expedition
forward
global type w_liste_mode_expedition from w_a_liste
end type
end forward

global type w_liste_mode_expedition from w_a_liste
string tag = "LISTE_MODE_TRANSPORT"
integer width = 1413
integer height = 920
string title = "Liste des modes de transport"
end type
global w_liste_mode_expedition w_liste_mode_expedition

on w_liste_mode_expedition.create
call super::create
end on

on w_liste_mode_expedition.destroy
call super::destroy
end on

event open;call super::open; 
/* appel fonction de chargement des éléments multi langue de la table concernée */

fu_ini_param("COME9025",DBNAME_CODE_MODE_EXP ,DBNAME_CODE_MODE_EXP_INTITULE )
end event

type cb_cancel from w_a_liste`cb_cancel within w_liste_mode_expedition
end type

type cb_ok from w_a_liste`cb_ok within w_liste_mode_expedition
end type

type dw_1 from w_a_liste`dw_1 within w_liste_mode_expedition
string tag = "A_TRADUIRE"
integer x = 78
integer width = 1221
integer height = 532
integer taborder = 1
string dataobject = "d_liste_mode_expedition"
end type

type pb_ok from w_a_liste`pb_ok within w_liste_mode_expedition
integer x = 174
integer y = 616
integer taborder = 0
string facename = "Arial"
end type

type pb_echap from w_a_liste`pb_echap within w_liste_mode_expedition
integer x = 882
integer y = 616
integer taborder = 0
string facename = "Arial"
end type

