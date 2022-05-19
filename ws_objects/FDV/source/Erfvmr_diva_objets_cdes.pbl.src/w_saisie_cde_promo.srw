$PBExportHeader$w_saisie_cde_promo.srw
$PBExportComments$Saisie des lignes de commande promotionnelles
forward
global type w_saisie_cde_promo from w_a_udim_su
end type
type dw_mas from u_dwa within w_saisie_cde_promo
end type
type sle_promo from singlelineedit within w_saisie_cde_promo
end type
type npraeact_15_t from statictext within w_saisie_cde_promo
end type
type rb_simple from u_rba within w_saisie_cde_promo
end type
type rb_rapide from u_rba within w_saisie_cde_promo
end type
type gb_mode_saisie from groupbox within w_saisie_cde_promo
end type
type mt_brut_ht_promo_t from statictext within w_saisie_cde_promo
end type
type dw_condition from u_dw_q within w_saisie_cde_promo
end type
type dw_publi_promo from u_dwa within w_saisie_cde_promo
end type
type qt_gratuit_t from statictext within w_saisie_cde_promo
end type
type sle_montant from u_slea within w_saisie_cde_promo
end type
type sle_qte_gratuite from u_slea within w_saisie_cde_promo
end type
type sle_qte_payante from u_slea within w_saisie_cde_promo
end type
type qt_payant_t from statictext within w_saisie_cde_promo
end type
type pb_ok from u_pba_ok within w_saisie_cde_promo
end type
type pb_echap from u_pba_echap within w_saisie_cde_promo
end type
type pb_supprim from u_pba_supprim within w_saisie_cde_promo
end type
type pb_art_nua from u_pba_art_nua within w_saisie_cde_promo
end type
type pb_modalites from u_pba_modalite_promo within w_saisie_cde_promo
end type
type pb_gratuit from u_pba_gratuit within w_saisie_cde_promo
end type
type pb_rech_ref from u_pba_recherche_ref within w_saisie_cde_promo
end type
type pb_nuance from u_pba_art_nua within w_saisie_cde_promo
end type
type st_cb from statictext within w_saisie_cde_promo
end type
type em_cb from u_ema within w_saisie_cde_promo
end type
type code_barre_t from statictext within w_saisie_cde_promo
end type
type st_qte_cb from statictext within w_saisie_cde_promo
end type
type pb_annul_cb from u_pba_etiquette within w_saisie_cde_promo
end type
type pb_etiquette from u_pba_etiquette within w_saisie_cde_promo
end type
type sle_qte_cb from singlelineedit within w_saisie_cde_promo
end type
type r_cb from rectangle within w_saisie_cde_promo
end type
end forward

global type w_saisie_cde_promo from w_a_udim_su
string tag = "SAISIE_PROMOTION"
integer x = 0
integer y = 0
integer width = 4718
integer height = 2040
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = child!
windowstate windowstate = maximized!
long backcolor = 12632256
boolean ib_statusbar_visible = true
event ue_ctrl pbm_custom41
event ue_validation pbm_custom46
event ue_annul_promo pbm_custom47
event ue_modalite_promo pbm_custom48
event ue_gratuit pbm_custom60
event ue_article_dimension ( )
event ue_delete_ligne_supprimee ( )
event ue_saisie_cb ( )
event ue_ctrl_codebarre ( )
dw_mas dw_mas
sle_promo sle_promo
npraeact_15_t npraeact_15_t
rb_simple rb_simple
rb_rapide rb_rapide
gb_mode_saisie gb_mode_saisie
mt_brut_ht_promo_t mt_brut_ht_promo_t
dw_condition dw_condition
dw_publi_promo dw_publi_promo
qt_gratuit_t qt_gratuit_t
sle_montant sle_montant
sle_qte_gratuite sle_qte_gratuite
sle_qte_payante sle_qte_payante
qt_payant_t qt_payant_t
pb_ok pb_ok
pb_echap pb_echap
pb_supprim pb_supprim
pb_art_nua pb_art_nua
pb_modalites pb_modalites
pb_gratuit pb_gratuit
pb_rech_ref pb_rech_ref
pb_nuance pb_nuance
st_cb st_cb
em_cb em_cb
code_barre_t code_barre_t
st_qte_cb st_qte_cb
pb_annul_cb pb_annul_cb
pb_etiquette pb_etiquette
sle_qte_cb sle_qte_cb
r_cb r_cb
end type
global w_saisie_cde_promo w_saisie_cde_promo

type variables
nv_commande_object 	i_nv_commande_object
nv_ligne_cde_object 	i_nv_ligne_cde_object
n_tooltip_mgr 			itooltip

// Indique si la saisie est contrôlée ou non
boolean		i_b_controle = true

// Indique que l'entete de cde vient d'être ouverte
boolean		i_b_entete_cde = False

// 1 ere colonne dans l'odre de tabulation
String		i_s_tab_one

// Conditions de la promotion
Str_pass		i_str_pass_condition

// Indique si une suppression de ligne est en cours
Boolean		i_b_delete_ligne
Boolean		i_b_mode_nuance
Long			i_l_ligne_encours_controle
String is_fenetre_origine= BLANK

boolean					i_b_erreur_sur_ligne = false     // Permet de savoir si une erreur a été détectéé lors du controle
Decimal     				id_remise = 0  						// Contitent la nouvelle remise
Boolean					i_b_insert_ligne  = FALSE        // Permet de savoir si une nouvelle à été insérée dans la datawindow
Boolean 					i_b_mode_ano  = FALSE			// Permet de savoir si on est mode affichage des lignes en anomalie

String is_code_barre
boolean  i_b_saisie_cb

nv_client_object 		i_nv_client_object
end variables

forward prototypes
public function integer fw_calcul_montant ()
public subroutine fw_suppression_ligne_qte_zero ()
public subroutine fw_sauvegarde_info_livraison ()
public function boolean fw_process_ligne ()
public subroutine fw_update_entete ()
end prototypes

event ue_validation;/* <DESC>
	Validation des lignes de commande en fin de saisie et réactualisaqtion des éléments de l'entête de la commande
	 </DESC> */
 setPointer(Hourglass!)
i_nv_ligne_cde_object.fu_validation_complete(dw_1)
i_nv_commande_object.fu_validation_commande_par_lignes_cde()
setPointer(Arrow!)

end event

event ue_annul_promo;/*  <DESC>
 Annulation de la promotion saisie, les lignes de commande saisies passent en lignes
 de commande normales. Cette annulation est effectuée car la demande d'annulation a
 été effectuée lors de l'affichage des publi promo à la validation de fin de saisie.
 Les lignes gratuites passent en payantes
 - Code promotion = ""
 - Code produit gratuit = '0'
 - Revalorisation des lignes
</DESC> */

Long			l_nb_row
Long			l_row
dw_1.AcceptText ()

for l_row = 1 to dw_1.rowCount()
	dw_1.SetItem (l_row, DBNAME_CODE_PROMO, BLANK)
	dw_1.SetItem (l_row, DBNAME_TYPE_SAISIE, CODE_SAISIE_SIMPLE)
	dw_1.SetItem (l_row, DBNAME_PAYANT_GRATUIT, CODE_PAYANT)		
next

IF dw_1.Update () = -1 THEN
	i_b_update_status = FALSE
ELSE
	i_b_update_status = TRUE
END IF

//fw_update_entete()
end event

