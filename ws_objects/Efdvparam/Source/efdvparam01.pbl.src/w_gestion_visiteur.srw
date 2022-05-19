$PBExportHeader$w_gestion_visiteur.srw
$PBExportComments$Permet la gestion du repertoire des visiteurs
forward
global type w_gestion_visiteur from w_a_pick_list_det
end type
type cb_ok from u_cba within w_gestion_visiteur
end type
type cb_fermer from u_cba within w_gestion_visiteur
end type
type cb_nouveau from u_cba within w_gestion_visiteur
end type
type cb_suppression from u_cba within w_gestion_visiteur
end type
type dw_manager from u_dw_udis within w_gestion_visiteur
end type
end forward

global type w_gestion_visiteur from w_a_pick_list_det
integer x = 769
integer y = 461
integer width = 3543
integer height = 2052
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = child!
windowstate windowstate = maximized!
long backcolor = 12632256
event ue_listes ( )
event ue_save_manager ( )
cb_ok cb_ok
cb_fermer cb_fermer
cb_nouveau cb_nouveau
cb_suppression cb_suppression
dw_manager dw_manager
end type
global w_gestion_visiteur w_gestion_visiteur

type variables
long il_row_selectionne
boolean ib_nouveau = false
end variables

event ue_listes();/* <DESC>
   Permet d'afficher la liste correspondante a la zone selectionnee pour permettre la selection d'une valeur
	</DESC> */

String		s_colonne
String 		s_code_colonne
Str_pass		str_work
nv_list_manager s_nv_liste_manager
s_nv_liste_manager = CREATE nv_list_manager

s_colonne = dw_1.GetColumnName()	
str_work.s[1] = s_colonne
str_work.s[3] = dw_1.getItemString(1,DBNAME_TYPE_CDE)
str_work = s_nv_liste_manager.get_list_of_column(str_work)
	
// cette action provient de la fenetre de selection appelée
// prédemment - click sur cancel
if str_work.s_action =  ACTION_CANCEL then
	return
end if

// Mise à jour de la datawindow correspondante à la liste selectionnee
dw_1.SetItem (1, s_colonne, str_work.s[1])
destroy s_nv_liste_manager
end event

event ue_save_manager();long ll_row
dw_manager.AcceptText ()
String ls_visiteur 

i_b_update_status = True
ls_visiteur = trim(dw_manager.getitemstring(dw_manager.getRow(),"CODEEVIS"))
if len (ls_visiteur)  = 0 then
	if dw_manager.getItemstatus(dw_manager.getRow(),0,primary!) =New!	 or   dw_manager.getItemstatus(dw_manager.getRow(),0,primary!) =NewModified!	  then
		i_b_update_status = FALSE
		return
	end if
	dw_manager.deleterow(dw_manager.getRow())
	dw_manager.update()
	i_b_update_status = FALSE
	return
end if


ll_row = 	dw_pick.find ( DBNAME_CODE_VISITEUR + " = '" + dw_manager.getitemstring(dw_manager.getRow(),"CODEEVIS") + "'",1,dw_pick.rowcount())
if ll_row = 0 THEN
	MessageBox (This.title,"Visiteur inexistant" ,StopSign!,Ok!,1)
	dw_manager.SetColumn (DBNAME_CODE_VISITEUR)
	dw_manager.SetFocus ()
	i_b_update_status = FALSE
	return
end if


dw_manager.setitem(dw_manager.getrow(),"codeemaj", "C")
dw_manager.setitem(dw_manager.getrow(),"timefcre", sqlca.fnv_get_datetime( ) )
dw_manager.setitem(dw_manager.getrow(),"codeevis_manager",dw_pick.getItemString(dw_pick.getRow(),DBNAME_CODE_VISITEUR))
dw_manager.update()
	

end event

on w_gestion_visiteur.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.cb_fermer=create cb_fermer
this.cb_nouveau=create cb_nouveau
this.cb_suppression=create cb_suppression
this.dw_manager=create dw_manager
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.cb_fermer
this.Control[iCurrent+3]=this.cb_nouveau
this.Control[iCurrent+4]=this.cb_suppression
this.Control[iCurrent+5]=this.dw_manager
end on

on w_gestion_visiteur.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.cb_fermer)
destroy(this.cb_nouveau)
destroy(this.cb_suppression)
destroy(this.dw_manager)
end on

event ue_init;call super::ue_init;/* <DESC>
      Initialisation de la fenetre en affichant la liste des visiteurs
   </DESC> */
dw_pick.retrieve()
dw_manager.settrans( i_tr_sql)
end event

