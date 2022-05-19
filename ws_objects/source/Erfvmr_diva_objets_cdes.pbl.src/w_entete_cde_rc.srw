$PBExportHeader$w_entete_cde_rc.srw
$PBExportComments$Affichage et mise à jour des données complémentaires de l'entête de commande. N'est accessible que par les assistantes clientèles
forward
global type w_entete_cde_rc from w_a_mas_det
end type
type pb_ok from u_pba_ok within w_entete_cde_rc
end type
type pb_echap from u_pba_echap within w_entete_cde_rc
end type
type pb_text_def from u_pba_texte_defaut within w_entete_cde_rc
end type
type st_message_instruction_cde from u_slea within w_entete_cde_rc
end type
type st_message_marquage_caisse from u_slea within w_entete_cde_rc
end type
type st_message_transitaire from u_slea within w_entete_cde_rc
end type
type st_message_transporteur from u_slea within w_entete_cde_rc
end type
type st_message_facture from u_slea within w_entete_cde_rc
end type
type st_message_bordereau from u_slea within w_entete_cde_rc
end type
type pb_instruction_cde from picturebutton within w_entete_cde_rc
end type
type marquage_t from statictext within w_entete_cde_rc
end type
type pb_marquage_caisse from picturebutton within w_entete_cde_rc
end type
type pb_transitaire from picturebutton within w_entete_cde_rc
end type
type pb_transporteur from picturebutton within w_entete_cde_rc
end type
type pb_facture from picturebutton within w_entete_cde_rc
end type
type pb_bordereau from picturebutton within w_entete_cde_rc
end type
type instruction_t from statictext within w_entete_cde_rc
end type
type transitaire_t from statictext within w_entete_cde_rc
end type
type transporteur_t from statictext within w_entete_cde_rc
end type
type facture_t from statictext within w_entete_cde_rc
end type
type bordereau_t from statictext within w_entete_cde_rc
end type
type rr_1 from roundrectangle within w_entete_cde_rc
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
pb_text_def pb_text_def
st_message_instruction_cde st_message_instruction_cde
st_message_marquage_caisse st_message_marquage_caisse
st_message_transitaire st_message_transitaire
st_message_transporteur st_message_transporteur
st_message_facture st_message_facture
st_message_bordereau st_message_bordereau
pb_instruction_cde pb_instruction_cde
marquage_t marquage_t
pb_marquage_caisse pb_marquage_caisse
pb_transitaire pb_transitaire
pb_transporteur pb_transporteur
pb_facture pb_facture
pb_bordereau pb_bordereau
instruction_t instruction_t
transitaire_t transitaire_t
transporteur_t transporteur_t
facture_t facture_t
bordereau_t bordereau_t
rr_1 rr_1
end type
global w_entete_cde_rc w_entete_cde_rc

type variables
nv_commande_object i_nv_commande_object
n_tooltip_mgr itooltip

String is_fenetre_origine
Boolean  ib_anomalie = false

end variables

forward prototypes
public subroutine fw_refresh_message ()
end prototypes

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
	fw_refresh_message()
end if
end event

public subroutine fw_refresh_message ();/* <DESC>
      Permet de rafraichir les premières lignes après mise à jour des textes
   </DESC> */
Datastore ds_message
ds_message = CREATE Datastore
ds_message.dataobject = "d_texte_come9086"
ds_message.setTransObject(sqlca)
ds_message.retrieve(i_nv_commande_object.fu_get_numero_cde())
st_message_bordereau.text = DONNEE_VIDE
if ds_message.RowCount() > 0 then
	st_message_bordereau.text = ds_message.getItemString(1, DBNAME_MESSAGE)
else 	
     ds_message.dataobject = "d_texte_come9086_complement"
     ds_message.setTransObject(sqlca) 
     ds_message.retrieve(i_nv_commande_object.fu_get_numero_cde())
	if ds_message.RowCount() > 0 then
	    st_message_bordereau.text = ds_message.getItemString(1, DBNAME_MESSAGE) 
     end if
end if

ds_message.dataobject = "d_texte_come9089"
ds_message.setTransObject(sqlca)
ds_message.retrieve(i_nv_commande_object.fu_get_numero_cde())
st_message_facture.text = DONNEE_VIDE
if ds_message.RowCount() > 0 then
	st_message_facture.text = ds_message.getItemString(1, DBNAME_MESSAGE)
end if

ds_message.dataobject = "d_texte_come9087"
ds_message.setTransObject(sqlca)
ds_message.retrieve(i_nv_commande_object.fu_get_numero_cde())
st_message_transporteur.text = DONNEE_VIDE
if ds_message.RowCount() > 0 then
	st_message_transporteur.text = ds_message.getItemString(1, DBNAME_MESSAGE)
