$PBExportHeader$w_recuperation_commande.srw
$PBExportComments$Permet de recuperer les commandes du serveur pour mettre a jour le portable
forward
global type w_recuperation_commande from w_a
end type
type erreurs_t from statictext within w_recuperation_commande
end type
type pb_echap from u_pba_echap within w_recuperation_commande
end type
type pb_ok from u_pba_ok within w_recuperation_commande
end type
type dw_pipe_errors from datawindow within w_recuperation_commande
end type
type dw_tables from datawindow within w_recuperation_commande
end type
end forward

global type w_recuperation_commande from w_a
string tag = "RECUP_CDES"
integer width = 5536
integer height = 3436
string title = "Récupération des commandes"
boolean minbox = false
boolean maxbox = false
boolean vscrollbar = true
boolean resizable = false
windowtype windowtype = response!
long backcolor = 12632256
boolean center = true
erreurs_t erreurs_t
pb_echap pb_echap
pb_ok pb_ok
dw_pipe_errors dw_pipe_errors
dw_tables dw_tables
end type
global w_recuperation_commande w_recuperation_commande

type variables
transaction			 	i_tr_serveur
nv_pipeline_object 	i_pipeline
integer					i_nbr_rectangle
long 						i_nbr_lue
long 						i_nbr_ecrite
long 						i_nbr_erreur
String 					is_dbmessage
boolean 					ib_return
String 					is_statut

Integer 					i_indice_tableau = 14
String           is_trait,                                          is_titre,                      is_type,                is_object1,                                              is_object2,                                           is_object3,                                is_object4

/* Tableau contenant les traitements a effectuer pour la recuperation des commandes avec les objects a utiliser */
String is_tableau[14] ={ &
              "Selection_visiteur, Sélection des visiteurs,                      Selection,          w_selection_visiteurs,"                     + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come9pat,             Extraction entete cde serveur,           Recuperation,  come9pat_recup,"                                         + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come9pbt,             Extraction message cde serveur,     Recuperation,  come9pbt_recup,"                                         + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come9pct,             Extraction ligne cde serveur,              Recuperation,  come9pct_recup,"                                         + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come986t,             Extraction message cde serveur,     Recuperation,  come986t_recup,"                                         + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come987t,             Extraction texte cde serveur,               Recuperation,  come987t_recup,"                                        + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come988t,             Extraction texte cde serveur,               Recuperation,  come988t_recup,"                                        + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come989t,             Extraction texte cde serveur,               Recuperation,  come989t_recup,"                                        + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come990t,             Extraction texte cde serveur,               Recuperation,  come990t_recup,"                                        + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come991t,             Extraction texte cde serveur,               Recuperation,  come991t_recup,"                                        + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come9fdv_log,       Creation log cdes récupérées,          Log,                    d_come9pat_pour_log,                      d_come9fdv_log"                 + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&				  
			"Restore     ,             Restore commande du portable,       Restore,            call FdvRecupCde,"                    + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come9par,              Mise à  jour paramètres du visiteur,  Fonction,           fw_donnees_visiteur,"                      + DONNEE_VIDE                     + ","     +DONNEE_VIDE + ","       +  DONNEE_VIDE,&												
			"Visiteurs,                 Récupération liste des visiteurs,       Fonction,           fw_liste_visiteur,"                               + DONNEE_VIDE                    + ","      +DONNEE_VIDE + ","       +  DONNEE_VIDE  &																							
			}
			
