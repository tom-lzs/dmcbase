$PBExportHeader$nv_ligne_cde_object.sru
$PBExportComments$Contient toutes les régles de mise à jour des lignes de commande
forward
global type nv_ligne_cde_object from nonvisualobject
end type
end forward

global type nv_ligne_cde_object from nonvisualobject
end type
global nv_ligne_cde_object nv_ligne_cde_object

type variables
nv_commande_object i_nv_commande
long    il_dernier_num_ligne = 0
long    il_dernier_numero_page = 0
integer   ii_nbr_ligne_validee = 0

nv_reference_vente  inv_reference_object



end variables

forward prototypes
public function boolean fu_affichage_dimension_tarif (ref string as_article, ref decimal as_prix, ref string as_dimension)
public subroutine fu_validation_complete (ref datawindow adw_lignes_cde)
public function boolean fu_is_ligne_promotionnelle (long al_row, ref datawindow adw_ligne_cde)
public subroutine fu_init_valeur_ligne_cde_simple (ref datawindow adw_ligne_cde)
public subroutine fu_init_valeur_ligne_cde_par_bon_cde (ref datawindow adw_ligne_cde)
public subroutine fu_init_info_commande (any anv_commande)
public subroutine fu_init_valeur_ligne_cde_catalogue (ref datawindow adw_ligne_cde)
public subroutine fu_init_valeur_ligne_cde_promo (ref datawindow adw_ligne_cde, string as_promo)
public function string fu_get_nouveau_numero_ligne ()
public subroutine fu_init_valeur_ligne_cde_operatrice (ref datawindow adw_ligne_cde)
public subroutine fu_incremente_num_page ()
public subroutine fu_init_num_page (ref datawindow adw_ligne_cde)
public function decimal fu_get_max_page ()
public function integer fu_get_nbr_ligne_validee ()
public function boolean fu_existe_ligne_pour_catalogue (string as_cde, string as_catalogue, ref string as_type_tarif)
public subroutine fu_calcul_montant_ligne (ref datawindow adw_ligne_cde, integer al_row)
public subroutine fu_calcul_montant_ligne_avec_datastore (ref datastore adw_ligne_cde, integer al_row)
public function integer fu_controle_doublons_mode_rapide (string as_article, string as_dimension, string as_num_ligne, ref datastore adw_lignes_cde, string as_type_saisie, decimal adec_qte, ref datawindow adw_ligne_cde_ecran)
public function boolean fu_controle_saisie_operatrice (ref datawindow adw_lignes_cde, string as_numero_cde, long al_row, ref datastore ads_ttes_lignes_cde)
public subroutine fu_get_tarif_ligne (long al_row, ref datawindow adw_ligne_cde, boolean ab_option_gratuit_payant)
public function boolean fu_is_substitution_autorise ()
public function boolean fu_controle_et_maj_ligne_cde (long al_row, ref datawindow adw_ligne_cde, boolean ab_mode_saisie_dimension, boolean ab_mode_validation_complete)
public function integer fu_controle_doublons (ref datawindow adw_lignes_cde, string as_article, string as_dimension, string as_type_saisie, long al_row, ref long al_row_maj)
end prototypes

public function boolean fu_affichage_dimension_tarif (ref string as_article, ref decimal as_prix, ref string as_dimension);/* <DESC>
	Permet d'afficher la fenêtre de sélection des références dans le cas ou une anomalie sur référence inexistante a été
	détectée durant le contrôle d'une ligne de commande et que l'utilisateur souhaite recherche la référence pour correction
   </DESC> */
str_pass l_str_work
l_str_work.s[1] = as_article
l_str_work.s[2] = as_dimension
l_str_work.s[3] = DONNEE_VIDE
l_str_work.s[4] = DONNEE_VIDE
l_str_work.s[5] = i_nv_commande.fu_get_liste_prix()
l_str_work.s[6] = i_nv_commande.fu_get_devise()
l_str_work.s[7] = DONNEE_VIDE 
l_str_work.b[1] = false

OpenWithParm (w_liste_reference_tarifs, l_str_work)
l_str_work = Message.fnv_get_str_pass()
Message.fnv_clear_str_pass()
CHOOSE CASE l_str_work.s_action
	CASE ACTION_OK
		as_article 	 = l_str_work.s[1]
		as_dimension = l_str_work.s[2]		
		as_prix      = l_str_work.d[1]		
		return true
	CASE ELSE
		return false
END CHOOSE
 
end function

public subroutine fu_validation_complete (ref datawindow adw_lignes_cde);/* <DESC>
     Permet d'effectuer le controle de toutes les lignes de commande contenues dans la datawindow
	  Cette fonction est sollicitée lors de la validation en fin de saisie des lignes et le controle ne 
	  s'effectuera que pour les lignes non validées
   </DESC> */
Long    l_row
boolean lb_maj = false

ii_nbr_ligne_validee = 0 
for l_row = 1 to adw_lignes_cde.RowCount()
	if adw_lignes_cde.getItemString(l_row,DBNAME_CODE_MAJ) = CODE_MODE_RAPIDE then
	  ii_nbr_ligne_validee = l_row
    	  fu_controle_et_maj_ligne_cde(l_row, adw_lignes_cde,false, true)
	  lb_maj = true
	end if
next

if lb_maj then
   adw_lignes_cde.update()
end if

end subroutine

public function boolean fu_is_ligne_promotionnelle (long al_row, ref datawindow adw_ligne_cde);/* <DESC> 
     Détermine  si la line de commande est une ligne promotionnelle ou non
   </DESC> */
if adw_ligne_cde.GetitemString(al_row,DBNAME_TYPE_SAISIE) = CODE_SAISIE_PROMO or &
   adw_ligne_cde.GetitemString(al_row,DBNAME_TYPE_SAISIE) = CODE_SAISIE_PUBLI_PROMO then	
	return true
else
	return false
end if
end function

public subroutine fu_init_valeur_ligne_cde_simple (ref datawindow adw_ligne_cde);/* <DESC> 
     Initialise les valeurs par défaut de la datawindow qui seront prise en compte lors de la création d'une nouvelle
	  ligne dans la datawindow.
	  Ceci evite lors de la mise à jour d'une ligne de commande de controler s'il s'agit d'une nouvelle ligne et donc d'initialiser 
	  les informations par défaut par du script.
   </DESC> */
adw_ligne_cde.Modify (DBNAME_DATE_CREATION + ".Initial =" + "'" + String (SQLCA.fnv_get_datetime ()) + "'")
adw_ligne_cde.Modify (DBNAME_CODE_MAJ + ".Initial ='" + BLANK +"'")
adw_ligne_cde.Modify (DBNAME_NUM_CDE + ".Initial =" + "'" + i_nv_commande.fu_get_numero_cde() + "'")
adw_ligne_cde.Modify (DBNAME_ARTICLE + ".Initial ='" + BLANK +"'")
adw_ligne_cde.Modify (DBNAME_DIMENSION + ".Initial = '" + BLANK +"'")
adw_ligne_cde.Modify (DBNAME_QTE + ".Initial ='0'") 
adw_ligne_cde.Modify (DBNAME_PAYANT_GRATUIT + ".Initial ='"+ CODE_PAYANT +"'")
adw_ligne_cde.Modify (DBNAME_REMISE_LIGNE + ".Initial ='0'")
adw_ligne_cde.Modify (DBNAME_CODE_PROMO + ".Initial ='" + BLANK +"'")
adw_ligne_cde.Modify (DBNAME_TARIF + ".Initial ='0'")
adw_ligne_cde.Modify (DBNAME_MONTANT_REMISE_LIGNE+ ".Initial ='0'")
adw_ligne_cde.Modify (DBNAME_DATE_PRIX + ".Initial ='" + DATE_DEFAULT_SYBASE + "'")
adw_ligne_cde.Modify (DBNAME_TYPE_LIGNE + ".Initial ='" + TYPE_LIGNE_DIRECT + "'")
adw_ligne_cde.Modify (DBNAME_MODE_PAIEMENT + ".Initial ='" + BLANK +"'")
adw_ligne_cde.Modify (DBNAME_CODE_ECHEANCE + ".Initial ='" + BLANK +"'")
adw_ligne_cde.Modify (DBNAME_DATE_LIVRAISON + ".Initial ='" + DATE_DEFAULT_SYBASE + "'")
adw_ligne_cde.Modify (DBNAME_GROSSISTE + ".Initial ='" + BLANK +"'")
adw_ligne_cde.Modify (DBNAME_CODE_CATALOGUE + ".Initial ='" + BLANK +"'")
adw_ligne_cde.Modify (DBNAME_MONTANT_LIGNE+ ".Initial ='0'")
adw_ligne_cde.Modify (DBNAME_TYPE_SAISIE+ ".Initial ='" + CODE_SAISIE_SIMPLE + "'")
adw_ligne_cde.Modify (DBNAME_CODE_ERREUR_LIGNE+ ".Initial ='" + BLANK + "'")
adw_ligne_cde.Modify (DBNAME_CODE_PAGE+ ".Initial ='0'")
adw_ligne_cde.Modify (DBNAME_QTE_UN + ".Initial ='0'") 

