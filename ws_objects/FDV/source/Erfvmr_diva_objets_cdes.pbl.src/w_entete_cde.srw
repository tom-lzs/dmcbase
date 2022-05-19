$PBExportHeader$w_entete_cde.srw
$PBExportComments$Affichage et mise à jour de l'entête de commande. Première fenêtre qui est commune aux différents profils de visiteur.
forward
global type w_entete_cde from w_a_mas_det
end type
type pb_ok from u_pba_ok within w_entete_cde
end type
type pb_echap from u_pba_echap within w_entete_cde
end type
end forward

global type w_entete_cde from w_a_mas_det
string tag = "ENTETE_CDE"
integer x = 0
integer y = 0
integer width = 2985
integer height = 2012
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = child!
windowstate windowstate = maximized!
long backcolor = 12632256
boolean ib_statusbar_visible = true
event ue_planning pbm_custom41
event ue_listes pbm_custom47
event ue_modifications pbm_custom54
event ue_entete_cde pbm_custom55
event ue_workflow ( )
pb_ok pb_ok
pb_echap pb_echap
end type
global w_entete_cde w_entete_cde

type variables
// Structure Information client
str_pass		i_str_client
DateTime		i_dt_dtsaeliv
nv_commande_object i_nv_commande_object

String is_fenetre_origine

end variables

forward prototypes
public function string fw_determine_recherche_partenaire ()
end prototypes

event ue_listes;/* <DESC>
    Affichage des listes correspondantes au champ en cours de saisie et
	 ceci lors de l'activation de la touche F2. 
	 En Retour affichage de l'intitulé du code sélectionné.
</DESC> */ 
// =========================================
// Listes proposées quand F2 sur une colonne
// -----------------------------------------
// - Liste des codes fonction client
// - Liste des codes nature client
// - Liste des clients grossistes
// =========================================
// DECLARATION DES VARIABLES LOCALES
String		s_colonne
Str_pass		str_work

s_colonne = dw_1.GetColumnName()
str_work.s[1] = s_colonne
str_work.s[2] = fw_determine_recherche_partenaire()
str_work.s[3] = dw_1.getItemString(1,DBNAME_TYPE_CDE)
str_work.s[4] = i_str_pass.s[1]

str_work = g_nv_liste_manager.get_list_of_column(str_work)

// cette action provient de la fenetre de selection appelée
// prédemment - click sur cancel
if str_work.s_action =  ACTION_CANCEL then
	return
end if

// Mise à jour de la datawindow correspondante à la liste selectionnee
if s_colonne = DBNAME_GROSSISTE then
	dw_1.SetItem (1, DBNAME_GROSSISTE, str_work.s[1])
	dw_1.SetItem (1, DBNAME_GROSSISTE_ABREGE_NOM, str_work.s[2])
	dw_1.SetItem (1, DBNAME_GROSSISTE_ABREGE_VILLE, str_work.s[3])
	
elseif s_colonne = DBNAME_CLIENT_LIVRE_CODE then
	dw_1.SetItem (1, DBNAME_CLIENT_LIVRE_CODE, str_work.s[1])
	dw_1.SetItem (1, DBNAME_CLIENT_LIVRE_ABREGE_NOM, str_work.s[2])
	dw_1.SetItem (1, DBNAME_CLIENT_LIVRE_ABREGE_VILLE, str_work.s[3])
else
	dw_1.SetItem (1, s_colonne, str_work.s[1])
	dw_1.SetItem (1, str_work.s[3], str_work.s[2])	
end if

end event

event ue_workflow();/* <DESC>
    Cet evenement est appelé lors de la sélection d'une option dans le menu alors que cette
	 fenetre est la fenetre active et va lancer le workflow manager pour effetuer l'enchainement.
</DESC> */
i_str_pass.po[2] = i_nv_commande_object
i_str_pass.s[2] = i_nv_commande_object.fu_get_numero_cde()
g_nv_workflow_manager.fu_check_workflow(FENETRE_ENTETE_CDE, i_str_pass)
close(this)
end event

