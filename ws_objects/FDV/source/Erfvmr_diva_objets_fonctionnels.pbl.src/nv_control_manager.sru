$PBExportHeader$nv_control_manager.sru
$PBExportComments$Effectue le controle d'existence du code saisi et ceci par rapport à la table correspondante.
forward
global type nv_control_manager from nonvisualobject
end type
end forward

global type nv_control_manager from nonvisualobject
end type
global nv_control_manager nv_control_manager

type variables
str_pass i_str_pass
nv_datastore	i_ds_donnee
		// s[1] = code a valider
		// s[2] = contiendra l'intitule
		// s[3] = nom colonne contenant le code
		// s[4] = nom colonne contenant l'intitule	
		// s[5] = nom datawindow
		// s[6] = nom contenant de l'info supplementaire à envoyer	
		// s[7] = nom de la table pour recherche de la traduction
		
   	// à partir de s[10], on peut passer des arguments
		// s[20] = type de controle client livre a effectuer
		// d[1] = nombre d'arguments
		// b[1] = validation Ok ou NOK
		// b[2] = Info suplementaire à envoyer
//String i_s_version =   '2011-09-28'
//String i_s_version = '2012-05-15'
//String i_s_version = '2013-12-01'
//String i_s_version = '2014-07-01'
//String i_s_version = '2014-02-01'
//String i_s_version = '2014-09-01_P01'
//String i_s_version = '2014-12-01'
//String i_s_version = '2015-04-01'
//String i_s_version = '2015-09-01'
//String i_s_version = '2015-09-15'
//String i_s_version = '2016-05-09'
//String i_s_version = '2019-02-01'
String i_s_version = '2019-03-01'
//String i_s_version = '2020-06-12'
//String i_s_patch    =  'P01'
//String i_s_patch    =  'P02'
String i_s_patch    = ''
end variables
forward prototypes
private function any get_data ()
private function any get_data_with_argument ()
public function any is_code_langue_valide (any as_str_pass)
public function any is_client_livre_valide (any as_str_pass)
public function any is_client_valide (any as_str_pass)
public function any is_correspondanciere_valide (any as_str_pass)
public function any is_devise_valide (any as_str_pass)
public function any is_echeance_valide (any as_str_pass)
public function any is_fonction_client_valide (any as_str_pass)
public function any is_grossiste_valide (any as_str_pass)
public function any is_incoterm_valide (any as_str_pass)
public function any is_mode_expedition_valide (any as_str_pass)
public function any is_mode_paiement_valide (any as_str_pass)
public function any is_nature_valide (any as_str_pass)
public function any is_niveau_responsabilite_valide (any as_str_pass)
public function any is_origine_cde_valide (any as_str_pass)
public function any is_pays_valide (any as_str_pass)
public function any is_resp_secteur_valide (any as_str_pass)
public function any is_type_cde_valide (any as_str_pass)
public function any is_blocage_sap_valide (any as_str_pass)
public function any is_validation_arun_valide (any as_str_pass)
public subroutine get_traduction ()
public function any is_ucc_valide (any as_str_pass)
public function boolean is_portable_connecte (ref transaction a_tr_serveur, ref string as_message)
public function boolean is_version_valide ()
public subroutine get_data_by_langue ()
public subroutine get_data_by_langue_with_argument ()
public function boolean is_date_valide (string as_date)
public function boolean is_date_liv_valide (string as_date)
public function boolean is_transfert_interdit ()
public function boolean is_recup_interdite ()
public function any is_marche_valide (any as_str_pass)
public function string get_version ()
public function string get_patch ()
public function boolean is_date_cde_valide (string as_date)
end prototypes

private function any get_data ();/* <DESC>
    Fonction générique de validation de la saisie d'un code à partir d'une datawindow sans argument particulier.
	 
    Principe:
	 
	 Modification de la datawindow correspondante au code à contrôler et passé en paramètre, en rajoutant ou en complétant 
	 la clause where sur le code à contrôler. Ces informations sont passées via la structure d'instance Str_pass
	 
	 Retrieve de la datawindow
	  Si aucune donnée extraite (code inexistant), on initialise la première variable booléenne à Faux
	  Sinon on initialise la première variable booléenne à Vrai,on retourne le code faisant l'objet du controle
	  avec son intitulé si demander.
   </DESC> */