event ue_modalite_promo;/* <DESC> 
       Permet d'afficher ou de cacher les modalités de la promotion
   </DESC> */

	If pb_modalites.text = "&Modalités" then
		dw_condition.Visible	=	True
		dw_1.SetFocus()
		pb_modalites.text		=	"Caché &Mod"
	Else
		dw_condition.Visible	=	False
		dw_1.SetFocus()
		pb_modalites.text		=	"&Modalités"
	End if
end event

event ue_gratuit;/* <DESC>
 Passage d'une ligne de commande payante en ligne de commande gratuite et inversement
 <LI> Controle que des lignes soient selectionnées
 <LI> Les lignes de commandes dites promotionnelles sélectionnées ne sont pas impactées
 <LI> pour chaque ligne mise à jour des informatios:
<LI><LI>	 Payant --> Gratuit
	       Seuls les articles étant définis comme gratuit dans la pormotion peuvent être passés en gratuit
  		  les autres restent payant.
   	        Code gratuit = G
		   Code Erreur Ligne à blanc
 <LI><LI>	 Gratuit --> Payant
   	        Code gratuit = P
		   Recherche du tarif de la référence de la ligne
		   Si aucun tarif trouvé, positionne le code erreur de la ligne à tarif inexistant
 <LI> valorisation de la ligne
	
- en fin de mise à jour,revalorisation de la commande
</DESC> */

Long			l_nb_select
Long			l_row
Integer		i
Str_pass		str_work

DateTime		dt_jour
Datastore   ds_article_gratuit
Long			l_nbr_row

ds_article_gratuit = CREATE Datastore
ds_article_gratuit.DataObject = "d_ref_gratuite_promo"
ds_article_gratuit.setTransObject(sqlca)

// CONTROLE NBR DE LIGNES SELECTIONNEES
l_nb_select = dw_1.fu_get_selected_count ()
IF l_nb_select = 0 THEN
	messagebox (This.title, g_nv_traduction.get_traduction(SELECTION_OBLIGATOIRE), Information!,Ok!,1)
	dw_1.SetFocus ()
	RETURN
END IF

dt_jour	= i_tr_sql.fnv_get_datetime ()
l_row 	= dw_1.GetSelectedRow (0)
DO WHILE l_row > 0
	// SI LIGNES GRATUITES PASSENT EN PAYANTES 
	IF dw_1.GetItemString (l_row, DBNAME_PAYANT_GRATUIT) = CODE_GRATUIT THEN
		dw_1.SetItem (l_row, DBNAME_PAYANT_GRATUIT, CODE_PAYANT)		
		i_nv_ligne_cde_object.fu_get_tarif_ligne	(l_row, dw_1, true)
          i_nv_ligne_cde_object.fu_calcul_montant_ligne(dw_1, l_row)
	// SI LIGNES PAYANTES PASSENT EN GRATUITES SI ARTICLE DEFINI COMME GRATUIt
	// DANS LA PROMO
	else
		if ds_article_gratuit.retrieve(i_str_pass.s[3], dw_1.GetItemString (l_row,DBNAME_ARTICLE) + "%") = -1 then
			f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
		end if
		if ds_article_gratuit.rowCount() > 0 then
			dw_1.SetItem (l_row, DBNAME_PAYANT_GRATUIT, CODE_GRATUIT)
		      i_nv_ligne_cde_object.fu_calcul_montant_ligne(dw_1, l_row)
		end if		
	end if
	
	i = l_row
	l_row = dw_1.GetSelectedRow (i)	
LOOP

dw_mas.retrieve(i_nv_commande_object.fu_get_numero_cde(),g_nv_come9par.get_code_langue())

dw_1.update ()
dw_1.SetFocus ()
fw_calcul_montant()

destroy ds_article_gratuit
end event

event ue_article_dimension();/* <DESC> 
Passage de la saisie Article,Dimension et inversement
 Ceci permet de forcer le positionnement du curseur lors de la création 
 d'une nouvelle sur l'article ou la dimension
</DESC> */
IF i_b_mode_nuance THEN
	pb_art_nua.visible = true
	pb_nuance.visible = false
	i_b_mode_nuance			=	False
	dw_1.SetColumn(DBNAME_ARTICLE)
	i_s_tab_one 				= DBNAME_ARTICLE
else
     pb_art_nua.visible = false
	pb_nuance.visible = true
	i_b_mode_nuance		  =	True
	dw_1.SetColumn(DBNAME_DIMENSION)
	i_s_tab_one 			  = DBNAME_DIMENSION		
END IF

dw_1.SetFocus ()
end event

event ue_delete_ligne_supprimee();/* <DESC>
        Permet de supprimer la ligne si celle ci a été positionnée comme supprimer lors du controle de la ligne
  	   de commande. Il s'agit de ligne ayant soit étant un doublon, soit  une référence inexistante et pour laquelle
		  l'utilisateur a répondu qu'il ne souhaitait pas conserver la ligne.
   </DESC> */

// la ligne est  déjà supprimée
if i_b_delete_ligne then
	return
end if

if i_l_ligne_encours_controle > dw_1.rowCount() then
		if i_b_saisie_cb then
		em_cb.text=""
		em_cb.setFocus()
     end if
	return
end if

// le code mise à jour de la ligne est  a supprimer
if dw_1.getItemString(i_l_ligne_encours_controle,DBNAME_CODE_MAJ) = CODE_SUPPRESSION then
		// suppression de la ligne
		i_b_delete_ligne = true
		dw_1.deleteRow(i_l_ligne_encours_controle)
		i_b_delete_ligne = false

		dw_1.SetFocus ()
		if dw_1.rowCount() = 0 then
			dw_1.insertRow(0)
		end if
		dw_1.ScrollToRow(dw_1.RowCount())
//		fw_alimentation_nbr_ligne()
	end if
	if i_b_saisie_cb then
		em_cb.text=""
		em_cb.setFocus()
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

event ue_ctrl_codebarre();// controle du code barre
//
// 1- recherche si exitence du code barre dans la table des code barres.
//              - si code barre non trouvé, erreur 
//              - si code barre trouvé rattaché à une seule référence, valdiation du controle
//            2  - si code barre trouvé mais plusieurs références rattachées, 
//                          recherche si existence d'une référence déinifie au niveau pour le code barre
//                          - Si trouve, la référence de la ligne de commande sera alimentée par celle trouvée
//                       3   - Si non trouve, recherche si exitence d'une référence au niveau du marché et de la grande fonction client
//                                - Si trouve, la référence de la ligne de commande sera alimentée par celle trouvée
//                             4   - Si non trouve, recherche si existence d'une référence au niveau du marché
//                                       - Si trouve, la référence de la ligne de commande sera alimentée par celle trouvée
//                                    5    - Si non trouvée, affichage des références trouves dans la table des codes barre pour pouvoir sélectionner la référence.
//
integer li_long
integer li_indice
string ls_chaine
long li_row
Decimal ld_qte
Str_pass		l_str_work
string ls_article
string ls_dimension
string ls_article_prec
Boolean lb_article_prec

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

// 1-  controle de l'existence du code barre dans la table des codes barre
nv_datastore ds_datastore
ds_datastore = create nv_datastore
ds_datastore.dataobject = "d_ctrl_codebarre"  
ds_datastore.settrans( SQLCA)

