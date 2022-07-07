$PBExportHeader$erfvmr.sra
$PBExportComments$Application Force de vente
forward
global type erfvmr from application
end type
global nv_sqlca sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global nv_error error
global nv_message message
end forward

global variables
// Variables utilisées par PT5.0
//w_fa		   	g_w_frame
w_frame_erfvmr g_w_frame
nv_ini			g_nv_ini
nv_msg_manager	g_nv_msg_mgr
nv_components	g_nv_components
nv_environment	g_nv_env
userobject		g_nv_security
userobject		g_nv_nav_manager
str_user			g_str_user
nv_trace          g_nv_trace
boolean          g_b_traduction = false
	
nv_list_manager     g_nv_liste_manager
nv_come9par			  g_nv_come9par
nv_traduction			g_nv_traduction 

String g_s_version =   ''
String g_s_patch    =  ''

nv_workflow_manager g_nv_workflow_manager
String      g_s_fenetre_destination

String      g_s_fenetre_actuelle
// Informations Utilisateur
String		g_s_visiteur

// Informations Sasisie de commande
String		g_s_tarif
String		g_s_position_cpte

Integer    g_i_option_liste_cde_visiteur = 1
Integer    g_i_option_liste_derniere_cde = 5
// Informations sur l'option principale du menu
//   Cette info va permettre de savoir si la liste des 
//   clients doit être filtrée ou non 
//     (Affichage de tous les clients ou uniquement de ceux
//      ayant une nature = 0'

//String		g_s_origine
String      g_s_valide 
// Informations Commande en cours
String		g_s_cde_tarif
Decimal	g_dec_cde_remise

/* ===================================================
     constantes correpondantes aux noms des champs de la base de données
	 =================================================== */
