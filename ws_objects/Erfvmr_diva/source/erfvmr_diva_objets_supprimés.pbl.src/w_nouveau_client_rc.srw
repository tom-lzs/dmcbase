$PBExportHeader$w_nouveau_client_rc.srw
$PBExportComments$Permet la modification des données complémentaires du client prospect par les assistantes commerciales uniquement
forward
global type w_nouveau_client_rc from w_a_udis
end type
type pb_ok from u_pba_ok within w_nouveau_client_rc
end type
type pb_echap from u_pba_echap within w_nouveau_client_rc
end type
type dw_client_livre from u_dw_udim within w_nouveau_client_rc
end type
type uo_message from uo_mise_a_jour_messages within w_nouveau_client_rc
end type
end forward

global type w_nouveau_client_rc from w_a_udis
string tag = "CLIENT_PROSPECT"
integer x = 0
integer y = 0
integer width = 3470
integer height = 1720
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
long backcolor = 12632256
event ue_listes pbm_custom40
pb_ok pb_ok
pb_echap pb_echap
dw_client_livre dw_client_livre
uo_message uo_message
end type
global w_nouveau_client_rc w_nouveau_client_rc

type variables
// Nom de la DataWindow ayant le focus
u_dwa		i_dw_focus
end variables

forward prototypes
public subroutine fw_init_param_texte ()
end prototypes

event ue_listes;/* <DESC>
    Affichage des listes correspondantes au champ en cours de saisie et
	 ceci lors de l'activation de la touche F2. 
</DESC> */ 
// DECLARATION DES VARIABLES LOCALES
String		s_colonne
Str_pass		str_work

s_colonne = i_dw_focus.GetColumnName()
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
i_dw_focus.SetItem (1, s_colonne, str_work.s[1])

if s_colonne = DBNAME_CLIENT_LIVRE_CODE then
	i_dw_focus.SetItem (1, DBNAME_CLIENT_LIVRE_ABREGE_NOM, str_work.s[2])	
	i_dw_focus.SetItem (1, DBNAME_CLIENT_LIVRE_ABREGE_VILLE, str_work.s[3])		
end if


end event

public subroutine fw_init_param_texte ();/* <DESC>
      Initialise les paramètres de l'objet de gestion des textes en initialisant une structure qui contiendra pour chaque texte
	 le nom de la table , le nom du champ client correspondant et en passant le code langue du clent.
   </DESC< */
str_pass l_str_work
l_str_work.s[1] = i_str_pass.s[1]
l_str_work.s[2] = DBNAME_CLIENT_LIVRE_CODE
l_str_work.s[3] = "come9081"
l_str_work.s[4] = dw_1.getItemString (1, DBNAME_CODE_LANGUE)
		
l_str_work.s[5] = DBNAME_CLIENT_FACTURE_CODE
l_str_work.s[6] = "come9084"
l_str_work.s[7] =  dw_1.getItemString (1, DBNAME_CODE_LANGUE)

l_str_work.s[8] = DBNAME_CLIENT_LIVRE_CODE
l_str_work.s[9] = "come9082"
l_str_work.s[10] =  dw_1.getItemString (1, DBNAME_CODE_LANGUE)

l_str_work.s[11] = DBNAME_CLIENT_CODE
l_str_work.s[12] = "come9085"
l_str_work.s[13] =  dw_1.getItemString (1, DBNAME_CODE_LANGUE)

l_str_work.s[14] = DBNAME_CLIENT_LIVRE_CODE
l_str_work.s[15] = "come9083"
l_str_work.s[16] =  dw_1.getItemString (1, DBNAME_CODE_LANGUE)

l_str_work.s[17] = "d_client_entete_message"

l_str_work.s[18] = DBNAME_CLIENT_CODE
l_str_work.s[19] = "come9080"
l_str_work.s[20] =  dw_1.getItemString (1, DBNAME_CODE_LANGUE)

uo_message.fu_init_param(l_str_work)
end subroutine

