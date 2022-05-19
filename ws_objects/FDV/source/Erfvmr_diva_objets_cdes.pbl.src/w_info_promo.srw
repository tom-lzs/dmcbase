$PBExportHeader$w_info_promo.srw
$PBExportComments$Visualisation d'une promotion pour validation de la sélection et permettre la saisie des lignes de commande
forward
global type w_info_promo from w_a_mas_det
end type
type npraeact_t from statictext within w_info_promo
end type
type sle_promo from singlelineedit within w_info_promo
end type
type pb_ok from u_pba_ok within w_info_promo
end type
type pb_echap from u_pba_echap within w_info_promo
end type
type dw_ref_offerte from u_dw_udim within w_info_promo
end type
type pb_changer from u_pba_chge_sel within w_info_promo
end type
end forward

global type w_info_promo from w_a_mas_det
string tag = "INFO_PROMO"
integer x = 0
integer y = 0
integer width = 3630
integer height = 1532
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = child!
windowstate windowstate = maximized!
long backcolor = 12632256
boolean ib_statusbar_visible = true
event ue_changer pbm_custom41
npraeact_t npraeact_t
sle_promo sle_promo
pb_ok pb_ok
pb_echap pb_echap
dw_ref_offerte dw_ref_offerte
pb_changer pb_changer
end type
global w_info_promo w_info_promo

type variables

// Code de la promotion
String		i_s_promo
Date           i_d_lancement

nv_commande_object 	i_nv_commande_object
nv_ligne_cde_object 		i_nv_ligne_cde_object
nv_client_object				i_nv_client_object
end variables

event ue_changer;/* <DESC>
      Permet d'afficher le détail de la promotion qui a été selectionnée.
	<LI> Affichage de la fenêtre de sélection
	<LI> A Partir de la promotion sélectionnée, extraction et affichage des données
	de la promotion.
   </DESC> */
str_pass l_str_work

l_str_work.s[1] = i_nv_client_object.fu_get_code_marche() 
OpenwithParm (w_sel_promo, l_str_work)

l_str_work = Message.fnv_get_str_pass()
Message.fnv_clear_str_pass()

if l_str_work.s_action = ACTION_CANCEL then
	if dw_1.RowCount() = 0 then
		This.TriggerEvent ("ue_cancel")
	else
		dw_1.setFocus()
	end if
	return
end if

// Informations concernant la promotion
if dw_mas.retrieve(l_str_work.s[1]) = -1 then
 	f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
end if
// Chargement des références gratuites
if dw_1.retrieve(l_str_work.s[1], "%") = -1 then
 	f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
end if
// Chargement des références offertes
if dw_ref_offerte.retrieve(l_str_work.s[1]) = -1 then
 	f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
end if

// Mise à jour des zones de texte
sle_promo.Text		= l_str_work.s[2]
i_s_promo			= l_str_work.s[1] 
i_d_lancement        = l_str_work.dates[1]

end event

event ue_init;call super::ue_init;/* <DESC>
     Permet l'initialisation de l'affichage de la fenêtre.
	  <LI> Controle de l'identification du client
	  <LI> Affichage de la fenêtre de sélection des promotions
   </DESC> */
// DECLARATION DES VARIABLES LOCALES
Long			l_retrieve
Str_pass		str_work

// SELECTION DU CLIENT
i_str_pass = g_nv_workflow_manager.fu_ident_client(true, i_str_pass)
if  i_str_pass.s_action = ACTION_CANCEL then
	Close(this)
	RETURN
end if

i_nv_client_object  = Create nv_client_object 
i_nv_client_object.fu_retrieve_client( i_str_pass.s[1])
dw_ref_offerte.SetTransObject (i_tr_sql)
triggerEvent("ue_changer")

end event

event ue_cancel;/* <DESC>
     Permet de quitter la validation de la sélection en retournant sur la saisie normale
	  des lignes de commande
   </DESC> */
i_b_canceled = TRUE
i_str_pass.s_action = ACTION_OK
g_w_frame.fw_open_sheet(FENETRE_LIGNE_CDE, 0, 1, i_str_pass)
Close(this)
end event

event ue_ok;/* <DESC>
       Permet de valider la promotion et d'aller en saisie de lignes de commande
 	  cette promotion.
    </DESC> */
// -------------------------------
// SAISIE DES LIGNES EN PROMOTION
// -------------------------------
i_str_pass.s[3]  = i_s_promo
i_str_pass.s[4] = sle_promo.Text
i_str_pass.dates[3] = i_d_lancement
i_str_pass.s_action = ACTION_OK
g_w_frame.fw_open_sheet(FENETRE_CDE_PROMO,0,1,i_str_pass)
close(this)
end event

event key;call super::key;/* <DESC>
      Permet de trapper les touches de fonction activées et déclencher l'évènement associé
	à la touche.
	  F11 = Validation de la sélection
   </DESC> */
	IF KeyDown (KeyF11!) THEN
		This.TriggerEvent ("ue_ok")
	END IF
end event

