$PBExportHeader$nv_pipeline_object.sru
$PBExportComments$Objet générique permettant l'execution des pipelines créés
forward
global type nv_pipeline_object from pipeline
end type
end forward

global type nv_pipeline_object from pipeline
end type
global nv_pipeline_object nv_pipeline_object

type variables
Boolean  ib_pbselect = false
Boolean  ib_where  = false
datetime id_date_max
String     is_table

end variables

forward prototypes
public subroutine uf_init_dataobject (string as_dataobject)
public subroutine uf_complete_visiteur ()
public subroutine uf_complete_marche ()
public subroutine uf_complete_pour_manager ()
public subroutine uf_complete_codemaj ()
protected function boolean uf_complete_date ()
public subroutine uf_complete_syntaxe (ref boolean ab_par_delta, any ao_datastore, long al_row, string as_table)
public function string uf_get_syntaxe_depart ()
public subroutine xxx_uf_update_sql (string as_sql)
public function string xx_uf_get_sql ()
public function boolean uf_maj_delta (ref string as_dbmessage)
end prototypes

public subroutine uf_init_dataobject (string as_dataobject);dataobject = as_dataobject

end subroutine

public subroutine uf_complete_visiteur ();/*   Permet de completer la clause where du pipeline en ajoutant une condition pour extraire toutes
	  les lignes de la tabe dont les données appartiennent au visiteur ou au directeur de région ou
	  a l'ensemble des visiteurs.
	     - Mise à jour ou création  de la clause where du pipeline avec la valeur de la date extraite.
 */
integer li_pos_deb
String ls_syntaxe
boolean lb_where_condition = false

ls_syntaxe = uf_get_syntaxe_depart()

if ib_pbselect then
	ls_syntaxe = ls_syntaxe  + "WHERE(    EXP1 =~~~"(" +  UPPER(DBNAME_VISITEUR_POUR_EXTRACTION) + "~~~""
	ls_syntaxe = ls_syntaxe + "   OP =~~~"IN~~~" EXP2 =~~~"('"
	ls_syntaxe = ls_syntaxe + G_S_VISITEUR + "','" 
	ls_syntaxe = ls_syntaxe + POUR_TOUS_VISITEURS + "')~~~" LOGIC = ~~~"OR~~~" )"
	ls_syntaxe = ls_syntaxe  + " WHERE(  EXP1 =~~~"" +  UPPER(DBNAME_DIRECTEUR_REGION_POUR_EXTRACTION) + "~~~""
	ls_syntaxe = ls_syntaxe + " OP =~~~"IN~~~" EXP2 =~~~"('"
	ls_syntaxe = ls_syntaxe + G_S_VISITEUR + "','" 
	ls_syntaxe = ls_syntaxe + POUR_TOUS_VISITEURS + "') ) ~~~" )"
	ls_syntaxe = ls_syntaxe + ") ~")"
	ls_syntaxe = ls_syntaxe + mid (syntax,pos(syntax,"DESTINATION",1)-2)
else
     if ib_where	 then
		ls_syntaxe = ls_syntaxe + " AND "
	else
		ls_syntaxe = ls_syntaxe + " WHERE "
	end if	
	ls_syntaxe = ls_syntaxe  + "( " +  UPPER(DBNAME_VISITEUR_POUR_EXTRACTION) + " IN ('"
	ls_syntaxe = ls_syntaxe + G_S_VISITEUR + "','" 
	ls_syntaxe = ls_syntaxe + POUR_TOUS_VISITEURS + "') OR "
	ls_syntaxe = ls_syntaxe  +  UPPER(DBNAME_DIRECTEUR_REGION_POUR_EXTRACTION) + " IN ('"
	ls_syntaxe = ls_syntaxe + G_S_VISITEUR + "','" 
	ls_syntaxe = ls_syntaxe + POUR_TOUS_VISITEURS + "')) ~")"
	ls_syntaxe = ls_syntaxe + mid (syntax,pos(syntax,"DESTINATION",1)-1)	
end if
syntax = ls_syntaxe
end subroutine

public subroutine uf_complete_marche ();/* <DESC>
     Permet de completer la clause where du pipeline en ajoutant une condition sur le code
	  visiteur de la table relation marche / code visiteur
	<LI> Mise à jour ou création  de la clause where du pipeline avec la valeur de la date extraite.
   </DESC> */

String ls_syntaxe

