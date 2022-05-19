$PBExportHeader$u_pba_fin_page.sru
$PBExportComments$Ancêtre - Fin de page mode operatrice
forward
global type u_pba_fin_page from u_pba
end type
end forward

global type u_pba_fin_page from u_pba
integer width = 334
integer height = 168
string facename = "Arial"
string text = "Fin &Page. F2"
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pb_fin_page.bmp"
boolean map3dcolors = true
end type
global u_pba_fin_page u_pba_fin_page

event constructor;call super::constructor;
// ------------------------------------
// Déclenche l'évènement de la fenêtre
// ------------------------------------
	fu_setevent ("ue_fin_page")

	fu_set_microhelp ("Fin de page")
end event

on u_pba_fin_page.create
call super::create
end on

on u_pba_fin_page.destroy
call super::destroy
end on

