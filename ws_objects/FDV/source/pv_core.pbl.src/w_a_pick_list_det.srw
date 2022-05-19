$PBExportHeader$w_a_pick_list_det.srw
$PBExportComments$[MAIN] Ancêtre des fenêtres Liste/Détail.
forward
global type w_a_pick_list_det from w_a_pick_list_det_pt
end type
end forward

global type w_a_pick_list_det from w_a_pick_list_det_pt
end type
global w_a_pick_list_det w_a_pick_list_det

on w_a_pick_list_det.create
call w_a_pick_list_det_pt::create
end on

on w_a_pick_list_det.destroy
call w_a_pick_list_det_pt::destroy
end on

