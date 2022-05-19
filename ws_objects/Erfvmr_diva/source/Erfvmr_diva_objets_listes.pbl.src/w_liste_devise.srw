$PBExportHeader$w_liste_devise.srw
$PBExportComments$Permet l'affichage de la liste des devises
forward
global type w_liste_devise from w_a_liste
end type
end forward

global type w_liste_devise from w_a_liste
string tag = "LISTE_DEVISE"
integer width = 1431
integer height = 996
string title = "Liste des codes devises"
end type
global w_liste_devise w_liste_devise

on w_liste_devise.create
call super::create
end on

on w_liste_devise.destroy
call super::destroy
end on

event open;call super::open; 
/* appel fonction de chargement des éléments multi langue de la table concernée */

fu_ini_param("COME9022",DBNAME_CODE_DEVISE ,DBNAME_CODE_DEVISE_INTITULE )
end event

type cb_cancel from w_a_liste`cb_cancel within w_liste_devise
end type

type cb_ok from w_a_liste`cb_ok within w_liste_devise
end type

type dw_1 from w_a_liste`dw_1 within w_liste_devise
string tag = "A_TRADUIRE"
string dataobject = "d_liste_devise"
end type

type pb_ok from w_a_liste`pb_ok within w_liste_devise
integer x = 151
string facename = "Arial"
end type

type pb_echap from w_a_liste`pb_echap within w_liste_devise
integer x = 878
string facename = "Arial"
end type

