$PBExportHeader$u_pba_etiquette.sru
$PBExportComments$Ancêtre - Picture Button nouveau
forward
global type u_pba_etiquette from u_pba
end type
end forward

global type u_pba_etiquette from u_pba
integer width = 375
integer height = 200
integer textsize = -16
integer weight = 700
string facename = "Arial"
boolean flatstyle = true
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\etiquettescb.jpg"
string disabledname = "C:\Donnees\PowerBuilder\Erfvmr_diva\Image\etiquettescb.jpg"
end type
global u_pba_etiquette u_pba_etiquette

event constructor;call super::constructor;
// --------------------------------------
// Déclenche l'évènement de la fenêtre
// --------------------------------------
	fu_setevent ("ue_saisie_cb")

	fu_set_microhelp ("Saisie par code barre")
end event

on u_pba_etiquette.create
call super::create
end on

on u_pba_etiquette.destroy
call super::destroy
end on

