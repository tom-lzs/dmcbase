$PBExportHeader$u_pba_changer.sru
$PBExportComments$Ancêtre - Picture Button changer
forward
global type u_pba_changer from u_pba
end type
end forward

global type u_pba_changer from u_pba
integer width = 379
integer height = 180
string facename = "Arial"
string text = "C&hanger"
boolean originalsize = true
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbchange.bmp"
string disabledname = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbchange.bmp"
end type
global u_pba_changer u_pba_changer

on constructor;call u_pba::constructor;
// ------------------------------------
// Déclanche l'évenement de la fenêtre
// ------------------------------------
	fu_setevent("ue_changer")

	fu_set_microhelp ("Sélection d'un autre client")
end on

on u_pba_changer.create
call super::create
end on

on u_pba_changer.destroy
call super::destroy
end on

