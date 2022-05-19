$PBExportHeader$u_pba_new_client.sru
$PBExportComments$Ancêtre - Picture Button Modification client prospect
forward
global type u_pba_new_client from u_pba
end type
end forward

global type u_pba_new_client from u_pba
integer width = 370
integer height = 172
boolean dragauto = true
string facename = "Arial"
string text = "&Modif Client"
boolean default = true
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbnewcli.bmp"
alignment htextalign = left!
end type
global u_pba_new_client u_pba_new_client

on constructor;call u_pba::constructor;
// -------------------------------------------------------
// DECLENCHEMENT DE L'EVENEMENT AU NIVEAU DE LA FENÊTRE 
// -------------------------------------------------------
	fu_setevent ("ue_modif_client")

	fu_set_MicroHelp ("Modification d'un client prospect")

end on

on u_pba_new_client.create
call super::create
end on

on u_pba_new_client.destroy
call super::destroy
end on