end subroutine

public subroutine fu_init_valeur_ligne_cde_par_bon_cde (ref datawindow adw_ligne_cde);/* <DESC> 
     Initialise les valeurs par défaut de la datawindow qui seront prise en compte lors de la création d'une nouvelle
	  ligne dans la datawindow.
	  Ceci evite lors de la mise à jour d'une ligne de commande de controler s'il s'agit d'une nouvelle ligne et donc d'initialiser 
	  les informations par défaut par du script.
   </DESC> */
if g_nv_workflow_manager.fu_get_fenetre_origine() = FENETRE_LIGNE_CDE_OPERATRICE then
	fu_init_valeur_ligne_cde_operatrice(adw_ligne_cde)
	adw_ligne_cde.Modify (DBNAME_TYPE_SAISIE+ ".Initial ='" + CODE_SAISIE_BON_CDE + "'")	
	il_dernier_numero_page ++
	adw_ligne_cde.Modify (DBNAME_CODE_PAGE + ".Initial ='" + String(il_dernier_numero_page) + "'")	
else
	fu_init_valeur_ligne_cde_simple(adw_ligne_cde)
	adw_ligne_cde.Modify (DBNAME_TYPE_SAISIE+ ".Initial ='" + CODE_SAISIE_BON_CDE + "'")
end if

adw_ligne_cde.Modify (DBNAME_CODE_MAJ+ ".Initial ='" + CODE_MODE_RAPIDE + "'")
end subroutine

public subroutine fu_init_info_commande (any anv_commande);/* <DESC>
      Permet d'initialiser le dernier n° de ligne de commande crée pour la commande
      en cours de traitement
   </DESC> */
i_nv_commande = anv_commande

Datastore lds_max_ligne 
lds_max_ligne = CREATE Datastore
lds_max_ligne.Dataobject = "d_object_max_num_ligne_cde"
lds_max_ligne.SetTransObject(sqlca)
lds_max_ligne.retrieve(i_nv_commande.fu_get_numero_cde())

// recherche du dernier n° de commande
if lds_max_ligne.rowCount() = 0 then
	il_dernier_num_ligne = 0
	return
end if

if isNull(lds_max_ligne.getItemString(lds_max_ligne.rowCount(),DBNAME_NUM_LIGNE)) then
	il_dernier_num_ligne = 0
	return
end if

il_dernier_num_ligne = double (lds_max_ligne.getItemString(lds_max_ligne.rowCount(),DBNAME_NUM_LIGNE))

	

end subroutine

public subroutine fu_init_valeur_ligne_cde_catalogue (ref datawindow adw_ligne_cde);/* <DESC> 
     Initialise les valeurs par défaut de la datawindow qui seront prise en compte lors de la création d'une nouvelle
	  ligne dans la datawindow.
	  Ceci evite lors de la mise à jour d'une ligne de commande de controler s'il s'agit d'une nouvelle ligne et donc d'initialiser 
	  les informations par défaut par du script.
   </DESC> */

fu_init_valeur_ligne_cde_par_bon_cde(adw_ligne_cde)
adw_ligne_cde.Modify (DBNAME_TYPE_SAISIE+ ".Initial ='" + CODE_SAISIE_CATALOGUE + "'")
adw_ligne_cde.Modify( DBNAME_CODE_MAJ+ ".Initial ='" +CODE_MODE_RAPIDE + "'")

end subroutine

public subroutine fu_init_valeur_ligne_cde_promo (ref datawindow adw_ligne_cde, string as_promo);/* <DESC> 
     Initialise les valeurs par défaut de la datawindow qui seront prise en compte lors de la création d'une nouvelle
	  ligne dans la datawindow.
	  Ceci evite lors de la mise à jour d'une ligne de commande de controler s'il s'agit d'une nouvelle ligne et donc d'initialiser 
	  les informations par défaut par du script.
   </DESC> */
fu_init_valeur_ligne_cde_simple(adw_ligne_cde)
adw_ligne_cde.Modify (DBNAME_TYPE_SAISIE+ ".Initial ='" + CODE_SAISIE_PROMO + "'")
adw_ligne_cde.Modify (DBNAME_CODE_PROMO + ".Initial ='" + as_promo + "'")

end subroutine

public function string fu_get_nouveau_numero_ligne ();/* <DESC>
       Incremente le dernier n° de ligne de commande et retourne la valeur pour completer la ligne de 
		 commande en cours de creation.
   </DESC> */

String s_num

il_dernier_num_ligne = il_dernier_num_ligne + 1
s_num	= string (il_dernier_num_ligne)
do until len (s_num) = LONG_NUM_LIGNE
	s_num = "0" + s_num 
loop

return s_num
end function

public subroutine fu_init_valeur_ligne_cde_operatrice (ref datawindow adw_ligne_cde);/* <DESC> 
     Initialise les valeurs par défaut de la datawindow qui seront prise en compte lors de la création d'une nouvelle
	  ligne dans la datawindow.
	  Ceci evite lors de la mise à jour d'une ligne de commande de controler s'il s'agit d'une nouvelle ligne et donc d'initialiser 
	  les informations par défaut par du script.
   </DESC> */
// recherche du dernier numero de page de la commande
Datastore lds_max_numero
lds_max_numero = CREATE Datastore
lds_max_numero.Dataobject = "d_object_max_num_page"
lds_max_numero.SetTransObject(sqlca)
lds_max_numero.retrieve(i_nv_commande.fu_get_numero_cde())

// recherche du dernier n° de commande
if lds_max_numero.rowCount() = 0 then
	il_dernier_numero_page = 1
	
elseif isNull(lds_max_numero.getItemDecimal(lds_max_numero.rowCount(),DBNAME_CODE_PAGE)) then
 	il_dernier_numero_page = 1
else	 
	il_dernier_numero_page = double (lds_max_numero.getItemDecimal(lds_max_numero.rowCount(),DBNAME_CODE_PAGE))	
end if

// INITIALISATION DES VALEURS PAR DEFAUT
fu_init_valeur_ligne_cde_simple(adw_ligne_cde)
adw_ligne_cde.Modify (DBNAME_TYPE_SAISIE+ ".Initial ='" + CODE_SAISIE_OPERATRICE + "'")
adw_ligne_cde.Modify (DBNAME_CODE_PAGE + ".Initial ='" + String(il_dernier_numero_page) + "'")
adw_ligne_cde.Modify (DBNAME_CODE_MAJ+ ".Initial ='" + CODE_MODE_RAPIDE + "'")

end subroutine

