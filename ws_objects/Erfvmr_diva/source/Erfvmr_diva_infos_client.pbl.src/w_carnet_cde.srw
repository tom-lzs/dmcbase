$PBExportHeader$w_carnet_cde.srw
$PBExportComments$Permet l'affichage du carnet de commande du client
forward
global type w_carnet_cde from w_a_pick_list_det
end type
type pb_changer_client from u_pba_changer within w_carnet_cde
end type
type pb_fiche_client from u_pba_client within w_carnet_cde
end type
type pb_cpt_client from u_pba_cpt_client within w_carnet_cde
end type
type pb_sai_cmde from u_pba_sai_cmde within w_carnet_cde
end type
type pb_echap from u_pba_echap within w_carnet_cde
end type
end forward

global type w_carnet_cde from w_a_pick_list_det
string tag = "CARNET_CDE"
integer x = 837
integer y = 512
integer width = 3273
integer height = 2072
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
long backcolor = 12632256
boolean ib_statusbar_visible = true
event ue_workflow ( )
event ue_ligne_cde pbm_custom49
event ue_changer pbm_custom46
event ue_client pbm_custom47
event ue_cpt_client pbm_custom50
pb_changer_client pb_changer_client
pb_fiche_client pb_fiche_client
pb_cpt_client pb_cpt_client
pb_sai_cmde pb_sai_cmde
pb_echap pb_echap
end type
global w_carnet_cde w_carnet_cde

type variables
nv_client_object  i_client
String is_fenetre_origine = BLANK
end variables

forward prototypes
public function any fw_selection_client (any as_structure)
public subroutine fw_is_client_donneur_ordre ()
end prototypes

event ue_workflow();/* <DESC>
    Cet evenement est appelé lors de la sélection d'une option dans le menu alors que cette
	 fenetre est la fenetre active et va lancer le workflow manager pour effetuer l'enchainement.
</DESC> */
g_nv_workflow_manager.fu_check_workflow(FENETRE_CARNET_CDE_CLIENT, i_str_pass)
close(this)
end event

event ue_ligne_cde;/* <DESC>
    Affichage de la fenêtre de création d'une nouvelle commande pour le client en
    initialisant l'object commande à vide.
</DESC> */
nv_commande_object l_commande
l_commande = CREATE nv_commande_object
i_str_pass.po[2] = l_commande	
i_str_pass.s[2] = DONNEE_VIDE

g_s_fenetre_destination = FENETRE_LIGNE_CDE
triggerEvent("ue_workflow")

end event

event ue_changer;/* <DESC> 
    Permet de changer de client en appelant la fenetre de sélection
</DESC> */
Str_pass		str_work

str_work = fw_selection_client (str_work)
if str_work.s_action = ACTION_OK then
	i_str_pass = str_work
	dw_1.SetFocus()	
	fw_is_client_donneur_ordre()
	i_client = i_str_pass.po[1]
	
	dw_pick.retrieve(i_str_pass.s[01])
end if

end event

event ue_client; /* <DESC> 
    Permet d'afficher la fiche principale du client
</DESC> */
	i_str_pass.s_action = ACTION_OK
	g_s_fenetre_destination = FENETRE_CLIENT
	triggerEvent("ue_workflow")

end event

event ue_cpt_client;/* <DESC> 
    Permet d'afficher la situation comptable du client
</DESC> */
	i_str_pass.s_action = ACTION_OK
	g_s_fenetre_destination = FENETRE_COMPTE_CLIENT
	triggerEvent("ue_workflow")

end event

public function any fw_selection_client (any as_structure);/* <DESC>
    Effectuer l'appel de l'affichage de la sélection du client
</DESC> */
// SELECTION DU CLIENT 
str_pass l_str_work
return g_nv_workflow_manager.fu_ident_client(false, as_structure)
end function

public subroutine fw_is_client_donneur_ordre ();/* <DESC>
    Controle si la nature du client permet la création de commande ou non. 
    Si ce n'est pas le cas le bouton sera caché.
</DESC> */
if i_client.is_donneur_ordre() then
 	pb_sai_cmde.visible = true
end if
	
end subroutine

event ue_cancel;/* <DESC>
   Permet de quitter la consultation et de revenir à la fenetre d'origine.
</DESC> */
i_b_canceled = TRUE
g_nv_workflow_manager.fu_cancel_option( i_str_pass)
close (this)
end event

on w_carnet_cde.create
int iCurrent
call super::create
this.pb_changer_client=create pb_changer_client
this.pb_fiche_client=create pb_fiche_client
this.pb_cpt_client=create pb_cpt_client
this.pb_sai_cmde=create pb_sai_cmde
this.pb_echap=create pb_echap
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_changer_client
this.Control[iCurrent+2]=this.pb_fiche_client
this.Control[iCurrent+3]=this.pb_cpt_client
this.Control[iCurrent+4]=this.pb_sai_cmde
this.Control[iCurrent+5]=this.pb_echap
end on

on w_carnet_cde.destroy
call super::destroy
destroy(this.pb_changer_client)
destroy(this.pb_fiche_client)
destroy(this.pb_cpt_client)
destroy(this.pb_sai_cmde)
destroy(this.pb_echap)
end on

event open;call super::open;/* <DESC>
     Sauvegarde la fenêtre d'origine de l'appel de la consultation du carnet de commande
   </DESC> */
is_fenetre_origine = g_nv_workflow_manager.fu_get_fenetre_origine()
end event

event closequery;/* <DESC> 
     Overwrite uniquement du script de l'ancetre
   </DESC> */
// Overwrite
end event

