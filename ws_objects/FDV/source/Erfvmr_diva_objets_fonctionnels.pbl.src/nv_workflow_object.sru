$PBExportHeader$nv_workflow_object.sru
$PBExportComments$Object contenant les iformations de navigation entre 2 fenêtres et créé par le nv_workflow_manager
forward
global type nv_workflow_object from nonvisualobject
end type
end forward

global type nv_workflow_object from nonvisualobject
end type
global nv_workflow_object nv_workflow_object

type variables
String is_fenetre_active
String is_fenetre_destination
String is_action
String is_message

integer ii_nbr_fenetre
boolean ib_avec_parametre
end variables

forward prototypes
public function integer fu_get_nbr_fenetre_autorisee ()
public function string fu_get_action ()
public function boolean is_this_workflow (string as_fenetre_active, string as_fenetre_destination)
public function boolean fu_avec_parametre ()
public function integer fu_create_workflow (string as_fenetre_active, string as_fenetre_destination, string as_action, integer as_nbr_fenetre, boolean as_avec_parametre, string as_message)
public function string fu_get_message ()
end prototypes

public function integer fu_get_nbr_fenetre_autorisee ();/* <DESC> 
    permet de retourner le nombre d'instance pouvant être ouverte
   </DESC> */
return ii_nbr_fenetre
end function

public function string fu_get_action ();/* <DESC>
    Permet de retourner l'action a effectue sur la fenetre d'orignie (fermer, laisser ouvert..)
  </DESC> */
return is_action
end function

public function boolean is_this_workflow (string as_fenetre_active, string as_fenetre_destination);/* <DESC> 
    Permet de controler s'il s'agit bien du workflow a traite
   </DESC> */
if as_fenetre_active 		= is_fenetre_active and &
   as_fenetre_destination  = is_fenetre_destination then
	return true
end if

return false
end function

public function boolean fu_avec_parametre ();/* <DESC> 
    Permet de savoir si le workflow enttre les 2 fenetres doit s'effectuer avec le passage
	 de la structure de la fenetre d'origine
   </DESC> */
return ib_avec_parametre
end function

public function integer fu_create_workflow (string as_fenetre_active, string as_fenetre_destination, string as_action, integer as_nbr_fenetre, boolean as_avec_parametre, string as_message);/* <DESC>
     Permet de creer l'objet à partir des éléments données en paramètre
	  </DESC> */
is_fenetre_active = as_fenetre_active
is_fenetre_destination = as_fenetre_destination
is_action = as_action
ii_nbr_fenetre = as_nbr_fenetre
ib_avec_parametre = as_avec_parametre
is_message = as_message
return 0
end function

public function string fu_get_message ();/* <DESC>
      Permet de retrouner le message a afficher dans le cas ou l'enchainement ne 	ce faire
	</DESC> */
return g_nv_traduction.get_traduction( is_message)
end function

on nv_workflow_object.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nv_workflow_object.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

