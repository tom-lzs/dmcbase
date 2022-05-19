$PBExportHeader$w_message_cde.srw
$PBExportComments$Permet la gestion du message associé à une commande.
forward
global type w_message_cde from w_message_cde_response
end type
end forward

global type w_message_cde from w_message_cde_response
integer width = 3776
integer height = 2036
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean resizable = false
windowtype windowtype = child!
boolean ib_statusbar_visible = true
end type
global w_message_cde w_message_cde

on w_message_cde.create
call super::create
end on

on w_message_cde.destroy
call super::destroy
end on

event closequery;// overwrite
end event

type uo_statusbar from w_message_cde_response`uo_statusbar within w_message_cde
integer x = 2478
integer y = 308
end type

type dw_1 from w_message_cde_response`dw_1 within w_message_cde
string tag = "A_TRADUIRE"
integer y = 724
integer width = 2103
end type

type dw_mas from w_message_cde_response`dw_mas within w_message_cde
string tag = "A_TRADUIRE"
integer height = 512
end type

type pb_echap from w_message_cde_response`pb_echap within w_message_cde
integer y = 1548
string picturename = "C:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type pb_ok from w_message_cde_response`pb_ok within w_message_cde
integer y = 1556
string picturename = "C:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_suppression from w_message_cde_response`pb_suppression within w_message_cde
integer y = 1552
string picturename = "C:\appscir\Erfvmr_diva\Image\PB_SUPPR.BMP"
end type

type pb_impression from w_message_cde_response`pb_impression within w_message_cde
integer y = 1552
string picturename = "C:\appscir\Erfvmr_diva\Image\PB_IMP.BMP"
end type

