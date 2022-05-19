$PBExportHeader$w_situation_cpt_client.srw
$PBExportComments$Permet l'affichage de la situation comptable du client (facture non soldées)
forward
global type w_situation_cpt_client from w_a_mas_det
end type
type pb_changer_client from u_pba_changer within w_situation_cpt_client
end type
type pb_sai_cmde from u_pba_sai_cmde within w_situation_cpt_client
end type
type pb_reliquat from u_pba_reliquat within w_situation_cpt_client
end type
type pb_echap from u_pba_echap within w_situation_cpt_client
end type
type pb_fiche_client from u_pba_client within w_situation_cpt_client
end type
type pb_impression from u_pba within w_situation_cpt_client
end type
type st_texte_factor from statictext within w_situation_cpt_client
end type
end forward

global type w_situation_cpt_client from w_a_mas_det
string tag = "SITUATION_COMPTE"
integer x = 0
integer y = 0
integer width = 3584
integer height = 2208
string title = "Situation du compte client"
boolean minbox = false
boolean maxbox = false
long backcolor = 12632256
boolean ib_statusbar_visible = true
event ue_planning pbm_custom41
event ue_reliquat pbm_custom43
event ue_changer pbm_custom46
event ue_client pbm_custom47
event ue_ligne_cde pbm_custom49
event ue_workflow ( )
pb_changer_client pb_changer_client
pb_sai_cmde pb_sai_cmde
pb_reliquat pb_reliquat
pb_echap pb_echap
pb_fiche_client pb_fiche_client
pb_impression pb_impression
st_texte_factor st_texte_factor
end type
global w_situation_cpt_client w_situation_cpt_client

forward prototypes
public subroutine fw_retrieve ()
public subroutine fw_is_client_donneur_ordre ()
public function any fw_selection_client (any as_structure)
end prototypes

event ue_reliquat;/* <DESC>
    Affichage de la fenêtre  du carnet de commande du client en cours
</DESC> */
	i_str_pass.s_action = "O"
	g_s_fenetre_destination = FENETRE_CARNET_CDE_CLIENT
	triggerEvent("ue_workflow")

end event

event ue_changer;/* <DESC> 
    Permet de changer de client en appelant la fenêtre de sélection
</DESC> */
// SELECTION DU CLIENT
Str_pass		str_work

str_work = fw_selection_client (str_work)
if str_work.s_action = ACTION_OK then
	i_str_pass = str_work
	fw_retrieve()
	dw_1.SetFocus()	
	fw_is_client_donneur_ordre()
end if

end event

event ue_client;/* <DESC> 
    Permet d'afficher la fiche principale du client
</DESC> */
	i_str_pass.s_action = ACTION_OK
	g_s_fenetre_destination = FENETRE_CLIENT
	triggerEvent("ue_workflow")	
	
end event

event ue_ligne_cde;/* <DESC>
    Affichage de la fenêtre de création d'une nouvelle commande pour le client en
    initialisant l'object commande à vide.
</DESC> */
// Creation d'une nouvelle commande
nv_commande_object l_commande
l_commande = CREATE nv_commande_object
i_str_pass.po[2] = l_commande	
i_str_pass.s[2] = DONNEE_VIDE

g_s_fenetre_destination = FENETRE_LIGNE_CDE
triggerEvent("ue_workflow")

end event

event ue_workflow();/* <DESC>
    Cet evenement est appelé lors de la sélection d'une option dans le menu alors que cette
	 fenêtre est la fenêtre active et va lancer le workflow manager pour effectuer l'enchainement.
</DESC> */
g_nv_workflow_manager.fu_check_workflow(FENETRE_COMPTE_CLIENT, i_str_pass)
close(this)
end event

public subroutine fw_retrieve ();/* <DESC>
     Effectue l'extraction des données dans les datawindows 
   </DESC> */
decimal ld_ecr_fact
decimal ld_det_fact

dw_mas.SetRedraw(FALSE)
dw_1.SetRedraw(FALSE)

