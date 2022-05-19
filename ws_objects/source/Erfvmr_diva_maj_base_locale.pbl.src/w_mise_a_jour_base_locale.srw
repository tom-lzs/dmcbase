$PBExportHeader$w_mise_a_jour_base_locale.srw
$PBExportComments$Permet d'effectuer la mise à jour des données du portable à partir du serveur et ceci à partir de la litse des tables à mettre à jour.
forward
global type w_mise_a_jour_base_locale from w_a
end type
type erreurs_t from statictext within w_mise_a_jour_base_locale
end type
type pb_echap from u_pba_echap within w_mise_a_jour_base_locale
end type
type pb_ok from u_pba_ok within w_mise_a_jour_base_locale
end type
type dw_pipe_errors from datawindow within w_mise_a_jour_base_locale
end type
type dw_tables from datawindow within w_mise_a_jour_base_locale
end type
end forward

global type w_mise_a_jour_base_locale from w_a
string tag = "MAJ_PORTABLE"
integer width = 4133
integer height = 2224
string title = "Mise à jour du portable / Update data"
boolean minbox = false
boolean maxbox = false
boolean vscrollbar = true
boolean resizable = false
windowtype windowtype = response!
long backcolor = 12632256
boolean center = true
boolean ib_statusbar_visible = true
erreurs_t erreurs_t
pb_echap pb_echap
pb_ok pb_ok
dw_pipe_errors dw_pipe_errors
dw_tables dw_tables
end type
global w_mise_a_jour_base_locale w_mise_a_jour_base_locale

type variables
transaction i_tr_serveur

nv_pipeline_object i_pipeline
integer  i_nbr_rectangle 
nv_Datastore ids_table
long		 il_row_encours
Boolean	 ib_par_delta = false
Boolean  ib_pbselect = false
Boolean ib_where  = false

datetime id_date_deb
datetime id_date_fin
datetime id_date_max

String is_dbmessage



end variables

forward prototypes
public subroutine fw_complete_transaction (ref transaction as_tr, string as_section)
public function string fw_get_erreur_message (integer as_return)
public function boolean fw_maj_visiteur (boolean ab_log_mvt)
public function boolean fw_transfert_cpt_visite ()
public function boolean fw_visite_rc ()
end prototypes

public subroutine fw_complete_transaction (ref transaction as_tr, string as_section);/* <DESC>
     Prépare la connexion du sserveur en alimentant les données à partir
	  du fichier .ini de l'application.
   </DESC> */
as_tr.dbms 			=	g_nv_ini.fnv_Profile_String(as_section,"DBMS","")
as_tr.database 	=	g_nv_ini.fnv_Profile_String(as_section,"Database","")
as_tr.ServerName	=  g_nv_ini.fnv_Profile_String(as_section,"Servername","")
as_tr.DBParm         =  g_nv_ini.fnv_Profile_String(as_section,"DbParm","") + ";UID="+g_s_visiteur+";PWD="+g_s_visiteur+"'"


end subroutine

public function string fw_get_erreur_message (integer as_return);/* <DESC> 
     Permet de décodifier le code retour retourner par le pipeline pour
	  affichage dans la datawindow des erreurs.
   </DESC> */
String ls_message 

choose case as_return
	case -1
		ls_message = "Erreur ouverture Pipeline"
	case -2
		ls_message = "Trop de colonnes"
	case -3
		ls_message = "Table déJà existante"
	case -4
		ls_message = "Table inexistante"		
	case -5
		ls_message = "Manque connexion"				
	case -6
		ls_message = "Mauvais arguments"				
	case -7
		ls_message = "Type colonne incompatible"				
	case -8
		ls_message = "Error SQL dans la source"				
	case -9
		ls_message = "Error SQL destination"						
	case -10
		ls_message = "Error SQL source"						
	case -11
		ls_message = "Nbr maxi erreurs dépassées"						
	case -12
		ls_message = "Erreur table syntaxe"						
	case -13
		ls_message = "CLé demandée par alimenter"						
	case -15
		ls_message = "Pipeline déjà encours"						
	case -16
		ls_message = "Erreur Accès serveur distant"						
	case -17
		ls_message = "Erreur Accès serveur local"								
	case -18
		ls_message = "Base locale en lecture seulement"								
	case else
		ls_message = "??????"
end choose

return ls_message
end function

public function boolean fw_maj_visiteur (boolean ab_log_mvt);nv_Datastore ds_donnee_serveur
nv_Datastore ds_donnee_locale
nv_come9fdv_log lnv_come9fdv_log 

