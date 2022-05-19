$PBExportHeader$w_transfert_des_commandes.srw
$PBExportComments$Permet d'effectuer le transfert des commandes du portable vers le serveur et de lancer l'intégration de ces commandes.
forward
global type w_transfert_des_commandes from w_a
end type
type erreurs_t from statictext within w_transfert_des_commandes
end type
type pb_echap from u_pba_echap within w_transfert_des_commandes
end type
type pb_ok from u_pba_ok within w_transfert_des_commandes
end type
type dw_pipe_errors from datawindow within w_transfert_des_commandes
end type
type dw_tables from datawindow within w_transfert_des_commandes
end type
end forward

global type w_transfert_des_commandes from w_a
string tag = "TRANSFERT_CDE"
integer x = 769
integer y = 461
integer width = 5394
integer height = 3292
string title = "Envoi des commandes en central"
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
global w_transfert_des_commandes w_transfert_des_commandes

type variables
transaction i_tr_serveur
integer i_nbr_rectangle
nv_pipeline_object i_pipeline
Boolean	 ib_par_delta = false
Boolean  ib_pbselect = false
Boolean ib_where  = false

integer i_nbr_lue
integer i_nbr_ecrite
integer i_nbr_erreur
String is_dbmessage
Boolean ib_timer_transfert
nv_come9fdv_log   inv_come9fdv_log 
String is_date_creation
nv_param_informatique  inv_parametre

end variables

forward prototypes
public function boolean fw_suppression_mvts_client ()
public function boolean fw_transfert_donnees (string as_table)
public function boolean fw_suppression_cdes_integrees ()
public function boolean fw_donnees_visiteur ()
public function boolean fw_recuperation_cdes_validees ()
public function boolean fw_suppression_temporaire ()
public function boolean fw_suppression_donnees (string as_datawindow, ref long al_nbr_row, boolean ab_avec_visiteur, transaction a_tr_sql)
public subroutine fw_log_erreur (string as_message)
public subroutine fw_save_bon_cde ()
public function boolean fw_lancement_integration ()
public subroutine fw_transfert_manuel ()
public subroutine fw_export_csv (datastore ad_datastore, string as_table)
public subroutine fw_log_cde_nontransferee ()
end prototypes

public function boolean fw_suppression_mvts_client ();/* <DESC>
     Suppression des mouvements de modification des infos client de la base local
	<LI> Extraction des mouvements à partir de la datastore puis copy de toutes les lignes
	du buffer primaire dans le buffer contenant les lignes supprimées, puis lancer la
	mise à jour
   </DESC> */
nv_datastore ds_locale
string ls_fichier
ds_locale = CREATE nv_datastore
ds_locale.dataobject = "d_extraction_mvts_client"
ds_locale.settrans( i_tr_sql)
ds_locale.retrieve(g_s_visiteur)
string ls_objet
string ls_commande
i_nbr_lue = ds_locale.rowCount()
i_nbr_ecrite = 0

if ds_locale.rowCount() > 0 then
    ls_fichier = inv_parametre.fu_check_directory("Transfert", is_date_creation) + "\" + "come9049.csv"
   ds_locale.SaveAs(ls_fichier,CSV!,true)
	ls_objet =    g_s_visiteur+"-fichier-modif-fiche-client "
	ls_commande = "cmd /c c:\appscir\EnvoiFdvMail.bat "+ ls_objet + "  '" + ls_fichier+ "'"
	run ( ls_commande) 
end if

/* ds_locale.RowsMove(1, ds_locale.rowcount(), primary!, ds_locale, 1,Delete!)
if ds_locale.update() = -1 then
     is_dbmessage = ds_locale.uf_getdberror( )
	i_nbr_erreur = i_nbr_lue
	return false
end if  */
i_nbr_ecrite = i_nbr_lue
return true

end function

public function boolean fw_transfert_donnees (string as_table);/* <DESC>
    Transfert des données commandes vers le serveur en effectuant une copie des lignes extraites de la base
	 locale.
  </DESC> */
nv_datastore ds_locale
nv_datastore ds_serveur
String s_datawindow_serveur
String s_datawindow_locale
boolean b_avec_param = false 
String   s_param		
String ls_fichier

ds_locale = CREATE nv_datastore
ds_serveur = CREATE nv_datastore

Choose case as_table
	case "come9pat"
		ds_locale.dataobject = "d_extraction_entete_cde"
		ds_serveur.dataobject  = "d_come9pat"
	case "come9pbt"
		ds_locale.dataobject = "d_extraction_message_cde"
		ds_serveur.dataobject  = "d_come9pbt"
	case "come9pct"
		ds_locale.dataobject = "d_extraction_ligne_cde"
		ds_serveur.dataobject  = "d_come9pct"
	case "come986t"
		ds_locale.dataobject = "d_extraction_come9086"
		ds_serveur.dataobject  = "d_come986t"
	case "come987t"
		ds_locale.dataobject = "d_extraction_come9087"
		ds_serveur.dataobject  = "d_come987t"
	case "come988t"
		ds_locale.dataobject = "d_extraction_come9088"
		ds_serveur.dataobject  = "d_come988t"
	case "come989t"
		ds_locale.dataobject = "d_extraction_come9089"
		ds_serveur.dataobject  = "d_come989t"
	case "come990t"
		ds_locale.dataobject = "d_extraction_come9090"
		ds_serveur.dataobject  = "d_come990t"
	case "come991t"
		ds_locale.dataobject = "d_extraction_come9091"
		ds_serveur.dataobject  = "d_come991t"
    case "come940t"
		ds_locale.dataobject = "d_extraction_client_prospect"
		ds_serveur.dataobject  = "d_come940t"		
		b_avec_param = true
		s_param = g_s_visiteur
    case "come949t"
		ds_locale.dataobject = "d_extraction_mvts_client"
		ds_serveur.dataobject  = "d_come949t"	
		b_avec_param = true
		s_param = g_s_visiteur
	case "come999t"
		ds_locale.dataobject = "d_extraction_entete_cde"
		ds_serveur.dataobject  = "d_come999t"
end choose

ds_locale.settrans( i_tr_sql)
ds_serveur.settrans(i_tr_serveur)
if b_avec_param then					
	ds_locale.retrieve(s_param)
else
	ds_locale.retrieve()
end if

i_nbr_lue = ds_locale.rowCount()

ds_locale.RowsCopy(1, ds_locale.rowcount(), primary!, ds_serveur, 1,Primary!)
if ds_serveur.update() = -1 then
	is_dbmessage = ds_serveur.uf_getdberror( )
	i_nbr_ecrite = 0
	i_nbr_erreur = i_nbr_lue
	return false
