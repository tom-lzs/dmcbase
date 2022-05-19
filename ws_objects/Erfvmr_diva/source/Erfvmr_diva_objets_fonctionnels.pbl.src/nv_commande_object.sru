$PBExportHeader$nv_commande_object.sru
$PBExportComments$Contient toutes les données de la commande en cours de traitement,toutes les fonctions permettant d'accéder aux données du client, tous les controles et règles de mise à jour.
forward
global type nv_commande_object from nonvisualobject
end type
end forward

global type nv_commande_object from nonvisualobject
end type
global nv_commande_object nv_commande_object

type variables
String is_numcde = BLANK                  	// N° de commande
String is_client_livre                            	 // N° du client livré
Date   id_date_commande            			// Date de la commande
nv_datastore i_ds_entete_cde					// Contient les données de l'entete de la commande
nv_client_object i_donnees_client     		// Contient les informations du client donneur ordre
nv_control_manager  i_nv_check_value 
Datastore i_ds_client_livre             		// Contient les informations du client livré       
Datastore i_ds_controle_minimum_cde  	// Contient les parmaètres du minimum de commande
Long        il_nbr_lignes_cde = 0         		// Contient le noimbre de lignes de la commande
end variables

forward prototypes
public function string fu_get_numero_cde ()
public function string fu_controle_numero_cde (any as_client_object)
private function boolean fu_is_client_prospect ()
public subroutine fu_refresh_client_info (any as_client_object)
public function string fu_get_code_echeance ()
public function decimal fu_get_remise_cde ()
public function string fu_get_marche ()
public function string fu_get_liste_prix ()
public function string fu_get_devise ()
public function boolean fu_is_grossiste_saisie ()
public subroutine fu_update_grossiste (string as_grossiste)
private function decimal fu_get_minimum_cde ()
private subroutine fu_update_montants (datastore adw_lignes_cde)
public function boolean fu_is_commande_validee ()
public function boolean fu_is_entete_cde_validee ()
public function boolean fu_is_commande_bloquee ()
public subroutine fu_reactualise_les_blocages ()
public subroutine fu_set_numero_cde (string as_numcde)
public function boolean fu_is_commande_blocage_ligne ()
public function boolean fu_is_commande_avec_ligne_promo ()
private function string fu_get_client_livre ()
private function string fu_get_client_facture ()
private function string fu_get_client_donneur_ordre ()
public function boolean fu_modification_client (string as_numcde, any auo_info_nouveau_client)
public function boolean is_remise_cde ()
public function boolean fu_is_blocage_non_bloquant ()
public function string fu_get_mode_paiement ()
public function date fu_get_date_cde ()
public function date fu_get_date_livraison ()
public function date fu_get_date_prix ()
public function date fu_get_date_saisie_cde ()
public function boolean fu_is_commande_avec_ligne_indirecte ()
public subroutine fu_validation_cde_par_entete ()
public subroutine fu_validation_commande_par_lignes_cde ()
public function string fu_get_code_langue_payeur ()
public function string fu_get_code_langue_facture ()
public function string fu_get_code_langue ()
public function string fu_get_code_langue_livre ()
private function string fu_create_entete ()
public subroutine fu_validation_commande ()
private subroutine fu_controle_si_date_cde_modifiee ()
public function string fu_get_grossiste ()
private function string fu_get_type_cde ()
public function boolean fu_is_regroupement_cde_modifiable ()
public function boolean fu_is_commande_valorisable ()
private subroutine fu_reactualise_blocages_niveau_lignes (ref datastore ads_ligne)
public subroutine fu_positionne_cde_a_valider ()
public function boolean fu_is_manquant_obligatoire ()
public function boolean fu_is_commande_bloquee_hors_indirecte ()
public subroutine fu_init_info_client ()
public function boolean fu_is_commande_transferee ()
public function integer fu_retrieve_commande ()
public subroutine fu_update_entete ()
public function long fu_get_nbr_lignes_cde ()
public function boolean fu_existe_ligne_cde_catalogue (string as_catalogue, ref string as_type_tarif)
public subroutine fu_validation_par_message ()
public subroutine fu_validation_par_ligne_catalogue ()
public subroutine fu_validation_par_promo ()
public function string fu_get_visiteur_cde ()
public function string fu_get_ucc ()
public function string fu_get_alerte ()
public function boolean fu_is_commande_drop ()
public function string fu_get_keepdrop_promo ()
public subroutine fu_maj_keepdrop_promo (string as_keepdrop_code)
public function string fu_get_keepdrop_commande ()
public function boolean fu_is_promotion_drop ()
public subroutine fu_blocage_client ()
private subroutine fu_update_table_message (string as_datawindow_cde, string as_datawindow_client, string as_code_client, string as_code_langue, boolean ab_suppression_avant)
public subroutine fu_update_message (boolean ab_suppression_avant)
private subroutine fu_update_message_livre (boolean ab_suppression_avant)
public function boolean fu_is_referencement_client ()
public subroutine fu_get_critere_referencement (ref string as_enseigne, ref string as_client)
public subroutine fu_retrieve_minimum_cde ()
public function boolean fu_is_commande_franco ()
private function boolean fu_controle_si_client_livre_modifie ()
public function boolean fu_retrieve_info_client_livre ()
end prototypes

public function string fu_get_numero_cde ();/* <DESC> 
      Retourne le numéro de la commande en cours.
   </DESC>	*/
return is_numcde
end function

public function string fu_controle_numero_cde (any as_client_object);/* <DESC>
   - Cette fonction est appelée en début de chacune des fenêtres principales de gestion des commandes.
     Elle va permettre de controler si on est en mode création de commande ou en modification.
	  
   - En mode création, le n° de commande est alimenté à blanc et dans ce cas on va créer une nouvelle commande, sinon
   on récupère les éléments de la commande qui seront utilisées tout au long de la saisie.

   -	De plus on récupère les éléments du client livré associé à la commande, le minimum de cde et les
	éléments du client donneur ordre.
	
	En retour , la fonction retourne le N° de commande.
    </DESC>*/
integer li_retrieve
i_donnees_client = as_client_object

li_retrieve = i_ds_entete_cde.retrieve(is_numcde)
if (li_retrieve = -1) then
	f_dmc_error ("Commande Object" + BLANK + DB_ERROR_MESSAGE)
end if

if li_retrieve = 0 then
	return fu_create_entete()
end if

fu_retrieve_info_client_livre()
fu_retrieve_minimum_cde()
id_date_commande = Date(i_ds_entete_cde.getItemDateTime(1, DBNAME_DATE_CDE))

 if i_ds_entete_cde.GetItemString(1,DBNAME_CODE_MAJ) =  'I'  then // cde edit créée en batch
    fu_blocage_client()
   fu_update_message(false)
    i_ds_entete_cde.SetItem (1, DBNAME_CODE_MAJ , BLANK)
	 fu_update_entete()
 end if

return is_numcde
end function

private function boolean fu_is_client_prospect ();/* <DESC>
    permet de savoir si le client donneur d'ordre est un client prospect
   </DESC> */
return i_donnees_client.is_client_prospect()
end function

public subroutine fu_refresh_client_info (any as_client_object);/* <DESC>
    Permet de rafraichir les données du client donneur d'ordre de la commande
   </DESC> */
i_donnees_client = as_client_object
end subroutine

public function string fu_get_code_echeance ();/* <DESC> 
      Retourne le code échéance de la commande
   </DESC>	*/
return i_ds_entete_cde.getItemString(1, DBNAME_CODE_ECHEANCE)
end function

public function decimal fu_get_remise_cde ();/* <DESC> 
      Retourne la remise de l'entête de la commande
   </DESC>	*/
return i_ds_entete_cde.getItemDecimal(1, DBNAME_REMISE_CDE)
end function

public function string fu_get_marche ();/* <DESC> 
      Retourne le code marché de la commande
   </DESC>	*/
	String ls_marche
	
	ls_marche =  i_ds_entete_cde.getItemString(1, DBNAME_CODE_MARCHE)
return ls_marche
end function

public function string fu_get_liste_prix ();/* <DESC> 
      Retourne le code de la liste des prix de la commande
   </DESC>	*/
return i_ds_entete_cde.getItemString(1, DBNAME_LISTE_PRIX)
end function

public function string fu_get_devise ();/* <DESC> 
      Retourne le code devise de la commande
   </DESC>	*/
return i_ds_entete_cde.getItemString(1, DBNAME_CODE_DEVISE)
end function

public function boolean fu_is_grossiste_saisie ();/* <DESC>
   Permet de déterminer si un code grossite a été saisi au niveau de l'entête de la commande ou non
   </DESC> */

if isNull(i_ds_entete_cde.getItemString (1, DBNAME_GROSSISTE)) or & 
   Trim(i_ds_entete_cde.getItemString (1, DBNAME_GROSSISTE)) = DONNEE_VIDE then
	return false
end if

return true
end function

public subroutine fu_update_grossiste (string as_grossiste);/* <DESC>
   Permet de mettre à jour le code du grossite associé à la commande dans l'entête de la commande
   </DESC> */
