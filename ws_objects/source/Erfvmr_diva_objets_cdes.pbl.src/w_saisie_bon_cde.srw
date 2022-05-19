$PBExportHeader$w_saisie_bon_cde.srw
$PBExportComments$Saisie et modification des lignes de commande à partir des références composant un bon de commande
forward
global type w_saisie_bon_cde from w_a_mas_det
end type
type r_3 from rectangle within w_saisie_bon_cde
end type
type pb_ok from u_pba_ok within w_saisie_bon_cde
end type
type pb_echap from u_pba_echap within w_saisie_bon_cde
end type
type artae000_t from statictext within w_saisie_bon_cde
end type
type sle_article from u_slea within w_saisie_bon_cde
end type
type pb_changer from u_pba_bon_cde within w_saisie_bon_cde
end type
type dw_ligne_cde from u_dw_udim within w_saisie_bon_cde
end type
type r_1 from rectangle within w_saisie_bon_cde
end type
type r_2 from rectangle within w_saisie_bon_cde
end type
type patienter_t from statictext within w_saisie_bon_cde
end type
type st_2 from statictext within w_saisie_bon_cde
end type
end forward

global type w_saisie_bon_cde from w_a_mas_det
string tag = "SAISIE_BON_COMMANDE"
integer x = 0
integer y = 0
integer width = 3813
integer height = 2340
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = child!
windowstate windowstate = maximized!
long backcolor = 12632256
boolean ib_statusbar_visible = true
event ue_changer_bon pbm_custom41
event ue_workflow ( )
r_3 r_3
pb_ok pb_ok
pb_echap pb_echap
artae000_t artae000_t
sle_article sle_article
pb_changer pb_changer
dw_ligne_cde dw_ligne_cde
r_1 r_1
r_2 r_2
patienter_t patienter_t
st_2 st_2
end type
global w_saisie_bon_cde w_saisie_bon_cde

type variables
// Article du bon de cde encours
String		i_s_article
// Indique si on vient d'ouvrir la fenêtre
Boolean		i_b_ouverture = True
Double      i_d_qte_defaut

String DBNAME_QTE_BON  = "compute_qte"
nv_commande_object 	i_nv_commande_object
nv_ligne_cde_object 	i_nv_ligne_cde_object

n_tooltip_mgr itooltip

end variables

forward prototypes
public subroutine fw_return_fenetre_origine ()
end prototypes

event ue_changer_bon;/* <DESC>
       Permet d'afficher la fenêtre de sélection du bon de commande et
		 d'extraire les dimensions correspondantes au bon de commande 
		 sélectionné avec initialisation de la quantité par defaut saisie
		 lors de la sélection.
   </DESC> */
// DECLARATION DES VARIABLES LOCALES
Str_pass		str_work
Long			l_retrieve
Long			l_row

// SAUVEGARDE DE L'ENREGISTREMENT ENCOURS
IF dw_1.RowCount () <> 0 THEN
	This.TriggerEvent ("ue_save")
	if not i_b_update_status then
		return
	end if
END IF

// SELECTION DE LA REFERENCE 
str_work.s[01] = i_nv_commande_object.fu_get_ucc( )
OpenWithParm (w_liste_bon_cde, str_work)

str_work = Message.fnv_get_str_pass()
Message.fnv_clear_str_pass()

CHOOSE CASE str_work.s_action
	CASE ACTION_OK
		i_s_article  = str_work.s[1]
		sle_article.text = i_s_article + " - " + str_work.s[2]
	CASE ELSE
		IF i_s_article = donnee_vide THEN
			This.TriggerEvent ("ue_cancel")
		ELSE
			dw_1.SetFocus ()
		END IF 
		RETURN
END CHOOSE

// RETRIEVE DE LA DATAWINDOW DW_1
l_retrieve = dw_1.Retrieve (i_s_article)
CHOOSE CASE l_retrieve
	CASE -1
		f_dmc_error("Erreur Retrieve dw_1 dans ue_changer_bon de w_bon_cde")
	CASE 0
		messagebox (This.title,g_nv_traduction.get_traduction(AUCUNE_DIMENSION_BON_COMMANDE),StopSign! , Ok!, 1)
		This.PostEvent ("ue_changer_bon")
	CASE ELSE
