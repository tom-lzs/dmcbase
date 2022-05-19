$PBExportHeader$u_pba_choix_mois.sru
$PBExportComments$Ancêtre - Picture Button choix mois
forward
global type u_pba_choix_mois from u_pba
end type
end forward

global type u_pba_choix_mois from u_pba
integer width = 517
integer height = 264
string facename = "Arial"
string text = "Mo&is ?"
boolean originalsize = true
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbchmois.bmp"
string disabledname = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbchmois.bmp"
end type
global u_pba_choix_mois u_pba_choix_mois

on constructor;call u_pba::constructor;
// ------------------------------------
// Déclenche l'évènement de la fenêtre
// ------------------------------------
	fu_setevent("ue_choix_mois")

	fu_set_microhelp ("Changement de mois")
end on

on u_pba_choix_mois.create
call super::create
end on

on u_pba_choix_mois.destroy
call super::destroy
end on

