$PBExportHeader$w_liste_origine_cde.srw
$PBExportComments$Permet l'affichage de la liste des codes origines de cmmande
forward
global type w_liste_origine_cde from w_a_liste
end type
end forward

global type w_liste_origine_cde from w_a_liste
string tag = "LISTE_ORIGINE_COMMANDE"
integer width = 1335
integer height = 996
string title = "Liste des origines de commande"
end type
global w_liste_origine_cde w_liste_origine_cde

on w_liste_origine_cde.create
call super::create
end on

on w_liste_origine_cde.destroy
call super::destroy
end on

event open;call super::open; 
/* appel fonction de chargement des éléments multi langue de la table concernée */

fu_ini_param("COME9016",DBNAME_ORIGINE_CDE ,DBNAME_ORIGINE_CDE_INTITULE )
end event

type cb_cancel from w_a_liste`cb_cancel within w_liste_origine_cde
end type

type cb_ok from w_a_liste`cb_ok within w_liste_origine_cde
end type

type dw_1 from w_a_liste`dw_1 within w_liste_origine_cde
string tag = "A_TRADUIRE"
integer x = 64
integer width = 1184
string dataobject = "d_liste_origine_cde"
end type

type pb_ok from w_a_liste`pb_ok within w_liste_origine_cde
integer x = 160
string facename = "Arial"
end type

type pb_echap from w_a_liste`pb_echap within w_liste_origine_cde
integer x = 850
integer y = 692
string facename = "Arial"
end type

