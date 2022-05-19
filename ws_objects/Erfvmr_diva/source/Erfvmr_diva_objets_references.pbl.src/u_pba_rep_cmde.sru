$PBExportHeader$u_pba_rep_cmde.sru
$PBExportComments$Ancêtre - Picture Button répertoire des commandes
forward
global type u_pba_rep_cmde from u_pba
end type
end forward

global type u_pba_rep_cmde from u_pba
integer width = 370
integer height = 172
string facename = "Arial"
boolean enabled = false
string text = "R&ep Cmde"
boolean originalsize = true
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbrepcmd.bmp"
string disabledname = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbrepcmd.bmp"
end type
global u_pba_rep_cmde u_pba_rep_cmde

on constructor;call u_pba::constructor;
// ------------------------------------------
// Déclenche l'évenement de la fenêtre
// ------------------------------------------
	fu_setevent("ue_rep_cmde")

	fu_set_microhelp("affichage du répertoire des commandes")
end on

on u_pba_rep_cmde.create
call super::create
end on

on u_pba_rep_cmde.destroy
call super::destroy
end on

