$PBExportHeader$w_liste_cde.srw
$PBExportComments$Affiche la liste des commandes en fonction de critères de sélection et permet d'accéder aux commandes des autres visiteurs
forward
global type w_liste_cde from w_a_liste
end type
type pb_changer from u_pba_chge_sel within w_liste_cde
end type
type pb_modif_client from u_pba_new_client within w_liste_cde
end type
type pb_message from u_pba_echap within w_liste_cde
end type
type pb_suppression from u_pba_supprim within w_liste_cde
end type
type pb_lig_indirecte from u_pba within w_liste_cde
end type
type pb_impression from u_pba within w_liste_cde
end type
type rb_non_valide from u_rba within w_liste_cde
end type
type rb_val_ntrf from u_rba within w_liste_cde
end type
type rb_transferee from u_rba within w_liste_cde
end type
type rb_toutes from u_rba within w_liste_cde
end type
type rb_bloquee from u_rba within w_liste_cde
end type
type gb_visu_cde from groupbox within w_liste_cde
end type
end forward

global type w_liste_cde from w_a_liste
string tag = "DERNIERES_CDES"
integer x = 0
integer y = 0
integer width = 4133
integer height = 1692
boolean titlebar = false
boolean controlmenu = false
boolean resizable = false
windowtype windowtype = child!
windowstate windowstate = maximized!
boolean ib_statusbar_visible = true
event ue_changer pbm_custom42
event ue_message pbm_custom43
event ue_workflow ( )
event ue_lignes_indirectes ( )
event ue_modif_client ( )
pb_changer pb_changer
pb_modif_client pb_modif_client
pb_message pb_message
pb_suppression pb_suppression
pb_lig_indirecte pb_lig_indirecte
pb_impression pb_impression
rb_non_valide rb_non_valide
rb_val_ntrf rb_val_ntrf
rb_transferee rb_transferee
rb_toutes rb_toutes
rb_bloquee rb_bloquee
gb_visu_cde gb_visu_cde
end type
global w_liste_cde w_liste_cde

type variables
// Structure de travail
Str_pass		i_str_work

Boolean		i_b_ouverture = TRUE
Long			i_l_row
String         is_filtre

n_tooltip_mgr itooltip
end variables

forward prototypes
public function integer fw_retrieve_data (string as_message)
end prototypes

event ue_changer;/* <DESC>
    Permet de changer la sélection des commandes en affchant la fenêtre de sélection
    Après slection des critères, extraction des commandes. Si aucunes commande trouvée
	réaffichage de la liste de sélection.
   </DESC> */
Long			l_retrieve
integer	    li_return

i_b_ouverture = TRUE
OpenWithParm (w_sel_cde, i_str_work)

i_str_work = Message.fnv_get_str_pass()
Message.fnv_clear_str_pass()

CHOOSE CASE i_str_work.s_action
	CASE ACTION_OK
		li_return = fw_retrieve_data(AUCUNE_COMMANDE)
	CASE ACTION_CANCEL
		IF dw_1.RowCount () = 0 THEN
			This.TriggerEvent ("ue_cancel")
		ELSE
			dw_1.SetFocus ()
			i_b_ouverture = FALSE
		END IF
	END CHOOSE
	
end event

event ue_message;/* <DESC>
    Permet d'aller en saisie d'un message sur la commande sans fermeture de la liste.
    en fin de saisie des message, réactualisation de la liste.
   </DESC> */
	
if not fw_controle_cde("ue_message") then
	return
end if

fw_complete_structure()

g_nv_workflow_manager.fu_set_fenetre_origine (this.classname())
OpenWithParm (w_message_cde_response, i_str_pass)

fw_retrieve_data(AUCUNE_COMMANDE)
dw_1.SetFocus()
dw_1.scrollToRow(il_row_encours)


end event

