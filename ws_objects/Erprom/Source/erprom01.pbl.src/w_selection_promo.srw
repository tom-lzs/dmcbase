$PBExportHeader$w_selection_promo.srw
$PBExportComments$Fenetre de saisie des critères de sélection pour affichage de la liste des promotions
forward
global type w_selection_promo from w_a
end type
type st_promo from statictext within w_selection_promo
end type
type st_periode from statictext within w_selection_promo
end type
type st_1 from statictext within w_selection_promo
end type
type st_motcle from statictext within w_selection_promo
end type
type sle_promo from u_slea within w_selection_promo
end type
type em_periodedu from u_ema within w_selection_promo
end type
type em_periodeau from u_ema within w_selection_promo
end type
type sle_motcle from u_slea within w_selection_promo
end type
type cb_1 from u_cb_ok within w_selection_promo
end type
type cb_2 from u_cb_close within w_selection_promo
end type
type gb_1 from groupbox within w_selection_promo
end type
end forward

global type w_selection_promo from w_a
integer x = 769
integer y = 461
integer width = 1856
integer height = 852
string title = "Sélection des Promotions"
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
long backcolor = 12632256
st_promo st_promo
st_periode st_periode
st_1 st_1
st_motcle st_motcle
sle_promo sle_promo
em_periodedu em_periodedu
em_periodeau em_periodeau
sle_motcle sle_motcle
cb_1 cb_1
cb_2 cb_2
gb_1 gb_1
end type
global w_selection_promo w_selection_promo

type variables

end variables

event ue_ok;/* **************************************************
	 Objectif :
	 ----------
		Controler la saisie des parametres
		et affichage de la liste des promotions 

	Principe:
	----------

		1- Controle qu'un paramètre est renseigné
		2- Controle de la validité des données
		3- Si tout est ok,
				On retourne à l'affichage des promotions correspondantes
				à la sélection
	*****************************************************  */
Date		d_debut,		&
			d_fin
String	s_promo,		&
			s_motcle


s_promo		=	Trim(sle_promo.text)
d_debut		=	date(em_periodedu.text)
d_fin			=	date(em_periodeau.text)
s_motcle		=	Trim(sle_motcle.text)

If d_debut > d_fin then
 	MessageBox(title,"Période éronnée",StopSign!,ok!,0)
	Return
End if

If string(d_fin)	 =	DATE_SYBASE_MINI then
	d_fin	=	Date(DATE_SYBASE_MAX)
End if

I_str_pass.s[3]		=	s_promo
i_str_pass.s[4]		=	s_motcle
i_str_pass.dates[1]	=	d_debut
i_str_pass.dates[2]	=	d_fin

i_str_pass.s_action	=	ACTION_OK
Message.fnv_set_str_pass(i_str_pass)
Close (This)
end event

event ue_close;call super::ue_close;i_str_pass.s_action = ACTION_CANCEL
Message.fnv_set_str_pass(i_str_pass)
Close (This)
end event

on w_selection_promo.create
int iCurrent
call super::create
this.st_promo=create st_promo
this.st_periode=create st_periode
this.st_1=create st_1
this.st_motcle=create st_motcle
this.sle_promo=create sle_promo
this.em_periodedu=create em_periodedu
this.em_periodeau=create em_periodeau
this.sle_motcle=create sle_motcle
this.cb_1=create cb_1
this.cb_2=create cb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_promo
this.Control[iCurrent+2]=this.st_periode
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_motcle
this.Control[iCurrent+5]=this.sle_promo
this.Control[iCurrent+6]=this.em_periodedu
this.Control[iCurrent+7]=this.em_periodeau
this.Control[iCurrent+8]=this.sle_motcle
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.cb_2
this.Control[iCurrent+11]=this.gb_1
end on

on w_selection_promo.destroy
call super::destroy
destroy(this.st_promo)
destroy(this.st_periode)
destroy(this.st_1)
destroy(this.st_motcle)
destroy(this.sle_promo)
destroy(this.em_periodedu)
destroy(this.em_periodeau)
destroy(this.sle_motcle)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.gb_1)
end on

event ue_cancel;call super::ue_cancel;i_str_pass.s_action = ACTION_CANCEL
Message.fnv_set_str_pass(i_str_pass)
Close (This)
end event

type st_promo from statictext within w_selection_promo
integer x = 128
integer y = 108
integer width = 357
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
string text = "Promotion :"
boolean focusrectangle = false
end type

type st_periode from statictext within w_selection_promo
integer x = 128
integer y = 240
integer width = 494
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
string text = "Période :      Du "
boolean focusrectangle = false
end type

type st_1 from statictext within w_selection_promo
integer x = 1074
integer y = 240
integer width = 128
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
string text = "Au"
boolean focusrectangle = false
end type

type st_motcle from statictext within w_selection_promo
integer x = 128
integer y = 384
integer width = 283
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
string text = "Mot clé :  "
boolean focusrectangle = false
end type

type sle_promo from u_slea within w_selection_promo
integer x = 695
integer y = 92
integer width = 690
integer height = 96
integer taborder = 10
integer limit = 4
end type

type em_periodedu from u_ema within w_selection_promo
integer x = 695
integer y = 232
integer width = 352
integer height = 80
integer taborder = 20
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

type em_periodeau from u_ema within w_selection_promo
integer x = 1234
integer y = 232
integer width = 357
integer height = 80
integer taborder = 30
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

type sle_motcle from u_slea within w_selection_promo
integer x = 695
integer y = 376
integer width = 978
integer height = 96
integer taborder = 40
integer limit = 44
end type

type cb_1 from u_cb_ok within w_selection_promo
integer x = 361
integer y = 608
integer width = 352
integer height = 96
integer taborder = 70
integer textsize = -8
fontcharset fontcharset = ansi!
string facename = "MS Sans Serif"
string text = "&OK"
end type

type cb_2 from u_cb_close within w_selection_promo
integer x = 1042
integer y = 608
integer width = 352
integer height = 96
integer taborder = 80
integer textsize = -8
fontcharset fontcharset = ansi!
string facename = "MS Sans Serif"
boolean cancel = true
end type

type gb_1 from groupbox within w_selection_promo
integer x = 64
integer y = 48
integer width = 1696
integer height = 512
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
borderstyle borderstyle = styleraised!
end type

