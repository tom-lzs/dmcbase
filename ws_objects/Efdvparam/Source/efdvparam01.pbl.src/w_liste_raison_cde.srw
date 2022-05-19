$PBExportHeader$w_liste_raison_cde.srw
$PBExportComments$Permet l'affichage de la liste des raison de commande
forward
global type w_liste_raison_cde from w_a_liste
end type
end forward

global type w_liste_raison_cde from w_a_liste
integer x = 769
integer y = 461
string title = "Liste des raisons de commande"
end type
global w_liste_raison_cde w_liste_raison_cde

on w_liste_raison_cde.create
call super::create
end on

on w_liste_raison_cde.destroy
call super::destroy
end on

event ue_init;/* <DESC>
    Initialisation de la liste des raisons de commande pour le type de commande sélectionné
   </DESC> */

	if dw_1.Retrieve (i_str_pass.s[4]) = -1 then
     	f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
	end if
	
	if dw_1.rowCount() > 0 then
		dw_1.setRow(1)
		dw_1.setfocus()
	end if
end event

type cb_cancel from w_a_liste`cb_cancel within w_liste_raison_cde
end type

type cb_ok from w_a_liste`cb_ok within w_liste_raison_cde
end type

type dw_1 from w_a_liste`dw_1 within w_liste_raison_cde
string dataobject = "d_liste_raison_cde"
end type

