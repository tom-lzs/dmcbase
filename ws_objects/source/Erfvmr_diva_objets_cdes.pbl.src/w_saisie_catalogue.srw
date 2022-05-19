$PBExportHeader$w_saisie_catalogue.srw
$PBExportComments$Saisie et modification des lignes de commande à partir des références composant un catalogue.
forward
global type w_saisie_catalogue from w_a_mas_det
end type
type pb_echap from u_pba_echap within w_saisie_catalogue
end type
type pb_ok from u_pba_ok within w_saisie_catalogue
end type
type pb_changer from u_pba_chge_sel within w_saisie_catalogue
end type
type dw_ligne_cde from u_dw_udim within w_saisie_catalogue
end type
type r_3 from rectangle within w_saisie_catalogue
end type
type r_1 from rectangle within w_saisie_catalogue
end type
type r_2 from rectangle within w_saisie_catalogue
end type
type st_1 from statictext within w_saisie_catalogue
end type
type st_2 from statictext within w_saisie_catalogue
end type
type st_cb from statictext within w_saisie_catalogue
end type
type em_cb from u_ema within w_saisie_catalogue
end type
type code_barre_t from statictext within w_saisie_catalogue
end type
type st_qte_cb from statictext within w_saisie_catalogue
end type
type sle_qte_cb from singlelineedit within w_saisie_catalogue
end type
type pb_etiquette from u_pba_etiquette within w_saisie_catalogue
end type
type pb_annul_cb from u_pba_etiquette within w_saisie_catalogue
end type
type r_cb from rectangle within w_saisie_catalogue
end type
end forward

global type w_saisie_catalogue from w_a_mas_det
string tag = "SAISIE_CATALOGUE"
integer x = 0
integer y = 0
integer width = 4256
integer height = 2104
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = child!
windowstate windowstate = maximized!
long backcolor = 12632256
boolean ib_statusbar_visible = true
event ue_changer pbm_custom49
event ue_workflow ( )
event ue_saisie_cb ( )
event ue_ctrl_codebarre ( )
pb_echap pb_echap
pb_ok pb_ok
pb_changer pb_changer
dw_ligne_cde dw_ligne_cde
r_3 r_3
r_1 r_1
r_2 r_2
st_1 st_1
st_2 st_2
st_cb st_cb
em_cb em_cb
code_barre_t code_barre_t
st_qte_cb st_qte_cb
sle_qte_cb sle_qte_cb
pb_etiquette pb_etiquette
pb_annul_cb pb_annul_cb
r_cb r_cb
end type
global w_saisie_catalogue w_saisie_catalogue

type variables
// Numéro de ligne de commande
Long	i_l_num_ligne

// Indique si des lignes ont été saisies
Boolean	i_b_saisie

// Indique si on vient d'ouvrir la fenêtre
Boolean	i_b_ouverture = True

//Colonne triée
String	i_s_objet

//Indique le type de saisie effectuée (normal ou pre vente)
boolean i_b_prix_normal = true


nv_commande_object 	i_nv_commande_object
nv_ligne_cde_object 	i_nv_ligne_cde_object
nv_reference_vente  i_nv_reference_object

String 					is_sql_origine
n_tooltip_mgr itooltip

boolean					i_b_saisie_cb = false
string 					is_code_barre
end variables

forward prototypes
public subroutine fw_return_fenetre_origine ()
end prototypes

event ue_changer;/* <DESC>
    Affichage de la fenetre de selection du catatlogue et extraction des reéférences du
	 catalogue et en fonction des criteres de selection complementaire.
	 <LI>Controle et sauvegarde de la ligne en cours de saisie
	 <LI>Affichage de la fenetre de saisie des conditions
	 <LI>En fonction du type de tarif, rendre visible la zone tarif catalogue ou tarif normal
	 <LI>Complete la syntaxe sql en fonction des critères de sélection 
	 <LI>Extraction des lignes 
	 <LI>Pour chaque référence extraite, controle si existence d'une ligne de commande saisie
	 pour la catalogue et pour la reference. Si tel est le cas , affichage de la quantité commandée
   </DESC> */
	
// -----------------------------------
// DECLARATION DES VARIABLES LOCALES
// -----------------------------------
Str_pass		str_work
long        ll_row_cde
long        ll_row_catalogue
Decimal  ld_par, ld_tarif

// SAUVEGARDE DE L'ENREGISTREMENT ENCOURS
IF dw_1.RowCount () <> 0 THEN
	This.TriggerEvent ("ue_presave")
END IF

// affichage de la fenetre de selection du catalogue
str_work.po[01] = i_nv_commande_object
OpenWithParm (w_sel_catalogue, str_work)
	
str_work = Message.fnv_get_str_pass()
Message.fnv_clear_str_pass()

