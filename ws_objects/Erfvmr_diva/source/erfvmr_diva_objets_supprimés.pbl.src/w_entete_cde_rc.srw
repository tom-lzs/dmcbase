$PBExportHeader$w_entete_cde_rc.srw
$PBExportComments$Affichage et mise à jour des données complémentaires de l'entête de commande. N'est accessible que par les assistantes clientèles
forward
global type w_entete_cde_rc from w_a_mas_det
end type
type pb_ok from u_pba_ok within w_entete_cde_rc
end type
type pb_echap from u_pba_echap within w_entete_cde_rc
end type
type uo_message from uo_mise_a_jour_messages within w_entete_cde_rc
end type
type pb_text_def from u_pba_texte_defaut within w_entete_cde_rc
end type
end forward

global type w_entete_cde_rc from w_a_mas_det
string tag = "ENTETE_CDE_CPLT"
integer x = 0
integer y = 0
integer width = 3177
integer height = 2336
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = child!
windowstate windowstate = maximized!
long backcolor = 12632256
boolean ib_statusbar_visible = true
event ue_listes pbm_custom48
event ue_workflow ( )
event ue_texte_defaut ( unsignedlong wparam,  long lparam )
pb_ok pb_ok
pb_echap pb_echap
uo_message uo_message
pb_text_def pb_text_def
end type
global w_entete_cde_rc w_entete_cde_rc

type variables
nv_commande_object i_nv_commande_object
n_tooltip_mgr itooltip

String is_fenetre_origine
Boolean  ib_anomalie = false
end variables

event ue_listes;/* <DESC>
    Affichage des listes correspondantes au champ en cours de saisie et
	 ceci lors de l'activation de la touche F2. 
	 En Retour affichage de l'intitulé du code sélectionné.
</DESC> */ 
// =========================================
// Listes proposées quand F2 sur une colonne
// -----------------------------------------
// - Liste des codes fonction client
// - Liste des codes nature client
// - Liste des clients grossistes
// =========================================
// DECLARATION DES VARIABLES LOCALES
String		s_colonne
Str_pass		str_work

s_colonne = dw_1.GetColumnName()
str_work.s[1] = s_colonne
str_work.s[2] = OPTION_CLIENT
str_work.s[3] = BLANK

str_work = g_nv_liste_manager.get_list_of_column(str_work)
	
// cette action provient de la fenetre de selection appelée
// prédemment - click sur cancel
if str_work.s_action =  ACTION_CANCEL then
	return
end if

// Mise à jour de la datawindow correspondante à la liste selectionnee

if s_colonne = DBNAME_CODE_INCOTERM then
	dw_1.SetItem (1, s_colonne, str_work.s[1])
else
	dw_1.SetItem (1, s_colonne, str_work.s[1])
	dw_1.SetItem (1, str_work.s[3], str_work.s[2])			
end if



end event

event ue_workflow();/* <DESC>
    Cet evenement est appelé lors de la sélection d'une option dans le menu alors que cette
	 fenetre est la fenetre active et va lancer le workflow manager pour effectuer l'enchainement.
</DESC> */
i_str_pass.po[2] = i_nv_commande_object
i_str_pass.s[2] = i_nv_commande_object.fu_get_numero_cde()

if is_fenetre_origine = BLANK then
	g_s_fenetre_destination = FENETRE_LIGNE_CDE
else	
	g_s_fenetre_destination = is_fenetre_origine
end if

g_nv_workflow_manager.fu_check_workflow(FENETRE_ENTETE_CDE_RC, i_str_pass)
close(this)
end event

event ue_texte_defaut(unsignedlong wparam, long lparam);/* <DESC>
       Permet de remettre à jour les textes de la commande à partir des textes du client donneur d'ordre
	 et du client livré (annule et remplace) et ceci après sauvegarde des modifications
   </DESC> */
TriggerEvent ("ue_save")

if  not ib_anomalie then
	i_nv_commande_object.fu_update_message(true)
	uo_message.fu_refresh()
end if
end event

event ue_ok;/* <DESC>
    Effectue la validation de la saisie des données
   Si la validation est correcte et après mise à jour	de l'entête de commande 
	retour soit à la liste des commandes ou sinon à la saisie des lignes
   </DESC> */