//recherche si code barre existant
 if ds_datastore.retrieve (is_code_barre) < 1 then
		destroy ds_datastore
		messagebox ("Saisie par CB", "Code barre inexistant",stopsign!,ok!)
		is_code_barre = ""
	     em_cb.setFocus()
		return
 end if
 
 if ds_datastore.rowcount( ) = 1 then
	 ls_article = ds_datastore.getitemString(1,1)
     ls_dimension = ds_datastore.getitemString(1,2)
	goto AJOUT_LIGNE_CDE
 end if
 
 lb_article_prec = false
 // recherche si article de la ligne de cde précédente se trouve dans la liste du code barre
 
 if dw_1.rowcount() > 0 then
		ls_article_prec = dw_1.getitemstring(dw_1.rowcount( )-1,DBNAME_ARTICLE)
		li_row =ds_datastore.Find (DBNAME_ARTICLE     + " ='" +  ls_article_prec     + "'", 1,ds_datastore.RowCount())
         if li_row > 0 then
			ls_article = ds_datastore.getitemstring(li_row, DBNAME_ARTICLE)
			ls_dimension = ds_datastore.getitemstring(li_row, DBNAME_DIMENSION)
			lb_article_prec = true
		end if
	end if
 
 // 2- plusieurs lignes trouvées pour le code barre
 //     recherche si code barre spcecifique pour le client de référencement.
ds_datastore = create nv_datastore
ds_datastore.dataobject = "d_rech_cab_clt"  
ds_datastore.settrans( SQLCA)

 if ds_datastore.retrieve ( i_nv_client_object.fu_get_client_generique( ) ,is_code_barre) = 1 then
	 ls_article = ds_datastore.getitemString(1,1)
     ls_dimension = ds_datastore.getitemString(1,2)
	goto AJOUT_LIGNE_CDE
 end if
 
//3-   recherche code barre spcecifique pour le client de référencement non trouve
//      alors recherche par grande fonction  
ds_datastore = create nv_datastore
ds_datastore.dataobject = "d_rech_cab_gfct"  
ds_datastore.settrans( SQLCA)

 if ds_datastore.retrieve (i_nv_client_object.fu_get_code_marche( ) , i_nv_client_object.fu_get_grande_fonction( )  ,is_code_barre) = 1 then
	    ls_article = ds_datastore.getitemString(1,1)
        ls_dimension = ds_datastore.getitemString(1,2)
		goto AJOUT_LIGNE_CDE
 end if
 
//4-   recherche code barre spcecifique pour la grande fonction non trouve
//      alors recherche par marché  
ds_datastore = create nv_datastore
ds_datastore.dataobject = "d_rech_cab_marche"  
ds_datastore.settrans( SQLCA)

 if ds_datastore.retrieve (i_nv_commande_object.fu_get_marche() ,is_code_barre) = 1 then
		ls_article = ds_datastore.getitemString(1,1)
     ls_dimension = ds_datastore.getitemString(1,2)
		goto AJOUT_LIGNE_CDE
 end if
 
 
 // pas de code barre specifique de trouver mais l'article de la ligne de commande
 // précédente trouvé 
 if lb_article_prec then
   		goto AJOUT_LIGNE_CDE
 end if
 
 // pas de CAB trouve spécifique, alors affichage de la popup de sélection de l'article commandé
l_str_work.s[1] = is_code_barre
OpenWithParm (w_selection_cab, l_str_work)	
l_str_work = Message.fnv_get_str_pass()
Message.fnv_clear_str_pass()
if l_str_work.s_action = ACTION_CANCEL then
	dw_1.SetFocus ()	
   RETURN
END IF

ls_article = l_str_work.s[1]
ls_dimension = l_str_work.s[2]

 
AJOUT_LIGNE_CDE: 
 // Ajout de la ligne de commande
 dw_1.setFocus()
 li_row = dw_1.getrow()
	  
 dw_1.setitem(li_row,"artae000",ls_article)
 dw_1.setitem(li_row,"dimaeart",ls_dimension)
 dw_1.setitem(li_row,"qteaeuve",ld_qte)
 dw_1.SetColumn ("qteaeuve")
 dw_1.setrow(li_row)
 i_b_mode_nuance = false

 i_l_ligne_encours_controle = li_row
 dw_1.triggerevent("ue_change_row")
 triggerEvent("ue_save")
 dw_1.fu_insert (0)
 i_b_insert_ligne	=	TRUE	
 dw_1.SetColumn (i_s_tab_one)
 destroy ds_datastore
  is_code_barre = ""

end event

public function integer fw_calcul_montant ();/* <DESC>
      Recalcul le motant de la promotion et rafraichi les zones montantHt
		et les quantités payantes et gratuites
   </DESC> */
Decimal{2}	d_montant
Decimal{0}	d_qte_gratuite
Decimal{0}	d_qte_payante
Long		   l_row
String      ls_payant_gratuit

For l_row	=	1	to dw_1.RowCount()
	d_montant =	d_montant +	(dw_1.GetItemDecimal(l_row,DBNAME_MONTANT_LIGNE))
	 ls_payant_gratuit = dw_1.getItemString(l_row, DBNAME_PAYANT_GRATUIT)
	if ls_payant_gratuit = CODE_PAYANT then
		d_qte_payante    = d_qte_payante + (dw_1.GetItemDecimal(l_row,DBNAME_QTE_UN))
	else
		d_qte_gratuite    = d_qte_gratuite + (dw_1.GetItemDecimal(l_row,DBNAME_QTE_UN))
	end if
Next

sle_montant.text	=	String(d_montant)
sle_qte_gratuite.text = String (d_qte_gratuite)
sle_qte_payante.text = String (d_qte_payante)

Return 0
end function

public subroutine fw_suppression_ligne_qte_zero ();/* <DESC> 
     Suppression des lignes de commande dont la quantite est = 0
	  </DESC> */
long l_row
long l_nb_row
l_nb_row = dw_1.RowCount()
l_row = 1

Do While l_row <= l_nb_row
	IF dw_1.GetItemDecimal (l_row, DBNAME_QTE) = 0 THEN
		dw_1.DeleteRow (l_row)
		l_nb_row = l_nb_row - 1
	ELSE
		l_row = l_row + 1
	END IF
LOOP
end subroutine

public subroutine fw_sauvegarde_info_livraison ();// fonction permetant de sauvegarder les éléments des lignes
// de la promotion déjà créées 

i_str_pass_condition.s[1] = dw_1.getItemString(1, DBNAME_TYPE_LIGNE)
i_str_pass_condition.s[2] = dw_1.getItemString(1, DBNAME_GROSSISTE)
i_str_pass_condition.s[3] = dw_1.getItemString(1, DBNAME_CODE_ECHEANCE)
i_str_pass_condition.s[4] = dw_1.getItemString(1, DBNAME_MODE_PAIEMENT)
i_str_pass_condition.d[1] = dw_1.getItemDecimal(1, DBNAME_REMISE_LIGNE)
i_str_pass_condition.dates[1] = Date(dw_1.getItemDateTime(1, DBNAME_DATE_LIVRAISON))
i_str_pass_condition.dates[2] = Date(dw_1.getItemDateTime(1, DBNAME_DATE_PRIX))

if trim(i_str_pass_condition.s[3]) = DONNEE_VIDE or IsNull(i_str_pass_condition.s[3]) then
	i_str_pass_condition.s[3] = i_nv_commande_object.fu_get_code_echeance()
end if

if trim(i_str_pass_condition.s[4]) = DONNEE_VIDE or IsNull(i_str_pass_condition.s[4]) then
	i_str_pass_condition.s[4] = i_nv_commande_object.fu_get_mode_paiement()
end if

if i_str_pass_condition.d[1] = 0 then
	i_str_pass_condition.d[1] = i_nv_commande_object.fu_get_remise_cde()
