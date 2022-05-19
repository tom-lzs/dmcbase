$PBExportHeader$w_fiche_client_principale.srw
$PBExportComments$Permet l'affichage de la fiche du client donneur d'ordre ou interne
forward
global type w_fiche_client_principale from w_a_mas_det
end type
type gb_option from groupbox within w_fiche_client_principale
end type
type pb_changer_client from u_pba_changer within w_fiche_client_principale
end type
type pb_ok from u_pba_ok within w_fiche_client_principale
end type
type pb_sai_cmde from u_pba_sai_cmde within w_fiche_client_principale
end type
type pb_cpt_client from u_pba_cpt_client within w_fiche_client_principale
end type
type pb_reliquat from u_pba_reliquat within w_fiche_client_principale
end type
type pb_echap from u_pba_echap within w_fiche_client_principale
end type
type pb_modifier from u_pba_modifier within w_fiche_client_principale
end type
type uo_fiche_comptable from u_dw_comptabilite_client within w_fiche_client_principale
end type
type rb_qte from u_rba within w_fiche_client_principale
end type
type rb_ca from u_rba within w_fiche_client_principale
end type
type sel_activite from statictext within w_fiche_client_principale
end type
type dw_activite from u_dwa within w_fiche_client_principale
end type
type pb_impression from u_pba within w_fiche_client_principale
end type
type dw_comparatif_ca from u_dw_q within w_fiche_client_principale
end type
type dw_suivi_promo from u_dw_q within w_fiche_client_principale
end type
type dw_qte_objectif from u_dw_q within w_fiche_client_principale
end type
type dw_ca_objectif from u_dw_q within w_fiche_client_principale
end type
type dw_onglet from u_dw_tab_bleu within w_fiche_client_principale
end type
type sle_alerte from u_slea within w_fiche_client_principale
end type
end forward

global type w_fiche_client_principale from w_a_mas_det
string tag = "FICHE_CLIENT"
integer x = 0
integer y = 0
integer width = 3694
integer height = 2480
boolean minbox = false
boolean maxbox = false
long backcolor = 12632256
boolean toolbarvisible = false
boolean ib_statusbar_visible = true
event ue_planning pbm_custom41
event ue_modifier pbm_custom45
event ue_reliquat pbm_custom47
event ue_cpt_client pbm_custom50
event ue_changer pbm_custom51
event ue_ligne_cde pbm_custom59
event ue_listes pbm_custom64
event ue_workflow ( )
gb_option gb_option
pb_changer_client pb_changer_client
pb_ok pb_ok
pb_sai_cmde pb_sai_cmde
pb_cpt_client pb_cpt_client
pb_reliquat pb_reliquat
pb_echap pb_echap
pb_modifier pb_modifier
uo_fiche_comptable uo_fiche_comptable
rb_qte rb_qte
rb_ca rb_ca
sel_activite sel_activite
dw_activite dw_activite
pb_impression pb_impression
dw_comparatif_ca dw_comparatif_ca
dw_suivi_promo dw_suivi_promo
dw_qte_objectif dw_qte_objectif
dw_ca_objectif dw_ca_objectif
dw_onglet dw_onglet
sle_alerte sle_alerte
end type
global w_fiche_client_principale w_fiche_client_principale

type variables

// Indique quelle DTW a le focus
DataWindow	i_dw_focus

// Indique que les modif sont en cours
Boolean		i_b_modif

nv_Datastore   i_ds_log_maj
String          is_dw_focus_active

Constant string 	is_fiche_client = "FICHE_CLIENT"
Constant string is_ca_par_activite = "CA_PAR_ACTIVITE"
Constant string is_ca_par_art_obj  = "CA_PAR_ARTICLE_OBJ"
Constant string is_suivi_promo = "SUIVI_PROMO"
Constant string is_fiche_compta = "FICHE_COMPTA"


end variables

forward prototypes
public subroutine fw_retrieve_fiche_client ()
public subroutine fw_retrieve_fiche_cpta ()
public subroutine fw_retrieve_mas ()
public subroutine fw_retrieve_ca_art_obj ()
public subroutine fw_is_client_donneur_ordre ()
public function any fw_selection_client (any as_structure)
public subroutine fw_retrieve_ca ()
public subroutine fw_retrieve_suivi_promo ()
public subroutine fw_affiche_alerte ()
end prototypes

event ue_modifier;/* <DESC>
    Affichage de la fenêtre en mode modification de données.
	 Positionnement de la tabulation sur les zones en mises à jour. Le déverrouillage des champs est effectué dans la datawindow apès
	 avoir mis à jour la zone flag_modif à 'M'. ceci a pour effet de rafraichir la datawindow et donc d'appliquer les règles de déverrouillage
	 des zones.
	 Recherche si existence d'un enregistrement dans la table des Logs client pour ce client
	 Si existence de données ,affichage de ces données de la log étant différentes de celle de la fiche client en rouge.
</DESC> */
Datastore ds_log_maj

// GESTION DES AFFICHAGE DES BOUTONS
pb_modifier.visible = FALSE
pb_ok.visible = TRUE

// CHAMPS MODIFIABLES
dw_mas.SetTabOrder (DBNAME_NATURE_CLIENT, 10)
dw_mas.SetTabOrder (DBNAME_CLIENT_NOM_COMPLET1, 20)
dw_mas.SetTabOrder (DBNAME_CLIENT_ADRESSE_RUE, 30)
dw_mas.SetTabOrder (DBNAME_CLIENT_ADRESSE_RUE_COMPLEMENTAIRE, 40)
dw_mas.SetTabOrder (DBNAME_CLIENT_CODE_POSTAL, 50)
dw_mas.SetTabOrder (DBNAME_CLIENT_BUREAU_DISTRIBUTEUR, 60)

dw_mas.SetTabOrder (DBNAME_CLIENT_REGION, 70)	
dw_mas.SetTabOrder (DBNAME_PAYS, 80)	

dw_mas.SetTabOrder (DBNAME_CLIENT_TELEPHONE, 90)
dw_mas.SetTabOrder (DBNAME_CLIENT_FAX, 100)
dw_mas.SetTabOrder (DBNAME_CLIENT_TELEPHONE_PORTABLE, 110)	
dw_mas.SetTabOrder (DBNAME_CLIENT_EMAIL, 120)	

dw_1.SetTabOrder (DBNAME_FONCTION, 10)
dw_1.SetTabOrder (DBNAME_BANQUE, 20)
dw_1.SetTabOrder (DBNAME_BANQUE_RIB, 30)
dw_1.SetTabOrder (DBNAME_CODE_MANQUANT, 40)

dw_1.SetItem     (1,"flag_modif","M")
dw_mas.SetItem   (1,"flag_modif","M")

// Si l'on vient de la fenetre de validation des modifs client faite par le 
// représentant , on alimente les infos modifiées dans la datawindow pour l'assistante
// puisse voir les mofigications effectuées
If g_s_valide <> ORIGINE_VALIDATION_CLIENT then
	goto suite
end if

// Initialisation DataStore
ds_log_maj = CREATE DATASTORE
ds_log_maj.dataobject = 'd_client_log_maj'
ds_log_maj.SetTransObject (SQLCA)

if ds_log_maj.Retrieve(i_str_pass.s[01]) = -1 then
	f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
end if

If ds_log_maj.GetItemString(1,DBNAME_CLIENT_NOM_COMPLET1) <> dw_mas.GetItemString(1,DBNAME_CLIENT_NOM_COMPLET1) &
	And (Not ISNull (ds_log_maj.GetItemString(1,DBNAME_CLIENT_NOM_COMPLET1))											&
	And  ds_log_maj.GetItemString(1,DBNAME_CLIENT_NOM_COMPLET1) <> DONNEE_VIDE	)	then
	dw_mas.SetItem(1,DBNAME_CLIENT_NOM_COMPLET1,ds_log_maj.GetItemString(1,DBNAME_CLIENT_NOM_COMPLET1))
	dw_mas.Modify ( DBNAME_CLIENT_NOM_COMPLET1 + ".Color='" + String(RGB(255, 0, 0)) + "'" )		
End if

If ds_log_maj.GetItemString(1,DBNAME_NATURE_CLIENT) <> dw_mas.GetItemString(1,DBNAME_NATURE_CLIENT) &
	And (Not ISNull (ds_log_maj.GetItemString(1,DBNAME_NATURE_CLIENT))											&
	And  ds_log_maj.GetItemString(1,DBNAME_NATURE_CLIENT) <> DONNEE_VIDE	)	then
	dw_mas.SetItem(1,DBNAME_NATURE_CLIENT,ds_log_maj.GetItemString(1,DBNAME_NATURE_CLIENT))
	dw_mas.Modify ( DBNAME_NATURE_CLIENT + ".Color='" + String(RGB(255, 0, 0)) + "'" )			
End if

