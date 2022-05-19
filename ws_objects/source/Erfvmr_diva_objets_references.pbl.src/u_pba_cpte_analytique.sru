$PBExportHeader$u_pba_cpte_analytique.sru
$PBExportComments$Ancêtre - Changement du compte analytique des lignes de cde
forward
global type u_pba_cpte_analytique from u_pba
end type
end forward

global type u_pba_cpte_analytique from u_pba
integer width = 334
integer height = 168
string facename = "Arial"
string text = "Cpte.    Anal&yt."
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pb_cpana.bmp"
alignment htextalign = left!
vtextalign vtextalign = multiline!
end type
global u_pba_cpte_analytique u_pba_cpte_analytique

on constructor;call u_pba::constructor;
// -----------------------------------------------------
// DECLENCHEMENT DE L'EVENEMENT AU NIVEAU DE LA FENÊTRE
// -----------------------------------------------------
	fu_setevent ("ue_cpte_analytique")

	fu_set_microhelp ("Modification du compte analytique des lignes de commande")
end on

on u_pba_cpte_analytique.create
call super::create
end on

on u_pba_cpte_analytique.destroy
call super::destroy
end on

