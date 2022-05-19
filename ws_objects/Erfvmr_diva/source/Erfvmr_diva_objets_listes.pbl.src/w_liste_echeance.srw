$PBExportHeader$w_liste_echeance.srw
$PBExportComments$Permet l'affichage de la liste des codes échéances
forward
global type w_liste_echeance from w_a_liste
end type
end forward

global type w_liste_echeance from w_a_liste
string tag = "LISTE_ECHEANCE"
integer width = 2633
integer height = 1372
string title = "Liste des codes échéances"
boolean controlmenu = false
end type
global w_liste_echeance w_liste_echeance

on w_liste_echeance.create
call super::create
end on

on w_liste_echeance.destroy
call super::destroy
end on

event open;call super::open; 
/* appel fonction de chargement des éléments multi langue de la table concernée */

fu_ini_param("COME9005",DBNAME_CODE_ECHEANCE ,DBNAME_CODE_ECHEANCE_INTITULE )
end event

type uo_statusbar from w_a_liste`uo_statusbar within w_liste_echeance
integer x = 219
integer y = 0
end type

type cb_cancel from w_a_liste`cb_cancel within w_liste_echeance
integer taborder = 30
end type

type cb_ok from w_a_liste`cb_ok within w_liste_echeance
integer taborder = 20
end type

type dw_1 from w_a_liste`dw_1 within w_liste_echeance
string tag = "A_TRADUIRE"
integer x = 37
integer y = 64
integer width = 2414
integer height = 832
integer taborder = 10
string dataobject = "d_liste_echeance"
end type

type pb_ok from w_a_liste`pb_ok within w_liste_echeance
integer x = 329
integer y = 1024
integer taborder = 0
end type

type pb_echap from w_a_liste`pb_echap within w_liste_echeance
integer x = 1061
integer y = 1024
integer taborder = 0
end type