if str_work.s_action = ACTION_CANCEL then
	IF dw_1.RowCount() = 0 THEN
		This.TriggerEvent ("ue_cancel")
	ELSE
		dw_1.SetFocus ()
	END IF 
	RETURN
end if

// Reactualisation des tarifs à afficher et ceci en fonction du type de tarif
// selectionne
i_b_prix_normal = str_work.b[1]
if i_b_prix_normal then
    dw_1.modify (DBNAME_PRIX_CATALOGUE + ".visible = false")
    dw_1.modify (DBNAME_PRIX_ARTICLE + ".visible = true")
else
	dw_1.modify (DBNAME_PRIX_CATALOGUE + ".visible = true")
     dw_1.modify (DBNAME_PRIX_ARTICLE + ".visible = false")
end if

String ls_sql
Boolean lb_modif_sql = false
ls_sql = is_sql_origine

if trim(str_work.s[1]) <>  DONNEE_VIDE then
	ls_sql = ls_sql + " AND  COME9027." + DBNAME_CODE_CATALOGUE + " ='" + str_work.s[1] + "' "
	lb_modif_sql = true
end if

if trim(str_work.s[2]) <>  DONNEE_VIDE then
	ls_sql = ls_sql + " AND " + DBNAME_NUM_PAGE + " = '" + str_work.s[2] + "' "
	lb_modif_sql = true	
end if

if trim(str_work.s[3]) <>  DONNEE_VIDE then
	ls_sql = ls_sql + " AND " + DBNAME_CATALOGUE_DESCR_REF + " like '" + str_work.s[3] + "%' "
	lb_modif_sql = true	
end if

if trim(str_work.s[4]) <>  DONNEE_VIDE then
	ls_sql = ls_sql + " AND  COME9072." + DBNAME_ARTICLE + " = '" + str_work.s[4] + "' "
	lb_modif_sql = true	
end if

if	lb_modif_sql then
	dw_1.SetSqlSelect(ls_sql)
	dw_1.setTransObject(sqlca)
end if

if dw_1.retrieve() = -1 then
		f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
end if

if dw_1.RowCount() = 0 then
	messagebox (This.title	, g_nv_traduction.get_traduction(PAS_DE_SELECTION) , StopSign! , Ok!, 1)	
	This.TriggerEvent ("ue_changer")
	return
end if

setPointer(HourGlass!)
// recherche is existence de lignes de commande déjà saisies sur ce code cataloge.
// Si tel est le cas, initialisation de la qté à partir de celle de la ligne de cde
dw_ligne_cde.retrieve(i_nv_commande_object.fu_get_numero_cde(),str_work.s[01])
if dw_ligne_cde.rowCount() > 0 then
	 for ll_row_cde  = 1 to dw_ligne_cde.rowCount()
		for ll_row_catalogue = 1 to dw_1.rowCount()
			if dw_ligne_cde.GetItemString(ll_row_cde,DBNAME_ARTICLE)  = dw_1.GetItemString(ll_row_catalogue,DBNAME_ARTICLE)  and  &
			  dw_ligne_cde.GetItemString(ll_row_cde,DBNAME_DIMENSION) = dw_1.GetItemString(ll_row_catalogue,DBNAME_DIMENSION) then
  			      dw_1.setItem(ll_row_catalogue, DBNAME_QTE,   dw_ligne_cde.GetItemDecimal(ll_row_cde,DBNAME_QTE))
  		    end if
		next
	 next
end if

if not  i_b_prix_normal then
	goto fin
end if

// Recherche du tarif si l'on est en mode prix normal
//  Cette recherche est effectuée car la jointure externe pose des probleme en mode
//  portable
// extraction du tarif pour mettre à jour les infos au niveau de l'article
datastore ds_tarif 
ds_tarif = create datastore
ds_tarif.Dataobject = "d_dimension_tarif"
ds_tarif.SetTransObject (i_tr_sql)

Long l_row

for ll_row_cde = 1 to dw_1.RowCount() 
  ds_tarif.retrieve(dw_1.GetItemString (ll_row_cde, DBNAME_ARTICLE),   i_nv_commande_object.fu_get_marche(), &
															  i_nv_commande_object.fu_get_liste_prix(), &
															  i_nv_commande_object.fu_get_devise() )
  if ds_tarif.RowCount() = 0 then
   	   dw_1.setItem(l_row, DBNAME_PRIX_ARTICLE,0)		
	  continue
  end if
  ld_par =  ds_tarif.getItemDecimal(1, DBNAME_UNIPAR)
  ld_tarif = ds_tarif.getItemDecimal(1, DBNAME_PRIX_ARTICLE)
  if ld_par = 0 or IsNull(ld_par) then
       	dw_1.setItem(ll_row_cde, DBNAME_PRIX_ARTICLE, ld_tarif)
     else
          ld_tarif = Round(ld_tarif / ld_par,2)
		dw_1.setItem(ll_row_cde, DBNAME_PRIX_ARTICLE, ld_tarif)
  end if