/*****			
String is_tableau[57] = {  &
			"come9pat,              Création table temporaire,                Pipeline,          come9pat,"                                            + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come9pbt,              Création table temporaire,                Pipeline,          come9pbt,"                                            + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come9pct,              Création table temporaire,                Pipeline,          come9pct,"                                            + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come986t,              Création table temporaire,                Pipeline,          come986t,"                                            + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come987t,              Création table temporaire,                Pipeline,          come987t,"                                            + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come988t,              Création table temporaire,                Pipeline,          come988t,"                                            + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come989t,              Création table temporaire,                Pipeline,          come989t,"                                            + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come990t,              Création table temporaire,                Pipeline,          come990t,"                                            + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come991t,              Création table temporaire,                Pipeline,          come991t,"                                            + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come90pa_save,   Création table  ,                                  Pipeline,          come90pa_save_port,"                         + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come90pb_save,   Création table  ,                                  Pipeline,          come90pb_save_port,"                         + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come90pc_save,   Création table  ,                                  Pipeline,          come90pc_save_port,"                         + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come9086_save,   Création table ,                                   Pipeline,          come9086_save_port,"                         + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come9087_save,   Création table ,                                   Pipeline,          come9087_save_port,"                         + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come9088_save,   Création table  ,                                  Pipeline,          come9088_save_port,"                         + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come9089_save,   Création table ,                                   Pipeline,          come9089_save_port,"                         + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come9090_save,   Création table  ,                                  Pipeline,          come9090_save_port,"                         + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come9091_save,   Création table  ,                                  Pipeline,          come9091_save_port,"                         + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come90pa,             Sauve Entetes cde portable,            Sauvegarde,  d_extract_come90pa_pour_save,           d_extract_come90pa_deja_sauve,  d_come90pa_save_port,  d_come9pat" ,&
			"come90pb,             Sauve Messages cde portable,       Sauvegarde,  d_extract_come90pb_pour_save,           d_extract_come90pb_deja_sauve,  d_come90pb_save_port,  d_come9pbt" ,&
			"come90pc,             Sauve Lignes cde portable,             Sauvegarde,  d_extract_come90pc_pour_save,           d_extract_come90pc_deja_sauve,  d_come90pc_save_port,  d_come9pct" ,&
			"come9086,             Sauve Textes cde portable,             Sauvegarde,  d_extract_come9086_pour_save,           d_extract_come9086_deja_sauve,  d_come9086_save_port,  d_come986t" ,&
			"come9087,             Sauve Textes cde portable,             Sauvegarde,  d_extract_come9087_pour_save,           d_extract_come9087_deja_sauve,  d_come9087_save_port,  d_come987t" ,&
			"come9088,             Sauve Textes cde portable,             Sauvegarde,  d_extract_come9088_pour_save,           d_extract_come9088_deja_sauve,  d_come9088_save_port,  d_come988t" ,&
			"come9089,             Sauve Textes cde portable,             Sauvegarde,  d_extract_come9089_pour_save,           d_extract_come9089_deja_sauve,  d_come9089_save_port,  d_come989t" ,&
			"come9090,             Sauve Textes cde portable,             Sauvegarde,  d_extract_come9090_pour_save,           d_extract_come9090_deja_sauve,  d_come9090_save_port,  d_come990t" ,&
			"come9091,             Sauve Textes cde portable,             Sauvegarde,  d_extract_come9091_pour_save,           d_extract_come9091_deja_sauve,  d_come9091_save_port,  d_come991t" ,&
			"Selection_visiteur, Sélection des visiteurs,                    Selection,       w_selection_visiteurs,"                           + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come90pa,             Extraction entete cde serveur,         Recuperation, come90pa,"                                           + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come90pb,             Extraction message cde serveur,    Recuperation,  come90pb,"                                           + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come90pc,             Extraction ligne cde serveur,           Recuperation,  come90pc,"                                           + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come9086,             Extraction message cde serveur,    Recuperation,  come9086,"                                           + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come9087,             Extraction texte cde serveur,           Recuperation,  come9087,"                                           + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come9088,             Extraction texte cde serveur,           Recuperation,  come9088,"                                           + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come9089,             Extraction texte cde serveur,           Recuperation,  come9089,"                                           + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come9090,             Extraction texte cde serveur,           Recuperation,  come9090,"                                           + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come9091,             Extraction texte cde serveur,           Recuperation,  come9091,"                                           + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come9fdv_log,       Creation log cdes récupérées,      Log,                   d_come90pa_pour_log,                             d_come9fdv_log"              + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come90pa,             Restore entete cde portable,            Restore,         d_extract_come9pat_non_modifie,          d_extract_come90pa_existe_come9pat,  d_come9pat,"          + DONNEE_VIDE,&
			"come90pb,             Restore message cde portable,       Restore,         d_extract_come9pbt_non_modifie,          d_extract_come90pb_existe_come9pbt,  d_come9pbt,"          + DONNEE_VIDE,&
			"come90pc,             Restore lignes cde portable,             Restore,         d_extract_come9pct_non_modifie,          d_extract_come90pc_existe_come9pct,  d_come9pct,"          + DONNEE_VIDE,&
			"come9086,             Restore texte cde portable,              Restore,         d_extract_come986t_non_modifie,          d_extract_come9086_existe_come986t,  d_come986t,"          + DONNEE_VIDE,&
			"come9087,             Restore texte cde portable,              Restore,         d_extract_come987t_non_modifie,          d_extract_come9087_existe_come987t,  d_come987t,"          + DONNEE_VIDE,&
			"come9088,             Restore texte cde portable,              Restore,         d_extract_come988t_non_modifie,          d_extract_come9088_existe_come988t,  d_come988t,"          + DONNEE_VIDE,&
			"come9089,             Restore texte cde portable,              Restore,         d_extract_come989t_non_modifie,          d_extract_come9089_existe_come989t,  d_come989t,"          + DONNEE_VIDE,&
			"come9090,             Restore texte cde portable,              Restore,         d_extract_come990t_non_modifie,          d_extract_come9090_existe_come990t,  d_come990t,"          + DONNEE_VIDE,&
			"come9091,             Restore texte cde portable,              Restore,         d_extract_come991t_non_modifie,          d_extract_come9091_existe_come991t,  d_come991t,"          + DONNEE_VIDE,&
			"come9par,             Mise à  jour paramètres du visiteur,  Fonction,        fw_donnees_visiteur,"                             + DONNEE_VIDE + ","                         +DONNEE_VIDE + ","       +DONNEE_VIDE,&												
			"Visiteurs,               Récupération liste des visiteurs,       Fonction,        fw_liste_visiteur,"                                     + DONNEE_VIDE  + ","                        +DONNEE_VIDE + ","       +DONNEE_VIDE,&																								
			"come9pat,             Suppression table temporaire,           Pipeline,          come9pat,"                                            + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come9pbt,             Suppression table temporaire,           Pipeline,          come9pbt,"                                            + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come9pbc,            Suppression table temporaire,           Pipeline,          come9pbc,"                                            + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come986t,             Suppression table temporaire,           Pipeline,          come986t,"                                            + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come987t,             Suppression table temporaire,           Pipeline,          come987t,"                                            + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come988t,             Suppression table temporaire,           Pipeline,          come988t,"                                            + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come989t,             Suppression table temporaire,           Pipeline,          come989t,"                                            + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come990t,             Suppression table temporaire,           Pipeline,          come990t,"                                            + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE,&
			"come991t,             Suppression table temporaire,           Pipeline,          come991t,"                                            + DONNEE_VIDE                     + ","      + DONNEE_VIDE  + ","      + DONNEE_VIDE &
													}
****/
end variables