If ds_log_maj.GetItemString(1,DBNAME_CLIENT_ADRESSE_RUE) <> dw_mas.GetItemString(1,DBNAME_CLIENT_ADRESSE_RUE) &
	And (Not ISNull (ds_log_maj.GetItemString(1,DBNAME_CLIENT_ADRESSE_RUE))										  &
	And  ds_log_maj.GetItemString(1,DBNAME_CLIENT_ADRESSE_RUE) <> DONNEE_VIDE	)then
	dw_mas.SetItem(1,DBNAME_CLIENT_ADRESSE_RUE,ds_log_maj.GetItemString(1,DBNAME_CLIENT_ADRESSE_RUE))
	dw_mas.Modify ( DBNAME_CLIENT_ADRESSE_RUE + ".Color='" + String(RGB(255, 0, 0)) + "'" )				
End if

If ds_log_maj.GetItemString(1,DBNAME_CLIENT_ADRESSE_RUE_COMPLEMENTAIRE) <> dw_mas.GetItemString(1,DBNAME_CLIENT_ADRESSE_RUE_COMPLEMENTAIRE) &
	And (Not ISNull (ds_log_maj.GetItemString(1,DBNAME_CLIENT_ADRESSE_RUE_COMPLEMENTAIRE))										  &
	And  ds_log_maj.GetItemString(1,DBNAME_CLIENT_ADRESSE_RUE_COMPLEMENTAIRE) <> DONNEE_VIDE)then
	dw_mas.SetItem(1,DBNAME_CLIENT_ADRESSE_RUE_COMPLEMENTAIRE,ds_log_maj.GetItemString(1,DBNAME_CLIENT_ADRESSE_RUE_COMPLEMENTAIRE))
	dw_mas.Modify ( DBNAME_CLIENT_ADRESSE_RUE_COMPLEMENTAIRE + ".Color='" + String(RGB(255, 0, 0)) + "'" )					
End if

If ds_log_maj.GetItemString(1,DBNAME_CLIENT_CODE_POSTAL) <> dw_mas.GetItemString(1,DBNAME_CLIENT_CODE_POSTAL) &
	And (Not ISNull (ds_log_maj.GetItemString(1,DBNAME_CLIENT_CODE_POSTAL))										  &
	And  ds_log_maj.GetItemString(1,DBNAME_CLIENT_CODE_POSTAL) <> DONNEE_VIDE	)then
	dw_mas.SetItem(1,DBNAME_CLIENT_CODE_POSTAL,ds_log_maj.GetItemString(1,DBNAME_CLIENT_CODE_POSTAL))
	dw_mas.Modify ( DBNAME_CLIENT_CODE_POSTAL + ".Color='" + String(RGB(255, 0, 0)) + "'" )						
End if

If ds_log_maj.GetItemString(1,DBNAME_CLIENT_BUREAU_DISTRIBUTEUR) <> dw_mas.GetItemString(1,DBNAME_CLIENT_BUREAU_DISTRIBUTEUR) &
	And (Not ISNull (ds_log_maj.GetItemString(1,DBNAME_CLIENT_BUREAU_DISTRIBUTEUR))										  &
	And  ds_log_maj.GetItemString(1,DBNAME_CLIENT_BUREAU_DISTRIBUTEUR) <> DONNEE_VIDE	)then
	dw_mas.SetItem(1,DBNAME_CLIENT_BUREAU_DISTRIBUTEUR,ds_log_maj.GetItemString(1,DBNAME_CLIENT_BUREAU_DISTRIBUTEUR))
	dw_mas.Modify ( DBNAME_CLIENT_BUREAU_DISTRIBUTEUR + ".Color='" + String(RGB(255, 0, 0)) + "'" )							
End if

If ds_log_maj.GetItemString(1,DBNAME_PAYS) <> dw_mas.GetItemString(1,DBNAME_PAYS) &
	And (Not ISNull (ds_log_maj.GetItemString(1,DBNAME_PAYS))										  &
	And  ds_log_maj.GetItemString(1,DBNAME_PAYS) <> DONNEE_VIDE	)then
	dw_mas.SetItem(1,DBNAME_PAYS,ds_log_maj.GetItemString(1,DBNAME_PAYS))
	dw_mas.Modify ( DBNAME_PAYS + ".Color='" + String(RGB(255, 0, 0)) + "'" )								
End if

If ds_log_maj.GetItemString(1,DBNAME_CLIENT_REGION) <> dw_mas.GetItemString(1,DBNAME_CLIENT_REGION) &
	And (Not ISNull (ds_log_maj.GetItemString(1,DBNAME_CLIENT_REGION))										  &
	And  ds_log_maj.GetItemString(1,DBNAME_CLIENT_REGION) <> DONNEE_VIDE	)then
	dw_mas.SetItem(1,DBNAME_CLIENT_REGION,ds_log_maj.GetItemString(1,DBNAME_CLIENT_REGION))
	dw_mas.Modify ( DBNAME_CLIENT_REGION + ".Color='" + String(RGB(255, 0, 0)) + "'" )									
End if

If ds_log_maj.GetItemString(1,DBNAME_CLIENT_TELEPHONE) <> dw_mas.GetItemString(1,DBNAME_CLIENT_TELEPHONE) &
	And (Not ISNull (ds_log_maj.GetItemString(1,DBNAME_CLIENT_TELEPHONE))										  &
	And  ds_log_maj.GetItemString(1,DBNAME_CLIENT_TELEPHONE) <> DONNEE_VIDE	)then
	dw_mas.SetItem(1,DBNAME_CLIENT_TELEPHONE,ds_log_maj.GetItemString(1,DBNAME_CLIENT_TELEPHONE))
	dw_mas.Modify ( DBNAME_CLIENT_TELEPHONE + ".Color='" + String(RGB(255, 0, 0)) + "'" )									
End if

If ds_log_maj.GetItemString(1,DBNAME_CLIENT_TELEPHONE_PORTABLE) <> dw_mas.GetItemString(1,DBNAME_CLIENT_TELEPHONE_PORTABLE) &
	And (Not ISNull (ds_log_maj.GetItemString(1,DBNAME_CLIENT_TELEPHONE_PORTABLE))										  &
	And  ds_log_maj.GetItemString(1,DBNAME_CLIENT_TELEPHONE_PORTABLE) <> DONNEE_VIDE	)then
	dw_mas.SetItem(1,DBNAME_CLIENT_TELEPHONE_PORTABLE,ds_log_maj.GetItemString(1,DBNAME_CLIENT_TELEPHONE_PORTABLE))
	dw_mas.Modify ( DBNAME_CLIENT_TELEPHONE_PORTABLE + ".Color='" + String(RGB(255, 0, 0)) + "'" )	
End if


If ds_log_maj.GetItemString(1,DBNAME_CLIENT_FAX) <> dw_mas.GetItemString(1,DBNAME_CLIENT_FAX) &
	And (Not ISNull (ds_log_maj.GetItemString(1,DBNAME_CLIENT_FAX))										  &
	And  ds_log_maj.GetItemString(1,DBNAME_CLIENT_FAX) <> DONNEE_VIDE	)	then
	dw_mas.SetItem(1,DBNAME_CLIENT_FAX,ds_log_maj.GetItemString(1,DBNAME_CLIENT_FAX))
	dw_mas.Modify ( DBNAME_CLIENT_FAX + ".Color='" + String(RGB(255, 0, 0)) + "'" )										
End if

If ds_log_maj.GetItemString(1,DBNAME_CLIENT_EMAIL) <> dw_mas.GetItemString(1,DBNAME_CLIENT_EMAIL) &
	And (Not ISNull (ds_log_maj.GetItemString(1,DBNAME_CLIENT_EMAIL))										  &
	And  ds_log_maj.GetItemString(1,DBNAME_CLIENT_EMAIL) <> DONNEE_VIDE	)	then
	dw_mas.SetItem(1,DBNAME_CLIENT_EMAIL,ds_log_maj.GetItemString(1,DBNAME_CLIENT_EMAIL))
	dw_mas.Modify ( DBNAME_CLIENT_EMAIL + ".Color='" + String(RGB(255, 0, 0)) + "'" )											
End if

If ds_log_maj.GetItemString(1,DBNAME_FONCTION) <> dw_1.GetItemString(1,DBNAME_FONCTION) &
	And (Not ISNull (ds_log_maj.GetItemString(1,DBNAME_FONCTION))										  &
	And  ds_log_maj.GetItemString(1,DBNAME_FONCTION) <> DONNEE_VIDE	)	then
	dw_1.SetItem(1,DBNAME_FONCTION,ds_log_maj.GetItemString(1,DBNAME_FONCTION))
	dw_1.Modify ( DBNAME_FONCTION + ".Color='" + String(RGB(255, 0, 0)) + "'" )												
End if

If ds_log_maj.GetItemString(1,DBNAME_BANQUE) <> dw_1.GetItemString(1,DBNAME_BANQUE) &
	And (Not ISNull (ds_log_maj.GetItemString(1,DBNAME_BANQUE))										  &
	And  ds_log_maj.GetItemString(1,DBNAME_BANQUE) <> DONNEE_VIDE	)	then
	dw_1.SetItem(1,DBNAME_BANQUE,ds_log_maj.GetItemString(1,DBNAME_BANQUE))
	dw_1.Modify ( DBNAME_BANQUE + ".Color='" + String(RGB(255, 0, 0)) + "'" )													