on w_info_promo.create
int iCurrent
call super::create
this.npraeact_t=create npraeact_t
this.sle_promo=create sle_promo
this.pb_ok=create pb_ok
this.pb_echap=create pb_echap
this.dw_ref_offerte=create dw_ref_offerte
this.pb_changer=create pb_changer
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.npraeact_t
this.Control[iCurrent+2]=this.sle_promo
this.Control[iCurrent+3]=this.pb_ok
this.Control[iCurrent+4]=this.pb_echap
this.Control[iCurrent+5]=this.dw_ref_offerte
this.Control[iCurrent+6]=this.pb_changer
end on

on w_info_promo.destroy
call super::destroy
destroy(this.npraeact_t)
destroy(this.sle_promo)
destroy(this.pb_ok)
destroy(this.pb_echap)
destroy(this.dw_ref_offerte)
destroy(this.pb_changer)
end on

type uo_statusbar from w_a_mas_det`uo_statusbar within w_info_promo
end type

type dw_1 from w_a_mas_det`dw_1 within w_info_promo
string tag = "A_TRADUIRE"
integer x = 18
integer y = 724
integer width = 1422
integer height = 488
integer taborder = 10
boolean enabled = false
string dataobject = "d_ref_gratuite_promo"
boolean vscrollbar = true
end type

event dw_1::we_dwnkey;call super::we_dwnkey;/* <DESC> 
    Permet d'effectuer le trigger KEY de la fenetre
	 </DESC> */
	f_key(Parent)
end event

event dw_1::losefocus;call super::losefocus;/* <DESC>
      Permet de modifier le cadre de la datawindow afin de visualiser qu'elle est
		n'est plus sélectionnée
   </DESC> */
// PERTE DU FOCUS
	This.BorderStyle = StyleBox!
end event

event dw_1::getfocus;call super::getfocus;/* <DESC>
      Permet de modifier le cadre de la datawindow afin de visualiser qu'elle est
		sélectionnée
   </DESC> */
	This.BorderStyle = StyleLowered!
end event

type dw_mas from w_a_mas_det`dw_mas within w_info_promo
integer x = 146
integer y = 192
integer width = 2491
integer height = 496
integer taborder = 30
string dataobject = "d_condition_promo"
boolean vscrollbar = true
end type

event dw_mas::losefocus;call super::losefocus;/* <DESC>
      Permet de modifier le cadre de la datawindow afin de visualiser qu'elle 
		n'est plus sélectionnée
   </DESC> */
// PERTE DU FOCUS
	This.BorderStyle = StyleBox!
end event

event dw_mas::we_dwnkey;call super::we_dwnkey;/* <DESC> 
    Permet d'effectuer le trigger KEY de la fenetre
	 </DESC> */
	 f_key(Parent)
end event

event dw_mas::getfocus;call super::getfocus;/* <DESC>
      Permet de modifier le cadre de la datawindow afin de visualiser qu'elle est
	 sélectionnée
   </DESC> */
// MISE EN EVIDENCE DU FOCUS
	This.BorderStyle = StyleLowered!
end event

type npraeact_t from statictext within w_info_promo
integer x = 18
integer y = 80
integer width = 443
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
string text = "Promo :"
boolean focusrectangle = false
end type

type sle_promo from singlelineedit within w_info_promo
integer x = 507
integer y = 80
integer width = 1710
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean autohscroll = false
boolean displayonly = true
borderstyle borderstyle = styleshadowbox!
end type

type pb_ok from u_pba_ok within w_info_promo
integer x = 480
integer y = 1280
integer width = 334
integer taborder = 0
string text = "Valid. F11"
boolean default = false
string picturename = "c:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_echap from u_pba_echap within w_info_promo
integer x = 2062
integer y = 1280
integer taborder = 0
string picturename = "c:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type dw_ref_offerte from u_dw_udim within w_info_promo
string tag = "A_TRADUIRE"
integer x = 1499
integer y = 720
integer width = 1431
integer height = 488
integer taborder = 20
boolean enabled = false
string dataobject = "d_ref_offerte_promo"
boolean vscrollbar = true
end type

event we_dwnkey;call super::we_dwnkey;/* <DESC> 
    Permet d'effectuer le trigger KEY de la fenetre
	 </DESC> */
	 f_key(Parent)
end event

event losefocus;call super::losefocus;/* <DESC>
      Permet de modifier le cadre de la datawindow afin de visualiser qu'elle n'est
		plus sélectionnée
   </DESC> */
// PERTE DU FOCUS
	This.BorderStyle = StyleBox!
end event

event getfocus;call super::getfocus;/* <DESC>
      Permet de modifier le cadre de la datawindow afin de visualiser qu'elle est
		sélectionnée
   </DESC> */
// MISE EN EVIDENCE DU FOCUS
	This.BorderStyle = StyleLowered!
end event

type pb_changer from u_pba_chge_sel within w_info_promo
integer x = 1216
integer y = 1280
integer taborder = 0
string picturename = "c:\appscir\Erfvmr_diva\Image\pb_chgmt.bmp"
end type