END CHOOSE

// Initialisation de la qte
i_d_qte_defaut = str_work.d[1]
for l_row = 1 to dw_1.RowCount()
	dw_1.setItem(l_row,DBNAME_QTE_BON,i_d_qte_defaut)
	dw_1.setRow(l_row)
next

dw_1.SetFocus ()
i_b_ouverture = False
end event

event ue_workflow();/* <DESC>
    Cet evenement est appelé lors de la sélection d'une option dans le menu alors que cette
	 fenetre est la fenetre active et va lancer le workflow manager pour effectuer l'enchainement.
	 
	 Affichage d'un message de demande d'abandon de la saisie.
	 Si abandon de la saisie, enchainement par le workflowmanager sinon la fenetre reste
	 affichée
</DESC> */
integer li_reponse
li_reponse = messagebox (g_nv_traduction.get_traduction(SAISIE_COMMANDE), &
				g_nv_traduction.get_traduction(SAISIE_BON_COMMANDE_EN_COURS), & 
				StopSign!,YesNo!,1)

if li_reponse = 1 then
	i_str_pass.po[2] = i_nv_commande_object
	i_str_pass.s[2] = i_nv_commande_object.fu_get_numero_cde()
	g_nv_workflow_manager.fu_check_workflow(FENETRE_BON_CDE, i_str_pass)
	close(this)
end if
end event

public subroutine fw_return_fenetre_origine ();/* <DESC>
      Permet de revenir sur la fenetre d'origne.
	Si aucune fenetre n'est à l'origine de l'affichage de la saisie catalogue (Par le menu)
	   affichage de la fenetre de lignes de commande sinon affichage de la fenetre d'origine
   </DESC> */
if g_nv_workflow_manager.fu_get_fenetre_origine() = BLANK then
	g_s_fenetre_destination = FENETRE_LIGNE_CDE
else
	g_s_fenetre_destination = g_nv_workflow_manager.fu_get_fenetre_origine()
end if

g_nv_workflow_manager.fu_check_workflow(FENETRE_BON_CDE, i_str_pass)
close(this)
end subroutine

event ue_ok;/* <DESC>
    Validation de la saisie des lignes de commande.
	 <LI> Affichage de la fenêtre de saisie des conditions générales
	 <LI> Report des conditions sur les lignes de commande créées
	 <LI> Retour à la fenêtre d'origine
   </DESC> */
// OVERRIDE SCRIPT ANCESTOR
// DECLARATION DES VARIABLES LOCALES
Str_pass		str_work
integer	   li_indice
decimal ii_multiplicateur
decimal  ii_nbr_ligne_traitée =  0.0
decimal ii_nbr_total_ligne
boolean lb_invert = false
long	ll_color

triggerEvent("ue_save")
if not i_b_update_status then
	return
end if

if dw_1.rowCount() = 0 then
     messageBox(This.title,g_nv_traduction.get_traduction(VALIDATION_BON_IMPOSSIBLE), information!, ok!)
	return
end if

str_work.s[1] = dw_ligne_cde.getItemString(1, DBNAME_TYPE_LIGNE)
str_work.s[2] = dw_ligne_cde.getItemString(1, DBNAME_GROSSISTE)
str_work.s[3] = i_nv_commande_object.fu_get_code_echeance()
str_work.s[4] = i_nv_commande_object.fu_get_mode_paiement()
str_work.d[1] = i_nv_commande_object.fu_get_remise_cde()
str_work.dates[1] = i_nv_commande_object.fu_get_date_livraison()
str_work.dates[2] = i_nv_commande_object.fu_get_date_prix()
str_work.b[1] = false
str_work.po[1] = i_nv_commande_object
OpenWithParm (w_conditions, str_work)
str_work = Message.fnv_get_str_pass()
Message.fnv_clear_str_pass()

if str_work.s_action = ACTION_CANCEL then
	return