// OVERRIDE SCRIPT ANCESTOR
SetPointer  (HourGLass!)
g_nv_trace.fu_write_trace( this.classname( ), "ue_ok_bsave",i_str_pass.s[01], i_str_pass.s[02], this.classname( ) , g_s_fenetre_destination)
This.TriggerEvent ("ue_save")

// INITIALISATION DES ZONES DE LA STRUCTURE
IF  not i_b_update_status THEN
	return
end if

g_nv_trace.fu_write_trace( this.classname( ), "ue_ok_asave",i_str_pass.s[01], i_str_pass.s[02], this.classname( ) , g_s_fenetre_destination)
// OUVERTURE DE LA FENÊTRE SUIVANTE
i_str_pass.s_action 	= "O"
if is_fenetre_origine = BLANK then
	g_s_fenetre_destination = FENETRE_LIGNE_CDE
else	
	g_s_fenetre_destination = is_fenetre_origine
end if

triggerEvent("ue_workflow")
SetPointer  (Arrow!)
close(this)

end event

event ue_presave;call super::ue_presave;/* <DESC>
     Validation de la saisie des données
	 Controle des données obligatoires :
	     Echeance,Date prix, Mode transport, incoterm
	 Controle de la validité des codes
	     Echeance, mode transport, incoterm
	 Controle des informations complementaires EDI
	 	Si la date de livraison au plus tot alimentée, doit etre supérieure à la date du jour
		Si la date de livraison au plus tart alimentee, doit etre supérieure à la date du jour et à la date au plus tot
   </DESC> */
str_pass l_str_work
Date   d_date_liv_tot
Date   d_date_liv_tart
Date   d_date_jour

dw_1.AcceptText ()

// ===================================
// CONTRÔLES CHAMPS OBLIGATOIRES
// ===================================
IF IsNull(trim(dw_1.getItemString(1, DBNAME_CODE_ECHEANCE))) or &
	trim(dw_1.getItemString(1, DBNAME_CODE_ECHEANCE)) = DONNEE_VIDE then
		MessageBox (this.title,g_nv_traduction.get_traduction(ECHEANCE_OBLIGATOIRE) + g_nv_traduction.get_traduction(OBTENIR_LISTE), StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_CODE_ECHEANCE)
		Message.ReturnValue = -1
		RETURN	
end if
IF IsNull(string(dw_1.getItemDateTime(1, DBNAME_DATE_PRIX))) then
		MessageBox (this.title,g_nv_traduction.get_traduction(DATE_PRIX_OBLIGATOIRE), StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_DATE_PRIX)
		Message.ReturnValue = -1
		RETURN	
end if
IF IsNull(string(dw_1.getItemString(1, DBNAME_CODE_MODE_EXP))) then
		MessageBox (this.title,g_nv_traduction.get_traduction(MODE_EXPEDITION_OBLIGATOIRE) + g_nv_traduction.get_traduction(OBTENIR_LISTE), StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_CODE_MODE_EXP)
		Message.ReturnValue = -1
		RETURN	
end if
IF IsNull(string(dw_1.getItemString(1, DBNAME_CODE_INCOTERM))) then
		MessageBox (this.title,g_nv_traduction.get_traduction(INCOTERM_OBLIGATOIRE) + g_nv_traduction.get_traduction(OBTENIR_LISTE), StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_CODE_INCOTERM)
		Message.ReturnValue = -1
		RETURN	
end if
//
// ================================
// CONTROLES D'EXISTENCE DES CODES
// ================================
//
nv_control_manager nv_check_value 
nv_check_value = CREATE nv_control_manager

// Controle du code echeance
l_str_work.s[1] = dw_1.GetItemString (1, DBNAME_CODE_ECHEANCE)
l_str_work.s[2] = BLANK
l_str_work = nv_check_value.is_echeance_valide (l_str_work)
if not l_str_work.b[1] then
	MessageBox (This.title,g_nv_traduction.get_traduction(ECHEANCE_INEXISTANTE) + g_nv_traduction.get_traduction(OBTENIR_LISTE),StopSign!,Ok!,1)
	dw_1.SetColumn (DBNAME_CODE_ECHEANCE)
	dw_1.SetFocus ()
	Message.ReturnValue = -1
	RETURN
end if	
dw_1.setItem(1,DBNAME_CODE_ECHEANCE_INTITULE, l_str_work.s[2])

