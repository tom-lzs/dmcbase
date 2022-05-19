$PBExportHeader$efdvparam.sra
$PBExportComments$Permet l'ouverture de l'application
forward
global type efdvparam from application
end type
global nv_sqlca sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global nv_error error
global nv_message message
end forward

global variables
// Variables utilisées par PT5.0
w_fa		g_w_frame
nv_ini		g_nv_ini
nv_msg_manager	g_nv_msg_mgr
nv_components	g_nv_components
nv_environment	g_nv_env
userobject	g_nv_security
userobject	g_nv_nav_manager
str_user		g_str_user

String  g_s_version = '2009-09-01'

String ACTION_OK = "ok"
String ACTION_CANCEL = "cancel"
Constant String DBNAME_PAYS 		 								= "codaepay"
Constant String DBNAME_LANGUE 		 							= "codaelan"
Constant String DBNAME_PAYS_INTITULE							= "libaepay"
Constant String DBNAME_LANGUE_INTITULE						= "libaelan"
Constant String DBNAME_CODE_MAJ									= "codeemaj"
Constant String DBNAME_DATE_CREATION							= "timefcre"
Constant String DBNAME_CODE_VISITEUR							= "codeevis"
Constant String DBNAME_CODE_ADR   							     = "codeeadr"
Constant String DBNAME_CODE_NOM   							     = "nom"
Constant String DBNAME_CODE_MARCHE								= "codaemar"
Constant String DBNAME_CODE_MARCHE_INTITULE					= "libaemar"
Constant String DBNAME_LISTE_PRIX								= "lisaepri"
Constant String DBNAME_CODE_DEVISE								= "codaedev"
Constant String DBNAME_NOM_VISITEUR								= "nomeevis"
Constant String DBNAME_ORIGINE_CDE								= "coraecde"
Constant String DBNAME_ORIGINE_CDE_INTITULE					= "lboaecde"
Constant String DBNAME_RAISON_CDE								= "raiaecde"
Constant String DBNAME_RAISON_CDE_INTITULE				   = "libaercd"
Constant String DBNAME_TYPE_CDE									= "typaecde"
Constant String DBNAME_TYPE_CDE_INTITULE						= "libaetcd"
Constant String DBNAME_TYPE_VISITEUR							= "typaevsr"
Constant String DBNAME_CODE_DEVISE_INTITULE					= "libaedev"
Constant String DBNAME_RAISON_OBLIGATOIRE						= "raiaeobl"
Constant String DBNAME_VALORISATION_CDE						= "valaecde"
Constant String DBNAME_MODIF_REGROUPEMENT_CDE				= "rgtaeord"
Constant String DBNAME_MOT_PASSE									= "moteepas"
Constant String DBNAME_MINIMUM_CDE 								= "minaecde"
Constant String DBNAME_INTITULE_FR								= "intitule_fr"
Constant String DBNAME_INTITULE_EN								= "intitule_en"
Constant String DBNAME_INTITULE_ES								= "intitule_es"
Constant String DBNAME_INTITULE_IT								= "intitule_it"
Constant String DBNAME_INTITULE_DE								= "intitule_de"
Constant String DBNAME_LONG_INTITULE							= "lg_intitule"
Constant String DBNAME_DATE_MAJ_CDE							= "dteaencd"
Constant String DBNAME_DATE_MAJ_PROSPECT                  = "dteaeprp"
Constant String DBNAME_BLOCAGE_CDE                               = "cblaesap"
Constant String DBNAME_CODE_TABLE								= "codeetab"
Constant String DBNAME_INTITULE_TABLE							= "nomeetab"
Constant String DBNAME_EXTRACTION_DATE						= "extefdat"
Constant String DBNAME_EXTRACTION_VISITEUR				= "extefvis"
Constant String DBNAME_EXTRACTION_MARCHE  				= "extefmar"
Constant String DBNAME_UNIPAR 									= "uniaepar"
Constant String DBNAME_EXTRACTION_POUR_VENDEUR		= "extefven"
Constant String DBNAME_EXTRACTION_POUR_RC          		= "extefrcl"
Constant String DBNAME_EXTRACTION_POUR_FI          		="exteffil"

