$PBExportHeader$w_liste_type_cde.srw
$PBExportComments$Permet l'affichage de la liste des types de commande
forward
global type w_liste_type_cde from w_a_liste
end type
end forward

global type w_liste_type_cde from w_a_liste
string tag = "LISTE_TYPE_COMMANDE"
integer width = 1257
integer height = 1020
string title = "Liste des types de commande"
end type
global w_liste_type_cde w_liste_type_cde

on w_liste_type_cde.create
call super::create
end on

on w_liste_type_cde.destroy
call super::destroy
end on

event open;call super::open; 
/* appel fonction de chargement des éléments multi langue de la table concernée */

fu_ini_param("COME9024",DBNAME_TYPE_CDE ,DBNAME_TYPE_CDE_INTITULE )
end event

type cb_cancel from w_a_liste`cb_cancel within w_liste_type_cde
end type

type cb_ok from w_a_liste`cb_ok within w_liste_type_cde
end type

type dw_1 from w_a_liste`dw_1 within w_liste_type_cde
string tag = "A_TRADUIRE"
integer width = 1111
string dataobject = "d_liste_type_cde"
end type

type pb_ok from w_a_liste`pb_ok within w_liste_type_cde
integer x = 114
integer y = 704
string facename = "Arial"
end type

type pb_echap from w_a_liste`pb_echap within w_liste_type_cde
integer x = 759
integer y = 704
string facename = "Arial"
end type