long ll_rowerror
decimal  ldec_numcde_port
decimal  ldec_numcde_serv
datetime ldat1
datetime ldat2

ds_donnee_serveur =  CREATE nv_Datastore
ds_donnee_locale  =  CREATE nv_Datastore

ds_donnee_serveur.dataobject = "d_maj_parametre_visiteur"
ds_donnee_locale.dataobject  = "d_maj_parametre_visiteur"

ds_donnee_serveur.setTransObject(i_tr_serveur)
ds_donnee_locale.setTransObject(i_tr_sql)

ds_donnee_serveur.retrieve(g_s_visiteur)

if ds_donnee_serveur.rowCount() = 0 then
	return true
end if

ds_donnee_locale.retrieve(g_s_visiteur)
ds_donnee_locale.setItem(1, DBNAME_TYPE_VISITEUR , ds_donnee_serveur.getItemString(1, DBNAME_TYPE_VISITEUR))
ds_donnee_locale.setItem(1, DBNAME_NOM_VISITEUR , ds_donnee_serveur.getItemString(1, DBNAME_NOM_VISITEUR))
ds_donnee_locale.setItem(1, DBNAME_MOT_PASSE , ds_donnee_serveur.getItemString(1, DBNAME_MOT_PASSE))
ds_donnee_locale.setItem(1, DBNAME_TYPE_CDE , ds_donnee_serveur.getItemString(1, DBNAME_TYPE_CDE))
//ds_donnee_locale.setItem(1, DBNAME_RAISON_CDE , ds_donnee_serveur.getItemString(1, DBNAME_RAISON_CDE))
ds_donnee_locale.setItem(1, DBNAME_ORIGINE_CDE , ds_donnee_serveur.getItemString(1, DBNAME_ORIGINE_CDE))
ds_donnee_locale.setItem(1, DBNAME_CODE_DEVISE , ds_donnee_serveur.getItemString(1, DBNAME_CODE_DEVISE))
ds_donnee_locale.setItem(1, DBNAME_LISTE_PRIX , ds_donnee_serveur.getItemString(1, DBNAME_LISTE_PRIX))
ds_donnee_locale.setItem(1, DBNAME_CODE_MARCHE , ds_donnee_serveur.getItemString(1, DBNAME_CODE_MARCHE))
ds_donnee_locale.setItem(1, DBNAME_PAYS , ds_donnee_serveur.getItemString(1, DBNAME_PAYS))
ds_donnee_locale.setItem(1, DBNAME_DATE_CREATION , sqlca.fnv_get_datetime () )
ds_donnee_locale.setItem(1, DBNAME_CODE_LANGUE ,ds_donnee_serveur.getItemString(1, DBNAME_CODE_LANGUE))
ds_donnee_locale.setItem(1, DBNAME_CODE_ADRESSE ,ds_donnee_serveur.getItemString(1, DBNAME_CODE_ADRESSE))
ds_donnee_locale.setItem(1, DBNAME_FLAG_SUBSTITUT ,ds_donnee_serveur.getItemString(1, DBNAME_FLAG_SUBSTITUT))

ldec_numcde_port  = ds_donnee_locale.getItemDecimal(1,DBNAME_COMPTEUR_COMMANDE) 
ldec_numcde_serv  = ds_donnee_serveur.getItemDecimal(1,DBNAME_COMPTEUR_COMMANDE)

ldat1 = ds_donnee_locale.getItemDateTime(1,DBNAME_DATE_MAJ_PROSPECT)
ldat2 =  ds_donnee_serveur.getItemDateTime(1,DBNAME_DATE_MAJ_PROSPECT)

// comparatif de la date de derniere incrementation du compteur des prospect entre le serveur et la base locale
if ds_donnee_locale.getItemDateTime(1,DBNAME_DATE_MAJ_PROSPECT) < ds_donnee_serveur.getItemDateTime(1,DBNAME_DATE_MAJ_PROSPECT) then
	ds_donnee_locale.setItem(1, DBNAME_COMPTEUR_PROSPECT , ds_donnee_serveur.getItemDecimal(1,DBNAME_COMPTEUR_PROSPECT)  )
	ds_donnee_locale.setItem(1, DBNAME_DATE_MAJ_PROSPECT , ds_donnee_serveur.getItemDateTime(1,DBNAME_DATE_MAJ_PROSPECT)  )
