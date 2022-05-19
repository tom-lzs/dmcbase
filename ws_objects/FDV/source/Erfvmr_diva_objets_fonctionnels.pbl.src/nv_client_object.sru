$PBExportHeader$nv_client_object.sru
$PBExportComments$Contient toutes les données du client sélectionné et toutes les fonctions permettant d'accéder aux données du client.Il est créé lors de la sélection d'un client.
forward
global type nv_client_object from nonvisualobject
end type
end forward

global type nv_client_object from nonvisualobject
end type
global nv_client_object nv_client_object

type variables
Datastore i_ds_client
Datastore i_ds_client_payeur
Datastore i_ds_client_facture

boolean ib_referencement_client
String    is_enseigne_referencement, is_client_referencement

Constant String DBNAME_CLIENT_GENERIQUE                        = "TIERSREF"
Constant String DBNAME_CLIENT_GFONCTION                       = "gfcaeclf"

end variables

forward prototypes
public function string fu_get_abrege_nom ()
public function string fu_get_abrege_ville ()
public function string fu_get_code_pays ()
public function string fu_get_region ()
public function string fu_get_code_echeance ()
public function string fu_get_code_manquant ()
public function string fu_get_mode_paiement ()
public function string fu_get_code_devise ()
public function string fu_get_liste_prix ()
public function string fu_get_regroupement_ordre ()
public function string fu_get_mode_expedition ()
public function string fu_get_code_client ()
public function string fu_get_correspondanciere ()
public function string fu_get_code_client_payeur ()
public function boolean fu_retrieve_client (string as_code_client)
public function boolean is_client_prospect ()
public function string fu_get_prefix_client ()
public function string fu_get_incoterm1 ()
public function string fu_get_incoterm2 ()
public function string fu_get_paiement_expedition ()
public function string fu_get_client_facture ()
public function string fu_get_code_langue ()
public function string fu_get_code_langue_payeur ()
public function string fu_get_code_langue_facture ()
public function boolean is_donneur_ordre ()
public function string fu_get_ucc ()
public function string fu_get_nom_complet ()
public function string fu_get_alerte ()
public function boolean is_cde_a_bloquer (ref string as_code_blocage)
public function string fu_get_code_enseigne ()
public function boolean is_referencement_client ()
public subroutine fu_get_critere_ref_client (ref string as_enseigne, ref string as_client)
public function string fu_get_code_marche ()
public function string fu_get_codepostal ()
public function string fu_get_client_generique ()
public function string fu_get_grande_fonction ()
end prototypes

public function string fu_get_abrege_nom ();/* <DESC>
   Retourne le nom abrégé du client
</DESC> */
return i_ds_client.getItemString (1, DBNAME_CLIENT_ABREGE_NOM)
end function

public function string fu_get_abrege_ville ();/* <DESC>
   Retourne le nom abrégé de la ville
</DESC> */
return i_ds_client.getItemString (1, DBNAME_CLIENT_ABREGE_VILLE)
end function

public function string fu_get_code_pays ();/* <DESC>
   Retourne le code pays associé au client
</DESC> */
return i_ds_client.getItemString (1, DBNAME_PAYS)
end function

public function string fu_get_region ();/* <DESC>
   Retourne le code région associé au client
</DESC> */
return i_ds_client.getItemString (1, DBNAME_CLIENT_REGION)
end function

public function string fu_get_code_echeance ();/* <DESC>
   Retourne le code écheance du client
</DESC> */
return i_ds_client.getItemString (1, DBNAME_CODE_ECHEANCE)
end function

public function string fu_get_code_manquant ();/* <DESC>
   Retourne le code manquant associé au client
</DESC> */
return i_ds_client.getItemString (1, DBNAME_CODE_MANQUANT)

end function

public function string fu_get_mode_paiement ();/* <DESC>
   Retourne le mode de paiement associé au client
</DESC> */
if isnull(i_ds_client.getItemString (1, DBNAME_MODE_PAIEMENT)) or len(trim(i_ds_client.getItemString (1, DBNAME_MODE_PAIEMENT))) = 0 then
	return '?'
else
	return i_ds_client.getItemString (1, DBNAME_MODE_PAIEMENT)
end if

end function

public function string fu_get_code_devise ();/* <DESC>
   Retourne le code devise du client
</DESC> */
return i_ds_client.getItemString (1, DBNAME_CODE_DEVISE)
end function

