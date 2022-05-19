$PBExportHeader$nv_control_manager.sru
$PBExportComments$Effectue le controle d'existence du code saisi et ceci par rapport à la table correspondante
forward
global type nv_control_manager from nonvisualobject
end type
end forward

global type nv_control_manager from nonvisualobject
end type
global nv_control_manager nv_control_manager

type variables
str_pass i_str_pass
datastore	i_ds_donnee
		// s[1] = code a valider
		// s[2] = contiendra l'intitule
		// s[3] = nom colonne contenant le code
		// s[4] = nom colonne contenant l'intitule	
		// s[5] = nom datawindow
		// s[6] = nom contenant de l'info supplementaire à envoyer	
		
   	// à partir de s[10], on peut passer des arguments
		
		// s[20] = type de controle client livre a effectuer
		// d[1] = nombre d'arguments
		// b[1] = validation Ok ou NOK
		// b[2] = Info suplementaire à envoyer
		
		
end variables

forward prototypes
private function any get_data ()
private function any get_data_with_argument ()
public function any is_devise_valide (any as_str_pass)
public function any is_marche_valide (any as_str_pass)
public function any is_origine_cde_valide (any as_str_pass)
public function any is_pays_valide (any as_str_pass)
public function any is_type_cde_valide (any as_str_pass)
public function any is_raison_cde_valide (any as_str_pass)
public function any is_langue_valide (any as_str_pass)
private function any get_data_param ()
end prototypes

private function any get_data ();/* <DESC>
    Fonction générique de validation de la saisie d'un code à partir d'une datawindow sans argument particulier.
	 
    Principe:
	 
	 Modification de la datawindow correspondante au code à contrôler et passé en paramètre, en rajoutant ou en complétant 
	 la clause where sur le code à contrôler. Ces informations sont passées via la structure d'instance Str_pass
	 
	 Retrieve de la datawindow
	  Si aucune donnée extraite (code inexistant), on initialise la première variable booléenne à Faux
	  Sinon on initialise la première variable booléenne à Vrai,on retourne le code faisant l'objet du controle
	  avec son intitulé si demander.
   </DESC> */
String s_sql
string mod_string
String s_retour

i_ds_donnee.DataObject = i_str_pass.s[5] 
i_ds_donnee.SetTransObject (SQLCA) 
s_sql = i_ds_donnee.getSqlSelect()

if pos(s_sql,"WHERE") = 0 then
	s_sql = s_sql + " WHERE " 
else
	s_sql = s_sql + " AND " 
end if

s_sql = s_sql + i_str_pass.s[3] + " = '" + i_str_pass.s[1] + "'"	
i_ds_donnee.SetSqlSelect(s_sql)

if i_ds_donnee.retrieve() = -1 THEN
		f_dmc_error ("Control Manager" + BLANK + DB_ERROR_MESSAGE)			
end if

if i_ds_donnee.RowCount() = 0 then
	i_str_pass.b[1] =  false
else
	i_str_pass.b[1] =  true
	i_str_pass.s[2] = i_ds_donnee.getItemString(1, i_str_pass.s[4])
	if i_str_pass.b[2] then
		i_str_pass.s[3] = i_ds_donnee.getItemString(1, i_str_pass.s[6])		
	end if
end if	

return i_str_pass
end function

private function any get_data_with_argument ();/* <DESC>
    Fonction générique de validation de la saisie d'un code à partir d'une datawindow avec argument.
	 (Clause where intégrée dans la datawindow )
	 
    Principe:
	 
	 Initialisation de la data window du datatsore à partir du nom stocké dans la structure d'instance.

	 Retrieve de la datawindow en lui passant le code et un critère supplémentaire stocké dans le tableau
	 des chaines de caractères en position 10 et on complète la structure d'instance en fonction du résultat.
	 
	  Si aucune extraite (code inexistant), on initialise la première variable booléenne à Faux
	  Sinon on initialise la première variable booléenne à Vrai et retourne le code faisant l'objet du contrôle
	  avec son intitulé si demander.
   </DESC> */
Datastore ds_control
integer li_retrieve

ds_control = CREATE DATASTORE
ds_control.DataObject = i_str_pass.s[5]
ds_control.SetTransObject (SQLCA) 
li_retrieve = ds_control.retrieve(i_str_pass.s[10],i_str_pass.s[01])

if li_retrieve = -1 THEN
		f_dmc_error ("Control Manager" + BLANK + DB_ERROR_MESSAGE)			
end if

if ds_control.RowCount() = 0 then
	i_str_pass.b[1] = false
else
	i_str_pass.b[1] = true	
	i_str_pass.s[2] = ds_control.getItemString(1, i_str_pass.s[4])	
	if i_str_pass.b[2] then
		i_str_pass.s[3] = ds_control.getItemString(1, i_str_pass.s[6])		
	end if	
end if

return i_str_pass

end function

public function any is_devise_valide (any as_str_pass);/* <DESC>
     Permet de contrôler l'existence du code devise
   </DESC> */
i_str_pass = as_str_pass
i_str_pass.s[3] = DBNAME_CODE_DEVISE
i_str_pass.s[4] = DBNAME_CODE_DEVISE_INTITULE
i_str_pass.s[5] = 'd_liste_devise'
i_str_pass.b[2] = false
return  get_data_param()