event ue_workflow();/* <DESC>
    Cet évènement est appelé lors de la sélection d'une option dans le menu alors que cette
	 fenêtre est la fenêtre active et va lancer le workflow manager pour effetuer l'enchainement.
</DESC> */
fw_complete_structure()
g_nv_workflow_manager.fu_check_workflow(FENETRE_LISTE_DERNIERE_CDE, i_str_pass)

end event

event ue_lignes_indirectes();/* <DESC>
   Permet de lever le blocage pour les commandes étant bloquées pour existence de lignes indirectes.
  On controle que la commande ne soit pas validée et transférée, qu'elle contient des lignes de commandes indirectes,
  qu'il n'existe pas d'autre blocage .
  Si tout est ok
  	un bordereau est imprimé qui contiendra uniquement les lignes de commandes indirectes
	une confirmation de levé du blocage  est demandé 
	Si le verrou doit être levé, Validation complète de la commande. Si aucune anomalie n'a été detectée,
	  la commande est validée, Mise à jour de la date de création,du visiteur de mise à jour 
   </DESC> */

// DECLARATION DES VARIABLES LOCALES
Long		l_retrieve
String	s_numaecde
String	s_numaeclf
Datastore ds_print
Long l_row

l_row = dw_1.GetRow ()
if not fw_controle_cde("ue_lignes_indirectes") then
	return
end if

if not inv_commande.fu_is_commande_avec_ligne_indirecte() then
	messageBox(This.Title, g_nv_traduction.get_traduction(AUCUNE_LIGNE_INDIRECTE), information!, ok!)
	return
end if

if inv_commande.fu_is_commande_bloquee_hors_indirecte() then
	messageBox(This.Title,g_nv_traduction.get_traduction(LEVER_BLOCAGE_IMPOSSIBLE), information!, ok!)
	return
end if

// IMPRESSION DES LIGNES INDIRECTES
ds_print = CREATE Datastore
ds_print.Dataobject = "d_report_lignes_indirectes"
ds_print.setTransObject (sqlca)

s_numaecde = dw_1.GetItemString (dw_1.GetRow (), DBNAME_NUM_CDE)
s_numaeclf = dw_1.GetItemString (dw_1.GetRow (), DBNAME_CLIENT_CODE)
l_retrieve = ds_print.Retrieve (s_numaecde, s_numaeclf, g_nv_come9par.get_code_adresse(),g_nv_come9par.get_code_langue( )	)
CHOOSE CASE l_retrieve
	CASE -1
		f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
	CASE 0
	CASE ELSE
		g_nv_traduction.set_traduction_datastore( ds_print)
		triggerEvent("ue_printsetup")
		ds_print.print () 
END CHOOSE

if inv_commande.fu_is_commande_validee() then
	return
end if

IF not inv_commande.fu_is_entete_cde_validee() THEN
	messagebox (This.title,&
					g_nv_traduction.get_traduction(VALIDATION_ENTETE),&
					Information!,Ok!,1)
	RETURN
END IF

integer li_reponse
li_reponse = messageBox(This.title, g_nv_traduction.get_traduction(LEVER_BLOCAGE_INDIRECT), Information!, YesNo!)
if li_reponse = 2 then
	return
end if

dw_1.SetItem (l_Row, DBNAME_ETAT_CDE,COMMANDE_VALIDEE)
dw_1.SetItem (l_Row, DBNAME_BLOCAGE_LIGNE_CDE,CODE_PAS_DE_BLOCAGE)
dw_1.SetItem (l_Row, DBNAME_DATE_CREATION,i_tr_sql.fnv_get_datetime ())
dw_1.SetItem (l_Row, DBNAME_VISITEUR_MAJ, g_s_visiteur)
dw_1.Update ()


end event

event ue_modif_client();/* <DESC> 
    Permet de changer le client donneur d'ordre en affichant la fenêtre de sélection du client et une fois le client
	 sélectionné, crèation d'un nouvel oject client et appel de la fonction de changement du client sur la commande.
   Si le client sélectionné est un  client prospect, modification du client impossible et réaffichage la fenêtre de sélection 
    d'un client  sinon mise à jour du client donneur d'ordre et réactualisation de la liste des commandes.
  </DESC> */