// Controle du mode d'expedition
l_str_work.s[1] = dw_1.GetItemString (1, DBNAME_CODE_MODE_EXP)
l_str_work.s[2] = BLANK
l_str_work = nv_check_value.is_mode_expedition_valide (l_str_work)
if not l_str_work.b[1] then
	MessageBox (This.title,g_nv_traduction.get_traduction(MODE_EXPEDITION_INEXISTANT) + g_nv_traduction.get_traduction(OBTENIR_LISTE),StopSign!,Ok!,1)
	dw_1.SetColumn (DBNAME_CODE_MODE_EXP)
	dw_1.SetFocus ()
	Message.ReturnValue = -1
	RETURN
end if	
dw_1.setItem(1,DBNAME_CODE_MODE_EXP_INTITULE, l_str_work.s[2])

// Controle de l'incoterm
l_str_work.s[1] = dw_1.GetItemString (1, DBNAME_CODE_INCOTERM)
l_str_work.s[2] = BLANK
l_str_work = nv_check_value.is_incoterm_valide (l_str_work)
if not l_str_work.b[1] then
	MessageBox (This.title,g_nv_traduction.get_traduction(INCOTERM_INEXISTANT) + g_nv_traduction.get_traduction(OBTENIR_LISTE),StopSign!,Ok!,1)
	dw_1.SetColumn (DBNAME_CODE_INCOTERM)
	dw_1.SetFocus ()
	Message.ReturnValue = -1
	RETURN
end if	

/* ==========================================
     Controle des informations complementaires EDI
    ========================================== */
d_date_liv_tot  = Date (dw_1.GetItemDateTime(1,DBNAME_EDIT_DTE_LIVTOT))
d_date_liv_tart  = Date (dw_1.GetItemDateTime(1,DBNAME_EDIT_DTE_LIVTART))
d_date_jour	    = Today()

/* controle de la de livraison au plus tot */
IF not IsNull (String(d_date_liv_tot)) THEN
	if not nv_check_value.is_date_valide(string (d_date_liv_tot)) then
		messagebox (this.title,g_nv_traduction.get_traduction(DATE_LIVRAISON_ERRONEE3),StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_EDIT_DTE_LIVTOT)
		Message.ReturnValue = -1
	// La date de livraison saisie doit être > à la date de saisie de commande
     ElseIF d_date_liv_tot < d_date_jour THEN
		messagebox (this.title,g_nv_traduction.get_traduction(DATE_LIVRAISON_ERRONEE),StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_EDIT_DTE_LIVTOT)
		Message.ReturnValue = -1
		RETURN
	END IF
END IF
/* controle de la de livraison au plus tard*/
IF not IsNull (String(d_date_liv_tart)) THEN
	if not nv_check_value.is_date_valide(string (d_date_liv_tart)) then
		messagebox (this.title,g_nv_traduction.get_traduction(DATE_LIVRAISON_ERRONEE3),StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_EDIT_DTE_LIVTART)
		Message.ReturnValue = -1
	// La date de livraison saisie doit être > à la date de saisie de commande
     ElseIF d_date_liv_tart < d_date_liv_tot THEN
		messagebox (this.title,g_nv_traduction.get_traduction(DATE_LIVRAISON_ERRONEE4),StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_EDIT_DTE_LIVTART)
		Message.ReturnValue = -1
		RETURN
	END IF
END IF

destroy nv_check_value

end event

event ue_cancel;/* <DESC>
      Permet de quitter la fenetre aprés avoir initialisé la structure de l'object commande
	 et permettre le retour soit sur la liste des commandes  ou soit sur la saisie des lignes
	 de commande
   </DESC> */
i_b_canceled = TRUE
i_str_pass.s_action 	= "O"
triggerEvent("ue_workflow")


end event

event ue_init;call super::ue_init;/* <DESC>
      Initialisation des datawindows et initialisation de l'objet de gestion des textes associés 
	 à la commande  en verifiant l'existence des différents textes pour affichage de la première ligne 
	 sur chacune des lignes de la fenêtre.
	 Si la commande contient des lignes de commande sur promotion,  le paiement expedition n'est
	 pas modifiable.
	 Controle si le regroupement ordre est modifiable ou non et est dépendant du type de la commande
   </DESC> */
setpointer (Hourglass!)

dw_mas.SetRedraw (False)
dw_1.SetRedraw (False)
g_nv_trace.fu_write_trace( this.classname( ), "ue_ini",i_str_pass.s[01], i_str_pass.s[02], this.classname( ) , g_s_fenetre_destination)
i_nv_commande_object = i_str_pass.po[2] 