end if

if ds_locale.rowcount() > 0 then
	ls_fichier = inv_parametre.fu_check_directory("Transfert", is_date_creation) + "\" + as_table  + ".csv"
	ds_locale.SaveAs(ls_fichier,CSV!,true)
end if

i_nbr_ecrite= i_nbr_lue
i_nbr_erreur = 0
return true
end function

public function boolean fw_suppression_cdes_integrees ();/* <DESC>
    Fonction de suppression des commandes ayant été transférées lors du précédent transfert et
	 ceci avant de transférer les nouvelles commandes
    <LI> Pour chaque contenant des donnees commande, appel du module de suppression des donnees
	 en passant la datawindow qui contiendra les lignes a supprimer.
   </DESC> */
Long  ll_nbr_lignes
ll_nbr_lignes = 0

if not  fw_suppression_donnees( "d_extraction_message_cde", ll_nbr_lignes,false,i_tr_sql) then
	return false
end if

if not fw_suppression_donnees( "d_extraction_ligne_cde_pour_suppress", ll_nbr_lignes,true,i_tr_sql) then
	return false
end if

if not fw_suppression_donnees( "d_extraction_come9086", ll_nbr_lignes,false,i_tr_sql) then
	return false
end if

if not fw_suppression_donnees( "d_extraction_come9087", ll_nbr_lignes,false,i_tr_sql) then
	return false
end if

if not fw_suppression_donnees( "d_extraction_come9088", ll_nbr_lignes,false,i_tr_sql) then
	return false
end if

if not fw_suppression_donnees( "d_extraction_come9089", ll_nbr_lignes,false,i_tr_sql) then
	return false
end if

if not fw_suppression_donnees( "d_extraction_come9090", ll_nbr_lignes,false,i_tr_sql) then
	return false
end if

if not fw_suppression_donnees( "d_extraction_come9091", ll_nbr_lignes,false,i_tr_sql) then
	return false
end if

if  fw_suppression_donnees("d_extraction_entete_cde", ll_nbr_lignes,false,i_tr_sql) then
	i_nbr_ecrite = ll_nbr_lignes
	i_nbr_erreur = 0
else
	return false
end if

if not fw_suppression_donnees( "d_come9cdt", ll_nbr_lignes,false,i_tr_sql) then
	return false
end if

return true
end function

public function boolean fw_donnees_visiteur ();/* <DESC>
     Mise à jour des paramètres visiteur sur le serveur.
	 Les données mise à jour sont :
	 	le dernier n° de commande . 
		  Si le compteur contenant le n° de commande du portable est le plus récent, on reporte ce compteur sur le serveur
		le dernier n° de client prospect mais uniquement si sur le serveur le dernier numero est plus petit que sur la base locale.
   </DESC> */ 
	
nv_datastore ds_donnee_visiteur_serveur
nv_datastore ds_donnee_visiteur_local
boolean lb_maj_a_effectuer
boolean lb_retour

lb_maj_a_effectuer = false
ds_donnee_visiteur_serveur  = CREATE nv_Datastore
ds_donnee_visiteur_local  = CREATE nv_Datastore

ds_donnee_visiteur_serveur.dataobject  = "d_maj_parametre_visiteur"
ds_donnee_visiteur_local.dataobject  = "d_maj_parametre_visiteur"

ds_donnee_visiteur_serveur.setTransObject(i_tr_serveur)
ds_donnee_visiteur_local.setTransObject(i_tr_sql)

ds_donnee_visiteur_serveur.retrieve(g_s_visiteur)
ds_donnee_visiteur_local.retrieve(g_s_visiteur)

i_nbr_lue = 1

// comparatif de la date de derniere incrementation du compteur des prospect entre le serveur et la base locale
if ds_donnee_visiteur_local.getItemDateTime(1,DBNAME_DATE_MAJ_PROSPECT) > ds_donnee_visiteur_serveur.getItemDateTime(1,DBNAME_DATE_MAJ_PROSPECT) then
	ds_donnee_visiteur_serveur.setItem(1, DBNAME_COMPTEUR_PROSPECT , ds_donnee_visiteur_local.getItemDecimal(1,DBNAME_COMPTEUR_PROSPECT)  )
	ds_donnee_visiteur_serveur.setItem(1, DBNAME_DATE_MAJ_PROSPECT , ds_donnee_visiteur_local.getItemDateTime(1,DBNAME_DATE_MAJ_PROSPECT)  )
	lb_maj_a_effectuer = true
end if

if ds_donnee_visiteur_local.getItemDateTime(1, DBNAME_DATE_MAJ_NCDTER   ) > ds_donnee_visiteur_serveur.getItemDateTime(1,DBNAME_DATE_MAJ_NCDTER) then
	ds_donnee_visiteur_serveur.setItem(1, DBNAME_COMPTEUR_COMMANDE , ds_donnee_visiteur_local.getItemDecimal(1,DBNAME_COMPTEUR_COMMANDE)  )
	ds_donnee_visiteur_serveur.setItem(1, DBNAME_DATE_MAJ_NCDTER , ds_donnee_visiteur_local.getItemDateTime(1,DBNAME_DATE_MAJ_NCDTER)  )
	lb_maj_a_effectuer = true
end if

i_nbr_ecrite = 0
i_nbr_erreur = 0

if 	lb_maj_a_effectuer  then
	i_nbr_ecrite = 1
	i_nbr_erreur = 0
	if ds_donnee_visiteur_serveur.update() = -1 then
		is_dbmessage = ds_donnee_visiteur_serveur.uf_getdberror( )
		i_nbr_ecrite = 0
		i_nbr_erreur = 1
		lb_retour =  false
	else
		lb_retour =  true
	end if
else
	lb_retour =  true
end if

return lb_retour
end function

public function boolean fw_recuperation_cdes_validees ();/* <DESC>
   Recuperation des commandes validées sur  le serveur et creation des données dans la table des 
   commandes transférées ainsi que les commandes transférées du portable inexistante dans la 
	table des transferts - come9cdt
  </DESC> */
nv_datastore ds_locale
nv_datastore ds_serveur
nv_datastore ds_locale_transferees

ds_locale = CREATE nv_datastore
ds_serveur = CREATE nv_datastore
ds_locale_transferees = CREATE nv_datastore

ds_locale.dataobject = "d_come9cdt"
ds_serveur.dataobject  = "d_extraction_come90pa_validee"
ds_locale_transferees.dataobject = "d_extraction_come90pa_transferee"