String s_sql
string mod_string
String s_retour

i_ds_donnee.DataObject = i_str_pass.s[5] 
i_ds_donnee.SetTransObject (SQLCA) 
s_sql = i_ds_donnee.getSqlSelect()

if pos(s_sql,"WHERE") = 0 then
	s_sql = s_sql + " WHERE " 
else
	s_sql = s_sql + " AND " 
end if

s_sql = s_sql + i_str_pass.s[3] + " = '" + i_str_pass.s[1] + "'"	
i_ds_donnee.SetSqlSelect(s_sql)

if i_ds_donnee.retrieve() = -1 THEN
		f_dmc_error ("Control Manager" + BLANK + i_ds_donnee.uf_getdberror( )	)			
end if

if i_ds_donnee.RowCount() = 0 then
	i_str_pass.b[1] =  false
else
	i_str_pass.b[1] =  true
	i_str_pass.s[2] = i_ds_donnee.getItemString(1, i_str_pass.s[4])
	if i_str_pass.b[2] then
		i_str_pass.s[3] = i_ds_donnee.getItemString(1, i_str_pass.s[6])		
	end if
end if	

return i_str_pass
end function

private function any get_data_with_argument ();/* <DESC>
    Fonction générique de validation de la saisie d'un code à partir d'une datawindow avec argument.
	 (Clause where intégrée dans la datawindow )
	 
    Principe:
	 
	 Initialisation de la data window du datatsore à partir du nom stocké dans la structure d'instance.

	 Retrieve de la datawindow en lui passant le code et un critère supplémentaire stocké dans le tableau
	 des chaines de caractères en position 10 et on complète la structure d'instance en fonction du résultat.
	 
	  Si aucune extraite (code inexistant), on initialise la première variable booléenne à Faux
	  Sinon on initialise la première variable booléenne à Vrai et retourne le code faisant l'objet du contrôle
	  avec son intitulé si demander.
   </DESC> */
nv_Datastore ds_control
integer li_retrieve

ds_control = CREATE nv_DATASTORE
ds_control.DataObject = i_str_pass.s[5]
ds_control.SetTransObject (SQLCA) 
li_retrieve = ds_control.retrieve(i_str_pass.s[10],i_str_pass.s[01])

if li_retrieve = -1 THEN
		f_dmc_error ("Control Manager" + BLANK + ds_control.uf_getdberror( )  )			
end if

if ds_control.RowCount() = 0 then
	i_str_pass.b[1] = false
else
	i_str_pass.b[1] = true	
	i_str_pass.s[2] = ds_control.getItemString(1, i_str_pass.s[4])	
	if i_str_pass.b[2] then
		i_str_pass.s[3] = ds_control.getItemString(1, i_str_pass.s[6])		
	end if
end if

return i_str_pass

end function

public function any is_code_langue_valide (any as_str_pass);/* <DESC>
     Permet de contrôler l'existence du code langue
   </DESC> */
i_str_pass = as_str_pass
i_str_pass.s[3] = DBNAME_CODE_LANGUE
i_str_pass.s[4] = DBNAME_CODE_LANGUE_INTITULE
i_str_pass.s[5] = 'd_liste_code_langue'
i_str_pass.s[7] = 'COME9010'
i_str_pass.b[2] = false

get_data_by_langue()
return i_str_pass

end function

public function any is_client_livre_valide (any as_str_pass);/* <DESC>
     Permet de contrôler de l'existence du client livré  lors de la saisie de l'entête de la commande ou
     lors de la création du client prospect.
	// Modif version 2010-01-01
   </DESC> */

i_str_pass = as_str_pass
if i_str_pass.s[6] = OPTION_CLIENT then      // Si commande sur client prospect
	i_str_pass = as_str_pass
	i_str_pass.s[3] = DBNAME_CLIENT_CODE
	i_str_pass.s[4] = DBNAME_CLIENT_ABREGE_NOM
	i_str_pass.s[5] = 'd_client_control'
	i_str_pass.s[6] = DBNAME_CLIENT_ABREGE_VILLE
	i_str_pass.b[2] = true
	return get_data()
end if


