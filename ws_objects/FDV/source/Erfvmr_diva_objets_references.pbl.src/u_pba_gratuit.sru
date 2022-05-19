$PBExportHeader$u_pba_gratuit.sru
$PBExportComments$Ancêtre - Affectation de la gratuité aux lignes de cde
forward
global type u_pba_gratuit from u_pba
end type
end forward

global type u_pba_gratuit from u_pba
integer width = 334
integer height = 168
string facename = "Arial"
string text = "&Gratuit Payant"
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbargent.bmp"
alignment htextalign = left!
vtextalign vtextalign = multiline!
end type
global u_pba_gratuit u_pba_gratuit

on constructor;call u_pba::constructor;
// -----------------------------------------------------
// DECLENCHEMENT D'UN EVENEMENT AU NIVEAU DE LA FENÊTRE
// -----------------------------------------------------
	fu_setevent ("ue_gratuit")

	fu_set_MicroHelp ("Modification du code produit gratuit des lignes de commandes sélectionnées")

end on

on u_pba_gratuit.create
call super::create
end on

on u_pba_gratuit.destroy
call super::destroy
end on

