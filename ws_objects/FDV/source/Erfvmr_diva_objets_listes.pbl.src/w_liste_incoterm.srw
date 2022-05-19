$PBExportHeader$w_liste_incoterm.srw
$PBExportComments$Permet l'affichage de la liste des codes incoterm
forward
global type w_liste_incoterm from w_a_liste
end type
end forward

global type w_liste_incoterm from w_a_liste
string tag = "LISTE_INCOTERM"
integer width = 1417
integer height = 932
string title = "Liste des incoterms"
end type
global w_liste_incoterm w_liste_incoterm

on w_liste_incoterm.create
call super::create
end on

on w_liste_incoterm.destroy
call super::destroy
end on

event open;call super::open; 
/* appel fonction de chargement des éléments multi langue de la table concernée */

fu_ini_param("COME9011",DBNAME_CODE_INCOTERM ,DBNAME_CODE_INCOTERM_INTITULE )
end event

type cb_cancel from w_a_liste`cb_cancel within w_liste_incoterm
end type

type cb_ok from w_a_liste`cb_ok within w_liste_incoterm
end type

type dw_1 from w_a_liste`dw_1 within w_liste_incoterm
string tag = "A_TRADUIRE"
integer x = 96
integer width = 1221
integer height = 532
integer taborder = 1
string dataobject = "d_liste_incoterm"
end type

type pb_ok from w_a_liste`pb_ok within w_liste_incoterm
integer x = 178
integer y = 620
integer taborder = 0
end type

type pb_echap from w_a_liste`pb_echap within w_liste_incoterm
integer x = 878
integer y = 620
integer taborder = 0
end type