end if

setPointer(HourGlass!)
ii_nbr_total_ligne = dw_ligne_cde.RowCount()
ii_multiplicateur = 100 / ii_nbr_total_ligne
dw_1.visible = false
patienter_t.text = g_nv_traduction.get_traduction(PATIENTER_MAJ_EN_COURS)

for li_indice = 1 to dw_ligne_cde.RowCount()
	r_2.width = li_indice /dw_ligne_cde.RowCount()* r_1.width

	st_2.text = String (li_indice / dw_ligne_cde.RowCount(), "##0%")
	if not lb_invert then
		if ( r_2.width +  r_2.x) >= st_2.x then
			lb_invert = true
			ll_color = st_2.textcolor
			st_2.TextColor = st_2.BackColor
			st_2.BackColor = ll_color
		end if
	end if	  		

	dw_ligne_cde.setItem(li_indice, DBNAME_TYPE_LIGNE, str_work.s[1])
	dw_ligne_cde.setItem(li_indice, DBNAME_GROSSISTE, str_work.s[2])
	dw_ligne_cde.setItem(li_indice, DBNAME_MODE_PAIEMENT, str_work.s[3])
	dw_ligne_cde.setItem(li_indice, DBNAME_CODE_ECHEANCE, str_work.s[4])
	dw_ligne_cde.setItem(li_indice, DBNAME_REMISE_LIGNE, str_work.d[1])
	dw_ligne_cde.setItem(li_indice, DBNAME_DATE_LIVRAISON, str_work.dates[1])	
	dw_ligne_cde.setItem(li_indice, DBNAME_DATE_PRIX, str_work.dates[2])
    dw_ligne_cde.SetItem (li_indice, DBNAME_DATE_CREATION, i_tr_sql.fnv_get_datetime ())	
next
dw_ligne_cde.update()

if g_nv_workflow_manager.fu_get_fenetre_origine() = FENETRE_LIGNE_CDE_OPERATRICE then	
	i_nv_commande_object.fu_positionne_cde_a_valider()
end if

setPointer(Arrow!)
dw_1.visible = true

i_str_pass.s_action = ACTION_OK
i_str_pass.s[2] = i_nv_commande_object.fu_get_numero_cde()

fw_return_fenetre_origine()
Close(this)


end event

event ue_presave;call super::ue_presave;/* <DESC>
   Création des lignes de commande pour toutes les dimensions ayant une quantité
	saisie.durant cette mise à jour la datawindow de saisie est cachée et une barre
	de progression s'affiche.
	<LI>Controle de la validité de la quantité saisie
	<LI>Controle d'existence d'une ligne de cmmande pour chaque dimension
	Si une ligne existe, mise à jour de la quantité précédente par la nouvelle saisie. 
	Si laQuantité est à zéro, suppression de la ligne.
	<LI> Création des nouvelles lignes de commande
   </DESC> */
	
 // DECLARATION DES VARIABLES LOCALES
Long			l_row
long 			l_row_ligne_cde
String		s_article
String		s_dimension
Decimal		dec_qte

decimal ii_multiplicateur
decimal  ii_nbr_ligne_traitée =  0.0
decimal ii_nbr_total_ligne
boolean lb_invert = false
long	ll_color,ll_color_save,ll_backcolor_save
nv_reference_vente        lnv_reference_object

// INITIALISATION DES VARIABLES LOCALES
dw_1.AcceptText()
if dw_1.rowCount() = 0 then
	return
end if

lnv_reference_object = create nv_reference_vente

// controle de la quqntité
for l_row = 1 to dw_1.rowCount()
	dec_qte = dw_1.GetItemDecimal(l_row,DBNAME_QTE_BON)
	if not isNull(dec_qte) and dec_qte < 0 then
		MessageBox(This.title, g_nv_traduction.get_traduction(QUANTITE_ERRONE),StopSign!, ok!,1)
		dw_1.setRow(l_row)
		dw_1.setFocus()
		message.returnvalue = -1
		return 
	end if
next