public function string fw_determine_recherche_partenaire ();/* <DESC>
     Determine l'affichage de la liste des clients livrés
	Si client prospect , Il faudra afficher la liste de la table des	clients sinon
	    il faudra afficher la liste des clients livrés partneraires du donneur d'ordre
   </DESC> */
nv_client_object l_client
l_client = i_str_pass.po[1]

if l_client.is_client_Prospect() then
	return OPTION_CLIENT
end if

return OPTION_PARTENAIRE
end function

event ue_cancel;/* <DESC>
      Permet de quitter la fenetre aprés avoir initialisé la structure de l'object commande
	 et permetre le retour soit sur la liste des commandes  ou soit sur la saisie des lignes
	 de commande
   </DESC> */
i_b_canceled = TRUE
i_str_pass.po[2] = i_nv_commande_object
i_str_pass.s[2] = i_nv_commande_object.fu_get_numero_cde()

if is_fenetre_origine = BLANK  or trim(is_fenetre_origine) = "" or isnull(is_fenetre_origine) then
	g_s_fenetre_destination = FENETRE_LIGNE_CDE
else	
	g_s_fenetre_destination = is_fenetre_origine
end if

triggerEvent("ue_workflow")
close(this)

end event

event ue_presave;call super::ue_presave;/* <DESC>
     Validation de la saisie des données
	 Controle des données obligatoires :
	     Origine,Type, Client livré, Date de commande
	 Controle de la validité des codes
	     Origine,type,Raison, Client livré, Grossiste, Arun
	Controle de coherence entre les dates de saisie, de livraison et de commande
   </DESC> */
// DECLARATION DES VARIABLES LOCALES

Date   d_date_cde
Date   d_date_livraison
Date   d_saisie_cde
str_pass l_str_work
Integer li_reponse
	
// TRAITEMENT AVANT SAUVEGARDE
dw_1.AcceptText ()

// Controle des infos obligatoires
if trim(dw_1.GetItemString (1, DBNAME_ORIGINE_CDE)) = DONNEE_VIDE  or & 
   isNull(dw_1.GetItemString (1, DBNAME_ORIGINE_CDE)) then
	MessageBox (This.title,g_nv_traduction.get_traduction(ORIGINE_OBLIGATOIRE) + g_nv_traduction.get_traduction(OBTENIR_LISTE),StopSign!,Ok!,1)
	dw_1.SetColumn (DBNAME_ORIGINE_CDE)
	dw_1.SetFocus ()
	Message.ReturnValue = -1
	RETURN
end if		
if trim(dw_1.GetItemString (1, DBNAME_TYPE_CDE)) = DONNEE_VIDE  or & 
   isNull(dw_1.GetItemString (1, DBNAME_TYPE_CDE)) then
	MessageBox (This.title,g_nv_traduction.get_traduction(TYPE_CDE_OBLIGATOIRE) + g_nv_traduction.get_traduction(OBTENIR_LISTE),StopSign!,Ok!,1)
	dw_1.SetColumn (DBNAME_TYPE_CDE)
	dw_1.SetFocus ()
	Message.ReturnValue = -1
	RETURN
end if		

