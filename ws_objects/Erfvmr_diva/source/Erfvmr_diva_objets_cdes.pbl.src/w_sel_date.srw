$PBExportHeader$w_sel_date.srw
$PBExportComments$Saisir  une date de livraison pour les lignes de commandes
forward
global type w_sel_date from w_a_selection
end type
type dtsaeliv_15_t from statictext within w_sel_date
end type
type em_date_livr from u_ema within w_sel_date
end type
end forward

global type w_sel_date from w_a_selection
string tag = "MODIF_DATE_LIVRAISON"
integer x = 1248
integer y = 700
integer width = 1285
integer height = 420
string title = "*Modification de la date de livraison*"
long backcolor = 12632256
dtsaeliv_15_t dtsaeliv_15_t
em_date_livr em_date_livr
end type
global w_sel_date w_sel_date

event ue_ok;call super::ue_ok;/* <DESC>
      Controle de la saisie de la date
		Elle ne peut être inférieure à la date de commande
		Elle doit être supérieure à la date de saisie de commande
     Fermeture de la fenêtre en passant la date saisie.
	    Si la date saisie est identique à la date de livraison initiale, on passe la date
		  par défaut (01/01/1900)
   </DESC> */
	
	// ----------------------------------
// CONTRÔLE DE LA DATE SAISIE
// ----------------------------------
nv_control_manager nv_check_value 
nv_check_value = CREATE nv_control_manager

if not nv_check_value.is_date_valide(em_date_livr.Text) then
	messagebox (this.title,g_nv_traduction.get_traduction(DATE_LIVRAISON_ERRONEE3),StopSign!,Ok!,1)
	em_date_livr.SetFocus()
	return
end if

IF Date (em_date_livr.Text) < i_str_pass.dates[2] THEN
	MessageBox (This.title,g_nv_traduction.get_traduction(DATE_LIVRAISON_ERRONEE2),Information!,Ok!,1)
	em_date_livr.SetFocus()
	RETURN
END IF

IF Date (em_date_livr.Text) <= i_str_pass.dates[3] THEN
	MessageBox (This.title,g_nv_traduction.get_traduction(DATE_LIVRAISON_ERRONEE),Information!,Ok!,1)
	em_date_livr.SetFocus()
	RETURN
END IF

if not  nv_check_value.is_date_liv_valide(em_date_livr.Text) then
	em_date_livr.SetFocus()
	RETURN
END IF

i_str_pass.dates[4] = Date (em_date_livr.Text)

iF i_str_pass.dates[4] = i_str_pass.dates[1] THEN
	i_str_pass.dates[4] = Date (DATE_DEFAULT_SYBASE)
end if

destroy nv_check_value
Message.fnv_set_str_pass(i_str_pass)
Close (This)

end event

event ue_init;call super::ue_init;/* <DESC>
     Initialisation de la fenêtre en affichant le date de livraison passée en paramètre
   </DESC> */

em_date_livr.Text = String (i_str_pass.dates[1])
em_date_livr.SelectText(1,Len(em_date_livr.text))

end event

on w_sel_date.create
int iCurrent
call super::create
this.dtsaeliv_15_t=create dtsaeliv_15_t
this.em_date_livr=create em_date_livr
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dtsaeliv_15_t
this.Control[iCurrent+2]=this.em_date_livr
end on

on w_sel_date.destroy
call super::destroy
destroy(this.dtsaeliv_15_t)
destroy(this.em_date_livr)
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

type uo_statusbar from w_a_selection`uo_statusbar within w_sel_date
end type

type pb_ok from w_a_selection`pb_ok within w_sel_date
boolean enabled = false
string picturename = "c:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_echap from w_a_selection`pb_echap within w_sel_date
string picturename = "c:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type dtsaeliv_15_t from statictext within w_sel_date
integer x = 73
integer y = 108
integer width = 640
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
string text = "Date livraison  "
alignment alignment = center!
boolean focusrectangle = false
end type

type em_date_livr from u_ema within w_sel_date
integer x = 727
integer y = 100
integer width = 338
integer height = 80
integer taborder = 10
integer textsize = -8
fontcharset fontcharset = ansi!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