public subroutine fu_incremente_num_page ();/* <DESC>
     Increment le n° de page pour permettre pour permettre une  nouvelle saisie lors du saisie des lignes
	  en mode operatrice
   </DESC> */
il_dernier_numero_page = il_dernier_numero_page + 1

end subroutine

public subroutine fu_init_num_page (ref datawindow adw_ligne_cde);/* <DESC> 
     Permet l'initialisation du n° de la page sur la dtawindow de création des lignes de commande en
	  mode operatrice
   </DESC> */
adw_ligne_cde.Modify (DBNAME_CODE_PAGE + ".Initial ='" + String(il_dernier_numero_page) + "'")

end subroutine

public function decimal fu_get_max_page ();/* <DESC> 
     Retourne le dernier n° de page saisi lors de la saisie de la commande en mode
	  opératrice
   </DESC> */
return il_dernier_numero_page	

end function

public function integer fu_get_nbr_ligne_validee ();/* <DESC>
     Permet de retouner le nombre de lignes de commande validée lors du controle complet des lignes
	  de commande
   </DESC> */
return ii_nbr_ligne_validee
end function

public function boolean fu_existe_ligne_pour_catalogue (string as_cde, string as_catalogue, ref string as_type_tarif);/* <DESC>
     Permet de controle si des lignes de commande ont déjà été saisi sur la catalogue sélectionné
	 si tel est le cas retour du type de tarif utilisé.
   </DESC> */
datastore ldw_lignes_cde 
boolean   lb_return

ldw_lignes_cde = create datastore
ldw_lignes_cde.dataobject = "d_object_ligne_cde_catalogue"
ldw_lignes_cde.setTransObject(sqlca)

if ldw_lignes_cde.retrieve (as_cde,as_catalogue) = - 1 then
	f_dmc_error ("Nv_reference : reference vente " +  BLANK + DB_ERROR_MESSAGE)
end if

if ldw_lignes_cde.Rowcount() = 0 then
	as_type_tarif = DONNEE_VIDE
	lb_return = false
else
	as_type_tarif = ldw_lignes_cde.getItemString(1,DBNAME_TYPE_SAISIE)
	lb_return = true
end if

destroy ldw_lignes_cde
return lb_return

end function

public subroutine fu_calcul_montant_ligne (ref datawindow adw_ligne_cde, integer al_row);/* <DESC>
    Cette fonction utilise comme paramètre en entrée la datawindow contenant les lignes de commande en cours
	 de contrôle.Permet de calculer le montant HT et montant remise de la ligne 
	 
	- S'il s'agit d'une ligne de cde payante et ligne non promotionelle
			Montant ligne 	=	(Qte * Tarif) - %Remise ligne
			Montant remise =  (Qte * Tarif) - Montant ligne
			
	- S'il s'agit d'une ligne de cde payante et ligne promotionelle
			Montant ligne 	=	(Qte * Tarif) - %Remise ligne - % Remise commande
			Montant remise =  (Qte * Tarif) - Montant ligne
			
	- S'il s'agit d'une ligne de cde gratuite
			Montant ligne = 0
              Montant remise	=	Qte * Tarif
   </DESC> */
Decimal			dec_qte
Decimal			dec_remise_ligne 
Decimal			dec_remise_cde
Decimal			dec_total_remise
Decimal			dec_montant_ligne
Decimal			dec_tarif
String               ls_payant_gratuit
String               ls_type_saisie

dec_qte 				= adw_ligne_cde.GetItemDecimal (al_row, DBNAME_QTE_UN)
dec_tarif				= adw_ligne_cde.GetItemDecimal (al_row, DBNAME_TARIF)	
ls_payant_gratuit 	= adw_ligne_cde.GetItemString(al_row, DBNAME_PAYANT_GRATUIT)	
ls_type_saisie 		= adw_ligne_cde.GetItemString(al_row, DBNAME_TYPE_SAISIE)	

dec_remise_ligne	= 0 
dec_remise_cde 	= 0 

IF ls_payant_gratuit = CODE_PAYANT THEN
	dec_montant_ligne = dec_qte * dec_tarif * (1 - (dec_remise_ligne / 100)) 
	
	If ls_type_saisie = CODE_SAISIE_PROMO then
		dec_montant_ligne	= dec_montant_ligne  * (1 - (dec_remise_cde	 / 100))
	End if
	
	dec_total_remise 	= (dec_qte * dec_tarif) - dec_montant_ligne
	
	//----- Lignes gratuites ----	
ELSE
	dec_montant_ligne = 0
	dec_total_remise 	= dec_qte * dec_tarif
END IF

adw_ligne_cde.setItem(al_row, DBNAME_MONTANT_REMISE_LIGNE,	Round (dec_total_remise, 2))
adw_ligne_cde.setItem(al_row, DBNAME_MONTANT_LIGNE,	Round (dec_montant_ligne, 2))

end subroutine

public subroutine fu_calcul_montant_ligne_avec_datastore (ref datastore adw_ligne_cde, integer al_row);/* <DESC>
    Cette fonction utilise comme paramètre en entrée la datastore contenant les lignes de commande en cours
	 de contrôle.Permet de calculer le montant HT et montant remise de la ligne 
	 
	- S'il s'agit d'une ligne de cde payante et ligne non promotionelle
			Montant ligne 	=	(Qte * Tarif) - %Remise ligne
			Montant remise =  (Qte * Tarif) - Montant ligne
			
	- S'il s'agit d'une ligne de cde payante et ligne promotionelle
			Montant ligne 	=	(Qte * Tarif) - %Remise ligne - % Remise commande
			Montant remise =  (Qte * Tarif) - Montant ligne
			
	- S'il s'agit d'une ligne de cde gratuite
			Montant ligne = 0
              Montant remise	=	Qte * Tarif
   </DESC> */
Decimal			dec_qte
Decimal			dec_remise_ligne 
Decimal			dec_remise_cde
Decimal			dec_total_remise
Decimal			dec_montant_ligne
Decimal			dec_tarif
String               ls_payant_gratuit
String               ls_type_saisie

dec_qte 				= adw_ligne_cde.GetItemDecimal (al_row, DBNAME_QTE_UN)
dec_tarif				= adw_ligne_cde.GetItemDecimal (al_row, DBNAME_TARIF)	
ls_payant_gratuit 	= adw_ligne_cde.GetItemString(al_row, DBNAME_PAYANT_GRATUIT)	
ls_type_saisie 		= adw_ligne_cde.GetItemString(al_row, DBNAME_TYPE_SAISIE)	

dec_remise_ligne	= 0 
dec_remise_cde 	= 0 
	//----- Lignes payantes   -
IF ls_payant_gratuit = CODE_PAYANT THEN
	dec_montant_ligne = dec_qte * dec_tarif * (1 - (dec_remise_ligne / 100)) 
	
	If ls_type_saisie = CODE_SAISIE_PROMO then
		dec_montant_ligne	= dec_montant_ligne  * (1 - (dec_remise_cde	 / 100))
	End if
	
	dec_total_remise 	= (dec_qte * dec_tarif) - dec_montant_ligne
	
	//----- Lignes gratuites ----	
ELSE
	dec_montant_ligne = 0
	dec_total_remise 	= dec_qte * dec_tarif
END IF

   adw_ligne_cde.setItem(al_row, DBNAME_MONTANT_REMISE_LIGNE,	Round (dec_total_remise, 2))
   adw_ligne_cde.setItem(al_row, DBNAME_MONTANT_LIGNE,	Round (dec_montant_ligne, 2))


end subroutine

