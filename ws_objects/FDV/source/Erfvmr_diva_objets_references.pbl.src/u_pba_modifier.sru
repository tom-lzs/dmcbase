$PBExportHeader$u_pba_modifier.sru
$PBExportComments$Ancêtre - Picture Button modifier
forward
global type u_pba_modifier from u_pba
end type
end forward

global type u_pba_modifier from u_pba
integer width = 517
integer height = 272
string facename = "Arial"
string text = "F9            Modifier"
boolean originalsize = true
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbmodif.bmp"
string disabledname = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbmodif.bmp"
end type
global u_pba_modifier u_pba_modifier

on constructor;call u_pba::constructor;
// ------------------------------------------
// Déclenche l'évenement de la fenêtre
// ------------------------------------------
	fu_setevent ("ue_modifier")

	fu_set_microhelp ("Modification des informations client")
end on

on u_pba_modifier.create
call super::create
end on

on u_pba_modifier.destroy
call super::destroy
end on