End if

If ds_log_maj.GetItemString(1,DBNAME_BANQUE_RIB) <> dw_1.GetItemString(1,DBNAME_BANQUE_RIB) &
	And (Not ISNull (ds_log_maj.GetItemString(1,DBNAME_BANQUE_RIB))										  &
	And  ds_log_maj.GetItemString(1,DBNAME_BANQUE_RIB) <> DONNEE_VIDE	)	then
	dw_1.SetItem(1,DBNAME_BANQUE_RIB,ds_log_maj.GetItemString(1,DBNAME_BANQUE_RIB))
	dw_1.SetItem(1,DBNAME_BANQUE_RIB,ds_log_maj.GetItemString(1,DBNAME_BANQUE))	
End if

suite:
dw_mas.setfocus()

i_b_modif = TRUE
end event

event ue_reliquat;/* <DESC>
    Affichage de la fenêtre  du carnet de commande du client en cours
</DESC> */
	i_str_pass.s_action = ACTION_OK
     g_s_fenetre_destination = FENETRE_CARNET_CDE_CLIENT
     triggerEvent("ue_workflow")	

end event

event ue_cpt_client;/* <DESC>
   Affichage de la fenêtre de la situation comptable du client
</DESC> */
	i_str_pass.s_action = ACTION_OK
     g_s_fenetre_destination = FENETRE_COMPTE_CLIENT
     triggerEvent("ue_workflow")	

end event

event ue_changer;/* <DESC> 
    Permet de changer de client en appelant la fenêtre de sélection
</DESC> */

Str_pass		str_work

str_work = fw_selection_client (str_work)
if str_work.s_action = ACTION_OK then
	i_str_pass = str_work
	fw_retrieve_mas ()
	fw_retrieve_fiche_client ()		
	dw_onglet.SetFocus ()
	dw_onglet.fu_set_active_tab (1)
	fw_is_client_donneur_ordre()
end if
		
end event

event ue_ligne_cde;/* <DESC>
    Affichage de la fenêtre de saisie des lignes de commande en mode création d'une nouvelle commande
</DESC> */

nv_commande_object l_commande
l_commande = CREATE nv_commande_object
i_str_pass.po[2] = l_commande	
i_str_pass.s[2] = DONNEE_VIDE

g_s_fenetre_destination = FENETRE_LIGNE_CDE
triggerEvent("ue_workflow")


end event

event ue_listes;/* <DESC>
    Affichage des listes correspondantes au champ en cours de saisie et
	 ceci lors de l'activation de la touche F2. Option accessible en modificaiton de client
	 va permettre d'afficher la liste de valeur des codes fonctions, natures, grossistes
</DESC> */ 

String		s_colonne
Str_pass		str_work


if not i_b_modif then
	return
end if 

s_colonne = i_dw_focus.GetColumnName()
str_work.s[1] = s_colonne
str_work.s[2] = BLANK
str_work.s[3] = i_str_pass.s[1]

str_work = g_nv_liste_manager.get_list_of_column(str_work)
	
// cette action provient de la fenetre de selection appelée
// prédemment - click sur cancel
if str_work.s_action =  ACTION_CANCEL then
	return
end if

// Mise à jour de la datawindow correspondante à la liste selectionnee
i_dw_focus.SetItem (1, s_colonne, str_work.s[1])
i_dw_focus.SetItem (1, str_work.s[3], str_work.s[2])		


end event

event ue_workflow();/* <DESC>
    Cet evenement est appelé lors de la sélection d'une option dans le menu alors que cette
	 fenêtre est la fenêtre active et va lancer le workflow manager pour effetuer l'enchainement.
</DESC> */
g_nv_workflow_manager.fu_check_workflow(FENETRE_CLIENT, i_str_pass)
close(this)
end event

public subroutine fw_retrieve_fiche_client ();/* <DESC>
    Effectuer l'extraction des données de la fiche principale lors de l'activation de
	 l'onglet correspondant
</DESC> */
// ==================================
// FICHE CLIENT PRINCIPALE
// ==================================
long	l_retrieve

  sel_activite.visible = false
  dw_activite.visible =false
  gb_option.visible = false
  rb_ca.visible =false 	 
  rb_qte.visible =false	 	
  dw_ca_objectif. visible = false
  dw_qte_objectif.visible = false
  dw_suivi_promo.visible = false	

// MODIFICATION EN COURS
	IF i_b_modif = TRUE THEN
		dw_1.SetFocus ()
		RETURN
	END IF

	pb_modifier.visible			= TRUE

// RETRIEVE DE LA DTW
	l_retrieve = dw_1.Retrieve (i_str_pass.s[1],g_nv_come9par.get_code_langue())
	if l_retrieve = -1 then
		f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
	end if

i_b_canceled = TRUE		
end subroutine

public subroutine fw_retrieve_fiche_cpta ();/* <DESC>
    Effectuer l'extraction des données de la fiche comptable lors de l'activation de
	 l'onglet correspondant
</DESC> */
    sel_activite.visible = false
    dw_activite.visible =false
    gb_option.visible = false
    rb_ca.visible =false 	 
    rb_qte.visible =false	 	
   dw_ca_objectif. visible = false
   dw_qte_objectif.visible = false
   dw_suivi_promo.visible = false	
// ====================================
// FICHE CLIENT COMPTABLE
// ===================================
	long	l_retrieve


// RETRIEVE DE LA DTW FICHE CLIENT COMPTABLE
	l_retrieve = uo_fiche_comptable.dw_1.Retrieve (i_str_pass.s[1],g_nv_come9par.get_code_langue())
	CHOOSE CASE l_retrieve
		CASE -1
			f_dmc_error (this.title +  BLANK +  DB_ERROR_MESSAGE)
		CASE 0
			uo_fiche_comptable.dw_1.InsertRow (0)
		CASE ELSE
	END CHOOSE

     
	l_retrieve = uo_fiche_comptable.dw_remise_gamme.Retrieve (i_str_pass.s[1])
end subroutine

public subroutine fw_retrieve_mas ();/* <DESC>
    Effectuer l'extraction de l'entête de la fiche client
</DESC> */
// =================================
// ENTETE DE LA FICHE CLIENT ONGLET
// =================================
	long	l_retrieve

// Retrieve de la fiche client
	l_retrieve = dw_mas.Retrieve (i_str_pass.s[1],g_nv_come9par.get_code_langue())

	if l_retrieve =  -1 then
		f_dmc_error (this.title +  BLANK +  DB_ERROR_MESSAGE)
	end if
	
i_b_canceled = TRUE
end subroutine

public subroutine fw_retrieve_ca_art_obj ();/* <DESC>
    Effectuer l'extraction des données Par Article objectif lors de l'activation de
	 l'onglet correspondant
</DESC> */
    dw_suivi_promo.visible =false
// ==================================================
// COMPARATIF DU C.A. ou Qte PAR ARTICLE OBJECTIF EN C.A 
// ==================================================
	long	l_retrieve
    sel_activite.visible = true
    dw_activite.visible = true
    gb_option.visible = true	 
    rb_ca.visible = true	 	 
    rb_qte.visible = true		 	 

// RETRIEVE DE LA DTW
  if rb_ca.checked then
    dw_ca_objectif.visible = true
    dw_qte_objectif.visible= false
	if	dw_ca_objectif.Retrieve(	i_str_pass.s[1], dw_activite.GetText ()) = -1 then
			f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
	end if
	
else
    dw_ca_objectif.visible = false	
    dw_qte_objectif.visible= true
	if	dw_qte_objectif.Retrieve(	i_str_pass.s[1], dw_activite.GetText ()) = -1 then
			f_dmc_error (this.title + BLANK +  DB_ERROR_MESSAGE)
	end if	 
end if
end subroutine

public subroutine fw_is_client_donneur_ordre ();/* <DESC>
    Controle si la nature du client permet la création de commande ou non. 
    Si ce n'est pas le cas le bouton sera caché.
</DESC> */
nv_client_object  l_client
l_client = i_str_pass.po[1]

if l_client.is_donneur_ordre() then
  	pb_sai_cmde.visible = true
else
	pb_sai_cmde.visible = false
end if

end subroutine

public function any fw_selection_client (any as_structure);/* <DESC>
    Effectuer l'appel de l'affichage de la fenêtre de sélection du client lors de l'activation de la demande
	 de changement de client
</DESC> */
return g_nv_workflow_manager.fu_ident_client(false, as_structure)


end function

public subroutine fw_retrieve_ca ();/* <DESC>
    Effectuer l'extraction des données Chiffre d'affaire lors de l'activation de
	 l'onglet correspondant
</DESC> */
  sel_activite.visible = false
  dw_activite.visible =false
  gb_option.visible = false
  rb_ca.visible =false 	 
  rb_qte.visible =false	 	
 dw_ca_objectif. visible = false
 dw_qte_objectif.visible = false
 dw_suivi_promo.visible = false