i_ds_entete_cde.setItem (1, DBNAME_GROSSISTE, as_grossiste)
 fu_update_entete()

end subroutine

private function decimal fu_get_minimum_cde ();/* <DESC> 
      Retourne le minimum de cde autorisé 
   </DESC>	*/

if i_ds_controle_minimum_cde.rowCount() = 0 then
	return 0
end if

return i_ds_controle_minimum_cde.getItemDecimal(1,DBNAME_MINIMUM_CDE)
end function

private subroutine fu_update_montants (datastore adw_lignes_cde);/* <DESC>
   Permet de valoriser la commande et de mettre à jour l'entête de la commande.
   Si la commande n'est pas valorisable (dependant du type de la commande)
	  remise à zéro des montants de la commande.
   Sinon calcul des montants à partir des lignes de la commande comme suit :
	    montant indirect =  Cumul du montant des lignes de type indirect
	    montant direct =  Cumul du montant des lignes de type direct	  
	</DESC> */
	
// Cette fonction permet de mettre à jour les montants de la commande
// et de réactualiser la datawindow
integer   li_indice
Decimal	dec_mtlaedir
Decimal	dec_mtlaeind
Decimal	dec_mtlaegrf
str_pass l_str_work

// Recherche si la valorisation de la cde doit être effectuee ou non
// Ceci est dépendant du type de la commande
nv_control_manager nv_check_value 
nv_check_value = CREATE nv_control_manager

dec_mtlaedir = 0
dec_mtlaeind = 0
dec_mtlaegrf = 0

//Type de commande
l_str_work.s[1] = fu_get_type_cde()
l_str_work.s[2] = BLANK
l_str_work = nv_check_value.is_type_cde_valide (l_str_work)
// Type de cde non trouve
if not l_str_work.b[1] then
	goto FIN
end if	

// Pas de valorisation
if l_str_work.s[7] = "N" then
		goto FIN
end if

// la valorisation est effectuée si la commande n'est pas affectée à un client
// interne et qu''il ne s'agit pas d'une commande de livraison gratuite
if fu_is_commande_valorisable() then
	for li_indice =  1 to adw_lignes_cde.RowCount()
		choose case adw_lignes_cde.getItemString (li_indice, DBNAME_TYPE_LIGNE)
			case TYPE_LIGNE_DIRECT
				dec_mtlaedir =  dec_mtlaedir + adw_lignes_cde.getItemDecimal(li_indice, DBNAME_MONTANT_LIGNE)
			case TYPE_LIGNE_INDIRECT
				dec_mtlaeind = dec_mtlaeind + adw_lignes_cde.getItemDecimal(li_indice, DBNAME_MONTANT_LIGNE)			
			case else
				dec_mtlaegrf = dec_mtlaegrf + adw_lignes_cde.getItemDecimal(li_indice, DBNAME_MONTANT_LIGNE)			
		end choose
	next
end if

FIN:
i_ds_entete_cde.setItem(1, DBNAME_MONTANT_CDE_DIRECT, dec_mtlaedir)
i_ds_entete_cde.setItem(1, DBNAME_MONTANT_CDE_INDIRECT, dec_mtlaeind)
i_ds_entete_cde.setItem(1, DBNAME_MONTANT_CDE_GROSSISTE, dec_mtlaegrf)
adw_lignes_cde.update()


end subroutine

public function boolean fu_is_commande_validee ();/* <DESC>
    Permet de déterminer si la commande est validée mais non transférée dans SAP
	 </DESC> */

if i_ds_entete_cde.getItemString(1, DBNAME_ETAT_CDE) = COMMANDE_VALIDEE then
	return true
else
	return false
end if

end function

public function boolean fu_is_entete_cde_validee ();/* <DESC> 
    Permet de déterminer si l'entete de commande a été validée ou non.
    Ceci est déterminé en fonction du code mise à jour de l'entête de commande.
    Si le code est à blanc, l'assistante commerciale n'a pas créé la commande à partir de l'entête de commande
    et doit donc d'abord valider l'entête pour que la commande puisse être validée.
   </DESC> */

String s_code_maj
s_code_maj = trim( i_ds_entete_cde.getItemString(1, DBNAME_CODE_MAJ))
if s_code_maj = ENTETE_CDE_VALIDEE then
	return true
else
	return false
end if

end function

public function boolean fu_is_commande_bloquee ();/* <DESC> 
      Permet de déterminer si la commande est bloquée ou non 
	</DESC> */
if i_ds_entete_cde.getItemString(1, DBNAME_ETAT_CDE) = COMMANDE_BLOQUEE then
	return true
else
	return false
end if

end function

public subroutine fu_reactualise_les_blocages ();/* <DESC>
   Permet de déterminer de reactualiser les codes blocages spécifiques à l'entete de la commande
   Les code blocages d'une commande possible sont :
	   Client donneur ordre est un prospect
        Client livré n'est pas un partenaire du client donneur d'ordre
	   Montant minimum de la commande n'est pas atteint
	   Existence de message associés à la commande.
   L'etat de la commande passe à bloquer donc non  non validable si :
	  Si client prospect, partenaire inexistant,Reference inexistante, ligne de commande indirecte,
	  existence de message sur la commande dans le cas d'une commande saisie par un vendeur.
   </DESC> */

str_pass l_str_work
Datastore lds_controle

String ls_value
integer li_indice
boolean  lb_commande_bloquee = false

/* --------------------------------------------------
	Controle du Blocage partenaire non conforme
	
	Si Client prospect, le blocage est systématique car dans SAP aucun
	   partenaire ne peut être défini
	Si le client livré est inexistant dans la table des partenaire pour
	   le client de la commande, le blocage est posé sinon il sera levé
   -------------------------------------------------- */
if fu_is_client_prospect() then
	lb_commande_bloquee = true
end if

if i_ds_entete_cde.getItemString(1, DBNAME_BLOCAGE_PARTENAIRE) = CODE_BLOCAGE then
	lb_commande_bloquee = true
end if

// Controle minimun de commande. ce controle ne sera pas effectué si pour le type de commande
// on ne doit pas valoriser la commande
Decimal  dec_total_cde
i_ds_entete_cde.setItem(1,DBNAME_BLOCAGE_MINI_CDE, CODE_PAS_DE_BLOCAGE)		
if fu_is_commande_valorisable()  then
	dec_total_cde = i_ds_entete_cde.getItemDecimal(1, DBNAME_MONTANT_CDE_DIRECT) &
						 + i_ds_entete_cde.getItemDecimal(1, DBNAME_MONTANT_CDE_INDIRECT) &
						 + i_ds_entete_cde.getItemDecimal(1, DBNAME_MONTANT_CDE_GROSSISTE)
	
	if  dec_total_cde < fu_get_minimum_cde() then
		i_ds_entete_cde.setItem(1,DBNAME_BLOCAGE_MINI_CDE, CODE_BLOCAGE)	
	elseif fu_get_minimum_cde() > 0  and fu_is_commande_franco() then
//		i_ds_entete_cde.setItem(1,DBNAME_PAIEMENT_EXPEDITON,CODE_NON_SOUMIS)
		i_ds_entete_cde.setItem(1,DBNAME_PAIEMENT_EXPEDITON,"2")
	end if
end if

// Controle des anomalies sur les lignes de cde
if i_ds_entete_cde.getItemString(1,DBNAME_BLOCAGE_REF) =  CODE_BLOCAGE then
	lb_commande_bloquee = true	
end if

if i_ds_entete_cde.getItemString(1,DBNAME_BLOCAGE_LIGNE_CDE) =  CODE_BLOCAGE then
	lb_commande_bloquee = true
end if

if i_ds_entete_cde.getItemString(1,DBNAME_BLOCAGE_QTE) =  CODE_BLOCAGE then
	lb_commande_bloquee = true
end if

// Controle si existence de message pour la commande
lds_controle = Create Datastore
lds_controle.Dataobject = "d_texte_come90pb"
lds_controle.setTransObject(sqlca)
lds_controle.retrieve(fu_get_numero_cde())
if lds_controle.rowCount() > 0 then
	i_ds_entete_cde.setItem(1,DBNAME_BLOCAGE_MSG_CDE, CODE_BLOCAGE)
	if g_nv_come9par.is_vendeur() or g_nv_come9par.is_filiale() then
		lb_commande_bloquee = true
	end if
else
	i_ds_entete_cde.setItem(1,DBNAME_BLOCAGE_MSG_CDE, CODE_PAS_DE_BLOCAGE)
end if

String s_etat
s_etat = i_ds_entete_cde.getItemString(1,DBNAME_ETAT_CDE)

if	lb_commande_bloquee then
	i_ds_entete_cde.setItem(1,DBNAME_ETAT_CDE, COMMANDE_BLOQUEE)
elseif s_etat = COMMANDE_BLOQUEE then
	i_ds_entete_cde.setItem(1,DBNAME_ETAT_CDE, COMMANDE_SUSPENDUE)
end if
i_ds_entete_cde.update()
destroy lds_controle
end subroutine

