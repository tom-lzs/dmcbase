$PBExportHeader$w_a_ident.srw
$PBExportComments$Ancêtre - Fenêtre de saisie de critères
forward
global type w_a_ident from w_a
end type
type pb_ok from u_pba_ok within w_a_ident
end type
type pb_liste from u_pba_liste within w_a_ident
end type
type pb_echap from u_pba_echap within w_a_ident
end type
type pb_nouveau from u_pba_nouveau within w_a_ident
end type
end forward

global type w_a_ident from w_a
integer width = 1536
integer height = 1040
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
long backcolor = 16776960
event ue_liste pbm_custom40
event ue_nouveau pbm_custom41
event ue_echap pbm_custom42
pb_ok pb_ok
pb_liste pb_liste
pb_echap pb_echap
pb_nouveau pb_nouveau
end type
global w_a_ident w_a_ident

event key;call super::key;/* <DESC>
      Permet de trapper les touches de fonction activées et déclencher l'évènement associé
	à la touche.
	  F11 = Validqtion de la sélection
	  F2 = Affichage de la liste des clients
   </DESC> */
	IF KeyDown (keyF11!) THEN
		This.PostEvent ("ue_ok")
	END IF
	IF KeyDown (keyF2!) THEN
		This.PostEvent ("ue_liste")
	END IF


end event

event ue_ok;call super::ue_ok;/* <DESC> 
     Initialisation de la variable Action de la structure à OK
	  pour pouvoir spécifier aux fenêtres appelantes la sélection qui a été effectuée
   </DESC> */	i_str_pass.s_action = "ok"
end event

event ue_new;call super::ue_new;/* <DESC> 
     Initialisation de la variable Action de la structure à New
	  pour pouvoir spécifier aux fenêtres appelantes la sélection qui a été effectuée
   </DESC> */
	i_str_pass.s_action = "new"
end event

on w_a_ident.create
int iCurrent
call super::create
this.pb_ok=create pb_ok
this.pb_liste=create pb_liste
this.pb_echap=create pb_echap
this.pb_nouveau=create pb_nouveau
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_ok
this.Control[iCurrent+2]=this.pb_liste
this.Control[iCurrent+3]=this.pb_echap
this.Control[iCurrent+4]=this.pb_nouveau
end on

on w_a_ident.destroy
call super::destroy
destroy(this.pb_ok)
destroy(this.pb_liste)
destroy(this.pb_echap)
destroy(this.pb_nouveau)
end on

event ue_cancel;call super::ue_cancel;/* <DESC> 
     Initialisation de la variable Action de la structure à cancel
	  pour pourvoir spécifier aux fenêtres appelantes que la sélection a
	  été abandonnée
   </DESC> */
	i_str_pass.s_action = "cancel"
end event

type uo_statusbar from w_a`uo_statusbar within w_a_ident
end type

type pb_ok from u_pba_ok within w_a_ident
integer x = 27
integer y = 756
integer width = 334
integer taborder = 40
string text = "Valid  F11"
string picturename = "C:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_liste from u_pba_liste within w_a_ident
integer x = 777
integer y = 756
integer width = 334
integer height = 168
integer taborder = 30
boolean originalsize = false
string picturename = "C:\appscir\Erfvmr_diva\Image\pbliste.bmp"
string disabledname = "C:\appscir\Erfvmr_diva\Image\pbliste.bmp"
end type

type pb_echap from u_pba_echap within w_a_ident
integer x = 1152
integer y = 756
integer taborder = 20
string picturename = "C:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type pb_nouveau from u_pba_nouveau within w_a_ident
integer x = 402
integer y = 756
integer width = 334
integer height = 168
integer taborder = 10
boolean originalsize = false
string picturename = "C:\appscir\Erfvmr_diva\Image\pbnouv.bmp"
string disabledname = "C:\appscir\Erfvmr_diva\Image\pbnouv.bmp"
end type