end if

if i_str_pass_condition.dates[1] = Date(DATE_DEFAULT_SYBASE) then
	i_str_pass_condition.dates[1] = i_nv_commande_object.fu_get_date_livraison()
end if

if i_str_pass_condition.dates[2] = Date(DATE_DEFAULT_SYBASE) then
	i_str_pass_condition.dates[2] = i_nv_commande_object.fu_get_date_prix()
end if

i_str_pass_condition.dates[3] = i_str_pass.dates[3]

end subroutine

public function boolean fw_process_ligne ();   /* <DESC>
     Executer lors de l'activation de la touche Tabulation et premet de déterminer si le curseur
	  devra ou non être positionnée sur larticle ou sur la dimension.
	Si la ligne en cours n'est pas la dernière ligne de la datawindow, passage à la zone suivante et pas
		de positionnement du curseur
	Si la colonne en cours n'est pas la quantité, pas de positionnement du curseur
	Si l'article et la dimension ne sont pas renseignés et que l'on est en mode article, repositionnement du curseur
	Si des modifications ont été effectuées  sur la ligne, on effecture le controle et la mise à jour de la ligne
	Si la ligne en cours n'est ps la dernière ligne de saisie, on se positionne sur la ligne suivante
	Si on se trouve en mode normal, et que l'on se trouve sur la dernière ligne, création d'une nouvelle ligne
	</DESC> */

// Déclaration des variables locales
string	s_article, &
		s_dimension

// EN FIN DE LIGNE INSERTION D'UNE NOUVELLE LIGNE SI LA LIGNE PRECEDENTE EST SAISIE
IF dw_1.GetRow () < dw_1.RowCount() THEN
	Send(Handle(This),256,9,Long(0,0))
	Return false
END IF

If dw_1.GetColumnName () <> DBNAME_QTE then
	Return false
End if
 
s_article	          =	Trim(dw_1.Getitemstring(dw_1.rowcount(),DBNAME_ARTICLE))
s_dimension	=	Trim(dw_1.Getitemstring(dw_1.rowcount(),DBNAME_DIMENSION))

IF  (IsNull(s_article)     OR s_article = DONNEE_VIDE ) &
AND (IsNull(s_dimension)	OR s_dimension = DONNEE_VIDE )  &
and  dw_1.getROw() = dw_1.RowCount() then
	return true
end if

dw_1.fu_insert (0)
dw_1.SetColumn (i_s_tab_one)

IF dw_1.RowCount() = 2 AND pb_art_nua.text = "&Article" THEN 
	postEvent("ue_article_dimension")
END IF

return true


end function

public subroutine fw_update_entete ();/* <DESC>
     Mise à jour de la date de mise à jour et du visteur de mise à jour sur l'entête de la commande
   </DESC>  */
i_nv_commande_object.fu_validation_par_promo()
end subroutine

event ue_presave;call super::ue_presave;long l_row 
l_row = dw_1.fu_get_itemchanged_row_num ()
i_b_erreur_sur_ligne = false

// ceci est du au fait que lorsque l'on supprime une ligne, 
// cet evenement est automatiquement déclenché pour la ligne supprimée
if i_b_delete_ligne then
	i_b_delete_ligne = False
	Message.ReturnValue = -1
	RETURN
end if

if l_row = 0 then
	Message.ReturnValue = -1
	RETURN
end if

if	l_row > dw_1.RowCount() then
	Message.ReturnValue = -1
	RETURN
end if

setPointer(Hourglass!)

// report de la remise s'il s'agit d'une nouvelle lligne
if dw_1.getItemStatus(l_row,0,primary!) = NewModified! then
	dw_1.SetItem (l_row, DBNAME_REMISE_LIGNE, id_remise)
end if

g_nv_workflow_manager.fu_set_fenetre_origine(this.Classname())
i_l_ligne_encours_controle = l_row

// controle de la ligne de commande. Si la ligne est supprimée positionner le code erreur ligne à vrai pour
// pouvoir effectuer la suppression de la ligne 
if not i_nv_ligne_cde_object.fu_controle_et_maj_ligne_cde(l_row, dw_1,i_b_mode_nuance,  false) then
     dw_1.setRow(l_row)
     i_b_erreur_sur_ligne = true
	Message.ReturnValue = -1
	setPointer(Arrow!)
	RETURN
end if

setPointer(Arrow!)

end event

event ue_init;call super::ue_init;/* <DESC>
     Initialisation de la fenêtre
	<LI> Controle si identification du client
	<LI> Création de l'object commande et extraction des informations de l'entête de la commande
	<LI> Extraction des lignes de la commande
	<LI> Initailisation de l'object nv_ligne_cde_object
   </DESC> */
integer li_retrieve

sle_qte_cb.text = "1"

i_nv_commande_object = CREATE nv_commande_object
i_nv_commande_object.fu_set_numero_cde(i_str_pass.s[2])

//i_nv_commande_object = i_str_pass.po[2]
dw_mas.setTransObject (i_tr_sql)
dw_condition.SetTransObject	(i_tr_sql)
dw_publi_promo.SetTransObject	(i_tr_sql)

// CHARGEMENT DE LA DTW DW_MAS
IF dw_mas.Retrieve (i_nv_commande_object.fu_controle_numero_cde(i_str_pass.po[1]),g_nv_come9par.get_code_langue()) = -1 THEN
 	f_dmc_error (this.title +  BLANK + DB_ERROR_MESSAGE)
END IF

nv_client_object lnv_client
lnv_client = i_str_pass.po[1]
i_nv_client_object = i_str_pass.po[1]

dw_mas.setItem(1,"alerte",lnv_client.fu_get_alerte( ))


// CHARGEMENT DE LA DTW DW_1
li_retrieve = dw_1.Retrieve (i_nv_commande_object.fu_get_numero_cde(), i_str_pass.s[3])
if li_retrieve = -1 then
	f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
end if

i_nv_ligne_cde_object = CREATE nv_ligne_cde_object
i_nv_ligne_cde_object.fu_init_info_commande(i_nv_commande_object)
i_nv_ligne_cde_object.fu_init_valeur_ligne_cde_promo(dw_1, i_str_pass.s[3])

dw_1.fu_set_selection_mode (0)
dw_1.SetFocus ()

sle_promo.Text = i_str_pass.s[04]
i_s_tab_one		 = DBNAME_ARTICLE

dw_1.ScrollToRow (dw_1.InsertRow (0))
dw_1.SetColumn (i_s_tab_one)
i_str_pass.b[1]				=  false
If li_retrieve >= 1 then
	postEvent("ue_article_dimension")
End if

dw_condition.retrieve(i_str_pass.s[3])
// sauvegarde des infos livraison
fw_sauvegarde_info_livraison()
fw_calcul_montant()


end event

event ue_ok;/* <DESC>
      Validation de la fin de saisie .
	<LI> Si existence de publi promo affichage de la fenêtre de sélection du nbr de publi promo
	a intégrée dans la commande.EN retour de cette fenêtre les options possible sont :
	<LI>		Annulation de la promotion est demandée,appel de fonction de suppression de la saisie sur promotion
	et fin de la saisie
    <LI>		La quantité de publi promo est de zéro, suppression des publi promo qui auraient déjà
	 été intégrées dans la commande sinon rajout despubli promo dans la commande
	et fin de la saisie	
	 <LI> Affichage de la fenêtre de saisie des conditions générales en passant les 
	 paramètres par défaut issues de la ligne de commande ou de l'entete de la commande
	 <LI> En retour report des conditions saisies sur l'ensemble des lignes de commandes
	 saisie à partir du catalogue.
	 <LI> Validation da la commande en reactualisant les blocages de l'entete et valorisation 
	 de la commande
	 <LI> Retour à la fenêtre d'origine.
   </DESC> */