event ue_retrieve;call super::ue_retrieve;/* <DESC>
   Permet d'afficher les donnees du visiteur selectionne
   </DESC> */
if dw_pick.rowCount() = 0 then
	return
end if
ib_nouveau = false
il_row_selectionne = dw_pick.getRow()

dw_1.retrieve(dw_pick.getItemString(dw_pick.getRow(),DBNAME_CODE_VISITEUR))

if dw_1.GetItemString(1,DBNAME_TYPE_VISITEUR) = MANAGER then
	dw_manager.retrieve(dw_pick.getItemString(dw_pick.getRow(),DBNAME_CODE_VISITEUR))
	dw_manager.insertrow(0)
	dw_manager. visible = true
else
	dw_manager. visible = false
end if
end event

event key;call super::key;/* <DESC> 
     Permet de trapper les touches de fonctions activées et d'effectuer le traitement associe
	  F2 = Affichage de la liste de valeur de la zone sélectionnée
    </DESC> */
	IF KeyDown (KeyF2!) THEN
		This.PostEvent ("ue_listes")
	END IF
end event

event ue_presave;call super::ue_presave;/* <DESC>
    Effectue la validation de la saisie des données
	 <LI> en cas de creation le code visiteur est obligatoire
	 <LI>Nom du visisteur, mot de passe et type de visiteur obligatoires
	 <LI> les differentes données par defaut sont obligatoires et doivente être valide
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
if trim(dw_1.getItemString(1,DBNAME_CODE_VISITEUR)) = DONNEE_VIDE  or & 
   isNull(dw_1.getItemString(1,DBNAME_CODE_VISITEUR)) then
	MessageBox (This.title,"Code Obligatoire" ,StopSign!,Ok!,1)
	dw_1.SetColumn (DBNAME_CODE_VISITEUR)
	dw_1.SetFocus ()
	Message.ReturnValue = -1
	RETURN	
end if

// Controle que le visiteur n'existe pas 
// Controle du code marche et de la devise
if ib_nouveau then 
	ll_row = dw_pick.find (DBNAME_CODE_VISITEUR + " = '" + dw_1.getItemString(1,DBNAME_CODE_VISITEUR) + "'" ,1, dw_pick.rowCount())
	if ll_row > 0 then
		messagebox (this.title, "Visiteur deja existantt", Information!,Ok!,1)	
		dw_1.SetColumn (DBNAME_CODE_VISITEUR)
		dw_1.SetFocus ()
		Message.ReturnValue = -1
		RETURN	
	end if
end if

if trim(dw_1.getItemString(1,DBNAME_NOM_VISITEUR)) = DONNEE_VIDE  or & 
   isNull(dw_1.getItemString(1,DBNAME_NOM_VISITEUR)) then
	MessageBox (This.title,"Nom Obligatoire",StopSign!,Ok!,1)
	dw_1.SetColumn (DBNAME_NOM_VISITEUR)
	dw_1.SetFocus ()
	Message.ReturnValue = -1
	RETURN	
end if
if trim(dw_1.getItemString(1,DBNAME_MOT_PASSE)) = DONNEE_VIDE  or & 
   isNull(dw_1.getItemString(1,DBNAME_MOT_PASSE)) then
	MessageBox (This.title,"Mot de passe obligatoire" ,StopSign!,Ok!,1)
	dw_1.SetColumn (DBNAME_MOT_PASSE)
	dw_1.SetFocus ()
	Message.ReturnValue = -1
	RETURN	
end if
if trim(dw_1.getItemString(1,DBNAME_TYPE_VISITEUR)) = DONNEE_VIDE  or & 
   isNull(dw_1.getItemString(1,DBNAME_TYPE_VISITEUR)) then
	MessageBox (This.title,"Type obligatoire",StopSign!,Ok!,1)
	dw_1.SetColumn (DBNAME_TYPE_VISITEUR)
	dw_1.SetFocus ()
	Message.ReturnValue = -1
	RETURN	
end if
if trim(dw_1.getItemString(1,DBNAME_CODE_ADR)) = DONNEE_VIDE  or & 
   isNull(dw_1.getItemString(1,DBNAME_CODE_ADR)) then
	MessageBox (This.title,"Adresse obligatoire",StopSign!,Ok!,1)
	dw_1.SetColumn (DBNAME_CODE_ADR)
	dw_1.SetFocus ()
	Message.ReturnValue = -1
	RETURN	
end if

nv_control_manager nv_check_value 
nv_check_value = CREATE nv_control_manager
	
//Type de commande
l_str_work.s[1] = dw_1.GetItemString (1, DBNAME_TYPE_CDE)
l_str_work.s[2] = BLANK
l_str_work = nv_check_value.is_type_cde_valide (l_str_work)
if not l_str_work.b[1] then
	MessageBox (This.title,TYPE_CDE_INEXISTANT + BLANK + OBTENIR_LISTE,StopSign!,Ok!,1)
	dw_1.SetColumn (DBNAME_TYPE_CDE)
	dw_1.SetFocus ()
	Message.ReturnValue = -1
	RETURN
end if	

// si pour ce type de cde le code raison est obligatoire, controle
// de sa saisie
if l_str_work.s[6] = "O" then
	if trim(dw_1.GetItemString (1, DBNAME_RAISON_CDE)) = DONNEE_VIDE  or & 
	   isNull(dw_1.GetItemString (1, DBNAME_RAISON_CDE)) then
		MessageBox (This.title,RAISON_CDE_OBLIGATOIRE + BLANK + OBTENIR_LISTE,StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_RAISON_CDE)
		dw_1.SetFocus ()
		Message.ReturnValue = -1
		RETURN
	end if
end if 

//raison de commande
if trim(dw_1.GetItemString (1, DBNAME_RAISON_CDE)) <>  DONNEE_VIDE  and & 
   not isNull(dw_1.GetItemString (1, DBNAME_RAISON_CDE)) then		
	l_str_work.s[1] = dw_1.GetItemString (1, DBNAME_RAISON_CDE)
	l_str_work.s[2] = BLANK
	l_str_work.s[10] = dw_1.GetItemString (1, DBNAME_TYPE_CDE)
	l_str_work = nv_check_value.is_raison_cde_valide (l_str_work)
	if not l_str_work.b[1] then
		MessageBox (This.title,RAISON_CDE_INEXISTANTE + BLANK + OBTENIR_LISTE,StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_RAISON_CDE)
		dw_1.SetFocus ()
		Message.ReturnValue = -1
		RETURN
	end if	
end if

   //Origine de commande
l_str_work.s[1] = dw_1.GetItemString (1, DBNAME_ORIGINE_CDE)
l_str_work.s[2] = BLANK
l_str_work = nv_check_value.is_origine_cde_valide (l_str_work)
if not l_str_work.b[1] then
	MessageBox (This.title,ORIGINE_INEXISTANTE + BLANK + OBTENIR_LISTE,StopSign!,Ok!,1)
	dw_1.SetColumn (DBNAME_ORIGINE_CDE)
	dw_1.SetFocus ()
	Message.ReturnValue = -1
	RETURN
end if	

// Contrôle du code Marche
l_str_work.s[1] = dw_1.GetItemString (1, DBNAME_CODE_MARCHE)
l_str_work.s[2] = BLANK
l_str_work = nv_check_value.is_marche_valide (l_str_work)
if not l_str_work.b[1] then		
	MessageBox (This.title, MARCHE_INEXISTANT+ BLANK + OBTENIR_LISTE,StopSign!,Ok!,1)
	dw_1.SetColumn (DBNAME_CODE_MARCHE)
	dw_1.SetFocus ()
	Message.ReturnValue = -1
	RETURN
end if	
// Contrôle du code Devise
l_str_work.s[1] = dw_1.GetItemString (1, DBNAME_CODE_DEVISE)
l_str_work.s[2] = BLANK
l_str_work = nv_check_value.is_devise_valide (l_str_work)
if not l_str_work.b[1] then	
	MessageBox (This.title, DEVISE_INEXISTANTE + BLANK + OBTENIR_LISTE,StopSign!,Ok!,1)
	dw_1.SetColumn (DBNAME_CODE_DEVISE)
	dw_1.SetFocus ()
	Message.ReturnValue = -1
	RETURN
end if	

if trim(dw_1.getItemString(1,DBNAME_LISTE_PRIX)) = DONNEE_VIDE  or & 
   isNull(dw_1.getItemString(1,DBNAME_LISTE_PRIX)) then
	MessageBox (This.title,"Liste prix obligatoire" + BLANK + OBTENIR_LISTE,StopSign!,Ok!,1)
	dw_1.SetColumn (DBNAME_LISTE_PRIX)
	dw_1.SetFocus ()
	Message.ReturnValue = -1
	RETURN	
end if

// Controle du Code Pays
l_str_work.s[1] = dw_1.GetItemString (1, DBNAME_PAYS)
l_str_work.s[2] = BLANK
l_str_work = nv_check_value.is_pays_valide (l_str_work)
if not l_str_work.b[1] then
	MessageBox (This.title,PAYS_INEXISTANT + BLANK + OBTENIR_LISTE,StopSign!,Ok!,1)
	dw_1.SetColumn (DBNAME_PAYS)
	dw_1.SetFocus ()
	Message.ReturnValue = -1
	RETURN
end if

// Controle du Code Langue
l_str_work.s[1] = dw_1.GetItemString (1, DBNAME_LANGUE)
l_str_work.s[2] = BLANK
l_str_work = nv_check_value.is_langue_valide (l_str_work)
if not l_str_work.b[1] then
	MessageBox (This.title,LANGUE_INEXISTANT + BLANK + OBTENIR_LISTE,StopSign!,Ok!,1)
	dw_1.SetColumn (DBNAME_LANGUE)
	dw_1.SetFocus ()
	Message.ReturnValue = -1
	RETURN
end if

dw_1.SetItem(1,DBNAME_DATE_CREATION, 	i_tr_sql.fnv_get_datetime ())

if ib_nouveau then
	dw_1.SetItem(1,DBNAME_DATE_MAJ_CDE, 	i_tr_sql.fnv_get_datetime ())
	dw_1.SetItem(1,DBNAME_DATE_MAJ_PROSPECT, 	i_tr_sql.fnv_get_datetime ())
end if
end event

event ue_new;call super::ue_new;/* <DESC> 
    Initialisation de la datawindow pour permettre la creation d'un nouveau visiteur
   </DESC> */
