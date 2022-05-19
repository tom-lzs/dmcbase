$PBExportHeader$u_pba_grossiste.sru
$PBExportComments$Ancêtre - Picture Button  grossistes
forward
global type u_pba_grossiste from u_pba
end type
end forward

global type u_pba_grossiste from u_pba
integer width = 379
integer height = 180
string facename = "Arial"
string text = "&Grossiste"
boolean originalsize = true
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbgroste.bmp"
string disabledname = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbgroste.bmp"
end type
global u_pba_grossiste u_pba_grossiste

on constructor;call u_pba::constructor;
// -----------------------------------------------------
// DECLENCHEMENT DE L'EVENEMENT AU NIVEAU DE LA FENÊTRE
// -----------------------------------------------------
	fu_setevent ("ue_grossiste")

	fu_Set_MicroHelp ("modification des codes grossiste")
end on

on u_pba_grossiste.create
call super::create
end on

on u_pba_grossiste.destroy
call super::destroy
end on