else 	
     ds_message.dataobject = "d_texte_come9087_complement"
     ds_message.setTransObject(sqlca) 
     ds_message.retrieve(i_nv_commande_object.fu_get_numero_cde())
	if ds_message.RowCount() > 0 then
	    st_message_transporteur.text = ds_message.getItemString(1, DBNAME_MESSAGE) 
     end if	
end if

ds_message.dataobject = "d_texte_come9090" 
ds_message.setTransObject(sqlca)
ds_message.retrieve(i_nv_commande_object.fu_get_numero_cde())
st_message_transitaire.text = DONNEE_VIDE
if ds_message.RowCount() > 0 then
	st_message_transitaire.text = ds_message.getItemString(1, DBNAME_MESSAGE)
end if

ds_message.dataobject = "d_texte_come9088"
ds_message.setTransObject(sqlca)
ds_message.retrieve(i_nv_commande_object.fu_get_numero_cde())
st_message_marquage_caisse.text = DONNEE_VIDE
if ds_message.RowCount() > 0 then
	st_message_marquage_caisse.text = ds_message.getItemString(1, DBNAME_MESSAGE)
end if

ds_message.dataobject = "d_texte_come9091"
ds_message.setTransObject(sqlca)
ds_message.retrieve(i_nv_commande_object.fu_get_numero_cde())
st_message_instruction_cde.text = DONNEE_VIDE
if ds_message.RowCount() > 0 then
	st_message_instruction_cde.text = ds_message.getItemString(1, DBNAME_MESSAGE)
end if


end subroutine

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

if not i_nv_commande_object.fu_is_regroupement_cde_modifiable() then
	dw_1.setTaborder(DBNAME_REGROUPEMENT_ORDRE,0)
end if

//if i_nv_commande_object.fu_is_commande_avec_ligne_promo() then
	//dw_1.setTaborder(DBNAME_PAIEMENT_EXPEDITON,0)
//end if

fw_refresh_message()
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
	//uo_message.fu_update_flag(false)
	RETURN
END IF

dw_1.update ()

i_b_update_status = true

ib_anomalie = false
g_nv_trace.fu_write_trace( this.classname( ), "ue_save_bvalide_cde",i_str_pass.s[01], i_str_pass.s[02], this.classname( ) , g_s_fenetre_destination)
i_nv_commande_object.fu_validation_cde_par_entete()
g_nv_trace.fu_write_trace( this.classname( ), "ue_save_avalide_cde",i_str_pass.s[01], i_str_pass.s[02], this.classname( ) , g_s_fenetre_destination)
i_str_pass.po[2] = i_nv_commande_object
//uo_message.fu_update_flag(true)
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
this.pb_text_def=create pb_text_def
this.st_message_instruction_cde=create st_message_instruction_cde
this.st_message_marquage_caisse=create st_message_marquage_caisse
this.st_message_transitaire=create st_message_transitaire
this.st_message_transporteur=create st_message_transporteur
this.st_message_facture=create st_message_facture
this.st_message_bordereau=create st_message_bordereau
this.pb_instruction_cde=create pb_instruction_cde
this.marquage_t=create marquage_t
this.pb_marquage_caisse=create pb_marquage_caisse
this.pb_transitaire=create pb_transitaire
this.pb_transporteur=create pb_transporteur
this.pb_facture=create pb_facture
this.pb_bordereau=create pb_bordereau
this.instruction_t=create instruction_t
this.transitaire_t=create transitaire_t
this.transporteur_t=create transporteur_t
this.facture_t=create facture_t
this.bordereau_t=create bordereau_t
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_ok
this.Control[iCurrent+2]=this.pb_echap
this.Control[iCurrent+3]=this.pb_text_def
this.Control[iCurrent+4]=this.st_message_instruction_cde
this.Control[iCurrent+5]=this.st_message_marquage_caisse
this.Control[iCurrent+6]=this.st_message_transitaire
this.Control[iCurrent+7]=this.st_message_transporteur
this.Control[iCurrent+8]=this.st_message_facture
this.Control[iCurrent+9]=this.st_message_bordereau
this.Control[iCurrent+10]=this.pb_instruction_cde
this.Control[iCurrent+11]=this.marquage_t
this.Control[iCurrent+12]=this.pb_marquage_caisse
this.Control[iCurrent+13]=this.pb_transitaire
this.Control[iCurrent+14]=this.pb_transporteur
this.Control[iCurrent+15]=this.pb_facture
this.Control[iCurrent+16]=this.pb_bordereau
this.Control[iCurrent+17]=this.instruction_t
this.Control[iCurrent+18]=this.transitaire_t
this.Control[iCurrent+19]=this.transporteur_t
this.Control[iCurrent+20]=this.facture_t
this.Control[iCurrent+21]=this.bordereau_t
this.Control[iCurrent+22]=this.rr_1
end on