public function integer fu_controle_doublons_mode_rapide (string as_article, string as_dimension, string as_num_ligne, ref datastore adw_lignes_cde, string as_type_saisie, decimal adec_qte, ref datawindow adw_ligne_cde_ecran);/* <DESC>
		Fonction appelée en mode opératrice.
		En paramètre les données passées sont 2 nature :
				- la datawindow de saisie est passée  et ne contient que les lignes de commande pour une page donnée
				- La datastore qui contient toutes les lignes de la commande
		
        Contrôle doublon :
			   SI une ligne est déjà existante dans la datatstore des lignes de commande,
				affichage d'un message pour permettre soit de :
					- cumuler la quantité sur la ligne existante,
					- conserver la ligne en double
					- supprimer la saisie de la ligne
		
	  Si cumul de la quantité sur la ligne existante, cumul de la quantité saisie avec la quantité de la ligne et ceci dans
	  la datatsore contenant toutes les lignes et remise à zéro de la quantité dans la ligne en cours de saisie et ceci
	  dans la datawindow
	  
       Un code retour est positionnée afin de spécifier si la ligne a été cumulée et donc il faudra supprimer
		 la ligne (-1), conserve la ligne (0), suppression de la ligne (-1)
		 
   </DESC> */// ---------------------------------
// DECLARATION DES VARIABLES LOCALES
// ---------------------------------
Long			l_doublon
Long           l_ligne
Integer		i_reponse
Decimal{2}	dec_qte

// RECHERCHE LIGNE EN DOUBLE

l_doublon =	adw_lignes_cde.Find (  &
			DBNAME_ARTICLE     + " ='" + as_article     + "'and " + &
			DBNAME_DIMENSION   + " ='" + as_dimension   + "'and " + &
			DBNAME_TYPE_SAISIE + " ='" + as_type_saisie + "'and " + &
			DBNAME_QTE         + " <> 0 "   +                             "and "  + &
			DBNAME_NUM_LIGNE  + " <> '" + as_num_ligne  +  "'", &
			1,adw_lignes_cde.RowCount())

if l_doublon = 0 then
	return 0
end if
		
// EXISTENCE D'UN DOUBLON , QUE FAIRE
dec_qte = adw_lignes_cde.GetItemDecimal (l_doublon , DBNAME_QTE) 

i_reponse = messagebox (g_nv_traduction.get_traduction("CONTROLE_DOUBLON"),&
                                   	g_nv_traduction.get_traduction("CONTROLE_DOUBLON_REFERENCE") + as_article + " " + as_dimension +  " " + &
												  g_nv_traduction.get_traduction("CONTROLE_DOUBLON_REFERENCE2") + + " " + &
												  String(dec_qte) + "~r~n ~r~n" + &
                                        g_nv_traduction.get_traduction("CONTROLE_DOUBLON_OPTION1") + " ~r~n ~r~n" + &
								g_nv_traduction.get_traduction("CONTROLE_DOUBLON_OPTION2") + " ~r~n ~r~n"  + &
								g_nv_traduction.get_traduction("CONTROLE_DOUBLON_OPTION3"), &
								StopSign!,YesNoCancel!)						 

CHOOSE CASE i_reponse
	case 1
		dec_qte   = dec_qte + adec_qte
          adw_lignes_cde.SetItem (l_doublon, DBNAME_QTE, dec_qte)
          fu_calcul_montant_ligne_avec_datastore (adw_lignes_cde, l_doublon)
			 
		l_ligne  =	adw_ligne_cde_ecran.Find (  &
						DBNAME_NUM_LIGNE  + " = '" + as_num_ligne  +  "'", &
						1,adw_ligne_cde_ecran.RowCount())
		if l_ligne >  0 then
			adw_ligne_cde_ecran.SetItem(l_ligne,DBNAME_QTE,0)
		end if
          l_ligne  =	adw_lignes_cde.Find (  &
						DBNAME_NUM_LIGNE  + " = '" + as_num_ligne  +  "'", &
						1,adw_lignes_cde.RowCount())
		if l_ligne >  0 then
			adw_lignes_cde.SetItem(l_ligne,DBNAME_QTE,0)
		end if		
		return -1	
	case 2
		return 0
	case 3
		return -1
END CHOOSE

end function

public function boolean fu_controle_saisie_operatrice (ref datawindow adw_lignes_cde, string as_numero_cde, long al_row, ref datastore ads_ttes_lignes_cde);/* <DESC>
     Effectue les controles de la ligne de commande saisie.
	- Controle du mode de saisie de la référence ( Article ou Dimension) . Si mode Dimension, Rercherche de l'article
	sur la ligne précédente puis alimentation de l'article sur la ligne en cours de controle.
	- Si la Quantité saisie est à zéro, initialisation à 1.
	- Rercherche si existence de la référence dans le facilité de saisie, si tel est le cas l'article et la dimension
	sont remplacés par la véritable référence de vente.

	- Controle de l'existence d'un doublon. SI existence d'un doublon et demande de suppression de la ligne,
	 mise à jour de la ligne en alimentant le code mise à jour à SUPPRIMER et ceci pour permettre la suppression de la
	 ligne lors du retour dans le script d'appel.
	 
	 - Controle de l'existence de la reference, Si reference inexistante, mise à jour de la ligne en positionnent le code 
	 erreur reference inexistante sur la ligne 
	
	- Si la reference est une reference gratuite, mise à zéro du tarif
	sinon recherche du tarif. Si tarif inexistant, mise à jour de la ligne en positionnent le code erreur tarif inexistant
  </DESC> */
String  s_article
String  s_dimension
decimal dec_qte_saisie
boolean  lb_validation_ok = true
decimal dec_tarif

// Réinitialisation de l'enregistrement avant contrôle
	adw_lignes_cde.SetItem (al_row, DBNAME_CODE_ERREUR_LIGNE, CODE_AUCUNE_ERREUR)

// Préparation de la référence saisie
	s_article 				= adw_lignes_cde.GetItemString (al_row, DBNAME_ARTICLE)
	s_dimension	 	= adw_lignes_cde.GetItemString (al_row, DBNAME_DIMENSION)
	dec_qte_saisie		= adw_lignes_cde.GetItemDecimal(al_row, DBNAME_QTE)
	If IsNull (s_article) Or trim(s_article) = DONNEE_VIDE  then
		s_article =	BLANK
	End if	
	If IsNull(s_dimension) Or trim(s_dimension) = DONNEE_VIDE  then
		s_dimension = BLANK
	End if
	If s_article	=	BLANK	and s_dimension =	BLANK	then
		return false
	end if
	IF dec_qte_saisie = 0 THEN
		dec_qte_saisie = 1
		adw_lignes_cde.SetItem(al_row,DBNAME_QTE,1)
	END IF

// Controle si la reference est dans le facilite de saisie
	if fu_is_substitution_autorise() then
		inv_reference_object.fu_controle_facilite_saisie(s_article,s_dimension)
		adw_lignes_cde.SetItem(al_row,DBNAME_ARTICLE,s_article)		
		adw_lignes_cde.SetItem(al_row,DBNAME_DIMENSION,s_dimension)	
	end if
	if fu_controle_doublons_mode_rapide (s_article,s_dimension, &
				     	adw_lignes_cde.getItemString(al_row,DBNAME_NUM_LIGNE), &
				          ads_ttes_lignes_cde ,  &
						adw_lignes_cde.getItemString(al_row,DBNAME_TYPE_SAISIE), &
						adw_lignes_cde.getItemDecimal(al_row,DBNAME_QTE), &
						adw_lignes_cde)					 = -1 then
		adw_lignes_cde.setItem(al_row,DBNAME_CODE_MAJ, CODE_SUPPRESSION)
		ads_ttes_lignes_cde.update()
		adw_lignes_cde.update()
		return true
	end if

// CONTROLE REFERENCE 
	if not inv_reference_object.fu_controle_reference(s_article, s_dimension) then
		adw_lignes_cde.SetItem (al_row, DBNAME_CODE_ERREUR_LIGNE, CODE_REFERENCE_INEXISTANTE)
		return false
	end if
	
