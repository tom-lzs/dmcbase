$PBExportHeader$w_ligne_cde.srw
$PBExportComments$Saisie et modification des lignes de commande en mode normal et de valider la fin de saisie pour permettre la validation de la commande.
forward
global type w_ligne_cde from w_a_udim_su
end type
type pb_ok from u_pba_ok within w_ligne_cde
end type
type pb_echap from u_pba_echap within w_ligne_cde
end type
type pb_date from u_pba_date within w_ligne_cde
end type
type pb_echeance from u_pba_echeance within w_ligne_cde
end type
type pb_remise from u_pba_remise within w_ligne_cde
end type
type pb_tarif from u_pba_tarif within w_ligne_cde
end type
type pb_supprim from u_pba_supprim within w_ligne_cde
end type
type pb_gratuit from u_pba_gratuit within w_ligne_cde
end type
type pb_art_nua from u_pba_art_nua within w_ligne_cde
end type
type dw_mas from u_dwa within w_ligne_cde
end type
type pb_type_livraison from u_pba_type_livraison within w_ligne_cde
end type
type pb_affiche_ligne from u_pba within w_ligne_cde
end type
type pb_rech_ano from u_pba within w_ligne_cde
end type
type dw_imp_erreur from u_dwa within w_ligne_cde
end type
type pb_impr_ano from u_pba within w_ligne_cde
end type
type nblig_t from statictext within w_ligne_cde
end type
type sle_nbr_lignes from u_slea within w_ligne_cde
end type
type pb_rech_ref from u_pba_recherche_ref within w_ligne_cde
end type
type pb_nuance from u_pba_art_nua within w_ligne_cde
end type
type pb_grossiste from u_pba_type_livraison within w_ligne_cde
end type
type pb_edi from u_pba_edi within w_ligne_cde
end type
type pb_etiquette from u_pba_etiquette within w_ligne_cde
end type
type st_cb from statictext within w_ligne_cde
end type
type em_cb from u_ema within w_ligne_cde
end type
type pb_annul_cb from u_pba_etiquette within w_ligne_cde
end type
type code_barre_t from statictext within w_ligne_cde
end type
type st_qte_cb from statictext within w_ligne_cde
end type
type sle_qte_cb from singlelineedit within w_ligne_cde
end type
type pb_colisage_art from u_pba_pt within w_ligne_cde
end type
type pb_colisage_art_dim from u_pba_pt within w_ligne_cde
end type
type pb_colisage_supp from u_pba_pt within w_ligne_cde
end type
type r_cb from rectangle within w_ligne_cde
end type
end forward

global type w_ligne_cde from w_a_udim_su
string tag = "TITRE_LIGNE_CDE"
integer x = 0
integer y = 0
integer width = 4878
integer height = 2064
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = child!
windowstate windowstate = maximized!
long backcolor = 12632256
boolean ib_a_traduire = true
boolean ib_statusbar_visible = true
event ue_type_livraison pbm_custom42
event ue_echeance pbm_custom44
event ue_tarif pbm_custom45
event ue_date pbm_custom46
event ue_remise pbm_custom49
event ue_gratuit pbm_custom52
event ue_validation pbm_custom58
event ue_rech_ano pbm_custom69
event ue_article_dimension pbm_custom40
event ue_workflow pbm_custom56
event ue_affiche_ligne ( )
event ue_appro ( )
event ue_delete_ligne_supprimee ( )
event ue_edi ( )
event ue_saisie_cb ( )
event ue_ctrl_codebarre pbm_custom70
event ue_colisage_art ( )
event ue_colisage_art_dim ( )
event ue_colisage_supp ( )
pb_ok pb_ok
pb_echap pb_echap
pb_date pb_date
pb_echeance pb_echeance
pb_remise pb_remise
pb_tarif pb_tarif
pb_supprim pb_supprim
pb_gratuit pb_gratuit
pb_art_nua pb_art_nua
dw_mas dw_mas
pb_type_livraison pb_type_livraison
pb_affiche_ligne pb_affiche_ligne
pb_rech_ano pb_rech_ano
dw_imp_erreur dw_imp_erreur
pb_impr_ano pb_impr_ano
nblig_t nblig_t
sle_nbr_lignes sle_nbr_lignes
pb_rech_ref pb_rech_ref
pb_nuance pb_nuance
pb_grossiste pb_grossiste
pb_edi pb_edi
pb_etiquette pb_etiquette
st_cb st_cb
em_cb em_cb
pb_annul_cb pb_annul_cb
code_barre_t code_barre_t
st_qte_cb st_qte_cb
sle_qte_cb sle_qte_cb
pb_colisage_art pb_colisage_art
pb_colisage_art_dim pb_colisage_art_dim
pb_colisage_supp pb_colisage_supp
r_cb r_cb
end type
global w_ligne_cde w_ligne_cde

type variables
nv_commande_object 	i_nv_commande_object
nv_ligne_cde_object 		i_nv_ligne_cde_object
boolean				 		i_b_mode_nuance 			= false
n_tooltip_mgr 				itooltip


// 1 ere colonne dans l'odre de tabulation
String							i_s_tab_one						// contient la zone ou le curseur doit se potionner lors de la creation d'une nouvelle ligne

// Indique qu'une suppression de ligne est en cours
Boolean					i_b_delete_ligne = FALSE	    // Permet de savoir si la ligne a été suprimée
Boolean					i_b_insert_ligne  = FALSE        // Permet de savoir si une nouvelle à été insérée dans la datawindow
Boolean 					i_b_mode_ano  = FALSE			// Permet de savoir si on est mode affichage des lignes en anomalie

Integer					i_l_ligne_ano = 0					// compteur utilisé lors de la recherche des lignes en animalies
Long						i_l_ligne_encours_controle		// contient la ligne en cours de controle
boolean					i_b_erreur_sur_ligne = false     // Permet de savoir si une erreur a été détectéé lors du controle

Decimal     				id_remise = 0  						// Contitent la nouvelle remise

boolean					i_b_saisie_cb = false
string 					is_code_barre

//
nv_client_object 		i_nv_client_object
end variables

forward prototypes
public subroutine fw_suppression_ligne_qte_zero ()
public subroutine fw_alimentation_nbr_ligne ()
public function boolean fw_process_ligne ()
public subroutine fw_update_entete ()
end prototypes

event ue_type_livraison;/* <DESC> 
     Permet de modifier le type de livraison sur les lignes de commande sélectionnées
	Si le type actuel est Indirecte, passage en mode direct en changement l'intitulé du bouton,
		mise à jour de toutes les lignes sélectionnées en alimentant le code grossite à blanc et le type de ligne
		à direct.

	Si le type actuel est directe, passage en mode indirect en changeant l'intitulé du bouton,
	   Si le grossiste est alimenté sur l'entête de la commande, mise à jour de toutes les lignes sélectionnées
		 en alimentant le code grossiste avec celui de l'entête de la commande et le type de ligne à indirect.
		 
	  Si le grossiste n'est pas alimenté,affichage de la liste des grossistes pour sélection et mise à jour de toutes
	  	les lignes sélectionnées en alimentatnt le grossiste avec celui sélectionné et le type de ligne à indirect.
		Report du code grossiste sur l'entête de la commande
		
	Le type de livraison et le code grossiste sera initialisé comme valeur par défut pour la création des nouvelles lignes
   </DESC> */
Str_pass		str_work
Long			l_row
Integer		i
DateTime		dt_jour
Boolean		b_maj_entete	= False
String		s_numgrf

String		ls_type_livraison

IF pb_grossiste.visible Then
	pb_grossiste.visible= false
	pb_type_livraison.visible = true

	l_row = dw_1.GetSelectedRow (0)	
	DO WHILE l_row > 0
		dw_1.SetItem (l_row, DBNAME_DATE_CREATION, i_tr_sql.fnv_get_datetime ())
		dw_1.SetItem (l_row, DBNAME_GROSSISTE, BLANK)
		dw_1.SetItem (l_row, DBNAME_TYPE_LIGNE, TYPE_LIGNE_DIRECT)
		i = l_row
		l_row = dw_1.GetSelectedRow (i)	
	LOOP
	ls_type_livraison = TYPE_LIGNE_DIRECT
	s_numgrf = blank
	goto FIN	
END IF


// Modification du type de livraison on passe de DIRECTE en INDIRECTE
// (Livraison Grossiste)
	pb_grossiste.visible= true
	pb_type_livraison.visible = false
	
