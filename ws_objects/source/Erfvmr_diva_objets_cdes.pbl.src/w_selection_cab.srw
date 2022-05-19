$PBExportHeader$w_selection_cab.srw
forward
global type w_selection_cab from w_a_liste
end type
end forward

global type w_selection_cab from w_a_liste
string tag = "SELECTION_REFERENCE"
integer width = 2912
integer height = 1324
string title = "Selectionner la référence"
end type
global w_selection_cab w_selection_cab

event ue_init;if dw_1.Retrieve(i_str_pass.s[1]) = -1 then
 	f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
end if

dw_1.setfocus()
end event

on w_selection_cab.create
call super::create
end on

on w_selection_cab.destroy
call super::destroy
end on

type uo_statusbar from w_a_liste`uo_statusbar within w_selection_cab
integer x = 9
integer y = 104
end type

type cb_cancel from w_a_liste`cb_cancel within w_selection_cab
end type

type cb_ok from w_a_liste`cb_ok within w_selection_cab
integer x = 128
integer y = 772
end type

type dw_1 from w_a_liste`dw_1 within w_selection_cab
integer width = 2702
integer height = 840
string dataobject = "d_recherche_cab"
end type

type pb_ok from w_a_liste`pb_ok within w_selection_cab
integer x = 782
integer y = 924
string picturename = "c:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_echap from w_a_liste`pb_echap within w_selection_cab
integer x = 1728
integer y = 924
string picturename = "c:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