// RETRIEVE DE LA DTW
	if  dw_comparatif_ca.Retrieve (i_str_pass.s[1],g_nv_come9par.get_code_langue()) = -1 then
		f_dmc_error (this.title + & 
								 BLANK + &
								 DB_ERROR_MESSAGE)
	end if
end subroutine

public subroutine fw_retrieve_suivi_promo ();/* <DESC>
    Effectuer l'extraction des données pour consulter le suivi promotion lors de l'activation de
	 l'onglet correspondant
</DESC> */
     sel_activite.visible = false
    dw_activite.visible =false
    gb_option.visible = false
    rb_ca.visible =false 	 
    rb_qte.visible =false	 	
   dw_ca_objectif. visible = false
   dw_qte_objectif.visible = false
   dw_suivi_promo.visible = true
	
// RETRIEVE DE LA DTW
	if  dw_suivi_promo.Retrieve (i_str_pass.s[1]) = -1 then
		f_dmc_error (this.title + & 
								 BLANK + &
								 DB_ERROR_MESSAGE)
	end if
end subroutine

public subroutine fw_affiche_alerte ();/* <DESC>
    Controle si la nature du client permet la création de commande ou non. 
    Si ce n'est pas le cas le bouton sera caché.
</DESC> */
nv_client_object  l_client
l_client = i_str_pass.po[1]

sle_alerte.text = l_client.fu_get_alerte()


end subroutine

event ue_presave;/* <DESC>
     Validation de la mise a jour.
	 
	 CONTRÔLE DES CHAMPS SUIVANTS
		 - Existence du code nature
		 - Existence du code fonction
		 - Existence des codes grossistes
		 - Numéricité du nombre de visite
	Controle si existence d'un enregistrement dans la table des logs pour ce client. Si tel est le cas, mise à jour de cet
	enregistrement avec les données mise à jour sinon création d'un enregistrement
</DESC> */

// DECLARATION DES VARIABLES LOCALES
	String		s_nataeclf , s_nataeclf_orig
	String		s_lnaaeclf
	String		s_fctaeclf , s_fctaeclf_orig
	String		s_lfcaeclf
	String		s_numaegrf
	String		s_codaemqt , s_codaemqt_orig
	String		s_libaemqt
	String		s_nomaeclf , s_nomaeclf_orig
	String		s_rueaeclf , s_rueaeclf_orig
	String		s_codaepos , s_codaepos_orig
	String		s_buraedis , s_buraedis_orig
	String		s_cpaaeclf , s_cpaaeclf_orig
	String		s_numaetel , s_numaetel_orig
	String		s_numaetlx , s_numaetlx_orig
	String		s_domaeban , s_domaeban_orig
	String		s_ribae000 , s_ribae000_orig
	String		s_pays	  , s_pays_orig
	String		s_region	  , s_region_orig	
	String		s_numaegsm , s_numaegsm_orig
	String		s_adraeema , s_adraeema_orig	

	Integer		i_ctrl_grossiste = 0
	Decimal		dec_nbraevis
	Boolean		b_maj = False
	Str_pass		l_str_pass

	dw_mas.AcceptText ()
	dw_1.AcceptText ()

// Initialisation DataStore
	i_ds_log_maj = CREATE nv_Datastore
	i_ds_log_maj.dataobject = 'd_client_log_maj'
	i_ds_log_maj.SetTransObject (SQLCA)

// CONTRÔLE DES CHAMPS OBLIGATOIRES
// Information de la dtw dw_mas
	s_nomaeclf = trim(dw_mas.GetItemString (1, DBNAME_CLIENT_NOM_COMPLET1))
	IF len(s_nomaeclf)  = 0  or IsNull (s_nomaeclf) THEN
		MessageBox (this.title, g_nv_traduction.get_traduction(NOM_CLIENT_OBLIGATOIRE),StopSign!,Ok!,1)
		dw_mas.SetFocus ()
		dw_mas.SetColumn (DBNAME_CLIENT_NOM_COMPLET1)
		Message.ReturnValue = -1
		RETURN
	END IF

	s_rueaeclf = trim(dw_mas.GetItemString (1, DBNAME_CLIENT_ADRESSE_RUE))
	IF s_rueaeclf = DONNEE_VIDE or IsNull (s_rueaeclf) THEN
		MessageBox (this.title, g_nv_traduction.get_traduction(ADRESSE_OBLIGATOIRE) ,StopSign!,Ok!,1)
		dw_mas.SetFocus ()
		dw_mas.SetColumn (DBNAME_CLIENT_ADRESSE_RUE)
		Message.ReturnValue = -1
		RETURN
	END IF

	s_codaepos = trim(dw_mas.GetItemString (1, DBNAME_CLIENT_CODE_POSTAL))
	IF s_codaepos = DONNEE_VIDE or IsNull (s_codaepos) THEN
		MessageBox (this.title, g_nv_traduction.get_traduction(CODE_POSTAL_OBLIGATOIRE) ,StopSign!,Ok!,1)
		dw_mas.SetFocus ()
		dw_mas.SetColumn (DBNAME_CLIENT_CODE_POSTAL)
		Message.ReturnValue = -1
		RETURN
	END IF

	s_buraedis = trim(dw_mas.GetItemString (1, DBNAME_CLIENT_BUREAU_DISTRIBUTEUR))
	IF s_buraedis = DONNEE_VIDE or IsNull (s_buraedis) THEN
		MessageBox (this.title,g_nv_traduction.get_traduction( VILLE_OBLIGATOIRE) ,StopSign!,Ok!,1)
		dw_mas.SetFocus ()
		dw_mas.SetColumn (DBNAME_CLIENT_BUREAU_DISTRIBUTEUR)
		Message.ReturnValue = -1
		RETURN
	END IF

	s_region = trim(dw_mas.GetItemString (1, DBNAME_CLIENT_REGION))
	IF s_region = DONNEE_VIDE or IsNull (s_region) THEN
		MessageBox (this.title, g_nv_traduction.get_traduction(REGION_OBLIGATOIRE) ,StopSign!,Ok!,1)
		dw_mas.SetFocus ()
		dw_mas.SetColumn (DBNAME_CLIENT_REGION)
		Message.ReturnValue = -1
		RETURN
	END IF
	
	nv_control_manager nv_check_value 
	nv_check_value = CREATE nv_control_manager
	
// CONTRÔLE EXISTENCE DES CODES SAISIS
// Contrôle du code nature client
	l_str_pass.s[1] = dw_mas.GetItemString (1, DBNAME_NATURE_CLIENT)
	l_str_pass.s[2] = BLANK 
	l_str_pass = nv_check_value.is_nature_valide (l_str_pass)
	if not l_str_pass.b[1] then
		MessageBox (This.title,g_nv_traduction.get_traduction(NATURE_INEXISTANTE) + g_nv_traduction.get_traduction(OBTENIR_LISTE),StopSign!,Ok!,1)
		dw_mas.SetColumn (DBNAME_NATURE_CLIENT)
		dw_mas.SetFocus ()
		Message.ReturnValue = -1
		RETURN
	end if

	dw_mas.SetItem (1, DBNAME_NATURE_CLIENT_INTITULE, l_str_pass.s[2])
// Contrôle du code pays
	l_str_pass.s[1] = dw_mas.GetItemString (1, DBNAME_PAYS)
	l_str_pass.s[2] = BLANK 
	l_str_pass = nv_check_value.is_pays_valide (l_str_pass)
	if not l_str_pass.b[1] then
		MessageBox (This.title,g_nv_traduction.get_traduction(PAYS_INEXISTANT) + g_nv_traduction.get_traduction(OBTENIR_LISTE),StopSign!,Ok!,1)
		dw_mas.SetColumn (DBNAME_PAYS)
		dw_mas.SetFocus ()
		Message.ReturnValue = -1
		RETURN
	end if	
	
	dw_mas.SetItem (1, DBNAME_PAYS_INTITULE,l_str_pass.s[2])	
	
// Contrôle du code fonction client
	l_str_pass.s[1] = dw_1.GetItemString (1, DBNAME_FONCTION)
	l_str_pass.s[2] = BLANK 
	l_str_pass = nv_check_value.is_fonction_client_valide (l_str_pass) 
	if not l_str_pass.b[1] then
		MessageBox (This.title,g_nv_traduction.get_traduction(FONCTION_INEXISTANTE) + g_nv_traduction.get_traduction(OBTENIR_LISTE),StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_FONCTION)
		dw_1.SetFocus ()
		Message.ReturnValue = -1
		RETURN
	end if	

	dw_1.SetItem (1, DBNAME_FONCTION_INTITULE, 	l_str_pass.s[2])
	
	destroy nv_check_value
	
