$PBExportHeader$u_pba_echeance.sru
$PBExportComments$Ancêtre - Affectation d'un code échéance aux lignes de cde
forward
global type u_pba_echeance from u_pba
end type
end forward

global type u_pba_echeance from u_pba
integer width = 334
integer height = 168
string facename = "Arial"
string text = "&Echeance"
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\echeance.bmp"
end type
global u_pba_echeance u_pba_echeance

on constructor;call u_pba::constructor;
// -------------------------------------------------------
// DECLENCHEMENT DE L'EVENEMENT AU NIVEAU DE LA FENÊTRE 
// -------------------------------------------------------
	fu_setevent ("ue_echeance")

// --------------------------------------
// AFFICHAGE D'UN MESSAGE DANS MICROHELP
// --------------------------------------
	fu_set_MicroHelp ("Modification du code échéance des lignes de cde")

end on

on u_pba_echeance.create
call super::create
end on

on u_pba_echeance.destroy
call super::destroy
end on

