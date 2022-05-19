$PBExportHeader$u_pba_ca_mois.sru
$PBExportComments$Ancêtre - Picture Button ca mois
forward
global type u_pba_ca_mois from u_pba
end type
end forward

global type u_pba_ca_mois from u_pba
integer width = 521
integer height = 272
string facename = "Arial"
string text = "C&A Mois"
boolean originalsize = true
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbcamois.bmp"
string disabledname = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbcamois.bmp"
end type
global u_pba_ca_mois u_pba_ca_mois

on constructor;call u_pba::constructor;
// ------------------------------------
// DECLENCHE L'EVENEMENT DE LA FENÊTRE
// ------------------------------------
	fu_setevent("ue_ca_mois")

	fu_set_microhelp ("Affichage en C.A. mensuel")
end on

on u_pba_ca_mois.create
call super::create
end on

on u_pba_ca_mois.destroy
call super::destroy
end on

