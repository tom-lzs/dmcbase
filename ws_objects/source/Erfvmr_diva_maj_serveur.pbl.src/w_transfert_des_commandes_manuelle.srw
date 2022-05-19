$PBExportHeader$w_transfert_des_commandes_manuelle.srw
$PBExportComments$Permet d'effectuer le transfert des commandes du portable vers le serveur et de lancer l'intégration de ces commandes.
forward
global type w_transfert_des_commandes_manuelle from w_a
end type
type erreurs_t from statictext within w_transfert_des_commandes_manuelle
end type
type pb_echap from u_pba_echap within w_transfert_des_commandes_manuelle
end type
type pb_ok from u_pba_ok within w_transfert_des_commandes_manuelle
end type
type dw_pipe_errors from datawindow within w_transfert_des_commandes_manuelle
end type
type dw_tables from datawindow within w_transfert_des_commandes_manuelle
end type
end forward

global type w_transfert_des_commandes_manuelle from w_a
integer x = 769
integer y = 461
integer width = 5394
integer height = 3292
string title = "Transfert manuel des commandes"
boolean minbox = false
boolean maxbox = false
boolean vscrollbar = true
boolean resizable = false
windowtype windowtype = response!
long backcolor = 12632256
boolean center = true
boolean ib_statusbar_visible = true
erreurs_t erreurs_t
pb_echap pb_echap
pb_ok pb_ok
dw_pipe_errors dw_pipe_errors
dw_tables dw_tables
end type
global w_transfert_des_commandes_manuelle w_transfert_des_commandes_manuelle

type variables
nv_pipeline_object i_pipeline

integer i_nbr_lue
integer i_nbr_ecrite
integer i_nbr_erreur
String is_dbmessage
String is_date_creation
String is_directory

end variables

forward prototypes
public function boolean fw_suppression_mvts_client ()
public function boolean fw_transfert_donnees (string as_table)
public subroutine fw_export_csv (string as_sql, string as_table)
end prototypes

public function boolean fw_suppression_mvts_client ();/* <DESC>
     Suppression des mouvements de modification des infos client de la base local
	<LI> Extraction des mouvements à partir de la datastore puis copy de toutes les lignes
	du buffer primaire dans le buffer contenant les lignes supprimées, puis lancer la
	mise à jour
   </DESC> */
nv_datastore ds_locale
ds_locale = CREATE nv_datastore
ds_locale.dataobject = "d_extraction_mvts_client"
ds_locale.settrans( i_tr_sql)
ds_locale.retrieve(g_s_visiteur)

i_nbr_lue = ds_locale.rowCount()
i_nbr_ecrite = 0

ds_locale.RowsMove(1, ds_locale.rowcount(), primary!, ds_locale, 1,Delete!)
if ds_locale.update() = -1 then
     is_dbmessage = ds_locale.uf_getdberror( )
	i_nbr_erreur = i_nbr_lue
	return false
end if
i_nbr_ecrite = i_nbr_lue
return true

end function

public function boolean fw_transfert_donnees (string as_table);/* <DESC>
    Transfert des données commandes vers le serveur en effectuant une copie des lignes extraites de la base
	 locale.
  </DESC> */
nv_datastore ds_locale

String s_datawindow_locale
boolean b_avec_param = false 
String   s_param		
String ls_fichier
String ls_table_sql

ds_locale = CREATE nv_datastore

