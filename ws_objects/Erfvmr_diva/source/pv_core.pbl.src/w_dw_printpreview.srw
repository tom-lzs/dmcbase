$PBExportHeader$w_dw_printpreview.srw
$PBExportComments$[RESPONSE] Fenêtre Aperçu avant impression.
forward
global type w_dw_printpreview from w_dw_printpreview_pt
end type
end forward

global type w_dw_printpreview from w_dw_printpreview_pt
end type
global w_dw_printpreview w_dw_printpreview

on w_dw_printpreview.create
call w_dw_printpreview_pt::create
end on

on w_dw_printpreview.destroy
call w_dw_printpreview_pt::destroy
end on

