$PBExportHeader$w_a_udim_su_pt.srw
$PBExportComments$[MAIN] Ancêtre des fenêtres de Gestion Multi-lignes avec Update Mono-ligne
forward
global type w_a_udim_su_pt from w_a_udim
end type
end forward

global type w_a_udim_su_pt from w_a_udim
end type
global w_a_udim_su_pt w_a_udim_su_pt

type variables
Long i_l_save_row_num	// Last row which successfully gained focus
end variables

on ue_delete;call w_a_udim::ue_delete;// Ensure the update occurs.

dw_1.TriggerEvent (RowFocusChanged!)
end on

on w_a_udim_su_pt.create
call super::create
end on

on w_a_udim_su_pt.destroy
call super::destroy
end on

type dw_1 from w_a_udim`dw_1 within w_a_udim_su_pt
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;// Save changes, if any are pending, if this is indeed a row focus
// CHANGE, (e.g. we are not setting focus BACK to the current row).

Long l_row_num


// Bail out if we are simply setting focus BACK to the current row.

l_row_num = this.GetRow ()

IF l_row_num < 1 THEN
	RETURN
END IF

IF l_row_num = i_l_save_row_num THEN
	RETURN
END IF

IF NOT this.fu_changed() THEN
	i_l_save_row_num = l_row_num
	RETURN
END IF
	

// Trigger "ue_save" event if any changes were made since one row
// is maintained at a time (the 'su' paradigm).

//IF this.fu_changed () THEN
	parent.TriggerEvent ("ue_save")
//	IF NOT i_b_update_status THEN
//RETURN
	IF i_b_update_status THEN		
		
		i_l_save_row_num = l_row_num
	END IF
//END IF


// Save the row number.

//i_l_save_row_num = l_row_num
end event

