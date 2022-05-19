$PBExportHeader$w_initialisation.srw
forward
global type w_initialisation from w_a
end type
type rb_ii from u_rba within w_initialisation
end type
type rb_ip from u_rba within w_initialisation
end type
type rb_ie from u_rba within w_initialisation
end type
type rb_pt from u_rba within w_initialisation
end type
type rb_if from u_rba within w_initialisation
end type
type p_2 from u_pa within w_initialisation
end type
type p_1 from u_pa within w_initialisation
end type
type cb_ok from u_cba within w_initialisation
end type
type rb_it from u_rba within w_initialisation
end type
type rb_es from u_rba within w_initialisation
end type
type rb_gb from u_rba within w_initialisation
end type
type rb_fr from u_rba within w_initialisation
end type
type st_init_param from statictext within w_initialisation
end type
type gb_etab from groupbox within w_initialisation
end type
type r_1 from rectangle within w_initialisation
end type
type r_2 from rectangle within w_initialisation
end type
type ln_1 from line within w_initialisation
end type
end forward

global type w_initialisation from w_a
integer x = 769
integer y = 461
integer width = 1970
integer height = 1480
string title = "DivaPrint - Initialisation / Initialization"
long backcolor = 12632256
string icon = "C:\donnees\PowerBuilder\DivaPrint\Images\pegasus.ico"
rb_ii rb_ii
rb_ip rb_ip
rb_ie rb_ie
rb_pt rb_pt
rb_if rb_if
p_2 p_2
p_1 p_1
cb_ok cb_ok
rb_it rb_it
rb_es rb_es
rb_gb rb_gb
rb_fr rb_fr
st_init_param st_init_param
gb_etab gb_etab
r_1 r_1
r_2 r_2
ln_1 ln_1
end type
global w_initialisation w_initialisation

type variables
integer ii_num_rectangle
boolean itime_end

Constant string REGISTRY_KEY_USER    = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer"
Constant string REGISTRY_KEY    = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI"
Constant string REGISTRY_NAME_USER1 = "Logon User Name"
Constant string REGISTRY_NAME_USER = "LastLoggedOnUser"
Constant string REGISTRY_NAME_EMAIL = "eMailUser"
Constant string REGISTRY_KEY_PDF   = "HKEY_CLASSES_ROOT\.pdf"
Constant String REGISTRY_DEFAUT_VALUE = ""
Constant String REGISTRY_KEY_CLASSES =  "HKEY_CLASSES_ROOT"
String i_s_version = '20161011'
//String i_s_version = '20160108'
//String i_s_version = '20160101'
//String i_s_version = '20120815P01'
//String i_s_version =   '20120626'
//String i_s_version =   '20110928'

end variables

on w_initialisation.create
int iCurrent
call super::create
this.rb_ii=create rb_ii
this.rb_ip=create rb_ip
this.rb_ie=create rb_ie
this.rb_pt=create rb_pt
this.rb_if=create rb_if
this.p_2=create p_2
this.p_1=create p_1
this.cb_ok=create cb_ok
this.rb_it=create rb_it
this.rb_es=create rb_es
this.rb_gb=create rb_gb
this.rb_fr=create rb_fr
this.st_init_param=create st_init_param
this.gb_etab=create gb_etab
this.r_1=create r_1
this.r_2=create r_2
this.ln_1=create ln_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_ii
this.Control[iCurrent+2]=this.rb_ip
this.Control[iCurrent+3]=this.rb_ie
this.Control[iCurrent+4]=this.rb_pt
this.Control[iCurrent+5]=this.rb_if
this.Control[iCurrent+6]=this.p_2
this.Control[iCurrent+7]=this.p_1
this.Control[iCurrent+8]=this.cb_ok
this.Control[iCurrent+9]=this.rb_it
this.Control[iCurrent+10]=this.rb_es
this.Control[iCurrent+11]=this.rb_gb
this.Control[iCurrent+12]=this.rb_fr
this.Control[iCurrent+13]=this.st_init_param
this.Control[iCurrent+14]=this.gb_etab
this.Control[iCurrent+15]=this.r_1
this.Control[iCurrent+16]=this.r_2
this.Control[iCurrent+17]=this.ln_1
end on

on w_initialisation.destroy
call super::destroy
destroy(this.rb_ii)
destroy(this.rb_ip)
destroy(this.rb_ie)
destroy(this.rb_pt)
destroy(this.rb_if)
destroy(this.p_2)
destroy(this.p_1)
destroy(this.cb_ok)
destroy(this.rb_it)
destroy(this.rb_es)
destroy(this.rb_gb)
destroy(this.rb_fr)
destroy(this.st_init_param)
destroy(this.gb_etab)
destroy(this.r_1)
destroy(this.r_2)
destroy(this.ln_1)
end on