// Si grossiste est alimenté dans l'entete de commande, on positionne le type
// de ligne en indirecte et le grossistede la ligne à blanc
If i_nv_commande_object.fu_is_grossiste_saisie() then
	l_row = dw_1.GetSelectedRow (0)	
	DO WHILE l_row > 0
		dw_1.SetItem (l_row, DBNAME_DATE_CREATION, i_tr_sql.fnv_get_datetime ())
		dw_1.SetItem (l_row, DBNAME_GROSSISTE, i_nv_commande_object.fu_get_grossiste())
		dw_1.SetItem (l_row, DBNAME_TYPE_LIGNE, TYPE_LIGNE_INDIRECT)
		i = l_row
		l_row = dw_1.GetSelectedRow (i)	
	LOOP		
	ls_type_livraison = TYPE_LIGNE_INDIRECT
	s_numgrf = i_nv_commande_object.fu_get_grossiste() 
	goto FIN	
END IF	
	
	
// Si le grossiste n'est pas alimenté dans l'entete de la commande
// on affiche la liste des grossite pour en sélectionner un

str_work.s[1] = " "
OpenWithParm(w_liste_grossiste,str_work)
str_work = Message.fnv_get_str_pass()
Message.fnv_clear_str_pass()

if str_work.s_action = ACTION_CANCEL then
	return
end if
if str_work.s_action = ACTION_OK then
	b_maj_entete	=	True		
end if

// MISE A JOUR DES LIGNES SELECTIONNEES
l_row = dw_1.GetSelectedRow (0)	
// MISE A JOUR DE LA DATE DE LIVRAISON POUR LES LIGNES SELECTIONNEES
DO WHILE l_row > 0
		dw_1.SetItem (l_row, DBNAME_DATE_CREATION, i_tr_sql.fnv_get_datetime ())
		dw_1.SetItem (l_row, DBNAME_GROSSISTE, str_work.s[1])
		dw_1.SetItem (l_row, DBNAME_TYPE_LIGNE, TYPE_LIGNE_INDIRECT)
		i = l_row
		l_row = dw_1.GetSelectedRow (i)	
LOOP		

ls_type_livraison = TYPE_LIGNE_INDIRECT
s_numgrf = str_work.s[1]
// Si mise à jour de l'entete pour modif du grossiste
// modification du grossiste dans l'entete de cde
If b_maj_entete then
	i_nv_commande_object.fu_update_grossiste(str_work.s[1])
End if

FIN:
dw_1.Modify (DBNAME_TYPE_LIGNE + ".Initial ='" + ls_type_livraison + "'")
dw_1.Modify (DBNAME_GROSSISTE + ".Initial ='" + s_numgrf +"'")	
dw_1.update()
//fw_update_entete()
end event

event ue_echeance;/* <DESC> 
    Permet la modification du code échéance pour toutes les lignes sélectionnées
	- Controle qu' au moins une ligne soit sélectionnée
	- Affichage de la liste des échéances pour sélection
	- Mise à jour du code échéance pour les lignes sélectionnées
	- Modification de la valeur par defaut du code échéance de la datawindow pour prise en compte
	pour les nouvelles lignes
   </DESC> */
	
Str_pass		str_work
Long			l_row
Integer		i
DateTime		dt_jour

// CONTROLE NBR DE LIGNES SELECTIONNEES
IF dw_1.fu_get_selected_count () = 0 THEN
	messagebox (This.title,g_nv_traduction.get_traduction(SELECTION_OBLIGATOIRE), Information!,Ok!,1)
	dw_1.SetFocus ()
	RETURN
END IF

// SELECTION DU CODE ECHEANCE
str_work.s[1] = DBNAME_CODE_ECHEANCE
str_work = g_nv_liste_manager.get_list_of_column(str_work)
str_work = Message.fnv_get_str_pass()
Message.fnv_clear_str_pass()

if str_work.s_action = ACTION_CANCEL then
	return
end if

// MISE A JOUR DU CODE ECHEANCE POUR LES LIGNES SELECTIONNEES
l_row 	= dw_1.GetSelectedRow (0)
dt_jour	= i_tr_sql.fnv_get_datetime ()

// Permet de positionner la valeur par defaut pour les nouvelles lignes de
// commande
dw_1.Modify (DBNAME_CODE_ECHEANCE + ".Initial =" + "'" + str_work.s[1] + "'")

DO WHILE l_row > 0
	dw_1.SetItem (l_row, DBNAME_DATE_CREATION, dt_jour)
	dw_1.SetItem (l_row, DBNAME_CODE_ECHEANCE, str_work.s[1])		
	i = l_row
	l_row = dw_1.GetSelectedRow (i)
LOOP

dw_1.update ()
fw_update_entete()
dw_1.SetFocus ()

end event

event ue_tarif;/* <DESC> 
     Permet de modifier la date de prix sur les lignes de commande sélectionnées
	- Controle que au moinsune ligne soit sélectionnée
	- Préparation des paramètres à passer à la fenêtre de saisie de la date de prix
	  Les paramètres sont la date de prix
	- Affichage de la fenêtre de sélection de la date et en retour mise à jour de toutes les lignes de
	commande sélectionnées en modifiant la date de prix saisie.
   </DESC> */
// ==============================================================================
// Modification de la date du tarif pour les lignes de commande sélectionnées
// ============================================================================== 
	Str_pass		str_work
	Long 			i
	Long			l_row

// CONTROLE NBR DE LIGNES SELECTIONNEES
IF dw_1.fu_get_selected_count () = 0 THEN
	messagebox (This.title, g_nv_traduction.get_traduction(SELECTION_OBLIGATOIRE), Information!,Ok!,1)
	dw_1.SetFocus ()
	RETURN
END IF

str_work.dates[1] = Date (dw_1.GetItemDateTime (1, DBNAME_DATE_PRIX))
OpenWithParm (w_sel_date_tarif, str_work)
str_work = Message.fnv_get_str_pass()
Message.fnv_clear_str_pass()

if str_work.s_action = ACTION_CANCEL then
	return
end if

l_row = dw_1.GetSelectedRow (0)	

DO WHILE l_row > 0
	dw_1.SetItem (l_row, DBNAME_DATE_CREATION, i_tr_sql.fnv_get_datetime ())
	dw_1.SetItem (l_row, DBNAME_DATE_PRIX, str_work.dates[2])
	i = l_row
	l_row = dw_1.GetSelectedRow (i)	
LOOP

dw_1.update ()
fw_update_entete()
dw_1.SetFocus ()
end event

event ue_date;/* <DESC> 
     Permet de modifier la date de livraison sur les lignes de commande sélectionnées
	- Controle que au moins une ligne soit sélectionnée
	- Préparation des paramètres à passer à la fenêtre de saisie de la date de livraison
	  Les paramètres sont la date de livraison , de commande et de saisie de l'entête de commande
	- Affichage de la fenêtre de sélection de la date et en retour mise à jour de toutes les lignes de
	commande sélectionnées en modifiant la date de livraison saisie.
   </DESC> */
	Str_pass		str_work
	Long 			i
	Long			l_row
	long            li_nbr_lignes

// CONTROLE NBR DE LIGNES SELECTIONNEES
IF dw_1.fu_get_selected_count () = 0 THEN
	messagebox (This.title, g_nv_traduction.get_traduction(SELECTION_OBLIGATOIRE), Information!,Ok!,1)
	dw_1.SetFocus ()
	RETURN
END IF

//controle qu'aucune ligne promotionnelle ne soit sélectionnée
// si tel est le cas, déselectionne les lignes promotionnelles.
l_row = dw_1.GetSelectedRow (0)	
li_nbr_lignes = 0 
DO WHILE l_row > 0
	if i_nv_ligne_cde_object.fu_is_ligne_promotionnelle(l_row,dw_1) then
	    dw_1.SelectRow(l_row,FALSE)
		 li_nbr_lignes ++
	end if
	i = l_row
	l_row = dw_1.GetSelectedRow (i)
LOOP

if li_nbr_lignes > 0 then
		messagebox (This.title, g_nv_traduction.get_traduction(SELECTION_LIGNE_PROMO)+ " " +g_nv_traduction.get_traduction(SELECTION_LIGNE_PROMO2) , Information!,Ok!,1)
end if


IF dw_1.fu_get_selected_count () = 0 THEN
	RETURN
END IF

l_row = dw_1.GetSelectedRow (0)	

// SELECTION DE LA DATE DE LIVRAISON
str_work.dates[1] = Date (dw_mas.GetItemDateTime (1, DBNAME_DATE_LIVRAISON))
str_work.dates[2] = Date (dw_mas.GetItemDateTime (1, DBNAME_DATE_CDE))
str_work.dates[3] = Date (dw_mas.GetItemDateTime (1, DBNAME_DATE_SAISIE_CDE))
OpenWithParm (w_sel_date, str_work)
str_work = Message.fnv_get_str_pass()
Message.fnv_clear_str_pass()

if str_work.s_action = ACTION_CANCEL then
	return
end if

l_row = dw_1.GetSelectedRow (0)	
DO WHILE l_row > 0
	dw_1.SetItem (l_row, DBNAME_DATE_CREATION, i_tr_sql.fnv_get_datetime ())
	dw_1.SetItem (l_row, DBNAME_DATE_LIVRAISON, str_work.dates[4])	
	i = l_row
	l_row = dw_1.GetSelectedRow (i)
