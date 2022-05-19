$PBExportHeader$w_fin_cde.srw
$PBExportComments$Permet d'effectuer la validation de fin de commande.
forward
global type w_fin_cde from w_a_udis
end type
type cb_promo from u_cba within w_fin_cde
end type
type cb_anomalies from u_cba within w_fin_cde
end type
type cb_valorisation from u_cba within w_fin_cde
end type
type gb_1 from groupbox within w_fin_cde
end type
type pb_echap from u_pba_echap within w_fin_cde
end type
type pb_ok from u_pba_ok within w_fin_cde
end type
type p_fleche from picture within w_fin_cde
end type
type pb_affiche_ligne from u_pba within w_fin_cde
end type
end forward

global type w_fin_cde from w_a_udis
string tag = "FIN_CDE"
integer x = 0
integer y = 0
integer width = 3739
integer height = 2600
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = child!
windowstate windowstate = maximized!
long backcolor = 12632256
boolean ib_statusbar_visible = true
event ue_anomalies pbm_custom40
event ue_promo_cde pbm_custom42
event ue_affiche_ligne pbm_custom55
event ue_workflow ( )
cb_promo cb_promo
cb_anomalies cb_anomalies
cb_valorisation cb_valorisation
gb_1 gb_1
pb_echap pb_echap
pb_ok pb_ok
p_fleche p_fleche
pb_affiche_ligne pb_affiche_ligne
end type
global w_fin_cde w_fin_cde

type variables
// Ouverture d'une fenêtre où l'on peut modifier l'entête 
// de commande
Boolean					i_b_maj_entete = FALSE
nv_commande_object 	i_nv_commande_object
n_tooltip_mgr        itooltip
end variables

event ue_anomalies;/* <DESC> 
Permet d'afficher les lignes de commandes en anomalie 
</DESC> */
i_b_maj_entete = TRUE
i_b_canceled = TRUE
i_str_pass.s_action 	= ACTION_OK
i_str_pass.s_win_title = TITRE_LIGNE_EN_ANOMALIE
i_str_pass.s_dataobject = "d_ligne_cde_erreur"
g_w_frame.fw_open_sheet (FENETRE_LIGNE_CDE, 0, -1, i_str_pass)
Close (This)
end event

event ue_promo_cde;/* <DESC>
    Permet d'afficher le récapitulatif des promotions effectuées sur la commande
 </DESC> */
Str_pass l_str_work
l_str_work.s[1] = i_nv_commande_object.fu_get_numero_cde()
OpenWithParm (w_liste_promo_cde,l_str_work)

end event

event ue_affiche_ligne;/* <DESC>
    Permet de retourner en affichage des lignes de commande
	 </DESC> */
i_b_canceled = TRUE
i_str_pass.s_action = "O"
g_w_frame.fw_open_sheet (FENETRE_LIGNE_CDE, 0, -1, i_str_pass)
Close(this)
end event

event ue_workflow();/* <DESC>
    Cet evenement est appelé lors de la sélection d'une option dans le menu alors que cette
	 fenetre est la fenetre active et va lancer le workflow manager pour effetuer l'enchainement.
	 
	 Si l'on souhaite ouvri une autre fenêtre autre que l'entete de commande, il ne sera pas
	 possible d'effectuer l'enchainement tant que la fenetre sera active
</DESC> */

if g_s_fenetre_destination = FENETRE_ENTETE_CDE or &
   g_s_fenetre_destination = FENETRE_ENTETE_CDE_RC THEN
		i_b_maj_entete =  true
		g_nv_workflow_manager.fu_check_workflow(FENETRE_FIN_CDE, i_str_pass)
	else
      messagebox (This.title, g_nv_traduction.get_traduction(FIN_CDE_EN_COURS),Information!,Ok!,1)
end if

end event

event fw_modif_numcde;i_b_maj_entete = TRUE
i_str_pass.s_action = "O"
i_str_pass.b[6] = TRUE
g_w_frame.fw_open_sheet (FENETRE_ENTETE_CDE, 0, 1, i_str_pass)

messagebox (This.title, g_nv_traduction.get_traduction(FIN_CDE_EN_COURS),Information!,Ok!,1)

end event

event ue_ok;/* <DESC>
      Permet d'effectuer la validation de la commande et de retourner
	sur la liste d'origine
   </DESC> */
//
// OVERRIDE ANCESTOR SCRIPT
//
if i_nv_commande_object.fu_is_commande_validee() then
	return
end if

IF not i_nv_commande_object.fu_is_entete_cde_validee() THEN
	messagebox (This.title,&
					g_nv_traduction.get_traduction(VISU_AVANT_VALIDATION_CDE),&
					Information!,Ok!,1)
	RETURN
END IF

