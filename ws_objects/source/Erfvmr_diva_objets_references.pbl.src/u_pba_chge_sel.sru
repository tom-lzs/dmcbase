$PBExportHeader$u_pba_chge_sel.sru
$PBExportComments$Ancêtre - Changement de sélection
forward
global type u_pba_chge_sel from u_pba
end type
end forward

global type u_pba_chge_sel from u_pba
integer width = 334
integer height = 168
string facename = "Arial"
string text = "C&hanger"
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pb_chgmt.bmp"
alignment htextalign = left!
end type
global u_pba_chge_sel u_pba_chge_sel

on constructor;call u_pba::constructor;
// -------------------------------------------------------
// DECLENCHEMENT DE L'EVENEMENT AU NIVEAU DE LA FENÊTRE 
// -------------------------------------------------------
	fu_setevent ("ue_changer")

	fu_set_microhelp ("Modification de la sélection initiale")

end on

on u_pba_chge_sel.create
call super::create
end on

on u_pba_chge_sel.destroy
call super::destroy
end on

