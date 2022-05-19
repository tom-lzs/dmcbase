$PBExportHeader$u_dw_udis_pt.sru
$PBExportComments$Contrôle DataWindow pour les mises à jour mono-ligne
forward
global type u_dw_udis_pt from u_dw_udim
end type
end forward

global type u_dw_udis_pt from u_dw_udim
end type
global u_dw_udis_pt u_dw_udis_pt

forward prototypes
public function boolean fu_delete (long a_l_row_num)
public function long fu_insert (long a_l_row_num)
end prototypes

public function boolean fu_delete (long a_l_row_num);// Delete single record and update to database (argument l_row_num
// is ignored).


// Trigger the pre-delete event.  If message.returnvalue is negative
// the delete is abandoned.

this.TriggerEvent ("ue_predelete")

IF message.returnvalue < 0 THEN
	this.SetFocus ()
	RETURN FALSE
END IF


// Delete the record and invoke update.

this.DeleteRow (0)

IF NOT this.fu_update () THEN
	this.SetFocus ()
	RETURN FALSE
END IF


// Trigger the post-delete event, insert new row and set focus to
// this DataWindow.

this.TriggerEvent ("ue_postdelete")

this.SetFocus ()

RETURN TRUE
end function

public function long fu_insert (long a_l_row_num);// Reset datawindow and insert single row.  The function will return
// 1 if successful, -1 otherwise.


// Trigger the pre-insert event.  If message.returnvalue is negative
// the insert is abandoned.

this.TriggerEvent ("ue_preinsert")

IF message.returnvalue < 0 THEN
	this.SetFocus ()
	RETURN -1
END IF


// Reset datawindow.

this.SetRedraw (FALSE)

this.Reset ()


// Insert row - argument a_l_row_num ignored.

a_l_row_num = this.InsertRow (1)


// Trigger the post-insert event and set focus back to the DataWindow.

this.TriggerEvent ("ue_postinsert")

this.SetFocus ()

this.SetRedraw (TRUE)

RETURN 1
end function

on constructor;call u_dw_udim::constructor;// By default the delete confirmation message will display

fu_set_confirm_delete (TRUE)
end on

