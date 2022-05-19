$PBExportHeader$u_pba_fact_gro.sru
$PBExportComments$Ancêtre - Facturation Grossiste
forward
global type u_pba_fact_gro from u_pba
end type
end forward

global type u_pba_fact_gro from u_pba
integer width = 334
integer height = 168
boolean dragauto = true
string facename = "Arial"
string text = "Fa&ct. Gro"
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pb_fgro.bmp"
end type
global u_pba_fact_gro u_pba_fact_gro

on constructor;call u_pba::constructor;
// -------------------------------------------------------
// DECLENCHEMENT DE L'EVENEMENT AU NIVEAU DE LA FENÊTRE 
// -------------------------------------------------------
	fu_setevent ("ue_fact_gro")

	fu_set_MicroHelp ("Facturation de la ligne de commande au client payeur")

end on

on u_pba_fact_gro.create
call super::create
end on

on u_pba_fact_gro.destroy
call super::destroy
end on