event ue_init;call super::ue_init;/* <DESC>
    Prépare l'affichage de la fenêtre. Si aucun client n'a été sélectionné affichage de la fenêtre de sélection
   puis affichage des données du client.
</DESC> */

dw_1.fu_set_selection_mode (1)

i_str_pass = fw_selection_client (i_str_pass)
CHOOSE CASE i_str_pass.s_action
	CASE ACTION_OK
		dw_pick.retrieve(i_str_pass.s[01])
          i_client = i_str_pass.po[1]
		
	CASE ACTION_CANCEL
		This.TriggerEvent ("ue_cancel")
		RETURN
END CHOOSE

g_nv_trace.fu_write_trace( this.classname( ), "ue_ini",i_str_pass.s[01], i_str_pass.s[02], this.classname( ) , g_s_fenetre_destination)
end event

event ue_retrieve;call super::ue_retrieve;/* <DESC>
    Permet d'afficher les lignes de la commande sélectionnée.
</DESC> */
if dw_pick.getRow() > 0 then
	dw_1.retrieve(i_str_pass.s[01],dw_pick.getItemString(dw_pick.getRow(),DBNAME_NUMCDE_SAP))
	if len(trim(dw_1.getItemString(1,DBNAME_UCC))) > 0 then
	     dw_1.setitem(1,DBNAME_UCC_INTITULE,g_nv_traduction.get_traduction_code( "COME9008",dw_1.getItemString(1,DBNAME_UCC)))
      end if
end if

end event

type uo_statusbar from w_a_pick_list_det`uo_statusbar within w_carnet_cde
end type

type dw_1 from w_a_pick_list_det`dw_1 within w_carnet_cde
string tag = "A_TRADUIRE"
integer x = 91
integer y = 524
integer width = 2793
integer height = 1072
integer taborder = 30
string dataobject = "d_detail_carnet_cde"
boolean vscrollbar = true
end type

event dw_1::rowfocuschanged;
// ---------------------------------
// RETRIEVE DE LA DTW NUANCE
// ---------------------------------
//	Parent.TriggerEvent ("ue_fileopen")
this.SelectRow (0, FALSE)
this.SelectRow (getRow(), TRUE)
end event

event dw_1::we_dwnkey;call super::we_dwnkey;
// RENVOIE A L'EVENEMENT KEY DE LA FENÊTRE
//	f_activation_key ()
	f_key(Parent)
end event

event dw_1::getfocus;call super::getfocus;
// VISUALISATION DE LA RECEPTION DU FOCUS
	This.BorderStyle = StyleLowered!
end event

event dw_1::losefocus;call super::losefocus;
// VISUALISATION DE LA PERTE DU FOCUS
	This.BorderStyle = StyleBox!
end event

type dw_pick from w_a_pick_list_det`dw_pick within w_carnet_cde
string tag = "A_TRADUIRE"
integer x = 174
integer y = 16
integer width = 2519
integer height = 456
integer taborder = 10
string dataobject = "d_entete_carnet_cde"
boolean vscrollbar = true
end type

event dw_pick::getfocus;call super::getfocus;
// VISUALISATION DE LA RECEPTION DU FOCUS
	This.BorderStyle = StyleLowered!
end event

event dw_pick::we_dwnkey;call super::we_dwnkey;
// RENVOIE A L'EVENEMENT KEY DE LA FENÊTRE
//	f_activation_key ()
	f_key(Parent)
end event

event dw_pick::losefocus;call super::losefocus;
// VISUALISATION DE LA PERTE DU FOCUS
	This.BorderStyle = StyleBox!
end event

event dw_pick::rowfocuschanged;
this.SelectRow(0,FALSE)
this.SelectRow ( this.GetRow (), TRUE)

parent.TriggerEvent ("ue_retrieve")
		
end event

type pb_changer_client from u_pba_changer within w_carnet_cde
integer x = 805
integer y = 1640
integer taborder = 11
boolean bringtotop = true
string picturename = "C:\appscir\Erfvmr_diva\Image\PBCHANGE.BMP"
string disabledname = "C:\appscir\Erfvmr_diva\Image\PBCHANGE.BMP"
end type

type pb_fiche_client from u_pba_client within w_carnet_cde
integer x = 421
integer y = 1640
integer width = 347
integer height = 168
integer taborder = 11
boolean bringtotop = true
boolean enabled = false
string text = "&Client"
boolean originalsize = false
string picturename = "C:\appscir\Erfvmr_diva\Image\pbclient.bmp"
string disabledname = "C:\appscir\Erfvmr_diva\Image\pbclient.bmp"
alignment htextalign = right!
end type

type pb_cpt_client from u_pba_cpt_client within w_carnet_cde
integer x = 1179
integer y = 1640
integer height = 168
integer taborder = 11
boolean bringtotop = true
string text = "C&ompte"
boolean default = true
boolean originalsize = false
string picturename = "C:\appscir\Erfvmr_diva\Image\pbcptcli.bmp"
string disabledname = "C:\appscir\Erfvmr_diva\Image\pbcptcli.bmp"
end type

type pb_sai_cmde from u_pba_sai_cmde within w_carnet_cde
boolean visible = false
integer x = 1915
integer y = 1640
integer height = 168
integer taborder = 21
boolean bringtotop = true
boolean originalsize = false
string picturename = "C:\appscir\Erfvmr_diva\Image\pb_saicd.bmp"
end type

type pb_echap from u_pba_echap within w_carnet_cde
integer x = 2313
integer y = 1636
integer taborder = 11
boolean bringtotop = true
string picturename = "C:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