end if

if ds_donnee_locale.getItemDateTime(1, DBNAME_DATE_MAJ_NCDTER   ) < ds_donnee_serveur.getItemDateTime(1,DBNAME_DATE_MAJ_NCDTER) then
	ds_donnee_locale.setItem(1, DBNAME_COMPTEUR_COMMANDE , ds_donnee_serveur.getItemDecimal(1,DBNAME_COMPTEUR_COMMANDE)  )
	ds_donnee_locale.setItem(1, DBNAME_DATE_MAJ_NCDTER , ds_donnee_serveur.getItemDateTime(1,DBNAME_DATE_MAJ_NCDTER)  )
end if

if ds_donnee_locale.update() = -1 then
	ll_rowerror = dw_pipe_errors.insertRow(0)
	dw_pipe_errors.setItem(ll_rowerror,"Ligne_erreur", ds_donnee_locale.uf_getdberror( ))
	// Création d'un mouvement dans la table log du serveur
	lnv_come9fdv_log = create nv_come9fdv_log
	lnv_come9fdv_log.set_log_erreur_maj_portable( id_date_deb,i_tr_serveur,ds_donnee_locale.uf_getdberror( ))
	destroy nv_come9fdv_log
	return false
end if

if ab_log_mvt then
	ds_donnee_serveur.setItem(1, DBNAME_VERSION ,g_s_version+g_s_patch)
	ds_donnee_serveur.setItem(1, DBNAME_FORCE_MAJ ,"N")
     ds_donnee_serveur.update()
	lnv_come9fdv_log = create nv_come9fdv_log
	lnv_come9fdv_log.set_log_maj_portable( id_date_deb,i_tr_serveur,ldec_numcde_port, ldec_numcde_serv)
	destroy nv_come9fdv_log
end if

destroy g_nv_come9par
g_nv_come9par = create nv_come9par

return true
end function

public function boolean fw_transfert_cpt_visite ();String ls_sql
nv_Datastore ds_donnee_serveur
nv_Datastore ds_donnee_locale
nv_come9fdv_log lnv_come9fdv_log 


// suppresion des comptes rendu de visite sur le seveur du visiteur.
ls_sql =  "delete from come9cpt_rendu where codeevis = ' " + g_s_visiteur + "';"
EXECUTE immediate :ls_sql using i_tr_serveur;
if i_tr_serveur.sqldbcode <> 0 then
   is_dbmessage = i_tr_serveur.sqlerrtext 
   	messageBox(this.title, is_dbmessage, Stopsign!, ok!)
	return false
end if

ds_donnee_serveur =  CREATE nv_Datastore
ds_donnee_locale  =  CREATE nv_Datastore
//
ds_donnee_serveur.dataobject = "d_transfert_cpt_visite"
ds_donnee_locale.dataobject  = "d_transfert_cpt_visite"
//
ds_donnee_serveur.setTransObject(i_tr_serveur)
ds_donnee_locale.setTransObject(i_tr_sql)
//
ds_donnee_serveur.retrieve(g_s_visiteur)
ds_donnee_serveur.RowsMove(1, ds_donnee_serveur.rowcount(), primary!, ds_donnee_serveur, 1,delete!)
if ds_donnee_serveur.update() = -1 then
     is_dbmessage = ds_donnee_serveur.uf_getdberror( )
   	messageBox(this.title, is_dbmessage, Stopsign!, ok!)
	return false
end if

// extraction de la base locale
ds_donnee_locale.retrieve(g_s_visiteur)
if ds_donnee_locale.rowCount() = 0 then
	return true
end if

ds_donnee_serveur.retrieve(g_s_visiteur)
ds_donnee_locale.RowsCopy(1, ds_donnee_locale.rowcount(), primary!, ds_donnee_serveur, 1,primary!)
if ds_donnee_serveur.update() = -1 then
     is_dbmessage = ds_donnee_serveur.uf_getdberror( )
   	messageBox(this.title, is_dbmessage, Stopsign!, ok!)
	return false
end if

return true
end function

public function boolean fw_visite_rc ();String ls_sql
nv_Datastore ds_donnee_serveur
nv_Datastore ds_donnee_locale
nv_come9fdv_log lnv_come9fdv_log 


// suppresion des comptes rendu de visite sur le seveur du visiteur.
ls_sql =  "delete from come9cpt_rendu ;"
EXECUTE immediate :ls_sql using i_tr_sql;
if i_tr_sql.sqldbcode <> 0 then
   is_dbmessage = i_tr_sql.sqlerrtext 
   	messageBox(this.title, is_dbmessage, Stopsign!, ok!)
	return false