next

Fin:
setPointer(Arrow!)
dw_1.SetFocus ()
i_b_ouverture = False
end event

event ue_workflow();/* <DESC>
    Cet evenement est appelé lors de la sélection d'une option dans le menu alors que cette
	 fenetre est la fenetre active et va lancer le workflow manager pour effetuer l'enchainement.
	 
	 Affichage d'un message de demande d'abandon de la saisie.
	 Si abandon de la saisie, enchainemnt par le workflowmanager sinon la fenetre reste
	 affichée
</DESC> */
integer li_reponse

li_reponse = messagebox (g_nv_traduction.get_traduction(SAISIE_COMMANDE), &
				 g_nv_traduction.get_traduction ("SAISIE_CATALOGUE_EN_COURS") , & 
				StopSign!,YesNo!,1)

if li_reponse = 1 then
	i_str_pass.po[2] = i_nv_commande_object
	i_str_pass.s[2] = i_nv_commande_object.fu_get_numero_cde()
	g_nv_workflow_manager.fu_check_workflow(FENETRE_CATALOGUE, i_str_pass)
	close(this)
end if
end event

event ue_saisie_cb();em_cb.text=""
em_cb.setFocus()

if  i_b_saisie_cb then
   i_b_saisie_cb=false
else
   i_b_saisie_cb=true
end if

if i_b_saisie_cb then
	pb_annul_cb.visible = true
	pb_etiquette.visible =false
else
	pb_annul_cb.visible = false
	pb_etiquette.visible =true
	dw_1.setFocus()
end if
end event

event ue_ctrl_codebarre();integer li_long
integer li_indice
string ls_chaine
long li_row
Decimal ld_qte
long l_doublon


if len(is_code_barre) = 0 then
	return
end if

li_long =13 -  len(is_code_barre)
if li_long <13 then
	ls_chaine = is_code_barre
	for li_indice = 1 to li_long
		ls_chaine = "0"+ ls_chaine
	next
	is_code_barre = ls_chaine
end if

if len(sle_qte_cb.text) = 0 then
	messagebox ("Saisie par CB", "Qté obligatoire",stopsign!,ok!)
     sle_qte_cb.text = "1"
     sle_qte_cb.setFocus()
	  return
end if

ld_qte = integer(sle_qte_cb.text)

// controle de l'existence du code barre
nv_datastore ds_datastore
ds_datastore = create nv_datastore
ds_datastore.dataobject = "d_ctrl_codebarre"  
ds_datastore.settrans( SQLCA)

 if ds_datastore.retrieve (i_nv_commande_object.fu_get_marche(),is_code_barre) < 1 then
	if ds_datastore.retrieve ("",is_code_barre) < 1 then
		destroy ds_datastore
		messagebox ("Saiei par CB", "Code barre inexistant",stopsign!,ok!)
		is_code_barre = ""
	     em_cb.setFocus()
		return
	end if
 end if
 
// controle de l'article dans le catalogue
// RECHERCHE LIGNE EN DOUBLE
l_doublon =	dw_1.Find (  &
			DBNAME_ARTICLE     + " ='" + ds_datastore.getitemString(1,1)     + "'and " + &
			DBNAME_DIMENSION   + " ='" + ds_datastore.getitemString(1,2) + "'", &
			1,dw_1.RowCount())
if l_doublon = 0 then
	destroy ds_datastore
	messagebox ("Saiei par CB", "Produit inexistant dans le catalogue",stopsign!,ok!)
	is_code_barre = ""
	em_cb.setFocus()
	return
end if

//  Mise à jour de la quantité sur a ligne de catalogue
dw_1.scrollToRow(l_doublon)
dw_1.setFocus()
dw_1.setitem(l_doublon,"qteaeuve",ld_qte)
dw_1.SetColumn ("qteaeuve")
triggerEvent("ue_presave")
em_cb.setFocus()
//
//    i_l_ligne_encours_controle = li_row
//    dw_1.triggerevent("ue_change_row")
// 	triggerEvent("ue_save")
//	 dw_1.fu_insert (0)
//i_b_insert_ligne	=	TRUE	
//dw_1.SetColumn (i_s_tab_one)
//     destroy ds_datastore
//	is_code_barre = ""

end event

public subroutine fw_return_fenetre_origine ();/* <DESC>
      Permet de revenir sur la fenetre d'origne.
	Si aucune fenetre n'est à l'origine de l'affichage de la saisie catalogue (Par le menu)
	   affichage de la fenetre de lignes de commande sinon affichage de la fenetre d'origine
   </DESC> */
