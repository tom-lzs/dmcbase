$PBExportHeader$w_gestion_adr_dmc.srw
forward
global type w_gestion_adr_dmc from w_a_pick_list_det
end type
type cb_2 from u_cba within w_gestion_adr_dmc
end type
type cb_3 from u_cba within w_gestion_adr_dmc
end type
type cb_nouveau from u_cba within w_gestion_adr_dmc
end type
type cb_suppression from u_cba within w_gestion_adr_dmc
end type
end forward

global type w_gestion_adr_dmc from w_a_pick_list_det
integer width = 2853
integer height = 1360
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = child!
windowstate windowstate = maximized!
long backcolor = 12632256
cb_2 cb_2
cb_3 cb_3
cb_nouveau cb_nouveau
cb_suppression cb_suppression
end type
global w_gestion_adr_dmc w_gestion_adr_dmc

type variables
long il_row_selectionne
boolean ib_nouveau = false
end variables

on w_gestion_adr_dmc.create
int iCurrent
call super::create
this.cb_2=create cb_2
this.cb_3=create cb_3
this.cb_nouveau=create cb_nouveau
this.cb_suppression=create cb_suppression
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.cb_nouveau
this.Control[iCurrent+4]=this.cb_suppression
end on

on w_gestion_adr_dmc.destroy
call super::destroy
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.cb_nouveau)
destroy(this.cb_suppression)
end on

event closequery;call super::closequery;/* <DESC>
     Overwrite le script de l'ancetre
   </DESC> */

end event

event ue_delete;/* <DESC>
     Permet la suppression d'un visiteur
	<LI> Ouverture de la fenetre d'identification permettant d'autoriser la suppression
	<LI> Si identification valide, suppression du visiteur
   </DESC> */
// overwrite

OpenWithParm (w_dmc_login, i_str_pass)

i_str_pass = message.fnv_get_str_pass ()
if i_str_pass.s_action = ACTION_CANCEL then
	return
end if

dw_1.deleteROw(dw_1.getRow())
dw_1.update()
dw_pick.retrieve()
dw_1.retrieve(dw_pick.getItemString(dw_pick.getRow(),DBNAME_CODE_ADR))

end event

event ue_init;call super::ue_init;/* <DESC>
      Initialisation de la fenetre en affichant la liste des visiteurs
   </DESC> */
dw_pick.retrieve()
end event

event ue_new;call super::ue_new;/* <DESC> 
    Initialisation de la datawindow pour permettre la creation d'un nouveau visiteur
   </DESC> */
dw_1.reset()
dw_1.insertRow(1)
dw_1.setTabOrder(DBNAME_CODE_ADR,10)
dw_1.modify(DBNAME_CODE_ADR + ".border= '4'")
dw_1.setColumn(DBNAME_CODE_ADR)
dw_1.setFocus()
ib_nouveau = true
end event

event ue_ok;/* <DESC>
    Permet la validation de la saisie des données et de reactualiser la liste des visiteurs
   </DESC> */  
this.TriggerEvent ("ue_save")

if i_b_update_status then
	dw_pick.retrieve()
	dw_pick.scrollToRow(il_row_selectionne)
     ib_nouveau = false
end if

end event

event ue_retrieve;call super::ue_retrieve;/* <DESC>
   Permet d'afficher les donnees adresse selectionne
   </DESC> */
if dw_pick.rowCount() = 0 then
	return
end if
ib_nouveau = false
il_row_selectionne = dw_pick.getRow()

dw_1.retrieve(dw_pick.getItemString(dw_pick.getRow(),DBNAME_CODE_ADR))
end event

event ue_presave;call super::ue_presave;/* <DESC>
    Effectue la validation de la saisie des données
	 <LI> en cas de creation le code adresse est obligatoire
	 <LI>Nom et adresse obligatoires
   </DESC> */
// --------------------------------------------
// CONTRÔLE DES CHAMPS SUIVANTS
// --------------------------------------------
// DECLARATION DES VARIABLES LOCALES
String		s_intitule
Str_pass    l_str_work
Long			ll_row
	
dw_1.AcceptText ()

// Controle de la présence des infos
if trim(dw_1.getItemString(1,DBNAME_CODE_ADR)) = DONNEE_VIDE  or & 
   isNull(dw_1.getItemString(1,DBNAME_CODE_ADR)) then
	MessageBox (This.title,"Code Obligatoire" ,StopSign!,Ok!,1)
	dw_1.SetColumn (DBNAME_CODE_ADR)
	dw_1.SetFocus ()
	Message.ReturnValue = -1
	RETURN	
end if

if trim(dw_1.getItemString(1,DBNAME_CODE_NOM)) = DONNEE_VIDE  or & 
   isNull(dw_1.getItemString(1,DBNAME_CODE_NOM)) then
	MessageBox (This.title,"Nom Obligatoire" ,StopSign!,Ok!,1)
	dw_1.SetColumn (DBNAME_CODE_NOM)
	dw_1.SetFocus ()
	Message.ReturnValue = -1
	RETURN	
end if

// Controle que l'adresse n'existe pas déjà
if ib_nouveau then 
	ll_row = dw_pick.find (DBNAME_CODE_ADR + " = '" + dw_1.getItemString(1,DBNAME_CODE_ADR) + "'" ,1, dw_pick.rowCount())
	if ll_row > 0 then
		messagebox (this.title, "Code adresse deja existant", Information!,Ok!,1)	
		dw_1.SetColumn (DBNAME_CODE_ADR)
		dw_1.SetFocus ()
		Message.ReturnValue = -1
		RETURN	
	end if
end if

dw_1.SetItem(1,DBNAME_DATE_CREATION, 	i_tr_sql.fnv_get_datetime ())
dw_1.SetItem(1,DBNAME_CODE_MAJ, 	"C")
end event

type dw_1 from w_a_pick_list_det`dw_1 within w_gestion_adr_dmc
integer x = 82
integer y = 416
integer width = 2633
integer height = 660
string dataobject = "d_info_adr"
borderstyle borderstyle = styleshadowbox!
end type

type dw_pick from w_a_pick_list_det`dw_pick within w_gestion_adr_dmc
integer x = 727
integer y = 52
integer width = 1573
integer height = 320
string dataobject = "d_liste_adr"
boolean vscrollbar = true
borderstyle borderstyle = styleshadowbox!
end type

type cb_2 from u_cba within w_gestion_adr_dmc
integer x = 398
integer y = 1204
integer width = 352
integer height = 96
integer taborder = 31
boolean bringtotop = true
string text = "OK"
end type

event constructor;call super::constructor;i_s_event = "ue_ok"
end event

type cb_3 from u_cba within w_gestion_adr_dmc
integer x = 923
integer y = 1204
integer width = 352
integer height = 96
integer taborder = 41
boolean bringtotop = true
string text = "&Fermer"
end type

event constructor;call super::constructor;i_s_event = "ue_cancel"
end event

type cb_nouveau from u_cba within w_gestion_adr_dmc
integer x = 1449
integer y = 1204
integer width = 352
integer height = 96
integer taborder = 41
boolean bringtotop = true
string text = "Nouveau"
end type

event constructor;call super::constructor;i_s_event = "ue_new"
end event

type cb_suppression from u_cba within w_gestion_adr_dmc
integer x = 1911
integer y = 1200
integer width = 425
integer height = 96
integer taborder = 51
boolean bringtotop = true
string text = "&Suppression"
end type

event clicked;call super::clicked;i_s_event = "ue_delete"
end event

