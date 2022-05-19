$PBExportHeader$nv_come9par.sru
$PBExportComments$Contient toutes les informations du visiteur connecté .Il est créé à la connexion du visiteur et est utilisé à chaque fois qu'une donnée du visiteur est necessaire.
forward
global type nv_come9par from nonvisualobject
end type
end forward

global type nv_come9par from nonvisualobject
end type
global nv_come9par nv_come9par

type variables
Nv_Datastore i_ds_come9par // Datatsore contenat les données du visteur
integer i_code_retour        // Code retour initialisé lors de l'accés aux données

decimal {0} i_dernier_num_prospect  // contient le dernier n° prospect créé
decimal {0} i_dernier_num_cde          // contient le dernier n° de commande créé
end variables

forward prototypes
public function string get_numero_cde ()
public function string get_numero_prospect ()
public function string get_nom_visiteur ()
public function string get_type_cde ()
public function string get_origine_cde ()
public function string get_devise ()
public function string get_liste_prix ()
public function string get_password ()
public function integer get_return_code ()
public function string get_code_marche ()
public function string get_code_pays ()
public function boolean is_vendeur ()
public function boolean is_relation_clientele ()
private function boolean update_dernier_cde ()
public function string get_code_langue ()
public function string get_code_adresse ()
public function boolean is_francais ()
public function boolean is_filiale ()
public function boolean is_substitution_autorisee ()
public function integer retrievedata ()
public function string get_type_visiteur ()
public function string get_version ()
public function boolean update_version ()
public subroutine update_param ()
public function boolean is_maj_complete ()
public function boolean is_manager ()
public function string get_visiteurs_lies ()
public function boolean is_vendeur_multi_carte ()
end prototypes

public function string get_numero_cde ();/* <DESC>
  Attribution d'une numéro de commande à partir de compteur associé au visiteur.
  Avant d'affecter un nouveau numéro, les données du visiteur sont rafraichies pour être certain
  d'avoir le dernier N° de cde et après incrementaiton la base est remise à jour.
</DESC> */
String s_numcde
retrievedata()

i_dernier_num_cde = i_ds_come9par.GetItemDecimal(1, DBNAME_COMPTEUR_COMMANDE)
if (i_dernier_num_cde = 9999 ) then
	i_dernier_num_cde = 0
end if

i_dernier_num_cde = i_dernier_num_cde + 1
s_numcde = String (i_dernier_num_cde)

do until len (s_numcde) = 4
	s_numcde = "0" + s_numcde
loop

s_numcde = mid (g_s_visiteur,2,2)  +  s_numcde
update_dernier_cde()
return s_numcde

end function

public function string get_numero_prospect ();/* <DESC>
  Attribution d'une numéro de client à partir de compteur associé au visiteu.
  Avant d'affecter un nouveau numéro de client prospect, on rafraichi les infos du visiteur pour être certain d'avoir le dernier N° .
  de prospect et après incrementation l'on met à jour la base de données.
  Le n° du client sera composé du prefix 'P' +  Code visiteur et de compteur.
</DESC> */
String   s_prospect
retrievedata()
i_dernier_num_prospect = i_ds_come9par.GetItemDecimal(1, DBNAME_COMPTEUR_PROSPECT)

if (i_dernier_num_prospect = 999 ) then
	i_dernier_num_prospect = 0
end if

i_dernier_num_prospect = i_dernier_num_prospect + 1 
s_prospect = String (i_dernier_num_prospect)


do until len (s_prospect) = 2
	s_prospect = "0" + s_prospect
loop

s_prospect = CODE_PREFIX_PROSPECT + g_s_visiteur +  s_prospect
i_ds_come9par.SetItem(1, DBNAME_COMPTEUR_PROSPECT,i_dernier_num_prospect)
i_ds_come9par.SetItem(1, DBNAME_DATE_MAJ_PROSPECT,sqlca.fnv_get_datetime ())
i_ds_come9par.update()
return s_prospect
end function

public function string get_nom_visiteur ();/* <DESC>
   Retourne le nom du visiteur
</DESC> */
return i_ds_come9par.GetItemString(1, DBNAME_NOM_VISITEUR) 
end function

public function string get_type_cde ();/* <DESC>
  Retourne le type de cde associé au visiteur pour initialisé l'entête de commande lors de la création d'une nouvelle commande
</DESC> */
return i_ds_come9par.GetItemString(1, DBNAME_TYPE_CDE) 
end function