ls_syntaxe =  uf_get_syntaxe_depart()

if ib_pbselect then
	ls_syntaxe = ls_syntaxe  + "WHERE(  EXP1 =~~~"" +  UPPER(DBNAME_CODE_VISITEUR_MARCHE) + "~~~""
	ls_syntaxe = ls_syntaxe + " OP =~~~"IN~~~" EXP2 =~~~"('"
	ls_syntaxe = ls_syntaxe + G_S_VISITEUR + "','"
	ls_syntaxe = ls_syntaxe + POUR_TOUS_VISITEURS + "')~~~")) ~")"
	ls_syntaxe = ls_syntaxe + mid (syntax,pos(syntax,"DESTINATION",1)-2)
else
     if ib_where	 then
		ls_syntaxe = ls_syntaxe + " AND "
	else
		ls_syntaxe = ls_syntaxe + " WHERE "
	end if	
	ls_syntaxe = ls_syntaxe  + " ( " +  UPPER(DBNAME_CODE_VISITEUR_MARCHE) + " IN ('"
	ls_syntaxe = ls_syntaxe + G_S_VISITEUR + "','"
	ls_syntaxe = ls_syntaxe + POUR_TOUS_VISITEURS + " ) ~")"
	ls_syntaxe = ls_syntaxe + mid (syntax,pos(syntax,"DESTINATION",1)-1)	
end if
syntax = ls_syntaxe

end subroutine

public subroutine uf_complete_pour_manager ();/*   Permet de completer la clause where du pipeline en ajoutant une condition pour extraire toutes
	  les lignes de la tabe dont les données appartiennent aux visiteurs rattaché au visiteur ayant 
	  un profile de Manager
	  Mise à jour ou création  de la clause where du pipeline avec la valeur de la date extraite.
  */
integer li_pos_deb
String ls_syntaxe
boolean lb_where_condition = false

ls_syntaxe =  uf_get_syntaxe_depart()

if ib_pbselect then
	ls_syntaxe = ls_syntaxe  + "WHERE(    EXP1 =~~~"(" +  UPPER(DBNAME_VISITEUR_POUR_EXTRACTION) + "~~~""
	ls_syntaxe = ls_syntaxe + "   OP =~~~"IN~~~" EXP2 =~~~"("
	ls_syntaxe = ls_syntaxe + g_nv_come9par.get_visiteurs_lies()   + ",'" 
	ls_syntaxe = ls_syntaxe + POUR_TOUS_VISITEURS + "')~~~" LOGIC = ~~~"OR~~~" )"
	ls_syntaxe = ls_syntaxe  + " WHERE(  EXP1 =~~~"" +  UPPER(DBNAME_DIRECTEUR_REGION_POUR_EXTRACTION) + "~~~""
	ls_syntaxe = ls_syntaxe + " OP =~~~"IN~~~" EXP2 =~~~"("
	ls_syntaxe = ls_syntaxe + g_nv_come9par.get_visiteurs_lies()   + ",'" 
	ls_syntaxe = ls_syntaxe + POUR_TOUS_VISITEURS + "') ) ~~~" )"
	ls_syntaxe = ls_syntaxe + ") ~")"
	ls_syntaxe = ls_syntaxe + mid (syntax,pos(syntax,"DESTINATION",1)-2)
else
     if ib_where	 then
		ls_syntaxe = ls_syntaxe + " AND "
	else
		ls_syntaxe = ls_syntaxe + " WHERE "
	end if	
	ls_syntaxe = ls_syntaxe  + "( " +  UPPER(DBNAME_VISITEUR_POUR_EXTRACTION) + " IN ("
	ls_syntaxe = ls_syntaxe + g_nv_come9par.get_visiteurs_lies()   + ",'" 
	ls_syntaxe = ls_syntaxe + POUR_TOUS_VISITEURS + "') OR "
	ls_syntaxe = ls_syntaxe  +  UPPER(DBNAME_DIRECTEUR_REGION_POUR_EXTRACTION) + " IN ("
	ls_syntaxe = ls_syntaxe + g_nv_come9par.get_visiteurs_lies()   + ",'" 
	ls_syntaxe = ls_syntaxe + POUR_TOUS_VISITEURS + "')) ~")"
	ls_syntaxe = ls_syntaxe + mid (syntax,pos(syntax,"DESTINATION",1)-1)	
end if
syntax = ls_syntaxe