//if trim(dw_1.GetItemString (1, DBNAME_CLIENT_LIVRE_CODE)) = trim(dw_mas.GetItemString (1, DBNAME_CLIENT_CODE)) then
//	dw_1.setitem(1,DBNAME_CLIENT_LIVRE_CODE,"????")
//end if
if trim(dw_1.GetItemString (1, DBNAME_CLIENT_LIVRE_CODE)) <> trim(dw_mas.GetItemString (1, DBNAME_CLIENT_CODE)) then
		if trim(dw_1.GetItemString (1, DBNAME_CLIENT_LIVRE_CODE)) = DONNEE_VIDE  or & 
			isNull(dw_1.GetItemString (1, DBNAME_CLIENT_LIVRE_CODE)) then
			MessageBox (This.title,g_nv_traduction.get_traduction(CLIENT_LIVRE_OBLIGATOIRE) + g_nv_traduction.get_traduction(OBTENIR_LISTE),StopSign!,Ok!,1)
			dw_1.SetColumn (DBNAME_CLIENT_LIVRE_CODE)
			dw_1.SetFocus ()
			Message.ReturnValue = -1
			RETURN
		end if		
		if isNull(dw_1.GetItemDateTime (1, DBNAME_DATE_CDE)) then
			MessageBox (This.title,g_nv_traduction.get_traduction(DATE_CDE_OBLIGATOIRE) ,StopSign!,Ok!,1)
			dw_1.SetColumn (DBNAME_DATE_CDE)
			dw_1.SetFocus ()
			Message.ReturnValue = -1
			RETURN
		end if		
end if
// Controle des codes
nv_control_manager nv_check_value 
nv_check_value = CREATE nv_control_manager

	// code blocage sap
IF trim(dw_1.GetItemString(1,DBNAME_CODE_BLOCAGE_SAP)) <> DONNEE_VIDE and & 
	not isNull(trim(dw_1.GetItemString(1,DBNAME_CODE_BLOCAGE_SAP))) THEN	
	l_str_work.s[1] = dw_1.GetItemString (1, DBNAME_CODE_BLOCAGE_SAP)
	l_str_work.s[2] = BLANK
	l_str_work = nv_check_value.is_blocage_sap_valide (l_str_work)
	if not l_str_work.b[1] then	
		MessageBox (This.title,g_nv_traduction.get_traduction(BLOCAGE_SAP_INEXISTANT) + g_nv_traduction.get_traduction(OBTENIR_LISTE),StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_CODE_BLOCAGE_SAP)
		dw_1.SetFocus ()
		Message.ReturnValue = -1
		RETURN
	end if	
	dw_1.SetItem (1, DBNAME_CODE_BLOCAGE_SAP_INTITULE, l_str_work.s[2])
end if

   //Origine de commande
l_str_work.s[1] = dw_1.GetItemString (1, DBNAME_ORIGINE_CDE)
l_str_work.s[2] = BLANK
l_str_work = nv_check_value.is_origine_cde_valide (l_str_work)
if not l_str_work.b[1] then
	MessageBox (This.title,g_nv_traduction.get_traduction(ORIGINE_INEXISTANTE) + g_nv_traduction.get_traduction(OBTENIR_LISTE),StopSign!,Ok!,1)
	dw_1.SetColumn (DBNAME_ORIGINE_CDE)
	dw_1.SetFocus ()
	Message.ReturnValue = -1
	RETURN
end if	
dw_1.SetItem (1, DBNAME_ORIGINE_CDE_INTITULE,l_str_work.s[2])

   //Type de commande
l_str_work.s[1] = dw_1.GetItemString (1, DBNAME_TYPE_CDE)
l_str_work.s[2] = BLANK
l_str_work = nv_check_value.is_type_cde_valide (l_str_work)
if not l_str_work.b[1] then
	MessageBox (This.title,g_nv_traduction.get_traduction(TYPE_CDE_INEXISTANT) + g_nv_traduction.get_traduction(OBTENIR_LISTE),StopSign!,Ok!,1)
	dw_1.SetColumn (DBNAME_TYPE_CDE)
	dw_1.SetFocus ()
	Message.ReturnValue = -1
	RETURN
end if	
dw_1.SetItem (1, DBNAME_TYPE_CDE_INTITULE, l_str_work.s[2])

