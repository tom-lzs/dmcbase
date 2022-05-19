$PBExportHeader$w_a_pick_list_assoc.srw
$PBExportComments$[MAIN] Fenêtre associative Choix dans une Liste/Détail.
forward
global type w_a_pick_list_assoc from w_a_pick_list_assoc_pt
end type
end forward

global type w_a_pick_list_assoc from w_a_pick_list_assoc_pt
end type
global w_a_pick_list_assoc w_a_pick_list_assoc

on w_a_pick_list_assoc.create
call w_a_pick_list_assoc_pt::create
end on

on w_a_pick_list_assoc.destroy
call w_a_pick_list_assoc_pt::destroy
end on