event ue_presave;call super::ue_presave;/* <DESC>
    Permet de valider la saisie effectuée. 
    1- Controle des données du client: Toutes les données sont obligatoires et les différents codes doivent être existant.
    2- Si existence de clients livré, controle de leur existence dans le fichier client.
   </DESC> */
	String 		s_intitule = BLANK
	Str_pass		l_str_work

	dw_1.AcceptText ()

   IF Not dw_1.fu_check_required () THEN
		dw_1.SetFocus ()
		Message.ReturnValue = -1
		RETURN
	END IF
	
	if  isnull(dw_1.getItemString(1,DBNAME_CLIENT_ABREGE_NOM)) or len(trim(dw_1.GetItemString (1, DBNAME_CLIENT_ABREGE_NOM))) = 0 then
		MessageBox (This.title,g_nv_traduction.get_traduction(NOM_CLIENT_OBLIGATOIRE),StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_CLIENT_ABREGE_NOM)
		dw_1.SetFocus ()
		Message.ReturnValue = -1
		RETURN
	end if
	
	if  isnull(dw_1.getItemString(1,DBNAME_CLIENT_ABREGE_VILLE)) or len(trim(dw_1.GetItemString (1, DBNAME_CLIENT_ABREGE_VILLE))) = 0 then
		MessageBox (This.title,g_nv_traduction.get_traduction(VILLE_OBLIGATOIRE),StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_CLIENT_ABREGE_VILLE)
		dw_1.SetFocus ()
		Message.ReturnValue = -1
		RETURN
	end if	
// =======================================
// CONTRÔLE D'EXISTENCE DES CODES
// =======================================
	nv_control_manager nv_check_value 
	nv_check_value = CREATE nv_control_manager

// Controle du Niveau responsabilité
   l_str_work.s[1] = dw_1.GetItemString (1, DBNAME_CODE_NIVEAU_RESP)
	l_str_work.s[2] = BLANK
	l_str_work = nv_check_value.is_niveau_responsabilite_valide (l_str_work) 
	if not l_str_work.b[1] then
		MessageBox (This.title,g_nv_traduction.get_traduction(NIVEAU_RESP_INEXISTANTE) + g_nv_traduction.get_traduction(OBTENIR_LISTE),StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_CODE_NIVEAU_RESP)
		dw_1.SetFocus ()
		Message.ReturnValue = -1
		RETURN
	end if
// Controle de la correspondanciere
   l_str_work.s[1] = dw_1.GetItemString (1, DBNAME_CODE_CORREPONDANTE)
	l_str_work.s[2] = BLANK
	l_str_work = nv_check_value.is_correspondanciere_valide (l_str_work)
	if not l_str_work.b[1] then
		MessageBox (This.title,g_nv_traduction.get_traduction(CORRESPOND_INEXISTANTE) +g_nv_traduction.get_traduction(OBTENIR_LISTE),StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_CODE_CORREPONDANTE)
		dw_1.SetFocus ()
		Message.ReturnValue = -1
		RETURN
	end if	
// Controle du responsable de secteur
   l_str_work.s[1] = dw_1.GetItemString (1, DBNAME_CODE_RESP_SECTEUR)
	l_str_work.s[2] = BLANK
	l_str_work = nv_check_value.is_resp_secteur_valide (l_str_work)
	if not l_str_work.b[1] then
		MessageBox (This.title,g_nv_traduction.get_traduction(RESP_SECTEUR_INEXISTANT) + g_nv_traduction.get_traduction(OBTENIR_LISTE),StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_CODE_RESP_SECTEUR)
		dw_1.SetFocus ()
		Message.ReturnValue = -1
		RETURN
	end if		
// Controle du mode de paiement
   l_str_work.s[1] = dw_1.GetItemString (1, DBNAME_MODE_PAIEMENT)
	l_str_work.s[2] = BLANK
	l_str_work = nv_check_value.is_mode_paiement_valide (l_str_work)
	if not l_str_work.b[1] then
		MessageBox (This.title,g_nv_traduction.get_traduction(MODE_PAIEMENT_INEXISTANT) + g_nv_traduction.get_traduction(OBTENIR_LISTE),StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_MODE_PAIEMENT)
		dw_1.SetFocus ()
		Message.ReturnValue = -1
		RETURN
	end if		
