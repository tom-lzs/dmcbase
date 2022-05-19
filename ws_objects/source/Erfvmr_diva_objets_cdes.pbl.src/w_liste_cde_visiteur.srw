$PBExportHeader$w_liste_cde_visiteur.srw
$PBExportComments$Affiche la iste des commandes du visiteur connecté
forward
global type w_liste_cde_visiteur from w_a_liste
end type
type pb_suppression from u_pba_supprim within w_liste_cde_visiteur
end type
type pb_impression from u_pba within w_liste_cde_visiteur
end type
type pb_message from u_pba_echap within w_liste_cde_visiteur
end type
type pb_lig_indirecte from u_pba within w_liste_cde_visiteur
end type
type pb_modif_client from u_pba_new_client within w_liste_cde_visiteur
end type
type rb_non_valide from u_rba within w_liste_cde_visiteur
end type
type rb_val_ntrf from u_rba within w_liste_cde_visiteur
end type
type rb_transferee from u_rba within w_liste_cde_visiteur
end type
type rb_toutes from u_rba within w_liste_cde_visiteur
end type
type rb_bloquee from u_rba within w_liste_cde_visiteur
end type
type gb_visu_cde from groupbox within w_liste_cde_visiteur
end type
end forward

global type w_liste_cde_visiteur from w_a_liste
string tag = "CDES_VISITEURS"
integer x = 0
integer y = 0
integer width = 4215
integer height = 2208
boolean titlebar = false
boolean controlmenu = false
boolean resizable = false
windowtype windowtype = child!
windowstate windowstate = maximized!
boolean ib_statusbar_visible = true
event ue_message pbm_custom39
event ue_workflow ( )
event ue_lignes_indirectes ( )
event ue_modif_client ( )
pb_suppression pb_suppression
pb_impression pb_impression
pb_message pb_message
pb_lig_indirecte pb_lig_indirecte
pb_modif_client pb_modif_client
rb_non_valide rb_non_valide
rb_val_ntrf rb_val_ntrf
rb_transferee rb_transferee
rb_toutes rb_toutes
rb_bloquee rb_bloquee
gb_visu_cde gb_visu_cde
end type
global w_liste_cde_visiteur w_liste_cde_visiteur

type variables
Boolean		i_b_ouverture = TRUE
n_tooltip_mgr itooltip



end variables

forward prototypes
public subroutine fw_retrieve_donnee ()
end prototypes

event ue_message;/* <DESC>
    Permet d'aller en saisi d'un message sur la commande même celle ci est validée
   </DESC> */
if not fw_controle_cde("ue_message") then
	return
end if

fw_complete_structure()

g_nv_workflow_manager.fu_set_fenetre_origine (this.classname())
OpenWithParm (w_message_cde_response, i_str_pass)

dw_1.Retrieve (g_s_visiteur)
dw_1.SetFocus()
dw_1.scrollToRow(il_row_encours)


end event

event ue_workflow();/* <DESC>
    Cet evenement est appelé lors de la sélection d'une option dans le menu alors que cette
	 fenetre est la fenetre active et va lancer le workflow manager pour effetuer l'enchainement.
</DESC> */
if dw_1.rowCount() > 0 then
	IF dw_1.GetItemString (dw_1.getRow(), "etat") = "I" THEN
		messagebox (This.title,g_nv_traduction.get_traduction(OPERATION_CLIENT_INEXISTANT),StopSign!,Ok!,1)
		dw_1.SetFocus ()
		RETURN
	END IF
end if
	
fw_complete_structure()
g_nv_workflow_manager.fu_check_workflow(FENETRE_LISTE_CDE, i_str_pass)

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
Long  l_row


l_row = dw_1.GetRow ()
if not fw_controle_cde("ue_lignes_indirectes") then
	return
end if

