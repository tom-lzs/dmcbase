$PBExportHeader$u_pba_annul_promo.sru
$PBExportComments$Ancêtre - Picture Bouton : Annulation de la promtion en cours
forward
global type u_pba_annul_promo from u_pba
end type
end forward

global type u_pba_annul_promo from u_pba
integer width = 334
integer height = 168
string facename = "Arial"
string text = "&Annul      promo"
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pb_aprom.bmp"
alignment htextalign = left!
vtextalign vtextalign = multiline!
end type
global u_pba_annul_promo u_pba_annul_promo

on constructor;call u_pba::constructor;
// -------------------------------------------------------
// DECLENCHEMENT DE L'EVENEMENT AU NIVEAU DE LA FENÊTRE 
// -------------------------------------------------------
	fu_setevent ("ue_annul_promo")

	fu_set_MicroHelp ("Annulation de la promtion en cours")

end on

on u_pba_annul_promo.create
call super::create
end on

on u_pba_annul_promo.destroy
call super::destroy
end on