// Si le type de commande précise que la commande ne doit pas être valoriser, pas de recherche du tarif.
    if not  i_nv_commande.fu_is_commande_valorisable() then
     	adw_lignes_cde.SetItem (al_row, DBNAME_TARIF, 0)
		return true
   end if

  if inv_reference_object. fu_is_reference_gratuite()  then
		adw_lignes_cde.SetItem (al_row, DBNAME_PAYANT_GRATUIT, CODE_GRATUIT)
     	adw_lignes_cde.SetItem (al_row, DBNAME_TARIF, 0)
		return true
  end if
 
   if inv_reference_object.fu_get_tarif_article ( s_article, dec_tarif, &
															  i_nv_commande.fu_get_liste_prix(), &
															  i_nv_commande.fu_get_devise() ,&
															  adw_lignes_cde.GetItemString(al_row,DBNAME_TYPE_LIGNE), &
															  adw_lignes_cde.GetItemSTring(al_row,DBNAME_CODE_CATALOGUE	), &
															  adw_lignes_cde.GetItemString(al_row,DBNAME_DIMENSION), false ) then
	 adw_lignes_cde.SetItem (al_row, DBNAME_TARIF, dec_tarif)																
  else																
	 adw_lignes_cde.SetItem (al_row, DBNAME_CODE_ERREUR_LIGNE, CODE_TARIF_INEXISTANT)
  end if	
  
return true
end function

public subroutine fu_get_tarif_ligne (long al_row, ref datawindow adw_ligne_cde, boolean ab_option_gratuit_payant);/* <DESC>
     Recherche du tarif de la référence de la ligne de commande en cours de controle
	 - Controle de l'existence de la reference, si inexistant tarif = 0 et code erreur ligne = Ref Inexistante
	   fin de la recherche
	- Recherche du tarif pour la référence de la ligne de commande.
	 Si tarif inexistant, code erreur de la ligne = Tarif inexistant
	 Sinon alimentation du tarif
   </DESC> */
str_pass				  l_str_work
nv_reference_vente  lnv_reference_object
String      		  s_article
String      		  s_dimension
Decimal					dec_tarif

lnv_reference_object = CREATE nv_reference_vente

s_article 		= adw_ligne_cde.GetItemString (al_row, DBNAME_ARTICLE)
s_dimension	 	= adw_ligne_cde.GetItemString (al_row, DBNAME_DIMENSION)

if not lnv_reference_object.fu_controle_reference(s_article, s_dimension) then
	adw_ligne_cde.SetItem (al_row, DBNAME_CODE_ERREUR_LIGNE, CODE_REFERENCE_INEXISTANTE)
	adw_ligne_cde.SetItem (al_row, DBNAME_TARIF, 0)	
	destroy lnv_reference_object
	return
end if

// controle existence du tarif
if lnv_reference_object.fu_get_tarif_article ( s_article, dec_tarif, &
															  i_nv_commande.fu_get_liste_prix(), &
															  i_nv_commande.fu_get_devise(), &
															  adw_ligne_cde.GetItemString(al_row,DBNAME_TYPE_LIGNE), &
															  adw_ligne_cde.GetItemSTring(al_row,DBNAME_CODE_CATALOGUE	), &
															  adw_ligne_cde.GetItemString(al_row,DBNAME_DIMENSION), &
															  ab_option_gratuit_payant) then
	adw_ligne_cde.SetItem (al_row, DBNAME_TARIF, dec_tarif)																
else																
	adw_ligne_cde.SetItem (al_row, DBNAME_CODE_ERREUR_LIGNE, CODE_TARIF_INEXISTANT)
	adw_ligne_cde.SetItem (al_row, DBNAME_TARIF, 0)
end if

destroy lnv_reference_object
end subroutine

public function boolean fu_is_substitution_autorise ();String ls_visiteur
nv_come9par_commande lnv_come9par
lnv_come9par = create nv_come9par_commande

ls_visiteur = i_nv_commande.fu_get_visiteur_cde()
lnv_come9par.retrievedata( ls_visiteur)

return lnv_come9par.is_substitution_autorisee()

end function

public function boolean fu_controle_et_maj_ligne_cde (long al_row, ref datawindow adw_ligne_cde, boolean ab_mode_saisie_dimension, boolean ab_mode_validation_complete);/* <DESC>
     Ce module est appelé lors du controle de chaque ligne ou lors du controle de validation complet des lignes
	  qui s'effectue lors de la validation de fin de saisie des lignes.
	  	Dans les cas de la validation complète, seules les lignes dans le code mise à jour est positionné à R 
			  sont controlées et dans le cas d'anomalie aucun message n'est affiché mais le code erreur de la ligne
			  est postionnée.
     
	 Initialisation des données :
	 	- En validation complète (F11 sur les lignes de cde), si une ligne de commande est positionnée en erreur Qte Edi, 
		 	elle restera positionnée  pour obliger la modificaiton de la ligne.
	     - Si le mode saisie de la ligne est postionnée sur dimension, Alimentation de l'article avec l'article de la ligne
		   précédente si celui n'est pas alimenté
		- Initialisation de la qté à 1 si non alimentée.
		
    Les controles :
	 
	 - Si la substitution est autorisée pour le visiteur de la commande,
	 	Rercherche si existence de la référence dans le facilité de saisie, si tel est le cas la reference saisie
	      est remplacé par la véritable référence de vente.
			
	- Controle de l'existence d'un doublon. 
	SI existence d'un doublon et demande de suppression de la ligne,
	 mise à jour de la ligne en alimentant le code mise à jour à SUPPRIMER et ceci pour permettre la suppression de la
	 ligne lors du retour dans le script d'appel.
	 Ce controle ne s'effectue pas en validation complète (F11 sur les lignes de cde) mais uniquement sur le controle 
	   ligne par ligne
	 
	 - Controle de l'existence de la reference, 
	 Si inexistante et demande de suppresion de la saisie, 
 		mise à jour de la ligne en alimentant le code mise à jour à SUPPRIMER et ceci pour permettre la suppression de la
		ligne lors du retour dans le script d'appel. 
	 Si reference inexistante et la ligne doit être conservée,
 		mise à jour de la ligne en alimentant le code mise à jour à RAPIDE et ceci pour et ceci pour spécifier que
		la ligne n 'a pas été controlée complètement	, positionnement du code erreur reference inexistante sur la ligne et
		fin du controle.
	Si existence de referencement client,
	   Controle si la reference est autorisée à la saisie pour le client ou pour l'enseigne
	   Si saisie interdite, affichage d'un message et suppression de la ligne
	
	- Controle de l'existence du tarif. 
	Si le code gratuit/ payant est à gratuit, Tarif = 0 et mise à jour de la ligne en alimentant le
	code mise à jour à SAISIE MODE SIMPLE et ceci pour specifier que la ligne a été entierement controlée et sans
	erreur.
	Si la commande est  non valorisable Tarif = 0 et mise à jour de la ligne en alimentant le
	code mise à jour à SAISIE MODE SIMPLE et ceci pour specifier que la ligne a été entierement controlée et sans
	erreur.
	Si tarif inexistant, mise à jour de la ligne en alimentant le code mise à jour à RAPIDE et ceci pour et ceci pour spécifier que
	la ligne n 'a pas été controlée complètement	, positionnement du code erreur tarif inexistant sur la ligne et
	fin du controle.
	Si tarif existant, valorisation de la ligne de commande et mise à jour de la ligne en alimentant le
	code mise à jour à SAISIE MODE SIMPLE et ceci pour specifier que la ligne a été entierement controlée et sans
	erreur.
	
	- Controle de la qte.
	Si l'unite de la commande est L'unité conso., controler que la qté soit bien un multiple de la qté conditionnement
	     en utilisant le PCB (par combien).
	 </DESC> */