LOOP

dw_1.update ()
fw_update_entete()
dw_1.SetFocus ()
end event

event ue_remise;/* <DESC>
 Modification du taux de remise lignes pour les lignes de commande sélectionnées
  - controle qu'il n'y a pas de lignes  promotionnelles sélectionnées
 - Recalcul du montant ligne et montant offert
 - Recalcul du montant cde
   </DESC> */
	Str_pass		str_work
	Long			l_nb_select
	Long			l_row
	Integer		i
	Decimal{2}	dec_total_remise
	Decimal{2}	dec_montant_ligne
	DateTime		dt_jour


// CONTROLE NBR DE LIGNES SELECTIONNEES
IF dw_1.fu_get_selected_count () = 0 THEN
	messagebox (This.title, g_nv_traduction.get_traduction(SELECTION_OBLIGATOIRE), Information!,Ok!,1)
	dw_1.SetFocus ()
	RETURN
END IF

// une remise ne peut être accordée sur une ligne de commande promo
// --------------------------------------------------
l_row = dw_1.GetSelectedRow (0)	
// la date ne peut être modifiée sur une ligne de commande promo
// --------------------------------------------------
DO WHILE l_row > 0
	if i_nv_ligne_cde_object.fu_is_ligne_promotionnelle(l_row,dw_1) then
			messagebox(This.title,g_nv_traduction.get_traduction(REMISE_NON_ACCORDE_SUR_PROMO),StopSign!,ok!,0)
		dw_1.SelectRow(l_row,FALSE)			
		dw_1.SetFocus()
		Return
	End if
	i = l_row
	l_row = dw_1.GetSelectedRow (i)	
LOOP

str_work.d[1] = 0

openWithParm (w_sel_tx_remise, str_work)
str_work = Message.fnv_get_str_pass()
Message.fnv_clear_str_pass()

if str_work.s_action = ACTION_CANCEL then
	dw_1.SetFocus ()	
   RETURN
END IF

// MISE A JOUR DU TAUX DE REMISE POUR LES LIGNES SELECTIONNEES
l_row 	= dw_1.GetSelectedRow (0)
dt_jour	= i_tr_sql.fnv_get_datetime ()
id_remise = str_work.d[1]

l_row = dw_1.GetSelectedRow (0)	
DO WHILE l_row > 0
	IF dw_1.GetItemString (l_row, DBNAME_PAYANT_GRATUIT) = CODE_GRATUIT THEN	
		i = l_row
		l_row = dw_1.GetSelectedRow (i)			
		continue
	end if
	
	dw_1.SetItem (l_row, DBNAME_DATE_CREATION, dt_jour)
	dw_1.SetItem (l_row, DBNAME_REMISE_LIGNE, id_remise)
	i_nv_ligne_cde_object.fu_calcul_montant_ligne(dw_1, l_row)

	i = l_row
	l_row = dw_1.GetSelectedRow (i)	
LOOP

dw_1.Update ()
fw_update_entete()
dw_1.SetFocus ()
end event

event ue_gratuit;/* <DESC>
 Passage d'une ligne de commande payante en ligne de commande gratuite et inversement
 - Controle que des lignes soient selectionnées
 - Les lignes de commandes dites promotionnelles sélectionnées ne sont pas impactées
 - pour chaque ligne mise à jour des informatios:
	- Payant --> Gratuit
   	        Code gratuit = G
		   Code Erreur Ligne à blanc
 	- Gratuit --> Payant
   	        Code gratuit = P
		   Recherche du tarif de la référence de la ligne
		   Si aucun tarif trouvé, positionne le code erreur de la ligne à tarif inexistant
	- valorisation de la ligne
	
- en fin de mise à jour,revalorisation de la commande
</DESC> */

Long			l_nb_select
Long			l_row
Integer		i
Str_pass		str_work

DateTime		dt_jour
 
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
	
	if i_nv_ligne_cde_object.fu_is_ligne_promotionnelle(l_row,dw_1) then
		i = l_row
		l_row = dw_1.GetSelectedRow (i)	
		continue
	end if
	
	// MAJ DES LIGNES SELECTIONNEES (Lignes non promotionnelles)
	// LIGNES GRATUITES PASSENT EN PAYANTES
	IF dw_1.GetItemString (l_row, DBNAME_PAYANT_GRATUIT) = CODE_GRATUIT THEN
		dw_1.SetItem (l_row, DBNAME_PAYANT_GRATUIT, CODE_PAYANT)
		i_nv_ligne_cde_object.fu_get_tarif_ligne	(l_row, dw_1, true) 
		if dw_1.GetItemDecimal(l_row,DBNAME_TARIF) = 0 then
               dw_1.SetItem (l_row, DBNAME_CODE_ERREUR_LIGNE, CODE_TARIF_INEXISTANT)			
		end if
	else
		dw_1.SetItem (l_row, DBNAME_PAYANT_GRATUIT, CODE_GRATUIT)
          dw_1.SetItem (l_row, DBNAME_CODE_ERREUR_LIGNE, CODE_AUCUNE_ERREUR)		
	end if
	i_nv_ligne_cde_object.fu_calcul_montant_ligne(dw_1, l_row)
	
	i = l_row
	l_row = dw_1.GetSelectedRow (i)	
LOOP

dw_1.update ()

i_nv_commande_object.fu_validation_commande_par_lignes_cde()
dw_mas.retrieve(i_nv_commande_object.fu_get_numero_cde(),g_nv_come9par.get_code_langue())
dw_1.SetFocus ()
end event

event ue_validation;/* <DESC>
	Validation des lignes de commande en fin de saisie et réactualisaqtion des éléments de l'entête de la commande
	Cette validation s'effectue par la fenetre d'attente à laquelle il est necessaire de passer les paramètres suivant:
	     Object commande, Object ligne de commande, la datawindow des lignes de commandes, le n° de commande
		 et le mode de saisie positionné à simple
  </DESC> */
Str_pass l_str_pass
l_str_pass.po[1] = i_nv_commande_object
l_str_pass.po[2] = i_nv_ligne_cde_object
l_str_pass.po[3] = dw_1
l_str_pass.s[1] = i_nv_commande_object.fu_get_numero_cde()
l_str_pass.s[2] = CODE_MODE_SIMPLE

openwithparm(w_fenetre_attente,l_str_pass)

end event

event ue_rech_ano;/* <DESC>
     Permet de se positionner sur la première ligne en anomalie ou bien sur la suivante.
	Ceci se fait en fonction de la variable d'instance i_l_ligne_ano qui au départ est initisalisé à zero et
	incrementée au fur et à mesure de la recherche.
   </DESC> */
	
Long	l_indice

i_l_ligne_ano ++

FOR l_indice	=	i_l_ligne_ano TO dw_1.RowCount()
	IF dw_1.GetitemString(l_indice,DBNAME_CODE_ERREUR_LIGNE) > CODE_AUCUNE_ERREUR then
		i_l_ligne_ano = l_indice
		dw_1.SetFocus()
		dw_1.ScrollToRow(l_indice)
		Exit
	End if
NEXT

If l_indice >= dw_1.RowCount() then
	i_l_ligne_ano = 0
end if
end event

event ue_article_dimension;/* <DESC> 
Passage de la saisie Article,Dimension et inversement
 Ceci permet de forcer le positionnement du curseur lors de la création 
 d'une nouvelle sur l'article ou la dimension
</DESC> */
IF i_b_mode_nuance THEN
	pb_art_nua.visible = true
     pb_nuance.visible= false
	i_b_mode_nuance			=	False
	dw_1.SetColumn(DBNAME_ARTICLE)
	i_s_tab_one 				= DBNAME_ARTICLE
else
	pb_art_nua.visible = false
     pb_nuance.visible= true
	i_b_mode_nuance		  =	True
	dw_1.SetColumn(DBNAME_DIMENSION)
	i_s_tab_one 			  = DBNAME_DIMENSION		
END IF

dw_1.SetFocus ()
end event

event ue_workflow;/* <DESC>
    Cet evenement est appelé lors de la sélection d'une option dans le menu alors que cette
    fenetre est la fenetre active et va lancer le workflow manager pour effe tuer l'enchainement.
</DESC> */
dw_1.TriggerEvent (RowFocusChanged!)
dw_1.Update (TRUE)

i_str_pass.po[2] = i_nv_commande_object
i_str_pass.s[2] = i_nv_commande_object.fu_get_numero_cde()
g_nv_workflow_manager.fu_check_workflow(FENETRE_LIGNE_CDE, i_str_pass)
close(this)
end event