Constant String DBNAME_TABLE_CLIENT								= "come9040"
Constant String DBNAME_PAYS 		 								= "codaepay"
Constant String DBNAME_CODE_ADRESSE						= "codeeadr"
Constant String DBNAME_PAYS_INTITULE							= "libaepay"
Constant String DBNAME_CLIENT_CODE 								= "numaeclf"
Constant String DBNAME_CLIENT_ABREGE_NOM 						= "abnaeclf"
Constant String DBNAME_CLIENT_NOM_COMPLET1					= "nomaecl1"
Constant String DBNAME_CLIENT_NOM_COMPLET2					= "nomaecl2"
Constant String DBNAME_CLIENT_ADRESSE_RUE						= "rueaeclf"
Constant String DBNAME_CLIENT_ADRESSE_RUE_COMPLEMENTAIRE	= "cpaaeclf"
Constant String DBNAME_CLIENT_ABREGE_VILLE					= "abvaeclf"
Constant String DBNAME_CLIENT_REGION 							= "codaereg"
Constant String DBNAME_CLIENT_CODE_POSTAL						= "codaepos"
Constant String DBNAME_CLIENT_BUREAU_DISTRIBUTEUR		 	= "buraedis"
Constant String DBNAME_CLIENT_TELEPHONE       				= "numaetel"
Constant String DBNAME_CLIENT_TELEPHONE_PORTABLE       	= "numaegsm"
Constant String DBNAME_CLIENT_FAX       						= "numaetlx"
Constant String DBNAME_CLIENT_EMAIL      						= "adraeema"
Constant String DBNAME_BANQUE		       						= "domaeban"
Constant String DBNAME_BANQUE_RIB       						= "ribae000"
Constant String DBNAME_CODE_MANQUANT 							= "codaemqt"
Constant String DBNAME_SIRET		       						= "numaesin"
Constant String DBNAME_IDENT_TVA	       						= "nidaetva"
Constant String DBNAME_CODE_ACTIVITE      						= "actae000"
Constant String DBNAME_CODE_ECHEANCE 							= "codaeech"
Constant String DBNAME_CODE_ECHEANCE_INTITULE				= "libaeech"
Constant String DBNAME_MODE_PAIEMENT 							= "cmdaepai"
Constant String DBNAME_MODE_PAIEMENT_INTITULE            = "libaempf"
Constant String DBNAME_CODE_CORREPONDANTE 					= "numaeco1"
Constant String DBNAME_CODE_CORREPONDANTE_NOM				= "libaecor"
Constant String DBNAME_NATURE_CLIENT    						= "nataeclf"
Constant String DBNAME_NATURE_CLIENT_INTITULE 				= "lnaaeclf"
Constant String DBNAME_GRANDE_FONCTION    					= "gfcaeclf"
Constant String DBNAME_GRANDE_FONCTION_INTITULE		= "lgfaeclf"
Constant String DBNAME_FONCTION    								= "fctaeclf"
Constant String DBNAME_FONCTION_INTITULE      				= "lfcaeclf"
Constant String DBNAME_DATE_CREATION							= "timefcre"
Constant String DBNAME_DATE_MAJ									= "dteefmaj"
Constant String DBNAME_CODE_VISITEUR							= "codeevis"
Constant String DBNAME_CODE_MAJ									= "codeemaj"
Constant String DBNAME_NOUVEAU_CLIENT							= "nouaecli"
Constant String DBNAME_LISTE_PRIX								= "lisaepri"
Constant String DBNAME_CODE_DEVISE								= "codaedev"
Constant String DBNAME_NOM_VISITEUR								= "nomeevis"
Constant String DBNAME_COMPTEUR_COMMANDE						= "ncdaeter"
Constant String DBNAME_COMPTEUR_PROSPECT						= "nseef002"
Constant String DBNAME_COMPTEUR_EXTRACTION					= "cptafxtr"
Constant String DBNAME_ORIGINE_CDE								= "coraecde"
Constant String DBNAME_ORIGINE_CDE_INTITULE					= "lboaecde"
Constant String DBNAME_CODE_MARCHE					          = "codaemar"
Constant String DBNAME_CODE_MARCHE_INTITULE                = "libaemar"
Constant String DBNAME_TYPE_CDE									= "typaecde"
Constant String DBNAME_TYPE_CDE_INTITULE						= "libaetcd"
Constant String DBNAME_TYPE_VISITEUR							= "typaevsr"
Constant String DBNAME_CODE_DEVISE_INTITULE					= "libaedev"
Constant String DBNAME_CLIENT_PAYEUR_CODE						= "cliaepay"
Constant String DBNAME_CLIENT_PAYEUR_ABREGE_NOM			= "abnaeclp"
Constant String DBNAME_CLIENT_PAYEUR_ABREGE_VILLE			= "abvaeclp"
Constant String DBNAME_CLIENT_FACTURE_CODE					= "cliaefac"
Constant String DBNAME_CLIENT_FACTURE_ABREGE_NOM			= "abnaeclf"
Constant String DBNAME_CLIENT_FACTURE_ABREGE_VILLE		   = "abvaeclf"
Constant String DBNAME_CLIENT_LIVRE_CODE						= "cliaeliv"
Constant String DBNAME_CLIENT_LIVRE_ABREGE_NOM				= "abnaecll"
Constant String DBNAME_CLIENT_LIVRE_ABREGE_VILLE			= "abvaecll"
Constant String DBNAME_CODE_VISITEUR_CLIENT					= "codaevis"
Constant String DBNAME_CODE_NIVEAU_RESP						= "codaedir"
Constant String DBNAME_CODE_NIVEAU_RESP_INTITULE			= "nomaedir"
Constant String DBNAME_CODE_MODE_EXP							= "codaemxp"
Constant String DBNAME_CODE_RESP_SECTEUR						= "numaeto0"
Constant String DBNAME_CODE_RESP_SECTEUR_INTITULE			= "libaetou"
Constant String DBNAME_CODE_LANGUE								= "codaelan"
Constant String DBNAME_CODE_LANGUE_INTITULE					= "libaelan"
Constant String DBNAME_CODE_MODE_EXP_INTITULE				= "libaemxp"
Constant String DBNAME_CODE_INCOTERM							= "incaete1"
Constant String DBNAME_CODE_INCOTERM_2							= "incaete2"
Constant String DBNAME_CODE_INCOTERM_INTITULE				= "linaete1"
Constant String DBNAME_PAIEMENT_EXPEDITON						= "paiaeexp"
Constant String DBNAME_GROSSISTE									= "numaegrf"
Constant String DBNAME_GROSSISTE_ABREGE_NOM 					= "abnaegro"
Constant String DBNAME_GROSSISTE_ABREGE_VILLE				= "abvaegro"
Constant String DBNAME_NUM_CDE									= "numaecde"
Constant String DBNAME_DATE_LIVRAISON						   = "dtsaeliv"
Constant String DBNAME_DATE_CDE								   = "dataecde"
Constant String DBNAME_DATE_SAISIE_CDE						   = "dtsaecde"
Constant String DBNAME_NBR_LIGNE_CDE						   = "nbraflig"
Constant String DBNAME_NUM_VALIDATION_CDE					   = "nseef005"
Constant String DBNAME_TEXT_EXPEDITION						   = "txtaeexp"
Constant String DBNAME_TEXT_FACTURE							   = "txtaefac"
Constant String DBNAME_TEXT_MARQUAGE_CAISSE				   = "txtaemca"
Constant String DBNAME_TEXT_TRANSPORTEUR					   = "txtaetpt"
Constant String DBNAME_TEXT_TRANSITAIRE					   = "txtaettr"
Constant String DBNAME_TEXT_MESSAGE						   	= "txtaemsg"
Constant String DBNAME_REGROUPEMENT_ORDRE 				   = "rgtaeord"
Constant String DBNAME_CODE_PROSPECT		 				   = "codaeprp"
Constant String DBNAME_CODE_BLOCAGE_SAP	 				   = "cblaesap"
Constant String DBNAME_CODE_BLOCAGE_SAP_INTITULE			= "lcbaesap"
Constant String DBNAME_BLOCAGE_REF	 				   		= "blcaerix"
Constant String DBNAME_BLOCAGE_TARIF	 				   	= "blcaetab"
Constant String DBNAME_BLOCAGE_QTE	 				   		= "blcaeqnc"
Constant String DBNAME_BLOCAGE_MINI_CDE				   	= "blcaemcd"
Constant String DBNAME_BLOCAGE_CDE_EDI				   		= "blcaeedi"
Constant String DBNAME_BLOCAGE_MSG_CDE				 			= "blcaemsg"
Constant String DBNAME_BLOCAGE_LIGNE_CDE			  			= "blcaelin"
Constant String DBNAME_BLOCAGE_PARTENAIRE			   		= "blcaepnc"
Constant String DBNAME_BLOCAGE_SAP					  		 	= "blcaesap"
Constant String DBNAME_MONTANT_CDE_DIRECT			  		 	= "mntaedir"
Constant String DBNAME_MONTANT_CDE_INDIRECT		  		 	= "mntaeind"
Constant String DBNAME_MONTANT_CDE_GROSSISTE		  		 	= "mntaegrf"
Constant String DBNAME_MONTANT_DETTE_ECHUE					= "detaeech"
Constant String DBNAME_DATE_PRIX									= "dataepri"
Constant String DBNAME_MESSAGE									= "ligaetxt"
Constant String DBNAME_MESSAGE_NUM_LIGNE						= "numaelig"
Constant String DBNAME_ARUN										= "cvaaerun"
Constant String DBNAME_ARUN_INTITULE							= "lcvaerun"
Constant String DBNAME_ARTICLE									= "artae000"
Constant String DBNAME_DIMENSION									= "dimaeart"
Constant String DBNAME_MONTANT_LIGNE							= "mtlaehtt"
Constant String DBNAME_MONTANT_REMISE_LIGNE					= "mnraepr1"
Constant String DBNAME_TYPE_LIGNE							   = "ctyaesai"
Constant String DBNAME_QTE										   = "qteaeuve"
Constant String DBNAME_CODE_PROMO							   = "npraeact"
Constant String DBNAME_CODE_CATALOGUE						   = "codaectg"
Constant String DBNAME_CATALOGUE_INTITULE					   = "libaectg"
Constant String DBNAME_PAYANT_GRATUIT						   = "proaegra"
Constant String DBNAME_REMISE_LIGNE							   = "tauaerli"
Constant String DBNAME_REMISE_CDE							   = "tauaersa"
Constant String DBNAME_TARIF									   = "taraeecv"
Constant String DBNAME_CODE_ERREUR_LIGNE					   = "crfaeerr"
Constant String DBNAME_TYPE_SAISIE							   = "typaesai"
Constant String DBNAME_NUM_LIGNE									= "nseef005"
Constant String DBNAME_PRIX_ARTICLE								= "priaeart"
Constant String DBNAME_TAILLE_LOT								= "taiaelot"
Constant String DBNAME_CLASSE_REFERENCE						= "claaesse"
Constant String DBNAME_ETAT_CDE									= "cetaecde"
Constant String DBNAME_DESCRIPTION_REF							= "desaeref"
Constant String DBNAME_ARTICLE_AVEC_TABLE						= "come9030.artae000"
Constant String DBNAME_GROUPE_POSTE							   = "gtyaepst"
Constant String DBNAME_TYPE_ARTICLE							   = "typaeart"
Constant String DBNAME_QTE_MINI_CDE							   = "mcdaeart"
Constant String DBNAME_INTITULE_BON_CDE						= "libaebcd"
Constant String DBNAME_NUM_PAGE									= "numaepag"
Constant String DBNAME_QTE_PUBLI_PROMO							= "qteaeuni"
Constant String DBNAME_CODE_PAGE									= "codaepag"
Constant String DBNAME_MINIMUM_CDE								= "minaecde"
Constant String DBNAME_VALORISATION_CDE						= "valaecde"
Constant String DBNAME_MODIF_REGROUPEMENT_CDE				= "rgtaeord"