end function

public function any is_marche_valide (any as_str_pass);/* <DESC>
     Permet de contrôler l'existence du code marche
   </DESC> */
i_str_pass = as_str_pass
i_str_pass.s[3] = DBNAME_CODE_MARCHE
i_str_pass.s[4] = DBNAME_CODE_MARCHE_INTITULE
i_str_pass.s[5] = 'd_liste_marche'
i_str_pass.b[2] = false
return  get_data_param()


end function

public function any is_origine_cde_valide (any as_str_pass);/* <DESC>
     Permet de contrôler l'existence du code origine de commande
   </DESC> */
i_str_pass = as_str_pass
i_str_pass.s[3] = DBNAME_ORIGINE_CDE
i_str_pass.s[4] = DBNAME_ORIGINE_CDE_INTITULE
i_str_pass.s[5] = 'd_liste_origine_cde'
i_str_pass.b[2] = false
return  get_data_param()


end function

public function any is_pays_valide (any as_str_pass);/* <DESC>
     Permet de contrôler l'existence du code pays
   </DESC> */
i_str_pass = as_str_pass
i_str_pass.s[3] = DBNAME_PAYS
i_str_pass.s[4] = DBNAME_PAYS_INTITULE
i_str_pass.s[5] = 'd_liste_pays'
i_str_pass.b[2] = false
return  get_data_param()


end function

public function any is_type_cde_valide (any as_str_pass);/* <DESC>
     Permet de contrôler l'existence du type de commande
   </DESC> */
i_str_pass = as_str_pass
i_str_pass.s[3] = DBNAME_TYPE_CDE
i_str_pass.s[4] = DBNAME_TYPE_CDE_INTITULE
i_str_pass.s[5] = 'd_liste_type_cde'
i_str_pass.b[2] = false
i_str_pass =   get_data()

if i_ds_donnee.RowCount() > 0 then
	i_str_pass.s[6] = i_ds_donnee.getItemString (1, DBNAME_RAISON_OBLIGATOIRE)
	i_str_pass.s[7] = i_ds_donnee.getItemString (1, DBNAME_VALORISATION_CDE)
	i_str_pass.s[8] = i_ds_donnee.getItemString (1, DBNAME_MODIF_REGROUPEMENT_CDE)
end if

return i_str_pass


end function

public function any is_raison_cde_valide (any as_str_pass);/* <DESC>
     Permet de contrôler l'existence de la raison de commande
   </DESC> */
i_str_pass = as_str_pass
i_str_pass.s[3] = "COME9023." + DBNAME_RAISON_CDE
i_str_pass.s[4] = DBNAME_RAISON_CDE_INTITULE
i_str_pass.s[5] = 'd_controle_raison_cde'
i_str_pass.s[7] = 'COME9023'
i_str_pass.b[2] = false
i_str_pass.d[1] = 1
return  get_data_with_argument()

//come9023
end function

public function any is_langue_valide (any as_str_pass);/* <DESC>
     Permet de contrôler l'existence du code langue
   </DESC> */
i_str_pass = as_str_pass
i_str_pass.s[3] = DBNAME_LANGUE
i_str_pass.s[4] = DBNAME_LANGUE_INTITULE
i_str_pass.s[5] = 'd_liste_langue'
i_str_pass.b[2] = false
return  get_data_param()


end function

private function any get_data_param ();/* <DESC>
    Fonction générique de validation de la saisie d'un code à partir d'une datawindow sans argument particulier.
	 
    Principe:
	 
	 Modification de la datawindow correspondante au code à contrôler et passé en paramètre, en rajoutant ou en complétant 
	 la clause where sur le code à contrôler. Ces informations sont passées via la structure d'instance Str_pass
	 
	 Retrieve de la datawindow
	  Si aucune donnée extraite (code inexistant), on initialise la première variable booléenne à Faux
	  Sinon on initialise la première variable booléenne à Vrai,on retourne le code faisant l'objet du controle
	  avec son intitulé si demander.
   </DESC> */
String s_sql
string mod_string
String s_retour

i_ds_donnee.DataObject = i_str_pass.s[5] 
i_ds_donnee.SetTransObject (SQLCA) 
s_sql = i_ds_donnee.getSqlSelect()

if pos(s_sql,"WHERE") = 0 then
	s_sql = s_sql + " WHERE " 
else
	s_sql = s_sql + " AND " 
end if

s_sql = s_sql + "CODPARAM  = '" + i_str_pass.s[1] + "'"	
i_ds_donnee.SetSqlSelect(s_sql)

if i_ds_donnee.retrieve() = -1 THEN
		f_dmc_error ("Control Manager" + BLANK + DB_ERROR_MESSAGE)			
end if

if i_ds_donnee.RowCount() = 0 then
	i_str_pass.b[1] =  false
else
	i_str_pass.b[1] =  true
	i_str_pass.s[2] = i_ds_donnee.getItemString(1, i_str_pass.s[4])
	if i_str_pass.b[2] then
		i_str_pass.s[3] = i_ds_donnee.getItemString(1, i_str_pass.s[6])		
	end if
end if	

return i_str_pass
end function

on nv_control_manager.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nv_control_manager.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;i_ds_donnee = CREATE Datastore
end event

