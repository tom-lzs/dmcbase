$PBExportHeader$w_liste_fonction_client.srw
$PBExportComments$Permet l'affichage de la liste des codes fonctions client
forward
global type w_liste_fonction_client from w_a_liste
end type
end forward

global type w_liste_fonction_client from w_a_liste
string tag = "LISTE_CODE_FONCTION"
integer width = 1746
integer height = 1096
string title = "Liste des codes fonction client"
end type
global w_liste_fonction_client w_liste_fonction_client

on w_liste_fonction_client.create
call super::create
end on

on w_liste_fonction_client.destroy
call super::destroy
end on

event open;call super::open; 
/* appel fonction de chargement des éléments multi langue de la table concernée */

fu_ini_param("COME9003",DBNAME_FONCTION ,DBNAME_FONCTION_INTITULE )
end event

type cb_cancel from w_a_liste`cb_cancel within w_liste_fonction_client
end type

type cb_ok from w_a_liste`cb_ok within w_liste_fonction_client
end type

type dw_1 from w_a_liste`dw_1 within w_liste_fonction_client
string tag = "A_TRADUIRE"
integer y = 32
integer width = 1605
integer height = 708
integer taborder = 1
string dataobject = "d_liste_fonction_client"
end type

type pb_ok from w_a_liste`pb_ok within w_liste_fonction_client
integer x = 233
integer y = 784
integer taborder = 0
string facename = "Arial"
end type

type pb_echap from w_a_liste`pb_echap within w_liste_fonction_client
integer x = 1070
integer y = 784
integer taborder = 0
string facename = "Arial"
end type