forward prototypes
public function integer fw_parse_string (string as_chaine)
public function boolean fw_liste_visiteur ()
public function boolean fw_donnees_visiteur ()
public subroutine fw_ecrit_erreur ()
public function boolean fw_sauvegarde ()
public function boolean fw_restore ()
public function boolean fw_come9trf_log (string as_dataobject)
end prototypes

public function integer fw_parse_string (string as_chaine); /* <DESC>
      Permet d'extraire tous les paramètres de la ligne du tableau de traitement et initialisation des 
	variables d'instance correspondantes.
    </DESC> */
 Integer li_pos_prec
 Integer li_pos
 
 li_pos = pos(as_chaine, "," ,1)
 is_trait = trim(Mid(as_chaine,1, li_pos - 1))
 
 li_pos_prec = li_pos + 1
 li_pos = pos(as_chaine, "," ,li_pos_prec)
 is_titre = trim(Mid(as_chaine,li_pos_prec, li_pos - li_pos_prec))
 
 li_pos_prec = li_pos + 1
 li_pos = pos(as_chaine, "," ,li_pos_prec)
 is_type =  trim(Mid(as_chaine,li_pos_prec, li_pos - li_pos_prec))
 
 li_pos_prec = li_pos + 1
 li_pos = pos(as_chaine, "," ,li_pos_prec)
 is_object1 =   trim(Mid(as_chaine,li_pos_prec, li_pos -li_pos_prec))
 
 li_pos_prec = li_pos + 1
 li_pos = pos(as_chaine, "," ,li_pos_prec)
 is_object2 =   trim(Mid(as_chaine,li_pos_prec, li_pos -li_pos_prec))
  
 li_pos_prec = li_pos + 1
 li_pos = pos(as_chaine, "," ,li_pos_prec)
 is_object3 =   trim(Mid(as_chaine,li_pos_prec, li_pos -li_pos_prec))
 
 li_pos_prec = li_pos + 1
 is_object4 =   trim(Mid(as_chaine,li_pos_prec))
return 0
end function

public function boolean fw_liste_visiteur ();/* <DESC>
     Permet de mettre à jour la liste des visiteurs du portable à partir des données du serveur.
	  Les données du visiteur connecté ne sont pas pris en compte dans ce traitement.
   </DESC> */
nv_datastore ds_serveur
nv_datastore ds_locale

ds_serveur = CREATE nv_datastore
ds_locale    = CREATE nv_datastore

ds_serveur.dataobject = "d_come9par_liste_visiteur"
ds_locale.dataobject = "d_come9par_liste_visiteur"

ds_serveur.settransobject(  i_tr_serveur)
ds_locale.settransobject(i_tr_sql)

if ds_serveur.retrieve(g_s_visiteur) = -1 then
	is_dbmessage = ds_serveur.uf_getdberror( )
	return false
end if

i_nbr_lue = ds_serveur.RowCount()

if ds_locale.retrieve(g_s_visiteur) = -1 then
	is_dbmessage = ds_locale.uf_getdberror( )
	return false
end if

