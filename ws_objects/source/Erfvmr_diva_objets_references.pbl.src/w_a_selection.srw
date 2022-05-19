$PBExportHeader$w_a_selection.srw
$PBExportComments$Ancêtre - Fenêtre de sélection
forward
global type w_a_selection from w_a
end type
type pb_ok from u_pba_ok within w_a_selection
end type
type pb_echap from u_pba_echap within w_a_selection
end type
end forward

global type w_a_selection from w_a
integer width = 1257
integer height = 1028
string title = "Sélection"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
long backcolor = 16776960
pb_ok pb_ok
pb_echap pb_echap
end type
global w_a_selection w_a_selection

event ue_ok;call super::ue_ok;/* <DESC> 
     Initialisation de la variable Action de la structure à New
	  pour pourvoir spécifier aux fenêtres appelantes la sélection qui a été effectuée
   </DESC> */
i_str_pass.s_action = "ok" 
end event

event ue_cancel;call super::ue_cancel;/* <DESC>
     Permet de quitter la fenetre suite à l'abandon de la sélection
   </DESC> */
	i_str_pass.s_action = "cancel"
	Message.fnv_set_str_pass(i_str_pass)
	Close (This)
end event

on w_a_selection.create
int iCurrent
call super::create
this.pb_ok=create pb_ok
this.pb_echap=create pb_echap
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_ok
this.Control[iCurrent+2]=this.pb_echap
end on

on w_a_selection.destroy
call super::destroy
destroy(this.pb_ok)
destroy(this.pb_echap)
end on

type uo_statusbar from w_a`uo_statusbar within w_a_selection
end type

type pb_ok from u_pba_ok within w_a_selection
integer x = 169
integer y = 684
integer width = 334
integer height = 152
integer taborder = 10
string picturename = "C:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_echap from u_pba_echap within w_a_selection
integer x = 741
integer y = 684
integer height = 152
integer taborder = 20
string picturename = "C:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

