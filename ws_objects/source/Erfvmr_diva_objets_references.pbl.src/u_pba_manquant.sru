$PBExportHeader$u_pba_manquant.sru
$PBExportComments$Ancêtre - Affectation du code manquant aux lignes de cde
forward
global type u_pba_manquant from u_pba
end type
end forward

global type u_pba_manquant from u_pba
integer width = 334
integer height = 168
string facename = "Arial"
string text = "Man&quant"
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\manquant.bmp"
end type
global u_pba_manquant u_pba_manquant

on constructor;call u_pba::constructor;
// -------------------------------------------------------
// DECLENCHEMENT DE L'EVENEMENT AU NIVEAU DE LA FENÊTRE 
// -------------------------------------------------------
	fu_setevent ("ue_manquant")

	fu_set_MicroHelp ("Modification du code manquant des lignes de commande")
end on

on u_pba_manquant.create
call super::create
end on

on u_pba_manquant.destroy
call super::destroy
end on