// Controle du code echeance
   l_str_work.s[1] = dw_1.GetItemString (1, DBNAME_CODE_ECHEANCE)
	l_str_work.s[2] = BLANK
	l_str_work = nv_check_value.is_echeance_valide (l_str_work) 
	if not l_str_work.b[1] then
		MessageBox (This.title,g_nv_traduction.get_traduction(ECHEANCE_INEXISTANTE) + g_nv_traduction.get_traduction(OBTENIR_LISTE),StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_CODE_ECHEANCE)
		dw_1.SetFocus ()
		Message.ReturnValue = -1
		RETURN
	end if		
// Contrôle du numéro de client payeur
   l_str_work.s[1] = dw_1.GetItemString (1, DBNAME_CLIENT_PAYEUR_CODE)
	l_str_work.s[2] = BLANK
	l_str_work = nv_check_value.is_client_valide (l_str_work)
	if not l_str_work.b[1] then
		MessageBox (This.title,g_nv_traduction.get_traduction(CLIENT_PAYEUR_INEXISTANT) + g_nv_traduction.get_traduction(OBTENIR_LISTE),StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_CLIENT_PAYEUR_CODE)
		dw_1.SetFocus ()
		Message.ReturnValue = -1
		RETURN
	end if			
// Contrôle du numéro de client facturé
   l_str_work.s[1] = dw_1.GetItemString (1, DBNAME_CLIENT_FACTURE_CODE)
	l_str_work.s[2] = BLANK
	l_str_work = nv_check_value.is_client_valide (l_str_work)
	if not l_str_work.b[1] then
		MessageBox (This.title,g_nv_traduction.get_traduction(CLIENT_FACTURE_INEXISTANT) + g_nv_traduction.get_traduction(OBTENIR_LISTE),StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_CLIENT_FACTURE_CODE)
		dw_1.SetFocus ()
		Message.ReturnValue = -1
		RETURN
	end if				
// Controle du code langue
   l_str_work.s[1] = dw_1.GetItemString (1, DBNAME_CODE_LANGUE)
	l_str_work.s[2] = BLANK
	l_str_work = nv_check_value.is_code_langue_valide (l_str_work)
	if not l_str_work.b[1] then
		MessageBox (This.title,g_nv_traduction.get_traduction(CODE_LANGUE_INEXISTANT) + g_nv_traduction.get_traduction(OBTENIR_LISTE),StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_CODE_LANGUE)
		dw_1.SetFocus ()
		Message.ReturnValue = -1
		RETURN
	end if	
// Controle du mode d'expedition
   l_str_work.s[1] = dw_1.GetItemString (1, DBNAME_CODE_MODE_EXP)
	l_str_work.s[2] = BLANK
	l_str_work = nv_check_value.is_mode_expedition_valide (l_str_work)
	if not l_str_work.b[1] then
		MessageBox (This.title,g_nv_traduction.get_traduction(MODE_EXPEDITION_INEXISTANT) + g_nv_traduction.get_traduction(OBTENIR_LISTE),StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_CODE_MODE_EXP)
		dw_1.SetFocus ()
		Message.ReturnValue = -1
		RETURN
	end if	
// Controle de l'incoterm
   l_str_work.s[1] = dw_1.GetItemString (1, DBNAME_CODE_INCOTERM)
	l_str_work.s[2] = BLANK
	l_str_work = nv_check_value.is_incoterm_valide (l_str_work)
	if not l_str_work.b[1] then
		MessageBox (This.title,g_nv_traduction.get_traduction(INCOTERM_INEXISTANT) + g_nv_traduction.get_traduction(OBTENIR_LISTE),StopSign!,Ok!,1)
		dw_1.SetColumn (DBNAME_CODE_INCOTERM)
		dw_1.SetFocus ()
		Message.ReturnValue = -1
		RETURN
	end if	

