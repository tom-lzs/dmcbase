$PBExportHeader$u_pba_modalite_promo.sru
$PBExportComments$Ancêtre - Picture Button Modalité de la promotion
forward
global type u_pba_modalite_promo from u_pba
end type
end forward

global type u_pba_modalite_promo from u_pba
integer width = 334
integer height = 168
string facename = "Arial"
string text = "Modalités"
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbmodpro.bmp"
end type
global u_pba_modalite_promo u_pba_modalite_promo

on constructor;call u_pba::constructor;
// -------------------------------------------------------
// DECLENCHEMENT DE L'EVENEMENT AU NIVEAU DE LA FENÊTRE 
// -------------------------------------------------------
	fu_setevent ("ue_modalite_promo")

	fu_set_MicroHelp ("Affichage des modalités de la promotion")

end on

on u_pba_modalite_promo.create
call super::create
end on

on u_pba_modalite_promo.destroy
call super::destroy
end on