// ========================================================
//  V A L I D A T I O N   D E   L A   C O M M A N D E
// ========================================================
i_nv_commande_object.fu_validation_commande()
i_str_pass.s_action = ACTION_OK

destroy  itooltip

g_nv_workflow_manager.fu_affiche_liste_origine(i_str_pass)
Close (This)
end event

event activate;call super::activate;/* <DESC> 
     Déclencher lorsque la fenêtre devietn la fenêtre active.
	Ceci permet de réactualiser ls données de l'entête de commande. Ceci est
	surtout necessaire lorsque de cette fenetre on passe en validation de l'entete de commande
	puis retour sur cete fenetre
   </DESC> */
// Déclaration des variables locales
Long	l_retrieve

IF i_b_maj_entete = TRUE THEN
	i_b_maj_entete = FALSE
    i_nv_commande_object = CREATE nv_commande_object
	i_nv_commande_object.fu_set_numero_cde(i_str_pass.s[2])
	i_nv_commande_object.fu_controle_numero_cde(i_str_pass.po[1])
	
	if dw_1.Retrieve (i_nv_commande_object.fu_get_numero_cde(),g_nv_come9par.get_code_langue()) = -1 then
		f_dmc_error ("Erreur retrieve de dw_1 dans activate de w_fin_cde")
	end if

END IF 
end event

event ue_init;call super::ue_init;/* <DESC>
    Affichage initialie de la fenêtre.
	<LI> Si existence de ligne de commande en anomalie et qu'il s'agit du premier
	passage, affichage des lignes de commande en anomalie sinon
	rendre actif le bouton lignes en anomalie
	<LI> SI existence de ligne promotionnelle, rendre actif le bouton promotion
   </DESC> */
// DECLARATION DES VARIABLES LOCALES
Long		l_retrieve
g_nv_trace.fu_write_trace( this.classname( ), "ue_ini",i_str_pass.s[01], i_str_pass.s[02], this.classname( ) , g_s_fenetre_destination)
i_nv_commande_object = CREATE nv_commande_object
i_nv_commande_object.fu_set_numero_cde(i_str_pass.s[2])
i_nv_commande_object.fu_controle_numero_cde(i_str_pass.po[1])
i_str_pass.po[2] = i_nv_commande_object

i_str_pass.b[2]	= True

// Y A T'IL DES LIGNES EN ANOMALIE BLOQUANTE au niveau ligne
IF i_nv_commande_object.fu_is_commande_blocage_ligne() THEN
	cb_anomalies.enabled = TRUE
	If Not i_str_pass.b[1] then
		i_str_pass.b[1]	= True
		p_fleche.Visible	= True
		PostEvent("ue_anomalies")
	End if
ELSE
	cb_anomalies.enabled = FALSE
END IF

// Y A T'IL DES LIGNES PROMOTIONNELLES 
IF i_nv_commande_object.fu_is_commande_avec_ligne_promo() THEN
	cb_promo.enabled = TRUE
ELSE
	cb_promo.enabled = FALSE
END IF

// RETRIEVE DE LA DTW
if dw_1.Retrieve (i_nv_commande_object.fu_get_numero_cde(),g_nv_come9par.get_code_langue()) = -1 then
	f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
end if

nv_client_object lnv_client
lnv_client = i_str_pass.po[1]

dw_1.setItem(1,"alerte",lnv_client.fu_get_alerte( ))
i_b_canceled = TRUE


end event

on w_fin_cde.create
int iCurrent
call super::create
this.cb_promo=create cb_promo
this.cb_anomalies=create cb_anomalies
this.cb_valorisation=create cb_valorisation
this.gb_1=create gb_1
this.pb_echap=create pb_echap
this.pb_ok=create pb_ok
this.p_fleche=create p_fleche
this.pb_affiche_ligne=create pb_affiche_ligne
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_promo
this.Control[iCurrent+2]=this.cb_anomalies
this.Control[iCurrent+3]=this.cb_valorisation
this.Control[iCurrent+4]=this.gb_1
this.Control[iCurrent+5]=this.pb_echap
this.Control[iCurrent+6]=this.pb_ok
this.Control[iCurrent+7]=this.p_fleche
this.Control[iCurrent+8]=this.pb_affiche_ligne
end on

on w_fin_cde.destroy
call super::destroy
destroy(this.cb_promo)
destroy(this.cb_anomalies)
destroy(this.cb_valorisation)
destroy(this.gb_1)
destroy(this.pb_echap)
destroy(this.pb_ok)
destroy(this.p_fleche)
destroy(this.pb_affiche_ligne)
end on

event key;call super::key;/* <DESC>
      Permet de trapper les touches de fonction activées et déclencher l'évènement associé
	à la touche.
	  F11 = Validation de la commande
   </DESC> */
	IF KeyDown(KeyF11!) THEN
		This.PostEvent ("ue_ok")
	END IF
