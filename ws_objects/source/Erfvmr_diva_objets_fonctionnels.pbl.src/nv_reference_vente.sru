$PBExportHeader$nv_reference_vente.sru
$PBExportComments$Contient les données d'une référence de vente ainsi que les règles de contrôle.
forward
global type nv_reference_vente from nonvisualobject
end type
end forward

global type nv_reference_vente from nonvisualobject
end type
global nv_reference_vente nv_reference_vente

type variables
Datastore i_ds_reference
Datastore i_ds_facilite_saisie
Datastore i_ds_tarif
Datastore i_ds_tarif_catalogue
Datastore i_ds_date_ciale
end variables

forward prototypes
public subroutine fu_controle_facilite_saisie (ref string as_article, ref string as_dimension)
public function boolean fu_controle_reference (string as_article, string as_dimension)
public function boolean fu_is_reference_gratuite ()
public function any fu_check_mini_cde_et_taille_lot (any a_str_pass)
public function string fu_get_unite_conso ()
public function decimal fu_get_pcb ()
public function string fu_get_unite_vente ()
public function boolean fu_check_qte_cdee (string as_ucc, ref string as_unite_conso, ref decimal as_qte_un, decimal as_qte_saisie, ref decimal ad_pcb)
public function boolean fu_get_tarif_article (string as_article, ref decimal ad_tarif, string as_liste_prix, string as_devise, string as_type_saisie, string as_catalogue, string as_dimension, boolean ab_option_gratuit_payant)
public function datetime fu_get_date_dispo (string as_marche)
private function datetime fu_get_dtdispo_ciale (string as_marche)
private function datetime fu_get_dtdispo_indus ()
end prototypes

public subroutine fu_controle_facilite_saisie (ref string as_article, ref string as_dimension);/* <DESC>
	Recherche si la référence saisie se trouve sur le facilité de saisie
	Pour cela 2 cas possibles, 
	<LI>	- soit une facilité de saisie a été défini au niveau de la référence	saisie
	<LI>	- soit uniquement au niveau de l'article
	<LI>Accès avec la référence saisie
 		     - si existante, on récupère la référence de vente associée
		    - si inexistante dans la facilité et Dimension alimentée
		    - Accès avec uniquement l'article saisi
		  	  - si inexistante, la référence de vente sera celle saisie
		  	  - sinon:
				- si la dimension associée est alimentée,  la référence sera
					  celle associé à l'article saisie
				- sinon la référence de vente sera composé de l'article associée
					  plus de la dimension saisie
  </DESC> */
integer   li_retrieve
integer	 li_retrieve_2

li_retrieve = i_ds_facilite_saisie.retrieve(as_article, trim(as_dimension))

if li_retrieve = -1 then
 	f_dmc_error ("Nv_reference : facilite de saisie " +  BLANK + DB_ERROR_MESSAGE)
end if	 

if li_retrieve > 0 then
	as_article = i_ds_facilite_saisie.getItemString(1, DBNAME_ARTICLE)
	as_dimension = i_ds_facilite_saisie.getItemString(1, DBNAME_DIMENSION)
	return
end if

 // Reference non trouvée dans le facilite, recherche uniquement avec l'article
li_retrieve_2 = i_ds_facilite_saisie.retrieve(as_article, BLANK)
if li_retrieve_2 = -1 then
 	f_dmc_error ("Nv_reference : " +  BLANK + DB_ERROR_MESSAGE)			
end if

if li_retrieve_2 = 0 then
	return
end if

as_article = i_ds_facilite_saisie.getItemString(1, DBNAME_ARTICLE)				
// si la dimension n'est pas renseignée, on conserve celle saisie
// sinon elle sera remplacée par celle trouvée

if trim(i_ds_facilite_saisie.getItemString(1, DBNAME_DIMENSION)) <> DONNEE_VIDE then
	as_dimension = i_ds_facilite_saisie.getItemString(1, DBNAME_DIMENSION)
end if	
end subroutine