if g_nv_workflow_manager.fu_get_fenetre_origine() = BLANK then
	g_s_fenetre_destination = FENETRE_LIGNE_CDE
else
	g_s_fenetre_destination = g_nv_workflow_manager.fu_get_fenetre_origine()
end if

g_nv_workflow_manager.fu_check_workflow(FENETRE_CATALOGUE, i_str_pass)
close(this)
end subroutine

event ue_init;call super::ue_init;/* <DESC>
   Affichage initiale de la fenêtre.
	 <LI> Controle si identification du client
	 <LI> Création de l'object commande et extraction des informations de l'entête de la commande
	 <LI> Initialisation de l'object nv_ligne_cde_object
	 <LI> Initialisation de l'object nv_reference
	 <LI> Initialisation de la datastore devant contenir les lignes de commandes des références
	 du catalogue seélectionnées
   </DESC> */
	
Long			l_retrieve
Str_pass		str_work

	sle_qte_cb.text = "1"
	
i_str_pass = g_nv_workflow_manager.fu_ident_client(true, i_str_pass)
if  i_str_pass.s_action = ACTION_CANCEL then
	close(this)
	RETURN
end if

i_nv_commande_object = CREATE nv_commande_object
i_nv_commande_object.fu_set_numero_cde(i_str_pass.s[2])

IF dw_mas.Retrieve (i_nv_commande_object.fu_controle_numero_cde(i_str_pass.po[1]),g_nv_come9par.get_code_langue()) = -1 THEN
 	f_dmc_error (this.title +  BLANK + DB_ERROR_MESSAGE)
END IF
nv_client_object lnv_client
lnv_client = i_str_pass.po[1]

dw_mas.setItem(1,"alerte",lnv_client.fu_get_alerte( ))

i_nv_ligne_cde_object = CREATE nv_ligne_cde_object
i_nv_ligne_cde_object.fu_init_info_commande(i_nv_commande_object)

// Cette datawindow contiendra toutes les lignes de cde créées par cette option
// ceci pour permettre une validation des lignes
dw_ligne_cde.setTransObject (sqlca)
i_nv_ligne_cde_object.fu_init_valeur_ligne_cde_catalogue(dw_ligne_cde)

is_sql_origine = dw_1.getSqlSelect()
i_nv_reference_object = create nv_reference_vente

This.TriggerEvent ("ue_changer")
end event

event ue_cancel;/* <DESC> 
    Permet de quitter la saisie sans saisie des conditions puis retour soit sur la liste
	 d'origine, soit sur a saisie des lignes.
  </DESC> */
i_str_pass.s_action = ACTION_OK
i_b_canceled = TRUE

i_str_pass.po[2] = i_nv_commande_object
i_str_pass.s[2] = i_nv_commande_object.fu_get_numero_cde()
i_str_pass.s_action = ACTION_OK
i_b_canceled = TRUE
fw_return_fenetre_origine()
end event

event ue_ok;/* <DESC>
      Validation de la fin de saisie .
	 <LI> Affichage de la fenêtre de saisie des conditions générales en passant les 
	 paramètres par défaut issues de la ligne de commande ou de l'entete de la commande
	 <LI> En retour report des conditions saisies sur l'ensemble des lignes de commandes
	 saisie à partir du catalogue.
	 <LI> Validation da la commande en reactualisant les blocages de l'entete et valorisation 
	 de la commande
	 <LI> Retour à la fenêtre d'origine.
   </DESC> */
// OVERRIDE SCRIPT ANCESTOR
// DECLARATION DES VARIABLES LOCALES
Str_pass		str_work
integer	   li_indice
decimal ii_multiplicateur
decimal  ii_nbr_ligne_traitée =  0.0
decimal ii_nbr_total_ligne
boolean lb_invert = false
long	ll_color

dw_1.TriggerEvent (ItemChanged!)

if dw_ligne_cde.RowCount() = 0 then
     MessageBox(this.title, g_nv_traduction.get_traduction(VALIDATION_CATALOGUE_IMPOSSIBLE), information!, ok!)
	return
end if

str_work.s[1] = dw_ligne_cde.getItemString(1, DBNAME_TYPE_LIGNE)
str_work.s[2] = dw_ligne_cde.getItemString(1, DBNAME_GROSSISTE)

i_nv_commande_object.fu_retrieve_commande( )
str_work.s[3] = i_nv_commande_object.fu_get_code_echeance()
str_work.s[4] = i_nv_commande_object.fu_get_mode_paiement()
str_work.d[1] = i_nv_commande_object.fu_get_remise_cde()
str_work.dates[1] = i_nv_commande_object.fu_get_date_livraison()
str_work.dates[2] = i_nv_commande_object.fu_get_date_prix()
str_work.b[1]  = false
str_work.po[1] = i_nv_commande_object

