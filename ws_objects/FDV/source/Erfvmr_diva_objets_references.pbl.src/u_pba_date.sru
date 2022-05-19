$PBExportHeader$u_pba_date.sru
$PBExportComments$Ancêtre - Affectation date livraison aux lignes de cde
forward
global type u_pba_date from u_pba
end type
end forward

global type u_pba_date from u_pba
integer width = 334
integer height = 168
string facename = "Arial"
string text = "Date    Li&vr"
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbdatliv.bmp"
alignment htextalign = left!
vtextalign vtextalign = multiline!
end type
global u_pba_date u_pba_date

on constructor;call u_pba::constructor;
// -------------------------------------------------------
// DECLENCHEMENT DE L'EVENEMENT AU NIVEAU DE LA FENÊTRE 
// -------------------------------------------------------
	fu_setevent ("ue_date")

	fu_set_MicroHelp ("Modification de la date de livraison des lignes de commande")

end on

on u_pba_date.create
call super::create
end on

on u_pba_date.destroy
call super::destroy
end on

