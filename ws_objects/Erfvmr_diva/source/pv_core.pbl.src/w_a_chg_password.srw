$PBExportHeader$w_a_chg_password.srw
$PBExportComments$Ancêtre des fenêtres de changement de mot de passe.
forward
global type w_a_chg_password from w_a_chg_password_pt
end type
end forward

global type w_a_chg_password from w_a_chg_password_pt
end type
global w_a_chg_password w_a_chg_password

on w_a_chg_password.create
call w_a_chg_password_pt::create
end on

on w_a_chg_password.destroy
call w_a_chg_password_pt::destroy
end on