end if

ds_donnee_serveur =  CREATE nv_Datastore
ds_donnee_locale  =  CREATE nv_Datastore
//
ds_donnee_serveur.dataobject = "d_copy_cpt_visite_pour_rc"
ds_donnee_locale.dataobject  = "d_copy_cpt_visite_pour_rc"
//
ds_donnee_serveur.setTransObject(i_tr_serveur)
ds_donnee_locale.setTransObject(i_tr_sql)
//
ds_donnee_locale.retrieve()

// extraction de la base locale
ds_donnee_serveur.retrieve()
if ds_donnee_serveur.rowCount() = 0 then
	return true
end if

ds_donnee_serveur.RowsCopy(1, ds_donnee_serveur.rowcount(), primary!, ds_donnee_locale, 1,primary!)
if ds_donnee_locale.update() = -1 then
     is_dbmessage = ds_donnee_locale.uf_getdberror( )
   	messageBox(this.title, is_dbmessage, Stopsign!, ok!)
	return false
end if

return true
end function

on w_mise_a_jour_base_locale.create
int iCurrent
call super::create
this.erreurs_t=create erreurs_t
this.pb_echap=create pb_echap
this.pb_ok=create pb_ok
this.dw_pipe_errors=create dw_pipe_errors
this.dw_tables=create dw_tables
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.erreurs_t
this.Control[iCurrent+2]=this.pb_echap
this.Control[iCurrent+3]=this.pb_ok
this.Control[iCurrent+4]=this.dw_pipe_errors
this.Control[iCurrent+5]=this.dw_tables
end on

on w_mise_a_jour_base_locale.destroy
call super::destroy
destroy(this.erreurs_t)
destroy(this.pb_echap)
destroy(this.pb_ok)
destroy(this.dw_pipe_errors)
destroy(this.dw_tables)
end on

event ue_ok;call super::ue_ok;/* <DESC> 
    Permet de lancer la mise à jour pour chaque table listée. 
	 
   Pour chaque table :
	- Initialisation de l'objet Pipeline : le nom du pipeline a utilisé en celui correspondant
	au nom de la table lue. Si la mise à jour doit être effectuée par marché, le nom sera celui
	au nom de la table + "_marche" . Appel de la fonction qui va modifier la clause SQL du piepeline en fonction des
	 paramétres de mise à jour de la table sélectionnée
	 - Déclenchement de la mise à jour de la table et du timer pour permettre l'affichage de la barre de défilement sur la
	 la ligne en cours de traitement. En fin de mise à jour s'il s'agit d'une mise à jour par Delta (en fonction de la
	 date de mise à jour), suppression de toutes les lignes de table qui sont supprimées
	 - Mise à jour des éléments statistiques sur la ligne traitée
   En  fin de mise à jour du portable, mise à jour des données par défaut du visiteur à partir des données du serveur, ainsi
   que des compteurs commande et prospect si ceux du serveur sont plus grands que ceux du portable.
   Recherche ans le fichier .ini si une commande doit être executée.
   </DESC> 	 */
integer li_return
long ll_long
//String ls_sql, ls_nouveau_sql
integer li_pos
String  ls_nom_pipeline
String  ls_table
Long ll_rowerror
boolean	lb_erreur
string ls_sql
string ls_sql_insert

pb_ok.enabled = false
pb_echap.enabled = false
lb_erreur = true
setPointer(HourGlass!)

id_date_deb = SQLCA.fnv_get_datetime( )

