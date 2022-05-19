$PBExportHeader$u_pba_cumul_mois.sru
$PBExportComments$Ancêtre - Picture Button cumul mois
forward
global type u_pba_cumul_mois from u_pba
end type
end forward

global type u_pba_cumul_mois from u_pba
integer width = 379
integer height = 180
string facename = "Arial"
string text = "C&umul Mois"
boolean originalsize = true
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbcumois.bmp"
string disabledname = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbcumois.bmp"
end type
global u_pba_cumul_mois u_pba_cumul_mois

on constructor;call u_pba::constructor;
// ------------------------------------
// Déclenche l'évènement de la fenêtre
// ------------------------------------
	fu_setevent("ue_cumul_mois")

	fu_set_microhelp("Affichage en cumul menusel")
end on

on u_pba_cumul_mois.create
call super::create
end on

on u_pba_cumul_mois.destroy
call super::destroy
end on

