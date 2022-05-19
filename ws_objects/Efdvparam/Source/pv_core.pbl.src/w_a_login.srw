$PBExportHeader$w_a_login.srw
$PBExportComments$Ancêtre des fenêtres de connexion application.
forward
global type w_a_login from w_a_login_pt
end type
end forward

global type w_a_login from w_a_login_pt
end type
global w_a_login w_a_login

on w_a_login.create
call w_a_login_pt::create
end on

on w_a_login.destroy
call w_a_login_pt::destroy
end on

