$PBExportHeader$u_pba_promo.sru
$PBExportComments$Ancêtre - Picture Button suivi promo
forward
global type u_pba_promo from u_pba
end type
end forward

global type u_pba_promo from u_pba
integer width = 379
integer height = 180
string facename = "Arial"
string text = "&Suiv promo"
boolean originalsize = true
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbpromo.bmp"
string disabledname = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbpromo.bmp"
end type
global u_pba_promo u_pba_promo

on constructor;call u_pba::constructor;
// ------------------------------------------
// Déclenche l'évenement de la fenêtre
// ------------------------------------------
	fu_setevent ("ue_promo")

	fu_set_microhelp ("Suivi des promotion client")
end on

on u_pba_promo.create
call super::create
end on

on u_pba_promo.destroy
call super::destroy
end on