end event

event ue_cancel;/* <DESC>
     Permet de quitter la fenetre sans effectuer la validation de la commande
	  et de retourner sur la liste d'origine
   </DESC> */
	
// OVERRIDE SCRIPT ANCESTOR
i_b_canceled = TRUE
i_str_pass.s_action = ACTION_OK
i_str_pass.po[2] = i_nv_commande_object
i_str_pass.s[2] = i_nv_commande_object.fu_get_numero_cde()
g_nv_workflow_manager.fu_affiche_liste_origine(i_str_pass)
Close (This)
end event

event ue_close;/* <DESC>
     Permet de quitter la fenetre sans effectuer la validation de la commande
	  et de retourner sur la liste d'origine
   </DESC> */
i_b_canceled = TRUE
i_str_pass.s_action = ACTION_OK
i_str_pass.po[2] = i_nv_commande_object
i_str_pass.s[2] = i_nv_commande_object.fu_get_numero_cde()
g_nv_workflow_manager.fu_affiche_liste_origine(i_str_pass)
Close (This)
end event

type uo_statusbar from w_a_udis`uo_statusbar within w_fin_cde
integer x = 0
integer y = 2516
end type

type dw_1 from w_a_udis`dw_1 within w_fin_cde
event mousemove pbm_mousemove
string tag = "A_TRADUIRE"
integer x = 55
integer y = 16
integer width = 2962
integer height = 536
integer taborder = 0
string dataobject = "d_entete_saisie_cde"
borderstyle borderstyle = styleshadowbox!
end type

event dw_1::mousemove;//if not isvalid(itooltip) then
//	itooltip = create n_tooltip_mgr
//end if
//itooltip.of_mousemove_notify(parent, this, getobjectatpointer(), this.x + xpos, this.y + ypos)
end event

type cb_promo from u_cba within w_fin_cde
integer x = 946
integer y = 664
integer width = 823
integer height = 96
integer taborder = 0
boolean bringtotop = true
integer textsize = -8
fontcharset fontcharset = ansi!
string text = "P&romotions"
end type

event constructor;call super::constructor;
// DECLENCHEMENT DE L'EVENEMENT AU NIVEAU DE LA FENÊTRE
	This.fu_setevent ("ue_promo_cde")
end event

type cb_anomalies from u_cba within w_fin_cde
integer x = 946
integer y = 812
integer width = 823
integer height = 96
integer taborder = 0
boolean bringtotop = true
integer textsize = -8
fontcharset fontcharset = ansi!
string text = "Lignes en &anomalies"
end type

event constructor;call super::constructor;
// DECLENCHEMENT DE L'EVENEMENT AU NIVEAU DE LA FENÊTRE
	This.fu_setevent ("ue_anomalies")
end event

type cb_valorisation from u_cba within w_fin_cde
integer x = 946
integer y = 960
integer width = 823
integer height = 96
integer taborder = 0
boolean bringtotop = true
integer textsize = -8
fontcharset fontcharset = ansi!
boolean enabled = false
string text = "&Valorisation de la commande"
end type

event constructor;call super::constructor;
// DECLENCHEMENT DE L'EVENEMENT AU NIVEAU DE LA FENÊTRE
	This.fu_setevent ("ue_valorisation")
end event

type gb_1 from groupbox within w_fin_cde
string tag = "NO_TEXT"
integer x = 859
integer y = 556
integer width = 992
integer height = 568
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 12632256
end type

type pb_echap from u_pba_echap within w_fin_cde
integer x = 1920
integer y = 1184
integer taborder = 0
string picturename = "c:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type pb_ok from u_pba_ok within w_fin_cde
integer x = 489
integer y = 1180
integer taborder = 0
string text = "Valid.  F11"
boolean default = false
string picturename = "c:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type p_fleche from picture within w_fin_cde
boolean visible = false
integer x = 530
integer y = 808
integer width = 347
integer height = 104
boolean bringtotop = true
string picturename = "c:\appscir\Erfvmr_diva\Image\FLECHE1.BMP"
boolean focusrectangle = false
end type

type pb_affiche_ligne from u_pba within w_fin_cde
integer x = 1225
integer y = 1180
integer width = 370
integer height = 168
integer taborder = 10
string facename = "Arial"
string text = "Aff. &Lignes"
string picturename = "c:\appscir\Erfvmr_diva\Image\PB_SAICD.BMP"
end type

on constructor;call u_pba::constructor;
// -------------------------------------------------------
// DECLENCHEMENT DE L'EVENEMENT AU NIVEAU DE LA FENÊTRE 
// -------------------------------------------------------
	fu_setevent ("ue_affiche_ligne")
	fu_set_MicroHelp ("Affihage de toutes les lignes de cde")

end on

