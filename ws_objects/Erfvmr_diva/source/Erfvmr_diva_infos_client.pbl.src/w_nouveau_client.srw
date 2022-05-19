$PBExportHeader$w_nouveau_client.srw
$PBExportComments$Permet la création d'un client prospect lors de la création d'une commande ou la modification des données par les assistantes commerciales ou par les vendeurs.
forward
global type w_nouveau_client from w_a_udis
end type
type pb_ok from u_pba_ok within w_nouveau_client
end type
type pb_echap from u_pba_echap within w_nouveau_client
end type
end forward

global type w_nouveau_client from w_a_udis
string tag = "CLIENT_PROSPECT"
integer x = 0
integer y = 0
integer width = 3387
integer height = 1928
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
long backcolor = 12632256
boolean center = true
event ue_listes pbm_custom40
pb_ok pb_ok
pb_echap pb_echap
end type
global w_nouveau_client w_nouveau_client

type variables
DataStore	i_ds_log_maj

end variables

event ue_listes;/* <DESC>
    Affichage des listes des codes correspondantes au champ en cours de saisie et ceci lors de l'activation de la touche F2. 
</DESC> */ 

// Listes proposées quand F2 sur une colonne
// -----------------------------------------
// DECLARATION DES VARIABLES LOCALES
String		s_colonne
String 		s_code_colonne
Str_pass		str_work

s_colonne = dw_1.GetColumnName()	
str_work.s[1] = s_colonne
str_work.s[2] = OPTION_CLIENT
str_work.s[3] = i_str_pass.s[1]

str_work = g_nv_liste_manager.get_list_of_column(str_work)

	
// cette action provient de la fenetre de selection appelée
// prédemment - click sur cancel
if str_work.s_action =  ACTION_CANCEL then
	return
end if

// Mise à jour de la datawindow correspondante à la liste selectionnee
dw_1.SetItem (1, s_colonne, str_work.s[1])

end event

event ue_init;/* <DESC>
   Initialisation de la fenêtre de saisie.
   Le N° de prospect, le code marché,la liste de prix, la devise,le code pays seront  initialisés à
   partir des paramètres associés au visiteur connecté.
   La nature du client sera initialisée à Client Donneur ordre (nature N101)
   </DESC> */

long l_retrieve
// DECLARATION DES VARIABLES LOCALES
i_ds_log_maj = CREATE DATASTORE
i_ds_log_maj.DataObject = 'd_client_log_maj'
i_ds_log_maj.SetTransObject (SQLCA)

i_str_pass.s[20]	= BLANK
// RETRIEVE DE LA DTW
IF UpperBound(i_str_pass.s,1) <> 0 and & 
   Trim(i_str_pass.s[1]) <> DONNEE_VIDE THEN
	if dw_1.Retrieve (i_str_pass.s[1]) = -1 then
		f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
	end if
else	
	dw_1.insertRow(0)
	i_str_pass.s[20]	= CODE_CREATION
	dw_1.SetItem (1, DBNAME_CLIENT_CODE, 	g_nv_come9par.get_numero_prospect())
	dw_1.SetItem (1, DBNAME_LISTE_PRIX, 	g_nv_come9par.get_liste_prix())	
	dw_1.SetItem (1, DBNAME_CODE_DEVISE, 	g_nv_come9par.get_devise())	
	dw_1.SetItem (1, DBNAME_PAYS, 			g_nv_come9par.get_code_pays())		
	dw_1.SetItem (1, DBNAME_NATURE_CLIENT, CLIENT_DONNEUR_ORDRE)			
end if

end event

event ue_ok;/* <DESC>
     Validation de la saisie des données et création de l'object nv_Client et de l'object nv_commande vide
	 Si le visiteur est un vendeur ,retour en saisie de commande, sinon affichage de la fenêtre permettant de completer la saisie
	 du client puis retour à la saisie de commandes.
   </DESC> */
	
// OVERRIDE SCRIPT ANCESTOR

// -----------------------------------------
// Traitement selon le type de process
// - Consultation
// - Création - Maj
// -----------------------------------------
IF i_str_pass.b[1] = FALSE THEN
	i_str_pass.s_action = ACTION_OK
	Message.fnv_set_str_pass(i_str_pass)
	Close (This)
	return
End if
	
This.TriggerEvent ("ue_save")
IF message.returnvalue < 0 THEN
	return
end if

i_str_pass.s[1] = dw_1.GetItemString (1, DBNAME_CLIENT_CODE)
nv_client_object lu_client
lu_client = CREATE nv_client_object
lu_client.fu_retrieve_client(i_str_pass.s[1])
i_str_pass.po[1] = lu_client