SetPointer (HourGlass!)
// OVERRIDE SCRIPT ANCESTOR

Str_pass		str_work
long			ll_indice
long			l_row
boolean		lb_publi_promo = false

// CALCUL DU NOMBRE D'ENREGISTREMENT
dw_1.AcceptText ()
dw_1.SetRow (1)

// Suppression des lignes de commande dont la quantite est = 0
fw_suppression_ligne_qte_zero()
IF dw_1.RowCount () = 0 THEN
	messagebox (this.title, g_nv_traduction.get_traduction(PAS_LIGNE_PROMO_SAISIE) + "~r" + g_nv_traduction.get_traduction(ECHAP), & 
					Information!,Ok!,1)
	dw_1.InsertRow (0)
	dw_1.SetFocus ()
	RETURN
END IF

// ------------------------------------------
// DETAIL DE LA PROMOTION
// Les publi promo ont déjà été reportées 
// ------------------------------------------
for ll_indice = 1 to dw_1.RowCount()
	if dw_1.getItemString(ll_indice, DBNAME_TYPE_SAISIE) = CODE_SAISIE_PUBLI_PROMO then
		lb_publi_promo = true
	end if
next

IF lb_publi_promo THEN
	GoTo Saisie_condition
END IF
//
// Affichage du détail de la promo (publi promo à reporter)
// --------------------------------------------------------
str_work.s[1] = i_str_pass.s[3]
OpenWithParm (w_detail_cde_promo, str_work)
str_work = Message.fnv_get_str_pass()
Message.fnv_clear_str_pass()

if str_work.s_action = ACTION_CANCEL then
	dw_1.SetFocus ()
	RETURN	
end if

if str_work.s_action = ACTION_DELETE then
	This.TriggerEvent ("ue_annul_promo")
	goto fin
end if

if dw_publi_promo.retrieve(i_str_pass.s[3]) = -1 then
	f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
end if

if  str_work.d[1] = 0 then
	goto Saisie_condition
end if

for ll_indice = 1 to dw_publi_promo.RowCount()
	l_row = dw_1.insertRow(0)
	dw_1.setItem(l_row,DBNAME_ARTICLE, dw_publi_promo.getItemString(ll_indice, DBNAME_ARTICLE))
	dw_1.setItem(l_row,DBNAME_DIMENSION, dw_publi_promo.getItemString(ll_indice, DBNAME_DIMENSION))	
	dw_1.setItem(l_row,DBNAME_QTE, dw_publi_promo.GetItemDecimal (ll_indice, DBNAME_QTE_PUBLI_PROMO) *  str_work.d[1])
	dw_1.setItem(l_row,DBNAME_TYPE_SAISIE, CODE_SAISIE_PUBLI_PROMO)
	dw_1.setItem(l_row,DBNAME_PAYANT_GRATUIT, CODE_GRATUIT)	
	dw_1.setItem(l_row, DBNAME_NUM_LIGNE, i_nv_ligne_cde_object.fu_get_nouveau_numero_ligne( ))
	dw_1.setItem(l_row, DBNAME_CODE_MAJ, CODE_MODE_RAPIDE)
next

Saisie_condition:

i_str_pass_condition.po[1] = i_nv_commande_object
i_str_pass_condition.b[1] = true
OpenWithParm (w_conditions, i_str_pass_condition)
i_str_pass_condition = Message.fnv_get_str_pass()
Message.fnv_clear_str_pass()

if i_str_pass_condition.s_action = ACTION_CANCEL then
	dw_1.SetFocus ()
	RETURN	
end if

for ll_indice = 1 to dw_1.RowCount()
	dw_1.setItem(ll_indice, DBNAME_MODE_PAIEMENT, i_str_pass_condition.s[3])
	dw_1.setItem(ll_indice, DBNAME_CODE_ECHEANCE, i_str_pass_condition.s[4])
	dw_1.setItem(ll_indice, DBNAME_REMISE_LIGNE, i_str_pass_condition.d[1])
	dw_1.setItem(ll_indice, DBNAME_DATE_LIVRAISON, i_str_pass_condition.dates[1])
	dw_1.setItem(ll_indice, DBNAME_DATE_PRIX, i_str_pass_condition.dates[2])
   dw_1.SetItem (ll_indice, DBNAME_DATE_CREATION, i_tr_sql.fnv_get_datetime ())	
next

dw_1.update()

i_nv_commande_object.fu_maj_keepDrop_Promo(i_str_pass_condition.s[5])
fin:
// ------------------------------------------
// VALIDATION GLOBALE DE LA PROMO
// ------------------------------------------
This.TriggerEvent ("ue_validation")

// ------------------------------------------
// FIN DE COMMANDE
// ------------------------------------------
i_str_pass.s_action 	= ACTION_OK
i_b_canceled			= TRUE	
i_str_pass.po[2] = i_nv_commande_object
i_str_pass.s[2] = i_nv_commande_object.fu_get_numero_cde()

g_w_frame.fw_open_sheet (FENETRE_LIGNE_CDE,0,1,i_str_pass)
Close (This)
end event

event ue_delete;/* <DESC>
     Permet de supprimer les lignes de commande sélectionnées et de revaloriser la commande.
   </DESC> */

// OVERRIDE SCRIPT ANCESTOR

// DECLARATION DES VARIABLES LOCALES
Long	l_row,			&
		l_nb_select,	&
		i

// CONTROLE NBR DE LIGNES SELECTIONNEES
l_nb_select = dw_1.fu_get_selected_count ()
IF l_nb_select = 0 THEN
	messagebox (This.title, g_nv_traduction.get_traduction(SELECTION_OBLIGATOIRE), Information!,Ok!,1)
	dw_1.SetFocus ()
	RETURN
END IF

// SUPPRESSION DE L'ENREGISTREMENT
dw_1.TriggerEvent ("ue_presave")
dw_1.SetRow(1)
i_b_delete_ligne = TRUE
l_row = dw_1.GetSelectedRow (0)
DO WHILE l_row > 0
	dw_1.DeleteRow (l_row)
	l_row = dw_1.GetSelectedRow (0)
LOOP	

dw_1.Update ()
i_b_delete_ligne = FALSE

i_nv_ligne_cde_object.fu_validation_complete(dw_1)
i_nv_commande_object.fu_validation_commande_par_lignes_cde()

dw_mas.retrieve(i_nv_commande_object.fu_get_numero_cde(),g_nv_come9par.get_code_langue())
fw_calcul_montant()

dw_1.SetFocus ()
if dw_1.rowCount() = 0 then
	dw_1.insertRow(0)
end if
dw_1.ScrollToRow(dw_1.RowCount())
end event

event ue_save;call super::ue_save;/* <DESC> 
 si le controle des lignes s'est effectuée correctement , valorisation de la commande
 et suppression des lignes de commande supprimée
 </DESC> */
 if i_b_controle and  message.returnvalue  <>  -1 then
	setPointer(Hourglass!)
	i_nv_commande_object.fu_validation_commande_par_lignes_cde()
	dw_mas.retrieve(i_nv_commande_object.fu_get_numero_cde(),g_nv_come9par.get_code_langue())
	fw_calcul_montant()
	postEvent("ue_delete_ligne_supprimee")
	setPointer(Arrow!)
