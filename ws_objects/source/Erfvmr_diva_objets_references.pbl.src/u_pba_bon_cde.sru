$PBExportHeader$u_pba_bon_cde.sru
$PBExportComments$Ancêtre - Changement de bon de commande
forward
global type u_pba_bon_cde from u_pba
end type
end forward

global type u_pba_bon_cde from u_pba
integer width = 357
integer height = 152
boolean dragauto = true
string facename = "Arial"
string text = "&Changer"
boolean originalsize = true
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pb_bon.bmp"
end type
global u_pba_bon_cde u_pba_bon_cde

on constructor;call u_pba::constructor;
// -------------------------------------------------------
// DECLENCHEMENT DE L'EVENEMENT AU NIVEAU DE LA FENÊTRE 
// -------------------------------------------------------
	fu_setevent ("ue_changer_bon")

	fu_set_MicroHelp ("Sélection d'un autre bon de commande")

end on

on u_pba_bon_cde.create
call super::create
end on

on u_pba_bon_cde.destroy
call super::destroy
end on

