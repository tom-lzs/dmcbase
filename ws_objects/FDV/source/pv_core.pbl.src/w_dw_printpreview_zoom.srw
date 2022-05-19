$PBExportHeader$w_dw_printpreview_zoom.srw
$PBExportComments$Fenêtre de zoom d'une DataWindow en aperçu avant impression.
forward
global type w_dw_printpreview_zoom from w_dw_printpreview_zoom_pt
end type
end forward

global type w_dw_printpreview_zoom from w_dw_printpreview_zoom_pt
end type
global w_dw_printpreview_zoom w_dw_printpreview_zoom

on w_dw_printpreview_zoom.create
call w_dw_printpreview_zoom_pt::create
end on

on w_dw_printpreview_zoom.destroy
call w_dw_printpreview_zoom_pt::destroy
end on

