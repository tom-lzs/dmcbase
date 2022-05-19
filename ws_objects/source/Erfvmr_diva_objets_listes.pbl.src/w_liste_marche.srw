$PBExportHeader$w_liste_marche.srw
$PBExportComments$Permet l'affichage de la liste des marchés
forward
global type w_liste_marche from w_a_liste
end type
end forward

global type w_liste_marche from w_a_liste
string tag = "LISTE_MARCHE"
integer width = 1435
integer height = 1000
string title = "Liste des codes marchés"
end type
global w_liste_marche w_liste_marche

on w_liste_marche.create
call super::create
end on

on w_liste_marche.destroy
call super::destroy
end on

event open;call super::open; 
/* appel fonction de chargement des éléments multi langue de la table concernée */

fu_ini_param("COME9019",DBNAME_CODE_MARCHE ,DBNAME_CODE_MARCHE_INTITULE )
end event

type cb_cancel from w_a_liste`cb_cancel within w_liste_marche
end type

type cb_ok from w_a_liste`cb_ok within w_liste_marche
end type

type dw_1 from w_a_liste`dw_1 within w_liste_marche
string tag = "A_TRADUIRE"
string dataobject = "d_liste_marche"
end type

type pb_ok from w_a_liste`pb_ok within w_liste_marche
integer x = 137
string facename = "Arial"
end type

type pb_echap from w_a_liste`pb_echap within w_liste_marche
integer x = 850
string facename = "Arial"
end type

