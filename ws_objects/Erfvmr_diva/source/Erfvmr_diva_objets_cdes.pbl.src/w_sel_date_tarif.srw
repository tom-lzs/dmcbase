$PBExportHeader$w_sel_date_tarif.srw
$PBExportComments$Saisir une date de tarif
forward
global type w_sel_date_tarif from w_a_selection
end type
type date_tarif_t from statictext within w_sel_date_tarif
end type
type em_date from u_ema within w_sel_date_tarif
end type
end forward

global type w_sel_date_tarif from w_a_selection
string tag = "MODIFICATION_DATE_TARIF"
integer x = 1248
integer y = 700
integer width = 1285
integer height = 420
string title = "*Modification de la date du tarif*"
long backcolor = 12632256
date_tarif_t date_tarif_t
em_date em_date
end type
global w_sel_date_tarif w_sel_date_tarif

event ue_ok;call super::ue_ok;/* <DESC>
     Fermeture de la fenêtre en passant la date du tarif saisie.
	    Si la date saisie est identique à la date initiale, on passe la date
		  par défaut (01/01/1900)
   </DESC> */
// ----------------------------------
// CONTRÔLE DE LA DATE SAISIE
// ----------------------------------
i_str_pass.dates[2] = Date (em_date.Text)

nv_control_manager nv_check_value 
nv_check_value = CREATE nv_control_manager

if not nv_check_value.is_date_valide(em_date.Text) then
	messagebox (this.title,g_nv_traduction.get_traduction(DATE_PRIX_ERRONEE),StopSign!,Ok!,1)
	em_date.SetFocus()
	return
end if

iF i_str_pass.dates[2] = i_str_pass.dates[1] THEN
	i_str_pass.dates[2] = Date (DATE_DEFAULT_SYBASE)
end if

Message.fnv_set_str_pass(i_str_pass)
Close (This)

end event

event ue_init;call super::ue_init;/* <DESC> 
     Initialisation de la fenêtre en affichant le date du tarif passée en paramètre
  </DESC> */
// ---------------------------------------
// INITIALISATION DE LA DATE DE LIVRAISON 
// ---------------------------------------
em_date.Text = String (i_str_pass.dates[1])
em_date.SelectText(1,Len(em_date.text))

end event

on w_sel_date_tarif.create
int iCurrent
call super::create
this.date_tarif_t=create date_tarif_t
this.em_date=create em_date
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.date_tarif_t
this.Control[iCurrent+2]=this.em_date
end on

on w_sel_date_tarif.destroy
call super::destroy
destroy(this.date_tarif_t)
destroy(this.em_date)
end on

event key;call super::key;/* <DESC>
      Permet de trapper les touches de fonction activées et déclencher l'évènement associé
	à la touche.
	  F11 = Validation de la saisie
   </DESC> */
	IF KeyDown (KeyF11!) THEN
		This.TriggerEvent ("ue_ok")
	END IF
	
end event

type uo_statusbar from w_a_selection`uo_statusbar within w_sel_date_tarif
end type

type pb_ok from w_a_selection`pb_ok within w_sel_date_tarif
string picturename = "c:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_echap from w_a_selection`pb_echap within w_sel_date_tarif
string picturename = "c:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type date_tarif_t from statictext within w_sel_date_tarif
integer x = 183
integer y = 108
integer width = 530
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
string text = "Date tarif  "
boolean focusrectangle = false
end type

type em_date from u_ema within w_sel_date_tarif
integer x = 727
integer y = 100
integer width = 338
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