Constant String DBNAME_CODE_TABLE								= "codeetab"
Constant String DBNAME_INTITULE_TABLE							= "nomeetab"
Constant String DBNAME_EXTRACTION_DATE						= "extefdat"
Constant String DBNAME_EXTRACTION_VISITEUR				= "extefvis"
Constant String DBNAME_EXTRACTION_MARCHE  				= "extefmar"
Constant String DBNAME_MOT_PASSE								= "moteepas"
Constant String DBNAME_EXTRACTION_POUR_VENDEUR		= "extefven"
Constant String DBNAME_EXTRACTION_POUR_RC          		= "extefrcl"
Constant String DBNAME_EXTRACTION_POUR_FI          		="exteffil"

Constant String DBNAME_VISITEUR_POUR_EXTRACTION          = "come9040.dstaevis"
Constant String DBNAME_DIRECTEUR_REGION_POUR_EXTRACTION  = "come9040.dstaedre"
Constant String DBNAME_CODE_VISITEUR_MARCHE				   = "come9mpv.codaevis"
Constant String DBNAME_NUMCDE_SAP                                      = "NUMAECDE"
Constant string DBNAME_PRIX_CATALOGUE                               = "tareecat"
Constant string DBNAME_VISITEUR_EXTRACT        					= "dstaevis"
Constant String DBNAME_DIRECTEUR_REGION_EXTRACT     = "dstaedre"

Constant String DBNAME_VISITEUR_MAJ                                     = "cviaemaj"     // Modif du 01/2005
Constant string DBNAME_CODE_SELECTION						   = "codeesel"   // Modif du 03/2005
Constant string DBNAME_DATE_MAJ_PROSPECT					= "dteaeprp"
Constant string DBNAME_DATE_MAJ_NCDTER					= "dteaencd"

Constant String DBNAME_VALEUR_PARAM							= "valparam"
Constant String DBNAME_CLASSE_ABC								= "claaeabc"
Constant String DBNAME_FLAG_SUBSTITUT						= "flag_substitut" // Modif du 23/01/06
Constant String DBNAME_ARTICLE_CLIENT                            = "artaeclt"
Constant String DBNAME_PARAM_LANGUE                              = "COME9PRM.CODLANG"
Constant String DBNAME_CATALOGUE_DESCR_REF			= "desaeref"

