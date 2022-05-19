$PBExportHeader$w_gestion_table_a_transferer.srw
forward
global type w_gestion_table_a_transferer from w_a_pick_list_det
end type
type cb_fermer from u_cba within w_gestion_table_a_transferer
end type
type cb_ok from u_cba within w_gestion_table_a_transferer
end type
type cb_nouveau from u_cba within w_gestion_table_a_transferer
end type
type cb_1 from u_cba within w_gestion_table_a_transferer
end type
type st_1 from statictext within w_gestion_table_a_transferer
end type
end forward

global type w_gestion_table_a_transferer from w_a_pick_list_det
integer width = 4841
integer height = 2224
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = child!
windowstate windowstate = maximized!
long backcolor = 12632256
cb_fermer cb_fermer
cb_ok cb_ok
cb_nouveau cb_nouveau
cb_1 cb_1
st_1 st_1
end type
global w_gestion_table_a_transferer w_gestion_table_a_transferer

type variables
long il_row_selectionne
long i_l_save_row_num

end variables

on w_gestion_table_a_transferer.create
int iCurrent
call super::create
this.cb_fermer=create cb_fermer
this.cb_ok=create cb_ok
this.cb_nouveau=create cb_nouveau
this.cb_1=create cb_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_fermer
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.cb_nouveau
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.st_1
end on

on w_gestion_table_a_transferer.destroy
call super::destroy
destroy(this.cb_fermer)
destroy(this.cb_ok)
destroy(this.cb_nouveau)
destroy(this.cb_1)
destroy(this.st_1)
end on

event ue_cancel;i_b_canceled = FALSE
Close (this)
end event

event ue_delete;/* <DESC>
     Suppression de la table à ne plus transférer sur le portable ainsi
	  que les infos spécifiques visiteurs
   </DESC> */
	
dw_1.fu_delete (1)
dw_1.update()
dw_pick.retrieve()




end event

event ue_init;call super::ue_init;/* <DESC> 
     Initialisation de la fenêtre
   </DESC< */

dw_pick.retrieve()
end event

event ue_new;call super::ue_new;/* <DESC>
     Sauvegarde des données de la ligne en cours
	 Création d'une nouvelle ligne pour saisie
   </DESC> */
triggerEvent("ue_save")

if i_b_update_status then
	dw_pick.retrieve()
	dw_pick.scrollToRow(il_row_selectionne)
end if

dw_1.reset()
dw_1.insertRow(1)
dw_1.setTabOrder (DBNAME_CODE_TABLE,10)
dw_1.modify		  (DBNAME_CODE_TABLE + ".border= '4'")
dw_1.setColumn   (DBNAME_CODE_TABLE)
dw_1.setFocus()
il_row_selectionne = dw_pick.RowCount()
end event

event ue_ok;/* <DESC> 
     Validation & Mise à jour des infos de la table à transférer
   </DESC> */
this.TriggerEvent ("ue_save")

if i_b_update_status then
	dw_pick.retrieve()
	dw_pick.scrollToRow(il_row_selectionne)
end if

end event

event ue_presave;call super::ue_presave;/* <DESC>
     Contrôle de la saisie des données de la table à transférer
	 <LI> Zones Obligatoires : Code Table, Intitulé
	 <LI> Initialisation des indicateurs d'extraction
   </DESC> */
// --------------------------------------------
// CONTRÔLE DES CHAMPS SUIVANTS
// --------------------------------------------

dw_1.AcceptText ()
if dw_1.rowcount()= 0 then 
	return
end if

il_row_selectionne = dw_pick.getRow()

// Controle de la présence des infos
if trim(dw_1.getItemString(1,DBNAME_CODE_TABLE)) = DONNEE_VIDE  or & 
   isNull(dw_1.getItemString(1,DBNAME_CODE_TABLE)) then
	MessageBox (This.title,"Code Obligatoire" + BLANK + OBTENIR_LISTE,StopSign!,Ok!,1)
	dw_1.SetColumn (DBNAME_CODE_TABLE)
	dw_1.SetFocus ()
	Message.ReturnValue = -1
	RETURN	
