$PBExportHeader$u_pba_texte_defaut.sru
$PBExportComments$Ancêtre - Changement de bon de commande
forward
global type u_pba_texte_defaut from u_pba
end type
end forward

global type u_pba_texte_defaut from u_pba
integer width = 457
integer height = 160
boolean dragauto = true
string facename = "Arial"
string text = "&Textes par defaut"
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pb_bon.bmp"
end type
global u_pba_texte_defaut u_pba_texte_defaut

event constructor;call super::constructor;
// -------------------------------------------------------
// DECLENCHEMENT DE L'EVENEMENT AU NIVEAU DE LA FENÊTRE 
// -------------------------------------------------------
	fu_setevent ("ue_texte_defaut")

	fu_set_MicroHelp ("Reinitialisation des textes clients par defaut")

end event

on u_pba_texte_defaut.create
call super::create
end on

on u_pba_texte_defaut.destroy
call super::destroy
end on

