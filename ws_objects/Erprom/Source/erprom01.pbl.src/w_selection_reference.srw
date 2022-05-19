$PBExportHeader$w_selection_reference.srw
forward
global type w_selection_reference from w_a
end type
type cb_2 from u_cb_ok within w_selection_reference
end type
type cb_1 from u_cb_cancel within w_selection_reference
end type
type cb_ok from u_cb_ok within w_selection_reference
end type
type cb_cancel from u_cb_cancel within w_selection_reference
end type
type sle_ref from u_slea within w_selection_reference
end type
type st_3 from statictext within w_selection_reference
end type
type sle_dimension from u_slea within w_selection_reference
end type
type st_2 from statictext within w_selection_reference
end type
type sle_article from u_slea within w_selection_reference
end type
type st_1 from statictext within w_selection_reference
end type
end forward

global type w_selection_reference from w_a
integer x = 769
integer y = 461
integer width = 1687
integer height = 888
string title = "Sélection référence"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
long backcolor = 12632256
cb_2 cb_2
cb_1 cb_1
cb_ok cb_ok
cb_cancel cb_cancel
sle_ref sle_ref
st_3 st_3
sle_dimension sle_dimension
st_2 st_2
sle_article sle_article
st_1 st_1
end type
global w_selection_reference w_selection_reference

on w_selection_reference.create
int iCurrent
call super::create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.sle_ref=create sle_ref
this.st_3=create st_3
this.sle_dimension=create sle_dimension
this.st_2=create st_2
this.sle_article=create sle_article
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.cb_ok
this.Control[iCurrent+4]=this.cb_cancel
this.Control[iCurrent+5]=this.sle_ref
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.sle_dimension
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.sle_article
this.Control[iCurrent+10]=this.st_1
end on

on w_selection_reference.destroy
call super::destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.sle_ref)
destroy(this.st_3)
destroy(this.sle_dimension)
destroy(this.st_2)
destroy(this.sle_article)
destroy(this.st_1)
end on

event ue_ok;call super::ue_ok;
// ----------------------------------------
// AU MOINS UN CRITERE DOIT ETRE RENSEIGNE
// ----------------------------------------

IF		Trim (sle_article.Text)		= "" &
AND	Trim (sle_dimension.Text) 	= "" &
AND 	Trim (sle_ref.Text)			= "" THEN
	messagebox (This.title,"RENSEIGNEZ AU MOINS UN CRITERE" + "~r" + "   PUIS VALIDEZ, MERCI !!!",  & 
						Information!,Ok!,1)
	sle_article.SetFocus()
	RETURN
end if

i_str_pass.s[1] = sle_article.Text
i_str_pass.s[2] = sle_dimension.Text
i_str_pass.s[3] = sle_ref.Text
i_str_pass.s_action = ACTION_OK
Message.fnv_set_str_pass(i_str_pass)
Close (This)

end event

event ue_cancel;call super::ue_cancel;i_str_pass.s_action = ACTION_CANCEL
Message.fnv_set_str_pass(i_str_pass)
Close (This)
end event

type cb_2 from u_cb_ok within w_selection_reference
integer x = 370
integer y = 604
integer width = 352
integer height = 96
integer taborder = 40
end type

type cb_1 from u_cb_cancel within w_selection_reference
integer x = 791
integer y = 604
integer width = 352
integer height = 96
integer taborder = 40
end type

type cb_ok from u_cb_ok within w_selection_reference
integer x = 654
integer y = 1320
integer width = 352
integer height = 96
integer taborder = 40
end type

type cb_cancel from u_cb_cancel within w_selection_reference
integer x = 1074
integer y = 1320
integer width = 352
integer height = 96
integer taborder = 40
end type

type sle_ref from u_slea within w_selection_reference
integer x = 553
integer y = 392
integer width = 887
integer height = 72
integer taborder = 30
textcase textcase = upper!
integer limit = 8
end type

type st_3 from statictext within w_selection_reference
integer x = 123
integer y = 392
integer width = 402
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Mot Clé :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_dimension from u_slea within w_selection_reference
integer x = 553
integer y = 264
integer width = 489
integer height = 72
integer taborder = 20
textcase textcase = upper!
integer limit = 8
end type

type st_2 from statictext within w_selection_reference
integer x = 123
integer y = 272
integer width = 402
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Dimension :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_article from u_slea within w_selection_reference
integer x = 553
integer y = 140
integer width = 841
integer height = 72
integer taborder = 10
textcase textcase = upper!
integer limit = 18
end type

type st_1 from statictext within w_selection_reference
integer x = 123
integer y = 148
integer width = 402
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Article :"
alignment alignment = right!
boolean focusrectangle = false
end type