// INITIALISATION DES CHAMPS DE COME9040
	s_cpaaeclf = Trim(dw_mas.GetItemString(1, DBNAME_CLIENT_ADRESSE_RUE_COMPLEMENTAIRE))
	s_numaetel = Trim(dw_mas.GetItemString(1, DBNAME_CLIENT_TELEPHONE))
	s_numaetlx = Trim(dw_mas.GetItemString(1, DBNAME_CLIENT_FAX))

	s_numaegsm = Trim(dw_mas.GetItemString(1, DBNAME_CLIENT_TELEPHONE_PORTABLE))	
	s_adraeema = Trim(dw_mas.GetItemString(1, DBNAME_CLIENT_EMAIL))	
	
	s_ribae000 = Trim(dw_1.GetItemString  (1, DBNAME_BANQUE_RIB))	
	s_domaeban = Trim(dw_1.GetItemString  (1, DBNAME_BANQUE))	

	IF IsNull (s_cpaaeclf) THEN
		dw_mas.SetItem (1, DBNAME_CLIENT_ADRESSE_RUE_COMPLEMENTAIRE, space(01))
	END IF
	IF IsNull (s_numaetel) THEN
		dw_mas.SetItem (1, DBNAME_CLIENT_TELEPHONE, space(01))
	END IF
	IF IsNull (s_numaetlx) THEN
		dw_mas.SetItem (1, DBNAME_CLIENT_FAX, space(01))
	END IF
	IF IsNull (s_domaeban) THEN
		dw_1.SetItem (1, DBNAME_BANQUE, space(01))
	END IF
	IF IsNull (s_ribae000) THEN
		dw_1.SetItem (1, DBNAME_BANQUE_RIB, space(01))
	END IF
	IF IsNull (s_numaegsm) THEN
		dw_mas.SetItem (1, DBNAME_CLIENT_TELEPHONE_PORTABLE, space(01))
	END IF	
	IF IsNull (s_adraeema) THEN
		dw_mas.SetItem (1, DBNAME_CLIENT_EMAIL, space(01))
	END IF		
	dw_mas.SetItem (1, DBNAME_DATE_CREATION, i_tr_sql.fnv_get_datetime ())
	dw_mas.SetItem(1,DBNAME_CODE_MAJ,"M")	

// Alimentation de la table log des Mvts de mises à jour
// =====================================================
	s_nomaeclf_orig = Trim(dw_mas.GetItemString(1, DBNAME_CLIENT_NOM_COMPLET1,PRIMARY!,True))
	s_rueaeclf_orig = Trim(dw_mas.GetItemString(1, DBNAME_CLIENT_ADRESSE_RUE,PRIMARY!,True))
	s_cpaaeclf_orig = Trim(dw_mas.GetItemString(1, DBNAME_CLIENT_ADRESSE_RUE_COMPLEMENTAIRE,PRIMARY!,True))
	s_codaepos_orig = Trim(dw_mas.GetItemString(1, DBNAME_CLIENT_CODE_POSTAL,PRIMARY!,True))
	s_buraedis_orig = Trim(dw_mas.GetItemString(1, DBNAME_CLIENT_BUREAU_DISTRIBUTEUR,PRIMARY!,True))
	s_numaetel_orig = Trim(dw_mas.GetItemString(1, DBNAME_CLIENT_TELEPHONE,PRIMARY!,True))
	s_numaetlx_orig = Trim(dw_mas.GetItemString(1, DBNAME_CLIENT_FAX,PRIMARY!,True))
	s_nataeclf_orig = dw_mas.GetItemString(1, DBNAME_NATURE_CLIENT,PRIMARY!,True)
	s_region_orig 	 = dw_mas.GetItemString(1, DBNAME_CLIENT_REGION,PRIMARY!,True)	
	s_pays_orig 	 = dw_mas.GetItemString(1, DBNAME_PAYS,PRIMARY!,True)		
	s_numaegsm_orig = dw_mas.GetItemString(1, DBNAME_CLIENT_TELEPHONE_PORTABLE,PRIMARY!,True)			
	s_adraeema_orig = dw_mas.GetItemString(1, DBNAME_CLIENT_EMAIL,PRIMARY!,True)				
	
	s_fctaeclf_orig = dw_1.GetItemString(1, DBNAME_FONCTION,PRIMARY!,True)
	s_domaeban_orig = Trim(dw_1.GetItemString(1, DBNAME_BANQUE,PRIMARY!,True))
	s_ribae000_orig = Trim(dw_1.GetItemString(1, DBNAME_BANQUE_RIB,PRIMARY!,True))
	s_codaemqt_orig = dw_1.GetItemString(1, DBNAME_CODE_MANQUANT,PRIMARY!,True)

	IF s_nomaeclf <> s_nomaeclf_orig THEN
		b_maj = True
	END IF
	
	IF s_rueaeclf <> s_rueaeclf_orig THEN
		b_maj = True
	ELSE
		s_rueaeclf = DONNEE_VIDE
	END IF

	IF s_cpaaeclf <> s_cpaaeclf_orig THEN
		b_maj = True
	ELSE
		s_cpaaeclf = DONNEE_VIDE
	END IF

	IF s_codaepos <> s_codaepos_orig THEN
		b_maj = True
	ELSE
		s_codaepos = DONNEE_VIDE
	END IF

	IF s_buraedis <> s_buraedis_orig THEN
		b_maj = True
	ELSE
		s_buraedis = DONNEE_VIDE
	END IF

	IF s_numaetel <> s_numaetel_orig THEN
		b_maj = True
	ELSE
		s_numaetel = DONNEE_VIDE
	END IF

	IF s_numaetlx <> s_numaetlx_orig THEN
		b_maj = True
	ELSE
		s_numaetlx = DONNEE_VIDE
	END IF

	IF s_nataeclf <> s_nataeclf_orig THEN
		b_maj = True
	ELSE
		s_nataeclf = DONNEE_VIDE
	END IF

	IF s_fctaeclf <> s_fctaeclf_orig THEN
		b_maj = True
	ELSE
		s_fctaeclf = DONNEE_VIDE
	END IF

	IF s_domaeban <> s_domaeban_orig THEN
		b_maj = True
	ELSE
		s_domaeban = DONNEE_VIDE
	END IF

	IF s_ribae000 <> s_ribae000_orig THEN
		b_maj = True
	ELSE
		s_ribae000 = DONNEE_VIDE
	END IF

	IF s_codaemqt <> s_codaemqt_orig THEN
		b_maj = True
	ELSE
		s_codaemqt = DONNEE_VIDE
	END IF

	IF s_pays <> s_pays_orig THEN
		b_maj = True
	ELSE
		s_pays = DONNEE_VIDE
	END IF
	IF s_region <> s_region_orig THEN
		b_maj = True
	ELSE
		s_region = DONNEE_VIDE
	END IF
	IF s_numaegsm <> s_numaegsm_orig THEN
		b_maj = True
	ELSE
		s_numaegsm = DONNEE_VIDE
	END IF	
	IF s_adraeema <> s_adraeema_orig THEN
		b_maj = True
	ELSE
		s_adraeema = DONNEE_VIDE
	END IF	

	
	If Not b_maj then
		return
	End if
	
	If g_s_valide = ORIGINE_VALIDATION_CLIENT then
		i_ds_log_maj.Retrieve(i_str_pass.s[01])
	Else
		i_ds_log_maj.InsertRow(1)
		i_ds_log_maj.SetItem(1,DBNAME_CODE_VISITEUR,g_s_visiteur)
		i_ds_log_maj.SetItem(1,DBNAME_DATE_CREATION,i_tr_sql.fnv_get_datetime ())
		i_ds_log_maj.SetItem(1,DBNAME_CLIENT_CODE,i_str_pass.s[1])
	End if

	String s_column_count
	integer i_nbr_column
	integer i_indice
	String s_column_name
	s_column_count = dw_mas.Object.DataWindow.Column.Count
	i_nbr_column = Integer(s_column_count)
	
	for i_indice = 1  to i_nbr_column
		dw_mas.setColumn(i_indice)
		s_column_name = dw_mas.GetColumnName()

		if s_column_name = DBNAME_CODE_VISITEUR then
			continue
		end if
		if s_column_name = DBNAME_DATE_CREATION then
			continue
		end if		
		if s_column_name = DBNAME_CLIENT_CODE then
			continue
		end if	
         if dw_mas.GetItemStatus (1, s_column_name, primary!  )		 = DataModified! then
				i_ds_log_maj.SetItem(1,s_column_name,dw_mas.getItemString(1,s_column_name))
		end if		

	next				
	
	s_column_count = dw_1.Object.DataWindow.Column.Count
	i_nbr_column = Integer(s_column_count)
	for i_indice = 1  to i_nbr_column
		dw_1.setColumn(i_indice)
		s_column_name = dw_1.GetColumnName()

		if s_column_name = DBNAME_CODE_VISITEUR then
			continue
		end if
		if s_column_name = DBNAME_DATE_CREATION then
			continue
		end if		
		if s_column_name = DBNAME_CLIENT_CODE then
			continue
		end if	
         if dw_1.GetItemStatus (1, s_column_name, primary!  )		 = DataModified! then
				i_ds_log_maj.SetItem(1,s_column_name,dw_1.getItemString(1,s_column_name))
		end if
	next				
	
	i_ds_log_maj.SetItem(1,DBNAME_CODE_MAJ,"M")
	i_ds_log_maj.SetItem(1,DBNAME_CLIENT_NOM_COMPLET1,s_nomaeclf)
	
	IF not g_nv_come9par.is_relation_clientele() THEN 
		i_ds_log_maj.SetItem (1, DBNAME_NOUVEAU_CLIENT, CODE_CLIENT_A_VALIDER)
	Else
		i_ds_log_maj.SetItem (1, DBNAME_NOUVEAU_CLIENT, CODE_CLIENT_A_NE_PAS_VALIDER)
	End if

