$PBExportHeader$w_liste_ucc.srw
$PBExportComments$Permet l'affichage de la liste des unités de commande client
forward
global type w_liste_ucc from w_a_liste
end type
end forward

global type w_liste_ucc from w_a_liste
string tag = "LISTE_UCC"
integer width = 1426
integer height = 992
string title = "Liste des unités de commande"
end type
global w_liste_ucc w_liste_ucc

on w_liste_ucc.create
call super::create
end on

on w_liste_ucc.destroy
call super::destroy
end on

event open;call super::open; 
/* appel fonction de chargement des éléments multi langue de la table concernée */

fu_ini_param("COME9008",DBNAME_UCC ,DBNAME_UCC_INTITULE )
end event

type uo_statusbar from w_a_liste`uo_statusbar within w_liste_ucc
end type

type cb_cancel from w_a_liste`cb_cancel within w_liste_ucc
end type

type cb_ok from w_a_liste`cb_ok within w_liste_ucc
end type

type dw_1 from w_a_liste`dw_1 within w_liste_ucc
string tag = "A_TRADUIRE"
string dataobject = "d_liste_ucc"
end type

type pb_ok from w_a_liste`pb_ok within w_liste_ucc
integer x = 151
end type

type pb_echap from w_a_liste`pb_echap within w_liste_ucc
integer x = 878
end type

