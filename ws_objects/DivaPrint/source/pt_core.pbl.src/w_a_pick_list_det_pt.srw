$PBExportHeader$w_a_pick_list_det_pt.srw
$PBExportComments$[MAIN] Ancêtre des fenêtres Liste/Détail
forward
global type w_a_pick_list_det_pt from w_a_udim
end type
type dw_pick from u_dw_udim within w_a_pick_list_det_pt
end type
end forward

global type w_a_pick_list_det_pt from w_a_udim
int Width=1102
int Height=1045
event ue_insertpick pbm_custom45
event ue_deletepick pbm_custom46
dw_pick dw_pick
end type
global w_a_pick_list_det_pt w_a_pick_list_det_pt

on ue_insertpick;call w_a_udim::ue_insertpick;// Insert a new row in the pick list.

dw_pick.fu_insert (0)
end on

on ue_deletepick;call w_a_udim::ue_deletepick;// Delete current row in the pick list.

Long l_row_num


l_row_num = dw_pick.GetRow ()

IF l_row_num > 0 THEN
	dw_pick.fu_delete (l_row_num)
END IF

end on

on open;call w_a_udim::open;// Chain the detail datawindow to the pick list.

dw_pick.fu_append (dw_1)


// Set the pick list transaction and dbError title.

dw_pick.SetTransObject (i_tr_sql)

dw_pick.fu_set_error_title (this.title)


// Put the pick list in single row selecion mode.

dw_pick.fu_set_selection_mode (1)
end on

on w_a_pick_list_det_pt.create
int iCurrent
call w_a_udim::create
this.dw_pick=create dw_pick
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=dw_pick
end on

on w_a_pick_list_det_pt.destroy
call w_a_udim::destroy
destroy(this.dw_pick)
end on

type dw_1 from w_a_udim`dw_1 within w_a_pick_list_det_pt
int X=110
int Y=481
int TabOrder=10
end type

type dw_pick from u_dw_udim within w_a_pick_list_det_pt
int X=110
int Y=41
end type

event rowfocuschanged;call super::rowfocuschanged;// Prompt for save if a new pick list item is selected.

// Test ancestor results (was rowfocuschanged canceled?)
IF i_b_canceled_rfc THEN
	i_b_canceled_rfc = FALSE
	i_b_forced_rfc = TRUE
	RETURN
END IF

// Double boolean required to prevent 2nd rowfocuschanged
// event posted by ancestor from firing here (see u_dwa_pt)
IF i_b_forced_rfc  THEN
	i_b_forced_rfc = FALSE
	RETURN
END IF

parent.TriggerEvent ("ue_retrieve")
end event

event ue_prerowfocuschanged;// Override

Integer i_answer


IF dw_1.fu_changed () THEN
	i_answer = g_nv_msg_mgr.fnv_process_msg ("pt", "Save Changes?", &
															"", parent.title, 0, 0)
	CHOOSE CASE i_answer
		CASE 1
			parent.TriggerEvent ("ue_save")
			
		// Canceled.  Return to old row
		CASE 3
			RETURN -1
	END CHOOSE
END IF

RETURN 0
end event