Constant String DBNAME_DETAEECH_FACTOR					= "detaeech_factor"
Constant String DBNAME_ECRAECLF_FACTOR					= "ecraeclf_factor"
Constant String DBNAME_UCC                                                     = "j_3akvgr7"
Constant String DBNAME_UCC_INTITULE                                 =  "intitule"
Constant String DBNAME_PCB                                                      = "pcb"
Constant String DBNAME_UNITE_CONSO                                  ="vrkme"
Constant String DBNAME_UNITE_VENTE                                   ="uniaeqte"
Constant String DBNAME_QTE_UN                                              = "qteaeun"
Constant String DBNAME_UNITE_LIGCDE                                  ="uniqteprd"
Constant String DBNAME_UNIPAR                                                 = "uniaepar"

Constant String DBNAME_VERSION                                              = "num_version"

Constant String DBNAME_EDIT_DTE_LIVTOT                            = "dtlaetot"
Constant String DBNAME_EDIT_DTE_LIVTART                          = "dtlaetar"
Constant String DBNAME_MAGASIN_EDI								  = "numaemag"
Constant String DBNAME_MAGASIN_CDE_EDI                           = "ncdaemag"

Constant String DBNAME_FORCE_MAJ								   = "force_maj_complete"
Constant String DBNAME_ENSEIGNE								   = "katr6"


/* ===================================================
     constantes correpondantes à la longueur de certains champs
   =================================================== */
Constant integer LONG_CLIENT_CODE 	 = 10
Constant integer LONG_CLIENT_NOM  	 = 10
Constant integer LONG_CLIENT_VILLE   = 10
Constant integer LONG_CLIENT_DEPT    = 3
Constant integer LONG_CLIENT_PAYS    = 3
Constant integer LONG_MESSAGE		    = 64
Constant integer LONG_NUM_LIGNE	    = 5
Constant integer NOT_FOUND = 0
Constant integer DB_ERROR  = -1
Constant String BLANK = " "
Constant String DONNEE_VIDE = ""
Constant String MAX_STRING_VALUE = "Z"

/* ===================================================
     constantes correspondantes aux messages d'anomalie, de confirmation
	 =================================================== */