on w_entete_cde_rc.destroy
call super::destroy
destroy(this.pb_ok)
destroy(this.pb_echap)
destroy(this.pb_text_def)
destroy(this.st_message_instruction_cde)
destroy(this.st_message_marquage_caisse)
destroy(this.st_message_transitaire)
destroy(this.st_message_transporteur)
destroy(this.st_message_facture)
destroy(this.st_message_bordereau)
destroy(this.pb_instruction_cde)
destroy(this.marquage_t)
destroy(this.pb_marquage_caisse)
destroy(this.pb_transitaire)
destroy(this.pb_transporteur)
destroy(this.pb_facture)
destroy(this.pb_bordereau)
destroy(this.instruction_t)
destroy(this.transitaire_t)
destroy(this.transporteur_t)
destroy(this.facture_t)
destroy(this.bordereau_t)
destroy(this.rr_1)
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
integer y = 2144
integer width = 334
integer taborder = 0
string text = "Valid.  F11"
boolean default = false
string picturename = "c:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_echap from u_pba_echap within w_entete_cde_rc
integer x = 2121
integer y = 2136
integer taborder = 0
string picturename = "c:\appscir\Erfvmr_diva\Image\pbechap.bmp"
string disabledname = "AddWatch!"
end type

type pb_text_def from u_pba_texte_defaut within w_entete_cde_rc
integer x = 1271
integer y = 2140
integer taborder = 0
boolean dragauto = false
boolean bringtotop = true
string picturename = "c:\appscir\Erfvmr_diva\Image\pb_bon.bmp"
end type

type st_message_instruction_cde from u_slea within w_entete_cde_rc
integer x = 1024
integer y = 1952
integer width = 1335
integer height = 72
integer taborder = 10
boolean bringtotop = true
boolean border = false
boolean displayonly = true
borderstyle borderstyle = stylebox!
end type

type st_message_marquage_caisse from u_slea within w_entete_cde_rc
integer x = 1024
integer y = 1856
integer width = 1335
integer height = 72
integer taborder = 10
boolean bringtotop = true
boolean border = false
boolean displayonly = true
borderstyle borderstyle = stylebox!
end type

type st_message_transitaire from u_slea within w_entete_cde_rc
integer x = 1024
integer y = 1760
integer width = 1335
integer height = 72
integer taborder = 10
boolean bringtotop = true
boolean border = false
boolean displayonly = true
borderstyle borderstyle = stylebox!
end type

type st_message_transporteur from u_slea within w_entete_cde_rc
integer x = 1024
integer y = 1664
integer width = 1335
integer height = 72
integer taborder = 10
boolean bringtotop = true
boolean border = false
boolean displayonly = true
borderstyle borderstyle = stylebox!
end type

type st_message_facture from u_slea within w_entete_cde_rc
integer x = 1024
integer y = 1568
integer width = 1335
integer height = 72
integer taborder = 10
boolean bringtotop = true
boolean border = false
boolean displayonly = true
borderstyle borderstyle = stylebox!
end type

type st_message_bordereau from u_slea within w_entete_cde_rc
integer x = 1024
integer y = 1472
integer width = 1335
integer height = 72
integer taborder = 10
boolean bringtotop = true
boolean border = false
boolean displayonly = true
borderstyle borderstyle = stylebox!
end type

type pb_instruction_cde from picturebutton within w_entete_cde_rc
integer x = 2414
integer y = 1952
integer width = 101
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "none"
string picturename = "DosEdit!"
alignment htextalign = right!
end type

event clicked;
/*  Permet d'aller en mise à jour du texte en affichant la fenêtre de gestion
des textes mais uniquement après avoir effectuer la mise à jour de la fenêtre parent
en lancant l'évènemetn ue_save.
Aprés avoir mise à jour le texte, affichage de la première du texte saisi
*/
str_pass l_str_work

TriggerEvent ("ue_save")

    openwithParm(w_message_9091, i_str_pass)	
	l_str_work = Message.fnv_get_str_pass()	
//	st_message_instruction_cde.text = l_str_work.s[5]
fw_refresh_message()

end event

type marquage_t from statictext within w_entete_cde_rc
integer x = 439
integer y = 1888
integer width = 567
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 12632256
string text = "Marquage Caisse (LI)"
alignment alignment = right!
boolean focusrectangle = false
end type

type pb_marquage_caisse from picturebutton within w_entete_cde_rc
integer x = 2414
integer y = 1856
integer width = 101
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "none"
string picturename = "DosEdit!"
alignment htextalign = right!
end type

event clicked;
/*  Permet d'aller en mise à jour du texte en affichant la fenêtre de gestion
des textes mais uniquement après avoir effectuer la mise à jour de la fenêtre parent
en lancant l'évènemetn ue_save.
Aprés avoir mise à jour le texte, affichage de la première du texte saisi
*/
str_pass l_str_work