ds_locale.settrans( i_tr_sql)
ds_serveur.settrans(i_tr_serveur)
ds_locale_transferees.settrans( i_tr_sql)

// Traitement des commandes validées du serveur 
//	Copies de ces commandes dans la table come9cdt du portable
if ds_locale.retrieve() = -1 then
	is_dbmessage = ds_locale.uf_getdberror( )
     f_dmc_error (is_dbmessage)
end if

ds_serveur.retrieve()
i_nbr_lue = ds_serveur.rowCount()
ds_serveur.RowsCopy(1, ds_serveur.rowcount(), primary!, ds_locale, 1,Primary!)

// Traitement des commandes transférées de la base locale inexistantes dans la table des commandes
// transférées 
if ds_locale_transferees.retrieve() = -1 then
	is_dbmessage = ds_locale_transferees.uf_getdberror( )
	f_dmc_error (is_dbmessage)
end if

ds_locale_transferees.RowsCopy(1, ds_locale_transferees.rowcount(), primary!, ds_locale, 99999,Primary!)
if ds_locale.update() = -1 then
	is_dbmessage = ds_locale.uf_getdberror( )
	i_nbr_ecrite = 0
	i_nbr_erreur = i_nbr_lue
	return false
end if

i_nbr_ecrite= i_nbr_lue
i_nbr_erreur = 0
return true

end function

public function boolean fw_suppression_temporaire ();/* <DESC>
   Cette fonction va supprimée les lignes des tables temporaires du serveur correspondantes au commande
  du visiteur. Ceci peut ce produire si lors du transfert précédent, une erreur s'est produite et dans ce cas si
  les tables temporaires ne sont épurées, le traitement de transfert ne pourra être effectué car on risque
  d'avoir des anomalies de doublons .
  
  Attention: Si des lignes existent encore dans la table Come9pat (entete de commande), aucune
                    suppression ne sera effectuée car un traitement d'intégration a été posté et peut être encours.
  </DESC>*/
 
nv_datastore ds_serveur
String s_datawindow_serveur
String ls_sql
Long ll_nbr_lignes

i_nbr_ecrite = 0
i_nbr_erreur = 0
i_nbr_lue = 0

ds_serveur = create nv_datastore
ds_serveur.dataobject = 'd_suppression_come9pat_serveur'
ds_serveur.settrans( i_tr_serveur)
ds_serveur.retrieve(g_s_visiteur)

//if ds_serveur.rowcount() > 0 then
//	timer(0)
//	MessageBox(This.Title,g_nv_traduction.get_traduction ("TRANSFERT_ENCOURS") , information!,ok!)
//	destroy ds_serveur
//	timer(0)
//	return false
//end if




ls_sql ="delete from COME9PAT where cviaemaj = '" + g_s_visiteur + "' ;"
EXECUTE immediate :ls_sql using i_tr_serveur;
if i_tr_serveur.sqldbcode <> 0 then
	is_dbmessage = i_tr_serveur.sqlerrtext
	return false
end if

ls_sql ="delete from COME986T where numaecde in (select distinct numaecde FROM COME999T where cviaemaj = '" + g_s_visiteur + "') ;"
EXECUTE immediate :ls_sql using i_tr_serveur;
if i_tr_serveur.sqldbcode <> 0 then
	is_dbmessage = i_tr_serveur.sqlerrtext
	return false
end if

ls_sql ="delete from COME987T where numaecde in (select distinct numaecde FROM COME999T where cviaemaj = '" + g_s_visiteur + "') ;"
EXECUTE immediate :ls_sql using i_tr_serveur;
if i_tr_serveur.sqldbcode <> 0 then
	is_dbmessage = i_tr_serveur.sqlerrtext
	return false
end if

ls_sql ="delete from COME988T where numaecde in (select distinct numaecde FROM COME999T where cviaemaj = '" + g_s_visiteur + "') ;"
EXECUTE immediate :ls_sql using i_tr_serveur;
if i_tr_serveur.sqldbcode <> 0 then
	is_dbmessage = i_tr_serveur.sqlerrtext
	return false
end if

ls_sql ="delete from COME989T where numaecde in (select distinct numaecde FROM COME999T where cviaemaj = '" + g_s_visiteur + "') ;"
EXECUTE immediate :ls_sql using i_tr_serveur;
if i_tr_serveur.sqldbcode <> 0 then
	is_dbmessage = i_tr_serveur.sqlerrtext
	return false
end if

ls_sql ="delete from COME990T where numaecde in (select distinct numaecde FROM COME999T where cviaemaj = '" + g_s_visiteur + "') ;"
EXECUTE immediate :ls_sql using i_tr_serveur;
if i_tr_serveur.sqldbcode <> 0 then
	is_dbmessage = i_tr_serveur.sqlerrtext
	return false
end if

ls_sql ="delete from COME991T where numaecde in (select distinct numaecde FROM COME999T where cviaemaj = '" + g_s_visiteur + "') ;"
EXECUTE immediate :ls_sql using i_tr_serveur;
if i_tr_sql.sqldbcode <> 0 then
	is_dbmessage = i_tr_sql.sqlerrtext
	return false
end if

ls_sql ="delete from COME9PBT where numaecde in (select distinct numaecde FROM COME999T where cviaemaj = '" + g_s_visiteur + "') ;"
EXECUTE immediate :ls_sql using i_tr_serveur;
if i_tr_serveur.sqldbcode <> 0 then
	is_dbmessage = i_tr_serveur.sqlerrtext
	return false
end if

ls_sql ="delete from COME9PCT where numaecde in (select distinct numaecde FROM COME999T where cviaemaj = '" + g_s_visiteur + "') ;"
EXECUTE immediate :ls_sql using i_tr_serveur;
if i_tr_sql.sqldbcode <> 0 then
	is_dbmessage = i_tr_sql.sqlerrtext
	return false
end if

ls_sql ="delete from COME949T where  codeevis = '" + g_s_visiteur + "' ;"
EXECUTE immediate :ls_sql using i_tr_serveur;
if i_tr_serveur.sqldbcode <> 0 then
	is_dbmessage = i_tr_serveur.sqlerrtext
	return false
end if

ls_sql ="delete from COME940T where numaeclf in (select distinct numaeclf FROM COME999T where cviaemaj = '" + g_s_visiteur + "') ;"
EXECUTE immediate :ls_sql using i_tr_serveur;
if i_tr_serveur.sqldbcode <> 0 then
	is_dbmessage = i_tr_serveur.sqlerrtext
	return false
end if

