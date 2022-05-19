$PBExportHeader$u_pba_echap.sru
$PBExportComments$Ancêtre - Picture Button échappement
forward
global type u_pba_echap from u_pba
end type
end forward

global type u_pba_echap from u_pba
integer width = 334
integer height = 168
string facename = "Arial"
string text = "Echap"
boolean cancel = true
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbechap.bmp"
end type
global u_pba_echap u_pba_echap

on constructor;call u_pba::constructor;
// -----------------------------------
// Déclenche l'évènement de la fenêtre
// -----------------------------------
	fu_setevent ("ue_cancel")

	fu_set_microhelp ("Fermeture de la fenêtre")
end on

on u_pba_echap.create
call super::create
end on

on u_pba_echap.destroy
call super::destroy
end on