Choose case as_table
	case "come9pat"
		ds_locale.dataobject = "d_extraction_entete_cde"
		ls_table_sql = "select * from  come90pa where numaecde in (select numaecde from come9cdt) "
	case "come9pbt"
		ds_locale.dataobject = "d_extraction_message_cde"
		ls_table_sql = "select * from  come90pb where numaecde in (select numaecde from come9cdt) "		
	case "come9pct"
		ds_locale.dataobject = "d_extraction_ligne_cde"
		ls_table_sql = "select * from  come90pc where numaecde in (select numaecde from come9cdt) "
	case "come986t"
		ds_locale.dataobject = "d_extraction_come9086"
		ls_table_sql = "select * from  come9086 where numaecde in (select numaecde from come9cdt) "		
	case "come987t"
		ds_locale.dataobject = "d_extraction_come9087"
		ls_table_sql = "select * from  come9087 where numaecde in (select numaecde from come9cdt) "		
	case "come988t"
		ds_locale.dataobject = "d_extraction_come9088"
		ls_table_sql = "select * from  come9088 where numaecde in (select numaecde from come9cdt) "		
	case "come989t"
		ds_locale.dataobject = "d_extraction_come9089"
		ls_table_sql = "select * from  come9089 where numaecde in (select numaecde from come9cdt) "		
    case "come990t"
		ds_locale.dataobject = "d_extraction_come9090"
		ls_table_sql = "select * from  come9090 where numaecde in (select numaecde from come9cdt) "		
	case "come991t"
		ds_locale.dataobject = "d_extraction_come9091"
		ls_table_sql = "select * from  come9091 where numaecde in (select numaecde from come9cdt) "		
    case "come940t"
		ds_locale.dataobject = "d_extraction_client_prospect"
		b_avec_param = true
		s_param = g_s_visiteur
		ls_table_sql = "select * from  come9040 where numaeclf like 'P"+g_s_visiteur +"%' and numaeclf in (select numaclf from come90pa, come9cdt where come90pa.numaecde = come9cdt.numaeclf) "				
    case "come949t"
		ds_locale.dataobject = "d_extraction_mvts_client"
		b_avec_param = true
		s_param = g_s_visiteur
		ls_table_sql = "select * from  come9040 where codeevis = '" + g_s_visiteur + "'"
	case "come999t"
		ds_locale.dataobject = "d_extraction_entete_cde"
		ls_table_sql = "select * from  come90pa where numaecde in (select numaecde from come9cdt) "		
end choose

ds_locale.settrans( i_tr_sql)

if b_avec_param then					
	ds_locale.retrieve(s_param)
else
	ds_locale.retrieve()
end if

i_nbr_lue = ds_locale.rowCount()

if  ds_locale.rowCount() > 0 then
    fw_export_csv (ls_table_sql, as_table)
end if

i_nbr_ecrite= i_nbr_lue
i_nbr_erreur = 0
return true
end function

public subroutine fw_export_csv (string as_sql, string as_table);String ls_fichier
String ls_directory
String ls_sql
long start_pos=1

ls_directory = GetCurrentDirectory ( )
ls_directory = ls_directory + "\Transfert" 

if not  DirectoryExists ( ls_directory ) Then
	CreateDirectory(ls_directory)
end if

ls_directory = ls_directory + "\" + is_date_creation
is_directory = ls_directory

if len(ls_directory) > 0 then
	if not  DirectoryExists ( ls_directory ) Then
		CreateDirectory(ls_directory)
	end if
end if 
ls_fichier = ls_directory  + "\" + as_table  + ".csv"

