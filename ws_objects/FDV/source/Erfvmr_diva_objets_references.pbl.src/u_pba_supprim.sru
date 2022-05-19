$PBExportHeader$u_pba_supprim.sru
$PBExportComments$Ancêtre - Picture Button suppression
forward
global type u_pba_supprim from u_pba
end type
end forward

global type u_pba_supprim from u_pba
integer width = 334
integer height = 168
string facename = "Arial"
string text = "S&upprim."
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pb_suppr.bmp"
alignment htextalign = left!
end type
global u_pba_supprim u_pba_supprim

on constructor;call u_pba::constructor;
// ------------------------------------------
// Déclenche l'évenement de la fenêtre
// ------------------------------------------
	fu_setevent("ue_delete")

	fu_set_microhelp("Suppression")
end on

on u_pba_supprim.create
call super::create
end on

on u_pba_supprim.destroy
call super::destroy
end on

