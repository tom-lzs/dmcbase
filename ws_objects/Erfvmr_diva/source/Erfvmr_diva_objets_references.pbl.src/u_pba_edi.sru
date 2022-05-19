$PBExportHeader$u_pba_edi.sru
$PBExportComments$Ancêtre - Picture Button nouveau
forward
global type u_pba_edi from u_pba
end type
end forward

global type u_pba_edi from u_pba
integer width = 475
integer height = 224
integer weight = 700
string facename = "Arial"
string text = "E D I"
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\PB_INFO.BMP"
string disabledname = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\PB_INFO.BMP"
alignment htextalign = right!
end type
global u_pba_edi u_pba_edi

event constructor;call super::constructor;
// --------------------------------------
// Déclenche l'évènement de la fenêtre
// --------------------------------------
	fu_setevent ("ue_edi")

	fu_set_microhelp ("Modification infos EDI")
end event

on u_pba_edi.create
call super::create
end on

on u_pba_edi.destroy
call super::destroy
end on