// -----------------------------------
// DECLARATION DES VARIABLES LOCALES
// -----------------------------------
Str_pass		l_str_work
String		s_code_retour = "   "
Long			l_retrieve
String          ls_code_client, ls_numcde

ls_code_client = dw_1.GetItemString (dw_1.GetRow(), DBNAME_CLIENT_CODE)
ls_numcde = dw_1.GetItemString (dw_1.GetRow(), DBNAME_NUM_CDE)

// SELECTION DU BON CLIENT
Selection_client:
l_str_work.b[1]  = NOUVEAU_CLIENT_IMPOSSIBLE
l_str_work.b[20] = FALSE //PAS_RETOUR_DIRECT_AVEC_INFO_CLIENT
l_str_work.b[21] = AFFICHAGE_TOUS_LES_CLIENT
l_str_work.b[22] = AFFICHAGE_CLIENT_ORDRE_UNIQUEMENT	
l_str_work.b[23] = TRUE

OpenWithParm (w_ident_client, l_str_work)

l_str_work = Message.fnv_get_str_pass()
Message.fnv_clear_str_pass()

if l_str_work.s_action = ACTION_CANCEL then
	return
end if

nv_client_object lu_client
lu_client = CREATE nv_client_object
lu_client = l_str_work.po[1]

// Le client choisi ne doit pas être un prospect
IF lu_client.is_client_prospect() THEN
	messagebox (this.title, g_nv_traduction.get_traduction(CLIENT_PROSPECT_IMPOSSIBLE),Information!,Ok!,1)
		GoTo Selection_client
end if

f_changement_client(lu_client, ls_code_client,ls_numcde)

// -------------------------------
// Modification du client prospect
// -------------------------------
fw_retrieve_data(AUCUNE_COMMANDE)
	
end event

public function integer fw_retrieve_data (string as_message);/* <DESC> 
     Permet d'extraire toutes les commandes correspondantes aux critères code correpondancière, code client et visiteur
	 et d'appliquer le filtre en fonction des autres critères - Nom,ville, pays- et du type de visualisation	
   </DESC> */
integer l_retrieve

l_retrieve = dw_1.Retrieve (i_str_work.s[1], & 
									 i_str_work.s[2], & 
									 i_str_work.s[6])
CHOOSE CASE l_retrieve
	CASE -1
		f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
		return 0
	CASE 0
		messagebox (this.title,  g_nv_traduction.get_traduction(as_message),Information!,Ok!,1)
		return 0
END CHOOSE

String ls_filtre = DONNEE_VIDE
String ls_operateur = DONNEE_VIDE

if i_str_work.s[3] <> DONNEE_VIDE And not IsNull(i_str_work.s[3]) then
	ls_filtre = DBNAME_CLIENT_ABREGE_NOM + " ='" +  i_str_work.s[3] + "'"
	ls_operateur = " AND "
end if
if i_str_work.s[4] <> DONNEE_VIDE And not IsNull(i_str_work.s[4]) then
	ls_filtre = ls_filtre + ls_operateur +  DBNAME_CLIENT_ABREGE_VILLE+ " ='" +  i_str_work.s[4] + "'"
	ls_operateur = " AND "
end if
if i_str_work.s[5] <> DONNEE_VIDE And not IsNull(i_str_work.s[5]) then
	ls_filtre  = ls_filtre + DBNAME_PAYS + " ='" +  i_str_work.s[5] + "'"
end if

if is_filtre <> ""  and not isnull(is_filtre) then
	if ls_filtre <>  "" then
		ls_filtre = ls_filtre + " and "
	end if
	ls_filtre = ls_filtre +  is_filtre
end if

dw_1.SetFilter(ls_filtre)
dw_1.filter()

dw_1.SetFocus()

return 1
end function