event timer;call super::timer;long ll_width

ii_num_rectangle ++

if (100 * ii_num_rectangle) > 500 then
	timer(0)
	postevent("ue_close")
	openwithparm (w_impression_fichiers,i_str_pass)
	return
end if

ll_width = 100 * ii_num_rectangle

r_2.width = ll_width
r_2.visible = true
end event

event ue_close;call super::ue_close;close(this)
end event

event ue_ok;call super::ue_ok;String ls_fichier_ini
String ls_pdf
String ls_cde_pdf
String ls_key

datastore ds_datastore
Long ll_row
Integer   li_return

cb_ok.enabled = false
height = 1500
timer(1)

// alimentation  du code etablissement
if rb_fr.checked then
	g_s_etab = 'FR'
elseif  rb_gb.checked then
	g_s_etab = 'GB'
elseif  rb_es.checked then
	g_s_etab = 'ES'
elseif  rb_it.checked then
	g_s_etab = 'IT'
elseif  rb_if.checked then
	g_s_etab = 'IF'	
elseif  rb_pt.checked then
	g_s_etab = 'PT'	
elseif  rb_ie.checked then
	g_s_etab = 'IE'	
elseif  rb_ip.checked then
	g_s_etab = 'IP'		
elseif  rb_ii.checked then
	g_s_etab = 'II'		
else
	messageBox ("Controle","Sélection de l'établissement obligatoire",information!)
	return
end if

ls_fichier_ini = GetApplication().AppName

// Lecture du fichier INI de l'application
g_nv_ini.fnv_open ("PowerTool",ls_fichier_ini, true)

// Connexion au SGBDR
if SQLCA.fnv_db_connect("", ls_fichier_ini , "", "", true) < 0 then
    	triggerEvent("ue_close")
end if

ds_datastore = create datastore
ds_datastore.dataobject = "d_parametres"
ds_datastore.setTransObject (sqlca)

if ds_datastore.Retrieve(g_s_etab) = -1 then
	messageBox ("Initialisation","Problême d'acces à la table des paramètres",stopsign!)
	disconnect;
    	triggerEvent("ue_close")
end if

if ds_datastore.Retrieve(g_s_etab) = 0 then
	messageBox ("Initialisation","Paramètrage manquant pour l'établissement",stopsign!)
	timer(0)
    	triggerEvent("ue_close")
end if

// alimentation des paramètres
for ll_row = 1 to ds_datastore.rowCount()
	if ds_datastore.getItemString(ll_row,"code_param") = "SERVEUR_SMTP" then
   			g_s_serveur_smtp = ds_datastore.getItemString(ll_row,"valeur_alpha")
			i_str_pass.s[10] =  ds_datastore.getItemString(ll_row,"valeur_alpha")
	end if
	if ds_datastore.getItemString(ll_row,"code_param") = "PATH_FICHIERS" then
   			g_s_path_fichier = ds_datastore.getItemString(ll_row,"valeur_alpha")
			i_str_pass.s[11] = ds_datastore.getItemString(ll_row,"valeur_alpha")
//   			g_s_path_fichier_fac = ds_datastore.getItemString(ll_row,"valeur_alpha")	
		    i_str_pass.s[12] = ds_datastore.getItemString(ll_row,"valeur_alpha")
//   			g_s_path_fichier_cde = ds_datastore.getItemString(ll_row,"valeur_alpha")	
             i_str_pass.s[13] = ds_datastore.getItemString(ll_row,"valeur_alpha")				
	end if	
	if ds_datastore.getItemString(ll_row,"code_param") = "PATH_FICHIERS_CDE" then
//   			g_s_path_fichier_cde = ds_datastore.getItemString(ll_row,"valeur_alpha")		
			i_str_pass.s[13] = ds_datastore.getItemString(ll_row,"valeur_alpha")
	end if
	if ds_datastore.getItemString(ll_row,"code_param") = "PATH_FICHIERS_FAC" then
//   			g_s_path_fichier_fac = ds_datastore.getItemString(ll_row,"valeur_alpha")
			i_str_pass.s[12] = ds_datastore.getItemString(ll_row,"valeur_alpha")
	end if	
next

// recherche de la date la plus grande des pieces
ds_datastore.dataobject = "d_max_date_document"
ds_datastore.setTransObject (sqlca)

if ds_datastore.Retrieve() = -1 then
	messageBox ("Initialisation","Problême d'acces à la table des documents",stopsign!)
	disconnect;
	timer(0)	
    	triggerEvent("ue_close")
end if

if ds_datastore.rowCount() = 1 then
   g_d_max_date = ds_datastore.getItemDate(1,1)
else
  g_d_max_date =today()
end if


