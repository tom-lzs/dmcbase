$PBExportHeader$w_liste_resp_secteur.srw
$PBExportComments$Permet l'affichage de la liste des responsables de secteur
forward
global type w_liste_resp_secteur from w_a_liste
end type
end forward

global type w_liste_resp_secteur from w_a_liste
string tag = "LISTE_RESPONSABLE_SECTEUR"
integer width = 1435
integer height = 1000
string title = "Liste des responsables de secteur"
end type
global w_liste_resp_secteur w_liste_resp_secteur

on w_liste_resp_secteur.create
call super::create
end on

on w_liste_resp_secteur.destroy
call super::destroy
end on

event open;call super::open;
/* appel de la fonction qui permet de ne pas traduire les libellés */

fu_ne_pas_traduire()
end event

type cb_cancel from w_a_liste`cb_cancel within w_liste_resp_secteur
end type

type cb_ok from w_a_liste`cb_ok within w_liste_resp_secteur
end type

type dw_1 from w_a_liste`dw_1 within w_liste_resp_secteur
string tag = "A_TRADUIRE"
integer x = 50
integer y = 40
integer width = 1307
integer taborder = 1
string dataobject = "d_liste_resp_secteur"
end type

type pb_ok from w_a_liste`pb_ok within w_liste_resp_secteur
integer x = 128
integer taborder = 0
string facename = "Arial"
end type

type pb_echap from w_a_liste`pb_echap within w_liste_resp_secteur
integer x = 923
integer taborder = 0
string facename = "Arial"
end type

