$PBExportHeader$u_pba_appro.sru
$PBExportComments$Ancêtre - Facturation Grossiste
forward
global type u_pba_appro from u_pba
end type
end forward

global type u_pba_appro from u_pba
integer width = 334
integer height = 168
boolean dragauto = true
string text = "Ap&pro."
end type
global u_pba_appro u_pba_appro

event constructor;call super::constructor;
// -------------------------------------------------------
// DECLENCHEMENT DE L'EVENEMENT AU NIVEAU DE LA FENÊTRE 
// -------------------------------------------------------
	fu_setevent ("ue_appro")

	fu_set_MicroHelp ("Génération d'un OF")

end event

on u_pba_appro.create
end on

on u_pba_appro.destroy
end on

