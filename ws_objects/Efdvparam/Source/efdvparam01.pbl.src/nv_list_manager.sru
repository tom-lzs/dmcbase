$PBExportHeader$nv_list_manager.sru
$PBExportComments$Permet de faire appel à une liste de valeur correspondante au champ de la base de donnees passe en parametre
forward
global type nv_list_manager from nonvisualobject
end type
end forward

global type nv_list_manager from nonvisualobject
end type
global nv_list_manager nv_list_manager

type variables

end variables

forward prototypes
public function any get_list_of_column (any as_str_pass)
end prototypes

public function any get_list_of_column (any as_str_pass);/* <DESC>
   Permet d'afficher la liste de valeur en fonction de paramètre passé en arguments.
   Les arguments passés à la fonction sont stockés dans la structure standard STR_PASS,   dans le tableau des chaines 
  de caractères :    S[1] contient le nom du champ de la base pour lequel on souhaite faire afficher la liste des valeurs.
  
 On fait appel à la fenêtre d'affichage de la liste correspondant au nom du champ en passant une nouvelle structure 
 qui contiendra le nom du champ, le nom du champ contenant l'intitulé et en retour la fenêtre completera cette même structure
 par la valeur du code et de son intitulé sélectionné.
  </DESC> */

Str_pass		l_str_work
boolean     lb_retrieve_str
l_str_work = as_str_pass
l_str_work.s_action = DONNEE_VIDE
lb_retrieve_str = true
			
CHOOSE CASE l_str_work.s[1]
	// LISTE DES CODES PAYS
		CASE DBNAME_PAYS
			OpenWithParm (w_liste_pays, l_str_work)
  	// LISTE DES CODES LANGUE
		CASE DBNAME_LANGUE
			OpenWithParm (w_liste_langue, l_str_work)	
	// LISTE DES CODES MARCHE
		CASE DBNAME_CODE_MARCHE
			OpenWithParm (w_liste_marche, l_str_work)				
	// LISTE DES CODES DEVISE
		CASE DBNAME_CODE_DEVISE
			OpenWithParm (w_liste_devise, l_str_work)	
	// LISTE DES TYPES DE CDE
		CASE DBNAME_TYPE_CDE
			OpenWithParm (w_liste_type_cde, l_str_work)						
	// LISTE DES RAISONS DE CDE
		CASE DBNAME_RAISON_CDE
			l_str_work.s[4] 	= l_str_work.s[3]			
			OpenWithParm (w_liste_raison_cde, l_str_work)
	// LISTE DES ORIGINES DE CDE
		CASE DBNAME_ORIGINE_CDE
			OpenWithParm (w_liste_origine_cde, l_str_work)	
	// LISTE DES BLOCAGES DE CDE
		CASE DBNAME_BLOCAGE_CDE
			OpenWithParm (w_liste_code_blocage, l_str_work)							
		CASE ELSE
			l_str_work.s[1] = DONNEE_VIDE
			l_str_work.s[2] = DONNEE_VIDE
			l_str_work.s[3] = DONNEE_VIDE			
			l_str_work.s_action = ACTION_CANCEL
			lb_retrieve_str = false			
END CHOOSE

if lb_retrieve_str then
	l_str_work = Message.fnv_get_str_pass()		
end if
return l_str_work
end function

on nv_list_manager.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nv_list_manager.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