Constant String MARCHE_INEXISTANT								= "MARCHE_INEXISTANT"
Constant String MARCHE_OBLIGATOIRE							= "MARCHE_OBLIGATOIRE"	 
Constant String VISITEUR_INEXISTANT 								= "User Id doesn't exist"
Constant String DB_ERROR_MESSAGE    							= "Error during the data access "
Constant String MOT_PASSE_ERRONE    							= "Invalid password"
Constant String VISITEUR_NON_RENSEIGNE 					= "User Id is mandatory"
Constant String CRITERES_NON_RENSEIGNE 					= "CRITERES_NON_RENSEIGNE "
Constant String CLIENT_INEXISTANT  								= "CLIENT_INEXISTANT"
Constant String CLIENT_INEXISTANT_VIA_CDE  					= "CLIENT INEXISTANT ou NATURE DIFF. de LIVRER"
Constant String SAISIE_NON_AUTORISEE_CDE     				= "SAISIE_NON_AUTORISEE_CDE"
Constant String NOM_CLIENT_OBLIGATOIRE						= "NOM_CLIENT_OBLIGATOIRE"
Constant String ADRESSE_OBLIGATOIRE							= "ADRESSE_OBLIGATOIRE"
Constant String CODE_POSTAL_OBLIGATOIRE					= "CODE_POSTAL_OBLIGATOIRE"
Constant String VILLE_OBLIGATOIRE									= "VILLE_OBLIGATOIRE"
Constant String REGION_OBLIGATOIRE								= "REGION_OBLIGATOIRE"
Constant String PAYS_OBLIGATOIRE								     = "PAYS_OBLIGATOIRE"
Constant String PAYS_INEXISTANT									     = "PAYS_INEXISTANT"
Constant String FONCTION_OBLIGATOIRE							= "FONCTION_OBLIGATOIRE	"
Constant String FONCTION_INEXISTANTE							= "FONCTION_INEXISTANTE"
Constant String NATURE_INEXISTANTE			   					= "NATURE_INEXISTANTE"
Constant String NATURE_OBLIGATOIRE			   					= "NATURE_OBLIGATOIRE"
Constant String OBTENIR_LISTE										= "OBTENIR_LISTE"
Constant String AUCUNE_DONNEE_EXISTANTE					= "AUCUNE_DONNEE_EXISTANTE"
Constant String DEVISE_INEXISTANTE								= "DEVISE_INEXISTANTE"
Constant String DEVISE_OBLIGATOIRE								= "DEVISE_OBLIGATOIRE"
Constant String NIVEAU_RESP_INEXISTANTE						= "NIVEAU_RESP_INEXISTANTE"
Constant String CORRESPOND_INEXISTANTE						= "CORRESPOND_INEXISTANTE"
Constant String MODE_PAIEMENT_INEXISTANT   					= "MODE_PAIEMENT_INEXISTANT"
Constant String MODE_PAIEMENT_OBLIGATOIRE   				= "MODE_PAIEMENT_OBLIGATOIRE"
Constant String ECHEANCE_INEXISTANTE	   						= "ECHEANCE_INEXISTANTE"
Constant String ECHEANCE_OBLIGATOIRE   						= "ECHEANCE_OBLIGATOIRE"
Constant String CLIENT_PAYEUR_INEXISTANT     					= "CLIENT_PAYEUR_INEXISTANT"
Constant String CLIENT_FACTURE_INEXISTANT    				= "CLIENT_FACTURE_INEXISTANT"
Constant String CLIENT_LIVRE_INEXISTANT    						= "CLIENT_LIVRE_INEXISTANT"
Constant String CLIENT_LIVRE_OBLIGATOIRE    					= "CLIENT_LIVRE_OBLIGATOIRE"
Constant String RESP_SECTEUR_INEXISTANT    					= "RESP_SECTEUR_INEXISTANT"
Constant String CODE_LANGUE_INEXISTANT    					= "CODE_LANGUE_INEXISTANT"
Constant String MODE_EXPEDITION_INEXISTANT  					= "MODE_EXPEDITION_INEXISTANT"
Constant String MODE_EXPEDITION_OBLIGATOIRE  				= "MODE_EXPEDITION_OBLIGATOIRE"
Constant String INCOTERM_INEXISTANT  							= "INCOTERM_INEXISTANT"
Constant String INCOTERM_OBLIGATOIRE  							= "INCOTERM_OBLIGATOIRE"
//Constant String GROSSITE_OBLIGATOIRE  							= "GROSSITE_OBLIGATOIRE"
Constant String ORIGINE_INEXISTANTE	   							= "ORIGINE_INEXISTANTE"
Constant String ORIGINE_OBLIGATOIRE	   							= "ORIGINE_OBLIGATOIRE"
Constant String TYPE_CDE_INEXISTANT	   							= "TYPE_CDE_INEXISTANT"
Constant String TYPE_CDE_OBLIGATOIRE	   						= "TYPE_CDE_OBLIGATOIRE"
Constant String RAISON_CDE_INEXISTANTE	   					= "RAISON_CDE_INEXISTANTE"
Constant String RAISON_CDE_OBLIGATOIRE	   					= "RAISON_CDE_OBLIGATOIRE"
Constant String GROSSISTE_INEXISTANT	  						= "GROSSISTE_INEXISTANT"
Constant String GROSSISTE_OBLIGATOIRE	  						= "GROSSISTE_OBLIGATOIRE"
Constant String DATE_LIVRAISON_ERRONEE						= "DATE_LIVRAISON_ERRONEE"
Constant String DATE_LIVRAISON_ERRONEE2						= "DATE_LIVRAISON_ERRONEE2"
Constant String DATE_LIVRAISON_ERRONEE3						= "DATE_LIVRAISON_ERRONEE3"
Constant String DATE_CDE_OBLIGATOIRE 		   					= "DATE_CDE_OBLIGATOIRE "
Constant String DATE_CDE_ERRONEE	 	 		   					= "DATE_CDE_ERRONEE "
Constant String DATE_CDE_ERRONEE_2	 	 		   					= "DATE_CDE_ERRONEE_2"
Constant String DATE_CDE_ERRONEE_3 	 		   					= "DATE_CDE_ERRONEE_3"
Constant String DATE_CDE_ERRONEE_4 	 		   					= "DATE_CDE_ERRONEE_4"
Constant String DATE_PRIX_ERRONEE	 	 		   					= "DATE_PRIX_ERRONEE "
Constant String LISTE_PRIX_OBLIGATOIRE 							= " LISTE_PRIX_OBLIGATOIRE "
Constant String DATE_PRIX_OBLIGATOIRE 							= "DATE_PRIX_OBLIGATOIRE "
Constant String ENTETE_MODIFIEE             							     = "ENTETE_MODIFIEE"
Constant String ENTETE_MODIFIEE_SUITE        						= "ENTETE_MODIFIEE_SUITE"  //ENTETE_MODIFIEE + "Seules les lignes ayant les mêmes infos tarif seront modifiées " 
Constant String ENTETE_MODIFIEE_FINAL        						= "ENTETE_MODIFIEE_FINAL" //ENTETE_MODIFIEE_SUITE + "Si modification de la remise, le montant HT des lignes sera réaligné."
Constant String CLIENT_LIVRE_CDE_INEXISTANT  				= "CLIENT_LIVRE_CDE_INEXISTANT"
Constant String BLOCAGE_SAP_INEXISTANT						    = "BLOCAGE_SAP_INEXISTANT"
Constant String SELECTION_OBLIGATOIRE							= "SELECTION_OBLIGATOIRE"
Constant String COMMANDE_ENCOURS            					= "COMMANDE_ENCOURS"
Constant String TITRE_LIGNE_EN_ANOMALIE      					= "TITRE_LIGNE_EN_ANOMALIE"
Constant String ARUN_INEXISTANT 									= "ARUN_INEXISTANT"
Constant String PAS_DE_SELECTION								= "PAS_DE_SELECTION"
Constant String VALIDATION_IMPOSSIBLE							= "VALIDATION_IMPOSSIBLE"