if dw_mas.Retrieve(i_str_pass.s[1]) = -1 then
	f_dmc_error (this.title + & 
						 BLANK + &
						 DB_ERROR_MESSAGE)
end if

if dw_1.Retrieve(i_str_pass.s[1]) = -1 then
	f_dmc_error (this.title + & 
						 BLANK + &
						 DB_ERROR_MESSAGE)
end if
					

dw_mas.SetRedraw(TRUE)
dw_1.SetRedraw(TRUE)

if isnull( dw_mas.GetItemDecimal(1,DBNAME_ECRAECLF_FACTOR)) then
   ld_ecr_fact = 0
else
   ld_ecr_fact = dw_mas.GetItemDecimal(1,DBNAME_ECRAECLF_FACTOR)
end if

if isnull( dw_mas.GetItemDecimal(1,DBNAME_DETAEECH_FACTOR)) then
   ld_det_fact = 0
else
   ld_det_fact = dw_mas.GetItemDecimal(1,DBNAME_DETAEECH_FACTOR)
end if

if ld_ecr_fact > 0 then
	st_texte_factor.text = g_nv_traduction.get_traduction( MONTANT_EC_FACTOR_DIFF_ZERO)
end if

fw_is_client_donneur_ordre()
end subroutine

public subroutine fw_is_client_donneur_ordre ();/* <DESC>
    Controle si la nature du client permet la création de commande ou non. 
    Si ce n'est pas le cas le bouton sera caché.
</DESC> */
nv_client_object  l_client
l_client = i_str_pass.po[1]

if l_client.is_donneur_ordre() then
  	pb_sai_cmde.visible = true
else
	pb_sai_cmde.visible = false
end if

end subroutine

public function any fw_selection_client (any as_structure);/* <DESC>
      Permet d'afficher la fenêtre de sélection des clients
   </DESC> */
str_pass l_str_work
return g_nv_workflow_manager.fu_ident_client(false, as_structure)
end function

event ue_init;call super::ue_init;/* <DESC>
    Prépare l'affichage de la fenêtre. Si aucun client n'a été sélectionné affichage de la fenêtre de sélection
   puis affichage des données du client.
</DESC> */

dw_1.fu_set_selection_mode (1)
i_str_pass = fw_selection_client (i_str_pass)
CHOOSE CASE i_str_pass.s_action
	CASE ACTION_OK
		fw_retrieve()
	CASE ACTION_CANCEL
		This.TriggerEvent ("ue_cancel")
		RETURN
END CHOOSE

g_nv_trace.fu_write_trace( this.classname( ), "ue_ini",i_str_pass.s[01], i_str_pass.s[02], this.classname( ) , g_s_fenetre_destination)

end event

on w_situation_cpt_client.create
int iCurrent
call super::create
this.pb_changer_client=create pb_changer_client
this.pb_sai_cmde=create pb_sai_cmde
this.pb_reliquat=create pb_reliquat
this.pb_echap=create pb_echap
this.pb_fiche_client=create pb_fiche_client
this.pb_impression=create pb_impression
this.st_texte_factor=create st_texte_factor
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_changer_client
this.Control[iCurrent+2]=this.pb_sai_cmde
this.Control[iCurrent+3]=this.pb_reliquat
this.Control[iCurrent+4]=this.pb_echap
this.Control[iCurrent+5]=this.pb_fiche_client
this.Control[iCurrent+6]=this.pb_impression
this.Control[iCurrent+7]=this.st_texte_factor
end on

on w_situation_cpt_client.destroy
call super::destroy
destroy(this.pb_changer_client)
destroy(this.pb_sai_cmde)
destroy(this.pb_reliquat)
destroy(this.pb_echap)
destroy(this.pb_fiche_client)
destroy(this.pb_impression)
destroy(this.st_texte_factor)
end on

event ue_print;/* <DESC>
    Permet l'impression de le fiche de suivi comptable du client.
</DESC> */
IF dw_1.AcceptText () < 0 THEN
	RETURN
