$PBExportHeader$w_liste_correspondancieres.srw
$PBExportComments$Permet l'affichage de la liste des correspondancières
forward
global type w_liste_correspondancieres from w_a_liste
end type
end forward

global type w_liste_correspondancieres from w_a_liste
string tag = "LISTE_CORRESPONDANCIERE"
integer width = 1408
integer height = 992
string title = "Liste des correspondancières"
end type
global w_liste_correspondancieres w_liste_correspondancieres

on w_liste_correspondancieres.create
call super::create
end on

on w_liste_correspondancieres.destroy
call super::destroy
end on

event open;call super::open;
/* appel de la fonction qui permet de ne pas traduire les libellés */

fu_ne_pas_traduire()
end event

type cb_cancel from w_a_liste`cb_cancel within w_liste_correspondancieres
end type

type cb_ok from w_a_liste`cb_ok within w_liste_correspondancieres
end type

type dw_1 from w_a_liste`dw_1 within w_liste_correspondancieres
string tag = "A_TRADUIRE"
integer x = 64
integer y = 40
integer width = 1243
integer taborder = 1
string dataobject = "d_liste_correspondancieres"
end type

type pb_ok from w_a_liste`pb_ok within w_liste_correspondancieres
integer x = 197
integer taborder = 0
string facename = "Arial"
end type

type pb_echap from w_a_liste`pb_echap within w_liste_correspondancieres
integer x = 873
integer taborder = 0
string facename = "Arial"
end type