if i_str_pass.s[10] = i_str_pass.s[1] then
	i_str_pass = as_str_pass
	i_str_pass.s[3] = DBNAME_CLIENT_CODE
	i_str_pass.s[4] = DBNAME_CLIENT_ABREGE_NOM
	i_str_pass.s[5] = 'd_client_control'
	i_str_pass.s[6] = DBNAME_CLIENT_ABREGE_VILLE
	i_str_pass.b[2] = true
	return get_data()	
end if

i_str_pass.s[3] = DBNAME_CLIENT_LIVRE_CODE
i_str_pass.s[4] = DBNAME_CLIENT_LIVRE_ABREGE_NOM
i_str_pass.s[5] = 'd_client_livre_control'
i_str_pass.s[6] = DBNAME_CLIENT_LIVRE_ABREGE_VILLE
i_str_pass.b[2] = true	
i_str_pass.d[1] = 1
return get_data_with_argument()



end function

public function any is_client_valide (any as_str_pass);/* <DESC>
     Permet de contrôler l'existence du code client payeur ou du client facturé lors de la création du client prospect.
   </DESC> */
i_str_pass = as_str_pass
i_str_pass.s[3] = DBNAME_CLIENT_CODE
i_str_pass.s[4] = DBNAME_CLIENT_ABREGE_NOM
i_str_pass.s[5] = 'd_client_control'
i_str_pass.s[6] = DBNAME_CLIENT_ABREGE_VILLE
i_str_pass.b[2] = true


return get_data()

end function

public function any is_correspondanciere_valide (any as_str_pass);/* <DESC>
     Permet de contrôler l'existence du code correspondancière
   </DESC> */
i_str_pass = as_str_pass
i_str_pass.s[3] = DBNAME_CODE_CORREPONDANTE
i_str_pass.s[4] = DBNAME_CODE_CORREPONDANTE_NOM
i_str_pass.s[5] = 'd_liste_correspondancieres'
i_str_pass.s[7] = 'COME9015'
i_str_pass.b[2] = false

get_data_by_langue()
return i_str_pass


end function

public function any is_devise_valide (any as_str_pass);/* <DESC>
     Permet de contrôler l'existence du code devise
   </DESC> */
i_str_pass = as_str_pass
i_str_pass.s[3] = DBNAME_CODE_DEVISE
i_str_pass.s[4] = DBNAME_CODE_DEVISE_INTITULE
i_str_pass.s[5] = 'd_liste_devise'
i_str_pass.s[7] = 'COME9022'
i_str_pass.b[2] = false

get_data_by_langue()
return i_str_pass


end function

public function any is_echeance_valide (any as_str_pass);/* <DESC>
     Permet de contrôler l'existence du code échéance
   </DESC> */
i_str_pass = as_str_pass
i_str_pass.s[3] = DBNAME_CODE_ECHEANCE
i_str_pass.s[4] = DBNAME_CODE_ECHEANCE_INTITULE
i_str_pass.s[5] = 'd_liste_echeance'
i_str_pass.s[7] = 'COME9005'
i_str_pass.b[2] = false

get_data_by_langue()
return i_str_pass

end function

public function any is_fonction_client_valide (any as_str_pass);/* <DESC>
     Permet de contrôler l'existence du code fonction du client
   </DESC> */
i_str_pass = as_str_pass
i_str_pass.s[3] = DBNAME_FONCTION
i_str_pass.s[4] = DBNAME_FONCTION_INTITULE
i_str_pass.s[5] = 'd_liste_fonction_client'
i_str_pass.s[7] = 'COME9003'
i_str_pass.b[2] = false

get_data_by_langue()
return i_str_pass



end function

public function any is_grossiste_valide (any as_str_pass);/* <DESC>
     Permet de contrôler l'existence du code grossiste
   </DESC> */
i_str_pass = as_str_pass
i_str_pass.s[3] = DBNAME_CLIENT_CODE
i_str_pass.s[4] = DBNAME_CLIENT_ABREGE_NOM
i_str_pass.s[5] = 'd_liste_grossiste'
i_str_pass.s[10] = g_nv_come9par.get_code_langue()
i_str_pass.b[2] = false
return  get_data_with_argument()

end function

public function any is_incoterm_valide (any as_str_pass);/* <DESC>
     Permet de contrôler l'existence du code incoterm
   </DESC> */
i_str_pass = as_str_pass
i_str_pass.s[3] = DBNAME_CODE_INCOTERM
i_str_pass.s[4] = DBNAME_CODE_INCOTERM_INTITULE
i_str_pass.s[5] = 'd_liste_incoterm'
i_str_pass.s[7] = 'COME9011'
i_str_pass.b[2] = false