if not inv_commande.fu_is_commande_avec_ligne_indirecte() then
	messageBox(This.Title,g_nv_traduction.get_traduction( AUCUNE_LIGNE_INDIRECTE), information!, ok!)
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
		g_nv_traduction.set_traduction_datastore(ds_print)
		triggerEvent("ue_printsetup")
		ds_print.print () 
END CHOOSE

if inv_commande.fu_is_commande_validee() then
	return
end if

IF not inv_commande.fu_is_entete_cde_validee() THEN
	messagebox (This.title,g_nv_traduction.get_traduction(VALIDATION_ENTETE),	Information!,Ok!,1)
	RETURN
END IF

integer li_reponse
li_reponse = messageBox(This.title, g_nv_traduction.get_traduction(LEVER_BLOCAGE_INDIRECT), Information!, YesNo!)
if li_reponse = 2 then
	return
end if

dw_1.SetItem (l_row, DBNAME_ETAT_CDE,COMMANDE_VALIDEE)
dw_1.SetItem (l_row, DBNAME_BLOCAGE_LIGNE_CDE,CODE_PAS_DE_BLOCAGE)
dw_1.SetItem (l_row, DBNAME_DATE_CREATION,i_tr_sql.fnv_get_datetime ())
dw_1.SetItem (l_row, DBNAME_VISITEUR_MAJ, g_s_visiteur)
dw_1.Update ()

end event

event ue_modif_client();/* <DESC> 
    Permet de changer le client commande en affichant la fenetre de selection du client et une fois le client
	 selectionne, on creer un nouvel oject client et appel de la fonction de changement du client sur la commande.
   Si le client sélectionné est un  client prospect, on reaffiche la fenetre de selection d'un client.
  </DESC> */
// -----------------------------------
// DECLARATION DES VARIABLES LOCALES
// -----------------------------------
Str_pass		l_str_work
String		s_code_retour = "   "
Long			l_retrieve
String          ls_code_client, ls_numcde

if not fw_controle_cde("ue_modif_client") then
	return
end if

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
	messagebox (this.title, g_nv_traduction.get_traduction(CLIENT_PROSPECT_IMPOSSIBLE), Information!,Ok!,1)
		GoTo Selection_client
end if

f_changement_client(lu_client, ls_code_client,ls_numcde)

// -------------------------------
// Modification du client prospect
// -------------------------------
fw_retrieve_donnee()
	
end event

public subroutine fw_retrieve_donnee ();/* <DESC> 
     Permet d'extraire toutes commandes correspondantes au visiteur connecté
	 et d'appliquer le filtre en fonction  du type de visualisation	
   </DESC> */
// Chargement des données
Long l_retrieve
l_retrieve = dw_1.Retrieve (g_s_visiteur)

CHOOSE CASE l_retrieve
	CASE -1
		f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
	CASE 0
		messagebox (This.title, g_nv_traduction.get_traduction(AUCUNE_COMMANDE),Information!,Ok!,1)
		//This.PostEvent ("ue_cancel")
		return
	CASE ELSE
		i_b_ouverture = FALSE
		dw_1.fu_set_sort_on_label(True)
		dw_1.SetFocus ()		
END CHOOSE

// Controle si la devise est la même pour toutes les commandes
// Si cela n'est pas le cas, le total sera cache
String ls_devise
boolean lb_meme_devise = true

ls_devise = dw_1.getItemString(1,DBNAME_CODE_DEVISE)
for l_retrieve = 1 to dw_1.RowCount()
	if ls_devise <> dw_1.getItemString(1,DBNAME_CODE_DEVISE) then
		lb_meme_devise = false
		exit
	end if
next

if lb_meme_devise then
	dw_1.Modify("DataWindow.Footer.Height=120")
else
	dw_1.Modify("DataWindow.Footer.Height=0")
end if

dw_1.setRow(il_row_encours)		
end subroutine

event ue_init;/* <DESC>
    Permet d'initialiser l'affichage initiale de la fenetre et d'afficher la fenetre de selection 
	 des commandes.
   </DESC> */
