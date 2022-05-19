$PBExportHeader$w_a_pick_many.srw
$PBExportComments$[RESPONSE] Ancêtre des fenêtres de Sélection Multi-lignes.
forward
global type w_a_pick_many from w_a_pick_many_pt
end type
end forward

global type w_a_pick_many from w_a_pick_many_pt
end type
global w_a_pick_many w_a_pick_many

on w_a_pick_many.create
call w_a_pick_many_pt::create
end on

on w_a_pick_many.destroy
call w_a_pick_many_pt::destroy
end on