event ue_affiche_ligne();/* <DESC>
    Cette option est accessible lorsque l'on est en mode affichage des lignes en anomalie
	Elle permet de passer en mode normal (Affichage de toutes les lignes de commande)
   </DESC> */
	i_str_pass.s_action = "O"
	i_str_pass.b[6]	  = False
	g_w_frame.fw_open_sheet (FENETRE_LIGNE_CDE, 0, -1, i_str_pass)
	Close(this)
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
		fw_alimentation_nbr_ligne()
	end if
	if i_b_saisie_cb then
		em_cb.text=""
		em_cb.setFocus()
     end if
end event

event ue_edi();/* <DESC> 
     Permet de modifier les information n° de magasin et commande magasin
	  pour les commandes EDI
   </DESC> */
	Str_pass		str_work
	Long 			i
	Long			l_row

// CONTROLE NBR DE LIGNES SELECTIONNEES
IF dw_1.fu_get_selected_count () = 0 THEN
	messagebox (This.title, g_nv_traduction.get_traduction(SELECTION_OBLIGATOIRE), Information!,Ok!,1)
	dw_1.SetFocus ()
	RETURN
END IF

str_work.s[1] = dw_1.GetItemString (1,  DBNAME_MAGASIN_EDI	)
str_work.s[2] = dw_1.GetItemString (1, DBNAME_MAGASIN_CDE_EDI)

OpenWithParm (w_sel_edi_info, str_work)
str_work = Message.fnv_get_str_pass()
Message.fnv_clear_str_pass()

if str_work.s_action = ACTION_CANCEL then
	return
end if

l_row = dw_1.GetSelectedRow (0)	

DO WHILE l_row > 0
	dw_1.SetItem (l_row, DBNAME_DATE_CREATION, i_tr_sql.fnv_get_datetime ())
	dw_1.SetItem (l_row, DBNAME_MAGASIN_EDI, str_work.s[1])
	dw_1.SetItem (l_row, DBNAME_MAGASIN_CDE_EDI, str_work.s[2])
	i = l_row
	l_row = dw_1.GetSelectedRow (i)	
LOOP

dw_1.update ()
fw_update_entete()
dw_1.SetFocus ()
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

event ue_ctrl_codebarre;// controle du code barre
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

event ue_colisage_art();// DECLARATION DES VARIABLES LOCALES
Long	l_nb_select
Datetime l_date
String s_mois, s_jour,s_date,s_heure,s_minute,s_seconde,s_compteur
integer i_compteur

Long l_row, l_row_trouve, l_indice

// CONTROLE NBR DE LIGNES SELECTIONNEES
l_nb_select = dw_1.fu_get_selected_count ()
IF l_nb_select = 0 THEN
	messagebox (This.title, g_nv_traduction.get_traduction(SELECTION_OBLIGATOIRE), Information!,Ok!,1)
	dw_1.SetFocus ()
	RETURN
END IF

l_date =  i_tr_sql.fnv_get_datetime ()

s_mois = string( month(date(l_date)))
if len(s_mois) = 1 then
	 s_mois = "0"+s_mois
end if

s_jour = string(day(date(l_date)))
if len(s_jour) = 1 then
	 s_jour = "0"+s_jour
end if

s_heure = string(hour(time(l_date)))
if len(s_heure) = 1 then
	 s_heure = "0"+s_heure
end if

s_minute  = string(minute(time(l_date)))
if len(s_minute) = 1 then
	 s_minute = "0"+s_minute
end if
s_seconde  = string(second(time(l_date)))
if len(s_seconde) = 1 then
	 s_seconde = "0"+s_seconde
end if

s_date = s_mois+s_jour+s_heure+s_minute+s_seconde

// traitement des lignes sélectionnées

l_row = dw_1.GetSelectedRow (0)	

DO WHILE l_row > 0
	
	// RECHERCHE si existence d'une ligne avec un n° de magasin our l'article sélectionné

    l_row_trouve  =	dw_1.Find (  &
			                       DBNAME_ARTICLE     + " ='" + dw_1.getItemString(l_row,DBNAME_ARTICLE)     + "'and " + &
			                       DBNAME_MAGASIN_CDE_EDI   + " <> ''", &
			                       1,dw_1.RowCount())
           // auncune ligne trouvée , incrémente le n° de compteur , sinon on prend le compteur de la ligne trouvée
      if l_row_trouve = 0 then
		 i_compteur ++
		 Choose case len(string(i_compteur))
			case 1 
				 s_compteur = "0000"+string(i_compteur)
			case 2
				s_compteur = "000"+string(i_compteur)
			case 3 
				 s_compteur = "00"+string(i_compteur)				
			case 4
				 s_compteur = "0"+string(i_compteur)				
			case 5
				 s_compteur = string(i_compteur)
		end choose	
		s_compteur =  s_date + s_compteur
	  else
		 s_compteur = dw_1.getItemString(l_row_trouve,DBNAME_MAGASIN_CDE_EDI )
      end if

 	dw_1.SetItem (l_row, DBNAME_DATE_CREATION, i_tr_sql.fnv_get_datetime ())
	dw_1.SetItem (l_row, DBNAME_MAGASIN_CDE_EDI , s_compteur)
	l_indice = l_row
	l_row = dw_1.GetSelectedRow (l_indice)	
LOOP

dw_1.update ()
dw_1.SetFocus ()

end event

event ue_colisage_art_dim();// DECLARATION DES VARIABLES LOCALES
Long	l_nb_select
Datetime l_date
String s_mois, s_jour,s_date,s_heure,s_minute,s_seconde,s_compteur
integer i_compteur

Long l_row, l_row_trouve, l_indice

// CONTROLE NBR DE LIGNES SELECTIONNEES
l_nb_select = dw_1.fu_get_selected_count ()
IF l_nb_select = 0 THEN
	messagebox (This.title, g_nv_traduction.get_traduction(SELECTION_OBLIGATOIRE), Information!,Ok!,1)
	dw_1.SetFocus ()
	RETURN
END IF

l_date =  i_tr_sql.fnv_get_datetime ()

s_mois = string( month(date(l_date)))
if len(s_mois) = 1 then
	 s_mois = "0"+s_mois
end if

s_jour = string(day(date(l_date)))
if len(s_jour) = 1 then
	 s_jour = "0"+s_jour
end if

s_heure = string(hour(time(l_date)))
if len(s_heure) = 1 then
	 s_heure = "0"+s_heure
end if

s_minute  = string(minute(time(l_date)))
if len(s_minute) = 1 then
	 s_minute = "0"+s_minute
end if
s_seconde  = string(second(time(l_date)))
if len(s_seconde) = 1 then
	 s_seconde = "0"+s_seconde
end if

s_date = s_mois+s_jour+s_heure+s_minute+s_seconde

// traitement des lignes sélectionnées

l_row = dw_1.GetSelectedRow (0)	

DO WHILE l_row > 0
	
	// RECHERCHE si existence d'une ligne avec un n° de magasin pour l'article et dimension sélectionné

    l_row_trouve  =	dw_1.Find (  &
			                       DBNAME_ARTICLE     + " ='" + dw_1.getItemString(l_row,DBNAME_ARTICLE)     + "'and " + &
			                       DBNAME_DIMENSION     + " ='" + dw_1.getItemString(l_row,DBNAME_DIMENSION)     + "'and " + &										  
			                       DBNAME_MAGASIN_CDE_EDI   + " <> ''", &
			                       1,dw_1.RowCount())
           // auncune ligne trouvée , incrémente le n° de compteur , sinon on prend le compteur de la ligne trouvée
      if l_row_trouve = 0 then
		 i_compteur ++
		 Choose case len(string(i_compteur))
			case 1 
				 s_compteur = "0000"+string(i_compteur)
			case 2
				s_compteur = "000"+string(i_compteur)
			case 3 
				 s_compteur = "00"+string(i_compteur)				
			case 4
				 s_compteur = "0"+string(i_compteur)				
			case 5
				 s_compteur = string(i_compteur)
		end choose	
		s_compteur =  s_date + s_compteur
	  else
		 s_compteur = dw_1.getItemString(l_row_trouve,DBNAME_MAGASIN_CDE_EDI )
      end if

 	dw_1.SetItem (l_row, DBNAME_DATE_CREATION, i_tr_sql.fnv_get_datetime ())
	dw_1.SetItem (l_row, DBNAME_MAGASIN_CDE_EDI , s_compteur)
	l_indice = l_row
	l_row = dw_1.GetSelectedRow (l_indice)	
LOOP

dw_1.update ()
dw_1.SetFocus ()

end event

event ue_colisage_supp();// DECLARATION DES VARIABLES LOCALES
Long	l_nb_select, l_row, i

// CONTROLE NBR DE LIGNES SELECTIONNEES
l_nb_select = dw_1.fu_get_selected_count ()
IF l_nb_select = 0 THEN
	messagebox (This.title, g_nv_traduction.get_traduction(SELECTION_OBLIGATOIRE), Information!,Ok!,1)
	dw_1.SetFocus ()
	RETURN
END IF

