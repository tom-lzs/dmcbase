$PBExportHeader$w_a_shared_pick.srw
$PBExportComments$[MAIN] Ancêtre des fenêtres Liste/Détail avec DataWindows partagées.
forward
global type w_a_shared_pick from w_a_shared_pick_pt
end type
end forward

global type w_a_shared_pick from w_a_shared_pick_pt
end type
global w_a_shared_pick w_a_shared_pick

on w_a_shared_pick.create
call w_a_shared_pick_pt::create
end on

on w_a_shared_pick.destroy
call w_a_shared_pick_pt::destroy
end on