end if
setPointer(Hourglass!)

end event

event ue_cancel;/* <DESC>
    Permet de quitter l'application sans effectuer de validation de fin de saisie et
	 de revenir sur la fenêtre des lignes de commande
   </DESC> */
i_str_pass.s_action = ACTION_OK
i_b_canceled = TRUE
g_w_frame.fw_open_sheet(FENETRE_LIGNE_CDE, 0, 1, i_str_pass)
Close(this)
end event

on w_saisie_cde_promo.create
int iCurrent
call super::create
this.dw_mas=create dw_mas
this.sle_promo=create sle_promo
this.npraeact_15_t=create npraeact_15_t
this.rb_simple=create rb_simple
this.rb_rapide=create rb_rapide
this.gb_mode_saisie=create gb_mode_saisie
this.mt_brut_ht_promo_t=create mt_brut_ht_promo_t
this.dw_condition=create dw_condition
this.dw_publi_promo=create dw_publi_promo
this.qt_gratuit_t=create qt_gratuit_t
this.sle_montant=create sle_montant
this.sle_qte_gratuite=create sle_qte_gratuite
this.sle_qte_payante=create sle_qte_payante
this.qt_payant_t=create qt_payant_t
this.pb_ok=create pb_ok
this.pb_echap=create pb_echap
this.pb_supprim=create pb_supprim
this.pb_art_nua=create pb_art_nua
this.pb_modalites=create pb_modalites
this.pb_gratuit=create pb_gratuit
this.pb_rech_ref=create pb_rech_ref
this.pb_nuance=create pb_nuance
this.st_cb=create st_cb
this.em_cb=create em_cb
this.code_barre_t=create code_barre_t
this.st_qte_cb=create st_qte_cb
this.pb_annul_cb=create pb_annul_cb
this.pb_etiquette=create pb_etiquette
this.sle_qte_cb=create sle_qte_cb
this.r_cb=create r_cb
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_mas
this.Control[iCurrent+2]=this.sle_promo
this.Control[iCurrent+3]=this.npraeact_15_t
this.Control[iCurrent+4]=this.rb_simple
this.Control[iCurrent+5]=this.rb_rapide
this.Control[iCurrent+6]=this.gb_mode_saisie
this.Control[iCurrent+7]=this.mt_brut_ht_promo_t
this.Control[iCurrent+8]=this.dw_condition
this.Control[iCurrent+9]=this.dw_publi_promo
this.Control[iCurrent+10]=this.qt_gratuit_t
this.Control[iCurrent+11]=this.sle_montant
this.Control[iCurrent+12]=this.sle_qte_gratuite
this.Control[iCurrent+13]=this.sle_qte_payante
this.Control[iCurrent+14]=this.qt_payant_t
this.Control[iCurrent+15]=this.pb_ok
this.Control[iCurrent+16]=this.pb_echap
this.Control[iCurrent+17]=this.pb_supprim
this.Control[iCurrent+18]=this.pb_art_nua
this.Control[iCurrent+19]=this.pb_modalites
this.Control[iCurrent+20]=this.pb_gratuit
this.Control[iCurrent+21]=this.pb_rech_ref
this.Control[iCurrent+22]=this.pb_nuance
this.Control[iCurrent+23]=this.st_cb
this.Control[iCurrent+24]=this.em_cb
this.Control[iCurrent+25]=this.code_barre_t
this.Control[iCurrent+26]=this.st_qte_cb
this.Control[iCurrent+27]=this.pb_annul_cb
this.Control[iCurrent+28]=this.pb_etiquette
this.Control[iCurrent+29]=this.sle_qte_cb
this.Control[iCurrent+30]=this.r_cb
end on

on w_saisie_cde_promo.destroy
call super::destroy
destroy(this.dw_mas)
destroy(this.sle_promo)
destroy(this.npraeact_15_t)
destroy(this.rb_simple)
destroy(this.rb_rapide)
destroy(this.gb_mode_saisie)
destroy(this.mt_brut_ht_promo_t)
destroy(this.dw_condition)
destroy(this.dw_publi_promo)
destroy(this.qt_gratuit_t)
destroy(this.sle_montant)
destroy(this.sle_qte_gratuite)
destroy(this.sle_qte_payante)
destroy(this.qt_payant_t)
destroy(this.pb_ok)
destroy(this.pb_echap)
destroy(this.pb_supprim)
destroy(this.pb_art_nua)
destroy(this.pb_modalites)
destroy(this.pb_gratuit)
destroy(this.pb_rech_ref)
destroy(this.pb_nuance)
destroy(this.st_cb)
destroy(this.em_cb)
destroy(this.code_barre_t)
destroy(this.st_qte_cb)
destroy(this.pb_annul_cb)
destroy(this.pb_etiquette)
destroy(this.sle_qte_cb)
destroy(this.r_cb)
end on

event key;call super::key;/* <DESC>
      Permet de trapper les touches de fonction activées et déclencher l'évènement associé
	à la touche.
	  F11 = Validation de fin de saisie
   </DESC> */
	IF KeyDown (KeyF11!) THEN
		This.PostEvent ("ue_ok")
	END IF

end event

event open;call super::open;/* <DESC>
    Sauvegarde de la fenêtre d'origine
   </DESC> */
is_fenetre_origine = g_nv_workflow_manager.fu_get_fenetre_origine()


end event

event ue_close;/* <DESC>
     Permet de quitter la saisie après sauvegarde de la ligne en cours
   </DESC> */
//override ancestor script

i_b_canceled = TRUE

IF dw_1.fu_changed() THEN
	THIS.Triggerevent("ue_save")
END IF

Close(THIS)
end event

event closequery;/* <DESC>
     Overwrite du script de l'ancetre
	  </DESC> */
end event

event ue_search;call super::ue_search;/* <DESC>
    Permet d'effectuer la recherche d'une référence de vente pour alimenter la saisie de la ligne avec
	 la référence de vente sélectionnée.Ceci se fait par appel de la fenetre de liste des références en
	 passant les éléments tarifs de la commande
   </DESC> */
str_pass l_str_work
Long ll_row
// Recherche du tarif de l'article
l_str_work.s[1] = "."
l_str_work.s[2] = DONNEE_VIDE
l_str_work.s[3] = DONNEE_VIDE
l_str_work.s[4] = i_nv_commande_object.fu_get_marche()
l_str_work.s[5] = i_nv_commande_object.fu_get_liste_prix()
l_str_work.s[6] = i_nv_commande_object.fu_get_devise()
l_str_work.s[7] = this.className()
l_str_work.b[1] = false

OpenWithParm (w_liste_reference_tarifs, l_str_work)
l_str_work = Message.fnv_get_str_pass()
Message.fnv_clear_str_pass()
if  l_str_work.s_action <> ACTION_OK then
	 return
end if

ll_row = dw_1.getRow()
i_l_ligne_encours_controle = ll_row
dw_1.setItem(ll_row,DBNAME_ARTICLE, l_str_work.s[1])
dw_1.setItem(ll_row,DBNAME_DIMENSION, l_str_work.s[2])
dw_1.setItem(ll_row,DBNAME_TARIF, l_str_work.d[1])
dw_1.setcolumn (DBNAME_QTE)
dw_1.triggerevent("ue_change_row")
end event