OpenWithParm (w_conditions, str_work)
str_work = Message.fnv_get_str_pass()
Message.fnv_clear_str_pass()

if str_work.s_action = ACTION_CANCEL then
	return
end if

setPointer(HourGlass!)
ii_nbr_total_ligne = dw_ligne_cde.RowCount()
ii_multiplicateur = 100 / ii_nbr_total_ligne
st_1.text = "Veuillez patienter , mise à jour des lignes de la commande en cours"
dw_1.visible = false

for li_indice = 1 to dw_ligne_cde.RowCount()
	r_2.width = li_indice /dw_ligne_cde.RowCount()* r_1.width
	st_2.text = String (li_indice / dw_ligne_cde.RowCount(), "##0%")
	if not lb_invert then
		if ( r_2.width +  r_2.x) >= st_2.x then
			lb_invert = true
			ll_color = st_2.textcolor
			st_2.TextColor = st_2.BackColor
			st_2.BackColor = ll_color
		end if
	end if	  			
	
	dw_ligne_cde.setItem(li_indice, DBNAME_TYPE_LIGNE, str_work.s[1])
	dw_ligne_cde.setItem(li_indice, DBNAME_GROSSISTE, str_work.s[2])
	dw_ligne_cde.setItem(li_indice, DBNAME_MODE_PAIEMENT, str_work.s[3])
	dw_ligne_cde.setItem(li_indice, DBNAME_CODE_ECHEANCE, str_work.s[4])
	dw_ligne_cde.setItem(li_indice, DBNAME_REMISE_LIGNE, str_work.d[1])
	dw_ligne_cde.setItem(li_indice, DBNAME_DATE_LIVRAISON, str_work.dates[1])
	if dw_ligne_cde.getItemString(li_indice, DBNAME_PAYANT_GRATUIT) = CODE_PAYANT then
		dw_ligne_cde.setItem(li_indice, DBNAME_DATE_PRIX, str_work.dates[2])
	end if
    dw_ligne_cde.SetItem (li_indice, DBNAME_DATE_CREATION, i_tr_sql.fnv_get_datetime ())	
next
dw_ligne_cde.update()
i_nv_commande_object.fu_validation_commande_par_lignes_cde()

i_str_pass.po[2] = i_nv_commande_object
i_str_pass.s[2] = i_nv_commande_object.fu_get_numero_cde()
fw_return_fenetre_origine()


end event

event key;call super::key;/* <DESC>
      Permet de trapper les touches de fonction activées et déclencher l'évènement associé
	à la touche.
	  F11 = fin de saisie catalogue
   </DESC> */

	IF KeyDown (KeyF11!) THEN
		This.PostEvent ("ue_ok")
	END IF
end event

event ue_presave;call super::ue_presave;/* <DESC> 
      Validation de la référence et la qté saisie et création ou mise à jour
		de la ligne de commande.
		<LI> Controle si existence de la référence dans le facilite de saisie
		pour substitution de la reference
		<LI>Controle si existence d'une ligne de commande pour la référence
		sélectionnée. Si ligne existante modification de la quantite commandée avec
		celle saisie, sin on création d'une ligne de commande.
  	 	<LI> Si la quantité est à zéro , suppression de la ligne de commande.		
		<LI> Si le tarif est à zéro, positionnement du code erreur à 'Tarif inexist'.
		<LI> Valorisation de la ligne de commande
</DESC> */
// DECLARATION DES VARIABLES LOCALES
Long			l_row
String		s_article
String		s_dimension
Decimal		dec_qte
Decimal		dec_prix
String ls_catalogue

dw_1.AcceptText()
if dw_1.rowCount() = 0 then
	return
end if

l_row 			= dw_1.GetRow ()
s_article 		     = dw_1.GetItemString (l_row, DBNAME_ARTICLE)
s_dimension 	= dw_1.GetItemString (l_row, DBNAME_DIMENSION)

If IsNull(s_dimension) Or trim(s_dimension) = DONNEE_VIDE  then
	s_dimension = BLANK
End if

i_nv_reference_object.fu_controle_reference(s_article,s_dimension)
// Controle si la reference est dans le facilite de saisie
if i_nv_ligne_cde_object.fu_is_substitution_autorise( ) then
	i_nv_reference_object.fu_controle_facilite_saisie(s_article,s_dimension)
	dw_1.SetItem(l_row,DBNAME_ARTICLE,s_article)		
	dw_1.SetItem(l_row,DBNAME_DIMENSION,s_dimension)	
end if

dec_qte			= dw_1.GetItemDecimal(l_row, DBNAME_QTE)
ls_catalogue    = dw_1.getItemString(l_row,DBNAME_CODE_CATALOGUE)

