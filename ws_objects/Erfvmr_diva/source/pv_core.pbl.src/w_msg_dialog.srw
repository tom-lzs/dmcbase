$PBExportHeader$w_msg_dialog.srw
$PBExportComments$Fenêtre boîte de dialogue de message commun PowerTOOL.
forward
global type w_msg_dialog from w_msg_dialog_pt
end type
end forward

global type w_msg_dialog from w_msg_dialog_pt
end type
global w_msg_dialog w_msg_dialog

on w_msg_dialog.create
call w_msg_dialog_pt::create
end on

on w_msg_dialog.destroy
call w_msg_dialog_pt::destroy
end on

