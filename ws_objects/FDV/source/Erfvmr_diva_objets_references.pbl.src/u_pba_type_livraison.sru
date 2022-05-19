$PBExportHeader$u_pba_type_livraison.sru
$PBExportComments$Ancêtre - Modification du type de livraison (Direct , Indirect , Facturation grossiste)
forward
global type u_pba_type_livraison from u_pba
end type
end forward

global type u_pba_type_livraison from u_pba
integer width = 334
integer height = 168
string facename = "Arial"
string text = "Di&rect"
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pb_usine.bmp"
alignment htextalign = left!
end type
global u_pba_type_livraison u_pba_type_livraison

on constructor;call u_pba::constructor;
// -------------------------------------------------------
// DECLENCHEMENT DE L'EVENEMENT AU NIVEAU DE LA FENÊTRE 
// -------------------------------------------------------
	This.fu_setevent ("ue_type_livraison")

	This.fu_set_MicroHelp ("Modification du type de livraison (direct, indirect, facturation grossiste)")

end on

on u_pba_type_livraison.create
call super::create
end on

on u_pba_type_livraison.destroy
call super::destroy
end on