ls_sql ="delete from COME999T where cviaemaj = '" + g_s_visiteur + "';"
EXECUTE immediate :ls_sql using i_tr_serveur;
if i_tr_serveur.sqldbcode <> 0 then
	is_dbmessage = i_tr_serveur.sqlerrtext
	return false
end if
//ds_serveur = create nv_datastore
//ds_serveur.dataobject = 'd_suppression_come9pat_serveur'
//ds_serveur.settrans( i_tr_serveur)
//ds_serveur.retrieve(g_s_visiteur)
//
//if ds_serveur.rowcount() > 0 then
//	timer(0)
//	MessageBox(This.Title,g_nv_traduction.get_traduction ("TRANSFERT_ENCOURS") , information!,ok!)
//	destroy ds_serveur
//	timer(0)
//	return false
//end if
//
//if  fw_suppression_donnees("d_suppression_come986t_serveur", ll_nbr_lignes,true,i_tr_serveur) then
//	i_nbr_ecrite = ll_nbr_lignes
//	i_nbr_lue = ll_nbr_lignes
//	i_nbr_erreur = 0
//else
//	return false
//end if
//
//if  fw_suppression_donnees("d_suppression_come987t_serveur", ll_nbr_lignes,true,i_tr_serveur) then
//	i_nbr_ecrite = i_nbr_ecrite + ll_nbr_lignes
//	i_nbr_lue = i_nbr_lue + ll_nbr_lignes
//	i_nbr_erreur = 0
//else
//	return false
//end if
//
//if  fw_suppression_donnees("d_suppression_come988t_serveur", ll_nbr_lignes,true,i_tr_serveur) then
//	i_nbr_ecrite = i_nbr_ecrite + ll_nbr_lignes
//	i_nbr_lue = i_nbr_lue + ll_nbr_lignes
//	i_nbr_erreur = 0
//else
//	return false
//end if
//
//if  fw_suppression_donnees("d_suppression_come989t_serveur", ll_nbr_lignes,true,i_tr_serveur) then
//	i_nbr_ecrite = i_nbr_ecrite + ll_nbr_lignes
//	i_nbr_lue = i_nbr_lue + ll_nbr_lignes
//	i_nbr_erreur = 0
//else
//	return false
//end if
//
//if  fw_suppression_donnees("d_suppression_come990t_serveur", ll_nbr_lignes,true,i_tr_serveur) then
//	i_nbr_ecrite = i_nbr_ecrite + ll_nbr_lignes
//	i_nbr_lue = i_nbr_lue + ll_nbr_lignes
//	i_nbr_erreur = 0
//else
//	return false
//end if
//
//if  fw_suppression_donnees("d_suppression_come991t_serveur", ll_nbr_lignes,true,i_tr_serveur) then
//	i_nbr_ecrite = i_nbr_ecrite + ll_nbr_lignes
//	i_nbr_lue = i_nbr_lue + ll_nbr_lignes
//	i_nbr_erreur = 0
//else
//	return false
//end if
//
//if  fw_suppression_donnees("d_suppression_come9pct_serveur", ll_nbr_lignes,true,i_tr_serveur) then
//	i_nbr_ecrite = i_nbr_ecrite + ll_nbr_lignes
//	i_nbr_lue = i_nbr_lue + ll_nbr_lignes
//	i_nbr_erreur = 0
//else
//	return false
//end if
//
//if  fw_suppression_donnees("d_suppression_come9pbt_serveur", ll_nbr_lignes,true,i_tr_serveur) then
//	i_nbr_ecrite = i_nbr_ecrite + ll_nbr_lignes
//	i_nbr_lue = i_nbr_lue + ll_nbr_lignes
//	i_nbr_erreur = 0
//else
//	return false
//end if
//
//if  fw_suppression_donnees("d_suppression_come949t_serveur", ll_nbr_lignes,true,i_tr_serveur) then
//	i_nbr_ecrite = i_nbr_ecrite + ll_nbr_lignes
//	i_nbr_lue = i_nbr_lue + ll_nbr_lignes
//	i_nbr_erreur = 0
//else
//	return false
//end if
//
//if  fw_suppression_donnees("d_suppression_come940t_serveur", ll_nbr_lignes,true,i_tr_serveur) then
//	i_nbr_ecrite = i_nbr_ecrite + ll_nbr_lignes
//	i_nbr_lue = i_nbr_lue + ll_nbr_lignes
//	i_nbr_erreur = 0
//else
//	return false
//end if
//
//if  fw_suppression_donnees("d_suppression_come999t_serveur", ll_nbr_lignes,true,i_tr_serveur) then
//	i_nbr_ecrite = i_nbr_ecrite + ll_nbr_lignes
//	i_nbr_lue = i_nbr_lue + ll_nbr_lignes
//	i_nbr_erreur = 0
//else
//	return false
//end if
//
//i_nbr_ecrite = i_nbr_ecrite + ll_nbr_lignes
//i_nbr_lue = i_nbr_lue + ll_nbr_lignes
//i_nbr_erreur = 0
	
return true
end function

public function boolean fw_suppression_donnees (string as_datawindow, ref long al_nbr_row, boolean ab_avec_visiteur, transaction a_tr_sql);/* <DESC> 
    Module de suppression des données commandes
    <LI> Extraction des données à partir de la datawindow passé en paramètre, puis
	 copy des lignes extraites du buffer principal vers le buffer contenant les lignes
	 supprimées, puis lancement de la mise à jour
	 </DESC> */
nv_datastore ds_donnees
long    ll_nbr_lignes
ds_donnees = CREATE nv_datastore
ds_donnees.dataobject = as_datawindow
ds_donnees.settrans(a_tr_sql)
if ab_avec_visiteur  then
    ds_donnees.retrieve(g_s_visiteur)
else
	ds_donnees.retrieve()
end if
al_nbr_row = ds_donnees.Rowcount()
ds_donnees.rowsmove(1, ds_donnees.rowcount(), primary!, ds_donnees, 1,delete!)
if ds_donnees.update() = -1 then
	is_dbmessage = ds_donnees.uf_getdberror( )
	return false
end if
return true
end function

public subroutine fw_log_erreur (string as_message);// Création d'un mouvement dans la table log du serveur
//		nv_come9fdv_log lnv_come9fdv_log 
//	     lnv_come9fdv_log = create nv_come9fdv_log
//	     lnv_come9fdv_log.set_log_erreur_transfert_cde( id_date_deb, id_date_fin,i_tr_ori,as_message)
//	     destroy nv_come9fdv_log
end subroutine

public subroutine fw_save_bon_cde ();nv_datastore ds_locale
nv_datastore ds_datastore