end subroutine

public subroutine uf_complete_codemaj ();/*   Permet de complèter la clause SQL du Pipeline en rajoutant la condition pour ne pas prendre en compte
	  les lignes dont le code mise à jour est positionné à annuler.
	  Dans le cas ou il n'existe pas de clase where dans la clause d'origine rajout de la clause sinon
	  on complète la clause existante.
*/
integer li_pos_deb
String ls_syntaxe
boolean lb_where_condition = false

ls_syntaxe =  uf_get_syntaxe_depart()

if ib_pbselect then
	ls_syntaxe = ls_syntaxe  + " WHERE(  EXP1 =~~~"" + UPPER(is_table) + "." + UPPER(DBNAME_CODE_MAJ) + "~~~""
	ls_syntaxe = ls_syntaxe + " OP =~~~"<> ~~~" EXP2 =~~~"'A'~~~")) ~")"
	ls_syntaxe = ls_syntaxe + mid (syntax,pos(syntax,"DESTINATION",1)-2)
else
	 if ib_where	 then
		ls_syntaxe = ls_syntaxe + " AND "
	else
		ls_syntaxe = ls_syntaxe + " WHERE "
	end if	
	ls_syntaxe = ls_syntaxe  + "( " + UPPER(is_table) + "." + UPPER(DBNAME_CODE_MAJ) + " <> 'A' ) ~")"
	ls_syntaxe = ls_syntaxe + mid (syntax,pos(syntax,"DESTINATION",1)-1)
end if
syntax = ls_syntaxe
end subroutine

protected function boolean uf_complete_date ();/*  Permet de completer la clause where du pipeline avec la date de derniere
	mise à jour la plus grande trouvée dans la table du portab le à mettre à jour.
	  Extraction de la date de création la plus récente de la tabel à mettre à jour
	et ceci en créant un datastore dynamique à partir du nom de la table.
	 Mise à jour ou création  de la clause where du pipeline avec la valeur de la date extraite.
*/
	
integer li_pos_deb
String ls_syntaxe

boolean lb_where_condition = false
boolean lb_where_date		= false

nv_Datastore ds_max_date

DateTime     dt_date
Date               dd_date
Time               lt_time

String	 ls_sql
String	 ls_erreur

if is_table = 'COME9042' then
	ls_sql= ''
end if

ds_max_date = CREATE nv_Datastore
ls_sql = "Select max(" + UPPER(is_table) + "." + UPPER(DBNAME_DATE_CREATION) + ") "  + &
                         "From " +  UPPER(is_table)

ls_sql = sqlca.syntaxFromSql (ls_sql, "Style(Type=tabular)" , ls_erreur)

if ds_max_date.create (ls_sql, ls_erreur) <> 1 then
	return false
end if

ds_max_date.setTransObject(sqlca)
if ds_max_date.retrieve() = -1 then
	return false
end if

if isNull (ds_max_date.getItemDateTime(1,1)) then
	return false
end if

dt_date = ds_max_date.getItemDateTime(1,1)
dd_date = Date(dt_date)
lt_time = Time(dt_date)
lt_time = RelativeTime(Time(dt_date), 1)

dt_date = datetime(dd_date, lt_time)
id_date_max = dt_date

ls_syntaxe = uf_get_syntaxe_depart()

if 	ib_pbselect then
	ls_syntaxe = ls_syntaxe + " WHERE(  EXP1 =~~~"" + UPPER(is_table) + "." + UPPER(DBNAME_DATE_CREATION) + "~~~""
	ls_syntaxe = ls_syntaxe + " OP =~~~">~~~" EXP2 =~~~"'"
	ls_syntaxe = ls_syntaxe + String(dt_date, "yyyy-mm-dd hh:mm:ss") + "'~~~")) ~")" 
	ls_syntaxe = ls_syntaxe + mid (syntax,pos(syntax,"DESTINATION",1)-2)
else
     if ib_where	 then
		ls_syntaxe = ls_syntaxe + " AND "
	else
		ls_syntaxe = ls_syntaxe + " WHERE "
	end if
	ls_syntaxe = ls_syntaxe + " (  " + UPPER(is_table) + "." + UPPER(DBNAME_DATE_CREATION) + "  > '"
	ls_syntaxe = ls_syntaxe + String(dt_date, "yyyy-mm-dd hh:mm:ss") + " ') ~")"
	ls_syntaxe = ls_syntaxe + mid (syntax,pos(syntax,"DESTINATION",1)-1)	