Constant String DONNEE_VIDE										= ""
Constant String BLANK												= " "
Constant String MANAGER											= "MA"

Constant String DB_ERROR_MESSAGE    			= "Erreur d'accès aux données "
Constant String VISITEUR_NON_RENSEIGNE 		= "Veuiller saisir le code visiteur"
Constant String PAYS_INEXISTANT					= "Le pays est inexistant"
Constant String LANGUE_INEXISTANT				= "Le code langue est inexistant"
Constant String OBTENIR_LISTE						= "Appuyer sur F2 pour obtenir la liste"
Constant String MARCHE_INEXISTANT				= "Le Marché est inexistant"
Constant String DEVISE_INEXISTANTE				= "La devise est inexistante"
Constant String ORIGINE_INEXISTANTE	   		= "L'origine de commande est inexistante"
Constant String TYPE_CDE_INEXISTANT	   		= "Le type de commande est inexistant"
Constant String RAISON_CDE_INEXISTANTE	   	= "La raison de commande est inexistante"
Constant String RAISON_CDE_OBLIGATOIRE	   	= "La raison de commande est obligatoire"
Constant String LISTE_PRIX_OBLIGATOIRE 		= "La liste de prix est obligatoire "
end variables

global type efdvparam from application
string appname = "efdvparam"
string themepath = "C:\Program Files (x86)\Appeon\PowerBuilder 19.0\IDE\theme"
string themename = "Do Not Use Themes"
boolean nativepdfvalid = false
boolean nativepdfincludecustomfont = false
string nativepdfappname = ""
long richtextedittype = 2
long richtexteditx64type = 3
long richtexteditversion = 1
string richtexteditkey = ""
string appicon = "C:\appscir\Efdvparam\Source\appli.ico"
string appruntimeversion = "19.2.0.2728"
end type
global efdvparam efdvparam

type variables

end variables

on efdvparam.create
appname="efdvparam"
message=create nv_message
sqlca=create nv_sqlca
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create nv_error
end on

on efdvparam.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event close;/* <DESC>
      Permet d'effectuer la deconnexion au serveur avant de quitter l'application
   </DESC>*/
// DECONNEXION AU SGBDR

	DISCONNECT;
end event

event systemerror;/* <DESC> 
       Declencher lors d'une anoalie severe.
		 Deconnexion et stockage de l'erreur dans le fichier des erreurs
   </DESC> */
	DISCONNECT;
	Error.fnv_process_error ()
end event

event open;/* <DESC>
     Ouverture de l'application après avoir effectuer la connexion à la base
	  de donnée
   </DESC> */   
// Initialisation des variables locales
	g_nv_ini			 = CREATE nv_ini
	g_nv_env 		 = CREATE nv_environment
	g_nv_components = CREATE nv_components
	g_nv_msg_mgr 	 = CREATE nv_msg_manager
	String ls_fichier_ini
    String ls_commande_line

ls_fichier_ini = GetApplication().AppName
ls_commande_line = Trim(CommandParm())

//Controle si le fichier ini est passé en paramètre ou non
if ls_commande_line <> DONNEE_VIDE then
	if upper(Mid(ls_commande_line,1,4)) = "/INI" then
		ls_fichier_ini = Mid(ls_commande_line,6)
	end if
	
end if

	g_nv_msg_mgr.fnv_set_language("french")
	
//	This.MicroHelpDefault = "Prêt!"

// Lecture du fichier INI de l'application
	g_nv_ini.fnv_open ("powerTool", ls_fichier_ini, true)

// Connexion au SGBDR
	if SQLCA.fnv_db_connect("", ls_fichier_ini, "", "", true) < 0 then
		f_dmc_error ("Connexion impossible !")
	end if
	
	Open (w_cadre_mdi)
end event