// Controle des clients livrés
dw_client_livre.AcceptText ()
integer li_indice
for li_indice= 1 to dw_client_livre.RowCount()
   l_str_work.s[1] = dw_client_livre.GetItemString (li_indice, DBNAME_CLIENT_LIVRE_CODE)
	
	if l_str_work.s[1] = DONNEE_VIDE or isNull(l_str_work.s[1]) tHEN
		continue
	end if
	
	l_str_work.s[2] = BLANK
	l_str_work.s[6] = OPTION_CLIENT		
	l_str_work = nv_check_value.is_client_livre_valide (l_str_work)
	if not l_str_work.b[1] then
		MessageBox (This.title,g_nv_traduction.get_traduction(CLIENT_LIVRE_INEXISTANT) + g_nv_traduction.get_traduction(OBTENIR_LISTE),StopSign!,Ok!,1)
		dw_client_livre.SetColumn (DBNAME_CLIENT_LIVRE_CODE)
		dw_client_livre.SetFocus ()
		dw_client_livre.SetRow(li_indice)
		Message.ReturnValue = -1
		RETURN
	end if
	dw_client_livre.setItem(li_indice, DBNAME_CLIENT_CODE, i_str_pass.s[1])	
	dw_client_livre.setItem(li_indice, DBNAME_CLIENT_LIVRE_ABREGE_NOM, l_str_work.s[2])
	dw_client_livre.setItem(li_indice, DBNAME_CLIENT_LIVRE_ABREGE_VILLE, l_str_work.s[3])	
	dw_client_livre.SetItem (li_indice, DBNAME_DATE_CREATION, i_tr_sql.fnv_get_datetime ())
	dw_client_livre.SetItem (li_indice, DBNAME_CODE_MAJ, CODE_CREATION)	
next


end event

event ue_init;call super::ue_init;/* <DESC>
   Permet d'initialiser l'affichage de la fenêtre en recherchant les données du client et des clients livrés associés
  et en verifiant l'existence des différents textes pour affichage de la première ligne sur chacune des lignes de la fenêtre.
   </DESC> */
long l_retrieve
// RETRIEVE DE LA DTW DW_1
this.title = this.title + BLANK + i_str_pass.s[1]

if dw_1.Retrieve (i_str_pass.s[1]) = -1 then
	f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)		
end if


dw_client_livre.SetTransObject (i_tr_sql)
l_retrieve = dw_client_livre.retrieve(i_str_pass.s[1]) 
if l_retrieve = -1 then
	f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)	
end if
if l_retrieve = 0 then
	dw_client_livre.insertRow(0)
end if

fw_init_param_texte()
end event

event ue_ok;/* <DESC> 
      Permet la validation de la saisie er retour à la fenêtre d'origine.
   </DESC> */
// OVERRIDE SCRIPT ANCESTOR

// SI CONSULT FERME LA FENÊTRE
	IF i_str_pass.b[1] = FALSE THEN
		i_str_pass.s_action = ACTION_OK
		CloseWithReturn (This, i_str_pass)
	END IF


// SAUVEGARDE DES DONNEES
	This.TriggerEvent ("ue_save")

	IF dw_1.fu_updated () THEN
		i_str_pass.s_action = ACTION_OK
		Message.fnv_set_str_pass(i_str_pass)
		Close (This)
	END IF
end event

event open;call super::open;/* <DESC> 
     Permet de positionner la fenêtre dans le fenêtre principale de l'application  (MDI)
   </DESC> */
	This.X = 0
	This.Y = 130
end event

on w_nouveau_client_rc.create
int iCurrent
call super::create
this.pb_ok=create pb_ok
this.pb_echap=create pb_echap
this.dw_client_livre=create dw_client_livre
this.uo_message=create uo_message
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_ok
this.Control[iCurrent+2]=this.pb_echap
this.Control[iCurrent+3]=this.dw_client_livre
this.Control[iCurrent+4]=this.uo_message
end on

on w_nouveau_client_rc.destroy
call super::destroy
destroy(this.pb_ok)
destroy(this.pb_echap)
destroy(this.dw_client_livre)
destroy(this.uo_message)
end on

event ue_cancel;/* <DESC>
    Permet de quitter l'application sans effectuer de mise à jour
   </DESC> */
