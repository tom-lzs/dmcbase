$PBExportHeader$nv_come9par_commande.sru
$PBExportComments$Contient toutes les informations du visiteur de la commande. Utiliser pour controler si la passage devant le facilit de saisie est autorise ou non
forward
global type nv_come9par_commande from nonvisualobject
end type
end forward

global type nv_come9par_commande from nonvisualobject
end type
global nv_come9par_commande nv_come9par_commande

type variables
Datastore i_ds_come9par // Datatsore contenat les données du visteur
integer i_code_retour        // Code retour initialisé lors de l'accés aux données

decimal {0} i_dernier_num_prospect  // contient le dernier n° prospect créé
decimal {0} i_dernier_num_cde          // contient le dernier n° de commande créé
end variables

forward prototypes
public function integer get_return_code ()
public function boolean is_substitution_autorisee ()
public function integer retrievedata (string as_visiteur)
end prototypes

public function integer get_return_code ();/* <DESC>
  Retourne le code retour obtenu après l'accès à la base de données.
</DESC> */
return i_code_retour
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

public function integer retrievedata (string as_visiteur);/* <DESC>
   Effectue la recherche des données du visteur  et mémorise le code 
   retour renvoyé par la base de données.
	</DESC> */
i_code_retour = i_ds_come9par.retrieve(as_visiteur)
return 0

end function

event constructor;/* <DESC>
   Initialisation des données du visteur connecté à partir des informatiosn stockées dans
  la base de données
  </DESC> */

i_ds_come9par = CREATE DATASTORE
i_ds_come9par.DataObject = 'd_parametres_visiteur'
i_ds_come9par.SetTransObject (SQLCA)

end event

on nv_come9par_commande.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nv_come9par_commande.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