ds_locale.rowsmove (1, ds_locale.RowCount(), Primary!, ds_locale, 1 , Delete!)
if ds_locale.update() = -1  then
	is_dbmessage = ds_locale.uf_getdberror( )
	return false
end if

ds_serveur.RowsCopy (1, ds_serveur.ROwCount(), primary!, ds_locale, 1 , primary!)
if ds_locale.update()  = -1 then
	is_dbmessage = ds_locale.uf_getdberror( )
	return false
end if

return true
end function

public function boolean fw_donnees_visiteur ();/* <DESC>
     Mise à jour des paramètres visiteur sur le serveur.
	 Les données mise à jour sont :
	 	le dernier n° de commande . Pour ce faire on extrait la liste des commandes du visiteur triées par ordre
		 décroissant de la date de saisie de la commande du cote serveur et portable. 
		 Si la date de saisie du serveur est plus grance que celle du portable, mise à jour du dernier n° de commande
		 sur le serveur.
		le dernier n° de client prospect mais uniquement si sur la base locale le dernier numero est plus petit que sur la base locale.
   </DESC> */ 
	
nv_datastore ds_liste_serveur
nv_datastore ds_liste_locale
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

if ds_donnee_visiteur_local.getItemDateTime(1,DBNAME_DATE_MAJ_PROSPECT) < ds_donnee_visiteur_serveur.getItemDateTime(1,DBNAME_DATE_MAJ_PROSPECT) then
	ds_donnee_visiteur_local.setItem(1, DBNAME_COMPTEUR_PROSPECT , ds_donnee_visiteur_serveur.getItemDecimal(1,DBNAME_COMPTEUR_PROSPECT)  )
	ds_donnee_visiteur_local.setItem(1, DBNAME_DATE_MAJ_PROSPECT , ds_donnee_visiteur_serveur.getItemDateTime(1,DBNAME_DATE_MAJ_PROSPECT)  )
end if

if ds_donnee_visiteur_local.getItemDateTime(1, DBNAME_DATE_MAJ_NCDTER   ) < ds_donnee_visiteur_serveur.getItemDateTime(1,DBNAME_DATE_MAJ_NCDTER) then
	ds_donnee_visiteur_local.setItem(1, DBNAME_COMPTEUR_COMMANDE , ds_donnee_visiteur_serveur.getItemDecimal(1,DBNAME_COMPTEUR_COMMANDE)  )
	ds_donnee_visiteur_local.setItem(1, DBNAME_DATE_MAJ_NCDTER , ds_donnee_visiteur_serveur.getItemDateTime(1,DBNAME_DATE_MAJ_NCDTER)  )
end if

i_nbr_ecrite = 0
i_nbr_erreur = 0

if 	lb_maj_a_effectuer  then
	i_nbr_ecrite = 1
	i_nbr_erreur = 0
	if ds_donnee_visiteur_local.update() = -1 then
		is_dbmessage = ds_donnee_visiteur_local.uf_getdberror( )
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

public subroutine fw_ecrit_erreur ();/* <DESC>
     Permet d'ecrire l'erreur rencontrée lors de l'exécution d'un traitement dans la datawindow
	  des erreurs.
   </DESC> */
Long ll_row_error
ll_row_error = dw_pipe_errors.insertRow(0)
dw_pipe_errors.setItem(ll_row_error,"Ligne_erreur", is_dbmessage)
ib_return = true
is_statut = "En Erreur"			
end subroutine

public function boolean fw_sauvegarde ();/* <DESC>
      va effectuer la sauvegarde des données commandes du visiteur avant d'effectuer la récupération
	des commandes du serveur 
	<LI> Suppression des données encore existante dans la table contenant la sauvegarde. Ceci est possible dans
	le cas ou une anomalie a été rencontrée lors d'une précédente récupération.
	<LI> Extraction des données à sauvegarder
	<LI> Copie des lignes dans la table de sauvegarde et mise à jour
   </DESC> */
nv_datastore ds_donnees_a_sauvegarder
nv_datastore ds_donnees_deja_sauvegarder
nv_datastore ds_donnees_ttes_donnees_sauvegardees
nv_datastore ds_copie_temporaire
boolean lb_return

ds_donnees_a_sauvegarder = CREATE nv_datastore
ds_donnees_deja_sauvegarder = CREATE nv_datastore
ds_donnees_ttes_donnees_sauvegardees = CREATE nv_datastore
ds_copie_temporaire = CREATE nv_datastore

ds_donnees_a_sauvegarder.dataobject = is_object1
ds_donnees_deja_sauvegarder.dataobject = is_object2
ds_donnees_ttes_donnees_sauvegardees.dataobject = is_object3
ds_copie_temporaire.dataobject = is_object4