if i_b_prix_normal  then
	dec_prix		= dw_1.GetItemDecimal(l_row, DBNAME_PRIX_ARTICLE)
else 
	dec_prix		= dw_1.GetItemDecimal(l_row, DBNAME_PRIX_CATALOGUE)
end if

if isNull(dec_prix) then
	dec_prix = 0
end if

if dec_qte < 0 then
	messagebox(this.title, g_nv_traduction.get_traduction(QUANTITE_ERRONE),StopSign!, ok!,1)
	return
end if

//1- On controle s'il ne s'agit pas de modification de qte
boolean lb_existe_deja = false
for l_row = 1 to dw_ligne_cde.RowCount()
	if trim(dw_ligne_cde.getItemString(l_row, DBNAME_ARTICLE)) = trim(s_article) and &
	   trim(dw_ligne_cde.getItemString(l_row, DBNAME_DIMENSION)) = trim(s_dimension) then
		lb_existe_deja = true
		exit
	end if
next

if lb_existe_deja and dec_qte = 0 then
   dw_ligne_cde.deleterow(l_row)	
   dw_ligne_cde.update()
   return
end if

if dec_qte = 0 then
	return
end if

// creation de la ligne de cde
if not  lb_existe_deja then
    l_row = dw_ligne_cde.insertRow(0)
end if

dw_ligne_cde.setItem(l_row, DBNAME_ARTICLE, s_article)
dw_ligne_cde.setItem(l_row, DBNAME_DIMENSION, s_dimension)
dw_ligne_cde.setItem(l_row, DBNAME_QTE, dec_qte)
dw_ligne_cde.setItem(l_row, DBNAME_NUM_LIGNE, i_nv_ligne_cde_object.fu_get_nouveau_numero_ligne( ))
dw_ligne_cde.setItem(l_row, DBNAME_TARIF, dec_prix)
dw_ligne_cde.setItem(l_row,DBNAME_CODE_CATALOGUE,ls_catalogue)
dw_ligne_cde.SetItem(l_row, DBNAME_DATE_CREATION, i_tr_sql.fnv_get_datetime ())	
dw_ligne_cde.setItem(l_row, DBNAME_QTE_UN, dec_qte)

if dec_prix = 0 then
  dw_ligne_cde.SetItem (l_row, DBNAME_CODE_ERREUR_LIGNE, CODE_TARIF_INEXISTANT)
end if

if not i_b_prix_normal then
	dw_ligne_cde.setItem (l_row,DBNAME_TYPE_SAISIE, CODE_SAISIE_PREVENTE)
end if

datetime ldte_dispo
    ldte_dispo =  i_nv_reference_object.fu_get_date_dispo(i_nv_commande_object.fu_get_marche())
    if mid(string(ldte_dispo),1,10) <>  "01/01/1900" then
       dw_ligne_cde.SetItem (l_row,"DTDISPO",ldte_dispo)
      end if
dw_ligne_cde.update()

i_nv_commande_object.fu_validation_par_ligne_catalogue( )
i_nv_ligne_cde_object.fu_calcul_montant_ligne(dw_ligne_cde,l_row)
end event

on w_saisie_catalogue.create
int iCurrent
call super::create
this.pb_echap=create pb_echap
this.pb_ok=create pb_ok
this.pb_changer=create pb_changer
this.dw_ligne_cde=create dw_ligne_cde
this.r_3=create r_3
this.r_1=create r_1
this.r_2=create r_2
this.st_1=create st_1
this.st_2=create st_2
this.st_cb=create st_cb
this.em_cb=create em_cb
this.code_barre_t=create code_barre_t
this.st_qte_cb=create st_qte_cb
this.sle_qte_cb=create sle_qte_cb
this.pb_etiquette=create pb_etiquette
this.pb_annul_cb=create pb_annul_cb
this.r_cb=create r_cb
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_echap
this.Control[iCurrent+2]=this.pb_ok
this.Control[iCurrent+3]=this.pb_changer
this.Control[iCurrent+4]=this.dw_ligne_cde
this.Control[iCurrent+5]=this.r_3
this.Control[iCurrent+6]=this.r_1
this.Control[iCurrent+7]=this.r_2
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.st_cb
this.Control[iCurrent+11]=this.em_cb
this.Control[iCurrent+12]=this.code_barre_t
this.Control[iCurrent+13]=this.st_qte_cb
this.Control[iCurrent+14]=this.sle_qte_cb
this.Control[iCurrent+15]=this.pb_etiquette
this.Control[iCurrent+16]=this.pb_annul_cb
this.Control[iCurrent+17]=this.r_cb
end on

