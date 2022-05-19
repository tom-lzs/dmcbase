$PBExportHeader$u_pba_tarif.sru
$PBExportComments$Ancêtre - Affectation d'un tarif aux lignes de la cde
forward
global type u_pba_tarif from u_pba
end type
end forward

global type u_pba_tarif from u_pba
integer width = 334
integer height = 168
string facename = "Arial"
string text = "&Tarif"
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pb_tarif.bmp"
alignment htextalign = left!
end type
global u_pba_tarif u_pba_tarif

on constructor;call u_pba::constructor;
// -------------------------------------------------------
// DECLENCHEMENT DE L'EVENEMENT AU NIVEAU DE LA FENÊTRE 
// -------------------------------------------------------
	fu_setevent ("ue_tarif")

	fu_set_MicroHelp ("Modification du numéro de tarif des lignes de commande")
end on

on u_pba_tarif.create
call super::create
end on

on u_pba_tarif.destroy
call super::destroy
end on

