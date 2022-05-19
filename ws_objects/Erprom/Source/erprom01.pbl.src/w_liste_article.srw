$PBExportHeader$w_liste_article.srw
forward
global type w_liste_article from w_a_pick_one
end type
end forward

global type w_liste_article from w_a_pick_one
integer width = 2011
integer height = 1580
long backcolor = 12632256
end type
global w_liste_article w_liste_article

on w_liste_article.create
call super::create
end on

on w_liste_article.destroy
call super::destroy
end on

event ue_init;call super::ue_init;if dw_1.retrieve() = -1 then
	f_dmc_error (this.title +  BLANK + "Erreur recherche liste article")
end if

end event

event ue_ok;call super::ue_ok;dw_1.fu_set_selection_mode (1)

if dw_1.RowCount() = 0 then
	return
end if

long l_row 
l_row = dw_1.GetRow ()
IF l_row = 0 THEN
	messagebox (This.title,"Sélectionner une ligne", Information!,Ok!,1)
	RETURN
end if

i_str_pass.s[1] = dw_1.getItemString(l_row, DBNAME_ARTICLE)
i_str_pass.s_action = ACTION_OK
Message.fnv_set_str_pass(i_str_pass)
Close (This)
end event

event ue_cancel;call super::ue_cancel;i_str_pass.s_action = ACTION_CANCEL
Message.fnv_set_str_pass(i_str_pass)
Close (This)
end event

type cb_cancel from w_a_pick_one`cb_cancel within w_liste_article
integer x = 1074
integer y = 1304
end type

type cb_ok from w_a_pick_one`cb_ok within w_liste_article
integer x = 654
integer y = 1304
end type

type dw_1 from w_a_pick_one`dw_1 within w_liste_article
integer width = 1787
integer height = 1200
string dataobject = "d_liste_article"
end type