String s_cetaecde
String s_numaecde
String s_numaeclf
String s_code_adr
String s_ucc
String s_texte
String ls_fichier
Long ll_row
Integer li_retrieve

ds_locale = create nv_datastore
ds_locale.dataobject = "d_extraction_entete_cde"
ds_locale.settrans( i_tr_sql)
if ds_locale.retrieve() = -1 then
	return
end if

s_code_adr = g_nv_come9par.get_code_adresse()
ds_datastore = create nv_datastore
ds_datastore.dataobject = "d_save_bon_cde"
ds_datastore.setTransObject (i_tr_sql)

for ll_row = 1 to ds_locale.RowCount()
	s_numaecde = ds_locale.GetItemString (ll_row, DBNAME_NUM_CDE)
	s_numaeclf  = ds_locale.GetItemString (ll_row, DBNAME_CLIENT_CODE)
	ds_datastore.Retrieve (s_numaecde)
	g_nv_traduction.set_traduction_datastore( ds_datastore)
	ls_fichier = inv_parametre.fu_check_directory("Transfert",s_numaeclf ) + "\" + s_numaecde + " "+ is_date_creation  + ".html"
	ds_datastore.saveas(ls_fichier,HTMLTable!		,true)
next

destroy ds_datastore
destroy ds_locale
end subroutine

public function boolean fw_lancement_integration ();String ls_cmd
String ls_type
String ls_sql

ls_type = inv_parametre.fu_type_integration()

CHOOSE CASE ls_type
	CASE 'INTERNET'
		ls_cmd =  inv_parametre.fu_get_cde_fin_transfert( )
		ls_cmd = ls_cmd + g_s_visiteur + "&DateTrf="+string( today(), "yyyy-mm-ddhh-mm-ss")
		ls_cmd = ls_cmd +  inv_parametre.fu_get_cde_fin_transfert_2( )
		run ( ls_cmd) 
		timer(5)
		
	CASE 'PROC'
		ls_sql =  "Call COMEP100 ('" + g_s_visiteur + "');"
		EXECUTE immediate :ls_sql using i_tr_serveur;
		if i_tr_serveur.sqldbcode <> 0 then
		   is_dbmessage = i_tr_serveur.sqlerrtext 
		   	messageBox(this.title, is_dbmessage, Stopsign!, ok!)
			return false
		end if
		open ( w_confirmation_integration)
END CHOOSE

return true
end function

public subroutine fw_transfert_manuel ();// 1 Affichage des commandes pouvant être transférée
//     Non validée et non annulée

str_pass l_str_pass

OpenWithParm (w_selection_commandes, l_str_pass)
l_str_pass = Message.fnv_get_str_pass()
Message.fnv_clear_str_pass()				
if l_str_pass.s_action = ACTION_CANCEL  then	
end if


// 2 Export des données des commandes sélectionnées et ceci pour chaque commande
nv_datastore ds_locale
String s_datawindow_locale
String   s_param		
String ls_fichier

ds_locale = CREATE nv_datastore
ds_locale.settrans( i_tr_sql)

ds_locale.dataobject = "d_extraction_entete_cde"
ds_locale.retrieve()
fw_export_csv (ds_locale,'come9pat')
fw_export_csv (ds_locale,'come999t')

ds_locale.dataobject = "d_extraction_message_cde"
ds_locale.retrieve()
fw_export_csv (ds_locale,'come9pat')

ds_locale.dataobject = "d_extraction_ligne_cde"
ds_locale.retrieve()
fw_export_csv (ds_locale,'come9pct')

ds_locale.dataobject = "d_extraction_come9086"
ds_locale.retrieve()
fw_export_csv (ds_locale,'come986t')

ds_locale.dataobject = "d_extraction_come9087"
ds_locale.retrieve()
fw_export_csv (ds_locale,'come987t')

ds_locale.dataobject = "d_extraction_come9088"
ds_locale.retrieve()
fw_export_csv (ds_locale,'come988t')

ds_locale.dataobject = "d_extraction_come9089"
ds_locale.retrieve()
fw_export_csv (ds_locale,'come989t')

ds_locale.dataobject = "d_extraction_come9090"
ds_locale.retrieve()
fw_export_csv (ds_locale,'come990t')

ds_locale.dataobject = "d_extraction_come9091"
ds_locale.retrieve()
fw_export_csv (ds_locale,'come991t')

ds_locale.dataobject = "d_extraction_client_prospect"
ds_locale.retrieve(g_s_visiteur)
fw_export_csv (ds_locale,'come940t')

ds_locale.dataobject = "d_extraction_mvts_client"
ds_locale.retrieve(g_s_visiteur)
fw_export_csv (ds_locale,'come949t')


return
end subroutine

public subroutine fw_export_csv (datastore ad_datastore, string as_table);String ls_fichier

if ad_datastore.rowcount() > 0 then
	ls_fichier = inv_parametre.fu_check_directory("Transfert", is_date_creation) + "\" + as_table  + ".csv"
	ad_datastore.SaveAs(ls_fichier,CSV!,true)
end if
end subroutine

public subroutine fw_log_cde_nontransferee ();nv_datastore ds_donnees
long ll_row
ds_donnees = CREATE nv_datastore
ds_donnees.dataobject = "d_extraction_cde_nontrf"
ds_donnees.settrans(i_tr_sql)
ds_donnees.retrieve()


if ds_donnees.Rowcount()  = 0 then
	return
end if

for ll_row = 1 to ds_donnees.rowCount()
	inv_come9fdv_log.set_cde_ntrf (ds_donnees.getItemString(ll_row,DBNAME_NUM_CDE), &
	                                              ds_donnees.getItemString(ll_row,DBNAME_ETAT_CDE) , &
	                                              ds_donnees.getItemString(ll_row,DBNAME_CODE_MAJ)	,&
	                                              i_tr_serveur, &
	                                              ds_donnees.getItemDateTime(ll_row,DBNAME_DATE_SAISIE_CDE) , &
	                                               ds_donnees.getItemDateTime(ll_row,DBNAME_DATE_CDE)	,&
	                                               ds_donnees.getItemString(ll_row,DBNAME_CLIENT_CODE)	)			
next

DESTROY ds_donnees
return
end subroutine

on w_transfert_des_commandes.create
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

on w_transfert_des_commandes.destroy
call super::destroy
destroy(this.erreurs_t)
destroy(this.pb_echap)
destroy(this.pb_ok)
destroy(this.dw_pipe_errors)
destroy(this.dw_tables)
end on

