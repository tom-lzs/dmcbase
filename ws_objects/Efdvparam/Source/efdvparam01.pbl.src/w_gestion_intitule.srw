$PBExportHeader$w_gestion_intitule.srw
forward
global type w_gestion_intitule from w_a_udim_su
end type
type cb_fermer from u_cba within w_gestion_intitule
end type
type cb_1 from u_cb_print within w_gestion_intitule
end type
end forward

global type w_gestion_intitule from w_a_udim_su
integer width = 3991
integer height = 2476
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = child!
windowstate windowstate = maximized!
long backcolor = 12632256
cb_fermer cb_fermer
cb_1 cb_1
end type
global w_gestion_intitule w_gestion_intitule

on w_gestion_intitule.create
int iCurrent
call super::create
this.cb_fermer=create cb_fermer
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_fermer
this.Control[iCurrent+2]=this.cb_1
end on

on w_gestion_intitule.destroy
call super::destroy
destroy(this.cb_fermer)
destroy(this.cb_1)
end on

event ue_init;call super::ue_init;
//  Chargement des données de la table des intitulés

dw_1.Retrieve()
dw_1.Object.DataWindow.HorizontalScrollSplit = 1800
end event

event ue_presave;call super::ue_presave;/* <DESC>
    Effectue la validation de la saisie des données
	 <LI> la longueur des zones intitulés ne doivent pas être > longueur maxi indiquée
   </DESC> */
// --------------------------------------------
// CONTRÔLE DES CHAMPS SUIVANTS
// --------------------------------------------
// DECLARATION DES VARIABLES LOCALES
String		    s_intitule
Str_pass    l_str_work
long            l_row 
decimal      d_lg


l_row = dw_1.fu_get_itemchanged_row_num ()
	
dw_1.AcceptText ()

d_lg = dw_1.GetItemDecimal(l_row,DBNAME_LONG_INTITULE)

// Controle de la longueur des intitulés 
 
if Len (Trim(dw_1.GetItemString(l_row,DBNAME_INTITULE_FR))) > 	d_lg  then
	MessageBox (This.title,"Intitulé français trop long"  ,StopSign!,Ok!,1)
	dw_1.SetColumn (DBNAME_INTITULE_FR)
  	dw_1.SetFocus ()
	Message.ReturnValue = -1
	RETURN	
end if

if Len (Trim(dw_1.GetItemString(l_row,DBNAME_INTITULE_EN))) > 	d_lg  then
	MessageBox (This.title,"Intitulé anglais trop long" ,StopSign!,Ok!,1)
	dw_1.SetColumn (DBNAME_INTITULE_EN)
	dw_1.SetFocus ()
	Message.ReturnValue = -1
	RETURN	
end if

if Len (Trim(dw_1.GetItemString(l_row,DBNAME_INTITULE_ES))) > 	d_lg  then
	MessageBox (This.title,"Intitulé espagnol trop long" ,StopSign!,Ok!,1)
	dw_1.SetColumn (DBNAME_INTITULE_ES)
	dw_1.SetFocus ()
	Message.ReturnValue = -1
	RETURN	
end if

if Len (Trim(dw_1.GetItemString(l_row,DBNAME_INTITULE_IT))) > 	d_lg  then
	MessageBox (This.title,"Intitulé italien trop long" ,StopSign!,Ok!,1)
	dw_1.SetColumn (DBNAME_INTITULE_IT)
	dw_1.SetFocus ()
	Message.ReturnValue = -1
	RETURN	
end if

if Len (Trim(dw_1.GetItemString(l_row,DBNAME_INTITULE_DE))) > 	d_lg  then
	MessageBox (This.title,"Intitulé allemand trop long" ,StopSign!,Ok!,1)
	dw_1.SetColumn (DBNAME_INTITULE_DE)
	dw_1.SetFocus ()
	Message.ReturnValue = -1
	RETURN	
end if

end event

event ue_print;open (w_select_impression)
end event

type dw_1 from w_a_udim_su`dw_1 within w_gestion_intitule
integer x = 69
integer y = 72
integer width = 3872
integer height = 2192
string dataobject = "d_liste_intitule"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

type uo_statusbar from w_a_udim_su`uo_statusbar within w_gestion_intitule
end type

type cb_fermer from u_cba within w_gestion_intitule
integer x = 1403
integer y = 2296
integer width = 352
integer height = 96
integer taborder = 31
boolean bringtotop = true
string text = "&Fermer"
end type

event constructor;call super::constructor;i_s_event = "ue_cancel"
end event

type cb_1 from u_cb_print within w_gestion_intitule
integer x = 1975
integer y = 2296
integer width = 352
integer height = 96
integer taborder = 11
boolean bringtotop = true
end type