nv_commande_object l_commande
if (upperBound(i_str_pass.po,2)) > 0 then
	if not isNull(i_str_pass.po[2]) then
		l_commande = i_str_pass.po[2]
		i_str_pass.s[2] = l_commande.fu_get_numero_cde()	
		l_commande.fu_refresh_client_info(lu_client)
	end if
else
	l_commande = CREATE nv_commande_object
	i_str_pass.po[2] = l_commande
	i_str_pass.s[2] = DONNEE_VIDE	
end if


i_str_pass.b[1] = TRUE

i_str_pass.s_action = ACTION_OK
Message.fnv_set_str_pass(i_str_pass)
Close (This)


end event

event ue_presave;/* <DESC>
Permet d'effectuer le contrôle de la saisie des données.
Toutes les données sont obligatoires. Les codes doivent être existant dans la table paramètre correspondante.
Si tout est OK, enregistrement d'un mouvement dans la log  et les données du client seront complétées en alimentant les données
date de création, code mise à jour, code visiteur
</DESC> */


// DECLARATION DES VARIABLES LOCALES
	String		s_intitule
	Str_pass    l_str_work
	
	dw_1.AcceptText ()

	IF Not dw_1.fu_check_required () THEN
		dw_1.SetFocus ()
		Message.ReturnValue = -1
		RETURN
	END IF
	
// controle des zones obligatoires
     if isnull(dw_1.getItemString(1,DBNAME_CLIENT_NOM_COMPLET1)) or len(trim(dw_1.getItemString(1,DBNAME_CLIENT_NOM_COMPLET1)))  = 0 then
		MessageBox (This.title,g_nv_traduction.get_traduction(NOM_CLIENT_OBLIGATOIRE) ,StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_CLIENT_NOM_COMPLET1)
		dw_1.SetFocus ()
		Message.ReturnValue = -1
		return
  end if
  
   if isnull(dw_1.getItemString(1,DBNAME_CLIENT_ADRESSE_RUE)) or len(trim(dw_1.getItemString(1,DBNAME_CLIENT_ADRESSE_RUE))) = 0 then
		MessageBox (This.title,g_nv_traduction.get_traduction(ADRESSE_OBLIGATOIRE) ,StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_CLIENT_ADRESSE_RUE)
		dw_1.SetFocus ()
		Message.ReturnValue = -1
		return
  end if
 if isnull(dw_1.getItemString(1,DBNAME_CLIENT_CODE_POSTAL)) or len(trim(dw_1.getItemString(1,DBNAME_CLIENT_CODE_POSTAL))) = 0 then
		MessageBox (This.title,g_nv_traduction.get_traduction(CODE_POSTAL_OBLIGATOIRE) ,StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_CLIENT_CODE_POSTAL)
		dw_1.SetFocus ()
		Message.ReturnValue = -1
		return
  end if
  if isnull(dw_1.getItemString(1,DBNAME_CLIENT_BUREAU_DISTRIBUTEUR)) or len(trim(dw_1.getItemString(1,DBNAME_CLIENT_BUREAU_DISTRIBUTEUR))) = 0 then
		MessageBox (This.title,g_nv_traduction.get_traduction(VILLE_OBLIGATOIRE) ,StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_CLIENT_BUREAU_DISTRIBUTEUR)
		dw_1.SetFocus ()
		Message.ReturnValue = -1
		return
  end if
    if isnull(dw_1.getItemString(1,DBNAME_CLIENT_REGION)) or len(trim(dw_1.getItemString(1,DBNAME_CLIENT_REGION))) = 0 then
		MessageBox (This.title,g_nv_traduction.get_traduction(REGION_OBLIGATOIRE) ,StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_CLIENT_REGION)
		dw_1.SetFocus ()
		Message.ReturnValue = -1
		return
  end if
    if  isnull(dw_1.getItemString(1,DBNAME_CLASSE_ABC)) or len(trim(dw_1.getItemString(1,DBNAME_CLASSE_ABC))) = 0 then
		MessageBox (This.title,g_nv_traduction.get_traduction(CLASSE_ABC_OBLIGATOIRE) ,StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_CLASSE_ABC)
		dw_1.SetFocus ()
		Message.ReturnValue = -1
		return
  end if
	nv_control_manager nv_check_value 
	nv_check_value = CREATE nv_control_manager

// Controle du Code Pays
	l_str_work.s[1] = dw_1.GetItemString (1, DBNAME_PAYS)
	l_str_work.s[2] = BLANK
	l_str_work = nv_check_value.is_pays_valide (l_str_work)
	if not l_str_work.b[1] then
		MessageBox (This.title,g_nv_traduction.get_traduction(PAYS_INEXISTANT) + g_nv_traduction.get_traduction(OBTENIR_LISTE),StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_PAYS)
		dw_1.SetFocus ()
		Message.ReturnValue = -1
		RETURN
	end if
