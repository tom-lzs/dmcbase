$PBExportHeader$w_a_shared_pick_pt.srw
$PBExportComments$[MAIN] Ancêtre des fenêtres Liste/Détail avec DataWindows partagées
forward
global type w_a_shared_pick_pt from w_a_udim
end type
type dw_pick from u_dw_q within w_a_shared_pick_pt
end type
end forward

global type w_a_shared_pick_pt from w_a_udim
int Height=1029
dw_pick dw_pick
end type
global w_a_shared_pick_pt w_a_shared_pick_pt

event ue_init;call w_a_udim::ue_init;dw_pick.fu_set_selection_mode (1)  // set selection mode on pick
dw_1.ShareData (dw_pick)		// Share it with secondary window

end event

on ue_delete;call w_a_udim::ue_delete;dw_1.TriggerEvent (RowFocusChanged!)

end on

on w_a_shared_pick_pt.create
int iCurrent
call w_a_udim::create
this.dw_pick=create dw_pick
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=dw_pick
end on

on w_a_shared_pick_pt.destroy
call w_a_udim::destroy
destroy(this.dw_pick)
end on

type dw_1 from w_a_udim`dw_1 within w_a_shared_pick_pt
int X=60
int Y=497
int Width=860
int Height=417
int TabOrder=10
end type

on dw_1::rowfocuschanged;call w_a_udim`dw_1::rowfocuschanged;long l_row

l_row = this.GetRow ()

IF l_row > 0 AND l_row <> dw_pick.GetRow () THEN
	dw_pick.SetRow (l_row)
	dw_pick.ScrollToRow(l_row)
END IF

end on

on dw_1::retrieveend;call w_a_udim`dw_1::retrieveend;dw_pick.SelectRow (1, TRUE)
end on

type dw_pick from u_dw_q within w_a_shared_pick_pt
int X=55
int Y=49
int Width=860
int Height=417
int TabOrder=20
end type

on rowfocuschanged;call u_dw_q::rowfocuschanged;long l_row

l_row = this.GetRow ()

IF l_row > 0 AND l_row <> dw_1.GetRow () THEN
	dw_1.SetRow (l_row)
	dw_1.ScrollToRow(l_row)
	dw_1.SetFocus ()
END IF

end on