event activate;/* <DESC>
     La fenetre reste ouverte même lors de l'ouverture de la saise des lignes de commande, 
	 et permet en retour sur la liste de rafraichir les données de la liste
   </DESC> */
IF not i_b_ouverture THEN
	fw_retrieve_data(AUCUNE_COMMANDE)
	dw_1.scrollToRow(i_l_row)
END IF

end event

event ue_init;/* <DESC>
    Permet d'initialiser l'affichage initiale de la fenêtre et d'afficher la fenêtre de sélection 
	 des commandes.
   </DESC> */
	dw_1.fu_set_selection_mode(1)
	dw_1.fu_set_sort_on_label(True)

	dw_1.Object.DataWindow.HorizontalScrollSplit =750
	  
	itooltip = CREATE n_tooltip_mgr
	
	Choose case g_i_option_liste_derniere_cde
		case 1
		rb_non_valide.checked = true
		rb_non_valide.triggerevent("clicked")
	case 2
		rb_bloquee.checked = true		
		rb_bloquee.triggerevent("clicked")
    case 3
		rb_val_ntrf.checked = true
		rb_val_ntrf.triggerevent("clicked")
	case 4
		rb_transferee.checked = true
		rb_transferee.triggerevent("clicked")
	case 5
		rb_toutes.checked = true
		rb_toutes.triggerevent("clicked")
end choose
			
// Fenêtre de sélection des commandes
	This.TriggerEvent ("ue_changer")
end event

event ue_ok;/* <DESC>
     Permet d'aller en modification des lignes  pour la commande sélectionnée, après avoir
	 controler que la commande n'est pas validée et pas transférée
   </DESC> */
if not fw_controle_cde("ue_ok") then
	return
end if

Destroy itooltip

il_row_encours = dw_1.getRow()
i_b_ouverture = false
g_s_fenetre_destination = FENETRE_LIGNE_CDE
i_str_pass.s[20] = this.classname()
triggerEvent("ue_workflow")


end event

event key;call super::key;/* <DESC>
      Permet de trapper les touches de fonction activées et déclencher l'évènement associé
	à la touche.
	  F11 = validation de la sélection
   </DESC> */

	IF KeyDown (KeyF11!) THEN
		This.TriggerEvent ("ue_ok")
	END IF

end event

on w_liste_cde.create
int iCurrent
call super::create
this.pb_changer=create pb_changer
this.pb_modif_client=create pb_modif_client
this.pb_message=create pb_message
this.pb_suppression=create pb_suppression
this.pb_lig_indirecte=create pb_lig_indirecte
this.pb_impression=create pb_impression
this.rb_non_valide=create rb_non_valide
this.rb_val_ntrf=create rb_val_ntrf
this.rb_transferee=create rb_transferee
this.rb_toutes=create rb_toutes
this.rb_bloquee=create rb_bloquee
this.gb_visu_cde=create gb_visu_cde
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_changer
this.Control[iCurrent+2]=this.pb_modif_client
this.Control[iCurrent+3]=this.pb_message
this.Control[iCurrent+4]=this.pb_suppression
this.Control[iCurrent+5]=this.pb_lig_indirecte
this.Control[iCurrent+6]=this.pb_impression
this.Control[iCurrent+7]=this.rb_non_valide
this.Control[iCurrent+8]=this.rb_val_ntrf
this.Control[iCurrent+9]=this.rb_transferee
this.Control[iCurrent+10]=this.rb_toutes
this.Control[iCurrent+11]=this.rb_bloquee
this.Control[iCurrent+12]=this.gb_visu_cde
end on

on w_liste_cde.destroy
call super::destroy
destroy(this.pb_changer)
destroy(this.pb_modif_client)
destroy(this.pb_message)
destroy(this.pb_suppression)
destroy(this.pb_lig_indirecte)
destroy(this.pb_impression)
destroy(this.rb_non_valide)
destroy(this.rb_val_ntrf)
destroy(this.rb_transferee)
destroy(this.rb_toutes)
destroy(this.rb_bloquee)
destroy(this.gb_visu_cde)
end on