setPointer(HourGlass!)
ii_nbr_total_ligne = dw_1.RowCount()
ii_multiplicateur = 100 / ii_nbr_total_ligne
ll_color_save = st_2.TextColor
ll_backcolor_save = st_2.backcolor

dw_1.visible = false

for l_row = 1 to dw_1.RowCount()
	s_article 		     =  i_s_article
	s_dimension 	= dw_1.GetItemString (l_row, DBNAME_DIMENSION)
	dec_qte			= dw_1.GetItemDecimal(l_row, DBNAME_QTE_BON)
	
	r_2.width = l_row /dw_1.RowCount()* r_1.width

	st_2.text = String (l_row / dw_1.RowCount(), "##0%")
	if not lb_invert then
		if ( r_2.width +  r_2.x) >= st_2.x then
			lb_invert = true
			ll_color = st_2.textcolor
			st_2.TextColor = st_2.BackColor
			st_2.BackColor = ll_color
		end if
	end if	  	
	
	//1- On controle s'il ne s'agit pas de modification de qte
	boolean lb_existe_deja = false
	for l_row_ligne_cde = 1 to dw_ligne_cde.RowCount()
		if dw_ligne_cde.getItemString(l_row_ligne_cde, DBNAME_ARTICLE) = s_article  and &		
	        dw_ligne_cde.getItemString(l_row_ligne_cde, DBNAME_DIMENSION) = s_dimension then
			lb_existe_deja = true
			exit
		end if
	next
	
	if lb_existe_deja then
		if dec_qte = 0 then
			dw_ligne_cde.deleterow(l_row_ligne_cde)	
		else
			dw_ligne_cde.setItem(l_row_ligne_cde, DBNAME_QTE, dec_qte)
		end if
		continue
	end if
	
	if dec_qte = 0 then
      continue
	end if
	
	// creation de la ligne de cde	
	l_row_ligne_cde = dw_ligne_cde.insertRow(0)
	datetime ldte_dispo
	lnv_reference_object.fu_controle_reference(s_article,s_dimension)
    ldte_dispo =  lnv_reference_object.fu_get_date_dispo(i_nv_commande_object.fu_get_marche())
    if mid(string(ldte_dispo),1,10) <>  "01/01/1900" then
       dw_ligne_cde.SetItem (l_row_ligne_cde,"DTDISPO",ldte_dispo)
     end if

	dw_ligne_cde.setItem(l_row_ligne_cde, DBNAME_ARTICLE, i_s_article)
	dw_ligne_cde.setItem(l_row_ligne_cde, DBNAME_DIMENSION, s_dimension)
	dw_ligne_cde.setItem(l_row_ligne_cde, DBNAME_QTE, dec_qte)
	dw_ligne_cde.setItem(l_row_ligne_cde, DBNAME_NUM_LIGNE, i_nv_ligne_cde_object.fu_get_nouveau_numero_ligne( ))
next
 
setPointer(Arrow!)
dw_1.visible = true
st_2.TextColor = ll_color_save
st_2.BackColor = ll_backcolor_save
end event

event ue_init;call super::ue_init;/* <DESC>
    Permet l'initialisation de la fenêtre.
	 <LI>Contrôle identification client
	 <LI>Création de l'objet commande
	 <LI>Initialisation de la datawindow contenant les lignes de commandes qui
	 seront créées
	 <LI> Affichage fenêtre de sélection du bon de commande
   </DESC> */
	
// DECLARATION DES VARIABLES LOCALES
Long			l_retrieve
Str_pass		str_work

i_str_pass = g_nv_workflow_manager.fu_ident_client(true, i_str_pass)
if  i_str_pass.s_action = ACTION_CANCEL then
	close(this)
	RETURN
end if

i_nv_commande_object = CREATE nv_commande_object
i_nv_commande_object.fu_set_numero_cde(i_str_pass.s[2])

IF dw_mas.Retrieve (i_nv_commande_object.fu_controle_numero_cde(i_str_pass.po[1]),g_nv_come9par.get_code_langue()) = -1 THEN
 	f_dmc_error (this.title +  BLANK + DB_ERROR_MESSAGE)
