$PBExportHeader$w_a_pick_one.srw
$PBExportComments$[RESPONSE] Ancêtre des fenêtres de Sélection Mono-ligne.
forward
global type w_a_pick_one from w_a_pick_one_pt
end type
end forward

global type w_a_pick_one from w_a_pick_one_pt
end type
global w_a_pick_one w_a_pick_one

on w_a_pick_one.create
call w_a_pick_one_pt::create
end on

on w_a_pick_one.destroy
call w_a_pick_one_pt::destroy
end on