if dw_mas.Retrieve(i_nv_commande_object.fu_get_numero_cde(),g_nv_come9par.get_code_langue()) = -1 then
	f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
end if

if dw_1.Retrieve(i_nv_commande_object.fu_get_numero_cde(),g_nv_come9par.get_code_langue()) = -1 then
	f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)		
end if

nv_client_object lnv_client
lnv_client = i_str_pass.po[1]

dw_mas.setItem(1,"alerte",lnv_client.fu_get_alerte( ))

dw_mas.SetRedraw (True)
dw_1.SetRedraw (True)

str_pass l_str_work
l_str_work.s[1] = i_nv_commande_object.fu_get_numero_cde()
l_str_work.s[2] = DBNAME_NUM_CDE
l_str_work.s[3] = "come9086"
l_str_work.s[4] = i_nv_commande_object.fu_get_code_langue()
		
l_str_work.s[5] = DBNAME_NUM_CDE
l_str_work.s[6] = "come9089"
l_str_work.s[7] = i_nv_commande_object.fu_get_code_langue_facture()

l_str_work.s[8] = DBNAME_NUM_CDE
l_str_work.s[9] = "come9087"
l_str_work.s[10] = i_nv_commande_object.fu_get_code_langue()

l_str_work.s[11] = DBNAME_NUM_CDE
l_str_work.s[12] = "come9090"
l_str_work.s[13] = i_nv_commande_object.fu_get_code_langue()

l_str_work.s[14] = DBNAME_NUM_CDE
l_str_work.s[15] = "come9088"
l_str_work.s[16] = i_nv_commande_object.fu_get_code_langue()

l_str_work.s[17] = "d_entete_saisie_cde"

l_str_work.s[18] = DBNAME_NUM_CDE
l_str_work.s[19] = "come9091"
l_str_work.s[20] =  i_nv_commande_object.fu_get_code_langue()

uo_message.fu_init_param(l_str_work)

if not i_nv_commande_object.fu_is_regroupement_cde_modifiable() then
	dw_1.setTaborder(DBNAME_REGROUPEMENT_ORDRE,0)
end if

if i_nv_commande_object.fu_is_commande_avec_ligne_promo() then
	dw_1.setTaborder(DBNAME_PAIEMENT_EXPEDITON,0)
end if

setpointer (Arrow!)
end event

event key;call super::key;/* <DESC>
      Permet de trapper les touches de fonction activées et de déclencher l'évènement associé
	à la touche.
	  F2 = Affichage de la liste des codes - utilisée lors de la modification
	  F11 = Validation de la saisie
   </DESC> */
	IF KeyDown (KeyF11!) THEN
		This.PostEvent ("ue_ok")
	END IF

	IF KeyDown(KeyF2!) THEN
		This.PostEvent ("ue_listes")
	END IF
end event

event ue_save;/* <DESC>
      Lance le controle de la saisie des données et si le controle est correcte effectue la
	 mise à jour de l'entête de commande
	 Si tout est OK, validation de la commande
   </DESC> */
// OVERRIDE SCRIPT ANCESTOR

// DECLENCHEMENT DE L'EVENEMENT UE_PRESAVE
g_nv_trace.fu_write_trace( this.classname( ), "ue_save_presave",i_str_pass.s[01], i_str_pass.s[02], this.classname( ) , g_s_fenetre_destination)
This.TriggerEvent ("ue_presave")

IF message.returnvalue < 0 THEN
	ib_anomalie = true
	i_b_update_status = FALSE
	dw_1.SetFocus ()
	uo_message.fu_update_flag(false)
	RETURN
END IF

dw_1.update ()

i_b_update_status = true
ib_anomalie = false
g_nv_trace.fu_write_trace( this.classname( ), "ue_save_bvalide_cde",i_str_pass.s[01], i_str_pass.s[02], this.classname( ) , g_s_fenetre_destination)
i_nv_commande_object.fu_validation_cde_par_entete()
g_nv_trace.fu_write_trace( this.classname( ), "ue_save_avalide_cde",i_str_pass.s[01], i_str_pass.s[02], this.classname( ) , g_s_fenetre_destination)
i_str_pass.po[2] = i_nv_commande_object
uo_message.fu_update_flag(true)
g_nv_trace.fu_write_trace( this.classname( ), "ue_save_retrieve",i_str_pass.s[01], i_str_pass.s[02], this.classname( ) , g_s_fenetre_destination)
dw_mas.retrieve(i_nv_commande_object.fu_get_numero_cde(),g_nv_come9par.get_code_langue())