start_pos = Pos(ls_fichier, '\', start_pos)
DO WHILE start_pos > 0
    ls_fichier = Replace(ls_fichier, start_pos, 1,'\\')
    start_pos = Pos(ls_fichier, '\', start_pos + 2)
LOOP

// suppression du contenu de la table come9cdt du portable
ls_sql = as_sql + " into outfile '" + ls_fichier + " ' FIELDS TERMINATED BY ';'"
EXECUTE immediate :ls_sql using i_tr_sql;
if i_tr_sql.sqldbcode <> 0 then
	is_dbmessage = i_tr_sql.sqlerrtext
	return 
end if


end subroutine

on w_transfert_des_commandes_manuelle.create
int iCurrent
call super::create
this.erreurs_t=create erreurs_t
this.pb_echap=create pb_echap
this.pb_ok=create pb_ok
this.dw_pipe_errors=create dw_pipe_errors
this.dw_tables=create dw_tables
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.erreurs_t
this.Control[iCurrent+2]=this.pb_echap
this.Control[iCurrent+3]=this.pb_ok
this.Control[iCurrent+4]=this.dw_pipe_errors
this.Control[iCurrent+5]=this.dw_tables
end on

on w_transfert_des_commandes_manuelle.destroy
call super::destroy
destroy(this.erreurs_t)
destroy(this.pb_echap)
destroy(this.pb_ok)
destroy(this.dw_pipe_errors)
destroy(this.dw_tables)
end on

event ue_ok;call super::ue_ok;/* <DESC>
    Executer le transfert des données dans l'ordre défini dans la datawindow des traitements:
    <LI>Si le traitement est 'preparation', affichage de la fenetre de selection des commandes à transferer
    <LI>Si le traitement est 'come9049' suppression des mouvements de modification clients sur le poste
    <LI>Si le traitement est 'come9par' mise à jour des compteurs sur le serveur si ceux ci sont plus petits que ceux en local
    <LI>Sinon, transfert des données de la table correspondant au nom du traitement sur le serveur.
  </DESC> */
integer li_return
long ll_long
String  ls_table
str_pass l_str_pass
long ll_row
Boolean  lb_return
String ls_statut
integer li_nbr_cde_validee
datetime id_date_deb
string ls_sql


pb_ok.enabled = false
pb_echap.enabled = false

setPointer(HourGlass!)

is_date_creation = string( today(), "yyyy-mm-dd hh-mm-ss")
id_date_deb = sqlca.fnv_get_datetime ()

// suppression du contenu de la table come9cdt du portable
ls_sql ="truncate table  COME9CDT;"
EXECUTE immediate :ls_sql using i_tr_sql;
if i_tr_sql.sqldbcode <> 0 then
	is_dbmessage = i_tr_sql.sqlerrtext
	return 
end if

// Boucle de lecture de la datawindow contenant les traitemlents a effectuer
for ll_long = 1 to dw_tables.rowCount()
 	dw_tables.setItem(ll_long, "statut",	  "Encours")	
     dw_tables.setItem(ll_long, "heure_debut",		String(now()))	
	ls_table  = dw_tables.getItemString(ll_long, DBNAME_CODE_TABLE)
	i_nbr_lue = 0
	i_nbr_ecrite = 0
	i_nbr_erreur = 0
	lb_return = false
	ls_statut = "Terminer"
	
	choose case ls_table

   	     case "Preparation"
			OpenWithParm (w_selection_commandes, l_str_pass)
			l_str_pass = Message.fnv_get_str_pass()
			Message.fnv_clear_str_pass()				
			if l_str_pass.s_action = ACTION_CANCEL  then	
					pb_echap.enabled = true	
					return
			else
				i_nbr_lue = l_str_pass.d[1]
				i_nbr_ecrite  =  l_str_pass.d[2]
				i_nbr_erreur =  0
			end if
			
	   case "come9049"
			if not fw_suppression_mvts_client()  then
				ll_row = dw_pipe_errors.insertRow(0)
				dw_pipe_errors.setItem(ll_row,"Ligne_erreur", is_dbmessage)
				MessageBox(This.Title,g_nv_traduction.get_traduction ("TRANSFERT_CDE_ERREUR") , information!,ok!)
				lb_return = true
				ls_statut = "En Erreur"				
			end if

     case else
			if not fw_transfert_donnees(ls_table)  then
				ll_row = dw_pipe_errors.insertRow(0)
				dw_pipe_errors.setItem(ll_row,"Ligne_erreur", is_dbmessage)
   				lb_return = true
				ls_statut = "En Erreur"					
			end if
	end choose
	
	dw_tables.setItem(dw_tables.getRow(),"indicateur", 0)
	dw_tables.setItem(ll_long, "ligne_lue",		String(i_nbr_lue))
	dw_tables.setItem(ll_long, "ligne_ecrite",	     String(i_nbr_ecrite))	
     dw_tables.setItem(ll_long, "ligne_erreur",	String(i_nbr_erreur))		
     dw_tables.setItem(ll_long, "heure_fin",		String(now()))		
	dw_tables.setItem(ll_long, "statut", ls_statut	)
	dw_tables.setredraw( true)
next

pb_echap.enabled = true

choose case g_nv_come9par.get_code_langue( )
	case 'F'
	messageBox ("Transfert manuel des cdes", "Maintenant vous devez attacher les fichiers sui sont le répertoire '" + is_directory + "' dans un mail et vous l'envoyer à mpasquiers@dmc.fr, copy to cmangold@dmc.fr et dbihr@dmc.fr")
	case 'I'
	messageBox ("Manual Order Transfer", "Now you must attached the files which are in the directory '" + is_directory + "' in a mail and send it to mpasquiers@dmc.fr, copy to cmangold@dmc.fr and dbihr@dmc.fr")
	case 'S'
    messageBox ("Manual Order Transfer", "Now you must attached the files which are in the directory '" + is_directory + "' in a mail and send it to mpasquiers@dmc.fr, copy to cmangold@dmc.fr and dbihr@dmc.fr")		
	case'E'
	messageBox ("Manual Order Transfer", "Now you must attached the files which are in the directory '" + is_directory + "' in a mail and send it to mpasquiers@dmc.fr, copy to cmangold@dmc.fr and dbihr@dmc.fr")
    case else	
	messageBox ("Transfert manuel des cdes", "Maintenant vous devez attacher les fichiers sui sont le répertoire '" + is_directory + "' dans un mail et vous l'envoyer à mpasquiers@dmc.fr, copy to cmangold@dmc.fr et dbihr@dmc.fr")		
end choose


end event

event ue_init;call super::ue_init;/* <DESC>
    Initialisation de l'affichage de la fenêtre.
	 Création des lignes des traitements à effectuer dans la datawindow.
   </DESC> */
long ll_row

ll_row ++
dw_tables.insertRow (ll_row)
dw_tables.setItem(ll_row, 1,"Preparation")
dw_tables.setItem(ll_row, 2,"Selection des commandes à transferer")
dw_tables.setItem(ll_row, 3,"En attente")
dw_tables.setItem(ll_row,"pipeline_object","w_selection_commandes")

// Données pour transfert des commandes sur le serveur
ll_row ++
dw_tables.insertRow (ll_row)
dw_tables.setItem(ll_row, 1,"come999t")
dw_tables.setItem(ll_row, 2,"Transfert entetes commandes")
dw_tables.setItem(ll_row, 3,"En attente")
dw_tables.setItem(ll_row,"pipeline_object","d_come999t")

ll_row ++
dw_tables.insertRow (ll_row)
dw_tables.setItem(ll_row, 1,"come9pct")
dw_tables.setItem(ll_row, 2,"Transfert lignes commandes")
dw_tables.setItem(ll_row, 3,"En attente")
dw_tables.setItem(ll_row,"pipeline_object","d_come9pct")

ll_row ++
dw_tables.insertRow (ll_row)
dw_tables.setItem(ll_row, 1,"come9pbt")
dw_tables.setItem(ll_row, 2,"Transfert messages commandes")
dw_tables.setItem(ll_row, 3,"En attente")
dw_tables.setItem(ll_row,"pipeline_object","d_come9pbt")

ll_row ++
dw_tables.insertRow (ll_row)
dw_tables.setItem(ll_row, 1,"come991t")
dw_tables.setItem(ll_row, 2,"Transfert Instructions Cde")
dw_tables.setItem(ll_row, 3,"En attente")
dw_tables.setItem(ll_row,"pipeline_object","d_come991t")

ll_row ++
dw_tables.insertRow (ll_row)
dw_tables.setItem(ll_row, 1,"come990t")
dw_tables.setItem(ll_row, 2,"Transfert textes transitaires")
dw_tables.setItem(ll_row, 3,"En attente")
dw_tables.setItem(ll_row,"pipeline_object","d_come990t")

ll_row ++
dw_tables.insertRow (ll_row)
dw_tables.setItem(ll_row, 1,"come989t")
dw_tables.setItem(ll_row, 2,"Transfert textes factures")
dw_tables.setItem(ll_row, 3,"En attente")
dw_tables.setItem(ll_row,"pipeline_object","d_come989t")

ll_row ++
dw_tables.insertRow (ll_row)
dw_tables.setItem(ll_row, 1,"come988t")
dw_tables.setItem(ll_row, 2,"Transfert textes marquages")
dw_tables.setItem(ll_row, 3,"En attente")
dw_tables.setItem(ll_row,"pipeline_object","d_come988t")

ll_row ++
dw_tables.insertRow (ll_row)
dw_tables.setItem(ll_row, 1,"come987t")
dw_tables.setItem(ll_row, 2,"Transfert textes transporteur")
dw_tables.setItem(ll_row, 3,"En attente")
dw_tables.setItem(ll_row,"pipeline_object","d_come987t")

ll_row ++
dw_tables.insertRow (ll_row)
dw_tables.setItem(ll_row, 1,"come986t")
dw_tables.setItem(ll_row, 2,"Transfert textes bordereau")
dw_tables.setItem(ll_row, 3,"En attente")
dw_tables.setItem(ll_row,"pipeline_object","d_come986t")


ll_row ++
dw_tables.insertRow (ll_row)
dw_tables.setItem(ll_row, 1,"come940t")
dw_tables.setItem(ll_row, 2,"Transfert clients prospects")
dw_tables.setItem(ll_row, 3,"En attente")
dw_tables.setItem(ll_row,"pipeline_object","d_come940t")

ll_row ++
dw_tables.insertRow (ll_row)
dw_tables.setItem(ll_row, 1,"come949t")
dw_tables.setItem(ll_row, 2,"Transfert mouvements clients")
dw_tables.setItem(ll_row, 3,"En attente")
dw_tables.setItem(ll_row,"pipeline_object","d_come949t")

ll_row ++
dw_tables.insertRow (ll_row)
dw_tables.setItem(ll_row, 1,"come9049")
dw_tables.setItem(ll_row, 2,"RAZ mouvements clients")
dw_tables.setItem(ll_row, 3,"En attente")
dw_tables.setItem(ll_row,"pipeline_object","d_extraction_mvts_client")

ll_row ++
dw_tables.insertRow (ll_row)
dw_tables.setItem(ll_row, 1,"come9pat")
dw_tables.setItem(ll_row, 2,"Transfert entetes commandes")
dw_tables.setItem(ll_row, 3,"En attente")
dw_tables.setItem(ll_row,"pipeline_object","d_come9pat")

setPointer(Arrow!)

i_pipeline = CREATE nv_pipeline_object
pb_ok.enabled = true
pb_echap.enabled = true
pb_ok.setfocus( )

end event

event ue_cancel;call super::ue_cancel;/* <DESC> 
     Permet de quitter le trqnsfert apres deconnexion du serveur
   </DESC> */
close(this)
end event

event ue_print;call super::ue_print;/* <DESC>
      Permet d'imprimer la liste des traitements definis dans la datawindow des traitements
	</DESC> */
dw_tables.print()
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

type uo_statusbar from w_a`uo_statusbar within w_transfert_des_commandes_manuelle
end type

type erreurs_t from statictext within w_transfert_des_commandes_manuelle
integer x = 187
integer y = 1280
integer width = 718
integer height = 100
integer textsize = -14
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "none"
boolean border = true
boolean focusrectangle = false
end type

type pb_echap from u_pba_echap within w_transfert_des_commandes_manuelle
integer x = 1719
integer y = 1160
integer taborder = 30
boolean enabled = false
string picturename = "C:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type pb_ok from u_pba_ok within w_transfert_des_commandes_manuelle
integer x = 1234
integer y = 1156
integer taborder = 20
boolean enabled = false
string picturename = "C:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type dw_pipe_errors from datawindow within w_transfert_des_commandes_manuelle
integer x = 160
integer y = 1384
integer width = 3534
integer height = 704
integer taborder = 20
string title = "                                                 Les Erreurs"
string dataobject = "d_erreur_transfert"
boolean hscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_tables from datawindow within w_transfert_des_commandes_manuelle
integer x = 110
integer y = 36
integer width = 3858
integer height = 1092
integer taborder = 10
string title = "none"
string dataobject = "d_suivi"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