ds_donnees_a_sauvegarder.settransobject( i_tr_sql)
ds_donnees_deja_sauvegarder.settransobject( i_tr_sql)
ds_donnees_ttes_donnees_sauvegardees.settransobject( i_tr_sql)
ds_copie_temporaire.settransobject( i_tr_sql)

lb_return = true

/* Extraction des donnees a sauvegarder */
if ds_donnees_a_sauvegarder.retrieve(g_s_visiteur) = -1 then
	 is_dbmessage = ds_donnees_a_sauvegarder.uf_getdberror( )
	 lb_return =  false
	 goto FIN
end if

i_nbr_lue = ds_donnees_a_sauvegarder.RowCount()

/* Extraction des donnees deja sauvegardees pour supression des ces lignes avant
   de copier les donnees a sauvegarder */
if ds_donnees_deja_sauvegarder.retrieve() =  -1 then
	 is_dbmessage = ds_donnees_deja_sauvegarder.uf_getdberror( )
	  lb_return =  false
	 goto FIN
end if
ds_donnees_deja_sauvegarder.RowsMove(1,ds_donnees_deja_sauvegarder.RowCount(),primary!,ds_donnees_deja_sauvegarder,1,Delete!)

if ds_donnees_deja_sauvegarder.update() = -1 then
	is_dbmessage = ds_donnees_deja_sauvegarder.uf_getdberror( )
     lb_return =  false
	goto FIN
end if

/* sauvegarde des donnees */
if ds_donnees_ttes_donnees_sauvegardees.retrieve() = -1 then
	is_dbmessage = ds_donnees_ttes_donnees_sauvegardees.uf_getdberror( )
     lb_return =  false
	goto FIN
end if

ds_donnees_a_sauvegarder.RowsCopy (1,ds_donnees_a_sauvegarder.RowCount(), primary!, ds_donnees_ttes_donnees_sauvegardees,9999, primary!)
if ds_donnees_ttes_donnees_sauvegardees.update() = -1 then
	is_dbmessage = ds_donnees_ttes_donnees_sauvegardees.uf_getdberror( )
     lb_return =  false
	goto FIN	
end if

/* Copie des donnees sauvegarder dans la table temporaire de travail */
if ds_copie_temporaire.retrieve() = -1 then
	is_dbmessage = ds_copie_temporaire.uf_getdberror( )
     lb_return =  false
	goto FIN	
end if

ds_donnees_ttes_donnees_sauvegardees.RowsCopy(1,ds_donnees_ttes_donnees_sauvegardees.ROwCount(),primary!,ds_copie_temporaire,1,Primary!)
if ds_copie_temporaire.update() = -1 then
	is_dbmessage = ds_copie_temporaire.uf_getdberror( )
     lb_return =  false
	goto FIN	
end if

FIN:
destroy ds_donnees_a_sauvegarder
destroy ds_donnees_deja_sauvegarder
destroy ds_donnees_ttes_donnees_sauvegardees
destroy ds_copie_temporaire
return lb_return
end function

public function boolean fw_restore ();/* <DESC>
    Permet de restorer les donnees du visiteur sauvegardees qui sont des nouvelles donnees ou si la 
	 date de modification de 	 chaque ligne est superieure a celle issue du serveur.
	 Avant de restorer les données, toutes les lignes sauvegardées qui ont été
	 modifiée sur le serveur sont supprimées de la sauvegarde afin de ne conserver que les lignes à restorer
   </DESC> */
nv_datastore ds_donnees_sauvees_non_modifiees
nv_datastore ds_donnees_deja_existante
nv_datastore ds_donnees_sauvegardees
nv_datastore ds_donnees_applicatives
boolean lb_return

lb_return = true
ds_donnees_sauvees_non_modifiees  = CREATE nv_datastore
ds_donnees_deja_existante = CREATE nv_datastore
ds_donnees_sauvegardees = CREATE nv_datastore
ds_donnees_applicatives = CREATE nv_datastore

ds_donnees_sauvees_non_modifiees.dataobject  = is_object1
ds_donnees_deja_existante.dataobject = is_object2
ds_donnees_sauvegardees.dataobject = is_object3
ds_donnees_applicatives.dataobject = is_object2

ds_donnees_sauvees_non_modifiees.settransobject( i_tr_sql)
ds_donnees_deja_existante.settransobject( i_tr_sql)
ds_donnees_sauvegardees.settransobject( i_tr_sql)
ds_donnees_applicatives.settransobject( i_tr_sql)

/* Extraction des donnees sauvegardees mais qui ont été modifiées sur le serveur pour suppression
   de ces lignes dans la table de sauvegarde temporaire afin de ne conserver que les lignes
   reellement a reinjecter */
