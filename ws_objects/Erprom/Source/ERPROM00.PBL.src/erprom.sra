$PBExportHeader$erprom.sra
$PBExportComments$Application "Gestion des promotions"
forward
global type erprom from application
end type
global nv_transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global nv_error error
global nv_message message
end forward

global variables
// Variables utilisées par PT 4.0
application	g_app
w_fa		g_w_frame
nv_ini		g_nv_ini

// Variables utilisées par PT 5.0
nv_msg_manager	g_nv_msg_mgr
nv_environment	g_nv_env
nv_components	g_nv_components
userobject	g_nv_security
userobject	g_nv_nav_manager
str_user		g_str_user

// Variables DMC de gestion droits d'accès
String		g_s_code, &
		g_s_nom,  &
		g_s_profil

//String   g_s_version = '2009-01-23'
String   g_s_version = '2015-06-30'
Constant String ACTION_OK 				= "ok"
Constant String ACTION_CANCEL 		= "cancel"
Constant String BLANK					= " "
Constant String DONNEE_VIDE   		= ""
Constant String CODE_ADMINISTRATEUR = "000"
Constant String DATE_SYBASE_MINI 	= "01/01/1900"
Constant String DATE_SYBASE_MAX 		= "31/12/9999"
Constant String SYBASE_JOKER 			= "%"
Constant String MODE_CREATION			= "C"
Constant String MODE_MODIFICATION	= "M"
Constant String MODE_CONSULTATION	= "V"
Constant String VALEUR_PREMIERE_PROMO = "Y001"

Constant String DBNAME_USERID					= "useefrid"
Constant String DBNAME_PASSWORD				= "moteepas"
Constant String DBNAME_NOM_USER  			= "nomefusr"
Constant String DBNAME_PRENOM					= "prneeusr"
Constant String DBNAME_USER_FONCTION 		= "cdeeefct"
Constant String DBNAME_CODE_APPLICATION 	= "codeeapp"
Constant String DBNAME_CODE_PROMO		 	= "npraeact"
Constant String DBNAME_INTITULE_PROMO	 	= "lpraeact"
Constant String DBNAME_DATE_DEBUT		 	= "dtdaeva0"
Constant String DBNAME_DATE_FIN			 	= "dtFaeva0"
Constant String DBNAME_CONDITION			 	= "lpraeac1"
Constant String DBNAME_ARTICLE			 	= "artae000"
Constant String DBNAME_DIMENSION			 	= "dimaeart"
Constant String DBNAME_QUANTITE			 	= "qteaeuni"
Constant String DBNAME_DATE_CREATION	 	= "timefcre"
Constant String DBNAME_CODE_MAJ			 	= "codeemaj"
Constant String DBNAME_DESCRIPTION_REF	   = "desaeref"
Constant String DBNAME_MARCHE	   = "codaemar"
Constant String DBNAME_DATE_LANCEMENT	 	= "dteaelct"

/* *****************  Str Pass *********************
Str_pass.s[01] = n° promo
Str_pass.s[02] = Type acces  "C"réation 
                                           "M"odification
                                           "S"uppression
			 "V" consultation
   Parametres de la fenetre de selection de la promo
Str_pass.s[03] = n° promo
Str_pass.s[04] = mot cle

Str_pass.s[07] = Critere nom (recherche client)
Str_pass.s[08] = Critere ville (recherche client)
Str_pass.s[09] = Critere departement (recherche client)
Str_pass.s[10] = Origine appel
                           "w_selection_promo"
	             "w_promo_client"
                           "w_gestion_promo"
Str_pass.s[11] = Visiteur
Str_pass.Dates[01] = Période début
Str_pass.Dates[02] = Période fin
    ************************************************** */
end variables

global type erprom from application
string appname = "erprom"
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
global erprom erprom

type prototypes

end prototypes

event open;
Str_pass	str_work

// Initialisation des variables globales
	g_app 			 = This
	g_nv_ini 		 = CREATE nv_ini
	g_nv_env  		 = CREATE nv_environment
	g_nv_components = CREATE nv_components
	g_nv_msg_mgr 	 = CREATE nv_msg_manager


// Traduction du texte de la ligne d'aide
	This.MicroHelpDefault = "Prêt!"
	g_nv_msg_mgr.fnv_set_language ("french")

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

// Init du .INI
	g_nv_ini.fnv_open ("PowerTool", ls_fichier_ini, TRUE)

// Connexion au SGBDR
	if SQLCA.fnv_db_connect ("", ls_fichier_ini, "", "", TRUE) < 0 then
		f_dmc_error ("Connexion impossible !")
	end if
	
// Fenêtre de connexion
	OpenWithParm (w_dmc_login,str_work)

	str_work = Message.fnv_get_str_pass()
	Message.fnv_clear_str_pass()

	if str_work.s_action = ACTION_OK then
			g_s_code		=	str_work.s[01]
			g_s_nom		=	str_work.s[02]
			g_s_profil	=	str_work.s[03]
			Open(w_cadre_mdi)
	else			
			Halt			
	end if			

end event

event close;
// Déconnexion de la base
DISCONNECT;

end event

event systemerror;
// Déconnexion de la base
DISCONNECT;
Error.fnv_process_error ()
end event

on erprom.create
appname="erprom"
message=create nv_message
sqlca=create nv_transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create nv_error
end on

on erprom.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

