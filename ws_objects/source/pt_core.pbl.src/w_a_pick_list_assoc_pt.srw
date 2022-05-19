$PBExportHeader$w_a_pick_list_assoc_pt.srw
$PBExportComments$[MAIN] Fenêtre associative Choix dans une Liste/Détail
forward
global type w_a_pick_list_assoc_pt from w_a_assoc
end type
type dw_pick from u_dw_udim within w_a_pick_list_assoc_pt
end type
type dw_choices from u_dw_q within w_a_pick_list_assoc_pt
end type
end forward

global type w_a_pick_list_assoc_pt from w_a_assoc
int Width=1495
int Height=1041
event ue_insertpick pbm_custom45
event ue_deletepick pbm_custom46
dw_pick dw_pick
dw_choices dw_choices
end type
global w_a_pick_list_assoc_pt w_a_pick_list_assoc_pt

on ue_insertpick;call w_a_assoc::ue_insertpick;
// Insert a new row in the pick list.

dw_pick.fu_insert (0)

end on

on ue_deletepick;call w_a_assoc::ue_deletepick;
// Delete current row in the pick list.

Long l_row_num


l_row_num = dw_pick.GetRow ()

IF l_row_num > 0 THEN
	dw_pick.fu_delete (l_row_num)
END IF

end on

on open;call w_a_assoc::open;
// Chain the detail datawindow to the pick list.

dw_pick.fu_append (dw_1)

// Set the pick list transaction and dbError title.

dw_pick.SetTransObject (i_tr_sql)
dw_choices.SetTransObject (i_tr_sql)

dw_pick.fu_set_error_title (this.title)
dw_choices.fu_set_error_title (this.title)

// Put the pick list in single row selecion mode.

dw_pick.fu_set_selection_mode (1)

end on

on w_a_pick_list_assoc_pt.create
int iCurrent
call w_a_assoc::create
this.dw_pick=create dw_pick
this.dw_choices=create dw_choices
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=dw_pick
this.Control[iCurrent+2]=dw_choices
end on

on w_a_pick_list_assoc_pt.destroy
call w_a_assoc::destroy
destroy(this.dw_pick)
destroy(this.dw_choices)
end on

type dw_1 from w_a_assoc`dw_1 within w_a_pick_list_assoc_pt
int X=929
int Y=493
int TabOrder=70
end type

type dw_pick from u_dw_udim within w_a_pick_list_assoc_pt
int X=37
int Y=33
int Width=1381
int TabOrder=20
end type

on rowfocuschanged;call u_dw_udim::rowfocuschanged;// Prompt for save if a new pick list item is selected.

Integer i_answer


IF dw_1.fu_changed () THEN
	i_answer = g_nv_msg_mgr.fnv_process_msg ("pt", "Save Changes?", &
															"", parent.title, 0, 0)
	IF i_answer = 1 THEN
		parent.TriggerEvent ("ue_save")
	END IF
END IF

parent.TriggerEvent ("ue_retrieve")

end on

on constructor;call u_dw_udim::constructor;
parent.fw_set_main ( this ) 

end on

type dw_choices from u_dw_q within w_a_pick_list_assoc_pt
int X=37
int Y=493
int Width=490
end type

on constructor;call u_dw_q::constructor;
parent.fw_set_choices ( this ) 

this.fu_set_selection_mode ( 3 ) 

end on