end event

event open;call super::open;   /* <DESC>
	   Initialisation de la fenetre d'origine 
	 </DESC> */
	is_fenetre_origine = g_nv_workflow_manager.fu_get_fenetre_origine()
end event

on w_entete_cde_rc.create
int iCurrent
call super::create
this.pb_ok=create pb_ok
this.pb_echap=create pb_echap
this.uo_message=create uo_message
this.pb_text_def=create pb_text_def
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_ok
this.Control[iCurrent+2]=this.pb_echap
this.Control[iCurrent+3]=this.uo_message
this.Control[iCurrent+4]=this.pb_text_def
end on

on w_entete_cde_rc.destroy
call super::destroy
destroy(this.pb_ok)
destroy(this.pb_echap)
destroy(this.uo_message)
destroy(this.pb_text_def)
end on

event closequery;// Overwrite
/* <DESC>
     Overwrite du script 
   </DESC> */
end event

event ue_close;/* <DESC>
      Permet de quitter la fenêtre aprés avoir initialisé la structure de l'object commande
	 et permettre le retour soit sur la liste des commandes  ou soit sur la saisie des lignes
	 de commande
   </DESC> */
i_b_canceled = TRUE
triggerEvent("ue_workflow")


end event

type uo_statusbar from w_a_mas_det`uo_statusbar within w_entete_cde_rc
end type

type dw_1 from w_a_mas_det`dw_1 within w_entete_cde_rc
string tag = "A_TRADUIRE"
integer x = 64
integer y = 592
integer width = 2949
integer height = 784
string dataobject = "d_entete_cde_rc"
borderstyle borderstyle = stylelowered!
end type

event dw_1::itemchanged;call super::itemchanged;
// LE CODE FACTURATION PASSE DE "0" A "1"
	IF This.GetColumnName () = "come90pa_codaefac" AND This.GetText () = "1" THEN
		This.SetItem (1, "come90pa_cptaeana", space (6))
	END IF
 
end event

event dw_1::we_dwnkey;call super::we_dwnkey;/* Appel de la fonction de controle des touches de fonction autorisées dans l'application
et de déclencher l'évènement KEY de la fenêtre qui contient le code correspond à la
touche.
*/
f_key(Parent)
end event

event dw_1::we_dwnprocessenter;/* Permet en utilisqnt la touche Entrée de passer d'une zone de saisie à l'autre en
fonction de l'ordre de tabulation 
*/
	Send(Handle(This),256,9,Long(0,0))
	Return 1
end event

type dw_mas from w_a_mas_det`dw_mas within w_entete_cde_rc
event mousemove pbm_mousemove
string tag = "A_TRADUIRE"
integer x = 55
integer y = 20
integer width = 2958
integer height = 536
integer taborder = 0
string dataobject = "d_entete_saisie_cde"
borderstyle borderstyle = styleshadowbox!
end type

event dw_mas::mousemove;if not isvalid(itooltip) then
	itooltip = create n_tooltip_mgr
end if
itooltip.of_mousemove_notify(parent, this, getobjectatpointer(), this.x + xpos, this.y + ypos)
end event

event dw_mas::we_dwnkey;call super::we_dwnkey;
//	f_activation_key () 
	f_key(Parent)
end event

type pb_ok from u_pba_ok within w_entete_cde_rc
integer x = 475
integer y = 2080
integer width = 334
integer taborder = 0
string text = "Valid.  F11"
boolean default = false
end type

type pb_echap from u_pba_echap within w_entete_cde_rc
integer x = 2121
integer y = 2072
integer taborder = 0
end type

type uo_message from uo_mise_a_jour_messages within w_entete_cde_rc
integer x = 416
integer y = 1440
integer height = 624
integer taborder = 30
boolean bringtotop = true
end type

on uo_message.destroy
call uo_mise_a_jour_messages::destroy
end on

type pb_text_def from u_pba_texte_defaut within w_entete_cde_rc
integer x = 1271
integer y = 2076
integer taborder = 0
boolean dragauto = false
boolean bringtotop = true
end type

