$PBExportHeader$u_pba_nouveau.sru
$PBExportComments$Ancêtre - Picture Button nouveau
forward
global type u_pba_nouveau from u_pba
end type
end forward

global type u_pba_nouveau from u_pba
integer width = 521
integer height = 272
string facename = "Arial"
string text = "&Nouveau"
boolean default = true
boolean originalsize = true
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbnouv.bmp"
string disabledname = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbnouv.bmp"
end type
global u_pba_nouveau u_pba_nouveau

on constructor;call u_pba::constructor;
// --------------------------------------
// Déclenche l'évènement de la fenêtre
// --------------------------------------
	fu_setevent ("ue_new")

	fu_set_microhelp ("Saisie d'un nouveau client")
end on

on u_pba_nouveau.create
call super::create
end on

on u_pba_nouveau.destroy
call super::destroy
end on