event ue_delete;/* <DESC>
   Permet de supprimer une commande. Pour cela on controle que la commande ne soit pas validée, ni transférée dans SAP.
   La suppression n'est effective qu'après confirmation.
   Une commande validée ou transférée ne peut être supprimée.
   Le code mise à jour de l'entête de la commande est postionné à A, la date de création à la date du jour
  et le code visiteur de mise à jour alimenté par le code du visiteur connecté
  </DESC> */
Long		l_row, l_retrieve
String	s_cetaecde

if not fw_controle_cde("ue_delete") then
return
end if

l_row 		= dw_1.GetRow ()
// Contrôle : Commande non validée
IF dw_1.GetItemString (l_row, DBNAME_ETAT_CDE) = COMMANDE_VALIDEE THEN
	messagebox (This.title,g_nv_traduction.get_traduction(ACCES_COMMANDE_IMPOSSIBLE),StopSign!,Ok!,1)
	dw_1.SetFocus ()
	RETURN
END IF
IF dw_1.GetItemString (l_row, DBNAME_ETAT_CDE) = COMMANDE_TRANSFEE THEN
	messagebox (This.title,g_nv_traduction.get_traduction(ACCES_COMMANDE_IMPOSSIBLE),StopSign!,Ok!,1)
	dw_1.SetFocus ()
	RETURN
END IF

// Demande de Confirmation
IF messagebox (This.title,g_nv_traduction.get_traduction(CONFIRMATION_SUPPRESS_COMMANDE) + dw_1.GetItemString(l_row, "numaecde") + " ?",Question!,YesNo!,2) = 2 THEN
	dw_1.SetFocus ()
	RETURN
End if

// Le code Maj de la commande passe à "A"
dw_1.SetItem (l_row, DBNAME_CODE_MAJ, COMMANDE_SUPPRIMEE)
dw_1.SetItem (l_row, DBNAME_DATE_CREATION,i_tr_sql.fnv_get_datetime ())
dw_1.SetItem (l_row, DBNAME_VISITEUR_MAJ, g_s_visiteur)
dw_1.Update ()

// Chargement des données en cas de modification
fw_retrieve_data(AUCUNE_COMMANDE)
if dw_1.RowCount() = 0 then
	This.TriggerEvent ("ue_cancel")
end if

end event

event ue_cancel;/* <DESC>
   Permet de quitter la fenêtre sans effectuer de sélection
   </DESC> */
destroy itooltip
Message.fnv_set_str_pass(i_str_pass)
Close (This)
end event

event ue_print;call super::ue_print;/* <DESC>
     Permet d'imprimer le bon de commande pour la commande sélectionnée
	  </DESC> */
// DECLARATION DES VARIABLES LOCALES
Long		l_retrieve
String	s_numaecde
String	s_numaeclf
String	s_cetaecde
String	s_code_adr
String    s_ucc
String    s_texte
nv_datastore ds_datastore

IF dw_1.GetItemString (dw_1.getRow(), "etat") = "I" THEN
	messagebox (This.title,g_nv_traduction.get_traduction(OPERATION_CLIENT_INEXISTANT),StopSign!,Ok!,1)
	dw_1.SetFocus ()
	RETURN
END IF

// IMPRESSION DU BON DE COMMANDE
s_cetaecde = dw_1.GetItemString (dw_1.GetRow (), DBNAME_ETAT_CDE)
s_numaecde = dw_1.GetItemString (dw_1.GetRow (), DBNAME_NUM_CDE)
s_numaeclf = dw_1.GetItemString (dw_1.GetRow (), DBNAME_CLIENT_CODE)
s_code_adr = g_nv_come9par.get_code_adresse()
s_ucc		   = dw_1.GetItemString (dw_1.GetRow (), DBNAME_UCC)	

ds_datastore = create nv_datastore
ds_datastore.dataobject = "d_report_bon_cde"
ds_datastore.setTransObject (sqlca)