for ll_long = 1 to dw_tables.rowCount()
	if dw_tables.getitemString(ll_long,"flag_maj_en_batch") = "N" then
		continue
	end if
		
	i_nbr_rectangle = 0	
	il_row_encours  = ll_long
	ls_nom_pipeline = dw_tables.getItemString(ll_long, DBNAME_CODE_TABLE)
	ls_table	= ls_nom_pipeline
	if upper(ids_table.getItemString(ll_long, DBNAME_EXTRACTION_MARCHE)) = "O" then
		ls_nom_pipeline = ls_nom_pipeline + "_marche"
	end if	
	
	i_pipeline.uf_init_dataobject ( ls_nom_pipeline	)
	
	dw_tables.setItem(ll_long, "pipeline_object", ls_nom_pipeline)
	dw_tables.setItem(ll_long, "statut",	  "Encours")

     if upper(ids_table.getItemString(ll_long, DBNAME_EXTRACTION_DATE)) = "O" and  &
	   not g_nv_come9par.is_maj_complete()  then
		dw_tables.setItem(ll_long, "statut", "Recherche date MAJ"	)
		dw_tables.setRow(ll_long)
	end if
	
	dw_tables.scrolltoRow(ll_long)
	dw_tables.setRow(ll_long)	
	
	// Complete la syntaxe du pipeline en fonction du type de mise à jour à effecuer
	if ls_table <> "COME9PRM" and  ls_table <> "COME9_CLIENT_BLOCAGE" and  ls_table <> "COME9PAR_LISTE" then
 		i_pipeline.uf_complete_syntaxe( ib_par_delta,ids_table, ll_long,ls_table)
		 	if ls_table = "COME9_CLIENT_BLOCAGE" then
				 messagebox ('come9_client_blocage', i_pipeline.syntax  ,information!)
			 end if
	end if
	
	// Déclenchement du traitement de mise à jour
	Timer(1)	
	i_nbr_rectangle = 0	
	dw_tables.setItem(ll_long, "heure_debut",String(now()))
	
	if ls_table = "COME9PRM" then
		li_return = 0
		li_return 				 = i_pipeline.Start(i_tr_serveur, i_tr_sql,dw_pipe_errors,g_nv_come9par.get_code_langue())
	elseif ls_table = 'COME9PAR_LISTE' then
			ls_sql ="delete from force_vente.come9par where codeevis <> '" + g_s_visiteur  + "';"
			EXECUTE immediate :ls_sql using i_tr_sql;
		li_return 				 = i_pipeline.Start(i_tr_serveur, i_tr_sql,dw_pipe_errors,g_s_visiteur)
	else
		li_return 				 = i_pipeline.Start(i_tr_serveur, i_tr_sql,dw_pipe_errors)
	end if

	dw_tables.setItem(ll_long, "ligne_lue",		String(i_pipeline.RowsRead))
	dw_tables.setItem(ll_long, "ligne_ecrite",	     String(i_pipeline.RowsWritten))	
	dw_tables.setItem(ll_long, "ligne_erreur",	String(i_pipeline.RowsInerror))		
	dw_tables.setItem(ll_long, "heure_fin",		String(now()))	
	
	Timer(0)
	
	// Gestion des erreurs
	dw_tables.setItem(dw_tables.getRow(),"indicateur", 0)
	if li_return <> 1 then
		dw_tables.setItem(ll_long, "statut", fw_get_erreur_message(li_return)	)
		lb_erreur = false
		// Création d'un mouvement dans la table log du serveur
		nv_come9fdv_log lnv_come9fdv_log 
	     lnv_come9fdv_log = create nv_come9fdv_log
	     lnv_come9fdv_log.set_log_erreur_maj_portable( id_date_deb,i_tr_serveur,fw_get_erreur_message(li_return))
	     destroy nv_come9fdv_log
		goto FIN
	end if

	// dans le case de mise à jour par delta, suppression des
	// lignes annulées ramenées sur le portable
	if ib_par_delta  then
		dw_tables.setItem(ll_long, "statut",  "Suppression annulations.")
		dw_tables.setRow(ll_long)		
		is_dbmessage = ""
		if not i_pipeline.uf_maj_delta(is_dbmessage) then
			MessageBox(This.Title,is_dbmessage, information!,ok!)
			goto FIN
		end if
	end if		
	dw_tables.setItem(ll_long, "statut", "Terminer"	)
next

// mise à jour de la table client_blocage pour inclure tous les clients n'ayant
// pas de blocage pour avoir une jointure normale
ls_sql_insert ="insert into come9_client_blocage select current_date,'C',numaeclf , ''  from come9040 where numaeclf not in( SELECT numaeclf FROM come9_client_blocage);"
EXECUTE immediate :ls_sql_insert using i_tr_sql;


// Mise à jour des paramètres du visiteur
Long ll_row
ll_row = dw_tables.insertRow(0)
dw_tables.scrolltoRow(ll_long)
dw_tables.setRow(ll_long)	
dw_tables.setItem(ll_row, DBNAME_CODE_TABLE, "COME9PAR")
dw_tables.setItem(ll_row, DBNAME_INTITULE_TABLE, "Infos Visiteur")
dw_tables.setItem(ll_row, "statut", "Encours")
dw_tables.setItem(ll_row, "heure_debut",String(now()))
id_date_fin = SQLCA.fnv_get_datetime( )