// Déclaration des variables locales
Long		l_retrieve
	
dw_1.fu_set_selection_mode(1)
dw_1.fu_set_sort_on_label(True)
	
If not g_nv_come9par.is_vendeur() then
  	pb_modif_client.visible = True
End if


// Chargement des données
fw_retrieve_donnee()

i_str_pass.b[2]	= false
itooltip = CREATE n_tooltip_mgr

dw_1.Object.DataWindow.HorizontalScrollSplit = 400

Choose case g_i_option_liste_cde_visiteur
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


end event

event ue_print;/* <DESC>
     Permet d'imprimer le bon de commande pour la commande sélectionnée
	  </DESC> */
// DECLARATION DES VARIABLES LOCALES
Long		l_retrieve
String	s_numaecde
String	s_numaeclf
String	s_cetaecde
String s_code_adr
String    s_ucc
String    s_texte 
nv_datastore ds_datastore

IF dw_1.GetItemString (dw_1.getRow(), "etat") = "I" THEN
	messagebox (This.title,g_nv_traduction.get_traduction(OPERATION_CLIENT_INEXISTANT),StopSign!,Ok!,1)
	dw_1.SetFocus ()
	RETURN
END IF

// IMPRESSION DU BON DE COMMANDE

/* faire traduire le contenu de la datawindow pour imprimer le bon de commande
   dans la langue du visiteur */

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
												   s_texte,g_nv_come9par.get_code_langue( )	)

CHOOSE CASE l_retrieve
	CASE -1
		f_dmc_error (this.title + BLANK + ds_datastore.uf_getdberror( ) )
	CASE 0
	CASE ELSE
		g_nv_traduction.set_traduction_datastore (ds_datastore)
		triggerEvent("ue_printsetup")
		ds_datastore.print () 
END CHOOSE

destroy ds_datastore
end event

event ue_delete;call super::ue_delete;/* <DESC>
   Permet se supprimer une commande. Pour cela on controle que lq commande ne soit pas validée, ni transférée dans SAP.
   La suppression n'est effective qu'après confirmation.
  </DESC> */
// DECLARATION DES VARIABLES LOCALES
Long		l_row, l_retrieve
String	s_cetaecde

if not fw_controle_cde("ue_delete")  then
   	return
end if

l_row 		= dw_1.GetRow ()

// Demande de Confirmation
IF messagebox (This.title,g_nv_traduction.get_traduction(SUPPRESSION_COMMANDE) + dw_1.GetItemString(l_row, "numaecde") + " ?",Question!,YesNo!,2) = 2 THEN
	dw_1.SetFocus ()
	RETURN
End if

// Le code Maj de la commande passe à "A"
dw_1.SetItem (l_row, DBNAME_CODE_MAJ, COMMANDE_SUPPRIMEE)
dw_1.SetItem (l_row, DBNAME_DATE_CREATION,i_tr_sql.fnv_get_datetime ())
dw_1.SetItem (l_row, DBNAME_VISITEUR_MAJ, g_s_visiteur)
dw_1.Update ()


// Chargement des données en cas de modification
l_retrieve = dw_1.Retrieve (g_s_visiteur)
CHOOSE CASE l_retrieve
	CASE -1
		f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
	CASE 0
		messagebox (This.title, g_nv_traduction.get_traduction(AUCUNE_COMMANDE_EN_COURS),Information!,Ok!,1)
		This.PostEvent ("ue_cancel")
	CASE ELSE
		dw_1.SetFocus ()
END CHOOSE
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