event ue_ok;call super::ue_ok;/* <DESC>
    Executer le transfert des données dans l'ordre défini dans la datawindow des traitements:
    <LI>Si le traitement est 'come9cdt', on récupère la table des commandes transférées du serveur sur le poste
    <LI>Si le traitement est 'suppression' suppression des commandes présentent dans la table come9cdt récupérée précédemment
    <LI>Si le traitement est 'preparation', affichage de la fenetre de selection des commandes à transferer
    <LI>Si le traitement est 'come9049' suppression des mouvements de modification clients sur le poste
    <LI>Si le traitement est 'come9par' mise à jour des compteurs sur le serveur si ceux ci sont plus petits que ceux en local
    <LI>Si le traitement est 'supp_relicat' , suppression des données des tables temporaires du serveur 
    <LI>Sinon, transfert des données de la table correspondant au nom du traitement sur le serveur.
  </DESC> */
integer li_return
long ll_long
String  ls_table
str_pass l_str_pass
long ll_row
Boolean  lb_return
String ls_statut
integer li_nbr_cde_validee
datetime id_date_deb
string ls_sql

inv_come9fdv_log = create nv_come9fdv_log
inv_parametre        = create nv_param_informatique

pb_ok.enabled = false
pb_echap.enabled = false

setPointer(HourGlass!)
ib_timer_transfert = true

is_date_creation = string( today(), "yyyy-mm-dd hh-mm-ss")
id_date_deb = sqlca.fnv_get_datetime ()
// Boucle de lecture de la datawindow contenant les traitemlents a effectuer
for ll_long = 1 to dw_tables.rowCount()
 	dw_tables.setItem(ll_long, "statut",	  "Encours")	
     dw_tables.setItem(ll_long, "heure_debut",		String(now()))	
	Timer(1)	
	i_nbr_rectangle = 0	 	  
	ls_table  = dw_tables.getItemString(ll_long, DBNAME_CODE_TABLE)
	i_nbr_lue = 0
	i_nbr_ecrite = 0
	i_nbr_erreur = 0
	lb_return = false
	ls_statut = "Terminer"
	
	choose case ls_table
		case "come9cdt"
			i_pipeline.dataobject = ls_table
			if not g_nv_come9par.is_relation_clientele() then
			     li_return 				 = i_pipeline.Start(i_tr_serveur, i_tr_sql,dw_pipe_errors, g_s_visiteur + "%","%")
			else
			     li_return 				 = i_pipeline.Start(i_tr_serveur, i_tr_sql,dw_pipe_errors,  "%","X")
			end if
			
			if li_return <> 1 then
				messageBox(this.title, g_nv_traduction.get_traduction ("ERREUR_RECHERCHE") +" come9cdt  : return code = " + String(li_return) , Stopsign!, ok!)
				lb_return = true
				ls_statut = "En Erreur"
			else
	    		     i_nbr_lue = i_pipeline.RowsRead
				i_nbr_ecrite  = i_pipeline.RowsWritten
				i_nbr_erreur =  i_pipeline.RowsInerror
			end if
			
       case "come9cdt_cde_validee"
			i_pipeline.dataobject = ls_table
			li_return 				 = i_pipeline.Start(i_tr_serveur, i_tr_sql,dw_pipe_errors)
						
			if li_return <> 1 then
				messageBox(this.title, g_nv_traduction.get_traduction ("ERREUR_RECHERCHE") +" come9cdt  : return code = " + String(li_return) , Stopsign!, ok!)
				lb_return = true
				ls_statut = "En Erreur"
			else
	    		     i_nbr_lue = i_pipeline.RowsRead
				i_nbr_ecrite  = i_pipeline.RowsWritten
				i_nbr_erreur =  i_pipeline.RowsInerror
			end if			
					
		case "Suppression"
			ls_sql ="call FdvDeleteCde();"
			EXECUTE immediate :ls_sql using i_tr_sql;
			
			if i_tr_sql.sqldbcode <> 0 then
				is_dbmessage = i_tr_sql.sqlerrtext
				ll_row = dw_pipe_errors.insertRow(0)
  				dw_pipe_errors.setItem(ll_row,"Ligne_erreur", is_dbmessage)
  			     lb_return = true
         		ls_statut = "En Erreur"
			else					
	    		     i_nbr_lue =0
				i_nbr_ecrite  = 0
				i_nbr_erreur =  0
			end if

   	     case "Preparation"
			OpenWithParm (w_selection_commandes, l_str_pass)
			l_str_pass = Message.fnv_get_str_pass()
			Message.fnv_clear_str_pass()				
			if l_str_pass.s_action = ACTION_CANCEL  then	
				lb_return = true
				ls_statut = "En Erreur"				
			else
				i_nbr_lue = l_str_pass.d[1]
				i_nbr_ecrite  =  l_str_pass.d[2]
				i_nbr_erreur =  0
			end if
			
	   case "come9049"
			if not fw_suppression_mvts_client()  then
				ll_row = dw_pipe_errors.insertRow(0)
				dw_pipe_errors.setItem(ll_row,"Ligne_erreur", is_dbmessage)
				MessageBox(This.Title,g_nv_traduction.get_traduction ("TRANSFERT_CDE_ERREUR") , information!,ok!)
				lb_return = true
				ls_statut = "En Erreur"				
			end if
			
	   case "come9par"
			if not fw_donnees_visiteur() then
				ll_row = dw_pipe_errors.insertRow(0)
				dw_pipe_errors.setItem(ll_row,"Ligne_erreur", is_dbmessage)
   				lb_return = true
				ls_statut = "En Erreur"					
			end if
	   case "supp_relicat"
			if not fw_suppression_temporaire() then
				ll_row = dw_pipe_errors.insertRow(0)
				dw_pipe_errors.setItem(ll_row,"Ligne_erreur", is_dbmessage)
   				lb_return = true
				ls_statut = "En Erreur"					
			end if
	   case else
			if not fw_transfert_donnees(ls_table)  then
				ll_row = dw_pipe_errors.insertRow(0)
				dw_pipe_errors.setItem(ll_row,"Ligne_erreur", is_dbmessage)
   				lb_return = true
				ls_statut = "En Erreur"					
			end if
	end choose
	
	Timer(0)
	dw_tables.setItem(dw_tables.getRow(),"indicateur", 0)
	dw_tables.setItem(ll_long, "ligne_lue",		String(i_nbr_lue))
	dw_tables.setItem(ll_long, "ligne_ecrite",	     String(i_nbr_ecrite))	
     dw_tables.setItem(ll_long, "ligne_erreur",	String(i_nbr_erreur))		
     dw_tables.setItem(ll_long, "heure_fin",		String(now()))		
	dw_tables.setItem(ll_long, "statut", ls_statut	)
	dw_tables.setredraw( true)
	if lb_return then
		MessageBox(This.Title,g_nv_traduction.get_traduction ("TRANSFERT_CDE_ERREUR"), StopSign!,ok!)
		// Création d'un mouvement dans la table log du serveur
		if dw_pipe_errors.RowCount() > 0 then
		      inv_come9fdv_log.set_log_erreur_transfert_cde( id_date_deb,i_tr_serveur,dw_pipe_errors.GetItemString(li_return,"Ligne_erreur"))
		end if
		 disconnect using i_tr_serveur;
		  pb_echap.enabled = true
		 return
	end if