l_row = dw_1.GetSelectedRow(0)
DO WHILE l_row > 0
	dw_1.SetItem (l_row, DBNAME_MAGASIN_CDE_EDI , "")
	dw_1.SetItem (l_row, DBNAME_DATE_CREATION, i_tr_sql.fnv_get_datetime ())
	i = l_row
	l_row = dw_1.GetSelectedRow (i)	
LOOP

dw_1.update ()
dw_1.SetFocus ()

end event

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

public subroutine fw_alimentation_nbr_ligne ();/* <DESC>
     Alimentation du nombre de ligne de la datawindow qui représente le nombre de ligne 
	 commande en mode affichage des lignes de commande en anomalie sinon il s'agit du nombre de ligne
	 de commande + la ligne vide créée pour permettre la saisie d'une nouvelle ligne de commande
   </DESC> */
sle_nbr_lignes.text = String(dw_1.RowCount())
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

if dw_1.fu_changed() then
	triggerEvent("ue_save")
	if i_b_erreur_sur_ligne then
		return false
	end if
end if

dw_1.fu_insert (0)
dw_1.SetColumn (i_s_tab_one)
i_b_insert_ligne	=	TRUE

IF dw_1.RowCount() = 2 AND pb_art_nua.text = "&Article" THEN 
	postEvent("ue_article_dimension")
END IF

return true

end function

public subroutine fw_update_entete ();/* <DESC>
     Mise à jour de la date de mise à jour et du visteur de mise à jour sur l'entête de la commande
   </DESC>  */
i_nv_commande_object.fu_update_entete()
end subroutine

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

// SUPPRESSION DE L'ENREGISTREMEN
dw_1.SetRow(1)
i_b_delete_ligne = TRUE
l_row = dw_1.GetSelectedRow (0)
DO WHILE l_row > 0
	dw_1.DeleteRow (l_row)
	l_row = dw_1.GetSelectedRow (0)
LOOP	

dw_1.Update ()
i_b_delete_ligne = FALSE

i_nv_commande_object.fu_validation_commande_par_lignes_cde()
dw_mas.retrieve(i_nv_commande_object.fu_get_numero_cde(),g_nv_come9par.get_code_langue())

dw_1.SetFocus ()
if dw_1.rowCount() = 0 then
	dw_1.insertRow(0)
end if
dw_1.ScrollToRow(dw_1.RowCount())
fw_alimentation_nbr_ligne()
end event

event ue_presave;call super::ue_presave;/* <DESC>
      Permet d'effectuer le controle de la ligne de commande en cours de saisie ou de modification
      S'il s'agit d'une nouvelle ligne, report de la remise en cours
	 Si la ligne a été valorisée au prix catalogue, recalcul le montant de la ligne sinon controle de la ligne de commande
   </DESC> */
long l_row 
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

// si origine catalogue avec valorisation catalogue
//if dw_1.getItemString(l_row,DBNAME_TYPE_SAISIE) = "V" then
//  i_nv_ligne_cde_object.fu_calcul_montant_ligne(dw_1,l_row)
//   return
//end if

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
	- Si le visiteur est un vendeur, les boutons remise et echeance ne seront pas visible.
	- Controle si identification du client
	- Création de l'object commande et extraction des informations de l'entête de la commande
	- Extraction des lignes de la commande
	- Initailisation de l'object nv_ligne_cde_object
	- Si mode gestion des lignes en anomalie, rendre visible le bouton affichage des lignes et cacher le bouton
	   Article/Dimension sinon création d'une ligne vide et rendre visible le bouton affichage ligne
   </DESC> */
	
// DECLARATION DES VARIABLES LOCALES
Long			l_retrieve
Long			l_insert

dw_mas.SetTransObject (i_tr_sql)
dw_imp_erreur.SetTransObject	(i_tr_sql)

sle_qte_cb.text = "1"

if g_nv_come9par.is_vendeur() then
	pb_remise.visible = false
	pb_echeance.visible = false
	pb_gratuit.visible = false
	pb_colisage_art.visible = false
	pb_colisage_art_dim.visible = false
	pb_colisage_supp.visible = false
end if

// SELECTION DU CLIENT
i_str_pass = g_nv_workflow_manager.fu_ident_client(true, i_str_pass)
if  i_str_pass.s_action = ACTION_CANCEL then
     close(this)
	RETURN
end if
g_nv_trace.fu_write_trace( this.classname( ), "ue_ini",i_str_pass.s[01], i_str_pass.s[02], this.classname( ) , g_s_fenetre_destination)
dw_mas.SetRedraw (False)
dw_1.SetRedraw (False)

if not g_nv_come9par.is_francais() then
      dw_1.Modify ("compute_e.visible = 1")
	dw_1.Modify ("compute_f.visible = 0")
end if

i_nv_commande_object = CREATE nv_commande_object
i_nv_commande_object.fu_set_numero_cde(i_str_pass.s[2])

IF dw_mas.Retrieve (i_nv_commande_object.fu_controle_numero_cde(i_str_pass.po[1]),g_nv_come9par.get_code_langue()) = -1 THEN
 	f_dmc_error (this.title +  BLANK + DB_ERROR_MESSAGE)
END IF

if dw_1.Retrieve (i_nv_commande_object.fu_get_numero_cde()) = -1 then
		f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
end if

i_nv_ligne_cde_object = CREATE nv_ligne_cde_object
i_nv_ligne_cde_object.fu_init_info_commande(i_nv_commande_object)
i_nv_ligne_cde_object.fu_init_valeur_ligne_cde_simple(dw_1)

nv_client_object lnv_client
lnv_client = i_str_pass.po[1]
i_nv_client_object = i_str_pass.po[1]

dw_mas.setItem(1,"alerte",lnv_client.fu_get_alerte( ))

dw_mas.SetRedraw (True) 
dw_1.SetRedraw (True)
dw_1.fu_set_selection_mode (0)
dw_1.SetFocus ()

i_s_tab_one		 = DBNAME_ARTICLE

// Remise à blanc des zones de la structure concernant les lignes en anomalie
// Si on est en mode affichage des anomalies,
IF i_str_pass.s_win_title = TITRE_LIGNE_EN_ANOMALIE THEN
	pb_affiche_ligne.Visible	=	True
	i_str_pass.b[1]				=  true
	pb_art_nua.Visible			=	False
	i_b_mode_ano = true
Else
     l_insert = dw_1.InsertRow (0)
	dw_1.ScrollToRow (l_insert)
	dw_1.SetColumn (i_s_tab_one)
	i_str_pass.b[1]				=  false
	If l_retrieve >= 1 then
		postEvent("ue_article_dimension")
	End if
end if

i_str_pass.s_dataobject = ""
i_str_pass.s_win_title  = ""
i_str_pass.s[9]		   = FENETRE_LIGNE_CDE

fw_alimentation_nbr_ligne()
end event

event ue_ok;/* <DESC>
      Permet d'effectuer la  validation des lignes de commande et de l'entête avant d'aller en fin de commande
	- Suppression de toutes les lignes de commandes ayant une quantite à zero
	- Validation de la commande
	- ouverture de la fenêtre de fin de commande
   </DESC< */
	
// OVERRIDE SCRIPT ANCESTOR
dw_1.AcceptText ()
dw_1.SetRow (1)

// Suppression des lignes de commande dont la quantite est = 0
fw_suppression_ligne_qte_zero()

// VALIDATION DES LIGNES DE COMMANDE
This.TriggerEvent ("ue_validation")

IF i_nv_commande_object.fu_get_nbr_lignes_cde()  = 0 THEN
	messagebox (this.title,g_nv_traduction.get_traduction( PAS_LIGNE_SAISIE) + "~r" + g_nv_traduction.get_traduction(ECHAP), & 
					Information!,Ok!,1)
	dw_1.InsertRow (0)
	dw_1.SetFocus ()
	RETURN
END IF

i_str_pass.po[2] = i_nv_commande_object
i_str_pass.s[2] = i_nv_commande_object.fu_get_numero_cde()
g_w_frame.fw_open_sheet (FENETRE_FIN_CDE,0,-1,i_str_pass)
Close (This)

end event

event ue_save;call super::ue_save;/* <DESC> 
 si le controle des lignes s'est effectuée correctement , valorisation de la commande
 et suppression des lignes de commande supprimée
 </DESC> */
if  message.returnvalue  <>  -1 THEN
	setPointer(Hourglass!)
	i_nv_commande_object.fu_validation_commande_par_lignes_cde()
	dw_mas.retrieve(i_nv_commande_object.fu_get_numero_cde(),g_nv_come9par.get_code_langue())
	postEvent("ue_delete_ligne_supprimee")
	fw_alimentation_nbr_ligne()
	setPointer(Arrow!)
end if


end event

event ue_print;/* <DESC>
    Permet l'impression des lignes de commande en anomalie
    Pour cela affichage de la fenetre de sélection du type d'impression à effectuer (Standard ou destination client)
    En fonction du type, initialistion de la datwindow à prendre en compte et impression.
   </DESC> */
