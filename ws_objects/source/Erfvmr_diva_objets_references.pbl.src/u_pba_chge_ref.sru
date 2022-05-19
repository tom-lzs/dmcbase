$PBExportHeader$u_pba_chge_ref.sru
$PBExportComments$Ancêtre - Choix d'une autre référence
forward
global type u_pba_chge_ref from u_pba
end type
end forward

global type u_pba_chge_ref from u_pba
integer width = 334
integer height = 168
string facename = "Arial"
string text = "Change réf"
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbchgart.bmp"
end type
global u_pba_chge_ref u_pba_chge_ref

on constructor;call u_pba::constructor;
// -------------------------------------------------------
// DECLENCHEMENT DE L'EVENEMENT AU NIVEAU DE LA FENÊTRE 
// -------------------------------------------------------
	fu_setevent ("ue_chge_ref")

	fu_set_microhelp ("Sélection d'une autre référence")

end on

on u_pba_chge_ref.create
call super::create
end on

on u_pba_chge_ref.destroy
call super::destroy
end on