public subroutine fu_set_numero_cde (string as_numcde);/* <DESC>
   Permet d'initialiser la variable d'instance contenant le N° de la commande
   </DESC> */
is_numcde = as_numcde
end subroutine

public function boolean fu_is_commande_blocage_ligne ();/* <DESC> 
     Permet de déterminer si des lignes de commandes sont bloquée (reference inexistante,Tarif inexistant,Taille du lot
  </DESC> */

if i_ds_entete_cde.getItemString(1, DBNAME_BLOCAGE_REF) = CODE_BLOCAGE or &
	i_ds_entete_cde.getItemString(1, DBNAME_BLOCAGE_TARIF) = CODE_BLOCAGE or &
	i_ds_entete_cde.getItemString(1, DBNAME_BLOCAGE_QTE) = CODE_BLOCAGE then
	return true
end if
return false
end function

public function boolean fu_is_commande_avec_ligne_promo ();/* <DESC>
    Permet de déterminer Si exietence de ligne de commande saisie au titre de promotion
   </DESC> */
boolean lb_return = false
integer li_indice
Datastore lds_controle
lds_controle = CREATE Datastore
lds_controle.Dataobject = "d_ligne_cde"
lds_controle.setTransObject(sqlca)
lds_controle.retrieve(fu_get_numero_cde())

for li_indice = 1 to lds_controle.RowCount()
	if trim(lds_controle.getItemString (li_indice, DBNAME_CODE_PROMO)) <> DONNEE_VIDE and &
 	   not IsNull(lds_controle.getItemString (li_indice, DBNAME_CODE_PROMO)) then
		lb_return = true
		goto Fin
	end if
next

Fin:
destroy lds_controle
return lb_return
end function

private function string fu_get_client_livre ();/* <DESC> 
      Retourne le code du client livré associé à la commande
   </DESC>	*/
return i_ds_entete_cde.getItemString(1, DBNAME_CLIENT_LIVRE_CODE)
end function

private function string fu_get_client_facture ();/* <DESC> 
      Retourne le code du client facturé associé à la commande
   </DESC>	*/
return i_donnees_client.fu_get_client_facture()
end function

private function string fu_get_client_donneur_ordre ();/* <DESC> 
      Retourne le code du client donneur d'ordre associé à la commande
   </DESC>	*/
return i_ds_entete_cde.getItemString(1, DBNAME_CLIENT_CODE)
end function

public function boolean fu_modification_client (string as_numcde, any auo_info_nouveau_client);/* <DESC>
     Permettre de modifier le client prospect de la commande par le nouveau client affecté par l'assistante commerciale et
	  ceci pour permettre de pouvoir valider la commande.
	 Rafraichissement de l'objet commande
	 Modification des infos de la commande relatives au nouveau client,
	 Positionné l'entete de commande comme étant non validée
	 Mise à jour des messages de la commande à partir
	 du nouveau client donneur d'ordre 
	</DESC> */
	
String ls_ucc_avant_modif

fu_set_numero_cde(as_numcde)
fu_controle_numero_cde(auo_info_nouveau_client)
ls_ucc_avant_modif = fu_get_ucc()
 
fu_init_info_client()

is_client_livre = i_donnees_client.fu_get_code_client()

// Modification du code mise à jour de l'entete pour obliger la validation de l'entete de la commande
i_ds_entete_cde.SetItem (1, DBNAME_CODE_MAJ, BLANK)
if ls_ucc_avant_modif <>  i_donnees_client.fu_get_ucc( ) then
	i_ds_entete_cde.SetItem (1, DBNAME_BLOCAGE_QTE,CODE_BLOCAGE )
end if
fu_update_entete()

// Réactualisation des messages de la commande en fonction des nouveaux clients partenaires
fu_update_message(true)

/* Controle si l'unite de commande client a changé en fonction du nouveau client.
 Si tel est le cas, positionner un blocage qté non conforme et positionner toutes les lignes de la commande
en anomalie qté UNC incorrecte et le code mise à jour des lignes à 'R' pour forcer la validation des lignes*/
if ls_ucc_avant_modif =  i_donnees_client.fu_get_ucc( )  then
	return true
end if

integer   li_indice
datastore ds_ligne

ds_ligne= CREATE Datastore
ds_ligne.Dataobject = "d_ligne_cde"
ds_ligne.setTransObject(sqlca)

if ds_ligne.retrieve(as_numcde) = -1 then
	f_dmc_error ("Commande Object - fu_modification_client " + DB_ERROR_MESSAGE)
end if

for li_indice = 1 to ds_ligne.RowCount()
	ds_ligne.setItem(li_indice,DBNAME_QTE_UN,0)
     ds_ligne.setItem(li_indice,DBNAME_UNITE_LIGCDE," ")
     ds_ligne.SetItem (li_indice, DBNAME_CODE_ERREUR_LIGNE, CODE_QTE_UNC_INCORRECT)		
     ds_ligne.SetItem (li_indice, DBNAME_CODE_MAJ, CODE_MODE_RAPIDE)			  
next
ds_ligne.update()
return true
end function

public function boolean is_remise_cde ();/* <DESC>
    Permet de définir si il existe un remise global sur la commande.
   </DESC> */
if i_ds_entete_cde.getItemDecimal(1, DBNAME_REMISE_CDE) = 0 then
	return false
else
	return true
end if

end function

public function boolean fu_is_blocage_non_bloquant ();/* <DESC>
     permet de définir l'existence de blocage au niveau de la commande mais autorisant la validation
  </DESC> */
if	i_ds_entete_cde.getItemString(1, DBNAME_BLOCAGE_TARIF) = CODE_BLOCAGE or &
	i_ds_entete_cde.getItemString(1, DBNAME_BLOCAGE_QTE) = CODE_BLOCAGE or &	
	i_ds_entete_cde.getItemString(1, DBNAME_BLOCAGE_MINI_CDE) = CODE_BLOCAGE or &		
	i_ds_entete_cde.getItemString(1, DBNAME_BLOCAGE_CDE_EDI) = CODE_BLOCAGE or &			
	i_ds_entete_cde.getItemString(1, DBNAME_BLOCAGE_MSG_CDE) = CODE_BLOCAGE or &				
	i_ds_entete_cde.getItemString(1, DBNAME_BLOCAGE_SAP) = CODE_BLOCAGE then
	return true
end if

return false
end function

public function string fu_get_mode_paiement ();/* <DESC> 
      Retourne le mode de paiement de la commande
   </DESC>	*/
return i_ds_entete_cde.getItemString(1, DBNAME_MODE_PAIEMENT)
end function

public function date fu_get_date_cde ();/* <DESC> 
      Retourne la date de la commande 
   </DESC>	*/
return Date(i_ds_entete_cde.getItemDateTime(1, DBNAME_DATE_CDE))
end function

public function date fu_get_date_livraison ();/* <DESC> 
      Retourne la date de livraison souhaitée
   </DESC>	*/
return Date(i_ds_entete_cde.getItemDateTime(1, DBNAME_DATE_LIVRAISON))
end function

public function date fu_get_date_prix ();/* <DESC> 
      Retourne la date de prix de la commande
   </DESC>	*/
return Date(i_ds_entete_cde.getItemDateTime(1, DBNAME_DATE_PRIX))
end function

public function date fu_get_date_saisie_cde ();/* <DESC> 
      Retourne la date de saisie de la commande
   </DESC>	*/
return Date( i_ds_entete_cde.getItemDateTime(1, DBNAME_DATE_SAISIE_CDE))
end function

public function boolean fu_is_commande_avec_ligne_indirecte ();/* <DESC>
     Permet de déterminer si il y a existence de ligne de commande indirect dans la commande
   </DESC> */

boolean lb_return = false
integer li_indice
Datastore lds_controle
lds_controle = CREATE Datastore
lds_controle.Dataobject = "d_ligne_cde"
lds_controle.setTransObject(sqlca)
lds_controle.retrieve(fu_get_numero_cde())

for li_indice = 1 to lds_controle.RowCount()
	if trim(lds_controle.getItemString (li_indice, DBNAME_TYPE_LIGNE)) = TYPE_LIGNE_INDIRECT then
		lb_return = true
		goto Fin
	end if
next

Fin:

destroy lds_controle
return lb_return
end function

public subroutine fu_validation_cde_par_entete ();/* <DESC>
    Permet de valider la commande lors de la validation de l'entête de la commande.
    Appel de la fonction de controle du client livré, de la modification de la date de la commande et de l'incoterm
    Si la commande ne peut regrouper, remise à blanc de l'indicateur de regroupement des commandes
	Mise à jour du code blocage client prospect en focntion du client
	Mise à jour du code blocage livraison (SAP)
	Appel de la fonction de reactualisation de l'enseble des blocages de la commande
	Appel de la fonction de remise à jour des montants de l'entete
	Positionnement du code mise à jour de l'entête de la commande à Création
   </DESC> */
/* ----------------------------------------------- 
    Cette fonction est appelée lorsque lors de la 
	 validation de l'entete de commande
   ----------------------------------------------- */
str_pass l_str_work
String   ls_value