if ds_donnees_sauvees_non_modifiees.retrieve() = -1 then
	is_dbmessage = ds_donnees_sauvees_non_modifiees.uf_getdberror( )
	lb_return =  false
	goto FIN
end if
ds_donnees_sauvees_non_modifiees.rowsmove(1, ds_donnees_sauvees_non_modifiees.rowCount(),primary!, ds_donnees_sauvees_non_modifiees,1,delete!)
if ds_donnees_sauvees_non_modifiees.update() = -1 then
	is_dbmessage = ds_donnees_sauvees_non_modifiees.uf_getdberror( )
	lb_return =  false
	goto FIN
end if

/* Extraction des donnees issues cote serveur qui ont ete modifies sur le portable pour supprimer ces
   lignes et permettre la recreation à partir de la sauvegarde */
if ds_donnees_deja_existante.retrieve() = -1 then
	is_dbmessage = ds_donnees_deja_existante.uf_getdberror( )
	lb_return =  false
	goto FIN
end if
ds_donnees_deja_existante.rowsmove(1, ds_donnees_deja_existante.rowCount(),primary!, ds_donnees_deja_existante,1,delete!)
if ds_donnees_deja_existante.update() = -1 then
	is_dbmessage = ds_donnees_deja_existante.uf_getdberror( )
	lb_return =  false
	goto FIN
end if

/* Extraction des donnees sauvegardees pour insertion dans la table applicative*/
if ds_donnees_sauvegardees.retrieve() = -1 then
	is_dbmessage = ds_donnees_sauvegardees.uf_getdberror( )
	lb_return =  false
	goto FIN
end if

if ds_donnees_applicatives.retrieve() = -1 then
	is_dbmessage = ds_donnees_applicatives.uf_getdberror( )
	lb_return =  false
	goto FIN
end if

/* Recreation des lignes sauvegardées dans la table applicative */
ds_donnees_sauvegardees.RowsCopy (1,ds_donnees_sauvegardees.RowCount(),primary!,ds_donnees_applicatives,1,primary!)
if ds_donnees_applicatives.update() = -1 then
	is_dbmessage = ds_donnees_applicatives.uf_getdberror( )
	lb_return =  false
	goto FIN
end if

i_nbr_ecrite = ds_donnees_applicatives.RowCount()

FIN:
destroy ds_donnees_sauvees_non_modifiees
destroy ds_donnees_deja_existante
destroy ds_donnees_sauvegardees
destroy ds_donnees_applicatives
return true
end function

public function boolean fw_come9trf_log (string as_dataobject);/* Cette fonction va permettre à partir des commandes récupérées ,la creation d'un mouvement dans la table log pour chaque
   commande */
nv_datastore ds_locale
nv_come9fdv_log lnv_come9fdv_log 
long ll_indice
long ll_row

ds_locale   = create nv_datastore
ds_locale.dataobject = as_dataobject
lnv_come9fdv_log = create nv_come9fdv_log

ds_locale.settransobject(i_tr_sql)
ds_locale.retrieve()
i_nbr_lue = ds_locale.rowcount()

for ll_indice = 1 to ds_locale.rowcount()
	lnv_come9fdv_log.set_log_recup_cde(ds_locale.getitemString(ll_indice,DBNAME_NUM_CDE),  & 
															ds_locale.getitemString(ll_indice,DBNAME_ETAT_CDE),  &
															ds_locale.getitemString(ll_indice,DBNAME_CODE_MAJ),  &
															i_tr_serveur)
next

lnv_come9fdv_log.updatelog( )
i_nbr_ecrite = ds_locale.rowcount()
destroy lnv_come9fdv_log
destroy ds_locale
return true
end function

on w_recuperation_commande.create
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

on w_recuperation_commande.destroy
call super::destroy
destroy(this.erreurs_t)
destroy(this.pb_echap)
destroy(this.pb_ok)
destroy(this.dw_pipe_errors)
destroy(this.dw_tables)
end on

event ue_ok;call super::ue_ok;/* <DESC>
   Lancement de la récupération des commandes. Pour chaque ligne de traitement , recherche des paramètres dans le tableau 
	correspondants à la ligne traitée:
	<LI> Si type traitement = Pipeline, Initialisation  du pipeline avec le nom de l'objet du tableau, connexion départ = serveur
	et connexion destination = portable et lancement du taritement
	<LI> Si type = Sauvegarde, appel de la fonction de sauvegarde pour la table à traiter
	<LI> Si type = Restore, appel de la fonction de restore pour la table à traiter
	<LI> Si type = Fonction ,soit appel de la fonction de récupération de la liste des visiteurs du serveur ou appel de la 
	fonction de mise à jour des données du visiteur et ceci est fonction de l'objet associé au type de fonction
	<LI> Si type = Log, creation d'un mouvement dans la table come9fdv_log, pour chaque commande récupérée
	  par le visiteur
	

	En cas d'erreur, la récupération est stoppée
  </DESC> */
