$PBExportHeader$u_pba_reliquat.sru
$PBExportComments$Ancêtre - Picture Button reliquat par article
forward
global type u_pba_reliquat from u_pba
end type
end forward

global type u_pba_reliquat from u_pba
integer width = 521
integer height = 268
string facename = "Arial"
string text = "&Carnet cde"
boolean default = true
boolean originalsize = true
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbreliqu.bmp"
string disabledname = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbreliqu.bmp"
end type
global u_pba_reliquat u_pba_reliquat

on constructor;call u_pba::constructor;
// ------------------------------------------
// Déclenche l'évenement de la fenêtre
// ------------------------------------------
	fu_setevent("ue_reliquat")

	fu_set_microhelp("Affichage du carnet de commande client (reliquats)")
end on

on u_pba_reliquat.create
call super::create
end on

on u_pba_reliquat.destroy
call super::destroy
end on