Constant String VALIDATION_BON_IMPOSSIBLE					= "VALIDATION_BON_IMPOSSIBLE"
Constant String ABANDON_BON_A_CONFIRMER					= "ABANDON_BON_A_CONFIRMER"
Constant String NON_AUTORISER		            						= "NON_AUTORISER"
Constant String VALIDATION_CATALOGUE_IMPOSSIBLE		= "VALIDE_CATALOGUE_IMPOSSIBLE"
Constant String ACCES_COMMANDE_IMPOSSIBLE               	= "ACCES_COMMANDE_IMPOSSIBLE"
Constant String AUCUNE_COMMANDE 								= "AUCUNE_COMMANDE"
Constant String CONFIRMATION_SUPPRESS_COMMANDE 		= "CONFIRMATION_SUPPRESS_COMMANDE"
Constant String VALIDATION_ENTETE 								=  "VALIDATION_ENTETE"  // avec validation impossible
Constant String LEVER_BLOCAGE_INDIRECT 						= "LEVER_BLOCAGE_INDIRECT"
Constant String AUCUNE_LIGNE_INDIRECTE 						= "AUCUNE_LIGNE_INDIRECTE"
Constant String  LEVER_BLOCAGE_IMPOSSIBLE 	                    = "LEVER_BLOCAGE_IMPOSSIBLE"
Constant String CLIENT_PROSPECT_IMPOSSIBLE 					= "CLIENT_PROSPECT_IMPOSSIBLE"
Constant String OPERATION_CLIENT_INEXISTANT 				= "OPERATION_CLIENT_INEXISTANT"
Constant String TYPE_TARIF_OBLIGATOIRE						= "TYPE_TARIF_OBLIGATOIRE"
Constant String CONFIRMAT_TYPE_TARIF_NORMAL				= "CONFIRMAT_TYPE_TARIF_NORMAL" // + CONFIRMATION
Constant String CONFIRMAT_TYPE_TARIF_CATALOGUE		= "CONFIRMAT_TYPE_TARIF_CATALOGUE" // + confirmation
Constant String VALIDATION_COMMANDE                                = "VALIDATION_COMMANDE"
Constant String BLOCAGE_POSITIONNE								= "BLOCAGE_POSITIONNE"
Constant String EXISTENCE_BLOCAGE                                      = "EXISTENCE_BLOCAGE"
Constant String VALIDER_COMMANDE                                      = "VALIDER_COMMANDE"
Constant String QUANTITE_COMMANDE_ERRONE                    = "QUANTITE_COMMANDE_ERRONE"
Constant String CONTROLE                                                        = "CONTROLE"
Constant String SUPPRESSION_COMMANDE                             = "SUPPRESSION_COMMANDE"
Constant String AUCUNE_COMMANDE_EN_COURS                  = "AUCUNE_COMMANDE_EN_COURS"
Constant String ERR_GETCHILD_W_SEL_CATALOGUE            = "ERR_GETCHILD_W_SEL_CATALOGUE"
Constant String ERR_GETCHILD_W_SEL_CDE                           = "ERR_GETCHILD_W_SEL_CDE"
Constant String REMISE_NON_ACCORDE_SUR_PROMO           = "REMISE_NON_ACCORDE_SUR_PROMO"
Constant String PAS_LIGNE_SAISIE                                           = "PAS_LIGNE_SAISIE"
Constant String ECHAP                                                               = "ECHAP"
Constant String PAS_SELECTION                                               = "PAS_SELECTION"
Constant String RENSEIGNER_CRITERE_REFERENCE                = "RENSEIGNER_CRITERE_REFERENCE"
Constant String VALIDER_MERCI                                               = "VALIDER_MERCI"
Constant String SEL_OPTION                                                     = "SEL_OPTION"
Constant String PAGE_ERRONE                                                 = "PAGE_ERRONE"
Constant String DETTE_POSITIVE_CLIENT                                 = "DETTE_POSITIVE_CLIENT"
Constant String SAISIR_ARTICLE                                               = "SAISIR_ARTICLE"
Constant String SAISIE_COMMANDE                                          = "SAISIE_COMMANDE"
Constant String QUANTITE_ERRONE                                          = "QUANTITE_ERRONE"
Constant String PAS_LIGNE_PROMO_SAISIE                             = "PAS_LIGNE_PROMO_SAISIE"
Constant String FIN_CDE_EN_COURS                                         = "FIN_CDE_EN_COURS"
Constant String VISU_AVANT_VALIDATION_CDE                     = "VISU_AVANT_VALIDATION_CDE"
Constant String QUANTITE_OBLIGATOIRE                                 = "QUANTITE_OBLIGATOIRE"
Constant String AUCUNE_DIMENSION_BON_COMMANDE          = "AUCUNE_DIMENSION_BON_COMMANDE"
Constant String SAISIE_BON_COMMANDE_EN_COURS            = "SAISIE_BON_COMMANDE_EN_COURS"
Constant String RECHERCHE_REFERENCE_OUI                         = "RECHERCHE_REFERENCE_OUI"
Constant String VALIDER_SAISIE_NON                                     = "VALIDER_SAISIE_NON"
Constant String SUPPRIMER_SAISIE_ANNULER                        = "SUPPRIMER_SAISIE_ANNULER"
Constant String REFERENCE_INEXISTANTE                               = "REFERENCE_INEXISTANTE"
Constant String PATIENTER_MAJ_EN_COURS                          = "PATIENTER_MAJ_EN_COURS"
Constant String CLASSE_ABC_OBLIGATOIRE						 = "CLASSE_ABC_OBLIGATOIRE"
Constant String MONTANT_EC_FACTOR_DIFF_ZERO			  = "MONTANT_EC_FACTOR_DIFF_ZERO"
Constant String UCC_INEXISTANTE                                              = "UCC_INEXISTANTE"
Constant String RECUPERATION_CDE                                        = "RECUPERATION_CDE"
Constant String RECUPERATION_CDE_ERREUR                     = "RECUPERATION_CDE_ERREUR"
Constant String DATE_LIVRAISON_ERRONEE4						= "DATE_LIVRAISON_ERRONEE4"
Constant String SELECTION_LIGNE_PROMO					     = "SELECTION_LIGNE_PROMO"
Constant String SELECTION_LIGNE_PROMO2					     = "SELECTION_LIGNE_PROMO2"
Constant String DATE_LIV_LOINTAINE								= "DATE_LIV_LOINTAINE"
/* ===================================================
     constantes correpondantes à des valeurs testées
   =================================================== */