str_pass l_str_work

openWithParm (w_selection_type_edition_anomalie, l_str_work)

l_str_work = Message.fnv_get_str_pass()
Message.fnv_clear_str_pass() 

if l_str_work.s_action = ACTION_CANCEL then
	return
end if

if not l_str_work.b[1] then
	dw_imp_erreur.dataobject = "d_impression_ligne_cde_erreur_client"
	dw_imp_erreur.SetTransObject(sqlca)
	dw_imp_erreur.Retrieve (i_nv_commande_object.fu_get_numero_cde(),g_nv_come9par.get_code_langue(),g_nv_come9par.get_code_adresse( ))
else
	dw_imp_erreur.Retrieve (i_nv_commande_object.fu_get_numero_cde(),g_nv_come9par.get_code_langue())
end if


g_nv_traduction.set_traduction_datawindow(dw_imp_erreur)
if not g_nv_come9par.is_francais() then
	dw_imp_erreur.object.dw_2.object.compute_e.visible= 1
	dw_imp_erreur.object.dw_2.object.compute_f.visible= 0
end if
triggerEvent("ue_printsetup")
dw_imp_erreur.Print()

end event

event ue_cancel;/* <DESC>
    Permet de quitter l'application après avoir effectuer le controle de la ligne en cours de saisie ou
	 de modification.
	 Si on est en mode Anomalie, on retour sur la fenêtre de fin de commande sinon sur la liste des commandes
	 d'origine.
   </DESC> */
	
// OVERRIDE SCRIPT ANCESTOR

// Déclaration des variables locales
Long		l_row
Long		l_nb_row
boolean  lb_row_deleted = false

// permet de déclencher l'évènement we_dwnprocessenter de la datawindow
// pour forcer la mise à jour de la ligne en cours
i_b_canceled = TRUE
dw_1.AcceptText()
dw_1.SetRow(1)

// Suppression des lignes de commande dont la quantite est = 0
l_row = 1
l_nb_row = dw_1.RowCount()
Do While l_row <= l_nb_row
	IF dw_1.GetItemDecimal (l_row, DBNAME_QTE) = 0 THEN
		dw_1.DeleteRow (l_row)
		lb_row_deleted = true
		l_nb_row = l_nb_row - 1
	ELSE
		l_row = l_row + 1
	END IF
LOOP

if lb_row_deleted then
	dw_1.fu_update()
end if

i_str_pass.po[2] = i_nv_commande_object
i_str_pass.s[2] = i_nv_commande_object.fu_get_numero_cde()

// On retourne en fin de commande si on en vient
IF i_str_pass.s_win_title = TITRE_LIGNE_EN_ANOMALIE THEN
	g_w_frame.fw_open_sheet (FENETRE_FIN_CDE, 0, 1, i_str_pass)
else
	g_nv_workflow_manager.fu_affiche_liste_origine(i_str_pass)
END IF

Close (this)
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

on w_ligne_cde.create
int iCurrent
call super::create
this.pb_ok=create pb_ok
this.pb_echap=create pb_echap
this.pb_date=create pb_date
this.pb_echeance=create pb_echeance
this.pb_remise=create pb_remise
this.pb_tarif=create pb_tarif
this.pb_supprim=create pb_supprim
this.pb_gratuit=create pb_gratuit
this.pb_art_nua=create pb_art_nua
this.dw_mas=create dw_mas
this.pb_type_livraison=create pb_type_livraison
this.pb_affiche_ligne=create pb_affiche_ligne
this.pb_rech_ano=create pb_rech_ano
this.dw_imp_erreur=create dw_imp_erreur
this.pb_impr_ano=create pb_impr_ano
this.nblig_t=create nblig_t
this.sle_nbr_lignes=create sle_nbr_lignes
this.pb_rech_ref=create pb_rech_ref
this.pb_nuance=create pb_nuance
this.pb_grossiste=create pb_grossiste
this.pb_edi=create pb_edi
this.pb_etiquette=create pb_etiquette
this.st_cb=create st_cb
this.em_cb=create em_cb
this.pb_annul_cb=create pb_annul_cb
this.code_barre_t=create code_barre_t
this.st_qte_cb=create st_qte_cb
this.sle_qte_cb=create sle_qte_cb
this.pb_colisage_art=create pb_colisage_art
this.pb_colisage_art_dim=create pb_colisage_art_dim
this.pb_colisage_supp=create pb_colisage_supp
this.r_cb=create r_cb
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_ok
this.Control[iCurrent+2]=this.pb_echap
this.Control[iCurrent+3]=this.pb_date
this.Control[iCurrent+4]=this.pb_echeance
this.Control[iCurrent+5]=this.pb_remise
this.Control[iCurrent+6]=this.pb_tarif
this.Control[iCurrent+7]=this.pb_supprim
this.Control[iCurrent+8]=this.pb_gratuit
this.Control[iCurrent+9]=this.pb_art_nua
this.Control[iCurrent+10]=this.dw_mas
this.Control[iCurrent+11]=this.pb_type_livraison
this.Control[iCurrent+12]=this.pb_affiche_ligne
this.Control[iCurrent+13]=this.pb_rech_ano
this.Control[iCurrent+14]=this.dw_imp_erreur
this.Control[iCurrent+15]=this.pb_impr_ano
this.Control[iCurrent+16]=this.nblig_t
this.Control[iCurrent+17]=this.sle_nbr_lignes
this.Control[iCurrent+18]=this.pb_rech_ref
this.Control[iCurrent+19]=this.pb_nuance
this.Control[iCurrent+20]=this.pb_grossiste
this.Control[iCurrent+21]=this.pb_edi
this.Control[iCurrent+22]=this.pb_etiquette
this.Control[iCurrent+23]=this.st_cb
this.Control[iCurrent+24]=this.em_cb
this.Control[iCurrent+25]=this.pb_annul_cb
this.Control[iCurrent+26]=this.code_barre_t
this.Control[iCurrent+27]=this.st_qte_cb
this.Control[iCurrent+28]=this.sle_qte_cb
this.Control[iCurrent+29]=this.pb_colisage_art
this.Control[iCurrent+30]=this.pb_colisage_art_dim
this.Control[iCurrent+31]=this.pb_colisage_supp
this.Control[iCurrent+32]=this.r_cb
end on

on w_ligne_cde.destroy
call super::destroy
destroy(this.pb_ok)
destroy(this.pb_echap)
destroy(this.pb_date)
destroy(this.pb_echeance)
destroy(this.pb_remise)
destroy(this.pb_tarif)
destroy(this.pb_supprim)
destroy(this.pb_gratuit)
destroy(this.pb_art_nua)
destroy(this.dw_mas)
destroy(this.pb_type_livraison)
destroy(this.pb_affiche_ligne)
destroy(this.pb_rech_ano)
destroy(this.dw_imp_erreur)
destroy(this.pb_impr_ano)
destroy(this.nblig_t)
destroy(this.sle_nbr_lignes)
destroy(this.pb_rech_ref)
destroy(this.pb_nuance)
destroy(this.pb_grossiste)
destroy(this.pb_edi)
destroy(this.pb_etiquette)
destroy(this.st_cb)
destroy(this.em_cb)
destroy(this.pb_annul_cb)
destroy(this.code_barre_t)
destroy(this.st_qte_cb)
destroy(this.sle_qte_cb)
destroy(this.pb_colisage_art)
destroy(this.pb_colisage_art_dim)
destroy(this.pb_colisage_supp)
destroy(this.r_cb)
end on

event ue_close;/* <DESC> 
     Permet de fermer la fenêtre sans effectuer de mise à jour de la ligne en cours de modification
	en retournant en fin de commande si mode affichage des lignes en anomalie sinon retour à la
	liste des commandes 
   </DESC> */
//override ancestor script
i_b_canceled = TRUE
i_str_pass.po[2] = i_nv_commande_object
i_str_pass.s[2] = i_nv_commande_object.fu_get_numero_cde()

IF i_str_pass.s_win_title = TITRE_LIGNE_EN_ANOMALIE THEN
	g_w_frame.fw_open_sheet (FENETRE_FIN_CDE, 0, 1, i_str_pass)
else
	g_nv_workflow_manager.fu_affiche_liste_origine(i_str_pass)
END IF

Close (this)
end event

event close;/* <DESC>
     Permet de fermer la fenêtre
   </DESC> */
i_b_canceled = TRUE
close(this)
end event

event closequery;/* <DESC>
     Overwrite le script de l'ancêtre
   </DESC> */
end event

event ue_search;call super::ue_search;/* <DESC>
    Permet d'effectuer la recherche d'une référence de vente pour alimenter la saisie de la ligne avec
    la référence de vente sélectionnée.Ceci se fait par appel de la fenetre de liste des références en
    passant les éléments tarifs de la commande
  </DESC> */
str_pass l_str_work
Long ll_row