type uo_statusbar from w_a_udim_su`uo_statusbar within w_saisie_cde_promo
integer x = 0
integer y = 1852
end type

type dw_1 from w_a_udim_su`dw_1 within w_saisie_cde_promo
event ue_repositionne_curseur ( )
event ue_repostionne_curseur ( )
event ue_change_row ( )
string tag = "A_TRADUIRE"
integer x = 439
integer y = 712
integer width = 2135
integer height = 980
integer taborder = 20
string dataobject = "d_ligne_cde_promo"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event dw_1::ue_repostionne_curseur();/* <DESC>
     Permet de repositionner le curseur soit sur l'article ou sur la dimension
   </DESC> */
dw_1.SetColumn (i_s_tab_one)
dw_1.setFocus()
end event

event dw_1::ue_change_row();/* <DESC>
    Permet de changer le numero de la ligne en cours de changement
   </DESC> */
i_l_itemchanged_row_num = i_l_ligne_encours_controle
end event

event dw_1::we_dwnprocessenter;call super::we_dwnprocessenter;/* <DESC>
      Executer lors de l'activation de la touche Entrée
	Si la colonne en cours n'est pas la quantité, passage à la zone suivante
	Si l'article et la dimension ne sont pas renseignés et que l'on est en mode article, repositionnement du curseur
		sur l'article
	Si des modifications ont été effectuées  sur la ligne, on effecture le controle et la mise à jour de la ligne
	Si la ligne en cours n'est ps la dernière ligne de saisie, on se positionne sur la ligne suivante
	Si on se trouve en mode normal, et que l'on se trouve sur la dernière ligne, création d'une nouvelle ligne
   </DESC> */
// Déclaration des variables locales
string	s_article, &
		s_dimension
long ll_row

If dw_1.GetColumnName () <> DBNAME_QTE then
	Send(Handle(This),256,9,Long(0,0))
	Return 1
End if

ll_row = dw_1.getRow()
s_article	          =	Trim(dw_1.Getitemstring(ll_row,DBNAME_ARTICLE))
s_dimension	     =	Trim(dw_1.Getitemstring(ll_row,DBNAME_DIMENSION))

IF  (IsNull(s_article)     OR s_article = DONNEE_VIDE ) &
AND (IsNull(s_dimension)	OR s_dimension = DONNEE_VIDE ) &
AND not i_b_mode_nuance THEN
	dw_1.SetColumn (i_s_tab_one)
	return
end if

if fu_changed() then
	parent.triggerEvent("ue_save")
	if i_b_erreur_sur_ligne then
		return 1
	end if
end if

IF dw_1.GetRow () < dw_1.RowCount() THEN
	Send(Handle(This),256,9,Long(0,0))
	dw_1.SetColumn (i_s_tab_one)
	Return 1
END IF

if i_b_mode_ano then
	return 1
end if

dw_1.fu_insert (0)
i_b_insert_ligne	=	TRUE	
dw_1.SetColumn (i_s_tab_one)

IF dw_1.RowCount() = 2 AND pb_art_nua.text = "&Article"  and not(i_b_saisie_cb) THEN 
	Parent.postEvent("ue_article_dimension")
END IF

end event

event dw_1::we_dwnkey;call super::we_dwnkey;/* <DESC> 
     Permet d'effectuer le traitement en fonction de la touche de fonction activée.
	F5 --> Sélection de la ligne positionnée
	F6 --> Déselection de la ligne sélectionnée
	F7 --> Sélection de toutes les lignes  
	F8 --> Désélectin de toutes les lignes sélectionnées
	F11 --> validation compléte de la saisie des lignes de commandes
	F2 -->  Recherche de référence
	Tabulation --> positionne sur le champ suivant
   </DESC> */

// SELECTION DE LA LIGNE EN COURS
   IF KeyDown(KeyF5!) THEN
	 if dw_1.getRow() < dw_1.RowCount()  then
 		  dw_1.SelectRow(dw_1.GetRow(),TRUE)
  	 end if
  END IF

// DESELECTION DE LA LIGNE EN COURS
	IF KeyDown(KeyF6!) THEN
		dw_1.SelectRow(dw_1.GetRow(),FALSE)
	END IF

// SELECTION DE TOUTES LES LIGNES 
    IF KeyDown(KeyF7!) THEN
		dw_1.SelectRow(0,TRUE)
		dw_1.SelectRow(dw_1.RowCount(),FALSE)
	END IF

// DESELECTION DE TOUTES LES LIGNES
	IF KeyDown(KeyF8!) THEN
		dw_1.SelectRow(0,FALSE)
	END IF

// VALIDATION DES LIGNES DE COMMANDE
	IF KeyDown (KeyF11!) THEN
		Parent.PostEvent ("ue_ok")
	END IF
	
// Affichage de la fenetre de recherche d'une reference
	IF KeyDown(KeyF2!) THEN
		Parent.PostEvent ("ue_search")
	END IF
	
	// UTILISATION DE LA TOUCHE TABULATION
    boolean lb_position
	IF KeyDown(KeyTab!) THEN
		lb_position = fw_process_ligne()	
		if lb_position then
			postEvent("ue_repositionne_curseur")
		end if
	END IF	
end event

type dw_mas from u_dwa within w_saisie_cde_promo
event mousemove pbm_mousemove
string tag = "A_TRADUIRE"
integer x = 55
integer y = 20
integer width = 2917
integer height = 508
integer taborder = 0
string dataobject = "d_entete_saisie_cde"
borderstyle borderstyle = styleshadowbox!
end type

event mousemove;if not isvalid(itooltip) then
	itooltip = create n_tooltip_mgr
end if
itooltip.of_mousemove_notify(parent, this, getobjectatpointer(), this.x + xpos, this.y + ypos)
end event

type sle_promo from singlelineedit within w_saisie_cde_promo
integer x = 498
integer y = 592
integer width = 1792
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
boolean autohscroll = false
boolean displayonly = true
borderstyle borderstyle = styleshadowbox!
end type

type npraeact_15_t from statictext within w_saisie_cde_promo
integer x = 59
integer y = 592
integer width = 439
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 12632256
boolean enabled = false
string text = "Promotion  "
boolean focusrectangle = false
end type

type rb_simple from u_rba within w_saisie_cde_promo
boolean visible = false
integer x = 3081
integer y = 112
integer width = 453
integer height = 72
long backcolor = 12632256
string text = "S&imple"
boolean checked = true
end type

event clicked;call super::clicked;
	i_b_controle = True
	dw_1.SetFocus ()

end event

type rb_rapide from u_rba within w_saisie_cde_promo
boolean visible = false
integer x = 3081
integer y = 188
integer width = 448
integer height = 72
boolean bringtotop = true
long backcolor = 12632256
string text = "Ra&pide"
end type

event clicked;call super::clicked;
	i_b_controle = False
	dw_1.SetFocus ()

end event

type gb_mode_saisie from groupbox within w_saisie_cde_promo
boolean visible = false
integer x = 3017
integer y = 40
integer width = 576
integer height = 228
integer taborder = 70
integer textsize = -9
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
boolean underline = true
long textcolor = 33554432
long backcolor = 12632256
string text = "Mode Saisie"
end type

type mt_brut_ht_promo_t from statictext within w_saisie_cde_promo
integer x = 2683
integer y = 684
integer width = 800
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 128
long backcolor = 12632256
boolean enabled = false
string text = "Montant brut HT Promo"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_condition from u_dw_q within w_saisie_cde_promo
boolean visible = false
integer x = 46
integer y = 16
integer width = 2930
integer height = 464
integer taborder = 40
string dataobject = "d_condition_promo"
boolean vscrollbar = true
boolean resizable = true
end type