end if

// boucle pour changer le nom de la table par le nom de la table temporaire
long ll_start_pos 
string ls_old_str ,   ls_new_str

ls_old_str = UPPer(is_table)
ls_new_str = UPPer(is_table)+"_temp"

ll_start_pos = Pos(ls_syntaxe, "DESTINATION",1)
ll_start_pos =  Pos(ls_syntaxe, ls_old_str,ll_start_pos)
DO WHILE ll_start_pos > 0
    ls_syntaxe = Replace(ls_syntaxe, ll_start_pos, Len(ls_old_str), ls_new_str)
     ll_start_pos = Pos(ls_syntaxe, ls_old_str,ll_start_pos+Len(ls_new_str))
LOOP

syntax = ls_syntaxe

return true
end function

public subroutine uf_complete_syntaxe (ref boolean ab_par_delta, any ao_datastore, long al_row, string as_table);/*  Permet de compléter la clause SQL du Pipeline en fonction du type de mise à jour
	  à effectuer pour la table à mettre à jour
	    - Positionnement d'un indicateur précisant l'existence ou non d'une clause
	  de sélection dans le pipeline correspondant.
	    - Si le type de mise à jour est a effectuée avec extraction uniquement des
	  données du visiteur, complète la syntaxe en ajoutant une conditin sur le visiteur
	    - Si le type de mise à jour est a effectuée avec extraction en fonction de la date
	  de mise à jour, complète la syntaxe en ajoutant une condition sur le visiteur
	    - Si le type de mise à jour est a effectuée avec extraction uniquement des
	  données du marché associée au visiteur, complète la syntaxe en ajoutant une conditin sur le
	  marché.
	     -Si le type de mise à jour n'est pas effectué par Date, complète la sélection afin de
	  ne pas prendre en compte les lignes annulées
 */
 
nv_datastore lnv_ds
lnv_ds = ao_datastore
ab_par_delta = false
is_table 	= as_table

if is_table = 'come9040_ext' then
	messagebox('Controle','come9040_ext',information!,ok!)
end if

if pos(Upper(syntax), upper('STATEMENT=~"PBSELECT'),1) > 0  then
	ib_pbselect = true
else 
	ib_pbselect = false
end if
 
if upper(lnv_ds.getItemString(al_row, DBNAME_EXTRACTION_VISITEUR)) = "O" then
	if g_nv_come9par.is_manager( ) then
 		uf_complete_pour_manager ()
	else
 		uf_complete_visiteur()
	end if
end if
 
if upper(lnv_ds.getItemString(al_row, DBNAME_EXTRACTION_MARCHE)) = "O" then
      uf_complete_marche()
end if

if upper(lnv_ds.getItemString(al_row, DBNAME_EXTRACTION_DATE)) = "O"  and &
   not g_nv_come9par.is_maj_complete() then
  	ab_par_delta = uf_complete_date()
end if

if not ab_par_delta then
  	uf_complete_codemaj()
end if


end subroutine

public function string uf_get_syntaxe_depart ();/*   Permet d'extraire la syntaxe de depart.
	  La syntaxe est composé de 3 parties: 
	   - SOURCE qui contient les informations des tables d'ou sont extraites les données
	   - PBSELECTqui contient la clause Where 
	   -  DESTINATION qui contient les éléments de la table à mettre à jour
  	  
	 La partie qui est extraite est celle qui est avant DESTINATION et un indicateur est positionnée
	 pour spécifier l'existance ou non de la clause Where "PBSELECT"
*/
integer li_pos_deb 
String ls_syntaxe
String ls_chaine_1 = ")) ~")"
String ls_chaine_2 = "))~")"
Integer li_lg_1 = 5
Integer li_lg_2 = 4

li_pos_deb = pos(syntax,"DESTINATION",1)

if not ib_pbselect then
  ls_chaine_1 = "~")"
  ls_chaine_2 = "~")"
  li_lg_1 =2
  li_lg_2 = 2
end if

ib_where = false
if pos(syntax,"WHERE",1) > 0 then
	ib_where = true
end if

boolean lb_ok = false
integer li_indice 
String  ls_chaine_extraite_1
String  ls_chaine_extraite_2
li_indice = li_pos_deb