end if

if trim(dw_1.getItemString(1,DBNAME_INTITULE_TABLE)) = DONNEE_VIDE  or & 
   isNull(dw_1.getItemString(1,DBNAME_INTITULE_TABLE)) then
	MessageBox (This.title,"Intitulé Obligatoire" + BLANK + OBTENIR_LISTE,StopSign!,Ok!,1)
	dw_1.SetColumn (DBNAME_INTITULE_TABLE)
	dw_1.SetFocus ()
	Message.ReturnValue = -1
	RETURN	
end if

//if isNull(dw_1.getItemString(1, DBNAME_EXTRACTION_DATE)) then
//	dw_1.setItem(1, DBNAME_EXTRACTION_DATE, "N")
//end if
//if isNull(dw_1.getItemString(1, DBNAME_EXTRACTION_VISITEUR)) then
//	dw_1.setItem(1, DBNAME_EXTRACTION_VISITEUR, "N")
//end if
//if isNull(dw_1.getItemString(1, DBNAME_EXTRACTION_MARCHE)) then
//	dw_1.setItem(1, DBNAME_EXTRACTION_MARCHE, "N")
//end if
//if isNull(dw_1.getItemString(1, DBNAME_EXTRACTION_POUR_VENDEUR)) then
//	dw_1.setItem(1, DBNAME_EXTRACTION_POUR_VENDEUR, "N")
//end if
//if isNull(dw_1.getItemString(1, DBNAME_EXTRACTION_POUR_RC)) then
//	dw_1.setItem(1, DBNAME_EXTRACTION_POUR_RC, "N")
//end if
//if isNull(dw_1.getItemString(1, DBNAME_EXTRACTION_POUR_FI)) then 
//	dw_1.setItem(1, DBNAME_EXTRACTION_POUR_FI, "N")
//end if
end event

event ue_retrieve;call super::ue_retrieve;/* <DESC>
     Extraction des infos visiteur associées à la table sélectionnée
   </DESC> */
dw_1.retrieve(dw_pick.getItemString(dw_pick.getRow(),DBNAME_CODE_TABLE))
dw_1.setColumn(DBNAME_CODE_TABLE)

end event

type dw_1 from w_a_pick_list_det`dw_1 within w_gestion_table_a_transferer
integer x = 2587
integer y = 232
integer width = 1920
integer height = 836
string dataobject = "d_maj_liste_table"
end type

type uo_statusbar from w_a_pick_list_det`uo_statusbar within w_gestion_table_a_transferer
end type

type dw_pick from w_a_pick_list_det`dw_pick within w_gestion_table_a_transferer
integer width = 2441
integer height = 1924
string dataobject = "d_liste_table"
end type

type cb_fermer from u_cba within w_gestion_table_a_transferer
integer x = 1518
integer y = 2028
integer width = 352
integer height = 96
integer taborder = 80
boolean bringtotop = true
string text = "&Fermer"
end type

event constructor;call super::constructor;i_s_event = "ue_cancel"
end event

type cb_ok from u_cba within w_gestion_table_a_transferer
integer x = 2953
integer y = 1104
integer width = 352
integer height = 96
integer taborder = 40
boolean bringtotop = true
string text = "OK"
end type

event constructor;call super::constructor;i_s_event = "ue_ok"
end event

type cb_nouveau from u_cba within w_gestion_table_a_transferer
integer x = 3346
integer y = 1100
integer width = 352
integer height = 96
integer taborder = 90
boolean bringtotop = true
string text = "Nouvelle"
end type

event constructor;call super::constructor;i_s_event = "ue_new"
end event

type cb_1 from u_cba within w_gestion_table_a_transferer
integer x = 3735
integer y = 1100
integer width = 384
integer height = 96
integer taborder = 100
boolean bringtotop = true
string text = "Suppression"
end type

event constructor;call super::constructor;i_s_event = "ue_delete"
end event

type st_1 from statictext within w_gestion_table_a_transferer
integer x = 3186
integer y = 124
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Détail"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

