$PBExportHeader$w_sel_tx_remise.srw
$PBExportComments$Saisie du taux de remise pour affecter aux lignes de cde sélectionnées
forward
global type w_sel_tx_remise from w_a_selection
end type
type taux_remise_t from statictext within w_sel_tx_remise
end type
type em_taux_remise from u_ema within w_sel_tx_remise
end type
end forward

global type w_sel_tx_remise from w_a_selection
string tag = "MODIFICATION_TAUX_REMISE"
integer x = 1248
integer y = 700
integer height = 464
string title = "*Modification du taux de remise*"
long backcolor = 12632256
taux_remise_t taux_remise_t
em_taux_remise em_taux_remise
end type
global w_sel_tx_remise w_sel_tx_remise

event ue_ok;call super::ue_ok;/* <DESC>
       Fermture de la fenêtre en passant le taux de remise saisi
   </DESC> */
	i_str_pass.d[1] = Dec (em_taux_remise.Text)
	Message.fnv_set_str_pass(i_str_pass)
	Close (This)

	



end event

event ue_init;call super::ue_init;/* <DESC>
      Initialisation de l'affichage de la fenêtre en alimentant la remise à partir
		du paramètre passé
   </DESC> */
	em_taux_remise.Text = String (i_str_pass.d[1])
	em_taux_remise.SetFocus()
	em_taux_remise.SelectText(1,Len(em_taux_remise.Text))

end event

on w_sel_tx_remise.create
int iCurrent
call super::create
this.taux_remise_t=create taux_remise_t
this.em_taux_remise=create em_taux_remise
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.taux_remise_t
this.Control[iCurrent+2]=this.em_taux_remise
end on

on w_sel_tx_remise.destroy
call super::destroy
destroy(this.taux_remise_t)
destroy(this.em_taux_remise)
end on

event key;call super::key;/* <DESC>
      Permet de trapper les touches de fonction activées et déclencher l'évènement associé
	à la touche.
	  F11 = Validation de la saisie
	</DESC> */
// F9 DECLENCHE L'EVENEMENT MODIFIER

	IF KeyDown (KeyF11!) THEN
		This.TriggerEvent ("ue_ok")
	END IF
	
end event

type uo_statusbar from w_a_selection`uo_statusbar within w_sel_tx_remise
end type

type pb_ok from w_a_selection`pb_ok within w_sel_tx_remise
string picturename = "c:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_echap from w_a_selection`pb_echap within w_sel_tx_remise
string picturename = "c:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type taux_remise_t from statictext within w_sel_tx_remise
integer x = 46
integer y = 112
integer width = 832
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
string text = "Taux de remise ligne  "
alignment alignment = center!
boolean focusrectangle = false
end type

type em_taux_remise from u_ema within w_sel_tx_remise
integer x = 891
integer y = 104
integer width = 247
integer height = 88
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
maskdatatype maskdatatype = numericmask!
string mask = "##.00"
end type

