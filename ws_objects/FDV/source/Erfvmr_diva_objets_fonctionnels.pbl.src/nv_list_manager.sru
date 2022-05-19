$PBExportHeader$nv_list_manager.sru
$PBExportComments$Permet de faire appel à une liste de valeur correspondante au champ de la base de donnée passé en paramètres
forward
global type nv_list_manager from nonvisualobject
end type
end forward

global type nv_list_manager from nonvisualobject
end type
global nv_list_manager nv_list_manager

type variables

end variables

forward prototypes
public function any get_list_of_column (any as_str_pass)
end prototypes

public function any get_list_of_column (any as_str_pass);/* <DESC>
   Permet d'afficher la liste de valeur en fonction de paramètre passé en arguments.
   Les arguments passés à la fonction sont stockés dans la structure standard STR_PASS,   dans le tableau des chaines 
  de caractères :    S[1] contient le nom du champ de la base pour lequel on souhaite faire afficher la liste des valeurs.
  
 On fait appel à la fenêtre d'affichage de la liste correspondant au nom du champ en passant une nouvelle structure 
 qui contiendra le nom du champ, le nom du champ contenant l'intitulé et en retour la fenêtre completera cette même structure
 par la valeur du code et de son intitulé sélectionné.
  </DESC> */
			 
Str_pass		l_str_work
boolean     lb_retrieve_str
l_str_work = as_str_pass
l_str_work.s_action = DONNEE_VIDE
lb_retrieve_str = true
			
CHOOSE CASE l_str_work.s[1]
	// LISTE DES NATURES CLIENT
		CASE DBNAME_NATURE_CLIENT
			l_str_work.s[3] 	= DBNAME_NATURE_CLIENT_INTITULE			
			OpenWithParm (w_liste_nature_client, l_str_work)
	// LISTE DES FONCTIONS CLIENT
		CASE DBNAME_FONCTION
			l_str_work.s[3] 	= DBNAME_FONCTION_INTITULE						
			OpenWithParm (w_liste_fonction_client, l_str_work)
	// LISTE DES CODES PAYS
		CASE DBNAME_PAYS
			l_str_work.s[3] 	= DBNAME_PAYS_INTITULE
			OpenWithParm (w_liste_pays, l_str_work)	
	// LISTE DES CODES MARCHE
		CASE DBNAME_CODE_MARCHE
			l_str_work.s[3] 	= DBNAME_CODE_MARCHE_INTITULE
			OpenWithParm (w_liste_marche, l_str_work)				
	// LISTE DES CODES DEVISE
		CASE DBNAME_CODE_DEVISE
			l_str_work.s[3] 	= DBNAME_CODE_DEVISE_INTITULE
			OpenWithParm (w_liste_devise, l_str_work)	
	// LISTE DES NIVEAUX DE RESPONSABILITE
		CASE DBNAME_CODE_NIVEAU_RESP
			l_str_work.s[3] 	= DBNAME_CODE_NIVEAU_RESP
			OpenWithParm (w_liste_niveau_responsabilite, l_str_work)							
	// LISTE DES CODE CORRESPONDANCIERES
		CASE DBNAME_CODE_CORREPONDANTE
			l_str_work.s[3] 	= DBNAME_CODE_CORREPONDANTE
			OpenWithParm (w_liste_correspondancieres, l_str_work)										
			
	// LISTE DES CODES ECHEANCE
		CASE DBNAME_CODE_ECHEANCE
			l_str_work.s[3] 	= DBNAME_CODE_ECHEANCE_INTITULE
			OpenWithParm (w_liste_echeance, l_str_work)																
	// LISTE DES CLIENTS PAYEUR
		CASE DBNAME_CLIENT_PAYEUR_CODE
			l_str_work.b[1] = false
			l_str_work.b[3] = true
			OpenWithParm (w_ident_client_partenaire, l_str_work)						
	// LISTE DES CLIENTS FACTURE
		CASE DBNAME_CLIENT_FACTURE_CODE
			l_str_work.b[1] = false
			l_str_work.b[3] = false			
			OpenWithParm (w_ident_client_partenaire, l_str_work)						
	// LISTE DES CLIENTS LIVRE
		CASE DBNAME_CLIENT_LIVRE_CODE
			l_str_work.b[1] = true
			l_str_work.b[3] = false				
			OpenWithParm (w_ident_client_partenaire, l_str_work)
	// LISTE DES RESPONSABLES DE SECTEUR
		CASE DBNAME_CODE_RESP_SECTEUR
			l_str_work.s[3] 	= DBNAME_CODE_RESP_SECTEUR
			OpenWithParm (w_liste_resp_secteur, l_str_work)	
	// LISTE DES CODES LANGUE
		CASE DBNAME_CODE_LANGUE
			l_str_work.s[3] 	= DBNAME_CODE_LANGUE
			OpenWithParm (w_liste_code_langue, l_str_work)	
	// LISTE DES MODES EXPEDITON
		CASE DBNAME_CODE_MODE_EXP
			l_str_work.s[3] 	= DBNAME_CODE_MODE_EXP_INTITULE
			OpenWithParm (w_liste_mode_expedition, l_str_work)				
	// LISTE DES CODES INCOTERM
		CASE DBNAME_CODE_INCOTERM
			l_str_work.s[3] 	= DBNAME_CODE_INCOTERM_INTITULE
			OpenWithParm (w_liste_incoterm, l_str_work)	
	// LISTE DES TYPES DE CDE
		CASE DBNAME_TYPE_CDE
			l_str_work.s[3] 	= DBNAME_TYPE_CDE_INTITULE
			OpenWithParm (w_liste_type_cde, l_str_work)						
	// LISTE DES ORIGINES DE CDE
		CASE DBNAME_ORIGINE_CDE
			l_str_work.s[3] 	= DBNAME_ORIGINE_CDE_INTITULE
			OpenWithParm (w_liste_origine_cde, l_str_work)												
	// LISTE DES GROSSISTES
		CASE DBNAME_GROSSISTE
			OpenWithParm (w_liste_grossiste, l_str_work)
     // LISTE DES CODES BLOCAGES SAP
		CASE DBNAME_CODE_BLOCAGE_SAP
			l_str_work.s[3] 	= DBNAME_CODE_BLOCAGE_SAP_INTITULE
			OpenWithParm (w_liste_code_blocage, l_str_work)
	// LISTE DES CODES UNITE COMMANDE CLIENT
		CASE DBNAME_UCC
			l_str_work.s[3] 	= DBNAME_UCC_INTITULE
			OpenWithParm (w_liste_ucc, l_str_work)																
		CASE ELSE
			l_str_work.s[1] = DONNEE_VIDE
			l_str_work.s[2] = DONNEE_VIDE
			l_str_work.s[3] = DONNEE_VIDE			
			l_str_work.s_action = ACTION_CANCEL
			lb_retrieve_str = false			
END CHOOSE

if lb_retrieve_str then
	l_str_work = Message.fnv_get_str_pass()		
end if
return l_str_work
end function

on nv_list_manager.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nv_list_manager.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

