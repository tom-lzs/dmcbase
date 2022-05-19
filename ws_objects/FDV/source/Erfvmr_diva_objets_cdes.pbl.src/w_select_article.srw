$PBExportHeader$w_select_article.srw
$PBExportComments$Saisie de l'article à recherche dans les lignes de commande
forward
global type w_select_article from w_a
end type
type sle_1 from u_slea within w_select_article
end type
type artae000_t from statictext within w_select_article
end type
type gb_1 from groupbox within w_select_article
end type
type pb_ok from u_pba_ok within w_select_article
end type
type pb_echap from u_pba_echap within w_select_article
end type
end forward

global type w_select_article from w_a
string tag = "SELECTION_ARTICLE"
integer width = 1449
integer height = 548
string title = "Selection Article "
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
long backcolor = 12632256
sle_1 sle_1
artae000_t artae000_t
gb_1 gb_1
pb_ok pb_ok
pb_echap pb_echap
end type
global w_select_article w_select_article

event ue_ok;call super::ue_ok;/* <DESC>
      Permet de valider la saisie d'un article et fermer la fenêtre en passant
		l'article .
   </DESC> */
/*  *********************************************
         Validation saisie du code article
    ********************************************* */

If len(sle_1.Text) = 0 then
  	messagebox("Selection",g_nv_traduction.get_traduction(SAISIR_ARTICLE),StopSign!,Ok!,0)
	Return
End if

i_str_pass.s[01]	=	sle_1.text
i_str_pass.s_action = ACTION_OK
Message.fnv_set_str_pass(i_str_pass)
Close (this)
end event

event ue_cancel;call super::ue_cancel;/* <DESC> 
    Permet de fermer la fenêtre sans saisie d'un article.
   </DESC> */
	i_str_pass.s_action = ACTION_CANCEL
	Message.fnv_set_str_pass(i_str_pass)
	Close (this)

end event

on w_select_article.create
int iCurrent
call super::create
this.sle_1=create sle_1
this.artae000_t=create artae000_t
this.gb_1=create gb_1
this.pb_ok=create pb_ok
this.pb_echap=create pb_echap
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_1
this.Control[iCurrent+2]=this.artae000_t
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.pb_ok
this.Control[iCurrent+5]=this.pb_echap
end on

on w_select_article.destroy
call super::destroy
destroy(this.sle_1)
destroy(this.artae000_t)
destroy(this.gb_1)
destroy(this.pb_ok)
destroy(this.pb_echap)
end on

event key;call super::key;/* <DESC>
      Permet de trapper les touches de fonction activées et déclencher l'évènement associé
	à la touche.
	  F11 = validation de la sélection
   </DESC> */
	IF KeyDown (KeyF11!) THEN
		This.PostEvent ("ue_ok")
	END IF
end event

type uo_statusbar from w_a`uo_statusbar within w_select_article
end type

type sle_1 from u_slea within w_select_article
integer x = 507
integer y = 132
integer width = 750
integer height = 76
integer taborder = 10
textcase textcase = upper!
integer limit = 18
end type

type artae000_t from statictext within w_select_article
integer x = 73
integer y = 132
integer width = 425
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
string text = "Article  "
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_select_article
string tag = "NO_TEXT"
integer x = 59
integer y = 60
integer width = 1275
integer height = 184
integer textsize = -13
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
end type

type pb_ok from u_pba_ok within w_select_article
integer x = 306
integer y = 288
integer width = 297
integer height = 136
integer taborder = 20
string picturename = "c:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_echap from u_pba_echap within w_select_article
integer x = 850
integer y = 288
integer width = 302
integer height = 140
integer taborder = 30
string picturename = "c:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

