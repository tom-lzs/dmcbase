$PBExportHeader$u_pba_detail.sru
$PBExportComments$Ancêtre - Détail du carnet de commande client
forward
global type u_pba_detail from u_pba
end type
end forward

global type u_pba_detail from u_pba
integer width = 338
integer height = 160
boolean dragauto = true
string facename = "Arial"
string text = "&Détail"
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbdetail.bmp"
end type
global u_pba_detail u_pba_detail

on constructor;call u_pba::constructor;
// -------------------------------------------------------
// DECLENCHEMENT DE L'EVENEMENT AU NIVEAU DE LA FENÊTRE 
// -------------------------------------------------------
	fu_setevent ("ue_detail")

	fu_set_MicroHelp ("Détail du carnet de commande d'un client et d'une référence")

end on

on u_pba_detail.create
call super::create
end on

on u_pba_detail.destroy
call super::destroy
end on

