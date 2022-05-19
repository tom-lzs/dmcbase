$PBExportHeader$w_a_mas_det.srw
$PBExportComments$[MAIN] Ancêtre des fenêtres Maître/Détail.
forward
global type w_a_mas_det from w_a_mas_det_pt
end type
end forward

global type w_a_mas_det from w_a_mas_det_pt
end type
global w_a_mas_det w_a_mas_det

on w_a_mas_det.create
call w_a_mas_det_pt::create
end on

on w_a_mas_det.destroy
call w_a_mas_det_pt::destroy
end on