Constant String CODE_RELATION_CLIENTELE 			= "RC"
Constant String CODE_VENDEUR								= "VD"
Constant String CODE_MANAGER								= "MA"
Constant String CODE_FILIALE						 			= "FI"
Constant String CODE_VENDEUR_MULTI_CARTE			= "VM"
Constant String CODE_GRANDE_FONCTION_GROSSISTE	= "1"
Constant String CODE_NATURE_CLIENT_LIVRE		   = "0"
Constant String CODE_PROSPECT						   = "P"
Constant String CODE_PREFIX_PROSPECT			   = "P"
Constant String CODE_CREATION						   = "C"
Constant String CODE_CLIENT_A_VALIDER				= "V"
Constant String CODE_CLIENT_A_NE_PAS_VALIDER		= "N"
Constant String CODE_CLIENT_VALIDER					= "O"
Constant String ORIGINE_VALIDATION_CLIENT			= "O"
Constant String CODE_PAS_DE_BLOCAGE					= " "
Constant String TYPE_LIGNE_DIRECT					= "D"
Constant String TYPE_LIGNE_INDIRECT					= "G"
Constant String TYPE_LIGNE_FACTURE					= "F"
Constant String CODE_BLOCAGE							= "X"
Constant String DATE_DEFAULT_SYBASE             = "01/01/1900"
Constant String CODE_PAYANT							= "P"
Constant String CODE_GRATUIT							= "G"
Constant String CODE_CLASSE_9							= "9"
Constant String CODE_CLASSE_T							= "T"
Constant String CODE_CLASSE_C							= "C"
Constant String CODE_SAISIE_SIMPLE					= "S"
Constant String CODE_SAISIE_PROMO					= "P"
Constant String CODE_SAISIE_BON_CDE					= "B"
Constant String CODE_SAISIE_CATALOGUE				= "C"
Constant String CODE_SAISIE_PUBLI_PROMO         = "U"
Constant String CODE_SAISIE_OPERATRICE          = "O"
Constant String CODE_SAISIE_PREVENTE                  = "V"
Constant String CODE_AUCUNE_ERREUR					= "0"
Constant String CODE_REFERENCE_INEXISTANTE		= "1"
Constant String CODE_TARIF_INEXISTANT				= "2"
Constant String CODE_QTE_INF_MINI_CDE				= "3"
Constant String CODE_QTE_ERREUR_TAILLE_LOT		= "4"
Constant String CODE_TARIF_CATALOGUE_INEXISTANT			= "5"
Constant String CODE_QTE_EDI_INCORRECT			= "6"
Constant String CODE_QTE_UNC_INCORRECT			= "7"
Constant String COMMANDE_VALIDEE						= "V"
Constant String COMMANDE_BLOQUEE						= "B"
Constant String COMMANDE_SUSPENDUE					= "S"
Constant String COMMANDE_SUPPRIMEE					= "A"
Constant String COMMANDE_REACTIVEE					= " "
Constant String COMMANDE_A_VALIDER					= "?"
Constant String COMMANDE_TRANSFEE					= "T"
Constant String ENTETE_CDE_VALIDEE                     = "C"
Constant String GROUPE_TYPE_GRATUIT_ZFGR		= "ZFGR"

Constant String CLIENT_DONNEUR_ORDRE				= "N101"

Constant String CODE_NOUVEAU_CLIENT 				= "O"
Constant String CODE_SUPPRESSION						= "A"
//Constant String CODE_NON_SOUMIS							= "1"
//Constant String CODE_NON_SOUMIS							= "2"
//Constant String CODE_SOUMIS							= "2"
//Constant String CODE_SOUMIS							= "1"
Constant String CODE_MODE_RAPIDE  						= "R"
Constant String CODE_MODE_SIMPLE  						= " "
Constant String ACTION_OK 								= "ok"
Constant String ACTION_CANCEL 						= "cancel"
Constant String ACTION_NEW	 							= "new"
Constant String ACTION_CHANGER						= "corriger"
Constant String ACTION_DELETE 						= "delete"
Constant String OPTION_CLIENT 						= "CLIENT"
Constant String OPTION_PARTENAIRE				   = "PARTENAIRE"
Constant boolean NOUVEAU_CLIENT_IMPOSSIBLE      = false
Constant boolean NOUVEAU_CLIENT_POSSIBLE        = true
Constant boolean RETOUR_DIRECT_AVEC_INFO_CLIENT = true
Constant boolean PAS_RETOUR_DIRECT_AVEC_INFO_CLIENT = true
Constant boolean AFFICHAGE_CLIENT_LIVRE_UNIQUEMENT = true
Constant boolean AFFICHAGE_TOUS_LES_CLIENT		   = false
Constant boolean AFFICHAGE_CLIENT_ORDRE_UNIQUEMENT = true
Constant String AFFICHAGE_LISTE_CLIENT_LIVRE      = "livre"
Constant String AFFICHAGE_LISTE_CLIENT_PAYEUR     = "payeur"
Constant String AFFICHAGE_LISTE_CLIENT_FACTURE    = "facture"
Constant String CODE_INEXISTANT                                        = "?"
Constant String CODE_UCC_UC                                              = "001"
Constant String CODE_MQT_KEEP                                          = "2"
Constant String	 POUR_TOUS_VISITEURS = "ALL"
/* ===================================================
     constantes correpondantes aux noms des différentes fenêtres
	 =================================================== */
