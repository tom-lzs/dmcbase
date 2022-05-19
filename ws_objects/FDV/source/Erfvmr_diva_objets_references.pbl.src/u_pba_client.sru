$PBExportHeader$u_pba_client.sru
$PBExportComments$Ancêtre - Picture Button client
forward
global type u_pba_client from u_pba
end type
end forward

global type u_pba_client from u_pba
integer width = 530
integer height = 268
string facename = "Arial"
string text = "        &Client"
boolean originalsize = true
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbclient.bmp"
string disabledname = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbclient.bmp"
end type
global u_pba_client u_pba_client

on constructor;call u_pba::constructor;
// ------------------------------------
// Déclenche l'évènement de la fenêtre
// ------------------------------------
	fu_setevent ("ue_client")

	fu_set_microhelp ("Informations fiche client principale")
end on

on u_pba_client.create
call super::create
end on

on u_pba_client.destroy
call super::destroy
end on