public function string get_origine_cde ();/* <DESC>
  Retourne l'origine de cde associé au visiteur pour initialisé l'entête de commande lors de la création d'une nouvelle commande
</DESC> */
return i_ds_come9par.GetItemString(1, DBNAME_ORIGINE_CDE) 
end function

public function string get_devise ();/* <DESC>
   Recherche le code devise associé au visiteur pour la recherche des tarifs
   en mode hors saisie commande (en passant par l'option du menu) et pour initialisée
   la devise lors de la création d'un nouveau client.
</DESC> */
return i_ds_come9par.GetItemString(1, DBNAME_CODE_DEVISE) 
end function

public function string get_liste_prix ();/* <DESC>
   Recherche la liste de prix  associé au visiteu pour la recherche des tarifs
   en mode hors saisie commande (en passant par l'option du menu) et pour initialisée
   la liste de prix lors de la création d'un nouveau client.
</DESC> */
return i_ds_come9par.GetItemString(1, DBNAME_LISTE_PRIX)
end function

public function string get_password ();/* <DESC>
  Retourne le mote de passe pour controler la saisie lors de la connection
</DESC> */
return i_ds_come9par.getItemString(1,DBNAME_MOT_PASSE)
end function

public function integer get_return_code ();/* <DESC>
  Retourne le code retour obtenu après l'accès à la base de données.
</DESC> */
return i_code_retour
end function

public function string get_code_marche ();/* <DESC>
   Recherche le code marché associé au visiteur. Il est utilisé lors de la recherche des références et des tarifs associés
   mais uniquement si l'option est appelée en dehors de la saisie d'une commande
</DESC> */
return i_ds_come9par.GetItemString(1, DBNAME_CODE_MARCHE) 
end function

public function string get_code_pays ();/* <DESC>
   Recherche le code pays associé au visiteur pour initialiser le code pays lors de la création d'un client prospect
</DESC> */
return i_ds_come9par.GetItemString(1, DBNAME_PAYS) 
end function

public function boolean is_vendeur ();/* <DESC>
  Permet de controler si le visiteur est un vendeur.
  Si tel est le cas, la fonction retourne la valeur vrai sinon faux.
</DESC> */
String ls_type_visiteur

ls_type_visiteur = get_type_visiteur()

if ls_type_visiteur = CODE_VENDEUR or ls_type_visiteur = CODE_VENDEUR_MULTI_CARTE then
	return true
else
	return false
end if
end function

public function boolean is_relation_clientele ();/* <DESC>
   Permet de controler si le visiteur est une assistante clientéle.
  Si tel est le cas, la fonction retourne la valeur vrai sinon faux.
</DESC> */
if get_type_visiteur() = CODE_RELATION_CLIENTELE then
	return true
else
	return false
end if
end function

private function boolean update_dernier_cde ();/* <DESC>
   Effectue la mise à jour des données du visiteur dans la base de données dans le cas
  ou des mises à jour sont nécessaire. (creation d'une nouvelle commande, d'un client prospect)
  </DESC> */
i_ds_come9par.SetItem(1, DBNAME_COMPTEUR_COMMANDE,i_dernier_num_cde)
i_ds_come9par.SetItem(1, DBNAME_DATE_MAJ_NCDTER,sqlca.fnv_get_datetime ())
i_ds_come9par.update()
return true
end function

public function string get_code_langue ();/* <DESC>
  Retourne le code langue associé au visiteur pour permettre la traduction des intitules
  de l'application
</DESC> */
return i_ds_come9par.GetItemString(1, DBNAME_CODE_LANGUE) 
end function

public function string get_code_adresse ();/* <DESC>
  Retourne le code langue associé au visiteur pour permettre la traduction des intitules
  de l'application
</DESC> */
return i_ds_come9par.GetItemString(1, DBNAME_CODE_ADRESSE) 
end function

public function boolean is_francais ();if get_code_langue() = "F" then
	return true
else 
	return false
end if
end function

public function boolean is_filiale ();/* <DESC>
  Permet de controler si le visiteur est une filiale.
  Si tel est le cas, la fonction retourne la valeur vrai sinon faux.
</DESC> */
if get_type_visiteur() = CODE_FILIALE then
	return true
else
	return false
end if
end function

public function boolean is_substitution_autorisee ();/* <DESC>
   Permet de controler si pour le visiteur de la commande , la substitution des references
	est autorisée
</DESC> */
if  i_ds_come9par.GetItemString(1, DBNAME_FLAG_SUBSTITUT) = "O" then
	return true
else
	return false
