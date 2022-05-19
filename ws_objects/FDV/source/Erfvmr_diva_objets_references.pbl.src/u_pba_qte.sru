$PBExportHeader$u_pba_qte.sru
$PBExportComments$Ancêtre - Picture Button quantité
forward
global type u_pba_qte from u_pba
end type
end forward

global type u_pba_qte from u_pba
integer width = 512
integer height = 272
string facename = "Arial"
string text = "&Quantité"
boolean cancel = true
boolean originalsize = true
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbqte.bmp"
string disabledname = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbqte.bmp"
end type
global u_pba_qte u_pba_qte

on constructor;call u_pba::constructor;
// ------------------------------------
// Déclenche l'évènement de la fenêtre
// ------------------------------------  
	fu_setevent  ("ue_qte")

	fu_set_microhelp ("Affichage du comparatif C.A. par article objectif en quantité")
end on

on u_pba_qte.create
call super::create
end on

on u_pba_qte.destroy
call super::destroy
end on