boolean lb_return       = true
boolean lb_delete_ligne = false
String  s_article
String  s_dimension	
Decimal dec_qte_saisie
Decimal dec_tarif
boolean  lb_reference_gratuite = false
Integer i_reponse
String   ls_code_maj
String  ls_erreur
String s_client_reference, s_enseigne_reference
str_pass		l_str_work
nv_datastore ds_datastore
Long ll_row_a_controler
Long ll_row_a_recontroler

ll_row_a_controler = al_row

// _________________  initialisation des données _____________________________

debut_traitement:
	// Si le code erreur de la ligne est positionne a 6, erreur Qte provenant d'un client EDI et
	// que la validation est complete, il faut que la ligne reste positionnee en anomalie pour etre
	// corrigee de facon manuelle
ll_row_a_recontroler = 0
if ab_mode_validation_complete and  &
   adw_ligne_cde.getItemString(ll_row_a_controler,DBNAME_CODE_ERREUR_LIGNE)  = CODE_QTE_EDI_INCORRECT then
          ls_code_maj =  CODE_MODE_RAPIDE
		goto Num_ligne
end if

	// Réinitialisation de l'enregistrement avant contrôle
adw_ligne_cde.SetItem (ll_row_a_controler, DBNAME_CODE_ERREUR_LIGNE, CODE_AUCUNE_ERREUR)

	// Préparation de la référence saisie
If ll_row_a_controler > 1	and 	ab_mode_saisie_dimension	then
	ab_mode_saisie_dimension	=	True
End if
s_article 		= adw_ligne_cde.GetItemString (ll_row_a_controler, DBNAME_ARTICLE)
s_dimension	 	= adw_ligne_cde.GetItemString (ll_row_a_controler, DBNAME_DIMENSION)
dec_qte_saisie	= adw_ligne_cde.GetItemDecimal(ll_row_a_controler, DBNAME_QTE)

If IsNull (s_article) Or trim(s_article) = DONNEE_VIDE  then
	s_article =	BLANK
End if	

If IsNull(s_dimension) Or trim(s_dimension) = DONNEE_VIDE  then
	s_dimension = BLANK
End if

if s_article = BLANK and ab_mode_saisie_dimension then
	s_article	=	trim(adw_ligne_cde.GetitemString(ll_row_a_controler - 1 ,DBNAME_ARTICLE))
	If s_article = DONNEE_VIDE then
		s_article = BLANK
	End if
	adw_ligne_cde.SetItem(ll_row_a_controler,DBNAME_ARTICLE,s_article)	
End if

If s_article	=	BLANK	and s_dimension	=	BLANK	then
	if ab_mode_saisie_dimension then
		adw_ligne_cde.setColumn(DBNAME_DIMENSION)
	else
		adw_ligne_cde.setColumn(DBNAME_ARTICLE)		
	end if
	lb_return = false
	goto FIN	
end if

IF dec_qte_saisie = 0 THEN
	dec_qte_saisie = 1
	adw_ligne_cde.SetItem(ll_row_a_controler,DBNAME_QTE,1)
END IF

if dec_qte_saisie < 0 then
	messagebox (g_nv_traduction.get_traduction(CONTROLE),g_nv_traduction.get_traduction(QUANTITE_COMMANDE_ERRONE),StopSign!,Ok!,1)
	lb_return = false
	goto Num_ligne
end if

// ___________________________    Les controles ___________________________________
	// SUBSTITUTION: Controle si la reference est dans le facilite de saisie
	// Remarque : La substitution de la reference n 'est effectue que si elle est autorisée
	//                       pour le visiteur de la commande
if fu_is_substitution_autorise() then
	inv_reference_object.fu_controle_facilite_saisie(s_article,s_dimension)
	adw_ligne_cde.SetItem(ll_row_a_controler,DBNAME_ARTICLE,s_article)		
	adw_ligne_cde.SetItem(ll_row_a_controler,DBNAME_DIMENSION,s_dimension)	
end if

ls_code_maj = CODE_MODE_SIMPLE

	// CONTROLE DOUBLON - uniquement en controle ligne par ligne
	//   si la reference existe deja, l'utilisateur à la possibilité
	//   de cumuler la qte sur la ligne existante et dans ce cas
	//   la ligne saisie sera supprimée, ou bien de conserver
	//   cette ligne.
	//   Les lignes issues d'une promotion ne passent pas ce controle

if not ab_mode_validation_complete and &
   adw_ligne_cde.getItemString(ll_row_a_controler,DBNAME_TYPE_SAISIE) <> CODE_SAISIE_PUBLI_PROMO then
   if fu_controle_doublons(adw_ligne_cde, s_article,s_dimension, &
									adw_ligne_cde.getItemString(ll_row_a_controler,DBNAME_TYPE_SAISIE), &
									ll_row_a_controler,ll_row_a_recontroler) = -1 then
		ls_code_maj =  CODE_SUPPRESSION
		goto Num_ligne	
	end if
end if

	// CONTROLE REFERENCE 
	//    on controle si la reference est existante sur la table des références.
	//    Si inexistante, l'utilisateur à la possiblité de :
	//		- conserver la reference, 
	//   	- supprimer la ligne de commande 
	//		- appeler le module de recherche des références
	
CTRL_REF:
if inv_reference_object.fu_controle_reference(s_article, s_dimension) then
	lb_reference_gratuite = inv_reference_object.fu_is_reference_gratuite()
	datetime ldte_dispo
    ldte_dispo =  inv_reference_object.fu_get_date_dispo(i_nv_commande.fu_get_marche())
    if mid(string(ldte_dispo),1,10) <>  "01/01/1900" then
       adw_ligne_cde.SetItem (ll_row_a_controler,"DTDISPO",ldte_dispo)
      end if
      goto CTRL_REFERENCEMENT
end if

adw_ligne_cde.SetItem (ll_row_a_controler, DBNAME_CODE_ERREUR_LIGNE, CODE_REFERENCE_INEXISTANTE)
adw_ligne_cde.SetItem (ll_row_a_controler, DBNAME_TARIF, 0)	
ls_code_maj =  CODE_MODE_RAPIDE

if ab_mode_validation_complete then
	goto Num_ligne
end if

i_reponse = messagebox (g_nv_traduction.get_traduction(REFERENCE_INEXISTANTE),&
                                        g_nv_traduction.get_traduction(RECHERCHE_REFERENCE_OUI) + " ~r~n ~r~n" + &
								g_nv_traduction.get_traduction(VALIDER_SAISIE_NON) + " ~r~n ~r~n"  + &
								g_nv_traduction.get_traduction(SUPPRIMER_SAISIE_ANNULER), &
								StopSign!,YesNoCancel!)						 

CHOOSE CASE i_reponse
	CASE 2
		// ===> On garde la saisie en erreur
		ls_code_maj =  CODE_MODE_RAPIDE
		goto Num_ligne
		
		// ===> Appel de la fenêtre d'affichage des references pour selection
	CASE 1
		if fu_affichage_dimension_tarif (s_article, dec_tarif, s_dimension) then
			adw_ligne_cde.SetItem (ll_row_a_controler, DBNAME_ARTICLE,   s_article)
			adw_ligne_cde.SetItem (ll_row_a_controler, DBNAME_DIMENSION, s_dimension)
			adw_ligne_cde.SetItem (ll_row_a_controler, DBNAME_TARIF, dec_tarif)
		  	adw_ligne_cde.SetItem (ll_row_a_controler, DBNAME_CODE_ERREUR_LIGNE, CODE_AUCUNE_ERREUR)
			goto CTRL_REF			
         else
			// ===> On garde la saisie en erreur
			lb_return = false
			goto Num_ligne
         end if
		
	CASE 3
		// ===> Suppression de la ligne
		ls_code_maj = CODE_SUPPRESSION
		adw_ligne_cde.setItem(ll_row_a_controler,DBNAME_CODE_MAJ, CODE_SUPPRESSION)
		adw_ligne_cde.SetItem (ll_row_a_controler, DBNAME_CODE_ERREUR_LIGNE, CODE_AUCUNE_ERREUR)		
		goto Num_ligne	