public function string fu_get_liste_prix ();/* <DESC>
   Retourne le code de la liste de prix associé au client
</DESC> */
return i_ds_client.getItemString (1, DBNAME_LISTE_PRIX)
end function

public function string fu_get_regroupement_ordre ();/* <DESC>
   Retourne le code regroupement des commandes associé au client
</DESC> */
return i_ds_client.getItemString (1, DBNAME_REGROUPEMENT_ORDRE)
end function

public function string fu_get_mode_expedition ();/* <DESC>
   Retourne le mode d'expedition associé au client
</DESC> */
return i_ds_client.getItemString (1, DBNAME_CODE_MODE_EXP)
end function

public function string fu_get_code_client ();/* <DESC>
   Retourne le code du client
</DESC> */
return i_ds_client.getItemString (1, DBNAME_CLIENT_CODE)
end function

public function string fu_get_correspondanciere ();/* <DESC>
   Retourne le code correspondancière associé au client
</DESC> */
return i_ds_client.getItemString (1, DBNAME_CODE_CORREPONDANTE)
end function

public function string fu_get_code_client_payeur ();/* <DESC>
   Retourne le code du client payeur associé au client
</DESC> */
return i_ds_client.getItemString (1, DBNAME_CLIENT_PAYEUR_CODE)
end function

public function boolean fu_retrieve_client (string as_code_client);/* <DESC>
   Extrait les données du client donneur d'ordre  ,du client payeur et  client facturé.
</DESC> */
String ls_sql
integer li_retrieve

if i_ds_client.retrieve(as_code_client) = -1 then
 	f_dmc_error ("Creation Object Client"  + BLANK +  DB_ERROR_MESSAGE)
end if

if i_ds_client.RowCount() = 0 then
	return false
end if

// recherche des infos du client payeur
// Si la fiche du client payeur est inxistante, elle sera initialisée par le client donneur d'ordre
if i_ds_client_payeur.retrieve(i_ds_client.getItemString(1,DBNAME_CLIENT_PAYEUR_CODE)) = -1 then
 	f_dmc_error ("Creation Object Client payeur" +  BLANK + DB_ERROR_MESSAGE)
end if

if i_ds_client_payeur.rowcount() = 0 then
	i_ds_client_payeur.retrieve(as_code_client)
end if

// recherche des infos du client facture
// Si la fiche du client facture est inxistante, elle sera initialisée par le client donneur d'ordre
if i_ds_client_facture.retrieve(i_ds_client.getItemString(1,DBNAME_CLIENT_FACTURE_CODE)) = -1 then
 	f_dmc_error ("Creation Object Client facture" +  BLANK +  DB_ERROR_MESSAGE)
end if

if i_ds_client_facture.rowcount() = 0 then
	i_ds_client_facture.retrieve(as_code_client)
end if

// recherche si referencement client
nv_datastore lnv_data
lnv_data = create nv_datastore
ib_referencement_client = false
lnv_data.dataobject = "d_object_controle_ref_client"
lnv_data.SetTransObject (sqlca)
if lnv_data.retrieve(fu_get_code_enseigne(),as_code_client )  > 0 then
	ib_referencement_client = true
	is_enseigne_referencement = lnv_data.GetItemString(1,1)
	is_client_referencement = lnv_data.GetItemString(1,2)
end if

return true
end function

public function boolean is_client_prospect ();/* <DESC>
   Permet de définir si le client est un client prospect
	code prospect = P
</DESC> */
if i_ds_client.getItemString(1,DBNAME_CODE_PROSPECT) =  CODE_PROSPECT then
	return true
else
	return false
end if

end function

public function string fu_get_prefix_client ();/* <DESC>
   Retourne le premier caractère du client prospect sinon blanc
</DESC> */
if mid (fu_get_code_client(),1,1) = CODE_PREFIX_PROSPECT then
	return CODE_PREFIX_PROSPECT
else
	return BLANK
end if

end function

public function string fu_get_incoterm1 ();/* <DESC>
   Retourne le code incoterm associé au client
</DESC> */
return i_ds_client.getItemString (1, DBNAME_CODE_INCOTERM)
end function

public function string fu_get_incoterm2 ();/* <DESC>
   Retourne la deuxieme partie du code incoterm associé au client
</DESC> */
return i_ds_client.getItemString (1, DBNAME_CODE_INCOTERM_2)
end function