public function boolean fu_controle_reference (string as_article, string as_dimension);/* <DESC> 
	 Controle existence de la référence de vente
	</DESC>  */
integer   li_retrieve
boolean	 lb_return
String    ls_dimension

// controle de la référence de vente
ls_dimension = as_dimension
if ls_dimension = BLANK then
	ls_dimension = DONNEE_VIDE
end if

li_retrieve = i_ds_reference.retrieve(as_article, ls_dimension)

choose case li_retrieve
	case - 1
	 	f_dmc_error ("Nv_reference : reference vente " +  BLANK + DB_ERROR_MESSAGE)
	case 0
		lb_return = false
	case else
		lb_return = true		
end choose

return lb_return
end function

public function boolean fu_is_reference_gratuite ();/* <DESC>
       Détermine si la référence de vente est une référence gratuite
	  Ceci est dépendant du groupe de poste ( ZFGR)
   </DESC> */
if i_ds_reference.getItemString(1,DBNAME_GROUPE_POSTE) = GROUPE_TYPE_GRATUIT_ZFGR then
	return true
end if
	 
return false

end function

public function any fu_check_mini_cde_et_taille_lot (any a_str_pass);/* <DESC>
     Permet de controler si la quantité commandée n'est pas inférieure au minimum de commande autorisé et
	qu'elle soit bien un multiple du lot.
<LI>Ce controle n'est effectuée que si la référence est de classe 9, T ou C
<LI>En retour la fonction spécifie si une anaomalie a été rencontrée en alimentant un boolean , le message d'anomale
	associé et la qté proposée pour la correction.
   </DESC> */
Decimal d_taille_lot
Decimal d_mini_cde
Decimal d_qte_saisie
Decimal d_pcb
String      ls_ucc
String      ls_taille_lot 
String      ls_mini_cde

String  s_classe
long    ll_row
nv_Datastore   lnv_datastore

str_pass l_str_pass 
l_str_pass = a_str_pass

lnv_datastore = create nv_datastore
lnv_datastore.dataobject = "d_object_mto"
lnv_datastore.settrans( SQLCA)
lnv_datastore.retrieve()

ll_row = 0
if lnv_datastore.rowcount() > 0 then
	ll_row = lnv_datastore.find(DBNAME_CLASSE_REFERENCE +  " ='" +i_ds_reference.getItemString(1,DBNAME_CLASSE_REFERENCE) + "'",1, lnv_datastore.rowcount())
end if

if ll_row = 0 then
      l_str_pass.b[1] = true
     goto FIN
end if

ls_taille_lot =lnv_datastore.getItemString(ll_row,"FLAG_TAILLE_LOT") 
ls_mini_cde = lnv_datastore.getItemString(ll_row,"FLAG_MINI_CDE")
l_str_pass.s[2] = lnv_datastore.getItemString(ll_row,"flag_ctrl_obligatoire")
l_str_pass.s[3] = i_ds_reference.getItemString(1,DBNAME_CLASSE_REFERENCE) 

d_qte_saisie = l_str_pass.d[1]
d_pcb             = fu_get_pcb()
ls_ucc            = l_str_pass.s[1]
if ls_ucc <> CODE_UCC_UC then
	d_pcb = 1
end if

d_taille_lot = i_ds_reference.getItemDecimal(1,DBNAME_TAILLE_LOT)
d_mini_cde   = i_ds_reference.getItemDecimal(1,DBNAME_QTE_MINI_CDE)
s_classe 	 = i_ds_reference.getItemString(1,DBNAME_CLASSE_REFERENCE)

//if s_classe <> CODE_CLASSE_9 and &
//	s_classe <> CODE_CLASSE_T and &
//	s_classe <> CODE_CLASSE_C then
//		l_str_pass.b[1] = true
//		goto FIN
//end if