END CHOOSE

	// Si le client donneur est referencé dans la liste des clients pour lesquelles des references peuvent être
	// interdite, controle de l'existence de la reference dans cette liste.
	// Si cette reference existe, affichage d'un message et suppression de la ligne de commande
CTRL_REFERENCEMENT:
     if not i_nv_commande.fu_is_referencement_client( ) then
		 goto CTRL_QTE
     end if
     ds_datastore = create nv_datastore
	 ds_datastore.dataobject = "d_object_controle_ref_interdite"  
	 ds_datastore.settrans( SQLCA)
	 i_nv_commande.fu_get_critere_referencement(s_client_reference,s_enseigne_reference)
	 if ds_datastore.retrieve (s_enseigne_reference, s_client_reference, s_article, s_dimension) = 0 then
		destroy ds_datastore
		goto CTRL_QTE
	 end if
	 
	 // ===> Suppression de la ligne
	messagebox ("Référence interdite","la référence "+ s_article + " - " + s_dimension + " est interdite pour le client. La ligne sera supprimée", StopSign!,OK!)
	
	ls_code_maj = CODE_SUPPRESSION
	adw_ligne_cde.setItem(ll_row_a_controler,DBNAME_CODE_MAJ, CODE_SUPPRESSION)
	adw_ligne_cde.SetItem (ll_row_a_controler, DBNAME_CODE_ERREUR_LIGNE, CODE_AUCUNE_ERREUR)		
	destroy ds_datastore
	goto Num_ligne	
	
	//  CONTROLE QTE :
	//    - Controle de la qté saisie en fonction de l'unite de commande du client
	//		Si la commande est saisie en UNC, il faut qe la qté saisie soit un multiple du pcb défini au niveau de
	//	          de la reference.
	//
CTRL_QTE:

// controle de la qté en fonction de l'unite de commande
string ls_unite_conso
decimal  ld_qte_un
decimal ld_pcb

if  inv_reference_object.fu_check_qte_cdee( i_nv_commande.fu_get_ucc(), ls_unite_conso, ld_qte_un,dec_qte_saisie,ld_pcb) then
	adw_ligne_cde.setItem(ll_row_a_controler,DBNAME_QTE_UN,ld_qte_un)
	adw_ligne_cde.setItem(ll_row_a_controler,DBNAME_UNITE_LIGCDE,ls_unite_conso)
	goto suite_controle_qte
end if

if ab_mode_validation_complete then
	adw_ligne_cde.setItem(ll_row_a_controler,DBNAME_QTE_UN,0)
	adw_ligne_cde.setItem(ll_row_a_controler,DBNAME_UNITE_LIGCDE,ls_unite_conso)
	adw_ligne_cde.SetItem (ll_row_a_controler, DBNAME_CODE_ERREUR_LIGNE, CODE_QTE_UNC_INCORRECT)		
	ls_code_maj =  CODE_MODE_RAPIDE
	goto suite_controle_qte
//	goto Num_ligne
end if

ls_erreur = g_nv_traduction.get_traduction("CONTROLE_QTE_MINI") + "  ~r~n"
ls_erreur =  ls_erreur + g_nv_traduction.get_traduction("CONTROLE_QTE_ERREUR_1") + "   = " + String ( dec_qte_saisie) + "~r~n" 
ls_erreur = ls_erreur + g_nv_traduction.get_traduction("CONTROLE_QTE_ERREUR_5") + "   = " + String (ld_pcb) +  "~r~n" 		
messagebox (g_nv_traduction.get_traduction("CONTROLE_MINI_ET_TAILLE"),ls_erreur,StopSign!)
 adw_ligne_cde.SetItem (ll_row_a_controler, DBNAME_CODE_ERREUR_LIGNE, CODE_QTE_UNC_INCORRECT)		
 ls_code_maj =  CODE_MODE_RAPIDE		
goto Num_ligne			

suite_controle_qte:
// controle de la qte par rapport au mini de cde et à la taille des lots
l_str_work.d[1] =ld_qte_un
l_str_work.s[1] = i_nv_commande.fu_get_ucc()

l_str_work = inv_reference_object.fu_check_mini_cde_et_taille_lot(l_str_work)
if l_str_work.b[1] then
	goto CTRL_TARIF
end if

if ab_mode_validation_complete then
//	if l_str_work.s[2]= 'O' then
	if l_str_work.s[2]= 'N' then
  	    adw_ligne_cde.SetItem (ll_row_a_controler, DBNAME_CODE_ERREUR_LIGNE, l_str_work.s[1])		
	    ls_code_maj =  CODE_MODE_RAPIDE
	end if
	goto Num_ligne
end if

ls_erreur = "*** " +  g_nv_traduction.get_traduction("CLAAESSE_T") + " " 
ls_erreur = ls_erreur + g_nv_traduction.get_traduction("ARTAE000_T") + " = " +  l_str_work.s[3] + " ***" + "  ~r~n" 

if l_str_work.s[1] = CODE_QTE_INF_MINI_CDE then
	ls_erreur = ls_erreur + g_nv_traduction.get_traduction("CONTROLE_QTE_MINI") + "  ~r~n" 
	ls_erreur = ls_erreur + g_nv_traduction.get_traduction("CONTROLE_QTE_ERREUR_1") + "   = " + String ( l_str_work.d[1]) + "~r~n" 
	ls_erreur = ls_erreur + g_nv_traduction.get_traduction("CONTROLE_QTE_ERREUR_2") + "   = "  +String ( l_str_work.d[2]) + "~r~n" 	
	ls_erreur = ls_erreur + g_nv_traduction.get_traduction("CONTROLE_QTE_ERREUR_3") + "   = " + String ( l_str_work.d[4]) + "~r~n" 		
else
	ls_erreur = g_nv_traduction.get_traduction("CONTROLE_QTE_MULTIPLE") + "  ~r~n"
	ls_erreur =  ls_erreur + g_nv_traduction.get_traduction("CONTROLE_QTE_ERREUR_1") + "   = " + String ( l_str_work.d[1]) + "~r~n" 
	ls_erreur = ls_erreur + g_nv_traduction.get_traduction("CONTROLE_QTE_ERREUR_2") + "   = " + String ( l_str_work.d[2]) + "~r~n" 		
	ls_erreur =ls_erreur + g_nv_traduction.get_traduction("CONTROLE_QTE_ERREUR_4") + "   = " + String ( l_str_work.d[3]) + "~r~n" 	
	ls_erreur = ls_erreur + g_nv_traduction.get_traduction("CONTROLE_QTE_ERREUR_3") + "   = " + String ( l_str_work.d[4])+ "~r~n~r~n" 		
end if

ls_erreur =  ls_erreur + g_nv_traduction.get_traduction("CONTROLE_QTE_CONFIRMATION") + "~r~n~r~n" 		
ls_erreur =  ls_erreur + g_nv_traduction.get_traduction(SUPPRIMER_SAISIE_ANNULER)

//i_reponse = messagebox (g_nv_traduction.get_traduction("CONTROLE_MINI_ET_TAILLE"),ls_erreur,StopSign!,YesNo!,1)
i_reponse = messagebox (g_nv_traduction.get_traduction("CONTROLE_MINI_ET_TAILLE"),ls_erreur,StopSign!,YesNoCancel!,1)