if s_ucc = CODE_UCC_UC then
	s_texte = g_nv_traduction.get_traduction( "BON_CDE_QTE_UNC")
else
	s_texte = " "
end if

l_retrieve = ds_datastore.Retrieve (s_numaecde, s_numaeclf,  &
                                                               s_cetaecde,s_code_adr, &
												   s_texte,g_nv_come9par.get_code_langue( )		)

CHOOSE CASE l_retrieve
	CASE -1
		f_dmc_error (this.title + BLANK + ds_datastore.uf_getdberror( ) )
	CASE 0
	CASE ELSE
		g_nv_traduction.set_traduction_datastore( ds_datastore)
		triggerEvent("ue_printsetup")
		ds_datastore.print () 
END CHOOSE

destroy ds_datastore
end event

type uo_statusbar from w_a_liste`uo_statusbar within w_liste_cde
end type

type cb_cancel from w_a_liste`cb_cancel within w_liste_cde
integer y = 576
integer taborder = 40
end type

type cb_ok from w_a_liste`cb_ok within w_liste_cde
end type

type dw_1 from w_a_liste`dw_1 within w_liste_cde
event mousemove pbm_mousemove
string tag = "A_TRADUIRE"
integer x = 41
integer y = 32
integer width = 3397
integer height = 1200
string dataobject = "d_liste_cde"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_1::mousemove;if not isvalid(itooltip) then
	itooltip = create n_tooltip_mgr
end if
itooltip.of_mousemove_notify(parent, this, getobjectatpointer(), this.x + xpos, this.y + ypos)
end event

type pb_ok from w_a_liste`pb_ok within w_liste_cde
integer x = 87
integer y = 1340
integer taborder = 0
string text = "Valid. F11"
boolean default = false
string picturename = "c:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_echap from w_a_liste`pb_echap within w_liste_cde
integer x = 2665
integer y = 1340
integer taborder = 0
string picturename = "c:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type pb_changer from u_pba_chge_sel within w_liste_cde
integer x = 480
integer y = 1340
integer taborder = 0
string text = "&Autre  Sélection"
string picturename = "c:\appscir\Erfvmr_diva\Image\pb_chgmt.bmp"
vtextalign vtextalign = multiline!
end type

type pb_modif_client from u_pba_new_client within w_liste_cde
integer x = 1349
integer y = 1340
integer width = 393
integer height = 168
integer taborder = 0
boolean dragauto = false
string picturename = "c:\appscir\Erfvmr_diva\Image\pbnewcli.bmp"
end type

type pb_message from u_pba_echap within w_liste_cde
integer x = 1792
integer y = 1340
integer width = 366
integer taborder = 10
string text = "&Message"
string picturename = "c:\appscir\Erfvmr_diva\Image\LIVRES.BMP"
end type

on constructor;call u_pba_echap::constructor;
fu_setevent("ue_message")
fu_set_microhelp ("Saisie message cde")
end on

type pb_suppression from u_pba_supprim within w_liste_cde
integer x = 914
integer y = 1340
integer taborder = 11
string picturename = "c:\appscir\Erfvmr_diva\Image\pb_suppr.bmp"
end type

type pb_lig_indirecte from u_pba within w_liste_cde
integer x = 2194
integer y = 1340
integer width = 398
integer height = 168
integer taborder = 20
boolean bringtotop = true
string facename = "Arial"
string text = "&Lignes indirectes"
string picturename = "c:\appscir\Erfvmr_diva\Image\PB_IMP.BMP"
alignment htextalign = left!
end type

event constructor;call super::constructor;
// ------------------------------------------------------
// DECLENCHEMENT DE L'EVENEMENT AU NIVEAU DE LA FENÊTRE
// ------------------------------------------------------
	fu_setevent ("ue_lignes_indirectes")

// ------------------------------------------------------
// TEXTE DE LA MICROHELP
// ------------------------------------------------------
	fu_set_microhelp ("Impression des lignes indirectes")