// Controle de la Nature Client
	l_str_work.s[1] = dw_1.GetItemString (1, DBNAME_NATURE_CLIENT)
	l_str_work.s[2] = BLANK
	l_str_work = nv_check_value.is_nature_valide (l_str_work)
	if not l_str_work.b[1] then
		MessageBox (This.title,g_nv_traduction.get_traduction(NATURE_INEXISTANTE) + g_nv_traduction.get_traduction(OBTENIR_LISTE),StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_NATURE_CLIENT)
		dw_1.SetFocus ()
		Message.ReturnValue = -1
		RETURN
	end if
//
// Contrôle du code fonction client
	l_str_work.s[1] = dw_1.GetItemString (1, DBNAME_FONCTION)
	l_str_work.s[2] = BLANK
   l_str_work = nv_check_value.is_fonction_client_valide (l_str_work)
	if not l_str_work.b[1] then		
		MessageBox (This.title,g_nv_traduction.get_traduction(FONCTION_INEXISTANTE) + g_nv_traduction.get_traduction(OBTENIR_LISTE),StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_FONCTION)
		dw_1.SetFocus ()
		Message.ReturnValue = -1
		RETURN
	end if	
// Contrôle du code Marche
	l_str_work.s[1] = dw_1.GetItemString (1, DBNAME_CODE_MARCHE)
	l_str_work.s[2] = BLANK
     l_str_work = nv_check_value.is_marche_valide (l_str_work)
	if not l_str_work.b[1] then		
		MessageBox (This.title, g_nv_traduction.get_traduction(MARCHE_INEXISTANT)+ g_nv_traduction.get_traduction(OBTENIR_LISTE),StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_CODE_MARCHE)
		dw_1.SetFocus ()
		Message.ReturnValue = -1
		RETURN
	end if		
// Contrôle du code Devise
	l_str_work.s[1] = dw_1.GetItemString (1, DBNAME_CODE_DEVISE)
	l_str_work.s[2] = BLANK
     l_str_work = nv_check_value.is_devise_valide (l_str_work)
	if not l_str_work.b[1] then	
		MessageBox (This.title, g_nv_traduction.get_traduction(DEVISE_INEXISTANTE) + g_nv_traduction.get_traduction(OBTENIR_LISTE),StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_CODE_DEVISE)
		dw_1.SetFocus ()
		Message.ReturnValue = -1
		RETURN
	end if	
	// Contrôle du code unite de commande client
	l_str_work.s[1] = dw_1.GetItemString (1, DBNAME_UCC)
	l_str_work.s[2] = BLANK
     l_str_work = nv_check_value.is_ucc_valide (l_str_work)
	if not l_str_work.b[1] then	
		MessageBox (This.title, g_nv_traduction.get_traduction(UCC_INEXISTANTE) + g_nv_traduction.get_traduction(OBTENIR_LISTE),StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_UCC)
		dw_1.SetFocus ()
		Message.ReturnValue = -1
		RETURN
	end if	
	destroy nv_check_value

	If not g_nv_come9par.is_relation_clientele() THEN 
			dw_1.SetItem (1, DBNAME_NOUVEAU_CLIENT, CODE_CLIENT_A_VALIDER)
			i_ds_log_maj.SetItem (1, DBNAME_NOUVEAU_CLIENT, CODE_CLIENT_A_VALIDER)		
			dw_1.SetItem (1, DBNAME_CLIENT_PAYEUR_CODE, dw_1.GetItemString(1,DBNAME_CLIENT_CODE))		
			dw_1.SetItem (1, DBNAME_CLIENT_FACTURE_CODE, dw_1.GetItemString(1,DBNAME_CLIENT_CODE))				
	Else
			dw_1.SetItem (1, DBNAME_NOUVEAU_CLIENT, CODE_CLIENT_VALIDER)
			i_ds_log_maj.SetItem (1, DBNAME_NOUVEAU_CLIENT, CODE_CLIENT_VALIDER)		
	End if 
	
  	dw_1.SetItem(1,DBNAME_DATE_CREATION, 	i_tr_sql.fnv_get_datetime ())
  	dw_1.SetItem(1,DBNAME_CODE_MAJ, 	CODE_CREATION)	 
  	dw_1.SetItem(1,DBNAME_CODE_VISITEUR_CLIENT, 	g_s_visiteur)	 	  
  	dw_1.SetItem(1,DBNAME_CLIENT_PAYEUR_CODE, 	dw_1.GetItemString(1,DBNAME_CLIENT_CODE))	  
  	dw_1.SetItem(1,DBNAME_CLIENT_FACTURE_CODE, 	dw_1.GetItemString(1,DBNAME_CLIENT_CODE))	  	  
	dw_1.SetItem(1,DBNAME_CODE_PROSPECT,	  CODE_PROSPECT)
	dw_1.SetItem(1,DBNAME_VISITEUR_EXTRACT,	 g_s_visiteur)
	dw_1.SetItem(1,DBNAME_DIRECTEUR_REGION_EXTRACT,	 g_s_visiteur)
	
   i_ds_log_maj.SetItem(1,DBNAME_CODE_PROSPECT,	  CODE_PROSPECT)	

   if i_str_pass.s[20] = CODE_CREATION then
		i_ds_log_maj.InsertRow(1)
		i_ds_log_maj.SetItem(1,DBNAME_CODE_VISITEUR,		g_s_visiteur)
		i_ds_log_maj.SetItem(1,DBNAME_DATE_CREATION, 	i_tr_sql.fnv_get_datetime ())
		i_ds_log_maj.SetItem(1,DBNAME_CODE_MAJ,			CODE_CREATION)
		i_ds_log_maj.SetItem(1,DBNAME_CLIENT_CODE,		dw_1.GetItemString(1,DBNAME_CLIENT_CODE))
	else
		i_ds_log_maj.retrieve(dw_1.GetItemString(1,DBNAME_CLIENT_CODE))
	end if

	String s_column_count
	integer i_nbr_column
	integer i_indice
	String s_column_name
	s_column_count = dw_1.Object.DataWindow.Column.Count
	i_nbr_column = Integer(s_column_count)

	for i_indice = 1  to i_nbr_column
		dw_1.setColumn(i_indice)
		s_column_name = dw_1.GetColumnName()
		if s_column_name = DBNAME_CODE_VISITEUR then
			continue
		end if
		if s_column_name = DBNAME_DATE_CREATION then
			continue
		end if		
		if s_column_name = DBNAME_CLIENT_CODE then
			continue
		end if		
		i_ds_log_maj.SetItem(1,s_column_name,dw_1.getItemString(1,s_column_name))
	next				