//client livré 
l_str_work.s[1] = dw_1.GetItemString (1, DBNAME_CLIENT_LIVRE_CODE)
l_str_work.s[2] = BLANK
l_str_work.s[6] = BLANK
l_str_work.s[10] = i_str_pass.s[1]
l_str_work.s[20] = fw_determine_recherche_partenaire()
l_str_work = nv_check_value.is_client_livre_valide (l_str_work)
if not l_str_work.b[1] then
	if MessageBox (This.title,g_nv_traduction.get_traduction(CLIENT_LIVRE_CDE_INEXISTANT) + g_nv_traduction.get_traduction(OBTENIR_LISTE),Question!,YesNo! ,1) = 1 then
		dw_1.SetColumn (DBNAME_CLIENT_LIVRE_CODE)
		dw_1.SetFocus ()
		Message.ReturnValue = -1
		RETURN
	end if
	dw_1.SetItem (1, DBNAME_CLIENT_LIVRE_ABREGE_NOM, BLANK)	
else
	dw_1.SetItem (1, DBNAME_CLIENT_LIVRE_ABREGE_NOM, l_str_work.s[2])
end if	

	// Grossiste
IF trim(dw_1.GetItemString(1,DBNAME_GROSSISTE)) <> DONNEE_VIDE  and not isNull(dw_1.GetItemString(1,DBNAME_GROSSISTE)) THEN
	l_str_work.s[1] = dw_1.GetItemString (1, DBNAME_GROSSISTE)
	l_str_work.s[2] = BLANK
	l_str_work = nv_check_value.is_grossiste_valide (l_str_work)
	if not l_str_work.b[1] then	
		MessageBox (This.title,g_nv_traduction.get_traduction(GROSSISTE_INEXISTANT) + g_nv_traduction.get_traduction(OBTENIR_LISTE),StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_GROSSISTE)
		dw_1.SetFocus ()
		Message.ReturnValue = -1
		RETURN
	end if	
	dw_1.SetItem (1, DBNAME_GROSSISTE_ABREGE_NOM, l_str_work.s[2])
end if
// DATE DE COMMANDE
d_date_cde = Date (dw_1.GetItemDateTime(1,DBNAME_DATE_CDE))

// DATE DE LIVRAISON SAISIE
d_date_livraison = date (dw_1.GetItemDateTime(1,DBNAME_DATE_LIVRAISON))
d_saisie_cde = date (dw_1.GetItemDateTime(1,DBNAME_DATE_SAISIE_CDE))

// controle de validité des dates.
if not nv_check_value.is_date_cde_valide(string (d_date_cde)) then
	//li_reponse = messagebox (this.title,g_nv_traduction.get_traduction(DATE_CDE_ERRONEE),Information!,Ok!,1)
	dw_1.SetColumn (DBNAME_DATE_CDE)
	
	li_reponse = messagebox (this.title,g_nv_traduction.get_traduction(DATE_CDE_ERRONEE)+ " ~r~n ~r~n"  + &
								                   g_nv_traduction.get_traduction(DATE_CDE_ERRONEE_2) + " ~r~n ~r~n"  + &
												 g_nv_traduction.get_traduction(DATE_CDE_ERRONEE_3) + " ~r~n ~r~n"  + &
								                    g_nv_traduction.get_traduction(DATE_CDE_ERRONEE_4), &
									StopSign!,YesNo!)		

	CHOOSE CASE li_reponse
			// ===> On reste sur le fenetre pour modification
		CASE 1
			 Message.ReturnValue = -1
		CASE 2
			// ===> On garde la saisie de la date			 
	end choose
end if

IF not IsNull (String(d_date_livraison)) THEN
	if not nv_check_value.is_date_valide(string (d_date_livraison)) then
		messagebox (this.title,g_nv_traduction.get_traduction(DATE_LIVRAISON_ERRONEE3),StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_DATE_LIVRAISON)
		Message.ReturnValue = -1
	// La date de livraison saisie doit être > à la date de saisie de commande
     ElseIF d_date_livraison < d_saisie_cde THEN
		messagebox (this.title,g_nv_traduction.get_traduction(DATE_LIVRAISON_ERRONEE),StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_DATE_LIVRAISON)
		Message.ReturnValue = -1
		RETURN