end event

event ue_init;/* <DESC>
    Prépare l'affichage de la fenêtre en initialisant l'onglet par les datatwindows correspondantes, en affichant la fenêtre de sélection
   des clients , si aucun client de sélectionner, puis en recherchant les données du client sélectionner.
</DESC> */
// DECLARATION DES VARIABLES LOCALES
	Str_pass	str_pass_onglet
	DataWindowChild  ds_liste_des_activites
	i_b_modif = FALSE
	
// INITIALISATION DE L'OBJET DE TRANSACTION POUR LES DTW AJOUTEES
	dw_comparatif_ca.SetTransObject 					(i_tr_sql)
	uo_fiche_comptable.dw_1.SetTransObject 		(i_tr_sql)
	uo_fiche_comptable.dw_remise_gamme.SetTransObject 		(i_tr_sql)
	dw_ca_objectif.SetTransObject 					(i_tr_sql)
	dw_qte_objectif.SetTransObject 					(i_tr_sql)
	dw_suivi_promo.SetTransObject 					(i_tr_sql)
	

	dw_activite.getChild(DBNAME_CODE_ACTIVITE, ds_liste_des_activites)
	ds_liste_des_activites.setTransObject(i_tr_sql)
	ds_liste_des_activites.retrieve(g_nv_come9par.get_code_langue())

	dw_activite.SetTransObject 					(i_tr_sql)
	dw_activite.retrieve(g_nv_come9par.get_code_langue( )  )

// LIAISON DES DTW AVEC LE USER OBJECT ONGLET
	str_pass_onglet.s[1] = g_nv_traduction.get_traduction( "ONGLET_FICHE_CLIENT")
	str_pass_onglet.s[2] = g_nv_traduction.get_traduction( "ONGLET_FICHE_CPT")
	str_pass_onglet.s[3] = g_nv_traduction.get_traduction( "ONGLET_COMPARATIF_CA")
	str_pass_onglet.s[4] = g_nv_traduction.get_traduction( "ONGLET_ARTICLE_OBJ")
	str_pass_onglet.s[5] = g_nv_traduction.get_traduction( "ONGLET_SUIVI_PROMO")

	str_pass_onglet.po[1] = dw_1
	str_pass_onglet.po[2] = uo_fiche_comptable
	str_pass_onglet.po[3] = dw_comparatif_ca
	str_pass_onglet.po[4] = dw_ca_objectif
	str_pass_onglet.po[5] = dw_suivi_promo

// SELECTION DU CLIENT 
i_str_pass = fw_selection_client (i_str_pass)
CHOOSE CASE i_str_pass.s_action
	CASE ACTION_OK
		fw_retrieve_mas ()
		fw_retrieve_fiche_client ()
	CASE ACTION_CANCEL
		This.TriggerEvent ("ue_cancel")
		RETURN
END CHOOSE

g_nv_trace.fu_write_trace( this.classname( ), "ue_ini",i_str_pass.s[01], i_str_pass.s[02], this.classname( ) , g_s_fenetre_destination)

// CREATION DU USER OBJECT ONGLET
	dw_onglet.fu_create_tabs (5,5,str_pass_onglet,FALSE)
	dw_onglet.Modify ("Tab_1.Brush.Color = '16777088'")
	dw_onglet.Modify ("Tab_2.Brush.Color = '8454143'")
	dw_onglet.Modify ("Tab_3.Brush.Color = '8454016'")
	dw_onglet.Modify ("Tab_4.Brush.Color = '16776960'")
	dw_onglet.Modify ("Tab_5.Brush.Color = '8454143'")	
	dw_onglet.Modify ("Stab_1.Color = '0'")
	dw_onglet.Modify ("Stab_2.Color = '0'")
	dw_onglet.Modify ("Stab_3.Color = '0'")
	dw_onglet.Modify ("Stab_4.Color = '0'")
	dw_onglet.Modify ("Stab_5.Color = '0'")	
	
	dw_onglet.Visible = True
	dw_onglet.SetRedraw (TRUE)
	dw_onglet.SetFocus ()
	dw_1.visible	=	True
	
	fw_is_client_donneur_ordre()
	fw_affiche_alerte()

	If g_s_valide = ORIGINE_VALIDATION_CLIENT then
		pb_reliquat.visible		=	False
		pb_cpt_client.visible	=	False		
		pb_sai_cmde.visible		=	False
		pb_changer_client.visible		=	False
		This.PostEvent("ue_modifier")
   end if
	
	
end event

event key;call super::key;/* <DESC>
      Permet de trapper les touches de fonction activées et déclencher l'évènement associé
	à la touche.
	  F9 = Modification de la fiche client
	  F2 = Affichage de la liste des codes - utilisée lors de la modification
	  F5 = Affichage de l'onglet fiche client
	  F6 = Affichage de l'onglet fiche comptable
	  F7 = Affichage de l'onglet comparatif CA
	  F8 = Affichage de l'onglet article objectif
	  F4 = Affichage de l'onglet suivi promo
   </DESC> */

	IF KeyDown (keyF9!) THEN
   	This.PostEvent("ue_modifier")
	END IF

	IF KeyDown(KeyF2!) THEN
		This.PostEvent ("ue_listes")
	END IF

	IF KeyDown(KeyF11!) THEN
		This.PostEvent ("ue_ok")
	END IF

	IF KeyDown (KeyF5!) THEN
		IF i_b_modif = TRUE THEN
			dw_1.SetFocus ()
		ELSE
			dw_onglet.fu_set_active_tab (1)
		END IF
		RETURN
	END IF

	IF KeyDown (KeyF6!) AND i_b_modif = FALSE THEN
		dw_onglet.fu_set_active_tab (2)
		RETURN
	END IF

	IF KeyDown (KeyF7!) AND i_b_modif = FALSE THEN
		dw_onglet.fu_set_active_tab (3)
		RETURN
	END IF

	IF KeyDown (KeyF8!) AND i_b_modif = FALSE THEN
		dw_onglet.fu_set_active_tab (4)
		RETURN
	END IF
	
	IF KeyDown (KeyF4!) AND i_b_modif = FALSE THEN
		dw_onglet.fu_set_active_tab (5)
		RETURN
	END IF
end event

event ue_save;/* <DESC>
    Va effectuer la mise à jour des données après avoir fait le controle des données et 
	 réinitialiser la fenêtre en mode consultation.
</DESC> */
// OVERRIDE SCRIPT ANCESTOR
// MISE A JOUR DE L'ENTETE DE COMMANDE DW_1
	This.TriggerEvent ("ue_presave")

	IF message.returnvalue < 0 THEN
		i_b_update_status = FALSE
		RETURN
	END IF

	i_b_update_status = dw_1.fu_update ()
	if i_ds_log_maj.update () = -1 then
		f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE + i_ds_log_maj.uf_getdberror( ))
	end if

	dw_mas.SetTabOrder (DBNAME_NATURE_CLIENT, 0)
	dw_mas.SetTabOrder (DBNAME_CLIENT_NOM_COMPLET1, 0)
	dw_mas.SetTabOrder (DBNAME_CLIENT_ADRESSE_RUE, 0)
	dw_mas.SetTabOrder (DBNAME_CLIENT_ADRESSE_RUE_COMPLEMENTAIRE, 0)
	dw_mas.SetTabOrder (DBNAME_CLIENT_CODE_POSTAL, 0)
	dw_mas.SetTabOrder (DBNAME_CLIENT_BUREAU_DISTRIBUTEUR, 0)
	dw_mas.SetTabOrder (DBNAME_CLIENT_REGION, 0)	
	dw_mas.SetTabOrder (DBNAME_PAYS, 0)	
	dw_mas.SetTabOrder (DBNAME_CLIENT_TELEPHONE,0)
	dw_mas.SetTabOrder (DBNAME_CLIENT_TELEPHONE_PORTABLE,0)	
	dw_mas.SetTabOrder (DBNAME_CLIENT_FAX, 0)
	dw_mas.SetTabOrder (DBNAME_CLIENT_EMAIL, 0)	
	dw_mas.SetItem   (1,"flag_modif","V")
	
	dw_1.SetTabOrder (DBNAME_FONCTION, 0)
	dw_1.SetTabOrder (DBNAME_BANQUE, 0)
	dw_1.SetTabOrder (DBNAME_BANQUE_RIB, 0)
	dw_1.SetTabOrder (DBNAME_CODE_MANQUANT, 0)
	dw_1.SetItem     (1,"flag_modif","V")
		
	pb_modifier.visible 	= TRUE
	pb_ok.visible 			= FALSE
	
	fw_is_client_donneur_ordre()	

	i_b_modif = FALSE
end event