if not fw_maj_visiteur(true) then
	dw_tables.setItem(ll_row, "ligne_erreur", String(1))	
	dw_tables.setItem(ll_row, "heure_fin",String(now()))	
	MessageBox(This.Title, g_nv_traduction.get_traduction ("TRANSFERT_CDE_ERREUR"), information!,ok!)
	goto FIN
end if

dw_tables.setItem(ll_row, "ligne_ecrite", String(1))
dw_tables.setItem(ll_row, "ligne_erreur", String(0))
dw_tables.setItem(ll_row, "statut", "Terminer")
dw_tables.setItem(ll_row, "heure_fin",String(now()))

// Transfert compte rendu de visite
ll_row = dw_tables.insertRow(0)
dw_tables.scrolltoRow(ll_long)
dw_tables.setRow(ll_long)	
dw_tables.setItem(ll_row, DBNAME_CODE_TABLE, "COME9CPT_RENDU")
dw_tables.setItem(ll_row, DBNAME_INTITULE_TABLE, "Compte rendu visite")
dw_tables.setItem(ll_row, "statut", "Encours")
dw_tables.setItem(ll_row, "heure_debut",String(now()))
id_date_fin = SQLCA.fnv_get_datetime( )

IF not  g_nv_come9par.is_relation_clientele( ) THEN
    if not fw_transfert_cpt_visite() then
	      dw_tables.setItem(ll_row, "ligne_erreur", String(1))	
	      dw_tables.setItem(ll_row, "heure_fin",String(now()))	
	      MessageBox(This.Title, g_nv_traduction.get_traduction ("TRANSFERT_CDE_ERREUR"), information!,ok!)
	      goto FIN
     end if
else
	if not fw_visite_rc() then
     	dw_tables.setItem(ll_row, "ligne_erreur", String(1))	
	    dw_tables.setItem(ll_row, "heure_fin",String(now()))	
	    MessageBox(This.Title, g_nv_traduction.get_traduction ("TRANSFERT_CDE_ERREUR"), information!,ok!)
	    goto FIN
   end if
end if

dw_tables.setItem(ll_row, "ligne_ecrite", String(1))
dw_tables.setItem(ll_row, "ligne_erreur", String(0))
dw_tables.setItem(ll_row, "statut", "Terminer")
dw_tables.setItem(ll_row, "heure_fin",String(now()))

// copie cpt rendu visite sur les portables des RC

/* Recherche is une commande est à lancer */
nv_param_informatique lnv_param
lnv_param = create nv_param_informatique
lnv_param.fu_apres_maj_portable( )
destroy lnv_param

FIN:
 disconnect using i_tr_serveur;

 setPointer(Arrow!) 
 pb_echap.enabled = true
 
 g_nv_traduction.set_init_data( )
 if g_nv_traduction.is_traduction_chargee( ) then
	if lb_erreur  then
	 	MessageBox(This.Title,  g_nv_traduction.get_traduction ("MISE_A_JOUR_TERMINE"), information!,ok!)
	else
		MessageBox(This.Title, g_nv_traduction.get_traduction ("MISE_A_JOUR_ERREUR"), Stopsign!,ok!)
	end if
else
	MessageBox(This.Title,"Update Successful", information!,ok!)
end if
 i_str_pass.s_action = ACTION_OK
Message.fnv_set_str_pass(i_str_pass)

g_w_frame.fw_init_fenetre( )
//close(this)
end event

event ue_init;call super::ue_init;/* <DESC>
     Permet l'initialisation de la fenêtre et d'afficher la liste des tables à mettre à jour
	- Recherche des paramètres de connexion du serveur 
	et après controle,
	- Controle si le PC est connecté et la base accessible
     - Récupération de la table du serveur contenant la liste des tables à importer
	- Récupération des infos du visiteur de la table du serveur dans une table temporaire
	- Réactualiation des infos du visiteur.
	- Récupération de la table parametres informatique qui contient la version a installer
	- Récupération de la table lien visiteur manager si le profil du visteur est manager

	   - Controle que la version de l'executable avec la version à installer.
		    Si les version sont différentes cela signifie, qu'il faut installer la nouvelle version.
			dans ce cas affichage d'un message d'alerte, ouverture de la page d'instllation et fermeture
			de l'application.
			
	-  Affichage de la liste des tables mises à jour
   </DESC> */