next

// transfert dans le fichier log des commandes non sélectionnées.
// uniquement pour les profils vendeur
if g_nv_come9par.get_type_visiteur( ) = CODE_VENDEUR then
	fw_log_cde_nontransferee()
end if

fw_save_bon_cde()
ib_timer_transfert = false
inv_come9fdv_log.set_log_transfert( id_date_deb,i_tr_serveur)
	
fw_lancement_integration() 		

disconnect using i_tr_serveur;
destroy inv_come9fdv_log
destroy inv_parametre
pb_echap.enabled = true

end event

event ue_init;call super::ue_init;/* <DESC>
    Initialisation de l'affichage de la fenêtre.
	 <LI> Préparation de la connexion au serveur et connexion
	 <LI> Création des lignes des traitements à effectuer dans la datawindow.
   </DESC> */
String s_dbms, s_database,s_logid,s_log_pass,s_dbparm,s_serveur, ls_message
nv_control_manager  lnv_controle
pipeline lnv_pipeline
integer  li_return

i_tr_serveur = CREATE transaction
// Initialisation et connection au serveur central
String ls_section_ori
ls_section_ori = g_nv_ini.fnv_Profile_String("DefaultDBMS","DBMS_remote","")

i_tr_serveur.dbms 			=	g_nv_ini.fnv_Profile_String(ls_section_ori,"DBMS","")
i_tr_serveur.database 	=	g_nv_ini.fnv_Profile_String(ls_section_ori,"Database","")
i_tr_serveur.ServerName	=  g_nv_ini.fnv_Profile_String(ls_section_ori,"Servername","")
i_tr_serveur.DBParm         =  g_nv_ini.fnv_Profile_String(ls_section_ori,"DbParm","") + ";UID="+g_s_visiteur+";PWD="+g_s_visiteur+"'"


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

lnv_controle = create nv_control_manager
if not lnv_controle.is_portable_connecte(i_tr_serveur,ls_message) then
	messageBox(this.title, ls_message, Stopsign!, ok!)
	pb_echap.enabled = true
	setPointer(Arrow!)
	return
end if

// Récupération de la table du serveur contenant les paramètres informatiques
lnv_pipeline = CREATE pipeline
lnv_pipeline.dataobject = "come9_parametre_info"
li_return 				 = lnv_pipeline.Start(i_tr_serveur, i_tr_sql,dw_pipe_errors)
if li_return <> 1 then
	messageBox(this.title, g_nv_traduction.get_traduction ("ERREUR_RECHERCHE") + " come9_parametre_info  : return code = " + String(li_return) , Stopsign!, ok!)
	return
end if

// Traitement de controle des versions
if  lnv_controle.is_transfert_interdit() then
     this.PostEvent ("ue_cancel")
     return
end if

// Création des lignes de traitement dans la datwindow
long ll_row
ll_row  = 0

ll_row ++
dw_tables.insertRow (ll_row)
dw_tables.setItem(ll_row, 1,"come9cdt")
dw_tables.setItem(ll_row, 2,"Recpt Dernières Cdes transférées")
dw_tables.setItem(ll_row, 3,"En attente")
dw_tables.setItem(ll_row,"pipeline_object","come9cdt")

ll_row ++
dw_tables.insertRow (ll_row)
dw_tables.setItem(ll_row, 1,"come9cdt_cde_validee")
dw_tables.setItem(ll_row, 2,"Recpt Dernières Cdes validées")
dw_tables.setItem(ll_row, 3,"En attente")
dw_tables.setItem(ll_row,"pipeline_object","come9cdt_cde_validee")

ll_row ++
dw_tables.insertRow (ll_row)
dw_tables.setItem(ll_row, 1,"Suppression")
dw_tables.setItem(ll_row, 2,"Suppression des commandes transférées")
dw_tables.setItem(ll_row, 3,"En attente")
dw_tables.setItem(ll_row,"pipeline_object","call FdvDeleteCde")

// Données pour suppression du contenu des tables temporaires du serveur avant d'integrer
// les données des commandes sélectionnees. Dans le cas ou il existe encore des lignes dans
// les tables temporaires du serveur, cele signifie que le traitement de transfert précédent n'a pas
// été effectuée et que les commandes sont toujours sur le portable.
ll_row ++
dw_tables.insertRow (ll_row)
dw_tables.setItem(ll_row, 1,"supp_relicat")
dw_tables.setItem(ll_row, 2,"Supresssion infos transfert precedent")
dw_tables.setItem(ll_row, 3,"En attente")
dw_tables.setItem(ll_row,"pipeline_object","supp_relicat")

ll_row ++
dw_tables.insertRow (ll_row)
dw_tables.setItem(ll_row, 1,"Preparation")
dw_tables.setItem(ll_row, 2,"Selection des commandes à transferer")
dw_tables.setItem(ll_row, 3,"En attente")
dw_tables.setItem(ll_row,"pipeline_object","w_selection_commandes")

// Données pour transfert des commandes sur le serveur
ll_row ++
dw_tables.insertRow (ll_row)
dw_tables.setItem(ll_row, 1,"come999t")
dw_tables.setItem(ll_row, 2,"Transfert entetes commandes")
dw_tables.setItem(ll_row, 3,"En attente")
dw_tables.setItem(ll_row,"pipeline_object","d_come999t")

ll_row ++
dw_tables.insertRow (ll_row)
dw_tables.setItem(ll_row, 1,"come9pct")
dw_tables.setItem(ll_row, 2,"Transfert lignes commandes")
dw_tables.setItem(ll_row, 3,"En attente")
dw_tables.setItem(ll_row,"pipeline_object","d_come9pct")

ll_row ++
dw_tables.insertRow (ll_row)
dw_tables.setItem(ll_row, 1,"come9pbt")
dw_tables.setItem(ll_row, 2,"Transfert messages commandes")
dw_tables.setItem(ll_row, 3,"En attente")
dw_tables.setItem(ll_row,"pipeline_object","d_come9pbt")