END IF

i_str_pass.po[2] = i_nv_commande_object
i_nv_ligne_cde_object = CREATE nv_ligne_cde_object
i_nv_ligne_cde_object.fu_init_info_commande(i_nv_commande_object)

// Cette datawindow contiendra toutes les lignes de cde créées par cette option
// ceci pour permettre une validation des lignes
dw_ligne_cde.setTransObject (sqlca)
i_nv_ligne_cde_object.fu_init_valeur_ligne_cde_par_bon_cde(dw_ligne_cde)

nv_client_object lnv_client
lnv_client = i_str_pass.po[1]

dw_mas.setItem(1,"alerte",lnv_client.fu_get_alerte( ))

This.TriggerEvent ("ue_changer_bon")
end event

event ue_cancel;/* <DESC>
    Permet de quitter la saisie aprés demande de confirmation de l'abandon de la
	 saisie donc de la perte des lignes de commandes créées
   </DESC> */
integer li_return

if dw_1.RowCount() > 0 then
	li_return = MessageBox(This.title,g_nv_traduction.get_traduction(ABANDON_BON_A_CONFIRMER),StopSign!,yesNo!)
   if li_return = 2 then
		return
	end if
end if

i_str_pass.po[2] = i_nv_commande_object
i_str_pass.s_action = ACTION_OK
i_b_canceled = TRUE
fw_return_fenetre_origine()

end event

event key;call super::key;/* <DESC>
      Permet de trapper les touches de fonction activées et déclencher l'évènement associé
	à la touche.
	  F11 = Validation de al saisie
   </DESC> */
	IF KeyDown (KeyF11!) THEN
		This.PostEvent ("ue_ok")
	END IF
end event

on w_saisie_bon_cde.create
int iCurrent
call super::create
this.r_3=create r_3
this.pb_ok=create pb_ok
this.pb_echap=create pb_echap
this.artae000_t=create artae000_t
this.sle_article=create sle_article
this.pb_changer=create pb_changer
this.dw_ligne_cde=create dw_ligne_cde
this.r_1=create r_1
this.r_2=create r_2
this.patienter_t=create patienter_t
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.r_3
this.Control[iCurrent+2]=this.pb_ok
this.Control[iCurrent+3]=this.pb_echap
this.Control[iCurrent+4]=this.artae000_t
this.Control[iCurrent+5]=this.sle_article
this.Control[iCurrent+6]=this.pb_changer
this.Control[iCurrent+7]=this.dw_ligne_cde
this.Control[iCurrent+8]=this.r_1
this.Control[iCurrent+9]=this.r_2
this.Control[iCurrent+10]=this.patienter_t
this.Control[iCurrent+11]=this.st_2
end on

on w_saisie_bon_cde.destroy
call super::destroy
destroy(this.r_3)
destroy(this.pb_ok)
destroy(this.pb_echap)
destroy(this.artae000_t)
destroy(this.sle_article)
destroy(this.pb_changer)
destroy(this.dw_ligne_cde)
destroy(this.r_1)
destroy(this.r_2)
destroy(this.patienter_t)
destroy(this.st_2)
end on

event ue_close;/*<DESC> 
      Permet de fermer la fenêtre en retournant à la fenêtre d'origine.
   </DESC> */
//override ancestor script

i_b_canceled = TRUE
fw_return_fenetre_origine()
Close(THIS)
end event

event ue_detect_change;call super::ue_detect_change;/* <DESC>
     Overwrite du script de l'ancetre
    </DESC> */
message.doubleparm = 2
end event

event ue_save;/* <DESC>
      Permet de lancer le controle de la saisie et d'effectuer la mise à jour
	Le script de l'ancetre a été remplacé car la datawindow à mettre à jour n'est celle
	contenant le bon de commande mais les lignes de commandes
	La mise à jour des lignes de commande ne devient effective que les conditions
	saisies et reportées sur les lignes
   </DESC> */
// overwrite
this.TriggerEvent ("ue_presave")