g_nv_trace.fu_write_trace( this.classname( ), "fu_validation_cde_par_entete _bretrieve" ,fu_get_numero_cde(), " ", this.classname( ) , g_s_fenetre_destination)
if i_ds_entete_cde.retrieve(fu_get_numero_cde()) = DB_ERROR then
	f_dmc_error ("Validation Object cde - retrieve : " + i_ds_entete_cde.uf_getdberror( ) )
end if
g_nv_trace.fu_write_trace( this.classname( ), "fu_validation_cde_par_entete _aretrieve" ,fu_get_numero_cde(), " ", this.classname( ) , g_s_fenetre_destination)

	// Controle si le client livré a été modifié pour
	// réactualiser les textes associés au livré et de l'incoterm.
g_nv_trace.fu_write_trace( this.classname( ), "fu_validation_cde_par_entete _bCltLiv" ,fu_get_numero_cde(), " ", this.classname( ) , g_s_fenetre_destination)

if fu_controle_si_client_livre_modifie() then
   i_ds_entete_cde.SetItem (1, DBNAME_CODE_INCOTERM, i_ds_client_livre.getItemString(1,DBNAME_CODE_INCOTERM))
   i_ds_entete_cde.SetItem (1, DBNAME_CODE_INCOTERM_2, i_ds_client_livre.getItemString(1,DBNAME_CODE_INCOTERM_2))
end if	

	// Controle si la date de commande a été modifié
	// si tel est le cas on réactualise la date de prix
g_nv_trace.fu_write_trace( this.classname( ), "fu_validation_cde_par_entete _bCtrlDate" ,fu_get_numero_cde(), " ", this.classname( ) , g_s_fenetre_destination)	
fu_controle_si_date_cde_modifiee()

	// Controle le type de commande
	// Si celui ci est une note de livraison gratuite
	// on force le code regroupement commande à non
g_nv_trace.fu_write_trace( this.classname( ), "fu_validation_cde_par_entete _bCtrlReg" ,fu_get_numero_cde(), " ", this.classname( ) , g_s_fenetre_destination)	
if not fu_is_regroupement_cde_modifiable() then
	i_ds_entete_cde.setItem(1, DBNAME_REGROUPEMENT_ORDRE, BLANK)
end if
	
/* --------------------------------------------------
	Positionnement du Blocage partenaire non conforme
	
	Si Client prospect, le blocage est systématique car dans SAP aucun
	   partenaire ne peut être défini
	Si le client livré est inexistant dans la table des partenaire pour
	   le client de la commande, le blocage est posé sinon il sera levé
   -------------------------------------------------- */
g_nv_trace.fu_write_trace( this.classname( ), "fu_validation_cde_par_entete _bBlkPrp" ,fu_get_numero_cde(), " ", this.classname( ) , g_s_fenetre_destination)		
if fu_is_client_prospect() then
	i_ds_entete_cde.setItem(1, DBNAME_CODE_PROSPECT, CODE_PREFIX_PROSPECT)	
else
	i_ds_entete_cde.setItem(1, DBNAME_CODE_PROSPECT, BLANK)		
end if

g_nv_trace.fu_write_trace( this.classname( ), "fu_validation_cde_par_entete _bCtrDO" ,fu_get_numero_cde(), " ", this.classname( ) , g_s_fenetre_destination)		
l_str_work.s[1] = fu_get_client_livre()
l_str_work.s[2] = BLANK
l_str_work.s[6] = BLANK
l_str_work.s[10] = fu_get_client_donneur_ordre()
l_str_work.s[20] = OPTION_PARTENAIRE
l_str_work = i_nv_check_value.is_client_livre_valide (l_str_work)
if not l_str_work.b[1] then
	i_ds_entete_cde.setItem(1, DBNAME_BLOCAGE_PARTENAIRE, CODE_BLOCAGE)
else
	i_ds_entete_cde.setItem(1, DBNAME_BLOCAGE_PARTENAIRE, CODE_PAS_DE_BLOCAGE)
end if

	// Controle du blocage livraison
g_nv_trace.fu_write_trace( this.classname( ), "fu_validation_cde_par_entete _bCrlBLiv" ,fu_get_numero_cde(), " ", this.classname( ) , g_s_fenetre_destination)			
ls_value = trim (i_ds_entete_cde.GetItemString(1,DBNAME_CODE_BLOCAGE_SAP))
IF ls_value <> DONNEE_VIDE and not isNull(ls_value) THEN
	i_ds_entete_cde.setItem(1,DBNAME_BLOCAGE_SAP, CODE_BLOCAGE)
else
	i_ds_entete_cde.setItem(1,DBNAME_BLOCAGE_SAP, CODE_PAS_DE_BLOCAGE)	
end if

   // Réctualise le code état de la commande en fonction des blocages
g_nv_trace.fu_write_trace( this.classname( ), "fu_validation_cde_par_entete _bRactBlk" ,fu_get_numero_cde(), " ", this.classname( ) , g_s_fenetre_destination)			
fu_reactualise_les_blocages()

// Réctualise les montants
g_nv_trace.fu_write_trace( this.classname( ), "fu_validation_cde_par_entete _bRactMont" ,fu_get_numero_cde(), " ", this.classname( ) , g_s_fenetre_destination)			
nv_datastore ds_ligne
ds_ligne= CREATE nv_Datastore
ds_ligne.Dataobject = "d_ligne_cde"
ds_ligne.setTransObject(sqlca)
if ds_ligne.retrieve(is_numcde) = -1 then
	f_dmc_error ("Commande Object - Calcul total cde " + ds_ligne.uf_getdberror( )  )
end if

g_nv_trace.fu_write_trace( this.classname( ), "fu_validation_cde_par_entete _bUpdMont" ,fu_get_numero_cde(), " ", this.classname( ) , g_s_fenetre_destination)			
i_ds_entete_cde.setItem(1, DBNAME_CODE_MAJ, CODE_CREATION)
fu_update_montants(ds_ligne)

g_nv_trace.fu_write_trace( this.classname( ), "fu_validation_cde_par_entete _bUpdEnete" ,fu_get_numero_cde(), " ", this.classname( ) , g_s_fenetre_destination)			
fu_update_entete()

g_nv_trace.fu_write_trace( this.classname( ), "fu_validation_cde_par_entete _aUpdEnete" ,fu_get_numero_cde(), " ", this.classname( ) , g_s_fenetre_destination)			
end subroutine

public subroutine fu_validation_commande_par_lignes_cde ();/* <DESC>
   Permet d'actualiser les différents blocages de l'entête de la commande et de calculer le montant de la commande
	après validation de la saisie des lignes de la commande.
   </DESC> */
	 
i_ds_entete_cde.retrieve(fu_get_numero_cde())

// Réactualise les blocages relatifs aux lignes et montants de l'entete de commande
integer   li_indice
datastore ds_ligne

ds_ligne= CREATE Datastore
ds_ligne.Dataobject = "d_ligne_cde"
ds_ligne.setTransObject(sqlca)

if ds_ligne.retrieve(is_numcde) = -1 then
	f_dmc_error ("Commande Object - Calclul total cde " + DB_ERROR_MESSAGE)
end if

il_nbr_lignes_cde = ds_ligne.RowCount()
fu_update_montants(ds_ligne)
fu_reactualise_blocages_niveau_lignes(ds_ligne)
fu_reactualise_les_blocages()

 fu_update_entete()

end subroutine

public function string fu_get_code_langue_payeur ();/* <DESC> 
      Retourne le code langue dans lequel les messages relatif au paiement sont exprimés et correspond au code langue
	du client payeur associé au client donneur d'ordre de la commande
   </DESC>	*/
return i_donnees_client.fu_get_code_langue_payeur()
end function

public function string fu_get_code_langue_facture ();/* <DESC> 
      Retourne le code langue dans lequel les messages relatifs à la facture sont exprimés et correspond au code langue
	du client facturé associé au client donneur d'ordre de la commande
   </DESC>	*/
return i_donnees_client.fu_get_code_langue_facture()
end function

public function string fu_get_code_langue ();/* <DESC> 
      Retourne le code langue associé à la commande et initialisé à partir du code langue du client
	donneur d'ordre.
   </DESC>	*/
return i_donnees_client.fu_get_code_langue()
end function

public function string fu_get_code_langue_livre ();/* <DESC> 
      Retourne le code langue dans lequel les messages relatif à la livraison sont exprimés et correspond au code langue
	du client livré associé à la commande.
   </DESC>	*/
	
if i_ds_client_livre.rowCount() = 0 then
	return BLANK
else
	return i_ds_client_livre.getItemString(1,DBNAME_CODE_LANGUE)
end if

end function

