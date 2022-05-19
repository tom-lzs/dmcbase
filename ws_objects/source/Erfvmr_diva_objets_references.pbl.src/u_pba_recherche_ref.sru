$PBExportHeader$u_pba_recherche_ref.sru
$PBExportComments$Ancêtre - Recherche reference en saisie de commande
forward
global type u_pba_recherche_ref from u_pba
end type
end forward

global type u_pba_recherche_ref from u_pba
integer width = 334
integer height = 168
string facename = "Arial"
string text = "Rercherche Réf. (F2)"
string picturename = "c:\appscir\Erfvmr_diva\Image\PB_VIDE.bmp"
string disabledname = "c:\appscir\Erfvmr_diva\Image\PB_VIDE.bmp"
vtextalign vtextalign = multiline!
end type
global u_pba_recherche_ref u_pba_recherche_ref

on u_pba_recherche_ref.create
call super::create
end on

on u_pba_recherche_ref.destroy
call super::destroy
end on

event constructor;call super::constructor;
// ------------------------------------
// Déclenche l'évènement de la fenêtre
// ------------------------------------  
	fu_setevent  ("ue_search")

	fu_set_microhelp ("Recherche références et tarifs")
end event