END IF

Datastore ds_print_client
ds_print_client = CREATE Datastore
ds_print_client.DataObject = "d_impression_fiche_suivi_comptable"
ds_print_client.setTransObject (sqlca)

ds_print_client.retrieve(i_str_pass.s[1])

g_nv_traduction.set_traduction_datastore( ds_print_client)
ds_print_client.Print()
destroy ds_print_client
end event

event ue_cancel;/* <DESC>
     Permet de quitter la fenêtre en retournant sur la fenêtre d'origine en appelant le workflow manager
</DESC> */
i_b_canceled = TRUE
g_nv_workflow_manager.fu_cancel_option( i_str_pass)
close (this)
end event

type uo_statusbar from w_a_mas_det`uo_statusbar within w_situation_cpt_client
end type

type dw_1 from w_a_mas_det`dw_1 within w_situation_cpt_client
string tag = "A_TRADUIRE"
integer x = 59
integer y = 804
integer width = 2971
integer height = 820
integer taborder = 10
string dataobject = "d_situation_cpt_client"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type dw_mas from w_a_mas_det`dw_mas within w_situation_cpt_client
string tag = "A_TRADUIRE"
integer x = 197
integer y = 12
integer width = 2706
integer height = 676
integer taborder = 0
string dataobject = "d_client_entete_situation"
end type

type pb_changer_client from u_pba_changer within w_situation_cpt_client
integer x = 471
integer y = 1652
integer height = 168
integer taborder = 0
boolean originalsize = false
string picturename = "C:\appscir\Erfvmr_diva\Image\pbchange.bmp"
string disabledname = "C:\appscir\Erfvmr_diva\Image\pbchange.bmp"
end type

type pb_sai_cmde from u_pba_sai_cmde within w_situation_cpt_client
integer x = 1975
integer y = 1652
integer height = 168
integer taborder = 0
boolean originalsize = false
string picturename = "C:\appscir\Erfvmr_diva\Image\pb_saicd.bmp"
end type

type pb_reliquat from u_pba_reliquat within w_situation_cpt_client
integer x = 901
integer y = 1652
integer width = 379
integer height = 168
integer taborder = 0
string text = "C&arnet cde"
boolean originalsize = false
string picturename = "C:\appscir\Erfvmr_diva\Image\pbreliqu.bmp"
string disabledname = "C:\appscir\Erfvmr_diva\Image\pbreliqu.bmp"
end type

type pb_echap from u_pba_echap within w_situation_cpt_client
integer x = 2363
integer y = 1652
integer taborder = 0
string picturename = "C:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type pb_fiche_client from u_pba_client within w_situation_cpt_client
integer x = 119
integer y = 1652
integer width = 334
integer height = 168
integer taborder = 0
string text = "&Client"
boolean originalsize = false
string picturename = "C:\appscir\Erfvmr_diva\Image\pbclient.bmp"
string disabledname = "C:\appscir\Erfvmr_diva\Image\pbclient.bmp"
alignment htextalign = right!
end type

type pb_impression from u_pba within w_situation_cpt_client
integer x = 1358
integer y = 1652
integer width = 334
integer height = 168
integer taborder = 11
boolean bringtotop = true
string facename = "Arial"
string text = "&Impression"
string picturename = "C:\appscir\Erfvmr_diva\Image\PB_IMP.BMP"
end type

event constructor;call super::constructor;
// ------------------------------------------------------
// DECLENCHEMENT DE L'EVENEMENT AU NIVEAU DE LA FENÊTRE
// ------------------------------------------------------
	fu_setevent ("ue_print")

// ------------------------------------------------------
// TEXTE DE LA MICROHELP
// ------------------------------------------------------
	fu_set_microhelp ("Impression situation comptable  client")
end event

type st_texte_factor from statictext within w_situation_cpt_client
string tag = "NO_TEXT"
integer x = 759
integer y = 716
integer width = 1495
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean focusrectangle = false
end type