String s_dbms, s_database,s_logid,s_log_pass,s_dbparm,s_serveur
integer  li_return
nv_param_informatique lnv_param
String ls_version
String ls_version_precedente
String ls_message
nv_control_manager  lnv_controle

i_tr_serveur = CREATE transaction
 lnv_controle = CREATE nv_control_manager 
// Initialisation et connection au serveur central
String ls_section_ori
ls_section_ori = g_nv_ini.fnv_Profile_String("DefaultDBMS","DBMS_remote","")

// Initialisation et connection a la base locale
fw_complete_transaction(i_tr_serveur, ls_section_ori)

if UPPER(Mid(i_tr_sql.dbms,1,4)) <> "ODBC" then
	messageBox(this.title, g_nv_traduction.get_traduction ("PARAM_DBMS_ERREUR"), Stopsign!, ok!)
	return
end if

if i_tr_serveur.dbms = i_tr_sql.dbms then
	messageBox(this.title, g_nv_traduction.get_traduction ("PARAM_DBMS_ERREUR"), Stopsign!, ok!)
	return
end if

if i_tr_serveur.database = i_tr_sql.database and &
	i_tr_serveur.ServerName = i_tr_sql.ServerName then
	messageBox(this.title, g_nv_traduction.get_traduction ("PARAM_DBMS_ERREUR"), Stopsign!, ok!)
	return
end if	
setPointer(HourGlass!)

if not lnv_controle.is_portable_connecte(i_tr_serveur,ls_message) then
	messageBox(this.title, ls_message, Stopsign!, ok!)
	pb_echap.enabled = true
	setPointer(Arrow!)
	return
end if

// Récupération des paramètres du serveur du visiteur
i_pipeline = CREATE nv_pipeline_object
i_pipeline.dataobject = "come9par_temp"
li_return 				 = i_pipeline.Start(i_tr_serveur, i_tr_sql,dw_pipe_errors,g_s_visiteur  )
if li_return <> 1 then
	messageBox(this.title, g_nv_traduction.get_traduction ("ERREUR_RECHERCHE") + " come9par_temp  : return code = " + String(li_return) , Stopsign!, ok!)
	return
end if

g_nv_come9par.update_param()

// Récupération de la table lien manager visiteur si le profil du visiteur est manager
if g_nv_come9par.is_manager() then
	i_pipeline = CREATE nv_pipeline_object
	i_pipeline.dataobject = "come_manager_visiteur"
	li_return 				 = i_pipeline.Start(i_tr_serveur, i_tr_sql,dw_pipe_errors,g_s_visiteur  )
	if li_return <> 1 then
		messageBox(this.title, g_nv_traduction.get_traduction ("ERREUR_RECHERCHE") + " come_lien_ manager_visiteur  : return code = " + String(li_return) , Stopsign!, ok!)
	     return
      end if
end if

// Récupération de la table du serveur contenant la liste des tables à importer
i_pipeline = CREATE nv_pipeline_object
i_pipeline.dataobject = "come9trf_regles_v3"
li_return 				 = i_pipeline.Start(i_tr_serveur, i_tr_sql,dw_pipe_errors)
if li_return <> 1 then
	messageBox(this.title, g_nv_traduction.get_traduction ("ERREUR_RECHERCHE") + " come9trf_regles_v3  : return code = " + String(li_return) , Stopsign!, ok!)
	return
end if

// Récupération de la table du serveur contenant les paramètres informatiques
i_pipeline = CREATE nv_pipeline_object
i_pipeline.dataobject = "come9_parametre_info"
li_return 				 = i_pipeline.Start(i_tr_serveur, i_tr_sql,dw_pipe_errors)
if li_return <> 1 then
	messageBox(this.title, g_nv_traduction.get_traduction ("ERREUR_RECHERCHE") + " come9_parametre_info  : return code = " + String(li_return) , Stopsign!, ok!)
	return
end if

// Traitement de controle des versions
if not lnv_controle.is_version_valide() then
	i_str_pass.s_action = ACTION_CANCEL
	TriggerEvent("ue_cancel")
     g_w_frame.PostEvent ("ue_close")
     return
end if

// retrieve de la liste des tables stockée sur le portable
ids_table = CREATE nv_Datastore
ids_table.dataobject = "d_extract_regle_maj_portable"
ids_table.setTransObject(i_tr_sql)

