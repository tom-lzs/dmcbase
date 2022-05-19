$PBExportHeader$u_pba_cb_ok.sru
$PBExportComments$Ancêtre - Picture Button quantité
forward
global type u_pba_cb_ok from u_pba
end type
end forward

global type u_pba_cb_ok from u_pba
integer width = 384
integer height = 236
string facename = "Arial"
boolean cancel = true
boolean flatstyle = true
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\Etiquettescb.jpg"
string disabledname = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\Etiquettescb.jpg"
end type
global u_pba_cb_ok u_pba_cb_ok

event constructor;call super::constructor;
// ------------------------------------
// Déclenche l'évènement de la fenêtre
// ------------------------------------  
	fu_setevent  ("ue_cb_ok")

	fu_set_microhelp ("Validation saisie CB")
end event

on u_pba_cb_ok.create
call super::create
end on

on u_pba_cb_ok.destroy
call super::destroy
end on