private function string fu_create_entete ();/*  Cette fonction est appelée par la fonction fu_controle_numero_cde et va permettre 
  la création de l'entête de commande par défaut ainsi que la création des messages à associer à la commande
  à partir des messages clients.

  Le N° de commande sera composé par le Code du visiteur + du dernier n° commande du visiteur qui sera donné par l'objet
  NV_COME9PAR

 Initialisation de l'origne de la commande et du type de commande à partir des informations par defaut associées au visiteur.
 Initialisation des infos à partir des données du client donneur ordre (appel fonction fu_init_info_client)
 
 De plus on récupère les éléments du client livré associé à la commande, le minimum de cde et les éléments du client donneur ordre.
  */
  /*  version 2008-03-01 - Si le client donneur d'ordre se trouve dans la liste des clients à bloquer , positionner le code blocage avec celui
      associé au client dans cette liste  . Cette liste est gérée dans l'application Efdvparam  */
 
// DECLARATION DES VARIABLES LOCALES
datetime		date_jour
String s_numcde

date_jour = SQLCA.fnv_get_datetime ()

setPointer(Hourglass!)

// ----------------------------------------------------------
// INITIALISATION DE L'ENTETE DE COMMANDE LORS D'UNE CREATION
// ----------------------------------------------------------
s_numcde = g_nv_come9par.get_numero_cde()

i_ds_entete_cde.InsertRow (0)

i_ds_entete_cde.SetItem (1, DBNAME_DATE_CREATION, date_jour)
i_ds_entete_cde.SetItem (1, DBNAME_CODE_MAJ , BLANK)
i_ds_entete_cde.SetItem (1, DBNAME_CODE_VISITEUR, g_s_visiteur)
i_ds_entete_cde.SetItem (1, DBNAME_NUM_CDE, s_numcde)
i_ds_entete_cde.SetItem (1, DBNAME_DATE_CDE, date_jour)
i_ds_entete_cde.SetItem (1, DBNAME_NBR_LIGNE_CDE, 0)
i_ds_entete_cde.SetItem (1, DBNAME_NUM_VALIDATION_CDE, CODE_MQT_KEEP)
i_ds_entete_cde.SetItem (1, DBNAME_DATE_SAISIE_CDE, date_jour)
i_ds_entete_cde.SetItem (1, DBNAME_DATE_PRIX, date_jour)
i_ds_entete_cde.SetItem (1, DBNAME_MONTANT_CDE_DIRECT, 0)	
i_ds_entete_cde.SetItem (1, DBNAME_MONTANT_CDE_INDIRECT, 0)		
i_ds_entete_cde.SetItem (1, DBNAME_MONTANT_CDE_GROSSISTE, 0)		
i_ds_entete_cde.SetItem (1, DBNAME_REMISE_CDE , 0)		
i_ds_entete_cde.SetItem (1, DBNAME_CODE_BLOCAGE_SAP, BLANK)
i_ds_entete_cde.SetItem (1, DBNAME_BLOCAGE_REF, CODE_PAS_DE_BLOCAGE)
i_ds_entete_cde.SetItem (1, DBNAME_BLOCAGE_TARIF, CODE_PAS_DE_BLOCAGE)
i_ds_entete_cde.SetItem (1, DBNAME_BLOCAGE_QTE, CODE_PAS_DE_BLOCAGE)
i_ds_entete_cde.SetItem (1, DBNAME_BLOCAGE_MINI_CDE, CODE_PAS_DE_BLOCAGE)
i_ds_entete_cde.SetItem (1, DBNAME_BLOCAGE_CDE_EDI, CODE_PAS_DE_BLOCAGE)	
i_ds_entete_cde.SetItem (1, DBNAME_BLOCAGE_MSG_CDE, CODE_PAS_DE_BLOCAGE)	
i_ds_entete_cde.SetItem (1, DBNAME_BLOCAGE_LIGNE_CDE, CODE_PAS_DE_BLOCAGE)
i_ds_entete_cde.SetItem (1, DBNAME_BLOCAGE_PARTENAIRE, CODE_PAS_DE_BLOCAGE)
i_ds_entete_cde.SetItem (1, DBNAME_ETAT_CDE, COMMANDE_SUSPENDUE)
i_ds_entete_cde.SetItem (1, DBNAME_VISITEUR_MAJ, g_s_visiteur)

fu_init_info_client()
if i_donnees_client.is_client_prospect() then
	i_ds_entete_cde.SetItem (1,DBNAME_CODE_PROSPECT, CODE_PREFIX_PROSPECT)
end if

i_ds_entete_cde.SetItem (1, DBNAME_BLOCAGE_SAP, CODE_PAS_DE_BLOCAGE)	
i_ds_entete_cde.SetItem (1, DBNAME_COMPTEUR_EXTRACTION, 1)
i_ds_entete_cde.SetItem (1, DBNAME_ORIGINE_CDE, g_nv_come9par.get_origine_cde())
i_ds_entete_cde.SetItem (1, DBNAME_TYPE_CDE, g_nv_come9par.get_type_cde())


// Modif version 2010-01-01
i_ds_entete_cde.SetItem (1, DBNAME_ARUN,i_donnees_client.fu_get_code_manquant())

/* Controle des differents codes 
   Si un code n'est pas alimenté, on positionne un ? pour permettre une equi jointure
   afin de ne pas avoir de jointure externe qui ne fonctionne pas sur tous les systemes */
if trim(i_ds_entete_cde.getItemString(1,DBNAME_ORIGINE_CDE)) =  DONNEE_VIDE then
	i_ds_entete_cde.SetItem (1, DBNAME_ORIGINE_CDE, CODE_INEXISTANT)
end if
if trim(i_ds_entete_cde.getItemString(1,DBNAME_TYPE_CDE)) =  DONNEE_VIDE then
	i_ds_entete_cde.SetItem (1, DBNAME_TYPE_CDE, CODE_INEXISTANT)
end if
if trim(i_ds_entete_cde.getItemString(1,DBNAME_CODE_MANQUANT)) =  DONNEE_VIDE then
	i_ds_entete_cde.SetItem (1, DBNAME_CODE_MANQUANT, CODE_INEXISTANT)
end if


/* Controle si le code blocage de la commande doit être positionné ou non */
fu_blocage_client()

is_numcde = s_numcde
is_client_livre = i_donnees_client.fu_get_code_client()
id_date_commande = Date(i_ds_entete_cde.getItemDateTime(1, DBNAME_DATE_PRIX))

fu_retrieve_info_client_livre()
fu_update_entete()
fu_update_message(false)
fu_retrieve_minimum_cde()
setPointer(Arrow!)
return is_numcde
end function

public subroutine fu_validation_commande (); /* <DESC>
    Permet de controler si la commande peut être validée ou non. Cette fonction est appelée en fin de saisie de la commande.
    Elle va réactualiser l'ensemble des blocages de l'entête de la commande. Si existence de blocage interdisant la validation de la commande,
	le code état de la commande sera positionné à Bloquer sinon il sera positionné à valider.
   </DESC> */
	 
i_ds_entete_cde.retrieve(fu_get_numero_cde())

// Réactualise tous les blocages et montants de l'entete de commande
integer   li_indice
datastore ds_ligne

ds_ligne= CREATE Datastore
ds_ligne.Dataobject = "d_ligne_cde"
ds_ligne.setTransObject(sqlca)

if i_ds_entete_cde.retrieve(is_numcde) = -1 then
	f_dmc_error ("Commande Object" + BLANK + DB_ERROR_MESSAGE)
end if

if ds_ligne.retrieve(is_numcde) = -1 then
	f_dmc_error ("Commande Object - Calclul total cde " + DB_ERROR_MESSAGE)
end if

fu_controle_si_client_livre_modifie()

fu_update_montants(ds_ligne)

fu_reactualise_les_blocages()

fu_update_entete()

i_ds_entete_cde.setItem(1,DBNAME_BLOCAGE_CDE_EDI, CODE_PAS_DE_BLOCAGE)

if fu_is_commande_bloquee() then
	messagebox(g_nv_traduction.get_traduction(VALIDATION_COMMANDE),  + &
	          g_nv_traduction.get_traduction(BLOCAGE_POSITIONNE), information!,ok!)
	return
End If

integer li_response = 1
if fu_is_blocage_non_bloquant() then
	if g_nv_come9par.is_relation_clientele() then
		li_response = messagebox(g_nv_traduction.get_traduction(VALIDATION_COMMANDE),  + &
		                          g_nv_traduction.get_traduction(EXISTENCE_BLOCAGE) + &
							  g_nv_traduction.get_traduction(VALIDER_COMMANDE) , &
							  Stopsign!, YesNo!)
	else
		i_ds_entete_cde.SetItem (1, DBNAME_ETAT_CDE, COMMANDE_BLOQUEE)
         fu_update_entete()		
		messagebox(g_nv_traduction.get_traduction(VALIDATION_COMMANDE),  + &
	           g_nv_traduction.get_traduction(BLOCAGE_POSITIONNE), information!,ok!)
	return
	end if
end if

if li_response = 2 then
	return
end if

if g_nv_come9par.is_relation_clientele() then
	i_ds_entete_cde.SetItem (1, DBNAME_ETAT_CDE, 	COMMANDE_VALIDEE)
end if

fu_update_entete()

end subroutine

private subroutine fu_controle_si_date_cde_modifiee ();/* <DESC>
 Controle si la date de commande a été modifiée.
 Si oui , on réactualise la date de prix à la date de commande.
 </DESC> */
 