integer li_return
String  ls_table
String ls_erreur
str_pass l_str_pass
long ll_row, ll_row_error
boolean  lb_en_erreur
String ls_sql

pb_ok.enabled = false
pb_echap.enabled = false
setPointer(HourGlass!)
lb_en_erreur = false

// Boucle de lecture de la datawindow contenant les traitements a effectuer
for ll_row = 1 to dw_tables.rowCount()
 	dw_tables.setItem(ll_row, "statut",	  "Encours")	
     dw_tables.setItem(ll_row, "heure_debut",		String(now()))		
	dw_tables.setRow(ll_row)
	dw_tables.scrolltoRow(ll_row)
	i_nbr_rectangle = 0
     timer(1)
	ls_table  = dw_tables.getItemString(ll_row, DBNAME_CODE_TABLE)
	i_nbr_lue = 0
	i_nbr_ecrite = 0
	i_nbr_erreur = 0
	ib_return = false
	is_statut = "Terminer"
   
	fw_parse_string(is_tableau[ll_row])
	choose case Upper(is_type)
		case "PIPELINE"
			i_pipeline.dataobject = is_object1
		     li_return 				 = i_pipeline.Start(i_tr_serveur, i_tr_sql,dw_pipe_errors)
			if li_return <> 1 and li_return <> -3  then
				ls_erreur  =  g_nv_traduction.get_traduction ("ERREUR_RECHERCHE") + is_trait + "  : return code = " + String(li_return) 
				ib_return = true
				is_statut = "En Erreur"
			else
	    		     i_nbr_lue = i_pipeline.RowsRead
				i_nbr_ecrite  = i_pipeline.RowsWritten
				i_nbr_erreur =  i_pipeline.RowsInerror
			end if
			  
		case "RECUPERATION"
			i_pipeline.dataobject = is_object1
		    li_return 				 = i_pipeline.Start(i_tr_serveur, i_tr_sql,dw_pipe_errors,g_s_visiteur)
			if li_return <> 1 and li_return <> -3  then
				ls_erreur=  g_nv_traduction.get_traduction ("ERREUR_RECHERCHE") + is_trait + "  : return code = " + String(li_return) 
				ib_return = true
				is_statut = "En Erreur"
			else
	    		     i_nbr_lue = i_pipeline.RowsRead
				i_nbr_ecrite  = i_pipeline.RowsWritten
				i_nbr_erreur =  i_pipeline.RowsInerror
			end if
			  
		case "RESTORE"
			ls_sql = is_object1 + "('" + g_s_visiteur + "');"
			EXECUTE immediate :ls_sql using i_tr_sql;
			
			if i_tr_sql.sqldbcode <> 0 then
				is_dbmessage = i_tr_sql.sqlerrtext
				fw_ecrit_erreur()
				ls_erreur=  g_nv_traduction.get_traduction ("ERREUR_RECHERCHE") + is_trait + "  : return code = " + String(i_tr_sql.sqldbcode)
				lb_en_erreur = true
				goto FIN
			end if
				
		case "FONCTION"
			choose case upper(is_object1)
                     case "FW_LISTE_VISITEUR"
					if not fw_liste_visiteur() then
						fw_ecrit_erreur()
					end if
				
	 			case "FW_DONNEES_VISITEUR"
					if not fw_donnees_visiteur() then
						fw_ecrit_erreur()
					end if
			end choose
			
		case "SELECTION"
			l_str_pass.po[1] = i_tr_serveur
			OpenWithParm (w_selection_visiteurs, l_str_pass)
			l_str_pass = Message.fnv_get_str_pass()
			Message.fnv_clear_str_pass()	
			if l_str_pass.s_action = ACTION_CANCEL  then	
				ls_erreur = l_str_pass.s[1]
				ib_return = true
				is_statut = "En Erreur"				
			else
				i_nbr_lue = l_str_pass.d[1]
				i_nbr_ecrite = l_str_pass.d[2]
			end if
			
		case "LOG"
			 fw_come9trf_log( is_object1)
	end choose

     timer(0)
     dw_tables.setItem(ll_row,"indicateur",0)
	dw_tables.setItem(ll_row, "ligne_lue",		String(i_nbr_lue))
	dw_tables.setItem(ll_row, "ligne_ecrite",	     String(i_nbr_ecrite))	
     dw_tables.setItem(ll_row, "ligne_erreur",	String(i_nbr_erreur))		
     dw_tables.setItem(ll_row, "heure_fin",		String(now()))		
	dw_tables.setItem(ll_row, "statut", is_statut	)
	dw_tables.setredraw(true)

	if ib_return then
		lb_en_erreur = true
		goto FIN
	end if
