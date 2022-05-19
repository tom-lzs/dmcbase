$PBExportHeader$u_pba_ok.sru
$PBExportComments$Ancêtre - Picture Button ok
forward
global type u_pba_ok from u_pba
end type
end forward

global type u_pba_ok from u_pba
integer width = 338
integer height = 168
string facename = "Arial"
string text = "OK"
boolean default = true
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbok.bmp"
end type
global u_pba_ok u_pba_ok

on constructor;call u_pba::constructor;
// ------------------------------------------
// Déclenche l'évènement de la fenêtre
// ------------------------------------------
	fu_setevent ("ue_ok")

	fu_set_microhelp ("Validation et sauvegarde des modifications")
end on

on u_pba_ok.create
call super::create
end on

on u_pba_ok.destroy
call super::destroy
end on