IF message.returnvalue < 0 THEN
	i_b_update_status = FALSE
	RETURN
END IF

i_b_update_status = true
end event

event closequery;/* <DESC>
     Overwrite le script de l'ancetre
   </DESC> */

end event

type uo_statusbar from w_a_mas_det`uo_statusbar within w_saisie_bon_cde
end type

type dw_1 from w_a_mas_det`dw_1 within w_saisie_bon_cde
integer x = 101
integer y = 708
integer width = 3209
integer height = 896
integer taborder = 10
string dataobject = "d_bon_cde"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event dw_1::we_dwnkey;call super::we_dwnkey;/* <DESC> 
    Permet d'effectuer le trigger KEY de la fenetre
	 </DESC> */
f_key(Parent)
end event

event dw_1::we_dwnprocessenter;call super::we_dwnprocessenter;/* <DESC>
     Permet d'effectuer le changement de ligne lors de l'activation de la touche Entree
	  </DESC> */
AcceptText()
Send(Handle(This),256,9,Long(0,0))
Return 1		
end event

type dw_mas from w_a_mas_det`dw_mas within w_saisie_bon_cde
event mousemove pbm_mousemove
string tag = "A_TRADUIRE"
integer x = 219
integer y = 28
integer width = 2930
integer height = 524
integer taborder = 0
string dataobject = "d_entete_saisie_cde"
borderstyle borderstyle = styleshadowbox!
end type

event dw_mas::mousemove;if not isvalid(itooltip) then
	itooltip = create n_tooltip_mgr
end if
itooltip.of_mousemove_notify(parent, this, getobjectatpointer(), this.x + xpos, this.y + ypos)
end event

type r_3 from rectangle within w_saisie_bon_cde
integer linethickness = 4
long fillcolor = 12632256
integer x = 608
integer y = 928
integer width = 1883
integer height = 316
end type

type pb_ok from u_pba_ok within w_saisie_bon_cde
integer x = 302
integer y = 1656
integer width = 334
integer height = 156
integer taborder = 0
string text = "Valid.  F11"
boolean default = false
string picturename = "c:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_echap from u_pba_echap within w_saisie_bon_cde
integer x = 1463
integer y = 1660
integer height = 156
integer taborder = 0
string picturename = "c:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type artae000_t from statictext within w_saisie_bon_cde
integer x = 421
integer y = 592
integer width = 347
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
string text = "Article  "
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_article from u_slea within w_saisie_bon_cde
integer x = 795
integer y = 592
integer width = 1943
integer height = 72
integer taborder = 0
integer textsize = -9
integer weight = 700
string facename = "Arial"
long textcolor = 0
long backcolor = 1090519039
boolean border = false
borderstyle borderstyle = stylebox!
end type

type pb_changer from u_pba_bon_cde within w_saisie_bon_cde
integer x = 896
integer y = 1656
integer width = 421
integer height = 156
integer taborder = 0
boolean dragauto = false
boolean originalsize = false
string picturename = "c:\appscir\Erfvmr_diva\Image\pb_bon.bmp"
end type

type dw_ligne_cde from u_dw_udim within w_saisie_bon_cde
boolean visible = false
integer x = 3177
integer y = 464
integer width = 338
integer height = 176
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_ligne_cde"
end type

type r_1 from rectangle within w_saisie_bon_cde
integer linethickness = 4
long fillcolor = 16777215
integer x = 891
integer y = 1080
integer width = 1248
integer height = 76
end type

type r_2 from rectangle within w_saisie_bon_cde
integer linethickness = 4
long fillcolor = 16711680
integer x = 891
integer y = 1080
integer width = 41
integer height = 72
end type

type patienter_t from statictext within w_saisie_bon_cde
integer x = 635
integer y = 976
integer width = 1760
integer height = 88
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Veuillez patienter , création des lignes de la commande en cours"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_saisie_bon_cde
string tag = "0%"
integer x = 1435
integer y = 1084
integer width = 133
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 16777215
string text = "none"
long bordercolor = 16711680
boolean focusrectangle = false
end type