on w_saisie_catalogue.destroy
call super::destroy
destroy(this.pb_echap)
destroy(this.pb_ok)
destroy(this.pb_changer)
destroy(this.dw_ligne_cde)
destroy(this.r_3)
destroy(this.r_1)
destroy(this.r_2)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_cb)
destroy(this.em_cb)
destroy(this.code_barre_t)
destroy(this.st_qte_cb)
destroy(this.sle_qte_cb)
destroy(this.pb_etiquette)
destroy(this.pb_annul_cb)
destroy(this.r_cb)
end on

event ue_close;/* <DESC>
      Fermeture de la fenetre sans saisie des conditions puis retour à la fenêtre d'origine
	</DESC> */
//override ancestor script
i_str_pass.po[2] = i_nv_commande_object
i_str_pass.s_action = ACTION_OK
i_b_canceled = TRUE
fw_return_fenetre_origine()
end event

event ue_detect_change;/* <DESC>
     Overwrite du script de l'ancetre
    </DESC> */
// overwrite

message.doubleparm = 2
end event

event closequery;/* <DESC>
     Overwrite le script de l'ancetre
   </DESC> */
// OverWrite
end event

event ue_save;/* <DESC>
Overwrite du script de l'ancetre
</DESC> */
// overwrite 
end event

type uo_statusbar from w_a_mas_det`uo_statusbar within w_saisie_catalogue
end type

type dw_1 from w_a_mas_det`dw_1 within w_saisie_catalogue
string tag = "A_TRADUIRE"
integer x = 37
integer y = 684
integer width = 3465
integer height = 1088
string dataobject = "d_detail_catalogue"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event dw_1::clicked;call super::clicked;/* <DESC>
      Si l'entete de la colonne reference ou page est sélectionné, on effectue
		un tri sur la colonne.
   </DESC> */
// ---------------------------------------
// Déclaration des variables locales
// ---------------------------------------
	String 	s_col_name
	String	s_type_tri

// ---------------------------------------------------
// Tri sur l'entête de colonne (ajout au tri en cours)
// ---------------------------------------------------
	IF Left (dw_1.GetBandAtPointer ( ), 7) = "header~t" THEN

		IF Not IsNull (i_s_objet) THEN
			dw_1.Modify (i_s_objet + ".border='0'")
		END IF

		i_s_objet = dw_1.GetObjectAtPointer ()
		i_s_objet = Left (i_s_objet, Pos (i_s_objet, "~t") - 1)
		s_col_name = Left (i_s_objet, Pos (i_s_objet, "_t") - 1)

	// 3d lowered border
		CHOOSE CASE s_col_name
			CASE "artae000"
				dw_1.SetSort ("artae000 A, groae000 A, nuaae000 A")
			CASE "numaepag"
				dw_1.SetSort ("numaepag A, artae000 A, groae000 A, nuaae000 A")
			CASE ELSE
				RETURN
		END CHOOSE

		dw_1.Modify (i_s_objet + ".border='5'")
		dw_1.Sort ()
		dw_1.PostEvent (RowFocusChanged!)

	// 3d raised border
		dw_1.Modify (i_s_objet + ".border='6'")

	END IF
end event

event dw_1::we_dwnkey;call super::we_dwnkey;/* <DESC> 
    Permet d'effectuer le trigger KEY de la fenetre
	 </DESC> */
	f_key(Parent)
end event

event dw_1::itemchanged;call super::itemchanged;/* <DESC>
      permet d'effectuer la mise à jour de la ligne sélectionnée en cas  de changement
		de ligne
   </DESC> */
	Parent.TriggerEvent ("ue_presave")
end event

event dw_1::we_dwnprocessenter;call super::we_dwnprocessenter;/* <DESC>
     Permet d'effectuer le changement de ligne lors de l'activation de la touche Entree
	  </DESC> */
	IF dw_1.GetRow () <> dw_1.RowCount () THEN
		Send(Handle(This),256,9,Long(0,0))
		Return 1
	END IF
end event

