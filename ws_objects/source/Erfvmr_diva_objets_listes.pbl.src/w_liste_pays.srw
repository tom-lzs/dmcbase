$PBExportHeader$w_liste_pays.srw
$PBExportComments$Permet l'affichage de la liste des codes pays
forward
global type w_liste_pays from w_a_liste
end type
end forward

global type w_liste_pays from w_a_liste
string tag = "LISTE_PAYS"
integer width = 1422
integer height = 1096
string title = "Liste des pays"
end type
global w_liste_pays w_liste_pays

on w_liste_pays.create
call super::create
end on

on w_liste_pays.destroy
call super::destroy
end on

event open;call super::open;
/* appel fonction de chargement des éléments multi langue de la table concernée */

fu_ini_param("COME9001",DBNAME_PAYS ,DBNAME_PAYS_INTITULE )
end event

type uo_statusbar from w_a_liste`uo_statusbar within w_liste_pays
end type

type cb_cancel from w_a_liste`cb_cancel within w_liste_pays
end type

type cb_ok from w_a_liste`cb_ok within w_liste_pays
end type

type dw_1 from w_a_liste`dw_1 within w_liste_pays
string tag = "A_TRADUIRE"
integer height = 736
string dataobject = "d_liste_pays_langue"
end type

type pb_ok from w_a_liste`pb_ok within w_liste_pays
integer x = 151
integer y = 816
end type

type pb_echap from w_a_liste`pb_echap within w_liste_pays
integer x = 864
integer y = 808
end type