Date   sd_date_commande

sd_date_commande = Date(i_ds_entete_cde.getItemDateTime (1, DBNAME_DATE_CDE)) 
if id_date_commande <> sd_date_commande  then
   i_ds_entete_cde.setItem (1, DBNAME_DATE_PRIX,i_ds_entete_cde.getItemDateTime (1, DBNAME_DATE_CDE)) 
    fu_update_entete()
end if

id_date_commande = Date(i_ds_entete_cde.getItemDateTime (1, DBNAME_DATE_CDE))
end subroutine

public function string fu_get_grossiste ();/* <DESC> 
      Retourne le code du grossiste de la commande
   </DESC>	*/
return i_ds_entete_cde.getItemString (1, DBNAME_GROSSISTE)

end function

private function string fu_get_type_cde ();/* <DESC> 
      Retourne le type de la commande
   </DESC>	*/
return i_ds_entete_cde.getItemString (1, DBNAME_TYPE_CDE)
end function

public function boolean fu_is_regroupement_cde_modifiable ();/* <DESC>
   Permet de déterminer si le code regroupement de la commande est modifiable ou non.
   Ceci est fonction du type de la commande et est parametré dans la table des types de commande
  </DESC> */
 
 str_pass l_str_work
l_str_work.s[1] = fu_get_type_cde()
l_str_work.s[2] = BLANK
l_str_work = i_nv_check_value.is_type_cde_valide (l_str_work)
if not l_str_work.b[1] then
	return true
end if	

if l_str_work.s[8] = "O" then
	return true
end if

return false
end function

public function boolean fu_is_commande_valorisable ();/* <DESC>
     Permet de déterminer si la commande est valorisable ou non.
	Ceci est déterminer en fonction du type de la commande et est paramétrée dans la  table des types de commande
 	</DESC> */
str_pass l_str_work
l_str_work.s[1] = fu_get_type_cde()
l_str_work.s[2] = BLANK
l_str_work = i_nv_check_value.is_type_cde_valide (l_str_work)
if not l_str_work.b[1] then
	return true
end if	

if l_str_work.s[7] = "O" then
	return true
end if

return false
end function

private subroutine fu_reactualise_blocages_niveau_lignes (ref datastore ads_ligne);/* <DESC>
     Permet de réactualiser les codes blocages de l'entete de la commande en fonction
	des blocages existant sur les lignes de la commande. Ce controle va se faire à partir des lignes de la commande
	chargées dans la datastore passée en argument.
	
	Les blocages possibles sont - Référence inexistante, Tarif inexistant, Qté minimal non atteinte, Ligne de commande indirecte
	Pour chacun de ces blocages, on remet à jour l'indicateur correspondant dans l'entete de la commande.
   </DESC> */

integer li_indice

// Controle des anomalies sur les lignes de cde
boolean lb_reference_inexistante = false
boolean lb_tarif_inexistant      = false
boolean lb_quantite_non_conforme = false
boolean lb_ligne_indirecte		   = false
boolean lb_ligne_promo  = false
String  ls_code_erreur

for li_indice = 1 to ads_ligne.RowCount()
	ls_code_erreur = ads_ligne.getItemString(li_indice, DBNAME_CODE_ERREUR_LIGNE)
	if ls_code_erreur 		= CODE_REFERENCE_INEXISTANTE then
		lb_reference_inexistante = true
	elseif ls_code_erreur 	= CODE_TARIF_INEXISTANT then
		lb_tarif_inexistant = true
	elseif ls_code_erreur 	= CODE_QTE_INF_MINI_CDE then
		lb_quantite_non_conforme = true
	elseif ls_code_erreur 	= CODE_QTE_ERREUR_TAILLE_LOT then
		lb_quantite_non_conforme = true
	elseif ls_code_erreur 	= CODE_TARIF_CATALOGUE_INEXISTANT then
		lb_tarif_inexistant = true	
	elseif ls_code_erreur 	= CODE_QTE_EDI_INCORRECT then
		lb_quantite_non_conforme = true	
	elseif ls_code_erreur 	= CODE_QTE_UNC_INCORRECT then
		lb_quantite_non_conforme = true	
	end if
	
	if ads_ligne.getItemString(li_indice, DBNAME_TYPE_SAISIE) = CODE_SAISIE_PROMO then
		lb_ligne_promo = true
	end if
	
	if ads_ligne.getItemString(li_indice, DBNAME_TYPE_LIGNE) = TYPE_LIGNE_INDIRECT then
		lb_ligne_indirecte = true
	end if
next

i_ds_entete_cde.setItem(1,DBNAME_BLOCAGE_REF, CODE_PAS_DE_BLOCAGE)
i_ds_entete_cde.setItem(1,DBNAME_BLOCAGE_TARIF, CODE_PAS_DE_BLOCAGE)
i_ds_entete_cde.setItem(1,DBNAME_BLOCAGE_QTE, CODE_PAS_DE_BLOCAGE)
i_ds_entete_cde.setItem(1,DBNAME_BLOCAGE_LIGNE_CDE, CODE_PAS_DE_BLOCAGE)
if lb_reference_inexistante then
	i_ds_entete_cde.setItem(1,DBNAME_BLOCAGE_REF, CODE_BLOCAGE)	
end if
if lb_tarif_inexistant then
	i_ds_entete_cde.setItem(1,DBNAME_BLOCAGE_TARIF, CODE_BLOCAGE)	
end if
if lb_quantite_non_conforme then
	i_ds_entete_cde.setItem(1,DBNAME_BLOCAGE_QTE, CODE_BLOCAGE)	
end if
if lb_ligne_indirecte then
	i_ds_entete_cde.setItem(1,DBNAME_BLOCAGE_LIGNE_CDE, CODE_BLOCAGE)	
end if

if lb_ligne_promo then
//	i_ds_entete_cde.setItem(1,DBNAME_PAIEMENT_EXPEDITON, CODE_NON_SOUMIS)
//	i_ds_entete_cde.setItem(1,DBNAME_PAIEMENT_EXPEDITON, "2")
end if
end subroutine

public subroutine fu_positionne_cde_a_valider ();/* <DESC>
    Permet de positionner la commande comme étant à valider
   </DESC> */

// cette option est utilisée lors de la saisie mode opératrice
i_ds_entete_cde.retrieve(fu_get_numero_cde())
i_ds_entete_cde.setItem(1,DBNAME_ETAT_CDE, COMMANDE_A_VALIDER)
 fu_update_entete()
end subroutine

public function boolean fu_is_manquant_obligatoire ();/* <DESC>
   Permet de déterminer si lors de la saisie de l'entête de la commande, le code manquant est obligatoire ou non.
  Ceci est fonction du type de la commande et est parametré dans la table des types de commande.
  </DESC> */
	
str_pass l_str_work
l_str_work.s[1] = fu_get_type_cde()
l_str_work.s[2] = BLANK
l_str_work = i_nv_check_value.is_type_cde_valide (l_str_work)
if not l_str_work.b[1] then
	return true
end if	

if l_str_work.s[9] = "O" then
	return true
end if

return false
end function

public function boolean fu_is_commande_bloquee_hors_indirecte ();boolean  lb_commande_bloquee = false
/* <DESC>
     Permet de déterminer si la commande est bloquée pour une autre raison que l'existence 
     de lignes de commande indirectes.
     
	 Cette fonction retourne vrai si  le client livré n'est pas un partenaire du donneur d'ordre ou si existence de références inexistantes ou
	si des lignes sont bloquées pour des problemes de minimum de commande.
   </DESC> */
if fu_is_client_prospect() then
	lb_commande_bloquee = true
end if

if i_ds_entete_cde.getItemString(1, DBNAME_BLOCAGE_PARTENAIRE) = CODE_BLOCAGE then
	lb_commande_bloquee = true
end if

// Controle des anomalies sur les lignes de cde
if i_ds_entete_cde.getItemString(1,DBNAME_BLOCAGE_REF) =  CODE_BLOCAGE then
	lb_commande_bloquee = true	
end if

if i_ds_entete_cde.getItemString(1,DBNAME_BLOCAGE_QTE) =  CODE_BLOCAGE then
	lb_commande_bloquee = true
end if
return lb_commande_bloquee 
end function

public subroutine fu_init_info_client ();/* <DESC> 
      Permet d'initialiser les données de l'entête de la commande à partir des données du client donneur d'ordre
      Les données initialisées sont 	Client livré,code manquant,code echeance,devise, marche,liste de prix,mode expedition,
	 code correspondanciere,incoterm,indicteur regroupement des commandes,paiement expedition,mode paiement
	 
	 Si existence d'un seul client livré associé au client donneur d'ordre, Initialisation de l'incoterm à partir de celui ci
   </DESC>	*/