next

FIN:
setPointer(Arrow!)
disconnect using i_tr_serveur;	
 pb_echap.enabled = true
 if not lb_en_erreur then
	 MessageBox(This.Title, g_nv_traduction.get_traduction ("RECUPERATION_CDE") , Information!,ok!)
else
	MessageBox(This.Title,ls_erreur , StopSign!,ok!)
end if
end event

event ue_init;call super::ue_init;/* <DESC>
     Initialisation de l'affichage de la fenetre
	<LI> En effectuant une connexion au serveur
	<LI> A partir du tableau des traitements, alimentation de la datawindow
   </DESC> */
String s_dbms, s_database,s_logid,s_log_pass,s_dbparm,s_serveur
pipeline lnv_pipeline
nv_control_manager lnv_controle
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
	messageBox(this.title, g_nv_traduction.get_traduction ("PARAM_DBMS_ERREUR") , Stopsign!, ok!)
	return
end if

if i_tr_serveur.dbms = i_tr_sql.dbms then
	messageBox(this.title,g_nv_traduction.get_traduction ("PARAM_DBMS_ERREUR"), Stopsign!, ok!)
	return
end if

if i_tr_serveur.database = i_tr_sql.database and &
	i_tr_serveur.ServerName = i_tr_sql.ServerName then
	messageBox(this.title, g_nv_traduction.get_traduction ("PARAM_DBMS_ERREUR"), Stopsign!, ok!)
	return
end if	

connect using i_tr_serveur;

setPointer(HourGlass!)
// Récupération de la table du serveur contenant les paramètres informatiques
lnv_pipeline = CREATE pipeline
lnv_pipeline.dataobject = "come9_parametre_info"
li_return 				 = lnv_pipeline.Start(i_tr_serveur, i_tr_sql,dw_pipe_errors)
if li_return <> 1 then
	messageBox(this.title, g_nv_traduction.get_traduction ("ERREUR_RECHERCHE") + " come9_parametre_info  : return code = " + String(li_return) , Stopsign!, ok!)
	return
end if

lnv_controle = create nv_control_manager
// Traitement de controle des versions
if  lnv_controle.is_recup_interdite() then
     this.PostEvent ("ue_cancel")
     return
end if

long ll_row
ll_row  = 0

for ll_row = 1 to i_indice_tableau
	fw_parse_string( is_tableau[ll_row])
	dw_tables.insertRow (ll_row)
	dw_tables.setItem(ll_row, 1,is_trait)
	dw_tables.setItem(ll_row, 2,is_titre)
	dw_tables.setItem(ll_row, 3,"En attente")
	dw_tables.setItem(ll_row,"pipeline_object",is_object1)
next
setPointer(Arrow!)

i_pipeline = CREATE nv_pipeline_object
pb_ok.enabled = true
pb_echap.enabled = true
pb_ok.setfocus()
end event

event ue_cancel;call super::ue_cancel;/* <DESC>
     Permet de fermer le fenetre lors de l'activation de la touche Echap après deconnexion du serveur
   </DESC> */
disconnect using i_tr_serveur;
close(this)
end event

event close;call super::close;/* <DESC> 
     Deconnexion au serveur et ferme la fenetre
   </DESC> */
disconnect using i_tr_serveur;








end event

event ue_print;call super::ue_print;/* <DESC>
     Impression de la liste des traitements
   </DESC> */
dw_tables.print()
end event

event timer;call super::timer;/* <DESC>
       Permet lors du traitement d'un object de type piepeline, d'afficher des rectangles bleu sur la ligne en cours
	  de traitement pour montrer que le systeme travaille 
   </DESC> */
dw_tables.setItem(dw_tables.getRow(), "statut", BLANK	)
if i_nbr_rectangle =  4 then
	i_nbr_rectangle = 0
end if
i_nbr_rectangle ++
dw_tables.setItem(dw_tables.getRow(),"indicateur", i_nbr_rectangle)
	dw_tables.setredraw(true)
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

type uo_statusbar from w_a`uo_statusbar within w_recuperation_commande
end type

type erreurs_t from statictext within w_recuperation_commande
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
string text = "none "
boolean border = true
boolean focusrectangle = false
end type

type pb_echap from u_pba_echap within w_recuperation_commande
integer x = 1719
integer y = 1160
integer taborder = 30
boolean enabled = false
string picturename = "c:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type pb_ok from u_pba_ok within w_recuperation_commande
integer x = 1234
integer y = 1156
integer taborder = 20
boolean enabled = false
string picturename = "c:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type dw_pipe_errors from datawindow within w_recuperation_commande
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

type dw_tables from datawindow within w_recuperation_commande
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