get_data_by_langue()
return i_str_pass
end function

public function any is_mode_expedition_valide (any as_str_pass);/* <DESC>
     Permet de contrôler l'existence du mode expedition
   </DESC> */
i_str_pass = as_str_pass
i_str_pass.s[3] = DBNAME_CODE_MODE_EXP
i_str_pass.s[4] = DBNAME_CODE_MODE_EXP_INTITULE
i_str_pass.s[5] = 'd_liste_mode_expedition'
i_str_pass.s[7] = 'COME9025'
i_str_pass.b[2] = false

get_data_by_langue()
return i_str_pass
end function

public function any is_mode_paiement_valide (any as_str_pass);/* <DESC>
     Permet de contrôler l'existence du mode de paiement
   </DESC> */
i_str_pass = as_str_pass
i_str_pass.s[3] = DBNAME_MODE_PAIEMENT
i_str_pass.s[4] = DBNAME_MODE_PAIEMENT_INTITULE
i_str_pass.s[5] = 'd_liste_mode_paiement'
i_str_pass.s[7] = 'COME9004'
i_str_pass.b[2] = false

get_data_by_langue()
return i_str_pass
end function

public function any is_nature_valide (any as_str_pass);/* <DESC>
     Permet de contrôler l'existence de la nature du client
   </DESC> */
i_str_pass = as_str_pass
i_str_pass.s[3] = DBNAME_NATURE_CLIENT
i_str_pass.s[4] = DBNAME_NATURE_CLIENT_INTITULE
i_str_pass.s[5] = 'd_liste_nature_client'
i_str_pass.s[7] = 'COME9002'
i_str_pass.b[2] = false

get_data_by_langue()
return i_str_pass


end function

public function any is_niveau_responsabilite_valide (any as_str_pass);/* <DESC>
     Permet de contrôler l'existence du code niveau de responsabilité
   </DESC> */
i_str_pass = as_str_pass
i_str_pass.s[3] = DBNAME_CODE_NIVEAU_RESP
i_str_pass.s[4] = DBNAME_CODE_NIVEAU_RESP_INTITULE
i_str_pass.s[5] = 'd_liste_niveau_responsabilite'
i_str_pass.s[7] = 'COME9014'
i_str_pass.b[2] = false

get_data_by_langue()
return i_str_pass

end function

public function any is_origine_cde_valide (any as_str_pass);/* <DESC>
     Permet de contrôler l'existence du code origine de la commande
   </DESC> */
i_str_pass = as_str_pass
i_str_pass.s[3] = DBNAME_ORIGINE_CDE
i_str_pass.s[4] = DBNAME_ORIGINE_CDE_INTITULE
i_str_pass.s[5] = 'd_liste_origine_cde'
i_str_pass.s[7] = 'COME9016'
i_str_pass.b[2] = false

get_data_by_langue()
return i_str_pass


end function

public function any is_pays_valide (any as_str_pass);/* <DESC>
     Permet de contrôler l'existence du code pays
   </DESC> */
i_str_pass = as_str_pass
i_str_pass.s[3] = DBNAME_PAYS
i_str_pass.s[4] = DBNAME_PAYS_INTITULE
i_str_pass.s[5] = 'd_liste_pays_langue'
i_str_pass.s[7] = 'COME9001'
i_str_pass.b[2] = false

get_data_by_langue()
return i_str_pass


end function

public function any is_resp_secteur_valide (any as_str_pass);/* <DESC>
     Permet de contrôler l'existence du code responsable de secteur
   </DESC> */
i_str_pass = as_str_pass
i_str_pass.s[3] = DBNAME_CODE_RESP_SECTEUR
i_str_pass.s[4] = DBNAME_CODE_RESP_SECTEUR_INTITULE
i_str_pass.s[5] = 'd_liste_resp_secteur'
i_str_pass.s[7] = 'COME9013'
i_str_pass.b[2] = false

get_data_by_langue()
return i_str_pass

end function

public function any is_type_cde_valide (any as_str_pass);/* <DESC>
     Permet de contrôler l'existence du type de commande
   </DESC> */
	long ll_found 