//recherche du programme de gestion des PDF
li_return =  RegistryGet (REGISTRY_KEY_PDF, REGISTRY_DEFAUT_VALUE, RegString! ,ls_pdf)
if li_return = -1 then
	messageBox ("Initialisation","Pas de Programme d'ouverture de fichier PDF trouvé",stopsign!)
	disconnect;
    	triggerEvent("ue_close")
end if

ls_key = REGISTRY_KEY_CLASSES + "\" + ls_pdf + "\shell\open\command"
li_return =  RegistryGet (ls_key, REGISTRY_DEFAUT_VALUE, RegString! ,ls_cde_pdf)
if li_return = -1 then
	messageBox ("Initialisation","Pas de Programme d'ouverture de fichier PDF trouvé",stopsign!)
	disconnect;
	timer(0)
    	triggerEvent("ue_close")
end if
g_s_commande_open_pdf = mid(ls_cde_pdf,1,pos(ls_cde_pdf,"%1")-1)

ls_key = REGISTRY_KEY_CLASSES + "\" + ls_pdf + "\shell\print\command"
li_return =  RegistryGet (ls_key, REGISTRY_DEFAUT_VALUE, RegString! ,ls_cde_pdf)
if li_return = -1 then
	g_s_commande_print_pdf = g_s_commande_open_pdf
else
     g_s_commande_print_pdf = mid(ls_cde_pdf,1,pos(ls_cde_pdf,"%1")-1)
end if	  

// remplace le %1 par une chaine vide

end event

event open;call super::open;height =1500
end event

event ue_init;call super::ue_init;String ls_user
String ls_etab
String ls_fichier_ini
Boolean lb_change_version = False
Boolean lb_new_install = false
Long ll_row
datastore ds_datastore
String ls_commande
Boolean lb_true = false

// Lecture du fichier INI de l'application
ls_fichier_ini = GetApplication().AppName
g_nv_ini.fnv_open ("PowerTool",ls_fichier_ini, true)

//recherche de la cle sous XP
// RegistryGet(  REGISTRY_KEY_USER, REGISTRY_NAME_USER1, RegString!, ls_user)
//if ls_user ="" or isnull(ls_user) then
//	// recherche de la cle sous W7
//    RegistryGet(  REGISTRY_KEY, REGISTRY_NAME_USER, RegString!, ls_user)
//end if
//
//if ls_user ="" or isnull(ls_user) then
//	ls_user = g_nv_ini.fnv_profile_string( "Param", "User", "NOTFIND")
//end if
//
//
//if pos(ls_user,"\") > 0 then
//   ls_user = mid(ls_user,pos(ls_user,"\") +1)
//end if
//
this.title = this.title + " - " + ls_user


// Connexion au SGBDR
if SQLCA.fnv_db_connect("", ls_fichier_ini , "", "", true) < 0 then
    	triggerEvent("ue_close")
end if

// Controle si une nouvelle version est disponible
ds_datastore = create datastore
ds_datastore.dataobject = "d_parametres"
ds_datastore.setTransObject (sqlca)

if ds_datastore.Retrieve("INF") = -1 then
	messageBox ("Initialisation","Problême d'acces à la table des paramètres",stopsign!)
	disconnect;
    	triggerEvent("ue_close")
     return		 
end if
// alimentation des paramètres
for ll_row = 1 to ds_datastore.rowCount()
	if ds_datastore.getItemString(ll_row,"code_param") = "VERSION"  and i_s_version <>  ds_datastore.getItemString(ll_row,"valeur_alpha")  then
		lb_change_version = true		 
     end if
	if ds_datastore.getItemString(ll_row,"code_param") = "INSTALL" then
		lb_new_install = true
		ls_commande =  ds_datastore.getItemString(ll_row,"valeur_alpha")
	end if
next

if lb_new_install and lb_change_version then
	messagebox ("Installation ", "Une nouvelle version doit être installée / A new version must be install",Information!)
	run (ls_commande)
	disconnect;
	triggerevent("ue_close")
	return
end if

g_s_version = i_s_version
//ds_datastore = create datastore
//ds_datastore.dataobject = "d_parametres_user"
//ds_datastore.setTransObject (sqlca)
//
//if ds_datastore.Retrieve(ls_user) = -1 then
//	messageBox ("Initialisation","Problême d'acces à la table des paramètres",stopsign!)
//	disconnect;
//    	triggerEvent("ue_close")
//	return	 
//end if
//
//if ds_datastore.RowCount() = 0  then
//	messageBox ("Initialisation","Paramètrage non défini",stopsign!)
//	disconnect;
//    	triggerEvent("ue_close")
//     return		 
//end if