Constant String  FENETRE_CLIENT				= "w_fiche_client_principale"
Constant String  FENETRE_COMPTE_CLIENT 	= "w_situation_cpt_client"
Constant String  FENETRE_ENTETE_CDE 		= "w_entete_cde"
Constant String  FENETRE_ENTETE_CDE_RC 	= "w_entete_cde_rc"
Constant String  FENETRE_REFERENCE_TARIF 	= "w_liste_reference_tarifs"
Constant String  FENETRE_LIGNE_CDE       	= "w_ligne_cde"
Constant String  FENETRE_LISTE_CDE       	= "w_liste_cde_visiteur"
Constant String  FENETRE_LISTE_DERNIERE_CDE	= "w_liste_cde"
Constant String  FENETRE_FIN_CDE       	= "w_fin_cde"
Constant String  FENETRE_BON_CDE				= "w_saisie_bon_cde"
Constant String  FENETRE_CATALOGUE        = "w_saisie_catalogue"
Constant String  FENETRE_CDE_PROMO        = "w_saisie_cde_promo"
Constant String  FENETRE_PROMO	         = "w_info_promo"
Constant String  FENETRE_MESSAGE_CDE      = "w_message_cde"
Constant String  FENETRE_MESSAGE_CDE_RESPONSE   = "w_message_cde_response"
Constant String  FENETRE_LIGNE_CDE_OPERATRICE   = "w_ligne_cde_operatrice"
Constant String  FENETRE_VALIDATION_CLIENT      = "w_liste_client_a_valider"
Constant String  FENETRE_CARNET_CDE_CLIENT      = "w_carnet_cde"

/* ===================================================
    constantes utilisées par le workflow manager
   =================================================== */
Constant String  WORKFLOW_CTRL_STATUT_CDE			= "commande non validee"
Constant String  WORKFLOW_EVENT= "ue_workflow"
Constant Boolean AVEC_PASSAGE_PARAMETRE = true
Constant Boolean SANS_PASSAGE_PARAMETRE = false

Constant String TYPE_CDE_LIVRAISON_GRATUITE_CGR		= "CGR"							 
Constant String TYPE_CDE_LIVRAISON_GRATUITE_CEI		     = "CEI"		
Constant String TYPE_CDE_LIVRAISON_GRATUITE_CEE		= "CEE"							 
							 
end variables

global type erfvmr from application
string appname = "erfvmr"
string themepath = "C:\Program Files (x86)\Appeon\PowerBuilder 19.0\IDE\theme"
string themename = "Do Not Use Themes"
boolean nativepdfvalid = false
boolean nativepdfincludecustomfont = false
string nativepdfappname = ""
long richtextedittype = 2
long richtexteditx64type = 3
long richtexteditversion = 1
string richtexteditkey = ""
string appicon = "C:\appscir\Erfvmr_diva\Image\PHONE_1.ICO"
string appruntimeversion = "19.2.0.2703"
end type
global erfvmr erfvmr

type prototypes

end prototypes

event systemerror;/*<DESC>
   En cas d'anomalie lors de l'accès à la bade de donnée; le sytéme quitte l'application
  et affiche un message d'anomalie
  </DESC> */
// DECONNEXION AU SGBDR
	DISCONNECT;
	Error.fnv_process_error ()
end event

event open;/* <DESC>
  - Création des différents objets necessaire aux objects PowerTool. 
  - Initialisation de la connection de l'application à al base de données
  - Affichage de la fenetre générale de l'application.
  </DESC> */
  
// Initialisation des variables locales
g_nv_ini			 = CREATE nv_ini
g_nv_env 		 = CREATE nv_environment
g_nv_components = CREATE nv_components
g_nv_msg_mgr 	 = CREATE nv_msg_manager

String ls_fichier_ini
String ls_commande_line

ls_fichier_ini = "Erfvmr"
ls_commande_line = Trim(CommandParm())

//Controle si le fichier ini est passé en paramètre ou non
if ls_commande_line <> DONNEE_VIDE then
	if upper(Mid(ls_commande_line,1,4)) = "/INI" then
		ls_fichier_ini = Mid(ls_commande_line,6)
	end if
end if

g_nv_liste_manager = CREATE nv_list_manager
g_nv_workflow_manager = CREATE nv_workflow_manager

g_nv_msg_mgr.fnv_set_language("french")

This.MicroHelpDefault = "Prêt!"

// Lecture du fichier INI de l'application
g_nv_ini.fnv_open ("powerTool",ls_fichier_ini, true)
g_nv_trace            = CREATE nv_trace

//// Connexion au SGBDR
if SQLCA.fnv_db_connect("", ls_fichier_ini , "", "", true) < 0 then
	f_dmc_error ("Connexion impossible !")
	return
end if

// CONNEXION A L'APPLICATION

Open (w_frame_erfvmr)

end event

event close;/*<DESC>
    Permet de quitter l'application
  </DESC> */

	DISCONNECT;
end event

on erfvmr.create
appname="erfvmr"
message=create nv_message
sqlca=create nv_sqlca
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create nv_error
end on

on erfvmr.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

