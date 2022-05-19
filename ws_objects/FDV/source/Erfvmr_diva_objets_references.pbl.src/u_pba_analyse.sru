$PBExportHeader$u_pba_analyse.sru
$PBExportComments$Ancêtre - Picture Button analyse
forward
global type u_pba_analyse from u_pba
end type
end forward

global type u_pba_analyse from u_pba
boolean visible = false
integer width = 379
integer height = 180
string facename = "Arial"
string text = "Anal&yse"
boolean cancel = true
boolean originalsize = true
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbanalys.bmp"
string disabledname = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbanalys.bmp"
end type
global u_pba_analyse u_pba_analyse

on constructor;call u_pba::constructor;
// -----------------------------------
// Déclenche l'évenement de la fenêtre
// -----------------------------------
	fu_setevent("ue_analyse")

	fu_set_microhelp("Affichage de l'analyse du C.A client")
end on

on u_pba_analyse.create
call super::create
end on

on u_pba_analyse.destroy
call super::destroy
end on

