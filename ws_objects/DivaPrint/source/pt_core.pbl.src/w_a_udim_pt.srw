$PBExportHeader$w_a_udim_pt.srw
$PBExportComments$[MAIN] Ancêtre des fenêtres de Gestion Multi-lignes
forward
global type w_a_udim_pt from w_a
end type
type dw_1 from u_dw_udim within w_a_udim_pt
end type
end forward

global type w_a_udim_pt from w_a
int Width=965
int Height=609
dw_1 dw_1
end type
global w_a_udim_pt w_a_udim_pt

type variables

end variables

on ue_detect_change;call w_a::ue_detect_change;// Determine whether any changes are pending.
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

IF dw_1.fu_acceptText () = FALSE THEN
	i_return_code = g_nv_msg_mgr.fnv_process_msg ("pt", i_s_reason_msg, "", "", 0, 0)
	IF i_return_code = 2 THEN
		message.doubleparm = 3
		RETURN
	END IF
	message.doubleparm = 2
	RETURN
END IF


// Return 1 if any changes are pending.

IF dw_1.fu_changed () THEN
	message.doubleparm = 1
ELSE
	message.doubleparm = 2
END IF
end on

on ue_save;call w_a::ue_save;// Trigger the pre-save event.  If message.returnvalue is negative
// the save is abandoned.

this.TriggerEvent ("ue_presave")

IF message.returnvalue < 0 THEN
	i_b_update_status = FALSE
	RETURN
END IF


// Call Datawindow function to Update and Commit if successful

i_b_update_status = dw_1.fu_update ()
end on

on ue_print;call w_a::ue_print;// Bail out if AcceptText () fails.

IF dw_1.AcceptText () < 0 THEN
	RETURN
END IF


dw_1.Print()
end on

on ue_printpreview;call w_a::ue_printpreview;// Bail out if AcceptText () fails.

IF dw_1.AcceptText () < 0 THEN
	RETURN
END IF


dw_1.fu_dw_printpreview ()
end on

on open;call w_a::open;IF i_str_pass.s_dataobject <> "" AND Lower (i_str_pass.s_dataobject) <> "x" THEN
	dw_1.dataobject = i_str_pass.s_dataobject
END IF

dw_1.SetTransObject (i_tr_sql)
dw_1.SetRowFocusIndicator (FocusRect!)
dw_1.fu_set_error_title (this.title)

end on

on ue_fileopen;call w_a::ue_fileopen;// Set FALSE if and only if we get all the way through the script.

i_b_canceled = TRUE

IF fw_ask_update ("Open anyway?") = 3 THEN
	RETURN
END IF

i_b_canceled = FALSE
end on

on ue_close;call w_a::ue_close;i_b_canceled = FALSE
Close (this)
end on

on closequery;call w_a::closequery;IF NOT i_b_canceled THEN  // ask to save if not triggered by cancel
	IF fw_ask_update ("Close anyway?") = 3 THEN
		Message.ReturnValue = 1
		return
	END IF
END IF

end on

on w_a_udim_pt.create
int iCurrent
call w_a::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=dw_1
end on

on w_a_udim_pt.destroy
call w_a::destroy
destroy(this.dw_1)
end on

on ue_saveas;call w_a::ue_saveas;dw_1.SaveAs ()
end on

on ue_ok;call w_a::ue_ok;this.TriggerEvent ("ue_save")

IF dw_1.fu_updated () THEN
	Close (this)
END IF
end on

on ue_cancel;call w_a::ue_cancel;i_b_canceled = TRUE
Close (this)
end on

on ue_delete;call w_a::ue_delete;long l_row

l_row = dw_1.GetRow ()

IF l_row > 0 THEN
	dw_1.fu_delete (l_row)
END IF

end on

on ue_insert;call w_a::ue_insert;dw_1.fu_insert (0)


end on

on ue_prior;call w_a::ue_prior;dw_1.ScrollPriorRow ()
end on

on ue_next;call w_a::ue_next;dw_1.ScrollNextRow ()
end on

on ue_new;call w_a::ue_new;// Set FALSE if and only if we get all the way through the script

i_b_canceled = TRUE

IF fw_ask_update ("Open anyway?") = 3 THEN
	RETURN
END IF

i_b_canceled = FALSE

end on

on ue_reserved4powertool;call w_a::ue_reserved4powertool;//
//	Maintenance
//		2/24/95		#17	Added check for AcceptText () as first action
//								in "ue_print" and "ue_printpreview."
end on

type dw_1 from u_dw_udim within w_a_udim_pt
int X=46
int Y=45
end type

