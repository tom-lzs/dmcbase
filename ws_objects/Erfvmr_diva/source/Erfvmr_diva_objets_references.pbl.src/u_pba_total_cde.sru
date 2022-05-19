$PBExportHeader$u_pba_total_cde.sru
$PBExportComments$Ancêtre - Totalisation de la commande (valorisation)
forward
global type u_pba_total_cde from u_pba
end type
end forward

global type u_pba_total_cde from u_pba
integer width = 338
integer height = 168
string facename = "Arial"
string text = "T&otal cde"
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\calcul.bmp"
end type
global u_pba_total_cde u_pba_total_cde

on constructor;call u_pba::constructor;
// -------------------------------------------------------
// DECLENCHEMENT DE L'EVENEMENT AU NIVEAU DE LA FENÊTRE 
// -------------------------------------------------------
	fu_setevent ("ue_total_cde")

	fu_set_MicroHelp ("Estimation du total de la commande")

end on

on u_pba_total_cde.create
call super::create
end on

on u_pba_total_cde.destroy
call super::destroy
end on

