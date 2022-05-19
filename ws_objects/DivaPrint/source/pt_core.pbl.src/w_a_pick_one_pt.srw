$PBExportHeader$w_a_pick_one_pt.srw
$PBExportComments$[RESPONSE] Ancêtre des fenêtres de Sélection Mono-ligne
forward
global type w_a_pick_one_pt from w_a_pick_many
end type
end forward

global type w_a_pick_one_pt from w_a_pick_many
end type
global w_a_pick_one_pt w_a_pick_one_pt

on open;call w_a_pick_many::open;// Override the ancestor by resetting the selection mode to single row

dw_1.fu_set_selection_mode (1)
end on

on w_a_pick_one_pt.create
call w_a_pick_many::create
end on

on w_a_pick_one_pt.destroy
call w_a_pick_many::destroy
end on

event dw_1::doubleclicked;call w_a_pick_many`dw_1::doubleclicked;// Double click is equivalent to pressing the OK button

IF row > 0 THEN
	parent.TriggerEvent ("ue_ok")
END IF
end event

