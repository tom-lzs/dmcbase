$PBExportHeader$w_liste_promo.srw
$PBExportComments$Fenetre d'affichage de la liste des promotions en fonction des critères de sélection
forward
global type w_liste_promo from w_a_pick_one
end type
type cb_changer from u_cba within w_liste_promo
end type
end forward

global type w_liste_promo from w_a_pick_one
integer x = 5
integer y = 344
integer width = 2638
integer height = 1472
string title = "Liste des Promotions"
long backcolor = 12632256
event ue_selection pbm_custom51
cb_changer cb_changer
end type
global w_liste_promo w_liste_promo

type variables
String		i_s_appel_selection
end variables

event ue_selection;/* ******************************************
		Appel de la fenetre de selection des
		critères d'extraction des promotions
	****************************************** */
OpenWithParm (w_selection_promo, i_str_pass)

i_str_pass = Message.fnv_get_str_pass()
Message.fnv_clear_str_pass()

If i_str_pass.s_action = ACTION_CANCEL	then
	Message.fnv_set_str_pass(i_str_pass)
	Close (This)
	return
ELSE
	TriggerEvent("ue_retrieve")
END IF
end event

event ue_ok;call super::ue_ok;Datetime	dt_serveur

i_str_pass.s[01]	=	dw_1.GetItemString(dw_1.GetRow(),"npraeact")

dt_serveur	=	sqlca.fnv_get_datetime()

Message.fnv_set_str_pass(i_str_pass)
Close (This)
end event

event ue_retrieve;/* *********************************************
	Objectif :
   ----------
		Affichage de la liste des promotions pour les
		paramètres sélectionnés

	********************************************  */
String	s_promo,			&
			s_motcle
Date		d_debut,			&
			d_fin


s_promo	=	i_str_pass.s[03]	+ SYBASE_JOKER
s_motcle	=	SYBASE_JOKER + i_str_pass.s[04] + SYBASE_JOKER
d_debut	=	i_str_pass.Dates[01]
d_fin		=	i_str_pass.Dates[02]

dw_1.SetTransObject	(sqlca)
dw_1.Retrieve (s_promo,s_motcle,d_debut,d_fin)

If dw_1.RowCount() = 0 then
   cb_ok.visible = False
Else
   cb_ok.visible = True
End if
end event

event ue_init;	TriggerEvent("ue_selection")

end event

event ue_cancel;call super::ue_cancel;Message.fnv_set_str_pass(i_str_pass)
Close (This)
end event

on w_liste_promo.create
int iCurrent
call super::create
this.cb_changer=create cb_changer
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_changer
end on

on w_liste_promo.destroy
call super::destroy
destroy(this.cb_changer)
end on

event close;call super::close;i_str_pass.s_action = "cancel"
end event

type cb_cancel from w_a_pick_one`cb_cancel within w_liste_promo
integer x = 1152
integer y = 1260
integer width = 416
integer textsize = -8
fontcharset fontcharset = ansi!
string facename = "MS Sans Serif"
string text = "&Annuler"
end type

type cb_ok from w_a_pick_one`cb_ok within w_liste_promo
integer x = 485
integer y = 1260
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
string facename = "MS Sans Serif"
string text = "&OK"
end type

type dw_1 from w_a_pick_one`dw_1 within w_liste_promo
integer width = 2455
integer height = 1168
string dataobject = "d_liste_promotion"
end type

type cb_changer from u_cba within w_liste_promo
integer x = 1874
integer y = 1260
integer width = 571
integer height = 96
integer taborder = 40
integer textsize = -8
fontcharset fontcharset = ansi!
string facename = "MS Sans Serif"
string text = "&Changer sélection"
end type

on clicked;i_s_appel_selection	=	"changer"
Parent.TriggerEvent("ue_selection")
end on

on constructor;call u_cba::constructor;i_s_event = "ue_selection"
end on

