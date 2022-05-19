$PBExportHeader$w_select_article.srw
$PBExportComments$Permet la recherche d'un article
forward
global type w_select_article from w_a
end type
type cb_2 from u_cba within w_select_article
end type
type cb_1 from u_cba within w_select_article
end type
type sle_1 from u_slea within w_select_article
end type
type st_1 from statictext within w_select_article
end type
type gb_1 from groupbox within w_select_article
end type
end forward

global type w_select_article from w_a
integer width = 1449
integer height = 548
string title = "Selection Article "
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
long backcolor = 12632256
cb_2 cb_2
cb_1 cb_1
sle_1 sle_1
st_1 st_1
gb_1 gb_1
end type
global w_select_article w_select_article

event ue_ok;call super::ue_ok;/* <DESC>
     Permet la validation de la saisie de l'article et quitter la fenetre en passant l'article saisi
   </DESC> */

If len(sle_1.Text) = 0 then
  	messagebox("Selection","Veuillez saisir un article de recherche",StopSign!,Ok!,0)
	Return
End if

i_str_pass.s[01]	=	sle_1.text
i_str_pass.s_action = ACTION_OK
Message.fnv_set_str_pass(i_str_pass)
Close (this)
end event

event ue_cancel;call super::ue_cancel;/* <DESC> 
     Permet de quitter la fenetre sans effectuer de selection
   </DESC> */
	i_str_pass.s_action = ACTION_CANCEL
	Message.fnv_set_str_pass(i_str_pass)
	Close (this)

end event

on w_select_article.create
int iCurrent
call super::create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.sle_1=create sle_1
this.st_1=create st_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.sle_1
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.gb_1
end on

on w_select_article.destroy
call super::destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.sle_1)
destroy(this.st_1)
destroy(this.gb_1)
end on

type cb_2 from u_cba within w_select_article
integer x = 741
integer y = 316
integer width = 352
integer height = 96
integer taborder = 20
string text = "Fermer"
end type

event constructor;call super::constructor;i_s_event = "ue_cancel"
end event

type cb_1 from u_cba within w_select_article
integer x = 261
integer y = 316
integer width = 352
integer height = 96
integer taborder = 20
string text = "OK"
end type

event constructor;call super::constructor;i_s_event = "ue_ok"
end event

type sle_1 from u_slea within w_select_article
integer x = 507
integer y = 132
integer width = 750
integer height = 76
integer taborder = 10
textcase textcase = upper!
integer limit = 18
end type

type st_1 from statictext within w_select_article
integer x = 105
integer y = 132
integer width = 320
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Article : "
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_select_article
integer x = 101
integer y = 60
integer width = 1234
integer height = 184
integer textsize = -13
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
end type