dw_1.reset()
dw_1.insertRow(1)
dw_1.setTabOrder(DBNAME_CODE_VISITEUR,10)
dw_1.modify(DBNAME_CODE_VISITEUR + ".border= '4'")
dw_1.setColumn(DBNAME_CODE_VISITEUR)
dw_1.setFocus()
ib_nouveau = true
end event

event ue_ok;/* <DESC>
    Permet la validation de la saisie des données et de reactualiser la liste des visiteurs
   </DESC> */ 
	//  Overwrited
	
this.TriggerEvent ("ue_save")

if i_b_update_status then
	dw_pick.retrieve()
	dw_pick.scrollToRow(il_row_selectionne)
     ib_nouveau = false
end if

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

end event

event closequery;/* <DESC>
     Overwrite le script de l'ancetre
   </DESC> */

end event

type dw_1 from w_a_pick_list_det`dw_1 within w_gestion_visiteur
integer x = 119
integer y = 844
integer width = 2190
integer height = 976
string dataobject = "d_info_visiteur"
end type

event dw_1::we_dwnkey;call super::we_dwnkey;parent.triggerEvent("key")
end event

type uo_statusbar from w_a_pick_list_det`uo_statusbar within w_gestion_visiteur
end type

type dw_pick from w_a_pick_list_det`dw_pick within w_gestion_visiteur
integer x = 343
integer y = 80
integer width = 1714
integer height = 696
string dataobject = "d_liste_visiteur"
boolean vscrollbar = true
borderstyle borderstyle = styleshadowbox!
end type

type cb_ok from u_cba within w_gestion_visiteur
integer x = 320
integer y = 1920
integer width = 352
integer height = 96
integer taborder = 11
boolean bringtotop = true
string text = "OK"
end type

event constructor;call super::constructor;i_s_event = "ue_ok"
end event

type cb_fermer from u_cba within w_gestion_visiteur
integer x = 791
integer y = 1920
integer width = 352
integer height = 96
integer taborder = 21
boolean bringtotop = true
string text = "&Fermer"
end type

event constructor;call super::constructor;i_s_event = "ue_cancel"
end event

type cb_nouveau from u_cba within w_gestion_visiteur
integer x = 1294
integer y = 1920
integer width = 352
integer height = 96
integer taborder = 21
boolean bringtotop = true
string text = "Nouveau"
end type

event constructor;call super::constructor;i_s_event = "ue_new"
end event

type cb_suppression from u_cba within w_gestion_visiteur
integer x = 1833
integer y = 1920
integer width = 425
integer height = 96
integer taborder = 11
boolean bringtotop = true
string text = "&Suppression"
end type

event clicked;call super::clicked;i_s_event = "ue_delete"
end event

type dw_manager from u_dw_udis within w_gestion_visiteur
boolean visible = false
integer x = 2359
integer y = 916
integer width = 1134
integer height = 816
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_manager_visiteur"
boolean vscrollbar = true
end type

event we_dwnprocessenter;call super::we_dwnprocessenter;//IF  len(Trim(this.Getitemstring(this.getRow(),"codeevis")))  = 0 then
//	return 1
//end if
//

parent.triggerEvent("ue_save_manager")

if i_b_update_status then
	insertRow(0)
end if


end event