if ls_mini_cde = 'O' then
	if d_qte_saisie < d_mini_cde then
		l_str_pass.b[1] = false
		l_str_pass.s[1] = CODE_QTE_INF_MINI_CDE
		l_str_pass.d[1] = l_str_pass.d[1] * d_pcb
		l_str_pass.d[2] = d_mini_cde * d_pcb
	
		// Qte proposée
		l_str_pass.d[4] = d_mini_cde * d_pcb
		l_str_pass.b[1] = false
		goto FIN
	end if
end if

if d_taille_lot = 0 then
	l_str_pass.b[1] = true
	goto FIN
end if

l_str_pass.b[1] = true
if ls_taille_lot = 'O' then
	if Mod( Round(l_str_pass.d[1] - d_mini_cde, 0 ) , d_taille_lot) > 0 then
		l_str_pass.s[1] = CODE_QTE_ERREUR_TAILLE_LOT
//		l_str_pass.d[1] = l_str_pass.d[1] * d_pcb		
		l_str_pass.d[2] = d_mini_cde *d_pcb
		l_str_pass.d[3] = d_taille_lot*d_pcb	
	
		// Qte proposée
		l_str_pass.d[4] = ((Round(((l_str_pass.d[1] - d_mini_cde ) / d_taille_lot),0) * d_taille_lot)  + d_mini_cde) *d_pcb
		l_str_pass.d[1] = l_str_pass.d[1] * d_pcb	
		l_str_pass.b[1] = false
	end if
end if

FIN:

destroy lnv_datastore
return l_str_pass

end function

public function string fu_get_unite_conso ();return i_ds_reference.getItemString(1,DBNAME_UNITE_CONSO) 
end function

public function decimal fu_get_pcb ();return i_ds_reference.getItemDecimal(1,DBNAME_PCB) 
end function

public function string fu_get_unite_vente ();return i_ds_reference.getItemString(1,DBNAME_UNITE_VENTE) 
end function

public function boolean fu_check_qte_cdee (string as_ucc, ref string as_unite_conso, ref decimal as_qte_un, decimal as_qte_saisie, ref decimal ad_pcb);/* Controle de la qté saisie en fonction de l'unite de commande du client
    Si saisie commande en UN
	     initialiser la qte en un par la qte saisie
		initialiser l'unite conso par l'unite de vente de la référence
    Sinon controle que la qte saisie soit un multiple du PCB
*/

Decimal {5} ld_qte_prop

if as_ucc  <> CODE_UCC_UC then	
	as_unite_conso = fu_get_unite_vente()
	as_qte_un = as_qte_saisie
	return true
end if

as_unite_conso = fu_get_unite_conso()
if  Mod( as_qte_saisie , fu_get_pcb()) = 0 then
	as_qte_un = Round(as_qte_saisie/fu_get_pcb(),2)
	return true
end if

ad_pcb = fu_get_pcb()
return false
end function

public function boolean fu_get_tarif_article (string as_article, ref decimal ad_tarif, string as_liste_prix, string as_devise, string as_type_saisie, string as_catalogue, string as_dimension, boolean ab_option_gratuit_payant);/*<DESC> 
	 Recherche du tarif de l'article
</DESC> 
	<ARGS>	as_article: Article pour lequel la recherche du tarif sera effectue
			      ad_tarif: Contiendra le tarif trouvé
				 as_liste_prix: Liste de prix du tarif a recherche
				 as_devise: Devise du tarif a recherche
   				 as_type_saisie: Determine s'il faut rechercher le tarif standard de la reference ou celui du catalogue
				 as_catalogue: Code du catalogue si recherche tarif au niveau du catalogue
				 as_dimension: Dimension de la référence si recherche du tarif au niveau du catalogue	 
				</ARGS>
	 */
//Les articles gratuit ont toujours un tarif à 0	 
Decimal  ld_par

if (	i_ds_reference.getItemString(1,DBNAME_GROUPE_POSTE) = GROUPE_TYPE_GRATUIT_ZFGR) and & 
	not ab_option_gratuit_payant then
	ad_tarif = 0
	return true
end if