CHOOSE CASE i_reponse
	CASE 1
		adw_ligne_cde.setItem(ll_row_a_controler,DBNAME_QTE, l_str_work.d[4])
		dec_qte_saisie	= adw_ligne_cde.GetItemDecimal(ll_row_a_controler, DBNAME_QTE)
          goto CTRL_QTE
	
	CASE 2
		if l_str_work.s[2]= 'O' then
	          adw_ligne_cde.SetItem (ll_row_a_controler, DBNAME_CODE_ERREUR_LIGNE, l_str_work.s[1])		
   		      ls_code_maj =  CODE_MODE_RAPIDE		
			goto Num_ligne		
		else
			dec_qte_saisie	= adw_ligne_cde.GetItemDecimal(ll_row_a_controler, DBNAME_QTE)
			goto CTRL_TARIF
		end if
	CASE 3
		// ===> Suppression de la ligne
		ls_code_maj = CODE_SUPPRESSION
		adw_ligne_cde.setItem(ll_row_a_controler,DBNAME_CODE_MAJ, CODE_SUPPRESSION)
		adw_ligne_cde.SetItem (ll_row_a_controler, DBNAME_CODE_ERREUR_LIGNE, CODE_AUCUNE_ERREUR)		
		goto Num_ligne			
END CHOOSE

// controle existence du tarif
CTRL_TARIF:
// Si la ligne de cde a été positionnée comme gratuite, ne pas
// effectuer le controle
if adw_ligne_cde.getItemString (ll_row_a_controler, DBNAME_PAYANT_GRATUIT) = CODE_GRATUIT then
	adw_ligne_cde.SetItem (ll_row_a_controler, DBNAME_TARIF, 0)
	goto Num_ligne
end if

// Si le type de commande précise que la commande ne doit pas être valoriser, pas de recherche du tarif.
if not  i_nv_commande.fu_is_commande_valorisable() then
	adw_ligne_cde.SetItem (ll_row_a_controler, DBNAME_TARIF, 0)
	goto Num_ligne
end if

// Si type de saisie catalogue et que le prix est issu du catalogue pas de controle du tari
if adw_ligne_cde.getItemString(ll_row_a_controler,DBNAME_TYPE_SAISIE) = "V" then
   goto Num_ligne
end if

adw_ligne_cde.SetItem (ll_row_a_controler, DBNAME_TARIF, 0)
if inv_reference_object.fu_get_tarif_article ( s_article, dec_tarif, &
															  i_nv_commande.fu_get_liste_prix(), &
															  i_nv_commande.fu_get_devise(),     &
															  adw_ligne_cde.GetItemString(ll_row_a_controler,DBNAME_TYPE_SAISIE), &
															  adw_ligne_cde.GetItemSTring(ll_row_a_controler,DBNAME_CODE_CATALOGUE	), &
															  adw_ligne_cde.GetItemString(ll_row_a_controler,DBNAME_DIMENSION) , false) then
	adw_ligne_cde.SetItem (ll_row_a_controler, DBNAME_TARIF, dec_tarif)
else																
	adw_ligne_cde.SetItem (ll_row_a_controler, DBNAME_CODE_ERREUR_LIGNE, CODE_TARIF_INEXISTANT)
	ls_code_maj =  CODE_MODE_RAPIDE
	goto Num_ligne
end if

if dec_tarif = 0 and not lb_reference_gratuite then
	adw_ligne_cde.SetItem (ll_row_a_controler, DBNAME_CODE_ERREUR_LIGNE, CODE_TARIF_INEXISTANT)
	ls_code_maj =  CODE_MODE_RAPIDE
	goto Num_ligne
end if

// Affectation du n° de ligne pour les nouvelles lignes
Num_ligne:

IF IsNull (adw_ligne_cde.GetItemString (ll_row_a_controler, DBNAME_NUM_LIGNE)) THEN
	adw_ligne_cde.SetItem (ll_row_a_controler, DBNAME_NUM_LIGNE, fu_get_nouveau_numero_ligne())
	if lb_reference_gratuite then
		adw_ligne_cde.SetItem (ll_row_a_controler, DBNAME_PAYANT_GRATUIT, CODE_GRATUIT)
	end if
end if

// ==============================================
// MISE A JOUR DES MONTANTS
// ==============================================
fu_calcul_montant_ligne(adw_ligne_cde, ll_row_a_controler)

// ==============================================
// M O D I F I C A T I O N
// ==============================================
// MISE A JOUR DE LA DATE 
adw_ligne_cde.SetItem (ll_row_a_controler, DBNAME_DATE_CREATION, sqlca.fnv_get_datetime ())
adw_ligne_cde.SetItem(ll_row_a_controler,DBNAME_CODE_MAJ ,ls_code_maj)	

if ll_row_a_recontroler > 0 then
	ll_row_a_controler = ll_row_a_recontroler
	goto debut_traitement
end if
FIN:
return lb_return
end function

public function integer fu_controle_doublons (ref datawindow adw_lignes_cde, string as_article, string as_dimension, string as_type_saisie, long al_row, ref long al_row_maj);/* <DESC>
         Permet de contrôler si une ligne de commande pour la référence saisie n'est pas déjà existante dans
			la commande. Ce contrôle s'effectue pour la référence et en fonction du type de saisie
			(Catalogue,promotion,normale,...)
	   SI une ligne est déjà existante, affichage d'un message pour permettre soit de cumuler la quantité
		sur la ligne existante, soit conserver la ligne en double, soit supprimer la saisie de la ligne.
		
	  Si cumul de la quantité sur la ligne existante, cumul de la quantité saisie avec la quantité de la ligne
       Un code retour est positionnée afin de spécifier si la ligne a été cumulée et donc il faudra supprimer
		 la ligne (-1), conserve la ligne (0), suppression de la ligne (-1)
   </DESC> */
Long			l_doublon
Integer		i_reponse
Decimal{2}	dec_qte

// RECHERCHE LIGNE EN DOUBLE
l_doublon =	adw_lignes_cde.Find (  &
			DBNAME_ARTICLE     + " ='" + as_article     + "'and " + &
			DBNAME_DIMENSION   + " ='" + as_dimension   + "'and " + &
			DBNAME_TYPE_SAISIE + " ='" + as_type_saisie + "'and " + &
			DBNAME_QTE         + " <> 0 ", &
			1,adw_lignes_cde.RowCount())

if l_doublon = 0 or l_doublon = al_row then
	return 0
end if

dec_qte = adw_lignes_cde.GetItemDecimal (l_doublon , DBNAME_QTE) 

i_reponse = messagebox (g_nv_traduction.get_traduction("CONTROLE_DOUBLON"),&
                                   	g_nv_traduction.get_traduction("CONTROLE_DOUBLON_REFERENCE") + " "  +  as_article + " " + as_dimension + " "  + &
												  g_nv_traduction.get_traduction("CONTROLE_DOUBLON_REFERENCE2") + " " + &
												  String(dec_qte) + "~r~n ~r~n" + &
                                        g_nv_traduction.get_traduction("CONTROLE_DOUBLON_OPTION1") + " ~r~n ~r~n" + &
								g_nv_traduction.get_traduction("CONTROLE_DOUBLON_OPTION2") + " ~r~n ~r~n"  + &
								g_nv_traduction.get_traduction("CONTROLE_DOUBLON_OPTION3"), &
								StopSign!,YesNoCancel!)						 

CHOOSE CASE i_reponse
	case 1
		dec_qte   = dec_qte + adw_lignes_cde.GetItemDecimal (al_row , DBNAME_QTE)
          adw_lignes_cde.SetItem (l_doublon, DBNAME_QTE, dec_qte)
          adw_lignes_cde.SetItem (l_doublon, DBNAME_CODE_MAJ	, CODE_MODE_RAPIDE)			 
          fu_calcul_montant_ligne(adw_lignes_cde, l_doublon)
		 al_row_maj = l_doublon
		return -1	
	case 2
		return 0
	case 3
		return -1
END CHOOSE


end function

on nv_ligne_cde_object.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nv_ligne_cde_object.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;/* <DESC>
     Suppression des objets commande et référence
	  </DESC> */
destroy i_nv_commande
destroy inv_reference_object
end event

event constructor;/* <DESC>
    Création de l'objet de controle des référence de vente
	</DESC> */
inv_reference_object = CREATE nv_reference_vente
end event

