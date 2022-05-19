$PBExportHeader$u_pba_chgmt_annee.sru
$PBExportComments$Ancêtre - Picture Button changement année
forward
global type u_pba_chgmt_annee from u_pba
end type
end forward

global type u_pba_chgmt_annee from u_pba
integer width = 530
integer height = 272
string facename = "Arial"
string text = "An   An-&1"
boolean originalsize = true
string picturename = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbchgan.bmp"
string disabledname = "c:\users\a014446\documents\powerbuilder\12.5\Erfvmr_diva\Image\pbchgan.bmp"
end type
global u_pba_chgmt_annee u_pba_chgmt_annee

on constructor;call u_pba::constructor;
// -------------------------------------
// Declenche l'évènement de la fenêtre
// -------------------------------------
	fu_setevent ("ue_chgmt_annee")

	fu_set_microhelp ("Changement d'année")

end on

on u_pba_chgmt_annee.create
call super::create
end on

on u_pba_chgmt_annee.destroy
call super::destroy
end on

