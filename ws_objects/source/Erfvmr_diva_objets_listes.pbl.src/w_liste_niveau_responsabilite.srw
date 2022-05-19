$PBExportHeader$w_liste_niveau_responsabilite.srw
$PBExportComments$Permet l'affichage de la liste des niveaux de responsabilité
forward
global type w_liste_niveau_responsabilite from w_a_liste
end type
end forward

global type w_liste_niveau_responsabilite from w_a_liste
string tag = "LISTE_NIVEAU_RESPONSABILITE"
integer width = 1605
integer height = 1216
string title = "Liste des niveaux de responsabilités"
end type
global w_liste_niveau_responsabilite w_liste_niveau_responsabilite

on w_liste_niveau_responsabilite.create
call super::create
end on

on w_liste_niveau_responsabilite.destroy
call super::destroy
end on

event open;call super::open;
/* appel de la fonction qui permet de ne pas traduire les libellés */

fu_ne_pas_traduire()
end event

type cb_cancel from w_a_liste`cb_cancel within w_liste_niveau_responsabilite
end type

type cb_ok from w_a_liste`cb_ok within w_liste_niveau_responsabilite
end type

type dw_1 from w_a_liste`dw_1 within w_liste_niveau_responsabilite
string tag = "A_TRADUIRE"
integer width = 1422
integer height = 732
string dataobject = "d_liste_niveau_responsabilite"
end type

type pb_ok from w_a_liste`pb_ok within w_liste_niveau_responsabilite
integer x = 142
integer y = 892
end type

type pb_echap from w_a_liste`pb_echap within w_liste_niveau_responsabilite
integer x = 1088
integer y = 892
end type

