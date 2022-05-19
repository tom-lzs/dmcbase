$PBExportHeader$w_import_alerte.srw
$PBExportComments$Permet de saisir l'alerte lors de l'import d'un fichier client
forward
global type w_import_alerte from w_a
end type
type st_1 from statictext within w_import_alerte
end type
type sle_alerte from u_slea within w_import_alerte
end type
type dw_1 from datawindow within w_import_alerte
end type
type cb_2 from u_cba within w_import_alerte
end type
type cb_1 from u_cba within w_import_alerte
end type
end forward

global type w_import_alerte from w_a
integer x = 769
integer y = 461
integer width = 2565
integer height = 1108
string title = "Gestion du texte d~'alerte"
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
long backcolor = 12632256
st_1 st_1
sle_alerte sle_alerte
dw_1 dw_1
cb_2 cb_2
cb_1 cb_1
end type
global w_import_alerte w_import_alerte

event ue_ok;call super::ue_ok;/* <DESC>
     Permet la validation de la saisie de l'article et quitter la fenetre en passant l'article saisi
   </DESC> */

If len(sle_alerte.Text) = 0 then
  	messagebox("Selection","Veuillez spécifier un texte d'alerte ",StopSign!,Ok!,0)
	Return
End if
//
i_str_pass.s[01]	=	sle_alerte.text
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

on w_import_alerte.create
int iCurrent
call super::create
this.st_1=create st_1
this.sle_alerte=create sle_alerte
this.dw_1=create dw_1
this.cb_2=create cb_2
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.sle_alerte
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.cb_1
end on

on w_import_alerte.destroy
call super::destroy
destroy(this.st_1)
destroy(this.sle_alerte)
destroy(this.dw_1)
destroy(this.cb_2)
destroy(this.cb_1)
end on

event ue_init;call super::ue_init;dw_1.setTrans(i_tr_sql)
dw_1.retrieve()



end event

type st_1 from statictext within w_import_alerte
integer x = 544
integer y = 560
integer width = 1147
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Alerte sélectionnée"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_alerte from u_slea within w_import_alerte
integer x = 160
integer y = 620
integer width = 1897
integer height = 96
integer taborder = 20
string facename = "Arial"
integer limit = 50
end type

type dw_1 from datawindow within w_import_alerte
integer x = 142
integer y = 64
integer width = 1842
integer height = 400
integer taborder = 10
string title = "none"
string dataobject = "d_liste_alerte"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;sle_alerte.text = getitemString(getRow(),1)
end event

type cb_2 from u_cba within w_import_alerte
integer x = 1065
integer y = 828
integer width = 352
integer height = 96
integer taborder = 20
string text = "Fermer"
end type

event constructor;call super::constructor;i_s_event = "ue_cancel"
end event

type cb_1 from u_cba within w_import_alerte
integer x = 585
integer y = 828
integer width = 352
integer height = 96
integer taborder = 20
string text = "OK"
end type

event constructor;call super::constructor;i_s_event = "ue_ok"
end event

