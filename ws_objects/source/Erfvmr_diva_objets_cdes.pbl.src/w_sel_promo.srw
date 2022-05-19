$PBExportHeader$w_sel_promo.srw
$PBExportComments$Sélection de la promotion pour laquelle des lignes de commande vont être créées
forward
global type w_sel_promo from w_a_liste
end type
end forward

global type w_sel_promo from w_a_liste
string tag = "LISTE_PROMO "
integer width = 2514
integer height = 1324
string title = "*Liste des promotions*"
boolean controlmenu = false
end type
global w_sel_promo w_sel_promo

event key;call super::key;/* <DESC>
      Permet de trapper les touches de fonction activées et déclencher l'évènement associé
	à la touche.
	  Enter = Validation de la sélection
   </DESC> */
	IF KeyDown (KeyEnter!) THEN
		This.TriggerEvent ("ue_ok")
	END IF
end event

on w_sel_promo.create
call super::create
end on

on w_sel_promo.destroy
call super::destroy
end on

event open;call super::open;/* appel de la fonction qui permet de ne pas traduire les libellés */

fu_ne_pas_traduire()
end event

event ue_init;Datetime  ldate
ldate = SQLCA.fnv_get_datetime( )
dw_1.retrieve(SQLCA.fnv_get_datetime( ), i_str_pass.s[1])
end event

event ue_ok;Long		l_row
l_row		= dw_1.GetRow()

if l_row = 0 then
	return
end if
i_str_pass.s_action = "ok"
i_str_pass.s[1] = dw_1.GetItemString (l_row, 1)
i_str_pass.s[2] = dw_1.GetItemString (l_row, 2) 
i_str_pass.dates[1] = date(dw_1.GetItemDateTime (l_row, 3) )

Message.fnv_set_str_pass(i_str_pass)
Close (This)
end event

type uo_statusbar from w_a_liste`uo_statusbar within w_sel_promo
end type

type cb_cancel from w_a_liste`cb_cancel within w_sel_promo
integer taborder = 30
end type

type cb_ok from w_a_liste`cb_ok within w_sel_promo
integer taborder = 20
end type

type dw_1 from w_a_liste`dw_1 within w_sel_promo
string tag = "A_TRADUIRE"
integer x = 87
integer y = 100
integer width = 2272
integer height = 828
integer taborder = 10
string dataobject = "d_liste_promo"
end type

type pb_ok from w_a_liste`pb_ok within w_sel_promo
integer x = 306
integer y = 976
integer taborder = 0
string picturename = "c:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_echap from w_a_liste`pb_echap within w_sel_promo
integer x = 1239
integer y = 976
integer taborder = 0
string picturename = "c:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