l_str_work.s[1] = "."
l_str_work.s[2] = DONNEE_VIDE
l_str_work.s[3] = DONNEE_VIDE
l_str_work.s[4] = i_nv_commande_object.fu_get_marche()
l_str_work.s[5] = i_nv_commande_object.fu_get_liste_prix()
l_str_work.s[6] = i_nv_commande_object.fu_get_devise()
l_str_work.s[7] = this.className()
l_str_work.b[1] = false
ll_row = dw_1.getRow()

OpenWithParm (w_liste_reference_tarifs, l_str_work)
l_str_work = Message.fnv_get_str_pass()
Message.fnv_clear_str_pass()
if  l_str_work.s_action <> ACTION_OK then
	 return
end if

i_l_ligne_encours_controle = ll_row

dw_1.setfocus()
dw_1.setItem(ll_row,DBNAME_ARTICLE, l_str_work.s[1])
dw_1.setItem(ll_row,DBNAME_DIMENSION, l_str_work.s[2])
dw_1.setItem(ll_row,DBNAME_TARIF, l_str_work.d[1])
dw_1.setcolumn (DBNAME_DIMENSION)
dw_1.triggerevent("ue_change_row")
end event

event open;call super::open;/* <DESC>
     Si l'affichage est celui des lignes en anomalie, il est nécessaire d'effectuer
	  la traduction du titre et de la datawindow
   </DESC> */
IF i_str_pass.s_win_title = TITRE_LIGNE_EN_ANOMALIE THEN
	this.title = g_nv_traduction.get_traduction( TITRE_LIGNE_EN_ANOMALIE)
	g_nv_traduction.set_traduction_datawindow( dw_1)
end if
end event

type uo_statusbar from w_a_udim_su`uo_statusbar within w_ligne_cde
end type

type dw_1 from w_a_udim_su`dw_1 within w_ligne_cde
event ue_repositionne_curseur ( )
event ue_affichage_detail_ref ( )
event ue_change_row ( )
string tag = "A_TRADUIRE"
integer x = 69
integer y = 576
integer width = 3835
integer height = 952
integer taborder = 30
string title = "Gestion des anomalies"
string dataobject = "d_ligne_cde"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event dw_1::ue_repositionne_curseur();/* <DESC>
     Permet de repositionner le curseur soit sur l'article ou sur la dimension
   </DESC> */
dw_1.SetColumn (i_s_tab_one)
dw_1.setFocus()
end event

event dw_1::ue_affichage_detail_ref();/* <DESC> 
     Permet d'afficher la fenêtre des infos référence de la ligne de commande sélectionnée
	 en passant en paramère la référence et les éléments tarifs de la commande
   </DESC> */
if dw_1.getROw() = 0 then
	return
end if

if trim( dw_1.getItemString(dw_1.getRow(), DBNAME_ARTICLE)) = DONNEE_VIDE then
	return
end if


str_pass l_str_pass
l_str_pass.s[1] = dw_1.getItemString(dw_1.getRow(), DBNAME_ARTICLE)
l_str_pass.s[2] =  i_nv_commande_object.fu_get_marche()
l_str_pass.s[3] = i_nv_commande_object.fu_get_liste_prix()
l_str_pass.s[4] = i_nv_commande_object.fu_get_devise()
l_str_pass.s[5] = dw_1.getItemString(dw_1.getRow(), DBNAME_DIMENSION)
l_str_pass.s[6] = i_nv_commande_object.fu_get_numero_cde( )
l_str_pass.s[7] = dw_1.getItemString(dw_1.getRow(),DBNAME_ARTICLE_CLIENT)
l_str_pass.s[8] = dw_1.getItemString(dw_1.getRow(),DBNAME_NUM_LIGNE)
OpenWithParm (w_ligne_cde_info_ref,l_str_pass)
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
s_dimension	=	Trim(dw_1.Getitemstring(ll_row,DBNAME_DIMENSION))

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
	F1 --> Affichage du détail de la référence
	F2 -->  Recherche de référence
	Tabulation --> positionne sur le champ suivant
   </DESC> */
	
// SELECTION DE LA LIGNE EN COURS
// Si on se trouve en mode affichage ligne en anomalie, sélection de la ligne
// Si mode normal et que la ligne sélectionnée n'est pas la dernière , sélection de la ligne.
//             ( la dernière ligne est une ligne vide ou encours de création)
	IF KeyDown(KeyF5!) THEN
		if not i_str_pass.b[1] then
			if dw_1.getRow() < dw_1.RowCount()  then
 			  dw_1.SelectRow(dw_1.GetRow(),TRUE)
  		     end if
		else
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
		if not i_str_pass.b[1] then
			dw_1.SelectRow(dw_1.RowCount(),FALSE)
		end if
	END IF

// DESELECTION DE TOUTES LES LIGNES
	IF KeyDown(KeyF8!) THEN
		dw_1.SelectRow(0,FALSE)
	END IF

// VALIDATION DES LIGNES DE COMMANDE
	IF KeyDown (KeyF11!) THEN
		Parent.PostEvent ("ue_ok")
	END IF
	
// SELECTION DE LA LIGNE EN COURS
	IF KeyDown(KeyF1!) THEN
		PostEvent ("ue_affichage_detail_ref")
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

event dw_1::doubleclicked;call super::doubleclicked;/* <DESC>
    Afficher une fenetre de sélection d'article,pour se positionner sur la  première ligne de cde ayant cet article 
	après avoir triées les lignes de la datawindow par article.
</DESC>*/
Str_pass		str_work
String		s_nom_colonne
Long			l_row

// si aucune ligne de commande sélectionnée, aucune recherche ne peut être effectuée.
If row > 0 then
   Return
End if

// si le champ sur lequel a été effectué le double clique ne correspond pas à l'entête de la colonne
// article, aucune recherche ne sera effectuée
s_nom_colonne = this.GetObjectAtPointer()
If Mid(s_nom_colonne,1,10) <> "artae000_t" then
	Return
End if

// changement de l'apparence de la bordure de la zone contenant l'intitulé
this.SelectRow(0,FALSE)
this.Modify ("artae000_t.Border='5'")

// Ouverture de la fenêtre de saisie de l'article à rechercher
OpenWithParm (w_select_article,str_work)
str_work = Message.fnv_get_str_pass()
Message.fnv_clear_str_pass()

// Si un article a été saisi, tri de la datawindow sur l'article et recherche de la première ligne
// contenant l'article saisi.
This.Modify ("artae000_t.Border='6'")
if str_work.s_action = ACTION_OK then
		dw_1.Setsort(DBNAME_ARTICLE + " A")
		dw_1.sort()
		l_row	=	dw_1.find (DBNAME_ARTICLE + " = '" + str_work.s[01] + "' ", 1 , dw_1.RowCount())
		If l_row > 0 then
			this.ScrollToRow(l_row)
			this.SelectRow(l_row,TRUE)
		Else
			messagebox(This.title,g_nv_traduction.get_traduction(PAS_SELECTION),information!,ok!,0)
		End if
end if

end event

type pb_ok from u_pba_ok within w_ligne_cde
integer x = 82
integer y = 1760
integer width = 361
integer height = 152
integer taborder = 0
string text = "Valid. F11"
boolean default = false
string picturename = "c:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_echap from u_pba_echap within w_ligne_cde
integer x = 3063
integer y = 1760
integer width = 320
integer height = 152
integer taborder = 0
string picturename = "c:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type pb_date from u_pba_date within w_ligne_cde
integer x = 2254
integer y = 1580
integer width = 347
integer height = 152
integer taborder = 0
string text = "Date      Li&vr."
string picturename = "c:\appscir\Erfvmr_diva\Image\pbdatliv.bmp"
end type

type pb_echeance from u_pba_echeance within w_ligne_cde
integer x = 1536
integer y = 1580
integer height = 152
integer taborder = 0
string picturename = "c:\appscir\Erfvmr_diva\Image\echeance.bmp"
end type

type pb_remise from u_pba_remise within w_ligne_cde
integer x = 1216
integer y = 1580
integer width = 320
integer height = 152
integer taborder = 0
string picturename = "c:\appscir\Erfvmr_diva\Image\pbremise.bmp"
end type

type pb_tarif from u_pba_tarif within w_ligne_cde
integer x = 475
integer y = 1580
integer width = 357
integer height = 152
integer taborder = 0
string picturename = "c:\appscir\Erfvmr_diva\Image\PB_TARIF.BMP"
end type

type pb_supprim from u_pba_supprim within w_ligne_cde
integer x = 2254
integer y = 1760
integer width = 347
integer height = 152
integer taborder = 0
string text = "S&upprim"
string picturename = "c:\appscir\Erfvmr_diva\Image\pb_suppr.bmp"
end type