end if

end function

public function integer retrievedata ();/* <DESC>
   Effectue la recherche des données du visteur  et mémorise le code 
   retour renvoyé par la base de données.
	</DESC> */
i_code_retour = i_ds_come9par.retrieve(g_s_visiteur)
return 0

end function

public function string get_type_visiteur ();/* <DESC>
  Retourne le type du visiteur - Vendeur, Assistante ciale.
</DESC> */
return i_ds_come9par.GetItemString(1, DBNAME_TYPE_VISITEUR) 
end function

public function string get_version ();/* <DESC>
  Retourne le n° de version
</DESC> */
String ls_version 

ls_version = i_ds_come9par.GetItemString(1, DBNAME_VERSION)
if isnull(ls_version) then 
	ls_version = "???"
end if

return ls_version
end function

public function boolean update_version ();/* <DESC>
   Effectue la mise à jour du n° de version de l'application 
  </DESC> */
i_ds_come9par.SetItem(1, DBNAME_VERSION,g_s_version)
i_ds_come9par.update()
return true
end function

public subroutine update_param ();// permet de mettre à jour les données qui ont un impact sur la mise à jour
// des tables de la base locale.
// ces infos sont 
//            Le type de visiteur
//            Code langue
//            Le flag qui permet de forcer la maj complete des tables

nv_datastore lnv_param_temp
long ll_return_code 
lnv_param_temp = create nv_datastore
lnv_param_temp.dataobject = "d_parametres_visiteur_temp"
lnv_param_temp.SetTransObject (SQLCA)

ll_return_code = lnv_param_temp.retrieve()

i_ds_come9par.setItem(1,DBNAME_TYPE_VISITEUR, lnv_param_temp.getitemString(1,DBNAME_TYPE_VISITEUR))
i_ds_come9par.setItem(1,DBNAME_CODE_LANGUE, lnv_param_temp.getitemString(1,DBNAME_CODE_LANGUE))
i_ds_come9par.setItem(1,DBNAME_FORCE_MAJ, lnv_param_temp.getitemString(1,DBNAME_FORCE_MAJ))
i_ds_come9par.SetItem(1, DBNAME_DATE_CREATION,sqlca.fnv_get_datetime ())
if i_ds_come9par.update() = -1 then
	messageBox("update data", i_ds_come9par.uf_getdberror( )  , Stopsign!, ok!)
end if

destroy lnv_param_temp
end subroutine

public function boolean is_maj_complete ();
if i_ds_come9par.getItemString(1,DBNAME_FORCE_MAJ) = "O" then
	return true
else 
	return false
end if
end function

public function boolean is_manager ();/* <DESC>
  Permet de controler si le visiteur est un manager.
  Si tel est le cas, la fonction retourne la valeur vrai sinon faux.
</DESC> */
if get_type_visiteur() = CODE_MANAGER then
	return true
else
	return false
end if
end function

public function string get_visiteurs_lies ();// Retourne la liste des visiteurs qui sont rattachés à un visiteur de profil manager
nv_datastore lnv_datastore
long ll_row
String ls_liste

lnv_datastore = create nv_datastore
lnv_datastore.dataobject = "d_lien_manager_visiteur"
lnv_datastore.SetTransObject (SQLCA)
lnv_datastore.retrieve (g_s_visiteur)

ls_liste = "'" + g_s_visiteur + "'"
for ll_row = 1 to lnv_datastore.rowcount()
	ls_liste = ls_liste + ",'" + lnv_datastore.getItemString(ll_row,DBNAME_CODE_VISITEUR) + "'"
next

return ls_liste
end function

public function boolean is_vendeur_multi_carte ();/* <DESC>
  Permet de controler si le visiteur est un vendeur.
  Si tel est le cas, la fonction retourne la valeur vrai sinon faux.
</DESC> */
String ls_type_visiteur

ls_type_visiteur = get_type_visiteur()

if ls_type_visiteur = CODE_VENDEUR_MULTI_CARTE then
	return true
else
	return false
end if
end function

event constructor;/* <DESC>
   Initialisation des données du visteur connecté à partir des informatiosn stockées dans
  la base de données
  </DESC> */

i_ds_come9par = CREATE Nv_Datastore
i_ds_come9par.DataObject = 'd_parametres_visiteur'
i_ds_come9par.SetTransObject (SQLCA)

/************************************************************
   retrieve the data of the parameter table (table come9par)
 **********************************************************/

retrieveData() 
end event

on nv_come9par.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nv_come9par.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