do while not lb_ok
	ls_chaine_extraite_1 = Mid(syntax, li_indice,li_lg_1)
	ls_chaine_extraite_2 = Mid(syntax, li_indice,li_lg_2)
	
	if ls_chaine_extraite_1 = ls_chaine_1  or & 
   	ls_chaine_extraite_2 = ls_chaine_2 then
		lb_ok = true
	else
		li_indice = li_indice - 1
	end if
loop

li_pos_deb = li_indice
if not ib_pbselect then
   li_pos_deb --
end if 
if ib_where  and ib_pbselect then
   li_pos_deb --
end if

ls_syntaxe = mid(syntax,1,li_pos_deb)

if not  ib_where then
	return ls_syntaxe
end if

if  ib_pbselect then
	ls_syntaxe = ls_syntaxe + " LOGIC = ~~~"AND~~~" ) "
end if

return ls_syntaxe
end function

public subroutine xxx_uf_update_sql (string as_sql);syntax = as_sql
end subroutine

public function string xx_uf_get_sql ();return syntax
end function

public function boolean uf_maj_delta (ref string as_dbmessage);/* Dans le cas d'une mise à jour effectuer en fonction de la date, les données extraites du serveur sont stockées
    dans une table temporaire.
	 
	Il faut intégrer ces données dans la table applicative.
	
	1- Extraction des champs constituant l'index de la table à partir de la syntaxe du pipeline
	2- Suppression dans la table applicative des données existantes dans la table temporaire
	3- Inserer dans la table applicative des données de la table temporaire
*/
Long ll_position
Long ll_position_column
Long ll_position_column_suivant
Long ll_position_key
Long ll_position_name
Long ll_indice
Long ll_indice_str

Boolean lb_fin_boucle
Str_pass lstr_pass
String   ls_column_name
String  ls_chaine
// _________________________  1- Recherche des clés de la table ____________________
ll_position = pos(syntax,"DESTINATION(",1)
ll_position_column =  Pos(syntax, "COLUMN",ll_position)
ll_indice_str = 0
DO WHILE ll_position_column > 0
	ll_position_column_suivant =  Pos(syntax, "COLUMN",ll_position_column+6)
     ls_chaine = Mid(syntax,ll_position_column, ll_position_column_suivant - ll_position_column)
     ll_position_key = Pos(ls_chaine,"key=yes",1)
	
	if ll_position_key > 0 then
		ll_position_name =  Pos(ls_chaine,",name=",1)
         ll_indice = ll_position_name + 7
		ls_column_name = ""
		lb_fin_boucle = false
		do while not lb_fin_boucle
			if  Mid(ls_chaine,ll_indice,1) = '"' then
				lb_fin_boucle = true
			else
				ls_column_name = ls_column_name + Mid(ls_chaine,ll_indice,1)
				ll_indice ++
			end if
		loop
		ll_indice_str ++
		lstr_pass.s[ll_indice_str] = ls_column_name
	end if
	ll_position_column =  Pos(syntax, "COLUMN",ll_position_column+6)
LOOP

// ________________________ 2- Suppression des donnes de la table applicative existantes dans la table temporaire _____________
String ls_sql
String ls_concat = ""

ls_sql ="Delete " + is_table + ".* from " + is_table  + "," +   is_table +"_temp where "

if ll_indice_str = 1 then
	ls_concat = is_table + "." + lstr_pass.s[1] + " = " +  is_table + "_temp." + lstr_pass.s[1]
else
	ls_concat = is_table + "." + lstr_pass.s[1] + " = " +  is_table + "_temp." + lstr_pass.s[1]
	For ll_indice = 2 to ll_indice_str
		 ls_concat = ls_concat + " and "
          ls_concat = ls_concat +  is_table + "." + lstr_pass.s[ll_indice] + " = " +  is_table + "_temp." + lstr_pass.s[ll_indice]
	next
end if

ls_sql = ls_sql + ls_concat + " ;"
EXECUTE immediate :ls_sql using sqlca;
if sqlca.sqldbcode <> 0 then
    as_dbmessage = sqlca.sqlerrtext
	return false
end if

ls_sql ="insert into " + is_table + " select * from " + is_table + "_temp  where codeemaj <> 'A';"
EXECUTE immediate :ls_sql using sqlca;
if sqlca.sqldbcode <> 0 then
    as_dbmessage = sqlca.sqlerrtext
	return  false
end if

return true


end function

on nv_pipeline_object.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nv_pipeline_object.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