on w_liste_cde_visiteur.create
int iCurrent
call super::create
this.pb_suppression=create pb_suppression
this.pb_impression=create pb_impression
this.pb_message=create pb_message
this.pb_lig_indirecte=create pb_lig_indirecte
this.pb_modif_client=create pb_modif_client
this.rb_non_valide=create rb_non_valide
this.rb_val_ntrf=create rb_val_ntrf
this.rb_transferee=create rb_transferee
this.rb_toutes=create rb_toutes
this.rb_bloquee=create rb_bloquee
this.gb_visu_cde=create gb_visu_cde
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_suppression
this.Control[iCurrent+2]=this.pb_impression
this.Control[iCurrent+3]=this.pb_message
this.Control[iCurrent+4]=this.pb_lig_indirecte
this.Control[iCurrent+5]=this.pb_modif_client
this.Control[iCurrent+6]=this.rb_non_valide
this.Control[iCurrent+7]=this.rb_val_ntrf
this.Control[iCurrent+8]=this.rb_transferee
this.Control[iCurrent+9]=this.rb_toutes
this.Control[iCurrent+10]=this.rb_bloquee
this.Control[iCurrent+11]=this.gb_visu_cde
end on

on w_liste_cde_visiteur.destroy
call super::destroy
destroy(this.pb_suppression)
destroy(this.pb_impression)
destroy(this.pb_message)
destroy(this.pb_lig_indirecte)
destroy(this.pb_modif_client)
destroy(this.rb_non_valide)
destroy(this.rb_val_ntrf)
destroy(this.rb_transferee)
destroy(this.rb_toutes)
destroy(this.rb_bloquee)
destroy(this.gb_visu_cde)
end on

event open;call super::open;
	This.X = 0
	This.Y = 0
end event

event key;call super::key;/* <DESC>
      Permet de trapper les touches de fonction activées et déclencher l'évènement associé
	à la touche.
	  F11 = validation de la sélection
   </DESC> */
	IF KeyDown (KeyF11!) THEN
		This.PostEvent ("ue_ok")
	END IF
end event

event activate;call super::activate;/* <DESC>
     La fenetre reste ouverte même lors de l'ouverture de la saise des lignes de commande, 
	 et permet en retour sur la liste de refraichir les données affichées
   </DESC> */
//IF not i_b_ouverture THEN
	fw_retrieve_donnee()
	dw_1.scrollToRow(il_row_encours)
	i_b_ouverture = true
//END IF
end event

event ue_cancel;/* <DESC>
   Permet de quitter la fenetre
   </DESC> */
   destroy itooltip
	Message.fnv_set_str_pass(i_str_pass)
	Close (This)
end event

type uo_statusbar from w_a_liste`uo_statusbar within w_liste_cde_visiteur
end type

type cb_cancel from w_a_liste`cb_cancel within w_liste_cde_visiteur
integer y = 576
integer taborder = 0
end type

type cb_ok from w_a_liste`cb_ok within w_liste_cde_visiteur
integer taborder = 0
end type

type dw_1 from w_a_liste`dw_1 within w_liste_cde_visiteur
event mousemove pbm_mousemove
string tag = "A_TRADUIRE"
integer x = 37
integer y = 16
integer width = 3058
integer height = 1280
string dataobject = "d_liste_cde_visiteur"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_1::mousemove;if not isvalid(itooltip) then
	itooltip = create n_tooltip_mgr
end if
itooltip.of_mousemove_notify(parent, this, getobjectatpointer(), this.x + xpos, this.y + ypos)
end event

type pb_ok from w_a_liste`pb_ok within w_liste_cde_visiteur
integer x = 146
integer y = 1344
integer width = 366
integer taborder = 0
string text = "Valid.  F11"
boolean default = false
string picturename = "c:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_echap from w_a_liste`pb_echap within w_liste_cde_visiteur
integer x = 2912
integer y = 1336
integer width = 366
integer taborder = 0
string picturename = "c:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type pb_suppression from u_pba_supprim within w_liste_cde_visiteur
integer x = 1042
integer y = 1344
integer width = 366
integer taborder = 0
string picturename = "c:\appscir\Erfvmr_diva\Image\pb_suppr.bmp"
end type

