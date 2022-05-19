$PBExportHeader$w_liste_nature_client.srw
$PBExportComments$Permet l'affichage de la liste des natures de client
forward
global type w_liste_nature_client from w_a_liste
end type
end forward

global type w_liste_nature_client from w_a_liste
string tag = "LISTE_NATURE_CLIENT"
integer width = 1385
integer height = 1172
string title = "Liste des natures client"
end type
global w_liste_nature_client w_liste_nature_client

on w_liste_nature_client.create
call super::create
end on

on w_liste_nature_client.destroy
call super::destroy
end on

event open;call super::open;/* appel fonction de chargement des éléments multi langue de la table concernée */

fu_ini_param("COME9002",DBNAME_NATURE_CLIENT ,DBNAME_NATURE_CLIENT_INTITULE )
end event

type cb_cancel from w_a_liste`cb_cancel within w_liste_nature_client
end type

type cb_ok from w_a_liste`cb_ok within w_liste_nature_client
end type

type dw_1 from w_a_liste`dw_1 within w_liste_nature_client
string tag = "A_TRADUIRE"
integer x = 96
integer width = 1170
integer height = 756
integer taborder = 1
string dataobject = "d_liste_nature_client"
end type

type pb_ok from w_a_liste`pb_ok within w_liste_nature_client
integer x = 151
integer y = 844
integer taborder = 0
end type

type pb_echap from w_a_liste`pb_echap within w_liste_nature_client
integer x = 869
integer y = 844
integer taborder = 0
end type