end event

event open;call super::open;/* <DESC>
    Permet de positionner la fenêtre dans le cadre MDI
   </DESC> */
	This.X = 0
	This.Y = 140
end event

event ue_cancel; /* <DESC>
    Permet de quitter la création sans sauvegarder les données.
   </DESC> */
// OVERRIDE SCRIPT ANCESTOR
	i_str_pass.s_action = ACTION_CANCEL
	Message.fnv_set_str_pass(i_str_pass)
	Close (This)
end event

on w_nouveau_client.create
int iCurrent
call super::create
this.pb_ok=create pb_ok
this.pb_echap=create pb_echap
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_ok
this.Control[iCurrent+2]=this.pb_echap
end on

on w_nouveau_client.destroy
call super::destroy
destroy(this.pb_ok)
destroy(this.pb_echap)
end on

event key;call super::key;/* <DESC>
    Permet de trapper les touches de fonction et d'effectuer le traitement associé.
    Seules les touches F11 et F2 sont traitées.
   </DESC> */
	
// TRAITEMENT SELON LA TOUCHE DE FONCTION
	IF KeyDown (KeyF11!) THEN
		This.PostEvent ("ue_ok")
	END IF

	IF KeyDown (KeyF2!) THEN
		This.PostEvent ("ue_listes")
	END IF
end event

event closequery;/* <DESC>
     overwrite le script de l'ancetre 
   </DESC> */
// OVERRIDE SCRIPT ANCESTOR
end event

event ue_save;call super::ue_save;/* <DESC>
  Effectue la mise à jour des données dans la base de données
  </DESC> */

i_ds_log_maj.Update ()

nv_client_object lu_client
lu_client = CREATE nv_client_object
lu_client.fu_retrieve_client(i_str_pass.s[1])
i_str_pass.po[1] = lu_client
end event

type uo_statusbar from w_a_udis`uo_statusbar within w_nouveau_client
end type

type dw_1 from w_a_udis`dw_1 within w_nouveau_client
string tag = "A_TRADUIRE"
integer x = 123
integer y = 24
integer width = 3136
integer height = 1520
integer taborder = 20
string dataobject = "d_nouveau_client"
borderstyle borderstyle = stylelowered!
end type

event dw_1::we_dwnkey;call super::we_dwnkey;
// RENVOIE A L'EVENEMENT KEY DE LA FENÊTRE 
//	f_activation_key ()
	f_key(Parent)
end event

event dw_1::we_dwnprocessenter;call super::we_dwnprocessenter;
// La touche ENTER simule la touche TAB
	Send (Handle(This) , 256, 9, Long(0,0))
//	dw_1.SetActionCode (1)
	RETURN 1
end event

type pb_ok from u_pba_ok within w_nouveau_client
integer x = 306
integer y = 1592
integer taborder = 0
string text = "Valid.  F11"
boolean default = false
string picturename = "C:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_echap from u_pba_echap within w_nouveau_client
integer x = 2034
integer y = 1596
integer taborder = 0
string picturename = "C:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

