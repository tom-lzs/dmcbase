$PBExportHeader$u_pba_sai_cmde.sru
$PBExportComments$Ancêtre - Picture Button saisie des commandes
forward
global type u_pba_sai_cmde from u_pba
end type
end forward

global type u_pba_sai_cmde from u_pba
integer width = 379
integer height = 180
string facename = "Arial"
string text = "C&ommand."
boolean originalsize = true
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pb_saicd.bmp"
end type
global u_pba_sai_cmde u_pba_sai_cmde

on constructor;call u_pba::constructor;
// ------------------------------------------
// Déclenche l'évenement de la fenêtre
// ------------------------------------------
	fu_setevent("ue_ligne_cde")

	fu_set_microhelp("Saisie commande")


end on

on u_pba_sai_cmde.create
call super::create
end on

on u_pba_sai_cmde.destroy
call super::destroy
end on