lb_true = true
//for ll_row = 1 to ds_datastore.rowCount()
//	      ls_etab = ds_datastore.getitemString(ll_row,"VALEUR_ALPHA")
//		if ll_row > 1 then
//			 lb_true = false
//		end if
//		Choose case ls_etab
//			case "FR"
//				rb_fr.checked = lb_true
//				rb_fr.enabled = true
//			case "GB"
//				rb_gb.checked = lb_true
//				rb_gb.enabled = true
//			case "IT"
//				rb_it.checked = lb_true
//				rb_it.enabled = true		
//			case "ES"
//				rb_es.checked	 = true	
//				rb_es.enabled = true		
//			case "IF"
//				rb_if.checked	 = lb_true	
//				rb_if.enabled = true		
//			case "PT"
//				rb_pt.checked	 = lb_true	
//				rb_pt.enabled = true	
//			case "IE"
//				rb_ie.checked	 = lb_true	
//				rb_ie.enabled = true		
//			case "IP"
//				rb_ip.checked	 = lb_true	
//				rb_ip.enabled = true		
//			case "II"
//				rb_ii.checked	 = lb_true	
//				rb_ii.enabled = true						
//     	end choose
//next

rb_fr.enabled = true
rb_gb.enabled = true
rb_it.enabled = true
rb_es.enabled = true
rb_pt.enabled = true
end event

type rb_ii from u_rba within w_initialisation
integer x = 631
integer y = 696
integer width = 654
integer height = 64
long backcolor = 12632256
boolean enabled = false
string text = "II - Internet Italie"
end type

type rb_ip from u_rba within w_initialisation
integer x = 631
integer y = 612
integer width = 654
integer height = 64
long backcolor = 12632256
boolean enabled = false
string text = "IP - Internet Portugal"
end type

type rb_ie from u_rba within w_initialisation
integer x = 631
integer y = 524
integer width = 704
integer height = 64
long backcolor = 12632256
boolean enabled = false
string text = "IE - Internet Espagne"
end type

type rb_pt from u_rba within w_initialisation
integer x = 631
integer y = 436
integer width = 475
integer height = 64
long backcolor = 12632256
boolean enabled = false
string text = "PT - Portugal"
end type

type rb_if from u_rba within w_initialisation
integer x = 631
integer y = 356
integer width = 475
integer height = 64
long backcolor = 12632256
boolean enabled = false
string text = "IF - Internet france"
end type

type p_2 from u_pa within w_initialisation
integer x = 1399
integer y = 64
integer width = 457
integer height = 236
string picturename = "C:\appscir\DivaPrint\Images\logo.jpg"
boolean focusrectangle = true
end type

type p_1 from u_pa within w_initialisation
integer x = 37
integer y = 64
integer width = 366
integer height = 320
string picturename = "C:\appscir\DivaPrint\Images\Logo Pegasus.jpg"
end type

type cb_ok from u_cba within w_initialisation
integer x = 649
integer y = 848
integer width = 512
integer height = 96
integer taborder = 20
string text = "OK"
end type

event constructor;call super::constructor;	fu_setevent ("ue_ok")
end event

type rb_it from u_rba within w_initialisation
integer x = 631
integer y = 292
integer width = 475
integer height = 64
long backcolor = 12632256
boolean enabled = false
string text = "IT - Italien"
end type

type rb_es from u_rba within w_initialisation
integer x = 631
integer y = 228
integer width = 475
integer height = 64
long backcolor = 12632256
boolean enabled = false
string text = "ES - Espagne"
end type

type rb_gb from u_rba within w_initialisation
integer x = 631
integer y = 164
integer width = 585
integer height = 64
long backcolor = 12632256
boolean enabled = false
string text = "GB - Grande Bretagne"
end type

type rb_fr from u_rba within w_initialisation
integer x = 631
integer y = 100
integer width = 475
integer height = 64
long backcolor = 12632256
boolean enabled = false
string text = "FR - France"
end type

type st_init_param from statictext within w_initialisation
integer x = 256
integer y = 1060
integer width = 1243
integer height = 128
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Veuillez patienter , initialisation des paramètres / Please wait, Parameters initialization"
alignment alignment = center!
boolean focusrectangle = false
boolean disabledlook = true
end type

type gb_etab from groupbox within w_initialisation
integer x = 553
integer y = 36
integer width = 791
integer height = 776
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 12632256
string text = "Etablissement"
end type

type r_1 from rectangle within w_initialisation
integer linethickness = 4
long fillcolor = 16777215
integer x = 667
integer y = 1220
integer width = 498
integer height = 76
end type

type r_2 from rectangle within w_initialisation
boolean visible = false
integer linethickness = 4
long fillcolor = 16711680
integer x = 658
integer y = 1220
integer width = 101
integer height = 76
end type

type ln_1 from line within w_initialisation
long linecolor = 33554432
integer linethickness = 4
integer beginy = 996
integer endx = 1938
integer endy = 996
end type

