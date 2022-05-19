$PBExportHeader$w_liste_code_blocage.srw
$PBExportComments$Permet l'affichage de la liste des codes blocages
forward
global type w_liste_code_blocage from w_a_liste
end type
end forward

global type w_liste_code_blocage from w_a_liste
string tag = "BLOCAGE_COMMANDE"
integer width = 1422
integer height = 1000
string title = "Blocage de la commande"
end type
global w_liste_code_blocage w_liste_code_blocage

on w_liste_code_blocage.create
call super::create
end on

on w_liste_code_blocage.destroy
call super::destroy
end on

event open;call super::open; 
/* appel fonction de chargement des éléments multi langue de la table concernée */

fu_ini_param("COME9017",DBNAME_CODE_BLOCAGE_SAP ,DBNAME_CODE_BLOCAGE_SAP_INTITULE )
end event

type uo_statusbar from w_a_liste`uo_statusbar within w_liste_code_blocage
end type

type cb_cancel from w_a_liste`cb_cancel within w_liste_code_blocage
end type

type cb_ok from w_a_liste`cb_ok within w_liste_code_blocage
end type

type dw_1 from w_a_liste`dw_1 within w_liste_code_blocage
string tag = "A_TRADUIRE"
integer x = 78
integer width = 1225
string dataobject = "d_liste_code_blocage"
end type

type pb_ok from w_a_liste`pb_ok within w_liste_code_blocage
integer x = 169
string picturename = "c:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_echap from w_a_liste`pb_echap within w_liste_code_blocage
integer x = 901
end type

