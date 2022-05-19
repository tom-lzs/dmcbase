$PBExportHeader$w_a_mas_det_pt.srw
$PBExportComments$[MAIN] Ancêtre des fenêtres Maître/Détail
forward
global type w_a_mas_det_pt from w_a_udim
end type
type dw_mas from u_dw_udis within w_a_mas_det_pt
end type
end forward

global type w_a_mas_det_pt from w_a_udim
int Width=1011
int Height=1057
event ue_delete_master pbm_custom45
dw_mas dw_mas
end type
global w_a_mas_det_pt w_a_mas_det_pt

type variables

end variables

on ue_detect_change;// Override!

// Determine whether any changes are pending.
// Return codes:
//  1 - Changes are pending
//	 2 - No changes are pending
//  3 - AcceptText () failed and user wants to cancel update

Integer i_return_code


// If no reason message is supplied, set up a default one.

IF Len (Trim (i_s_reason_msg)) = 0 THEN
	i_s_reason_msg = "Proceed anyway?"
END IF


// Do the AcceptText.  If it fails, there's something wrong with the
// text (e.g., failed a validation test.  If so, ask the user what
// to do (e.g., "Close anyway?", "Open anyway", or "Proceed anyway?").

IF NOT dw_mas.fu_accepttext () THEN
	i_return_code = g_nv_msg_mgr.fnv_process_msg("pt", i_s_reason_msg, "", "", 0, 0)
	IF i_return_code = 2 THEN
		message.doubleparm = 3
		RETURN
	END IF
	message.doubleparm = 2
	RETURN
END IF


// Return 1 if any changes are pending.

IF dw_mas.fu_changed () THEN
	message.doubleparm = 1
ELSE
	message.doubleparm = 2
END IF
end on

on open;call w_a_udim::open;dw_mas.SetTransObject (i_tr_sql)

dw_mas.fu_set_error_title (this.title)
dw_mas.fu_append (dw_1)
end on

on ue_fileopen;call w_a_udim::ue_fileopen;// If there were changes to save and the user canceled, then return

IF i_b_canceled THEN
	RETURN
END IF

end on

on ue_save;// Override!

// Trigger the pre-save event.  If message.returnvalue is negative
// the save is abandoned.

this.TriggerEvent ("ue_presave")

IF message.returnvalue < 0 THEN
	i_b_update_status = FALSE
	RETURN
END IF


// Call Datawindow function to Update and Commit if successful

i_b_update_status = dw_mas.fu_update ()
end on

on w_a_mas_det_pt.create
int iCurrent
call w_a_udim::create
this.dw_mas=create dw_mas
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=dw_mas
end on

on w_a_mas_det_pt.destroy
call w_a_udim::destroy
destroy(this.dw_mas)
end on

on ue_new;call w_a_udim::ue_new;// If there were changes to save and the user canceled, then return

IF i_b_canceled THEN
	RETURN
END IF

end on

type dw_1 from w_a_udim`dw_1 within w_a_mas_det_pt
int X=74
int Y=473
int TabOrder=20
end type

type dw_mas from u_dw_udis within w_a_mas_det_pt
int X=74
int Y=33
end type

