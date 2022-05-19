$PBExportHeader$w_datasource_list_pt.srw
$PBExportComments$Boite de dialogue de sélection des sources de données
forward
global type w_datasource_list_pt from w_a_pick_one
end type
end forward

global type w_datasource_list_pt from w_a_pick_one
int X=993
int Y=533
int Width=1038
int Height=849
boolean TitleBar=true
string Title="Sélection source de donnée"
end type
global w_datasource_list_pt w_datasource_list_pt

type variables

end variables

on open;call w_a_pick_one::open;
// Populate the list of data sources available to be selected.

string	s_datasource_list
integer	i_pos

// Center dialog.

this.fw_center_window ()

// Data source list is in i_str_pass.s [1].

IF UpperBound (i_str_pass.s) < 1 THEN
	this.TriggerEvent ("ue_cancel")
	RETURN
END IF

s_datasource_list = i_str_pass.s [1]

i_str_pass.s [1] = ""

IF Len (Trim (s_datasource_list)) < 1 THEN
	this.TriggerEvent ("ue_close")
	RETURN
END IF

s_datasource_list = "'" + Trim (s_datasource_list) + "'"

// Extract each data source, one at a time, from the datasource list,
// and populate the DataWindow.

i_pos = Pos (s_datasource_list, "'")

DO WHILE i_pos > 0
	s_datasource_list = Mid (s_datasource_list, i_pos + 1)
	i_pos = Pos (s_datasource_list, "'")
	IF i_pos < 1 THEN
		EXIT
	END IF
	dw_1.SetItem (dw_1.InsertRow (0), "s_datasource", &
							Left (s_datasource_list, i_pos - 1))
	s_datasource_list = Mid (s_datasource_list, i_pos + 1)
	i_pos = Pos (s_datasource_list, "'")
LOOP

// Bail out if no rows are available to select.

IF dw_1.RowCount () < 1 THEN
	g_nv_msg_mgr.fnv_process_msg ("pt", "No Datasources", "", "", 0, 0)
	this.TriggerEvent ("ue_cancel")
END IF

dw_1.Sort ()

dw_1.SetFocus ()

dw_1.TriggerEvent (RowFocusChanged!)
end on

on ue_ok;call w_a_pick_one::ue_ok;// Return the selected datasource to the calling Window.

Long l_row_num


l_row_num = dw_1.GetRow ()

IF l_row_num < 1 THEN
	RETURN
END IF

i_str_pass.s [1] = dw_1.GetItemString (l_row_num, "s_datasource")

message.fnv_set_str_pass (i_str_pass)

Close (this)
end on

on ue_cancel;call w_a_pick_one::ue_cancel;// Return i_str_pass to the calling Window.

message.fnv_set_str_pass (i_str_pass)

Close (this)
end on

on w_datasource_list_pt.create
call w_a_pick_one::create
end on

on w_datasource_list_pt.destroy
call w_a_pick_one::destroy
end on

type cb_cancel from w_a_pick_one`cb_cancel within w_datasource_list_pt
int X=545
int Y=609
int Width=366
string Text="&Supprimer"
end type

type cb_ok from w_a_pick_one`cb_ok within w_datasource_list_pt
int Y=609
string Text="&OK"
end type

type dw_1 from w_a_pick_one`dw_1 within w_datasource_list_pt
int X=37
int Width=929
int Height=501
string DataObject="d_datasource_list"
boolean LiveScroll=true
end type