i_ds_entete_cde.SetItem (1, DBNAME_CLIENT_CODE, i_donnees_client.fu_get_code_client())
i_ds_entete_cde.SetItem (1, DBNAME_CODE_MANQUANT, i_donnees_client.fu_get_code_manquant())
i_ds_entete_cde.SetItem (1, DBNAME_CODE_ECHEANCE, i_donnees_client.fu_get_code_echeance())
i_ds_entete_cde.SetItem (1, DBNAME_CODE_DEVISE, i_donnees_client.fu_get_code_devise())		
i_ds_entete_cde.SetItem (1, DBNAME_CODE_MARCHE,i_donnees_client.fu_get_code_marche())				
i_ds_entete_cde.SetItem (1, DBNAME_LISTE_PRIX, i_donnees_client.fu_get_liste_prix())				
i_ds_entete_cde.SetItem (1, DBNAME_CODE_MODE_EXP, i_donnees_client.fu_get_mode_expedition())
i_ds_entete_cde.SetItem (1, DBNAME_CODE_PROSPECT, i_donnees_client.fu_get_prefix_client())	
i_ds_entete_cde.SetItem (1, DBNAME_ETAT_CDE, COMMANDE_SUSPENDUE)
i_ds_entete_cde.SetItem (1, DBNAME_CODE_CORREPONDANTE, i_donnees_client.fu_get_correspondanciere())		
i_ds_entete_cde.SetItem (1, DBNAME_CODE_INCOTERM, i_donnees_client.fu_get_incoterm1())
i_ds_entete_cde.SetItem (1, DBNAME_CODE_INCOTERM_2, i_donnees_client.fu_get_incoterm2())
i_ds_entete_cde.SetItem (1, DBNAME_REGROUPEMENT_ORDRE, i_donnees_client.fu_get_regroupement_ordre())
i_ds_entete_cde.SetItem (1, DBNAME_PAIEMENT_EXPEDITON, i_donnees_client.fu_get_paiement_expedition())
i_ds_entete_cde.SetItem (1, DBNAME_MODE_PAIEMENT, i_donnees_client.fu_get_mode_paiement())
i_ds_entete_cde.SetItem (1, DBNAME_UCC, i_donnees_client.fu_get_ucc())

if i_donnees_client.is_client_prospect() then
	i_ds_entete_cde.SetItem (1, DBNAME_CLIENT_LIVRE_CODE, i_donnees_client.fu_get_code_client())
	return
end if

nv_datastore ds_livres
ds_livres = create nv_datastore
ds_livres.dataobject = "d_object_liste_client_livre"
ds_livres.settrans (sqlca)
ds_livres.retrieve (i_donnees_client.fu_get_code_client())

if ds_livres.rowcount() > 1 then
	i_ds_entete_cde.SetItem (1, DBNAME_CLIENT_LIVRE_CODE, '???')
	return
end if

if ds_livres.rowcount() = 0 then
	i_ds_entete_cde.SetItem (1, DBNAME_CLIENT_LIVRE_CODE,i_donnees_client.fu_get_code_client( ) )
	return
end if

i_ds_entete_cde.SetItem (1, DBNAME_CLIENT_LIVRE_CODE,ds_livres.getItemString(1,DBNAME_CLIENT_LIVRE_CODE))
i_ds_client_livre.retrieve(ds_livres.getItemString(1,DBNAME_CLIENT_LIVRE_CODE))
i_ds_entete_cde.SetItem (1, DBNAME_CODE_INCOTERM, i_ds_client_livre.getItemString(1,DBNAME_CODE_INCOTERM))
i_ds_entete_cde.SetItem (1, DBNAME_CODE_INCOTERM_2, i_ds_client_livre.getItemString(1,DBNAME_CODE_INCOTERM_2))
end subroutine

public function boolean fu_is_commande_transferee ();/* <DESC>
    Permet de déterminer si la commande a été transférée dans SAP
   </DESC> */
if i_ds_entete_cde.getItemString(1, DBNAME_ETAT_CDE) = COMMANDE_TRANSFEE  then
	return true
else
	return false
end if

end function

public function integer fu_retrieve_commande ();/* <DESC>
    Permet de rafraichir les données de la commande
   </DESC> */
	 
return i_ds_entete_cde.retrieve(is_numcde)
end function

public subroutine fu_update_entete ();/* <DESC>
    Permet d'effectuer la mise à jour de l'entête de commande aprés initialisation du visiteur ayant mis à jour la commande
    ainsi que la date de création
   </DESC> */
SetPointer  (HourGlass!)
i_ds_entete_cde.SetItem (1, DBNAME_VISITEUR_MAJ, g_s_visiteur)
i_ds_entete_cde.SetItem (1, DBNAME_DATE_CREATION, sqlca.fnv_get_datetime ())
i_ds_entete_cde.update()
//if i_ds_entete_cde.update() = -1 then
//   f_dmc_error ("Commande Object - Update entete cde " + i_ds_entete_cde.uf_getdberror( ) )
//end if

COMMIT USING SQLCA;

i_ds_entete_cde.retrieve(fu_get_numero_cde())

SetPointer  (Arrow!)
end subroutine

public function long fu_get_nbr_lignes_cde ();/* <DESC> 
      Retourne le nombre de lignes de la commande
   </DESC>	*/
return il_nbr_lignes_cde
end function

public function boolean fu_existe_ligne_cde_catalogue (string as_catalogue, ref string as_type_tarif);/* <DESC>
   Permet de définir s'il existe des lignes de commande saisies pour le catalogue spécifié pour le type de tarif souhaité 
   dans la commande en cours de traitement.
   </DESC>
*/
nv_ligne_cde_object lnv_ligne_cde
lnv_ligne_cde = create nv_ligne_cde_object

return lnv_ligne_cde.fu_existe_ligne_pour_catalogue(fu_get_numero_cde(),as_catalogue,as_type_tarif)

end function

public subroutine fu_validation_par_message ();fu_reactualise_les_blocages()
fu_update_entete()
end subroutine

public subroutine fu_validation_par_ligne_catalogue ();i_ds_entete_cde.retrieve(fu_get_numero_cde())
 fu_update_entete()
end subroutine

public subroutine fu_validation_par_promo ();i_ds_entete_cde.retrieve(fu_get_numero_cde())
 fu_update_entete()
end subroutine

public function string fu_get_visiteur_cde ();/* <DESC> 
      Retourne le code du visiteur de la commande
   </DESC>	*/
return i_ds_entete_cde.getItemString (1, DBNAME_CODE_VISITEUR)
end function

public function string fu_get_ucc ();/* <DESC> 
      Retourne le code unite de comande client
   </DESC>	*/
return i_ds_entete_cde.getItemString(1, DBNAME_UCC)
end function

public function string fu_get_alerte ();return i_donnees_client.fu_get_alerte( )
end function

public function boolean fu_is_commande_drop ();String ls_manquant

ls_manquant = i_ds_entete_cde.getItemString(1,DBNAME_CODE_MANQUANT)
if ls_manquant = CODE_MQT_KEEP then
	return false
else
	return true
end if

return true
end function

public function string fu_get_keepdrop_promo ();return i_ds_entete_cde.getItemString(1,DBNAME_NUM_VALIDATION_CDE)
end function

public subroutine fu_maj_keepdrop_promo (string as_keepdrop_code);i_ds_entete_cde.SetItem(1,DBNAME_NUM_VALIDATION_CDE,as_KeepDrop_Code)
fu_update_entete()
end subroutine

public function string fu_get_keepdrop_commande ();return i_ds_entete_cde.getItemString(1,DBNAME_CODE_MANQUANT)
end function

public function boolean fu_is_promotion_drop ();String ls_manquant

ls_manquant = i_ds_entete_cde.getItemString(1,DBNAME_NUM_VALIDATION_CDE)
if ls_manquant = CODE_MQT_KEEP then
	return false
else
	return true
end if

end function

public subroutine fu_blocage_client ();/* Controle si le code blocage de la commande doit être positionné ou non */
String ls_blocage

if i_donnees_client.is_cde_a_bloquer( ls_blocage) then
	i_ds_entete_cde.SetItem (1, DBNAME_CODE_BLOCAGE_SAP, ls_blocage)
	i_ds_entete_cde.setItem(1,DBNAME_BLOCAGE_SAP, CODE_BLOCAGE)
end if

end subroutine

private subroutine fu_update_table_message (string as_datawindow_cde, string as_datawindow_client, string as_code_client, string as_code_langue, boolean ab_suppression_avant);/* <DESC> 
    Fonction générique permettant de créer le texte associé à la commande en fonction des arguments donnés.
    Les arguments sont : 
	   Nom de la datawindow correspondante au texte associé à la commande
	   Nom de la datawindow correspondante au texte associé au client
	   Le code du client
	   Le code langue
		
    A partir de ces arguments, 
	  initialisation des 2 datatsores allant contenir le texte de la commande et du client.
	  suppression du textes associé à la commande 
	  extraction du texte associé au client et création du texte à la commande.
</DESC> */  	 

nv_Datastore ds_message_cde
nv_Datastore ds_message_client

ds_message_cde = CREATE nv_Datastore
ds_message_client = CREATE nv_Datastore

ds_message_cde.dataobject = as_datawindow_cde
ds_message_cde.SetTransObject(sqlca)
if ds_message_cde.retrieve(fu_get_numero_cde(),as_code_langue) = -1 then
	f_dmc_error ("Objet Commande - update bordereau " + DB_ERROR_MESSAGE)	