i_str_pass = as_str_pass
i_str_pass.s[3] = DBNAME_TYPE_CDE
i_str_pass.s[4] = DBNAME_TYPE_CDE_INTITULE
i_str_pass.s[5] = 'd_liste_type_cde'
i_str_pass.s[7] = 'COME9024'
i_str_pass.b[2] = false
get_data_by_langue()

if i_ds_donnee.RowCount() > 0 then
	ll_found = i_ds_donnee.Find(i_str_pass.s[3] + "='" + i_str_pass.s[01] + "'", 1, i_ds_donnee.RowCount())
	i_str_pass.s[6] = "N"
	i_str_pass.s[7] = i_ds_donnee.getItemString (ll_found, DBNAME_VALORISATION_CDE)
	i_str_pass.s[8] = i_ds_donnee.getItemString (ll_found, DBNAME_MODIF_REGROUPEMENT_CDE)
     i_str_pass.s[9] =""
end if

return i_str_pass


end function

public function any is_blocage_sap_valide (any as_str_pass);/* <DESC>
     Permet de controler l'existence du code blocage sap lors de la saisie de l'entête de la commande
   </DESC> */
i_str_pass = as_str_pass
i_str_pass.s[3] = DBNAME_CODE_BLOCAGE_SAP
i_str_pass.s[4] = DBNAME_CODE_BLOCAGE_SAP_INTITULE
i_str_pass.s[5] = 'd_liste_code_blocage'
i_str_pass.s[7] = 'COME9017'
i_str_pass.b[2] = false

get_data_by_langue()
return i_str_pass

end function

public function any is_validation_arun_valide (any as_str_pass);/* <DESC>
     Permet de contrôler l'existence du code arun
   </DESC> */
i_str_pass = as_str_pass
i_str_pass.s[3] = DBNAME_ARUN
i_str_pass.s[4] = DBNAME_ARUN_INTITULE
i_str_pass.s[5] = 'd_liste_code_arun'
i_str_pass.s[7] = 'COME9018'
i_str_pass.b[2] = false

get_data_by_langue()
return i_str_pass

end function

public subroutine get_traduction ();/* permet de rechercher l'intiule d'un code dans le code langue du visiteur */
nv_datastore lnv_datastore
lnv_datastore = create nv_datastore
lnv_datastore.dataobject = "d_object_traduction_code"
lnv_datastore.settrans (sqlca)

if lnv_datastore.retrieve(i_str_pass.s[7],i_str_pass.s[1], g_nv_come9par.get_code_langue()) = DB_ERROR then
	f_dmc_error (lnv_datastore.uf_getdberror( ))
end if

if lnv_datastore.rowCount() = 1 then
	i_str_pass.s[2] = lnv_datastore.getitemstring(1,DBNAME_VALEUR_PARAM)
end if
end subroutine

public function any is_ucc_valide (any as_str_pass);/* <DESC>
     Permet de contrôler l'existence du code unite commande client
   </DESC> */
i_str_pass = as_str_pass
i_str_pass.s[3] = DBNAME_UCC
i_str_pass.s[4] = DBNAME_UCC_INTITULE
i_str_pass.s[5] = 'd_liste_ucc'
i_str_pass.s[7] = 'COME9008'
i_str_pass.b[2] = false

get_data_by_langue()
return i_str_pass
end function

public function boolean is_portable_connecte (ref transaction a_tr_serveur, ref string as_message);/* cette fonction va controler que le portable est bien connecté au réseau.
  ces controles ne sont pas effectués pour les visiteurs de profile RC

   1- Controle que le serveur réponde par le lancement de la commande Ping
        stockée dans la table come9_parametre_info .Le résultat du ping est stocké dans un fichier.
		 
	   Analyse du fichier en vérifiant si le texte 'TTL='  est existant. Si oui cela signifie que le serveur repond
	   dans le cas contraire, le PC n'est pas connécté.
		
   2- Controle que la base de donnée est accessible.
*/	
String ls_parametre, ls_fichier, ls_enreg
integer li_FileNum, li_return
Boolean  lb_ping_ok

if g_nv_come9par.is_relation_clientele( ) then
		goto Controle_database
end if

nv_param_informatique  lnv_param
lnv_param = create nv_param_informatique

	// Analyse du fichier
ls_fichier = lnv_param.fu_get_ping_file( )
if ls_fichier = "???" then
	goto Controle_database