// La date de livraison saisie doit être > ou = à la date de commande		
	ELSEif d_date_livraison < d_date_cde THEN
		messagebox (this.title,g_nv_traduction.get_traduction(DATE_LIVRAISON_ERRONEE2),StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_DATE_LIVRAISON)
		Message.ReturnValue = -1
		RETURN
	elseif not  nv_check_value.is_date_liv_valide(string (d_date_livraison)) then
		dw_1.SetColumn (DBNAME_DATE_LIVRAISON)
		Message.ReturnValue = -1
		RETURN
	END IF
END IF

dw_1.setItem(1,DBNAME_BLOCAGE_SAP,CODE_PAS_DE_BLOCAGE)

IF trim(dw_1.GetItemString(1,DBNAME_CODE_BLOCAGE_SAP)) <> DONNEE_VIDE and & 
	not isNull(trim(dw_1.GetItemString(1,DBNAME_CODE_BLOCAGE_SAP))) THEN
	dw_1.setItem(1,DBNAME_BLOCAGE_SAP, CODE_BLOCAGE)
end if

end event

event ue_ok;/* <DESC>
    Effectue la validation de la saisie des données
   Si la validation est correcte et après mise à jour ,si visiteur est une assistante affichage de la fenêtre complémentaire
	de saisie de l'entête de commande sinon retour soit à la liste des commandes ou sinon à la saisie des lignes
   </DESC> */
	
// OVERRIDE ANCESTOR SCRIPT
setpointer(Hourglass!)
// SAUVEGARDE DES MODIFICATIONS
This.TriggerEvent ("ue_save")

// OUVERTURE DE LA FENETRE SUIVANTE (SELON L'UTILISATEUR)
IF not i_b_update_status THEN
	return
end if 

i_nv_commande_object.fu_validation_cde_par_entete()
i_str_pass.po[2] = i_nv_commande_object
i_str_pass.s[2] = i_nv_commande_object.fu_get_numero_cde()

if g_nv_come9par.is_relation_clientele() or g_nv_come9par.is_filiale() then
	g_w_frame.fw_open_sheet (FENETRE_ENTETE_CDE_RC, 0, 1, i_str_pass)
	close(this)
	return
end if

if is_fenetre_origine = BLANK then
	g_s_fenetre_destination = FENETRE_LIGNE_CDE
else	
	g_s_fenetre_destination = is_fenetre_origine
end if
postEvent("ue_workflow")

setpointer(Arrow!)
close(this)
end event

event ue_init;call super::ue_init;/* <DESC>
      Permet d'initialiser l'affichage de la fenêtre
      - Controle de l'idendité du client. Si inexistant affichage de la fenêtre de sélection du client
	 - Création de l'object commande à partir du n° de commande . Si aucun n° de commande renseigné
	 une commande sera créée par l'object Commande.
      - Initialisation des informations du client livré de la commande	 
	 - Initialisation de la date de livraison à null si egale a la date de la commande
	 - Si la dette du client donneur d'ordre est superieure a zero, affichage d'une message d'information.
   </DESC> */

// DECLARATION DES VARIABLES LOCALES
Long			l_retrieve
Str_pass		str_work
DateTime		dt_null
nv_Datastore   lds_relance

lds_relance = CREATE nv_Datastore
lds_relance.Dataobject = "d_relance"
lds_relance.setTransObject (sqlca)

// SELECTION DU CLIENT 
i_str_pass.b[21] = true
i_str_pass = g_nv_workflow_manager.fu_ident_client(true, i_str_pass)
if  i_str_pass.s_action = ACTION_CANCEL then
	close(this)
	RETURN
end if
g_nv_trace.fu_write_trace( this.classname( ), "ue_ini",i_str_pass.s[01], i_str_pass.s[02], this.classname( ) , g_s_fenetre_destination)

dw_mas.SetRedraw (False)
dw_1.SetRedraw (False)

