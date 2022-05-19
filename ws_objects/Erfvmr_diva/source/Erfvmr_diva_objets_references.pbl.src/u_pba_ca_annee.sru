$PBExportHeader$u_pba_ca_annee.sru
$PBExportComments$Ancêtre - Picture Button ca année
forward
global type u_pba_ca_annee from u_pba
end type
end forward

global type u_pba_ca_annee from u_pba
integer width = 512
integer height = 268
string facename = "Arial"
string text = "&CA Année"
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbcaan.bmp"
string disabledname = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbcaan.bmp"
end type
global u_pba_ca_annee u_pba_ca_annee

on constructor;call u_pba::constructor;
// ------------------------------------
// DECLENCHE L'EVENEMENT DE LA FENÊTRE
// ------------------------------------
	fu_setevent("ue_ca_annee")

	fu_set_microhelp ("Affichage en C.A. annuel")
end on

on u_pba_ca_annee.create
call super::create
end on

on u_pba_ca_annee.destroy
call super::destroy
end on