type dw_mas from w_a_mas_det`dw_mas within w_saisie_catalogue
event mousemove pbm_mousemove
string tag = "A_TRADUIRE"
integer x = 78
integer y = 28
integer width = 2939
integer height = 524
integer taborder = 0
string dataobject = "d_entete_saisie_cde"
borderstyle borderstyle = styleshadowbox!
end type

event dw_mas::mousemove;if not isvalid(itooltip) then
	itooltip = create n_tooltip_mgr
end if
itooltip.of_mousemove_notify(parent, this, getobjectatpointer(), this.x + xpos, this.y + ypos)
end event

type pb_echap from u_pba_echap within w_saisie_catalogue
integer x = 1819
integer y = 1816
integer width = 375
integer taborder = 0
string picturename = "c:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type pb_ok from u_pba_ok within w_saisie_catalogue
integer x = 709
integer y = 1808
integer width = 398
integer taborder = 0
string text = "Valid. F11"
boolean default = false
string picturename = "c:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_changer from u_pba_chge_sel within w_saisie_catalogue
integer x = 1280
integer y = 1808
integer width = 393
integer taborder = 0
string picturename = "c:\appscir\Erfvmr_diva\Image\pb_chgmt.bmp"
vtextalign vtextalign = multiline!
end type

type dw_ligne_cde from u_dw_udim within w_saisie_catalogue
boolean visible = false
integer x = 3081
integer y = 40
integer width = 325
integer height = 192
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_ligne_cde_catalogue"
end type

type r_3 from rectangle within w_saisie_catalogue
integer linethickness = 4
long fillcolor = 12632256
integer x = 608
integer y = 928
integer width = 1883
integer height = 316
end type

type r_1 from rectangle within w_saisie_catalogue
integer linethickness = 4
long fillcolor = 16777215
integer x = 891
integer y = 1080
integer width = 1248
integer height = 76
end type

type r_2 from rectangle within w_saisie_catalogue
integer linethickness = 4
long fillcolor = 16711680
integer x = 891
integer y = 1080
integer width = 41
integer height = 72
end type

type st_1 from statictext within w_saisie_catalogue
integer x = 635
integer y = 976
integer width = 1760
integer height = 88
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Veuillez patienter , création des lignes de la commande en cours"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_saisie_catalogue
string tag = "0%"
integer x = 1435
integer y = 1084
integer width = 133
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 16777215
string text = "none"
long bordercolor = 16711680
boolean focusrectangle = false
end type

type st_cb from statictext within w_saisie_catalogue
integer x = 3104
integer y = 340
integer width = 357
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "CB"
alignment alignment = center!
long bordercolor = 12632256
boolean focusrectangle = false
end type

type em_cb from u_ema within w_saisie_catalogue
event ue_ctrl_cb ( )
accessiblerole accessiblerole = sliderrole!
integer x = 3479
integer y = 324
integer width = 576
integer height = 84
integer taborder = 130
boolean bringtotop = true
integer textsize = -8
textcase textcase = upper!
boolean autoskip = true
end type

event modified;call super::modified;if this.text <> "" and len( this.text) > 0 then 
	is_code_barre= this.text
	this.text = ""
    parent.TriggerEvent ("ue_ctrl_codebarre")
end if
end event

type code_barre_t from statictext within w_saisie_catalogue
integer x = 3141
integer y = 216
integer width = 832
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Saisie par Code Barre"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_qte_cb from statictext within w_saisie_catalogue
integer x = 3104
integer y = 424
integer width = 366
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Qté commandée"
alignment alignment = center!
long bordercolor = 12632256
boolean focusrectangle = false
end type

type sle_qte_cb from singlelineedit within w_saisie_catalogue
integer x = 3488
integer y = 416
integer width = 338
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "1"
borderstyle borderstyle = stylelowered!
end type

type pb_etiquette from u_pba_etiquette within w_saisie_catalogue
event ue_saisie_cb ( )
integer x = 2249
integer y = 1820
integer width = 329
integer height = 164
integer taborder = 80
boolean bringtotop = true
string text = "."
boolean flatstyle = false
string picturename = "c:\appscir\Erfvmr_diva\Image\etiquettescb.jpg"
string disabledname = "c:\appscir\Erfvmr_diva\Image\etiquettescb.jpg"
end type

event ue_saisie_cb();em_cb.text=""
em_cb.setFocus()

if  i_b_saisie_cb then
   i_b_saisie_cb=false
else
   i_b_saisie_cb=true
end if

if i_b_saisie_cb then
	pb_annul_cb.visible = true
	pb_etiquette.visible =false
else
	pb_annul_cb.visible = false
	pb_etiquette.visible =true
	dw_1.setFocus()
end if
end event

event constructor;call super::constructor;// --------------------------------------
// Déclenche l'évènement de la fenêtre
// --------------------------------------
	fu_setevent ("ue_saisie_cb")

	fu_set_microhelp ("Saisie par code barre")
end event

type pb_annul_cb from u_pba_etiquette within w_saisie_catalogue
boolean visible = false
integer x = 2249
integer y = 1820
integer width = 329
integer height = 164
integer taborder = 100
boolean bringtotop = true
string text = "."
boolean flatstyle = false
string picturename = "c:\appscir\Erfvmr_diva\Image\suppressioncb.jpg"
string disabledname = "C:\Users\A014446\Documents\PowerBuilder\12.5\Erfvmr_diva\Image\suppressioncb.jpg"
end type

type r_cb from rectangle within w_saisie_catalogue
long linecolor = 16711680
integer linethickness = 6
long fillcolor = 12632256
integer x = 3077
integer y = 300
integer width = 1033
integer height = 224
end type