IF dw_mas.Retrieve (i_str_pass.s[1],g_nv_come9par.get_code_langue()) = -1 THEN
 	f_dmc_error (this.title +  BLANK + DB_ERROR_MESSAGE)
END IF

i_nv_commande_object = CREATE nv_commande_object
i_nv_commande_object.fu_set_numero_cde(i_str_pass.s[2])

if dw_1.Retrieve (i_nv_commande_object.fu_controle_numero_cde(i_str_pass.po[1]),g_nv_come9par.get_code_langue())  = -1 then
		f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
end if

// Alimente le nom et la ville du client livré
if trim(dw_1.getItemString(1, DBNAME_CLIENT_LIVRE_CODE)) <> DONNEE_VIDE and &
   not isNull(dw_1.getItemString(1, DBNAME_CLIENT_LIVRE_CODE)) then
	str_work.s[1] = dw_1.GetItemString (1, DBNAME_CLIENT_LIVRE_CODE)
	str_work.s[2] = BLANK
	str_work.s[6] = BLANK
	str_work.s[10] = i_str_pass.s[1]
	str_work.s[20] = fw_determine_recherche_partenaire()
	nv_control_manager nv_check_value 
	nv_check_value = CREATE nv_control_manager	
	str_work = nv_check_value.is_client_livre_valide (str_work)
	if str_work.b[1] then
		dw_1.setItem(1, DBNAME_CLIENT_LIVRE_ABREGE_NOM, str_work.s[2])
		dw_1.setItem(1, DBNAME_CLIENT_LIVRE_ABREGE_VILLE, str_work.s[3])		
	end if
	destroy nv_check_value
end if

nv_client_object lnv_client
lnv_client = i_str_pass.po[1]

dw_mas.setItem(1,"alerte",lnv_client.fu_get_alerte( ))
dw_mas.SetRedraw (True)
dw_1.SetRedraw (True)

// CONTROLE DU MONTANT DE LA DETTE POUR LE CLIENT
IF dw_mas.GetItemNumber(dw_mas.GetRow(),DBNAME_MONTANT_DETTE_ECHUE) > 0 THEN
	l_retrieve = lds_relance.retrieve(lnv_client.fu_get_code_client( ))
	if l_retrieve > 0 then
			messagebox(This.title,g_nv_traduction.get_traduction(DETTE_POSITIVE_CLIENT)	+ " ~r~n ~r~n" + &
						  g_nv_traduction.get_traduction('DERRELANCE_T') + " ~r~n"  + &
						  "     - " + g_nv_traduction.get_traduction('NIVRELANCE_T') + " " + lds_relance.getitemstring(1,"niveau_relance") +" ~r~n"  + &
						  "     - " +  g_nv_traduction.get_traduction('DATRELANCE_T')+ " " + string(lds_relance.getItemdatetime(1,"date_relance"),"dd/mm/yyyy") ,&
	         StopSign!,Ok!,1)	
	else
	   messagebox(This.title,g_nv_traduction.get_traduction(DETTE_POSITIVE_CLIENT),StopSign!,Ok!,1)
	end if
	beep(10)
END IF

// recherche des intitulés pour le  blocage livraison
if len(trim(dw_1.getItemString(1,DBNAME_CODE_BLOCAGE_SAP))) > 0 then
	dw_1.setitem(1,DBNAME_CODE_BLOCAGE_SAP_INTITULE,g_nv_traduction.get_traduction_code( "COME9017",dw_1.getItemString(1,DBNAME_CODE_BLOCAGE_SAP)))
end if
//if len(trim(dw_1.getItemString(1,DBNAME_UCC))) > 0 then
//	dw_1.setitem(1,DBNAME_UCC_INTITULE,g_nv_traduction.get_traduction_code( "COME9008",dw_1.getItemString(1,DBNAME_UCC)))
//end if
end event

