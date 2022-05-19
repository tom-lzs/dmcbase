$PBExportHeader$u_pba_liste.sru
$PBExportComments$Ancêtre - Picture Button liste
forward
global type u_pba_liste from u_pba
end type
end forward

global type u_pba_liste from u_pba
integer width = 517
integer height = 268
string facename = "Arial"
string text = "F2   Liste"
boolean originalsize = true
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbliste.bmp"
string disabledname = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbliste.bmp"
end type
global u_pba_liste u_pba_liste

event constructor;call super::constructor;
// ------------------------------------------
// Déclenchement de l'évènement de la fenêtre
// ------------------------------------------
	fu_setevent ("ue_liste")

	fu_set_microhelp ("Affichage de la liste")
end event

on u_pba_liste.create
call super::create
end on

on u_pba_liste.destroy
call super::destroy
end on

