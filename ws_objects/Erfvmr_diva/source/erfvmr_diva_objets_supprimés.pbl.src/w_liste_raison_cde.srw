$PBExportHeader$w_liste_raison_cde.srw
$PBExportComments$Permet l'affichage de la liste des raisons de comande
forward
global type w_liste_raison_cde from w_a_liste
end type
end forward

global type w_liste_raison_cde from w_a_liste
string tag = "LISTE_RAISON_COMMANDE"
integer width = 1426
integer height = 996
string title = "Liste des raisons de commande"
end type
global w_liste_raison_cde w_liste_raison_cde

on w_liste_raison_cde.create
call super::create
end on

on w_liste_raison_cde.destroy
call super::destroy
end on

event open;call super::open; 
/* appel fonction de chargement des éléments multi langue de la table concernée 
   elle se trouve dans l'ancêtre w_a_liste */

      fu_ini_param("COME9023",DBNAME_RAISON_CDE ,DBNAME_RAISON_CDE_INTITULE )

/* appel fonction permettant de faire un retrieve avec argument au niveau 
   évènement ue_init de l'ancêtre w_a_liste   */ 
	
   fu_ini_retrieve_arg (i_str_pass.s[4])
end event

event ue_init;call super::ue_init;///* <DESC>
//     Permet d'extraire les données pour le type de commande passé en paramètre
//   </DESC> */
//	if dw_1.Retrieve (i_str_pass.s[4]) = -1 then
//			f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
//	end if
//	
//	if dw_1.rowCount() > 0 then
//		dw_1.setRow(1)
//		dw_1.setfocus()
//	end if
end event

type cb_cancel from w_a_liste`cb_cancel within w_liste_raison_cde
end type

type cb_ok from w_a_liste`cb_ok within w_liste_raison_cde
end type

type dw_1 from w_a_liste`dw_1 within w_liste_raison_cde
string tag = "A_TRADUIRE"
string dataobject = "d_liste_raison_cde"
end type

type pb_ok from w_a_liste`pb_ok within w_liste_raison_cde
integer x = 155
end type

type pb_echap from w_a_liste`pb_echap within w_liste_raison_cde
integer x = 887
integer y = 680
end type

