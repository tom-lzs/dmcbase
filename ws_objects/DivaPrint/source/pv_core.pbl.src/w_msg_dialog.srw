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
call super::create
end on

on w_msg_dialog.destroy
call super::destroy
end on

type cb_ok from w_msg_dialog_pt`cb_ok within w_msg_dialog
end type

type p_1 from w_msg_dialog_pt`p_1 within w_msg_dialog
string picturename = ""
end type

type mle_msg from w_msg_dialog_pt`mle_msg within w_msg_dialog
end type

type cb_1 from w_msg_dialog_pt`cb_1 within w_msg_dialog
end type

type cb_2 from w_msg_dialog_pt`cb_2 within w_msg_dialog
end type