event ue_ok;/* <DESC>
    Validation de la mise à jour et remise à jour de l'object client.Si existsence de l'objet commande
	 réactualisation des informations du client doneur d'ordre.
</DESC> */
// OVERRIDE SCRIPT ANCESTOR
This.TriggerEvent ("ue_save")

	// réactualise l'objet client
nv_client_object lu_client 
lu_client = i_str_pass.po[1]
lu_client.fu_retrieve_client(i_str_pass.s[1])

if (upperBound(i_str_pass.po,2)) > 0 then
	if not isNull(i_str_pass.po[2]) then
		nv_commande_object l_commande
		l_commande = i_str_pass.po[2]
		l_commande.fu_refresh_client_info(lu_client)
	end if
end if 

If g_s_valide	= "V" then
  g_s_valide = " "
	postevent("ue_cancel")
end if

	
end event

event we_nchittest;
// OVERRIDE SCRIPT ANCESTOR

end event

event open;call super::open;/* <DESC>
     Initialisation de le fenêtre
   </DESC> */
	This.X = 0
	This.Y = 0
	dw_onglet.SetRedraw (FALSE)
end event

on w_fiche_client_principale.create
int iCurrent
call super::create
this.gb_option=create gb_option
this.pb_changer_client=create pb_changer_client
this.pb_ok=create pb_ok
this.pb_sai_cmde=create pb_sai_cmde
this.pb_cpt_client=create pb_cpt_client
this.pb_reliquat=create pb_reliquat
this.pb_echap=create pb_echap
this.pb_modifier=create pb_modifier
this.uo_fiche_comptable=create uo_fiche_comptable
this.rb_qte=create rb_qte
this.rb_ca=create rb_ca
this.sel_activite=create sel_activite
this.dw_activite=create dw_activite
this.pb_impression=create pb_impression
this.dw_comparatif_ca=create dw_comparatif_ca
this.dw_suivi_promo=create dw_suivi_promo
this.dw_qte_objectif=create dw_qte_objectif
this.dw_ca_objectif=create dw_ca_objectif
this.dw_onglet=create dw_onglet
this.sle_alerte=create sle_alerte
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_option
this.Control[iCurrent+2]=this.pb_changer_client
this.Control[iCurrent+3]=this.pb_ok
this.Control[iCurrent+4]=this.pb_sai_cmde
this.Control[iCurrent+5]=this.pb_cpt_client
this.Control[iCurrent+6]=this.pb_reliquat
this.Control[iCurrent+7]=this.pb_echap
this.Control[iCurrent+8]=this.pb_modifier
this.Control[iCurrent+9]=this.uo_fiche_comptable
this.Control[iCurrent+10]=this.rb_qte
this.Control[iCurrent+11]=this.rb_ca
this.Control[iCurrent+12]=this.sel_activite
this.Control[iCurrent+13]=this.dw_activite
this.Control[iCurrent+14]=this.pb_impression
this.Control[iCurrent+15]=this.dw_comparatif_ca
this.Control[iCurrent+16]=this.dw_suivi_promo
this.Control[iCurrent+17]=this.dw_qte_objectif
this.Control[iCurrent+18]=this.dw_ca_objectif
this.Control[iCurrent+19]=this.dw_onglet
this.Control[iCurrent+20]=this.sle_alerte
end on

on w_fiche_client_principale.destroy
call super::destroy
destroy(this.gb_option)
destroy(this.pb_changer_client)
destroy(this.pb_ok)
destroy(this.pb_sai_cmde)
destroy(this.pb_cpt_client)
destroy(this.pb_reliquat)
destroy(this.pb_echap)
destroy(this.pb_modifier)
destroy(this.uo_fiche_comptable)
destroy(this.rb_qte)
destroy(this.rb_ca)
destroy(this.sel_activite)
destroy(this.dw_activite)
destroy(this.pb_impression)
destroy(this.dw_comparatif_ca)
destroy(this.dw_suivi_promo)
destroy(this.dw_qte_objectif)
destroy(this.dw_ca_objectif)
destroy(this.dw_onglet)
destroy(this.sle_alerte)
end on

event ue_cancel;/* <DESC>
     Permet de quitter la fenêtre en retournant sur la fenêtre d'origine en appelant le workflow manager
</DESC> */
g_s_valide = BLANK
i_b_canceled = TRUE
g_nv_workflow_manager.fu_cancel_option( i_str_pass)
close (this)
end event

event ue_print;/* <DESC>
   Permet d'imprimer la fiche du client 
</DESC> */ 

str_pass  l_str_pass
nv_datastore lnv_datastore
nv_datastore lnv_datastore1
nv_datastore lnv_datastore2
lnv_datastore = create nv_datastore
long l_retrieve

DataWindowChild l_dwc1
DataWindowChild l_dwc2

choose case is_dw_focus_active
	case  	is_fiche_client 
		IF dw_1.AcceptText () < 0 THEN
			RETURN
		END IF
		
		lnv_datastore = create nv_datastore
		lnv_datastore.dataobject = "d_report_fiche_client"
		lnv_datastore.settransobject(i_tr_sql)
		l_retrieve = lnv_datastore.retrieve(i_str_pass.s[1],g_nv_come9par.get_code_langue())
		
		if  l_retrieve = DB_ERROR then
				f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
		end if
			
		if l_retrieve = 0 then
			destroy lnv_datastore
			return
		end if		
		
	case     is_ca_par_activite
		lnv_datastore.dataobject = "d_impression_ca_activite"
		lnv_datastore.settransobject(i_tr_sql)
		
		lnv_datastore.GetChild( "dw_1", l_dwc1)
		lnv_datastore.GetChild( "dw_2", l_dwc2)
		dw_mas.sharedata(l_dwc1)
		dw_comparatif_ca.ShareData(l_dwc2)
	
	case    is_ca_par_art_obj
		if rb_ca.checked then
			lnv_datastore.dataobject = "d_impression_ca_activite_objectif"
			lnv_datastore.settransobject(i_tr_sql)
			
			lnv_datastore.GetChild( "dw_1", l_dwc1)
			lnv_datastore.GetChild( "dw_2", l_dwc2)

			dw_ca_objectif.ShareData(l_dwc2)	
		else 
			lnv_datastore.dataobject = "d_impression_QTE_activite_objectif"
			lnv_datastore.settransobject(i_tr_sql)
			
			lnv_datastore.GetChild( "dw_1", l_dwc1)
			lnv_datastore.GetChild( "dw_2", l_dwc2)

			dw_qte_objectif.ShareData(l_dwc2)	
		end if

		dw_mas.sharedata(l_dwc1)
		
	case is_suivi_promo
	     lnv_datastore.dataobject = "d_impression_suivi_promo"
		lnv_datastore.settransobject(i_tr_sql)
		
		lnv_datastore.GetChild( "dw_1", l_dwc1)
		lnv_datastore.GetChild( "dw_2", l_dwc2)
		dw_mas.sharedata(l_dwc1)
		dw_suivi_promo.ShareData(l_dwc2)		
		
	case is_fiche_compta
	     lnv_datastore.dataobject = "d_impression_fiche_compta"
		lnv_datastore.settransobject(i_tr_sql)
		
		lnv_datastore.GetChild( "dw_1", l_dwc1)
		lnv_datastore.GetChild( "dw_2", l_dwc2)
		dw_mas.sharedata(l_dwc1)
		uo_fiche_comptable.fu_get_datawindow().ShareData(l_dwc2)		
		
end choose


g_nv_traduction.set_traduction_datastore (lnv_datastore)
lnv_datastore.print( )

//long l_retrieve
//
//nv_control_manager nv_check_value
//long ll_indice
//
//IF dw_1.AcceptText () < 0 THEN
//	RETURN
//END IF
//
//lnv_datastore = create nv_datastore
//lnv_datastore.dataobject = "d_report_fiche_client"
//lnv_datastore.settransobject(i_tr_sql)
//l_retrieve = lnv_datastore.retrieve(i_str_pass.s[1],g_nv_come9par.get_code_langue())
//
//if  l_retrieve = DB_ERROR then
//		f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
//end if
//	
//if l_retrieve = 0 then
//	destroy lnv_datastore
//	return
//end if
//
//g_nv_traduction.set_traduction_datastore (lnv_datastore)
//
//lnv_datastore.print () 
//destroy lnv_datastore
//
end event

type uo_statusbar from w_a_mas_det`uo_statusbar within w_fiche_client_principale
end type

type dw_1 from w_a_mas_det`dw_1 within w_fiche_client_principale
string tag = "A_TRADUIRE"
integer x = 315
integer y = 1092
integer width = 2341
integer height = 880
integer taborder = 50
string dataobject = "d_client_general"
borderstyle borderstyle = stylelowered!
end type

event dw_1::we_dwnkey;call super::we_dwnkey;
// f_activation_key ()
	f_key(Parent)
end event

event dw_1::we_dwnprocessenter;call super::we_dwnprocessenter;
// SIMULATION DE LA TOUCHE TAB AVEC LA TOUCHE ENTER
	Send(Handle(This),256,9,Long(0,0))