event key;call super::key;/* <DESC>
      Permet de trapper les touches de fonction activées et déclencher l'évènement associé
	à la touche.
	  F2 = Affichage de la liste des codes - utilisée lors de la modification
	  F11 = Validation de la saisie
   </DESC> */

	IF KeyDown(KeyF11!) THEN
		This.PostEvent ("ue_ok")
	END IF

	IF KeyDown (KeyF2!) THEN
		This.PostEvent ("ue_listes")
	END IF
end event

event ue_save;/* <DESC>
      Lance le controle de la saisie des données et si le controle est correcte effectue la
	 mise à jour de l'entête de commande
   </DESC> */
// OVERRIDE SCRIPT ANCESTOR
This.TriggerEvent ("ue_presave")

IF message.returnvalue < 0 THEN
	i_b_update_status = FALSE
	dw_1.SetFocus ()
	RETURN
END IF

if g_nv_come9par.is_vendeur() then
	dw_1.setItem(1, DBNAME_CODE_MAJ, CODE_CREATION)
end if

dw_1.update ()
i_b_update_status = TRUE
end event

event open;call super::open;   /* <DESC>
	   Initialisation de la fenetre d'origine de l'ouverture de la fenetre
	 </DESC> */
	is_fenetre_origine = g_nv_workflow_manager.fu_get_fenetre_origine()
end event

on w_entete_cde.create
int iCurrent
call super::create
this.pb_ok=create pb_ok
this.pb_echap=create pb_echap
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_ok
this.Control[iCurrent+2]=this.pb_echap
end on

on w_entete_cde.destroy
call super::destroy
destroy(this.pb_ok)
destroy(this.pb_echap)
end on

event ue_close;/* <DESC>
      Permet de quitter la fenêtre aprés avoir initialisé la structure de l'object commande
	 et permetre le retour soit sur la liste des commandes  ou soit sur la saisie des lignes
	 de commande
   </DESC> */
i_b_canceled = true
i_str_pass.po[2] = i_nv_commande_object
i_str_pass.s[2] = i_nv_commande_object.fu_get_numero_cde()

if is_fenetre_origine = BLANK then
	g_s_fenetre_destination = FENETRE_LIGNE_CDE
else	
	g_s_fenetre_destination = is_fenetre_origine
end if
triggerEvent("ue_workflow")
Close (this)
end event

event closequery;//overWrite
end event

type uo_statusbar from w_a_mas_det`uo_statusbar within w_entete_cde
end type

type dw_1 from w_a_mas_det`dw_1 within w_entete_cde
string tag = "A_TRADUIRE"
integer x = 55
integer y = 972
integer width = 2766
integer height = 816
integer taborder = 10
string dataobject = "d_entete_cde"
borderstyle borderstyle = stylelowered!
end type

event dw_1::we_dwnprocessenter;call super::we_dwnprocessenter;/* Permet en utilisant la touche Entrée de passer d'une zone de saisie à l'autre en
fonction de l'ordre de tabulation 
*/
	Send(Handle(This),256,9,Long(0,0))
	RETURN 1
end event

event dw_1::we_dwnkey;call super::we_dwnkey;/* Appel de la fonction de controle des touches de fonction autorisées dans l'application
et de déclencher l'évènement KEY de la fenêtre qui contient le code correspond à la
touche.
*/
	f_key(Parent)


end event

type dw_mas from w_a_mas_det`dw_mas within w_entete_cde
string tag = "A_TRADUIRE"
integer x = 297
integer y = 28
integer width = 2057
integer height = 932
integer taborder = 0
string dataobject = "d_entete_client_cde"
borderstyle borderstyle = stylelowered!
end type

on dw_mas::we_nchittest;
// Override script ancestor
end on

type pb_ok from u_pba_ok within w_entete_cde
integer x = 270
integer y = 1820
integer width = 334
integer taborder = 0
string text = "Valid.  F11"
boolean default = false
string picturename = "c:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_echap from u_pba_echap within w_entete_cde
integer x = 2075
integer y = 1820
integer taborder = 0
string picturename = "c:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