end if

if as_datawindow_client <> "" then
	ds_message_client.dataobject = as_datawindow_client 
	ds_message_client.SetTransObject(sqlca)
	if ds_message_client.retrieve(as_code_client,as_code_langue) = -1 then
		f_dmc_error ("Objet Commande - update bordereau " + DB_ERROR_MESSAGE)	
	end if
end if

// suppression de toutes les lignes messages associées à la commande
integer li_indice
integer li_numero_ligne

if ab_suppression_avant  then
	
	ds_message_cde.RowsMove(1, ds_message_cde.RowCount(), Primary!,  ds_message_cde, 1, Delete!)
//	for li_indice = 1 to ds_message_cde.RowCount()
//		ds_message_cde.deleteRow(li_indice)
//	next
	li_numero_ligne = 0
	ds_message_cde.update()
else	
	// recherche du dernier n° de ligne
	li_numero_ligne = ds_message_cde.rowcount()
end if

if as_datawindow_client = "" then
	Destroy ds_message_cde
     return
end if

// creation des nouveaux messages à partir de ceux du client
String s_num
for li_indice = 1 to ds_message_client.RowCount()
	li_numero_ligne = li_numero_ligne + 1
	ds_message_cde.insertRow(li_numero_ligne)
	ds_message_cde.setItem(li_numero_ligne, DBNAME_DATE_CREATION, SQLCA.fnv_get_datetime())
	ds_message_cde.SetItem (li_numero_ligne, DBNAME_CODE_MAJ, CODE_CREATION)	
	ds_message_cde.SetItem (li_numero_ligne, DBNAME_NUM_CDE, is_numcde)

	s_num = String(li_numero_ligne)
	do until len (String(s_num)) = 3
		s_num = "0" + String(s_num)
	loop
	
	ds_message_cde.SetItem (li_numero_ligne, DBNAME_MESSAGE_NUM_LIGNE, s_num)	
	ds_message_cde.SetItem (li_numero_ligne, DBNAME_MESSAGE, mid(ds_message_client.getItemString(li_indice,DBNAME_MESSAGE),1,70))		
     ds_message_cde.SetItem (li_numero_ligne, DBNAME_CODE_LANGUE, ds_message_client.getItemString(li_indice,DBNAME_CODE_LANGUE))				  
next

if ds_message_cde.update() = -1 then
	f_dmc_error("Erreur creation texte " + as_datawindow_cde + " ;" + ds_message_cde.uf_getdberror( ))
end if
ds_message_client.update()

Destroy ds_message_client
Destroy ds_message_cde
end subroutine

public subroutine fu_update_message (boolean ab_suppression_avant);/* <DESC>
    Permet de mettre à jour les différents textes à associer à la commande et ceci à partir des textes desdifférents clients de la commande
    Mise à jour des textes à partir de ceux du client livré, du client facturé,du client donneur d'ordre
   </DESC> */
	
fu_update_message_livre(ab_suppression_avant)
// message facture
//fu_update_table_message("d_texte_come9089", "d_texte_come9084" ,fu_get_client_facture(),fu_get_code_langue_facture(),ab_suppression_avant)
fu_update_table_message("d_texte_come9089", "d_texte_come9084" ,fu_get_client_facture(),'F',ab_suppression_avant)
// transitaire
//fu_update_table_message("d_texte_come9090", "d_texte_come9085" ,fu_get_client_donneur_ordre(),fu_get_code_langue(),ab_suppression_avant)
fu_update_table_message("d_texte_come9090", "d_texte_come9085" ,fu_get_client_donneur_ordre(),'F',ab_suppression_avant)
// instruction de commande
//fu_update_table_message("d_texte_come9091", "d_texte_come9080" ,fu_get_client_donneur_ordre(),fu_get_code_langue(),ab_suppression_avant)
fu_update_table_message("d_texte_come9091", "d_texte_come9080" ,fu_get_client_donneur_ordre(),'F',ab_suppression_avant)

// message bordereau
//fu_update_table_message("d_texte_come9086", "d_texte_come9081" ,fu_get_client_donneur_ordre(),fu_get_code_langue(),ab_suppression_avant)
fu_update_table_message("d_texte_come9086", "d_texte_come9081" ,fu_get_client_donneur_ordre(),'F',ab_suppression_avant)

// message bordereau_complement
//fu_update_table_message("d_texte_come9086_complement", "" ,fu_get_client_donneur_ordre(),fu_get_code_langue(),ab_suppression_avant)
fu_update_table_message("d_texte_come9086_complement", "" ,fu_get_client_donneur_ordre(),'F',ab_suppression_avant)

// Mise à jour de l'entete de commande
//fu_update_entete()

end subroutine

private subroutine fu_update_message_livre (boolean ab_suppression_avant);/* <DESC>
   Création des textes message bordereau, marquage caisse,Transporteur à partir de ceux de la fiche du client livré
   </DESC> */
String ls_livre

ls_livre =fu_get_client_livre()
// marquage caisse
//fu_update_table_message("d_texte_come9088", "d_texte_come9083" ,fu_get_client_livre(),fu_get_code_langue_livre(),ab_suppression_avant)
fu_update_table_message("d_texte_come9088", "d_texte_come9083" ,fu_get_client_livre(),'F',ab_suppression_avant)
// transporteur
//fu_update_table_message("d_texte_come9087", "d_texte_come9082" ,fu_get_client_livre(),fu_get_code_langue(),ab_suppression_avant)
fu_update_table_message("d_texte_come9087", "d_texte_come9082" ,fu_get_client_livre(),'F',ab_suppression_avant)
//fu_update_table_message("d_texte_come9087_complement", "" ,fu_get_client_livre(),fu_get_code_langue(),ab_suppression_avant)
fu_update_table_message("d_texte_come9087_complement", "" ,fu_get_client_livre(),'F',ab_suppression_avant)
end subroutine

public function boolean fu_is_referencement_client ();return i_donnees_client.ib_referencement_client

end function

public subroutine fu_get_critere_referencement (ref string as_enseigne, ref string as_client);i_donnees_client.fu_get_critere_ref_client( as_enseigne,as_client)
end subroutine

public subroutine fu_retrieve_minimum_cde ();/* <DESC>
   Permet d'extraire le montant minimum de la commande en fonction du code marché et de la devisede la commande
   </DESC> */
if i_ds_controle_minimum_cde.retrieve(fu_get_marche(),fu_get_devise()) = -1 then
	f_dmc_error ("Commande Object : Minimum cde" + BLANK + DB_ERROR_MESSAGE)
end if
end subroutine

public function boolean fu_is_commande_franco ();
//if i_ds_entete_cde.getItemString(1, DBNAME_PAIEMENT_EXPEDITON) =CODE_SOUMIS  then
//	return true
//else
//	return false
//end if
if i_ds_entete_cde.getItemString(1, DBNAME_PAIEMENT_EXPEDITON) ="1"  then
	return true
else
	return false
end if
end function

private function boolean fu_controle_si_client_livre_modifie ();/* <DESC>
Controle si le client livré a été modifié lors de la modification de l'entete de la commande.
Si oui , on réactualise les éléments texte de la commande associés au client livré
 </DESC> */

if is_client_livre <> i_ds_entete_cde.getItemString (1, DBNAME_CLIENT_LIVRE_CODE) then
   if  i_ds_client_livre.retrieve(is_client_livre) < 1  then
	 return false
end if
   fu_update_message_livre(true)
	is_client_livre = i_ds_entete_cde.getItemString (1, DBNAME_CLIENT_LIVRE_CODE) 
	if fu_retrieve_info_client_livre() then
 		return true
	else
		return false
	end if
end if

return false
end function

public function boolean fu_retrieve_info_client_livre ();/* <DESC>
     Permet de rafraichir les données du client livré 
   </DESC> */
is_client_livre = i_ds_entete_cde.getItemString(1, DBNAME_CLIENT_LIVRE_CODE)

if i_ds_client_livre.retrieve(is_client_livre) = -1 then
	f_dmc_error ("Commande Object : Client livre" + BLANK + DB_ERROR_MESSAGE)
	return false
end if

return true
end function

on nv_commande_object.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nv_commande_object.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;/* <DESC>
   Initialisation des datastores necessaire à l'objet.
	 - Infos Entete de cde,  Client, Minimum de cde
   </DESC> */
i_ds_entete_cde = CREATE nv_Datastore
i_ds_entete_cde.Dataobject = "d_object_cde"
i_ds_entete_cde.setTransObject (sqlca)

i_nv_check_value = CREATE nv_control_manager

i_ds_client_livre = CREATE Datastore
i_ds_client_livre.Dataobject = "d_object_client"
i_ds_client_livre.setTransObject(sqlca)

i_ds_controle_minimum_cde = CREATE Datastore
i_ds_controle_minimum_cde.Dataobject = "d_object_minimum_cde"
i_ds_controle_minimum_cde.setTransObject(sqlca)

end event