type dw_publi_promo from u_dwa within w_saisie_cde_promo
boolean visible = false
integer x = 2747
integer y = 1420
integer width = 466
integer height = 168
integer taborder = 0
boolean bringtotop = true
string dataobject = "d_promo_publi"
end type

type qt_gratuit_t from statictext within w_saisie_cde_promo
integer x = 2683
integer y = 864
integer width = 759
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 128
long backcolor = 12632256
boolean enabled = false
string text = "Qté gratuite totale "
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_montant from u_slea within w_saisie_cde_promo
integer x = 2793
integer y = 748
integer width = 448
integer height = 84
integer taborder = 0
boolean bringtotop = true
integer weight = 700
boolean displayonly = true
borderstyle borderstyle = styleshadowbox!
boolean righttoleft = true
end type

type sle_qte_gratuite from u_slea within w_saisie_cde_promo
integer x = 2807
integer y = 928
integer width = 448
integer height = 84
integer taborder = 0
boolean bringtotop = true
integer weight = 700
boolean displayonly = true
borderstyle borderstyle = styleshadowbox!
boolean righttoleft = true
end type

type sle_qte_payante from u_slea within w_saisie_cde_promo
integer x = 2807
integer y = 1100
integer width = 448
integer height = 84
integer taborder = 0
boolean bringtotop = true
integer weight = 700
boolean displayonly = true
borderstyle borderstyle = styleshadowbox!
boolean righttoleft = true
end type

type qt_payant_t from statictext within w_saisie_cde_promo
integer x = 2697
integer y = 1036
integer width = 745
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 128
long backcolor = 12632256
boolean enabled = false
string text = "Qté payante totale "
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_ok from u_pba_ok within w_saisie_cde_promo
integer x = 151
integer y = 1740
integer width = 320
integer height = 152
integer taborder = 0
boolean bringtotop = true
string text = "Valid. F11"
boolean default = false
string picturename = "c:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_echap from u_pba_echap within w_saisie_cde_promo
integer x = 2565
integer y = 1740
integer width = 320
integer height = 152
integer taborder = 0
boolean bringtotop = true
string picturename = "c:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type pb_supprim from u_pba_supprim within w_saisie_cde_promo
integer x = 1431
integer y = 1740
integer width = 320
integer height = 152
integer taborder = 0
boolean bringtotop = true
string text = "S&upprim"
string picturename = "c:\appscir\Erfvmr_diva\Image\pb_suppr.bmp"
end type

type pb_art_nua from u_pba_art_nua within w_saisie_cde_promo
integer x = 846
integer y = 1740
integer width = 320
integer height = 152
integer taborder = 0
boolean dragauto = false
boolean bringtotop = true
string picturename = "c:\appscir\Erfvmr_diva\Image\pb_art.bmp"
end type

type pb_modalites from u_pba_modalite_promo within w_saisie_cde_promo
integer x = 2162
integer y = 1740
integer width = 366
integer height = 152
integer taborder = 0
boolean bringtotop = true
string text = "&Modalités"
string picturename = "c:\appscir\Erfvmr_diva\Image\pbmodpro.bmp"
end type

type pb_gratuit from u_pba_gratuit within w_saisie_cde_promo
integer x = 480
integer y = 1740
integer width = 320
integer height = 152
integer taborder = 0
boolean bringtotop = true
string text = "&Gratuit  Payant"
string picturename = "c:\appscir\Erfvmr_diva\Image\pbargent.bmp"
end type

type pb_rech_ref from u_pba_recherche_ref within w_saisie_cde_promo
integer x = 1792
integer y = 1740
integer height = 152
integer taborder = 30
boolean bringtotop = true
string picturename = "c:\appscir\Erfvmr_diva\Image\PB_VIDE.bmp"
string disabledname = "c:\appscir\Erfvmr_diva\Image\PB_VIDE.bmp"
end type

type pb_nuance from u_pba_art_nua within w_saisie_cde_promo
boolean visible = false
integer x = 850
integer y = 1740
integer width = 320
integer height = 152
integer taborder = 50
boolean dragauto = false
boolean bringtotop = true
string text = "&Nuance"
string picturename = "c:\appscir\Erfvmr_diva\Image\PB_NUA.BMP"
end type

type st_cb from statictext within w_saisie_cde_promo
integer x = 3104
integer y = 420
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

type em_cb from u_ema within w_saisie_cde_promo
event ue_ctrl_cb ( )
event ue_ctrl_codebarre ( )
accessiblerole accessiblerole = sliderrole!
integer x = 3479
integer y = 404
integer width = 576
integer height = 84
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
textcase textcase = upper!
boolean autoskip = true
end type

event ue_ctrl_codebarre();integer li_long
integer li_indice
string ls_chaine
long li_row
Decimal ld_qte


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
 
 dw_1.setFocus()
 li_row = dw_1.getrow()
	  
     dw_1.setitem(li_row,"artae000",ds_datastore.getitemString(1,1))
	dw_1.setitem(li_row,"dimaeart",ds_datastore.getitemString(1,2))
     dw_1.setitem(li_row,"qteaeuve",ld_qte)
	dw_1.SetColumn ("qteaeuve")
	dw_1.setrow(li_row)
	i_b_mode_nuance = false

    i_l_ligne_encours_controle = li_row
    dw_1.triggerevent("ue_change_row")
 	triggerEvent("ue_save")
	 dw_1.fu_insert (0)
i_b_insert_ligne	=	TRUE	
dw_1.SetColumn (i_s_tab_one)
     destroy ds_datastore
	is_code_barre = ""

end event

event modified;call super::modified;if this.text <> "" and len( this.text) > 0 then 
	is_code_barre= this.text
	this.text = ""
    parent.TriggerEvent ("ue_ctrl_codebarre")
end if
end event

type code_barre_t from statictext within w_saisie_cde_promo
integer x = 3141
integer y = 296
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

type st_qte_cb from statictext within w_saisie_cde_promo
integer x = 3104
integer y = 504
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

type pb_annul_cb from u_pba_etiquette within w_saisie_cde_promo
boolean visible = false
integer x = 2994
integer y = 1724
integer width = 329
integer height = 164
integer taborder = 90
boolean bringtotop = true
string text = "."
boolean flatstyle = false
string picturename = "c:\appscir\Erfvmr_diva\Image\suppressioncb.jpg"
string disabledname = "c:\appscir\Erfvmr_diva\Image\suppressioncb.jpg"
end type

type pb_etiquette from u_pba_etiquette within w_saisie_cde_promo
integer x = 3003
integer y = 1724
integer width = 329
integer height = 164
integer taborder = 80
boolean bringtotop = true
string text = "."
boolean flatstyle = false
string picturename = "c:\appscir\Erfvmr_diva\Image\etiquettescb.jpg"
string disabledname = "c:\appscir\Erfvmr_diva\Image\etiquettescb.jpg"
end type

event constructor;call super::constructor;// --------------------------------------
// Déclenche l'évènement de la fenêtre
// --------------------------------------
	fu_setevent ("ue_saisie_cb")

	fu_set_microhelp ("Saisie par code barre")
end event

type sle_qte_cb from singlelineedit within w_saisie_cde_promo
integer x = 3493
integer y = 504
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
string text = "none"
borderstyle borderstyle = stylelowered!
end type

type r_cb from rectangle within w_saisie_cde_promo
long linecolor = 16711680
integer linethickness = 6
long fillcolor = 12632256
integer x = 3077
integer y = 380
integer width = 1033
integer height = 224
end type

