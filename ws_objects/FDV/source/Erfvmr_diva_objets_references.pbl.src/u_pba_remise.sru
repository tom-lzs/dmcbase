$PBExportHeader$u_pba_remise.sru
$PBExportComments$Ancêtre - Affectation d'une remise aux lignes de cde
forward
global type u_pba_remise from u_pba
end type
end forward

global type u_pba_remise from u_pba
integer width = 334
integer height = 168
string facename = "Arial"
string text = "Re&mise"
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbremise.bmp"
end type
global u_pba_remise u_pba_remise

on constructor;call u_pba::constructor;
// -------------------------------------------------------
// DECLENCHEMENT DE L'EVENEMENT AU NIVEAU DE LA FENÊTRE 
// -------------------------------------------------------
	fu_setevent ("ue_remise")

	fu_set_MicroHelp ("Modification du taux de remise des lignes de commande")

end on

on u_pba_remise.create
call super::create
end on

on u_pba_remise.destroy
call super::destroy
end on

