$PBExportHeader$w_detail_cde_promo.srw
$PBExportComments$Permet en fin de saisie de la promotion de spécifier le traitement a effectuer sur les publi promo
forward
global type w_detail_cde_promo from w_a_mas_det
end type
type pb_ok from u_pba_ok within w_detail_cde_promo
end type
type pb_echap from u_pba_echap within w_detail_cde_promo
end type
type nb_publi_promo_t from statictext within w_detail_cde_promo
end type
type pb_annul_promo from u_pba_annul_promo within w_detail_cde_promo
end type
type em_nbr from u_ema within w_detail_cde_promo
end type
end forward

global type w_detail_cde_promo from w_a_mas_det
string tag = "validation_promo"
integer x = 0
integer y = 0
integer width = 2889
integer height = 1192
string title = "*Validation de la promotion*"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
long backcolor = 12632256
event ue_annul_promo pbm_custom41
pb_ok pb_ok
pb_echap pb_echap
nb_publi_promo_t nb_publi_promo_t
pb_annul_promo pb_annul_promo
em_nbr em_nbr
end type
global w_detail_cde_promo w_detail_cde_promo

event ue_annul_promo;/* <DESC>
     Retour à la fenetre de saisie des lignes promotionneles pour suppression
	 de la promotion de la commande
   </DESC> */
i_str_pass.s_action = ACTION_DELETE
Message.fnv_set_str_pass(i_str_pass)
Close (This)
end event

event ue_init;call super::ue_init;/* <DESC>
    Permet l'affichage initiale de la fenetre en effectuant l'extraction des données
	 de la promotion
   </DESC> */
// RETRIEVE DE LA DTW MAÎTRE
if dw_mas.Retrieve(i_str_pass.s[1]) = -1 then
	f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
end if

// RETRIEVE DE LA DTW DETAIL
if dw_1.Retrieve(i_str_pass.s[1]) = -1 then
	f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
end if

dw_1.fu_set_selection_mode(1)
em_nbr.Text = "1"
end event

event ue_close;/* <DESC>
      Fermeture de la fenêtre pour revenir sur la saisie des lignes sans effectuer de
		mise à jour des Publi Promo
    </DESC> */
// OVERRIDE SCRIPT ANCESTOR
	This.TriggerEvent ("ue_cancel")
end event

event open;call super::open;/* <DESC> 
      Permet de positionner la fenêtre sur la fenetre de saisie promo
</DESC> */
	This.X = 10
	This.Y = 400
end event

event ue_ok;/* <DESC>
     Validation de la saisie du nombre de publi promo et retour a la fenetre
	  de saisie des lignes pour intégration ou suppression des publi promo
   </DESC> */
// RENVOIE DES PARAMETRES
i_str_pass.s_action = ACTION_OK
i_str_pass.d[1] = Long(em_nbr.Text)
Message.fnv_set_str_pass(i_str_pass)
Close (This)
end event

event key;call super::key;/* <DESC>
      Permet de trapper les touches de fonction activées et déclencher l'évènement associé
	à la touche.
	  F11 = Validation de la fin de saisie de lignes promotionnelles
   </DESC> */
	IF KeyDown(KeyF11!) THEN 
		This.PostEvent ("ue_ok")
	END IF
end event

on w_detail_cde_promo.create
int iCurrent
call super::create
this.pb_ok=create pb_ok
this.pb_echap=create pb_echap
this.nb_publi_promo_t=create nb_publi_promo_t
this.pb_annul_promo=create pb_annul_promo
this.em_nbr=create em_nbr
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_ok
this.Control[iCurrent+2]=this.pb_echap
this.Control[iCurrent+3]=this.nb_publi_promo_t
this.Control[iCurrent+4]=this.pb_annul_promo
this.Control[iCurrent+5]=this.em_nbr
end on

on w_detail_cde_promo.destroy
call super::destroy
destroy(this.pb_ok)
destroy(this.pb_echap)
destroy(this.nb_publi_promo_t)
destroy(this.pb_annul_promo)
destroy(this.em_nbr)
end on

event ue_cancel;/* <DESC>
      Fermeture de la fenêtre pour revenir sur la saisie des lignes sans effectuer de
		mise à jour des Publi Promo
    </DESC> */
	 // OVERRIDE SCRIPT ANCESTOR
i_str_pass.s_action = ACTION_CANCEL
Message.fnv_set_str_pass(i_str_pass)
CloseWithreturn (This, i_str_pass)
end event

type uo_statusbar from w_a_mas_det`uo_statusbar within w_detail_cde_promo
end type

type dw_1 from w_a_mas_det`dw_1 within w_detail_cde_promo
string tag = "A_TRADUIRE"
integer x = 64
integer width = 1170
integer height = 536
string dataobject = "d_promo_publi"
boolean vscrollbar = true
end type

event dw_1::we_dwnkey;call super::we_dwnkey;
// RENVOIE A L'EVENEMENT KEY DE LA FENÊTRE
//	f_activation_key()
	f_key(Parent)

end event

type dw_mas from w_a_mas_det`dw_mas within w_detail_cde_promo
integer x = 41
integer width = 2469
integer height = 360
integer taborder = 30
string dataobject = "d_condition_promo"
boolean vscrollbar = true
end type

type pb_ok from u_pba_ok within w_detail_cde_promo
integer x = 1353
integer y = 816
integer width = 334
integer taborder = 0
string text = "Valid.  F11"
boolean default = false
string picturename = "c:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_echap from u_pba_echap within w_detail_cde_promo
integer x = 2327
integer y = 816
integer taborder = 0
string picturename = "c:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type nb_publi_promo_t from statictext within w_detail_cde_promo
integer x = 1271
integer y = 496
integer width = 782
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
string text = "*Nombre de publi promo :*"
boolean focusrectangle = false
end type

type pb_annul_promo from u_pba_annul_promo within w_detail_cde_promo
integer x = 1829
integer y = 816
integer taborder = 0
string text = "&Annul      Promo"
string picturename = "c:\appscir\Erfvmr_diva\Image\pb_aprom.bmp"
end type

type em_nbr from u_ema within w_detail_cde_promo
integer x = 2094
integer y = 480
integer width = 128
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
string mask = "###"
end type

