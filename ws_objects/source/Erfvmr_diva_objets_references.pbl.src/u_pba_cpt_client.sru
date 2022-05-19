$PBExportHeader$u_pba_cpt_client.sru
$PBExportComments$Ancêtre - Picture Button compte client
forward
global type u_pba_cpt_client from u_pba
end type
end forward

global type u_pba_cpt_client from u_pba
integer width = 379
integer height = 180
string facename = "Arial"
string text = "C&mpt Client"
boolean originalsize = true
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbcptcli.bmp"
string disabledname = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbcptcli.bmp"
end type
global u_pba_cpt_client u_pba_cpt_client

on constructor;call u_pba::constructor;
// ------------------------------------
// Déclenche l'évenement de la fenêtre
// ------------------------------------
	fu_setevent("ue_cpt_client")

	fu_set_microhelp ("Situation du compte client")
end on

on u_pba_cpt_client.create
call super::create
end on

on u_pba_cpt_client.destroy
call super::destroy
end on