// OVERRIDE SCRIPT ANCESTOR

	i_b_canceled = TRUE
	i_str_pass.s_action = ACTION_CANCEL
	
	Message.fnv_set_str_pass(i_str_pass)
	Close (This)

end event

event key;call super::key;/* <DESC>
      Permet de trapper les touches de fonction activées et déclencher l'évènement associé
	à la touche. Suels les touches F11 et F2 sont traitées.
   </DESC> */
	IF KeyDown (KeyF11!) THEN
		This.PostEvent ("ue_ok")
	END IF

	IF KeyDown (KeyF2!) THEN
		This.PostEvent ("ue_listes")
	END IF
end event

event ue_save;/* <DESC> 
     Permet la sauvegarde des données après avoir effectuer le contrôle de la saisie.
	Réinitialisation de l'affichage des lignes de texte. Creation de l'object nv_client  et si existence d'une commande en cours 
	rafraichissement des données client de l'objet nv_commande
   </DESC> */
	
this.TriggerEvent ("ue_presave")

IF message.returnvalue < 0 THEN
	i_b_update_status = FALSE
	RETURN
END IF


// Call Datawindow function to Update and Commit if successful

i_b_update_status = dw_1.fu_update ()
if not i_b_update_status then
	return
end if

dw_client_livre.update()

fw_init_param_texte()

nv_client_object lu_client
lu_client = CREATE nv_client_object
lu_client.fu_retrieve_client(i_str_pass.s[1])
i_str_pass.po[1] = lu_client		
uo_message.fu_update_flag(true)

if (upperBound(i_str_pass.po)) > 0 then
	if not isNull(i_str_pass.po[2]) then
		nv_commande_object l_commande		
		l_commande = i_str_pass.po[2]
		l_commande.fu_refresh_client_info(lu_client)
	end if
end if




end event

type dw_1 from w_a_udis`dw_1 within w_nouveau_client_rc
string tag = "A_TRADUIRE"
integer x = 142
integer y = 16
integer width = 2798
integer height = 696
integer taborder = 10
string dataobject = "d_nouveau_client_suite"
end type

event dw_1::we_dwnprocessenter;call super::we_dwnprocessenter;
// La touche ENTER simule la touche TAB
	Send (Handle(This) , 256, 9, Long(0,0))
//	dw_1.SetActionCode (1)
	Return 1
end event

event dw_1::getfocus;call super::getfocus;
// Indique que cette datawindow a le focus
	i_dw_focus = This
end event

event dw_1::we_dwnkey;call super::we_dwnkey;
// RENVOIE A L'EVENEMENT KEY DE LA FENÊTRE 
//	f_activation_key ()
	f_key(Parent)
end event

type pb_ok from u_pba_ok within w_nouveau_client_rc
integer x = 485
integer y = 1428
integer width = 338
integer height = 168
integer taborder = 0
string facename = "Arial"
string text = "Valid.  F11"
boolean default = false
end type

type pb_echap from u_pba_echap within w_nouveau_client_rc
integer x = 1723
integer y = 1420
integer height = 168
integer taborder = 0
string facename = "Arial"
end type

type dw_client_livre from u_dw_udim within w_nouveau_client_rc
string tag = "A_TRADUIRE"
integer x = 46
integer y = 768
integer width = 891
integer height = 484
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_client_prospect_client_livre"
end type

event we_dwnprocessenter;call super::we_dwnprocessenter;if trim(this.getItemString(getRow(), DBNAME_CLIENT_LIVRE_CODE)) = DONNEE_VIDE  or & 
   isNull(this.getItemString(getRow(), DBNAME_CLIENT_LIVRE_CODE)) then
	return
end if

this.insertRow(0)
end event

event getfocus;call super::getfocus;i_dw_focus = this
end event

event we_dwnkey;call super::we_dwnkey;IF KeyDown (KeyF2!) THEN
		parent.PostEvent ("ue_listes")
END IF
end event

type uo_message from uo_mise_a_jour_messages within w_nouveau_client_rc
integer x = 1001
integer y = 768
integer height = 612
integer taborder = 21
boolean bringtotop = true
end type

on uo_message.destroy
call uo_mise_a_jour_messages::destroy
end on

