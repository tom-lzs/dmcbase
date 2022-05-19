$PBExportHeader$u_pba_art_nua.sru
$PBExportComments$Ancêtre - Blocage de la saisie par article ou par nuance
forward
global type u_pba_art_nua from u_pba
end type
end forward

global type u_pba_art_nua from u_pba
integer width = 334
integer height = 168
boolean dragauto = true
string facename = "Arial"
string text = "&Article"
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pb_art.bmp"
end type
global u_pba_art_nua u_pba_art_nua

event constructor;call super::constructor;
// -------------------------------------------------------
// DECLENCHEMENT DE L'EVENEMENT AU NIVEAU DE LA FENÊTRE 
// -------------------------------------------------------
	fu_setevent ("ue_article_dimension")

	fu_set_MicroHelp ("Blocage de la saisie par article ou par dimension")

end event

on u_pba_art_nua.create
call super::create
end on

on u_pba_art_nua.destroy
call super::destroy
end on