end if 

FileDelete (ls_fichier)

	// execution du ping
ls_parametre = lnv_param.fu_get_commande_ping()
if ls_parametre = "???" then
	goto Controle_database
end if 

run ( ls_parametre) 

	// controle si le fichier existe. Le fichier est créé par la commande run juste au dessus
	// le problême est qu'il n'existe pas de possibilité d'attendre que le run soit fini
	// pour cet raison une boucle est mise en place jusqu'à présence du fichier.
boolean lb_fichier_existe 
do while not lb_fichier_existe
	if FileExists(ls_fichier) then
		lb_fichier_existe = true
	end if
loop
	
li_FileNum = -1
do while li_fileNum = -1 
	li_FileNum = FileOpen(ls_fichier)
loop

li_return = 0
lb_ping_ok = false

do while   li_return <> -100
    li_return = FileRead (li_FileNum,ls_enreg)
    if Pos(ls_enreg, "TTL=") > 0 then
		 lb_ping_ok = true
    end if
loop 

fileclose(li_filenum)

if not lb_ping_ok then
     as_message = g_nv_traduction.get_traduction ("PING_ERREUR")
	return false
end if

Controle_database:
//Acces_base:
// 2- Controle si base de donnée accessible.
connect using a_tr_serveur;
if a_tr_serveur.SQLDBCode	<> 0 then
	  as_message = g_nv_traduction.get_traduction ("DATABASE_ERREUR")
       return false
end if

destroy nv_param_informatique
return true
end function

public function boolean is_version_valide ();//Traitement de controle des versions
// Si la version de l'application est différente de la version déployée et de la version précédente, 
//     Controle si la version est autorisée pour le profile du visiteur 
//     Si version autorisée, affichage d'un message et affichage de page d'installation et fermeture de l'application.
//     Sinon c'est que la version de l'application est périmée et dans ce cas une page va être affichée 
//	pour spécifier ce que doit faire la personne et  l'application fermée.
// Si la version de l'application est différente de la version déployée, affichage d'un message et affichage de page 
// d'installation et fermeture de l'application.
nv_param_informatique  lnv_param
String  ls_version
String ls_version_precedente
String ls_version_profil
String ls_patch
String ls_chaine

lnv_param = create nv_param_informatique
ls_version = lnv_param.fu_get_version_autorisee( )
ls_version_precedente = lnv_param.fu_get_version_precedente()
ls_patch = lnv_param.fu_get_dernier_patch()

// Controle si la version de l'application n'est pas périmée
if i_s_version <> ls_version and i_s_version <> ls_version_precedente  then
	lnv_param.fu_ouvrir_page_alerte()
	return false
end if
	
// Controle du numero de version
if i_s_version <> ls_version then
	messageBox("Version", g_nv_traduction.get_traduction ("INSTALLATION_VERSION_1")   + " ~r~n ~r~n" +  &
								 	  g_nv_traduction.get_traduction ("INSTALLATION_VERSION_2")   + " ~r~n ~r~n" + & 
	                                          g_nv_traduction.get_traduction ("INSTALLATION_VERSION_3")  , Exclamation!, ok!)

	lnv_param.fu_ouvrir_page_installe()
      return false
end if

// Controle du numero de patch
// le patch est constitué du n° de version + 'n° du patch'
// controle que le n° de version du patch correspond à celui de la version
If ls_version <> i_s_version then
	return true
end if

ls_chaine = i_s_version + i_s_patch
if ls_patch > i_s_patch then
	messageBox("Patch", g_nv_traduction.get_traduction ("INSTALLATION_VERSION_1")   + " ~r~n ~r~n" +  &
							    g_nv_traduction.get_traduction ("INSTALLATION_VERSION_2")   + " ~r~n ~r~n" + & 
	                               g_nv_traduction.get_traduction ("INSTALLATION_VERSION_3")  , Exclamation!, ok!)

	lnv_param.fu_ouvrir_page_installe( )
     return false
end if

return true
end function

public subroutine get_data_by_langue ();/* <DESC>
    Fonction générique de validation de la saisie d'un code à partir d'une datawindow 
	 
    Principe:
	  Retrieve de la datawindow  en passant en paramètre le code langue
	  Recherche is le code se trouve dans la datawindow :
	  
	  Si code non trouvé (code inexistant), on initialise la première variable booléenne à Faux
	  Sinon on initialise la première variable booléenne à Vrai et retourne le code faisant l'objet du contrôle
	  avec son intitulé si demander.
   </DESC> */
