$PBExportHeader$w_liste_mode_paiement.srw
$PBExportComments$Permet l'affichage de la liste des modes de paiement
forward
global type w_liste_mode_paiement from w_a_liste
end type
end forward

global type w_liste_mode_paiement from w_a_liste
string tag = "LISTE_MODE_PAIEMENT"
integer width = 1394
integer height = 1124
string title = "Liste des modes de paiement"
boolean controlmenu = false
end type
global w_liste_mode_paiement w_liste_mode_paiement

on w_liste_mode_paiement.create
call super::create
end on

on w_liste_mode_paiement.destroy
call super::destroy
end on

event open;call super::open; 
/* appel fonction de chargement des éléments multi langue de la table concernée */

fu_ini_param("COME9004",DBNAME_MODE_PAIEMENT ,DBNAME_MODE_PAIEMENT_INTITULE )
end event

type cb_cancel from w_a_liste`cb_cancel within w_liste_mode_paiement
integer taborder = 30
end type

type cb_ok from w_a_liste`cb_ok within w_liste_mode_paiement
integer taborder = 20
end type

type dw_1 from w_a_liste`dw_1 within w_liste_mode_paiement
string tag = "A_TRADUIRE"
integer x = 82
integer y = 60
integer width = 1193
integer height = 664
integer taborder = 10
string dataobject = "d_liste_mode_paiement"
end type

type pb_ok from w_a_liste`pb_ok within w_liste_mode_paiement
integer x = 155
integer y = 800
integer taborder = 0
string facename = "Arial"
end type

type pb_echap from w_a_liste`pb_echap within w_liste_mode_paiement
integer x = 805
integer y = 800
integer taborder = 0
string facename = "Arial"
end type

