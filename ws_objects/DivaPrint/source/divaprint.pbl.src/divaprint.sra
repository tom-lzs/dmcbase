$PBExportHeader$divaprint.sra
$PBExportComments$Generated Application Object
forward
global type divaprint from application
end type
global nv_transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global nv_error error
global nv_message message
end forward

global variables
// Variables utilisées par PT5.0
w_fa		   	g_w_frame
//w_frame_erfvmr g_w_frame
nv_ini			g_nv_ini
nv_msg_manager	g_nv_msg_mgr
nv_components	g_nv_components
nv_environment	g_nv_env
userobject		g_nv_security
userobject		g_nv_nav_manager
str_user			g_str_user

String g_s_etab
String g_s_serveur_smtp
String g_s_path_fichier
Date  g_d_max_date
String g_s_version =   '20111001'
String g_s_commande_open_pdf
String g_s_commande_print_pdf


////Constant string REGISTRY_KEY    = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer"
//Constant string REGISTRY_KEY    = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI"
////Constant string REGISTRY_NAME_USER = "Logon User Name"
//Constant string REGISTRY_NAME_USER = "LastLoggedOnUser"
//Constant string REGISTRY_NAME_EMAIL = "eMailUser"
//Constant string REGISTRY_KEY_PDF   = "HKEY_CLASSES_ROOT\.pdf"
//Constant String REGISTRY_DEFAUT_VALUE = ""
//Constant String REGISTRY_KEY_CLASSES =  "HKEY_CLASSES_ROOT"
//



end variables

global type divaprint from application
string appname = "divaprint"
string themepath = "C:\Program Files (x86)\Appeon\PowerBuilder 19.0\IDE\theme"
string themename = "Do Not Use Themes"
boolean nativepdfvalid = false
boolean nativepdfincludecustomfont = false
string nativepdfappname = ""
long richtextedittype = 2
long richtexteditx64type = 3
long richtexteditversion = 1
string richtexteditkey = ""
string appicon = "C:\appscir\DivaPrint\Images\SC_Reader.ico"
string appruntimeversion = "19.2.0.2728"
end type
global divaprint divaprint

on divaprint.create
appname="divaprint"
message=create nv_message
sqlca=create nv_transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create nv_error
end on

on divaprint.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

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

g_nv_msg_mgr.fnv_set_language("french")

This.MicroHelpDefault = "Prêt!"

//Open (w_impression_fichiers)
open (w_initialisation)
end event

event close;/*<DESC>
    Permet de quitter l'application
  </DESC> */

	DISCONNECT;
end event