nv_Datastore ds_control
integer li_retrieve
long ll_found

ds_control = CREATE nv_DATASTORE
i_ds_donnee.DataObject = i_str_pass.s[5]
i_ds_donnee.SetTransObject (SQLCA) 
li_retrieve = i_ds_donnee.retrieve(g_nv_come9par.get_code_langue( ))

if li_retrieve = -1 THEN
		f_dmc_error ("Control Manager" + BLANK + i_ds_donnee.uf_getdberror( )  )			
end if

if i_ds_donnee.RowCount() = 0 then
	i_str_pass.b[1] = false
	return 
end if

ll_found = i_ds_donnee.Find(i_str_pass.s[3] + "='" + i_str_pass.s[01] + "'", 1, i_ds_donnee.RowCount())
if ll_found = 0 then
	i_str_pass.b[1] = false
	return 
end if	

i_str_pass.b[1] = true	
i_str_pass.s[2] = i_ds_donnee.getItemString(ll_found, i_str_pass.s[4])	
if i_str_pass.b[2] then
	i_str_pass.s[3] = i_ds_donnee.getItemString(ll_found, i_str_pass.s[6])		
end if

return 

end subroutine

public subroutine get_data_by_langue_with_argument ();/* <DESC>
    Fonction générique de validation de la saisie d'un code à partir d'une datawindow avec argument.
	 (Clause where intégrée dans la datawindow )
	 
    Principe:
	 
	 Initialisation de la data window du datatsore à partir du nom stocké dans la structure d'instance.

	 Retrieve de la datawindow en lui passant le code et un critère supplémentaire stocké dans le tableau
	 des chaines de caractères en position 10 et on complète la structure d'instance en fonction du résultat.
	 
	  Si aucune extraite (code inexistant), on initialise la première variable booléenne à Faux
	  Sinon on initialise la première variable booléenne à Vrai et retourne le code faisant l'objet du contrôle
	  avec son intitulé si demander.
   </DESC> */
nv_Datastore ds_control
integer li_retrieve

ds_control = CREATE nv_DATASTORE
i_ds_donnee.DataObject = i_str_pass.s[5]
i_ds_donnee.SetTransObject (SQLCA) 
li_retrieve = i_ds_donnee.retrieve(i_str_pass.s[10],i_str_pass.s[01],g_nv_come9par.get_code_langue( ) )

if li_retrieve = -1 THEN
		f_dmc_error ("Control Manager" + BLANK + i_ds_donnee.uf_getdberror( )  )			
end if

if i_ds_donnee.RowCount() = 0 then
	i_str_pass.b[1] = false
else
	i_str_pass.b[1] = true	
	i_str_pass.s[2] = i_ds_donnee.getItemString(1, i_str_pass.s[4])	
	if i_str_pass.b[2] then
		i_str_pass.s[3] = i_ds_donnee.getItemString(1, i_str_pass.s[6])		
	end if
end if

end subroutine

public function boolean is_date_valide (string as_date);/* Cette fonction va controler la validité de la date passée en paramètre.
    la date doit être compris entre 01/01/1900 et le 31/12/2999
 */
 Date ld_date_debut 
 Date ld_date_fin
 
 ld_date_debut = date ('1900-01-01')
 ld_date_fin = date ('2999-12-31')
  
 if not  IsDate (as_date) then
	return false
 end if
 
 if date (as_date ) > ld_date_fin or date (as_date ) < date (as_date )  then
	return false
end if
 
 return true

end function

public function boolean is_date_liv_valide (string as_date);/* Cette fonction va controler la validité de la date de livraison passée en paramètre.
    la date doit être compris entre 01/01/1900 et le 31/12/2999
 */
 Date ld_date_debut 
 Date ld_date_fin
 date ld_date
 long ll_ecart
 
 ld_date_debut = date ('1900-01-01')
  
 if not is_date_valide(as_date) then 
	 return false
end if
 
ld_date = date(as_date)

if ld_date = ld_date_debut then
	return true
end if

ll_ecart = DaysAfter ( today(), ld_date )
if  ll_ecart < 365 then
	return true
end if