ll_row ++
dw_tables.insertRow (ll_row)
dw_tables.setItem(ll_row, 1,"come991t")
dw_tables.setItem(ll_row, 2,"Transfert Instructions Cde")
dw_tables.setItem(ll_row, 3,"En attente")
dw_tables.setItem(ll_row,"pipeline_object","d_come991t")

ll_row ++
dw_tables.insertRow (ll_row)
dw_tables.setItem(ll_row, 1,"come990t")
dw_tables.setItem(ll_row, 2,"Transfert textes transitaires")
dw_tables.setItem(ll_row, 3,"En attente")
dw_tables.setItem(ll_row,"pipeline_object","d_come990t")

ll_row ++
dw_tables.insertRow (ll_row)
dw_tables.setItem(ll_row, 1,"come989t")
dw_tables.setItem(ll_row, 2,"Transfert textes factures")
dw_tables.setItem(ll_row, 3,"En attente")
dw_tables.setItem(ll_row,"pipeline_object","d_come989t")

ll_row ++
dw_tables.insertRow (ll_row)
dw_tables.setItem(ll_row, 1,"come988t")
dw_tables.setItem(ll_row, 2,"Transfert textes marquages")
dw_tables.setItem(ll_row, 3,"En attente")
dw_tables.setItem(ll_row,"pipeline_object","d_come988t")

ll_row ++
dw_tables.insertRow (ll_row)
dw_tables.setItem(ll_row, 1,"come987t")
dw_tables.setItem(ll_row, 2,"Transfert textes transporteur")
dw_tables.setItem(ll_row, 3,"En attente")
dw_tables.setItem(ll_row,"pipeline_object","d_come987t")

ll_row ++
dw_tables.insertRow (ll_row)
dw_tables.setItem(ll_row, 1,"come986t")
dw_tables.setItem(ll_row, 2,"Transfert textes bordereau")
dw_tables.setItem(ll_row, 3,"En attente")
dw_tables.setItem(ll_row,"pipeline_object","d_come986t")

ll_row ++
dw_tables.insertRow (ll_row)
dw_tables.setItem(ll_row, 1,"come940t")
dw_tables.setItem(ll_row, 2,"Transfert clients prospects")
dw_tables.setItem(ll_row, 3,"En attente")
dw_tables.setItem(ll_row,"pipeline_object","d_extraction_client_prospect")

//ll_row ++
//dw_tables.insertRow (ll_row)
//dw_tables.setItem(ll_row, 1,"come940t")
//dw_tables.setItem(ll_row, 2,"Transfert clients prospects")
//dw_tables.setItem(ll_row, 3,"En attente")
//dw_tables.setItem(ll_row,"pipeline_object","d_come940t")
//
//ll_row ++
//dw_tables.insertRow (ll_row)
//dw_tables.setItem(ll_row, 1,"come949t")
//dw_tables.setItem(ll_row, 2,"Transfert mouvements clients")
//dw_tables.setItem(ll_row, 3,"En attente")
//dw_tables.setItem(ll_row,"pipeline_object","d_come949t")

ll_row ++
dw_tables.insertRow (ll_row)
dw_tables.setItem(ll_row, 1,"come9049")
dw_tables.setItem(ll_row, 2,"RAZ mouvements clients")
dw_tables.setItem(ll_row, 3,"En attente")
dw_tables.setItem(ll_row,"pipeline_object","d_extraction_mvts_client")

ll_row ++
dw_tables.insertRow (ll_row)
dw_tables.setItem(ll_row, 1,"come9pat")
dw_tables.setItem(ll_row, 2,"Transfert entetes commandes")
dw_tables.setItem(ll_row, 3,"En attente")
dw_tables.setItem(ll_row,"pipeline_object","d_come9pat")

ll_row ++
dw_tables.insertRow(ll_row)
dw_tables.setItem(ll_row,1,"come9par")
dw_tables.setItem(ll_row,2,"Transfert infos visiteur")
dw_tables.setitem(ll_row,3,"En attente")
dw_tables.setItem(ll_row,"pipeline_object","fw_donnees_visiteur")

setPointer(Arrow!)

i_pipeline = CREATE nv_pipeline_object
pb_ok.enabled = true
pb_echap.enabled = true
pb_ok.setfocus( )

str_pass l_str_pass
l_str_pass.po[1] = i_tr_serveur
openwithparm ( w_compte_rendu,l_str_pass)

end event

event ue_cancel;call super::ue_cancel;/* <DESC> 
     Permet de quitter le trqnsfert apres deconnexion du serveur
   </DESC> */
disconnect using i_tr_serveur;
close(this)
end event

event close;call super::close;/* <DESC>
    Permet de femer la fenetre apres deconnexion du serveur
   </DESC> */
disconnect using i_tr_serveur;



end event

event ue_print;call super::ue_print;/* <DESC>
      Permet d'imprimer la liste des traitements definis dans la datawindow des traitements
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

event timer;call super::timer;	/* <DESC> 
     PErmet d'afficher la ligne de défilement sur la ligne correspondante
	  au pipeline en cours d'exécution.
   </DESC> */
	
if ib_timer_transfert then
	dw_tables.setItem(dw_tables.getRow(), "statut", BLANK	)
	if i_nbr_rectangle =  4 then
		i_nbr_rectangle = 0
	end if
	i_nbr_rectangle ++
	dw_tables.setItem(dw_tables.getRow(),"indicateur", i_nbr_rectangle)
	dw_tables.setredraw( true)
end if
end event

type uo_statusbar from w_a`uo_statusbar within w_transfert_des_commandes
end type

type erreurs_t from statictext within w_transfert_des_commandes
integer x = 187
integer y = 1280
integer width = 718
integer height = 100
integer textsize = -14
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "none"
boolean border = true
boolean focusrectangle = false
end type

type pb_echap from u_pba_echap within w_transfert_des_commandes
integer x = 1719
integer y = 1160
integer taborder = 30
boolean enabled = false
string picturename = "C:\appscir\Erfvmr_diva\Image\PBECHAP.BMP"
end type

type pb_ok from u_pba_ok within w_transfert_des_commandes
integer x = 1234
integer y = 1156
integer taborder = 20
boolean enabled = false
string picturename = "C:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type dw_pipe_errors from datawindow within w_transfert_des_commandes
integer x = 160
integer y = 1384
integer width = 3534
integer height = 704
integer taborder = 20
string title = "                                                 Les Erreurs"
string dataobject = "d_erreur_transfert"
boolean hscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_tables from datawindow within w_transfert_des_commandes
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