type pb_gratuit from u_pba_gratuit within w_ligne_cde
integer x = 1893
integer y = 1580
integer width = 338
integer height = 152
integer taborder = 0
string text = "&Gratuit  Payant"
string picturename = "c:\appscir\Erfvmr_diva\Image\pbargent.bmp"
end type

type pb_art_nua from u_pba_art_nua within w_ligne_cde
integer x = 1911
integer y = 1760
integer width = 320
integer height = 152
integer taborder = 0
boolean dragauto = false
string picturename = "c:\appscir\Erfvmr_diva\Image\pb_art.bmp"
end type

type dw_mas from u_dwa within w_ligne_cde
event mousemove pbm_mousemove
string tag = "A_TRADUIRE"
integer x = 69
integer y = 24
integer width = 2949
integer height = 516
integer taborder = 0
string dataobject = "d_entete_saisie_cde"
borderstyle borderstyle = styleshadowbox!
end type

event mousemove;/* <DESC>
     Permet de faire apparaitre l'info bulle correspondante au blocage sur lequel la souris est positionnée
   </DESC> */
if not isvalid(itooltip) then
	itooltip = create n_tooltip_mgr
end if
itooltip.of_mousemove_notify(parent, this, getobjectatpointer(), this.x + xpos, this.y + ypos)
end event

type pb_type_livraison from u_pba_type_livraison within w_ligne_cde
integer x = 869
integer y = 1580
integer width = 320
integer height = 152
integer taborder = 0
string text = "Di&recte"
string picturename = "c:\appscir\Erfvmr_diva\Image\pb_usine.bmp"
end type

type pb_affiche_ligne from u_pba within w_ligne_cde
boolean visible = false
integer x = 1216
integer y = 1760
integer width = 320
integer height = 152
integer taborder = 100
string facename = "Arial"
string text = "Aff. &Lignes"
string picturename = "c:\appscir\Erfvmr_diva\Image\pb_saicd.bmp"
end type

on constructor;call u_pba::constructor;// -------------------------------------------------------
// DECLENCHEMENT DE L'EVENEMENT AU NIVEAU DE LA FENÊTRE 
// -------------------------------------------------------
	fu_setevent ("ue_affiche_ligne")
	fu_set_MicroHelp ("Affihage de toutes les lignes de cde")

end on

type pb_rech_ano from u_pba within w_ligne_cde
integer x = 475
integer y = 1760
integer width = 329
integer height = 152
integer taborder = 0
string facename = "Arial"
string text = "Rec&h. Ano"
string picturename = "c:\appscir\Erfvmr_diva\Image\loupe.bmp"
alignment htextalign = right!
vtextalign vtextalign = multiline!
end type

on constructor;call u_pba::constructor;	fu_setevent ("ue_rech_ano")
	fu_set_MicroHelp ("Recherche des lignes en anomalies")
end on

type dw_imp_erreur from u_dwa within w_ligne_cde
boolean visible = false
integer x = 3099
integer y = 48
integer width = 78
integer height = 100
integer taborder = 0
string dataobject = "d_impression_ligne_cde_erreur"
end type

type pb_impr_ano from u_pba within w_ligne_cde
integer x = 846
integer y = 1760
integer width = 357
integer height = 152
integer taborder = 0
string facename = "Arial"
string text = "&Imprim. Ano"
string picturename = "c:\appscir\Erfvmr_diva\Image\pb_imp.bmp"
end type

on constructor;call u_pba::constructor;	fu_setevent ("ue_print")
	fu_set_MicroHelp ("Impression des anomalies")
end on

type nblig_t from statictext within w_ligne_cde
integer x = 3195
integer y = 1584
integer width = 393
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
string text = "Nbr de lignes :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_nbr_lignes from u_slea within w_ligne_cde
integer x = 3579
integer y = 1568
integer width = 274
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
long backcolor = 12632256
boolean displayonly = true
boolean righttoleft = true
end type

type pb_rech_ref from u_pba_recherche_ref within w_ligne_cde
integer x = 82
integer y = 1580
integer width = 375
integer height = 156
integer taborder = 50
boolean bringtotop = true
string picturename = "c:\appscir\Erfvmr_diva\Image\PB_VIDE.bmp"
string disabledname = "c:\appscir\Erfvmr_diva\Image\PB_VIDE.bmp"
end type

type pb_nuance from u_pba_art_nua within w_ligne_cde
boolean visible = false
integer x = 1536
integer y = 1760
integer width = 320
integer height = 152
integer taborder = 110
boolean dragauto = false
boolean bringtotop = true
string text = "&Nuance"
boolean flatstyle = true
string picturename = "c:\appscir\Erfvmr_diva\Image\pb_nua.bmp"
end type

type pb_grossiste from u_pba_type_livraison within w_ligne_cde
boolean visible = false
integer x = 841
integer y = 1580
integer width = 357
integer height = 152
integer taborder = 80
boolean bringtotop = true
string text = "Grossiste"
string picturename = "c:\appscir\Erfvmr_diva\Image\PBGROSTE.BMP"
end type

type pb_edi from u_pba_edi within w_ligne_cde
integer x = 2670
integer y = 1760
integer width = 320
integer height = 152
integer taborder = 60
boolean bringtotop = true
string picturename = "c:\appscir\Erfvmr_diva\Image\PB_INFO.BMP"
string disabledname = "c:\appscir\Erfvmr_diva\Image\PB_INFO.BMP"
end type

type pb_etiquette from u_pba_etiquette within w_ligne_cde
integer x = 2665
integer y = 1572
integer width = 329
integer height = 164
integer taborder = 70
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

type st_cb from statictext within w_ligne_cde
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

type em_cb from u_ema within w_ligne_cde
event ue_ctrl_cb ( )
accessiblerole accessiblerole = sliderrole!
integer x = 3479
integer y = 324
integer width = 576
integer height = 84
integer taborder = 120
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

type pb_annul_cb from u_pba_etiquette within w_ligne_cde
boolean visible = false
integer x = 2670
integer y = 1572
integer width = 329
integer height = 164
integer taborder = 90
boolean bringtotop = true
string text = "."
boolean flatstyle = false
string picturename = "c:\appscir\Erfvmr_diva\Image\suppressioncb.jpg"
string disabledname = "c:\appscir\Erfvmr_diva\Image\suppressioncb.jpg"
end type

type code_barre_t from statictext within w_ligne_cde
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

type st_qte_cb from statictext within w_ligne_cde
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

type sle_qte_cb from singlelineedit within w_ligne_cde
integer x = 3488
integer y = 416
integer width = 338
integer height = 84
integer taborder = 20
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

type pb_colisage_art from u_pba_pt within w_ligne_cde
integer x = 3963
integer y = 696
integer width = 361
integer height = 160
integer taborder = 11
boolean bringtotop = true
integer textsize = -8
string text = "Colisage par Article"
string picturename = "c:\appscir\Erfvmr_diva\Image\PB_VIDE.bmp"
string disabledname = "c:\appscir\Erfvmr_diva\Image\PB_VIDE.bmp"
vtextalign vtextalign = multiline!
end type

event constructor;call super::constructor;
// ------------------------------------
// Déclenche l'évènement de la fenêtre
// ------------------------------------  
	fu_setevent  ("ue_colisage_art")

	fu_set_microhelp ("Colisage par article")
end event

type pb_colisage_art_dim from u_pba_pt within w_ligne_cde
integer x = 3973
integer y = 888
integer width = 361
integer height = 160
integer taborder = 21
boolean bringtotop = true
integer textsize = -8
string text = "Colisage par Article/Dim."
string picturename = "c:\appscir\Erfvmr_diva\Image\PB_VIDE.bmp"
string disabledname = "c:\appscir\Erfvmr_diva\Image\PB_VIDE.bmp"
vtextalign vtextalign = multiline!
end type

event constructor;call super::constructor;// ------------------------------------
// Déclenche l'évènement de la fenêtre
// ------------------------------------  
	fu_setevent  ("ue_colisage_art_dim")

	fu_set_microhelp ("Colisage par article - dimension")
end event

type pb_colisage_supp from u_pba_pt within w_ligne_cde
integer x = 3973
integer y = 1108
integer width = 361
integer height = 160
integer taborder = 31
boolean bringtotop = true
integer textsize = -8
string text = "Suppression Colisage"
boolean cancel = true
string picturename = "c:\appscir\Erfvmr_diva\Image\PB_VIDE.bmp"
string disabledname = "c:\appscir\Erfvmr_diva\Image\PB_VIDE.bmp"
vtextalign vtextalign = multiline!
end type

event constructor;call super::constructor;// ------------------------------------
// Déclenche l'évènement de la fenêtre
// ------------------------------------  
	fu_setevent  ("ue_colisage_supp")

	fu_set_microhelp ("Suppression Colisage")
end event

type r_cb from rectangle within w_ligne_cde
long linecolor = 16711680
integer linethickness = 6
long fillcolor = 12632256
integer x = 3077
integer y = 300
integer width = 1033
integer height = 224
end type