if MessageBox ("Controle" ,g_nv_traduction.get_traduction(DATE_LIV_LOINTAINE) ,StopSign!,YesNo! ,1) = 2 then
	return false
end if
	
return true

end function

public function boolean is_transfert_interdit ();//Permet de valider si le transfert des commandes est autorisé ou non
// Si le transfert est interdit, affichage d'une message
nv_param_informatique  lnv_param
String  ls_version
String ls_version_precedente
String ls_version_profil

lnv_param = create nv_param_informatique
if  lnv_param.fu_transfert_interdit () then
	messageBox("Transfert", g_nv_traduction.get_traduction ("TRF_INTERDIT_1")   + " " +  g_nv_traduction.get_traduction ("TRF_INTERDIT_2"),  StopSign!, ok!)
     return true
end if

return false
end function

public function boolean is_recup_interdite ();//Permet de valider si la récupération des commandes est autorisé ou non
// Si le récupération est interdite, affichage d'une message
nv_param_informatique  lnv_param
String  ls_version
String ls_version_precedente
String ls_version_profil

lnv_param = create nv_param_informatique
if  lnv_param.fu_recup_interdite () then
	messageBox("Transfert", g_nv_traduction.get_traduction ("RECUP_INTERDIT_1")   + " " +  g_nv_traduction.get_traduction ("RECUP_INTERDIT_2"),  StopSign!, ok!)
     return true
end if

return false
end function

public function any is_marche_valide (any as_str_pass);/* <DESC>
     Permet de contrôler l'existence du code marché
   </DESC> */
i_str_pass = as_str_pass
i_str_pass.s[3] = DBNAME_CODE_MARCHE
i_str_pass.s[4] = DBNAME_CODE_MARCHE_INTITULE
i_str_pass.s[5] = 'd_liste_marche'
i_str_pass.s[7] = 'COME9019'
i_str_pass.b[2] = false

get_data_by_langue()
return i_str_pass



end function

public function string get_version ();return i_s_version
end function

public function string get_patch ();return i_s_patch
end function

public function boolean is_date_cde_valide (string as_date);/* Cette fonction va controler la validité de la date passée en paramètre.
    la date doit être compris entre 01/01/1900 et le 31/12/2999
 */
 Date ld_date_debut 
 Date ld_date_fin
 Date ld_date_cde
 date ld_calcul
 String ls_date
 Integer li_mois
String ls_mois
  
 if not  IsDate (as_date) then
	return false
 end if
 
 ld_date_cde = today()
 li_mois = Month(ld_date_cde)
 choose case li_mois
	case 1
		ld_calcul = relativeDate(ld_date_cde, -31)
		ls_mois = "31"
	case 2
		ld_calcul = relativeDate(ld_date_cde, -28)
		ls_mois = "28"
	case 3
		ld_calcul = relativeDate(ld_date_cde, -31)	
		ls_mois = "31"		
	case 4
		ld_calcul = relativeDate(ld_date_cde, -30)		
		ls_mois = "30"		
	case 5
		ld_calcul = relativeDate(ld_date_cde, -31)	
		ls_mois = "31"		
	case 6
		ld_calcul = relativeDate(ld_date_cde, -30)
		ls_mois = "30"		
	case 7
		ld_calcul = relativeDate(ld_date_cde, -31)
		ls_mois = "31"		
	case 8
		ld_calcul = relativeDate(ld_date_cde, -31)
		ls_mois = "31"		
	case 9
		ld_calcul = relativeDate(ld_date_cde, -30)	
		ls_mois = "30"		
	case 10
		ld_calcul = relativeDate(ld_date_cde, -31)
		ls_mois = "31"		
	case 11
		ld_calcul = relativeDate(ld_date_cde, -30)	
		ls_mois = "30"		
	case 12
		ld_calcul = relativeDate(ld_date_cde, -31)
		ls_mois = "31"		
 end choose
 
 ls_date = String(ld_calcul)
 ld_date_debut = date("01"+mid(ls_date,3,10))
 
 ls_date= String(today())
 ld_date_fin = date(ls_mois+mid(ls_date,3,10))
 
 if date (as_date ) > ld_date_fin or date (as_date ) < ld_date_debut  then
	return false
end if
 
 return true

end function

on nv_control_manager.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nv_control_manager.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;i_ds_donnee = CREATE nv_Datastore
end event

