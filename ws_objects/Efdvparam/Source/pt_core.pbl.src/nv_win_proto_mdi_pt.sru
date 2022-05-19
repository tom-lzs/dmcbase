$PBExportHeader$nv_win_proto_mdi_pt.sru
$PBExportComments$Objet protocole des fenêtres MDI
forward
global type nv_win_proto_mdi_pt from nv_win_proto
end type
end forward

global type nv_win_proto_mdi_pt from nv_win_proto
end type
global nv_win_proto_mdi_pt nv_win_proto_mdi_pt

type variables
PROTECTED:

Integer i_i_win_idx		// Index into frame's sheet manager

end variables

forward prototypes
public function boolean fnv_closing ()
public function boolean fnv_opening (w_a a_window, ref str_pass a_str_pass)
public function integer fnv_get_win_idx ()
public function integer fnv_set_win_idx (integer a_i_idx)
end prototypes

public function boolean fnv_closing ();// Interface with frame sheet manager to clear this sheet.

Integer i_new_count			// Sheet count after close


// Bail out if this object isn't intialized.

IF NOT i_b_init THEN
	RETURN FALSE
END IF


// Decrement number of open sheets, and clear contents of 
// frame's open sheets structure.

i_new_count = g_w_frame.fw_dec_sheet_cnt ()

g_w_frame.fw_set_sheet_key (i_i_win_idx, "")


// If the last sheet has been closed, post the ue_empty event on
// the frame (must be POSTed, not triggered).

IF i_new_count < 1 THEN
	g_w_frame.PostEvent ("ue_empty")
END IF


RETURN TRUE
end function

public function boolean fnv_opening (w_a a_window, ref str_pass a_str_pass);// Make sure Window and str_pass structure are valid.

IF NOT IsValid (a_window) THEN
	i_b_init = FALSE
	RETURN FALSE
END IF

IF NOT IsValid (a_str_pass) THEN
	i_b_init = FALSE
	RETURN FALSE
END IF


// Set index and title.

i_w_win = a_window

i_i_win_idx = a_str_pass.i_idx

g_w_frame.fw_inc_sheet_cnt ()

IF a_str_pass.s_win_title <> "" THEN
	i_w_win.title = a_str_pass.s_win_title
	i_w_win.fw_set_basetitle (i_w_win.title)
END IF

i_b_init = TRUE


RETURN TRUE
end function

public function integer fnv_get_win_idx ();// Return the index into the Frame window manager that describes
// the parent sheet.

IF NOT i_b_init THEN
	RETURN -1
END IF

RETURN i_i_win_idx
end function

public function integer fnv_set_win_idx (integer a_i_idx);// Save the index passed as a parameter and return it.

IF NOT i_b_init THEN
	RETURN -1
END IF

i_i_win_idx = a_i_idx

RETURN i_i_win_idx
end function

on nv_win_proto_mdi_pt.create
TriggerEvent( this, "constructor" )
end on

on nv_win_proto_mdi_pt.destroy
TriggerEvent( this, "destructor" )
end on