// si type de saisie  prevente (type saisie = V)  recherche du tarif du catalogue
if as_type_saisie = CODE_SAISIE_PREVENTE  then
	if i_ds_tarif_catalogue.Retrieve (as_catalogue,as_article,as_dimension) = -1 then
	     f_dmc_error ("Reference Object : Tarif catalogue"  + BLANK + DB_ERROR_MESSAGE)
	end if
	if i_ds_tarif_catalogue.rowCount() =  0 then
	      ad_tarif = 0
      	return false
	else
		ad_tarif = i_ds_tarif_catalogue.getItemDecimal(1, DBNAME_PRIX_CATALOGUE)
		if isnull(ad_tarif) or ad_tarif = 0 then
			return false
		else
 			return true
		end if
	end if
end if

// sinon recherche du tarif sur le catalogue a l'origine de la ligne
if i_ds_tarif.Retrieve (as_article,as_liste_prix, as_devise) = -1 then
	f_dmc_error ("Reference Object : Tarif"  + BLANK + DB_ERROR_MESSAGE)
end if

if i_ds_tarif.rowCount() =  0 then
	ad_tarif = 0
	return false
end if

ld_par =  i_ds_tarif.getItemDecimal(1, DBNAME_UNIPAR)
ad_tarif = i_ds_tarif.getItemDecimal(1, DBNAME_PRIX_ARTICLE)

if  ad_tarif =  0 then
	return false
end if

if ld_par = 0 or IsNull(ld_par) then
	return true
end if

ad_tarif = Round(ad_tarif / ld_par,2)
return true

end function

public function datetime fu_get_date_dispo (string as_marche);datetime ld_dtdispo_indus
datetime ld_dtdispo_ciale

ld_dtdispo_indus = fu_get_dtdispo_indus()
ld_dtdispo_ciale  = fu_get_dtdispo_ciale(as_marche)

if ld_dtdispo_indus > ld_dtdispo_ciale then
	return ld_dtdispo_indus
else
	return ld_dtdispo_ciale
end if
end function

private function datetime fu_get_dtdispo_ciale (string as_marche);
datetime ld_date
long ll_retrieve 

ld_date = datetime(date("00000000"))
ll_retrieve =  i_ds_date_ciale.retrieve (i_ds_reference.getItemString(1,"artae000"), i_ds_reference.getItemString(1,"dimaeart"),as_marche)

if ll_retrieve  < 1 then
	return ld_date
else
  return  i_ds_date_ciale.getItemDateTime(1,"dtdispo")
end if
end function

private function datetime fu_get_dtdispo_indus ();return i_ds_reference.getItemDateTime(1,"dtdispo") 
end function

on nv_reference_vente.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nv_reference_vente.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;/* <DESC>
   Création des différentes datastore nécéssaire aux différents controles
	  Référence, Facilité de saisie, Tarif, Tarif catalogue
   </DESC> */
i_ds_reference = CREATE Datastore
i_ds_reference.Dataobject = "d_object_reference_vente"
i_ds_reference.setTransObject (SQLCA)

i_ds_facilite_saisie = CREATE Datastore
i_ds_facilite_saisie.DataObject = "d_object_facilite_saisie"
i_ds_facilite_saisie.setTransObject (SQLCA)

i_ds_tarif = CREATE Datastore
i_ds_tarif.DataObject = "d_object_tarif_article"
i_ds_tarif.setTransObject (SQLCA)

i_ds_tarif_catalogue = create datastore
i_ds_tarif_catalogue.dataObject = "d_object_tarif_catalogue"
i_ds_tarif_catalogue.setTransObject (SQLCA)

i_ds_date_ciale = create datastore
i_ds_date_ciale.dataobject = "d_object_date_ciale"
i_ds_date_ciale.setTransObject (SQLCA)
end event

event destructor;/* <DESC>
      Destruction des différentes datastores
   </DESC> */
destroy i_ds_reference
destroy i_ds_facilite_saisie
destroy i_ds_tarif
destroy i_ds_tarif_catalogue
end event

