$PBExportHeader$u_pba_chge_promo.sru
$PBExportComments$Ancêtre - Changement de promotion
forward
global type u_pba_chge_promo from u_pba
end type
end forward

global type u_pba_chge_promo from u_pba
integer width = 334
integer height = 168
string facename = "Arial"
string text = "changer"
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbchprom.bmp"
end type
global u_pba_chge_promo u_pba_chge_promo

on constructor;call u_pba::constructor;
// -------------------------------------------------------
// DECLENCHEMENT DE L'EVENEMENT AU NIVEAU DE LA FENÊTRE 
// -------------------------------------------------------
	fu_setevent ("ue_chge_promo")

	fu_set_microhelp ("Sélection d'une autre promotion")

end on

on u_pba_chge_promo.create
call super::create
end on

on u_pba_chge_promo.destroy
call super::destroy
end on