//	This.SetActionCode(1)
	RETURN 1
end event

event dw_1::getfocus;call super::getfocus;
// Indique que cette datawindow a le focus
	i_dw_focus = This

end event

type dw_mas from w_a_mas_det`dw_mas within w_fiche_client_principale
string tag = "A_TRADUIRE"
integer x = 137
integer y = 4
integer width = 2683
integer height = 772
integer taborder = 0
string dataobject = "d_client_entete"
borderstyle borderstyle = styleshadowbox!
end type

event dw_mas::we_dwnkey;call super::we_dwnkey;
f_key (Parent)
end event

event dw_mas::we_dwnprocessenter;call super::we_dwnprocessenter;
// SIMULATION DE LA TOUCHE TAB AVEC LA TOUCHE ENTER
	Send(Handle(This),256,9,Long(0,0))
//	This.SetActionCode(1)
	RETURN 1
end event

event dw_mas::getfocus;call super::getfocus;
// Indique que cette datawindow a le focus
	i_dw_focus = This
end event

event dw_mas::clicked;call super::clicked;
// Indique que cette datawindow a le focus
	i_dw_focus = This
end event

type gb_option from groupbox within w_fiche_client_principale
string tag = "NO_TEXT"
integer x = 1536
integer y = 1024
integer width = 722
integer height = 128
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
borderstyle borderstyle = stylebox!
end type

type pb_changer_client from u_pba_changer within w_fiche_client_principale
integer x = 2917
integer y = 28
integer width = 306
integer height = 148
integer taborder = 0
boolean default = true
boolean originalsize = false
string picturename = "C:\appscir\Erfvmr_diva\Image\pbchange.bmp"
string disabledname = "C:\appscir\Erfvmr_diva\Image\pbchange.bmp"
end type

type pb_ok from u_pba_ok within w_fiche_client_principale
boolean visible = false
integer x = 96
integer y = 2080
integer width = 325
integer height = 148
integer taborder = 0
string text = "Valid. F11"
boolean default = false
string picturename = "C:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_sai_cmde from u_pba_sai_cmde within w_fiche_client_principale
integer x = 1998
integer y = 2080
integer width = 325
integer height = 148
integer taborder = 0
boolean originalsize = false
string picturename = "C:\appscir\Erfvmr_diva\Image\pb_saicd.bmp"
end type

type pb_cpt_client from u_pba_cpt_client within w_fiche_client_principale
integer x = 914
integer y = 2080
integer width = 325
integer height = 148
integer taborder = 0
string text = "Co&mpte"
boolean originalsize = false
string picturename = "C:\appscir\Erfvmr_diva\Image\pbcptcli.bmp"
string disabledname = "C:\appscir\Erfvmr_diva\Image\pbcptcli.bmp"
end type

type pb_reliquat from u_pba_reliquat within w_fiche_client_principale
integer x = 480
integer y = 2080
integer width = 361
integer height = 148
integer taborder = 0
boolean originalsize = false
string picturename = "C:\appscir\Erfvmr_diva\Image\pbreliqu.bmp"
string disabledname = "C:\appscir\Erfvmr_diva\Image\pbreliqu.bmp"
end type

type pb_echap from u_pba_echap within w_fiche_client_principale
integer x = 2373
integer y = 2080
integer width = 325
integer height = 148
integer taborder = 0
string picturename = "C:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type pb_modifier from u_pba_modifier within w_fiche_client_principale
string tag = "Modification client"
integer x = 96
integer y = 2080
integer width = 325
integer height = 148
integer taborder = 0
boolean originalsize = false
string picturename = "C:\appscir\Erfvmr_diva\Image\pbmodif.bmp"
string disabledname = ""
alignment htextalign = left!
end type

type uo_fiche_comptable from u_dw_comptabilite_client within w_fiche_client_principale
boolean visible = false
integer x = 160
integer y = 1064
integer width = 2670
integer height = 916
integer taborder = 60
end type

on uo_fiche_comptable.destroy
call u_dw_comptabilite_client::destroy
end on

type rb_qte from u_rba within w_fiche_client_principale
boolean visible = false
integer x = 1906
integer y = 1056
integer width = 288
integer height = 72
long backcolor = 12632256
string text = "Par Qté"
end type

event clicked;call super::clicked;fw_retrieve_ca_art_obj()
end event

type rb_ca from u_rba within w_fiche_client_principale
boolean visible = false
integer x = 1563
integer y = 1056
integer width = 279
integer height = 72
long backcolor = 12632256
string text = "Par Ca"
boolean checked = true
end type

event clicked;call super::clicked;fw_retrieve_ca_art_obj()
end event

type sel_activite from statictext within w_fiche_client_principale
boolean visible = false
integer x = 219
integer y = 1084
integer width = 261
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Activité :"
boolean focusrectangle = false
end type

type dw_activite from u_dwa within w_fiche_client_principale
string tag = "A_TRADUIRE"
boolean visible = false
integer x = 494
integer y = 1060
integer width = 818
integer height = 88
integer taborder = 11
string dataobject = "dd_activite"
end type

event itemchanged;call super::itemchanged;fw_retrieve_ca_art_obj()
end event

type pb_impression from u_pba within w_fiche_client_principale
integer x = 1362
integer y = 2080
integer width = 325
integer height = 148
integer taborder = 11
boolean bringtotop = true
string facename = "Arial"
string text = "&Impression"
string picturename = "C:\appscir\Erfvmr_diva\Image\PB_IMP.BMP"
end type

event constructor;call super::constructor;
// ------------------------------------------------------
// DECLENCHEMENT DE L'EVENEMENT AU NIVEAU DE LA FENÊTRE
// ------------------------------------------------------
	fu_setevent ("ue_print")

// ------------------------------------------------------
// TEXTE DE LA MICROHELP
// ------------------------------------------------------
	fu_set_microhelp ("Impression de la fiche client")
end event

type dw_comparatif_ca from u_dw_q within w_fiche_client_principale
string tag = "A_TRADUIRE"
boolean visible = false
integer x = 123
integer y = 1032
integer width = 2761
integer height = 944
integer taborder = 11
string dataobject = "d_comparatif_ca_par_activite"
boolean vscrollbar = true
long i_l_arow = 0
end type

type dw_suivi_promo from u_dw_q within w_fiche_client_principale
string tag = "A_TRADUIRE"
boolean visible = false
integer x = 151
integer y = 1036
integer width = 2743
integer height = 936
integer taborder = 11
string dataobject = "d_suivi_promo"
boolean vscrollbar = true
end type

type dw_qte_objectif from u_dw_q within w_fiche_client_principale
string tag = "A_TRADUIRE"
boolean visible = false
integer x = 155
integer y = 1144
integer width = 2761
integer height = 824
integer taborder = 21
string dataobject = "d_comparatif_qte_activite_objectif"
boolean vscrollbar = true
long i_l_arow = 0
end type

type dw_ca_objectif from u_dw_q within w_fiche_client_principale
string tag = "A_TRADUIRE"
boolean visible = false
integer x = 110
integer y = 1156
integer width = 2761
integer height = 816
integer taborder = 21
string dataobject = "d_comparatif_ca_activite_objectif"
boolean vscrollbar = true
long i_l_arow = 0
end type

type dw_onglet from u_dw_tab_bleu within w_fiche_client_principale
integer x = 50
integer y = 896
integer width = 3067
integer height = 1164
integer taborder = 20
borderstyle borderstyle = styleshadowbox!
end type

event ue_tabfocuschanged;call super::ue_tabfocuschanged;
// Déplacement dans les différents dossiers de l'onglet
CHOOSE CASE This.fu_get_tab()
	CASE 1 
	//FICHE CLIENT PRINCIPALE
		fw_retrieve_fiche_client ()
		is_dw_focus_active = is_fiche_client
	CASE 3
	// COMPARATIF DU C.A. ANNUEL
		fw_retrieve_ca()
		is_dw_focus_active = is_ca_par_activite
	CASE 4
	// COMPARATIF DU C.A. ARTICLE OBJECTIF EN C.A.
		fw_retrieve_ca_art_obj ()
		is_dw_focus_active = is_ca_par_art_obj
    CASE 5
	// SUIVI DES PROMO
		fw_retrieve_suivi_promo ()	
		is_dw_focus_active = is_suivi_promo
	CASE ELSE
	// Fiche client comptable
		fw_retrieve_fiche_cpta ()
		is_dw_focus_active = is_fiche_compta
END CHOOSE
end event

event we_dwnkey;call super::we_dwnkey;
// DECLENCHEMENT DE L'EVENEMENT AU NIVEAU DE LA FENÊTRE
//	f_activation_key ()
	f_key(Parent)
end event

type sle_alerte from u_slea within w_fiche_client_principale
integer x = 389
integer y = 800
integer width = 2235
integer height = 72
integer taborder = 11
boolean bringtotop = true
integer weight = 700
string facename = "Arial"
long textcolor = 255
long backcolor = 12632256
boolean border = false
boolean displayonly = true
borderstyle borderstyle = stylebox!
end type