type pb_impression from u_pba within w_liste_cde_visiteur
integer x = 599
integer y = 1344
integer width = 366
integer height = 168
integer taborder = 0
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

type pb_message from u_pba_echap within w_liste_cde_visiteur
integer x = 1938
integer y = 1344
integer width = 366
integer taborder = 10
string text = "&Message"
string picturename = "c:\appscir\Erfvmr_diva\Image\LIVRES.BMP"
vtextalign vtextalign = top!
end type

on constructor;call u_pba_echap::constructor;fu_setevent("ue_message")
fu_set_microhelp ("Saisie message commande")
end on

type pb_lig_indirecte from u_pba within w_liste_cde_visiteur
integer x = 2336
integer y = 1344
integer width = 421
integer height = 168
integer taborder = 30
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

type pb_modif_client from u_pba_new_client within w_liste_cde_visiteur
boolean visible = false
integer x = 1486
integer y = 1340
integer width = 366
integer height = 168
integer taborder = 30
boolean dragauto = false
boolean bringtotop = true
string picturename = "c:\appscir\Erfvmr_diva\Image\pbnewcli.bmp"
end type

type rb_non_valide from u_rba within w_liste_cde_visiteur
integer x = 3173
integer y = 284
integer width = 736
integer height = 72
boolean bringtotop = true
string facename = "Arial"
long backcolor = 12632256
string text = "Non Validée"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.setFilter(DBNAME_ETAT_CDE +" <> '" +COMMANDE_TRANSFEE +  "' and " +  DBNAME_ETAT_CDE + " <> '" +COMMANDE_VALIDEE +  "'")
dw_1.filter()
g_i_option_liste_cde_visiteur = 1
end event

type rb_val_ntrf from u_rba within w_liste_cde_visiteur
integer x = 3173
integer y = 440
integer width = 741
integer height = 72
boolean bringtotop = true
string facename = "Arial"
long backcolor = 12632256
string text = "Validée non transférée"
end type

event clicked;call super::clicked;dw_1.setFilter(DBNAME_ETAT_CDE +" <> '" +COMMANDE_TRANSFEE +  "' and " +  DBNAME_ETAT_CDE + " = '" +COMMANDE_VALIDEE +  "'")
dw_1.Filter( )
g_i_option_liste_cde_visiteur = 3
end event

type rb_transferee from u_rba within w_liste_cde_visiteur
integer x = 3173
integer y = 524
integer width = 736
integer height = 72
boolean bringtotop = true
string facename = "Arial"
long backcolor = 12632256
string text = "Transférée"
end type

event clicked;call super::clicked;dw_1.setFilter(DBNAME_ETAT_CDE +" = '" +COMMANDE_TRANSFEE + "'")
dw_1.Filter( )
g_i_option_liste_cde_visiteur = 4

end event

type rb_toutes from u_rba within w_liste_cde_visiteur
integer x = 3173
integer y = 604
integer width = 741
integer height = 72
boolean bringtotop = true
string facename = "Arial"
long backcolor = 12632256
string text = "Toutes"
end type

event clicked;call super::clicked;dw_1.setFilter("")
dw_1.Filter( )
g_i_option_liste_cde_visiteur = 5
end event

type rb_bloquee from u_rba within w_liste_cde_visiteur
integer x = 3173
integer y = 360
integer width = 741
integer height = 72
boolean bringtotop = true
string facename = "Arial"
long backcolor = 12632256
string text = "Bloquée"
end type

event clicked;call super::clicked;dw_1.setFilter(DBNAME_ETAT_CDE +" = '" + COMMANDE_BLOQUEE +  "'")
dw_1.filter()
g_i_option_liste_cde_visiteur = 2
end event

type gb_visu_cde from groupbox within w_liste_cde_visiteur
integer x = 3131
integer y = 216
integer width = 818
integer height = 504
integer taborder = 30
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