end event

type pb_impression from u_pba within w_liste_cde
integer x = 3063
integer y = 1340
integer width = 334
integer height = 168
integer taborder = 20
boolean bringtotop = true
string facename = "Arial"
string text = "&Impression"
string picturename = "c:\appscir\Erfvmr_diva\Image\PB_IMP.BMP"
end type

on constructor;call u_pba::constructor;
// ------------------------------------------------------
// DECLENCHEMENT DE L'EVENEMENT AU NIVEAU DE LA FENÊTRE
// ------------------------------------------------------
	fu_setevent ("ue_print")

// ------------------------------------------------------
// TEXTE DE LA MICROHELP
// ------------------------------------------------------
	fu_set_microhelp ("Impression du bon de commande")
end on

type rb_non_valide from u_rba within w_liste_cde
integer x = 3515
integer y = 288
integer width = 626
integer height = 72
boolean bringtotop = true
string facename = "Arial"
long backcolor = 12632256
string text = "Non Validée"
end type

event clicked;call super::clicked;String ls_filtre
ls_filtre = (DBNAME_ETAT_CDE +" <> '" +COMMANDE_TRANSFEE +  "' and " +  DBNAME_ETAT_CDE + " <> '" +COMMANDE_VALIDEE +  "'")
dw_1.setFilter(ls_filtre)
 is_filtre = ls_filtre
dw_1.filter()
g_i_option_liste_derniere_cde =  1
end event

type rb_val_ntrf from u_rba within w_liste_cde
integer x = 3515
integer y = 440
integer width = 631
integer height = 72
boolean bringtotop = true
string facename = "Arial"
long backcolor = 12632256
string text = "Validée non transférée"
end type

event clicked;call super::clicked;String ls_filtre

ls_filtre = (DBNAME_ETAT_CDE +" <> '" +COMMANDE_TRANSFEE +  "' and " +  DBNAME_ETAT_CDE + " = '" +COMMANDE_VALIDEE +  "'")

dw_1.setFilter(ls_filtre)
is_filtre = ls_filtre
dw_1.Filter( )
g_i_option_liste_derniere_cde =  3
end event

type rb_transferee from u_rba within w_liste_cde
integer x = 3515
integer y = 524
integer width = 631
integer height = 72
boolean bringtotop = true
string facename = "Arial"
long backcolor = 12632256
string text = "Transférée"
end type

event clicked;call super::clicked;String ls_filtre
ls_filtre = DBNAME_ETAT_CDE +" = '" +COMMANDE_TRANSFEE + "'"
dw_1.setFilter(ls_filtre)
is_filtre = ls_filtre
dw_1.Filter( )
g_i_option_liste_derniere_cde =  4
end event

type rb_toutes from u_rba within w_liste_cde
integer x = 3515
integer y = 604
integer width = 631
integer height = 72
boolean bringtotop = true
string facename = "Arial"
long backcolor = 12632256
string text = "Toutes"
boolean checked = true
end type

event clicked;call super::clicked;String ls_filtre
ls_filtre = ""

dw_1.setFilter(ls_filtre)
is_filtre = ls_filtre
dw_1.Filter( )
g_i_option_liste_derniere_cde =  5
end event

type rb_bloquee from u_rba within w_liste_cde
integer x = 3515
integer y = 360
integer width = 626
integer height = 72
boolean bringtotop = true
string facename = "Arial"
long backcolor = 12632256
string text = "Bloquée"
end type

event clicked;call super::clicked;String ls_filtre
ls_filtre = (DBNAME_ETAT_CDE +" = '" + COMMANDE_BLOQUEE +  "'")
dw_1.setFilter(ls_filtre)
 is_filtre = ls_filtre
dw_1.filter()
g_i_option_liste_derniere_cde =  2
end event

type gb_visu_cde from groupbox within w_liste_cde
integer x = 3479
integer y = 220
integer width = 695
integer height = 492
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Visualisation Cde"
end type