choose case g_nv_come9par.get_type_visiteur( ) 
	case CODE_RELATION_CLIENTELE
		ids_table.retrieve('%','O%','%',g_nv_come9par.get_type_visiteur( ) ,'%')
	case CODE_VENDEUR
		ids_table.retrieve('O%','%','%',g_nv_come9par.get_type_visiteur( ),'%')
	case CODE_MANAGER
		ids_table.retrieve('%','%','%',g_nv_come9par.get_type_visiteur( ),'O%')
	case CODE_FILIALE	
		ids_table.retrieve('%','%','O%',g_nv_come9par.get_type_visiteur( ),'%')
	case CODE_VENDEUR_MULTI_CARTE
		ids_table.retrieve('O%','%','%',g_nv_come9par.get_type_visiteur( ),'%')
		
end choose
dw_tables.setTransObject(i_tr_sql)

long ll_row
integer li_not_update = 0

for ll_row = 1 to ids_table.rowcount()
	dw_tables.insertRow(ll_row)
	dw_tables.setItem(ll_row, 1,ids_table.getItemString(ll_row,1))
	dw_tables.setItem(ll_row, 2,ids_table.getItemString(ll_row,2))
	dw_tables.setItem(ll_row,"flag_maj_en_batch",ids_table.getItemString(ll_row,"flag_maj_en_batch"))
	dw_tables.setItem(ll_row, 3,"En attente")
	if   upper(ids_table.getItemString(ll_row,"flag_maj_en_batch")) = 'N' then
		dw_tables.setItem(ll_row, 3,"Could Not Updated")
		li_not_update  ++
	end if
next


setPointer(Arrow!)
pb_ok.enabled = true
pb_echap.enabled = true
pb_ok.setfocus()
i_str_pass.s_action =  ""
end event

event timer;call super::timer;/* <DESC> 
     PErmet d'afficher la ligne de défilement sur la ligne correspondante
	  au pipeline en cours d'exécution.
   </DESC> */
dw_tables.setItem(dw_tables.getRow(), "statut", BLANK	)
if i_nbr_rectangle =  4 then
	i_nbr_rectangle = 0
end if
i_nbr_rectangle ++
dw_tables.setItem(dw_tables.getRow(),"indicateur", i_nbr_rectangle)
end event

event ue_cancel;call super::ue_cancel;/* <DESC> 
     Permet de fermer la fenetre après avoir effectuer la deconnexion du serveur
   </DESC> */
disconnect using i_tr_serveur;
if i_str_pass.s_action = "" then
	i_str_pass.s_action = ACTION_CANCEL
end if
Message.fnv_set_str_pass(i_str_pass)
close(this)
end event

event close;call super::close;/* <DESC> 
     Permet de fermer la fenetre après avoir effectuer la deconnexion du serveur
   </DESC> */
disconnect using i_tr_serveur;



end event

event ue_print;call super::ue_print;/* <DESC>
    Permet d'imprimer la liste des tables mises à jour par cette option.
   </DESC> */
dw_tables.print()
end event

event key;call super::key;/* <DESC>
      Permet de trapper les touches de fonction activées et déclencher l'évènement associé
	à la touche.
	  F11 = Fin de validation de la saisie
   </DESC> */
	IF KeyDown (KeyF11!)  THEN
		This.PostEvent ("ue_ok")
	END IF
end event

type uo_statusbar from w_a`uo_statusbar within w_mise_a_jour_base_locale
end type

type erreurs_t from statictext within w_mise_a_jour_base_locale
integer x = 187
integer y = 1280
integer width = 777
integer height = 100
integer textsize = -14
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Les Erreurs / Errors"
boolean border = true
boolean focusrectangle = false
end type

type pb_echap from u_pba_echap within w_mise_a_jour_base_locale
integer x = 1719
integer y = 1160
integer taborder = 30
boolean enabled = false
string picturename = "C:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type pb_ok from u_pba_ok within w_mise_a_jour_base_locale
integer x = 1234
integer y = 1156
integer taborder = 20
boolean enabled = false
string picturename = "C:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type dw_pipe_errors from datawindow within w_mise_a_jour_base_locale
integer x = 160
integer y = 1384
integer width = 3534
integer height = 704
integer taborder = 20
string title = "                                                 Les Erreurs"
string dataobject = "d_erreur_transfert"
boolean hscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_tables from datawindow within w_mise_a_jour_base_locale
integer x = 110
integer y = 36
integer width = 3858
integer height = 1092
integer taborder = 10
string title = "none"
string dataobject = "d_suivi"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