TriggerEvent ("ue_save")

    openwithParm(w_message_9088, i_str_pass)	
	l_str_work = Message.fnv_get_str_pass()	
//	st_message_marquage_caisse.text = l_str_work.s[5]
fw_refresh_message()

end event

type pb_transitaire from picturebutton within w_entete_cde_rc
integer x = 2414
integer y = 1760
integer width = 101
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "none"
string picturename = "DosEdit!"
alignment htextalign = right!
end type

event clicked;
/*  Permet d'aller en mise à jour du texte en affichant la fenêtre de gestion
des textes mais uniquement après avoir effectuer la mise à jour de la fenêtre parent
en lancant l'évènemetn ue_save.
Aprés avoir mise à jour le texte, affichage de la première du texte saisi
*/
str_pass l_str_work
TriggerEvent ("ue_save")

 openwithParm(w_message_9090, i_str_pass)	
 l_str_work = Message.fnv_get_str_pass()	
// st_message_transitaire.text = l_str_work.s[5]
fw_refresh_message()

end event

type pb_transporteur from picturebutton within w_entete_cde_rc
integer x = 2414
integer y = 1664
integer width = 101
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "none"
string picturename = "DosEdit!"
alignment htextalign = right!
end type

event clicked;
/*  Permet d'aller en mise à jour du texte en affichant la fenêtre de gestion
des textes mais uniquement après avoir effectuer la mise à jour de la fenêtre parent
en lancant l'évènemetn ue_save.
Aprés avoir mise à jour le texte, affichage de la première du texte saisi
*/
str_pass l_str_work

    openwithParm(w_message_9087, i_str_pass)	
	l_str_work = Message.fnv_get_str_pass()	
//	st_message_transporteur.text = l_str_work.s[5]
fw_refresh_message()

end event

type pb_facture from picturebutton within w_entete_cde_rc
integer x = 2414
integer y = 1568
integer width = 101
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "none"
string picturename = "DosEdit!"
alignment htextalign = right!
end type

event clicked;
/*  Permet d'aller en mise à jour du texte en affichant la fenêtre de gestion
des textes mais uniquement après avoir effectuer la mise à jour de la fenêtre parent
en lancant l'évènemetn ue_save.
Aprés avoir mise à jour le texte, affichage de la première du texte saisi
*/
str_pass l_str_work

    openwithParm(w_message_9089, i_str_pass)	
	l_str_work = Message.fnv_get_str_pass()	
//	st_message_facture.text = l_str_work.s[5]
fw_refresh_message()


end event

type pb_bordereau from picturebutton within w_entete_cde_rc
integer x = 2414
integer y = 1472
integer width = 105
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "none"
string picturename = "DosEdit!"
alignment htextalign = right!
end type

event clicked;
/*  Permet d'aller en mise à jour du texte en affichant la fenêtre de gestion
des textes mais uniquement après avoir effectuer la mise à jour de la fenêtre parent
en lancant l'évènemetn ue_save.
Aprés avoir mise à jour le texte, affichage de la première du texte saisi
*/
str_pass l_str_work

openwithParm(w_message_9086, i_str_pass)	
l_str_work = Message.fnv_get_str_pass()	
//st_message_bordereau.text = l_str_work.s[5]
fw_refresh_message()


end event

type instruction_t from statictext within w_entete_cde_rc
integer x = 439
integer y = 1952
integer width = 581
integer height = 112
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 12632256
string text = "Instruction traitement Cde (DO)"
alignment alignment = right!
boolean focusrectangle = false
end type

type transitaire_t from statictext within w_entete_cde_rc
integer x = 439
integer y = 1760
integer width = 576
integer height = 96
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 12632256
string text = "Transitaire (DO)"
alignment alignment = right!
boolean focusrectangle = false
end type

type transporteur_t from statictext within w_entete_cde_rc
integer x = 439
integer y = 1664
integer width = 553
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 12632256
string text = "Transporteur (LI)"
alignment alignment = right!
boolean focusrectangle = false
end type

type facture_t from statictext within w_entete_cde_rc
integer x = 658
integer y = 1568
integer width = 343
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 12632256
string text = "Facture (FA)"
alignment alignment = right!
boolean focusrectangle = false
end type

type bordereau_t from statictext within w_entete_cde_rc
integer x = 512
integer y = 1472
integer width = 498
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 12632256
string text = "Bordereau (DO)"
alignment alignment = right!
boolean focusrectangle = false
boolean righttoleft = true
end type

type rr_1 from roundrectangle within w_entete_cde_rc
integer linethickness = 4
long fillcolor = 12632256
integer x = 402
integer y = 1440
integer width = 2158
integer height = 640
integer cornerheight = 40
integer cornerwidth = 46
end type