public function string fu_get_paiement_expedition ();/* <DESC>
   Retourne le code paiement expédition associé au client
</DESC> */
return i_ds_client.getItemString (1, DBNAME_PAIEMENT_EXPEDITON)
end function

public function string fu_get_client_facture ();/* <DESC>
   Retourne le code du client facturé associé au client
</DESC> */
return i_ds_client.getItemString (1, DBNAME_CLIENT_FACTURE_CODE)
end function

public function string fu_get_code_langue ();/* <DESC>
   Retourne le code langue du client
</DESC> */
return i_ds_client.getItemString (1, DBNAME_CODE_LANGUE)
end function

public function string fu_get_code_langue_payeur ();/* <DESC>
   Retourne le code langue du client payeur 
</DESC> */
return  i_ds_client_payeur.getItemString (1, DBNAME_CODE_LANGUE)

end function

public function string fu_get_code_langue_facture ();/* <DESC>
   Retourne le code langue du client facturé
</DESC> */
return i_ds_client_facture.getItemString (1, DBNAME_CODE_LANGUE)
end function

public function boolean is_donneur_ordre ();/* <DESC>
   Permet de définir si le client est un client donneur d'ordre
	nature du client = N101
</DESC> */
IF i_ds_client.GetItemString (1, DBNAME_NATURE_CLIENT) <> CLIENT_DONNEUR_ORDRE  then
  	return false
else
	return true
end if

end function

public function string fu_get_ucc ();/* <DESC>
   Retourne le code unite de commande client
</DESC> */
return i_ds_client.getItemString (1, DBNAME_UCC)


end function

public function string fu_get_nom_complet ();/* <DESC>
   Retourne le nom complet du client
</DESC> */
return i_ds_client.getItemString (1, DBNAME_CLIENT_NOM_COMPLET1)
end function

public function string fu_get_alerte ();nv_datastore  lnv_ds
lnv_ds = create nv_datastore

lnv_ds.dataobject = "d_object_alerte"
lnv_ds.setTrans  (SQLCA)

lnv_ds.retrieve(fu_get_code_client())

if lnv_ds.rowCount() = 0 then
	return ""
else
	return lnv_ds.getItemString(1,"alerte")
end if
end function

public function boolean is_cde_a_bloquer (ref string as_code_blocage);as_code_blocage =  i_ds_client.GetItemString(1,DBNAME_CODE_BLOCAGE_SAP) 

if isnull(as_code_blocage ) or trim(as_code_blocage) = "" then
	return false
end if

return true
end function

public function string fu_get_code_enseigne ();string ls_enseigne

ls_enseigne = i_ds_client.getItemString (1, DBNAME_ENSEIGNE)

if isnull(ls_enseigne) or len(trim(ls_enseigne)) = 0 then
	ls_enseigne = " "
end if

return ls_enseigne
end function

public function boolean is_referencement_client ();return ib_referencement_client
end function

public subroutine fu_get_critere_ref_client (ref string as_enseigne, ref string as_client);as_enseigne = is_enseigne_referencement
as_client = is_client_referencement
end subroutine

public function string fu_get_code_marche ();/* <DESC>
   Retourne le code marché associé au client
</DESC> */
return i_ds_client.getItemString (1, DBNAME_CODE_MARCHE)
end function

public function string fu_get_codepostal ();/* <DESC>
   Retourne le code postal
</DESC> */
return i_ds_client.getItemString (1, "codaepos")
end function

public function string fu_get_client_generique ();return i_ds_client.getItemString (1, DBNAME_CLIENT_GENERIQUE)

end function

public function string fu_get_grande_fonction ();return i_ds_client.getItemString (1, DBNAME_CLIENT_GFONCTION)
end function

on nv_client_object.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nv_client_object.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;/* <DESC>
   Initialisation des 3 datastores devant stocker les informations des clients  donneur d'ordre,  payeur et facturé
</DESC> */
i_ds_client = CREATE Datastore
i_ds_client.Dataobject = "d_object_client"
i_ds_client.SetTransObject (sqlca)

i_ds_client_payeur  = CREATE Datastore
i_ds_client_payeur.Dataobject = "d_object_client"
i_ds_client_payeur.SetTransObject (sqlca)

i_ds_client_facture  = CREATE Datastore
i_ds_client_facture.Dataobject = "d_object_client"
i_ds_client_facture.SetTransObject (sqlca)


end event

