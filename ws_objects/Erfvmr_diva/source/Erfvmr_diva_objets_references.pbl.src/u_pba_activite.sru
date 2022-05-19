$PBExportHeader$u_pba_activite.sru
$PBExportComments$Ancêtre - Picture Button quantité
forward
global type u_pba_activite from u_pba
end type
end forward

global type u_pba_activite from u_pba
integer width = 526
integer height = 264
string facename = "Arial"
string text = "Ac&tivité"
boolean cancel = true
boolean default = true
boolean originalsize = true
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\PBACTIVI.BMP"
string disabledname = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\PBACTIVI.BMP"
end type
global u_pba_activite u_pba_activite

on constructor;call u_pba::constructor;
// ------------------------------------
// Déclenche l'évènement de la fenêtre
// ------------------------------------
	fu_setevent ("ue_activite")

	fu_set_microhelp ("Changement d'activité")
end on

on u_pba_activite.create
call super::create
end on

on u_pba_activite.destroy
call super::destroy
end on

