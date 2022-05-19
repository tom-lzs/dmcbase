$PBExportHeader$w_selection_commandes.srw
$PBExportComments$Permet de sélectionner les commandes à transférer au serveur pour intégration
forward
global type w_selection_commandes from w_a_udim
end type
type pb_ok from u_pba_ok within w_selection_commandes
end type
type pb_echap from u_pba_echap within w_selection_commandes
end type
end forward

global type w_selection_commandes from w_a_udim
string tag = "SELECTION_CDES"
integer width = 2757
integer height = 1708
string title = "Liste des commandes à transférer"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
long backcolor = 12632256
pb_ok pb_ok
pb_echap pb_echap
end type
global w_selection_commandes w_selection_commandes

event ue_init;call super::ue_init;/* <DESC>
      Extraction des commandes associées au visiteur pour effectuer le transfert.
		Par défaut toutes les commandes sont positionnées pour transfert.
   </DESC> */
Long ll_row

i_str_pass = Message.fnv_get_str_pass()
dw_1.retrieve (g_s_visiteur)

if dw_1.rowcount() = 0 then
	pb_ok.visible = false
end if

setfocus()
end event

on w_selection_commandes.create
int iCurrent
call super::create
this.pb_ok=create pb_ok
this.pb_echap=create pb_echap
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_ok
this.Control[iCurrent+2]=this.pb_echap
end on

on w_selection_commandes.destroy
call super::destroy
destroy(this.pb_ok)
destroy(this.pb_echap)
end on

event ue_ok;/*<DESC>
  Validation de la sélection des commandes à transférer.
  <LI> Suppression du contenu de la table come9cdt
  <LI> Chaque commande sélectionnée , le n° de commande sera stocké dans la table come90cdt
  <LI> si aucune commnde n'est sélectionnée, affichage d'une message d'alerte
 </DESC> */

// Overwrite
nv_datastore ds_cde_a_transferer
Long ll_row, ll_new_row
String ls_numcde

ds_cde_a_transferer = CREATE nv_datastore
ds_cde_a_transferer.dataobject = "d_come9cdt"
ds_cde_a_transferer.settrans( sqlca )
ds_cde_a_transferer.retrieve()

//ll_row =  ds_cde_a_transferer.rowcount()
//do while ll_row > 0
//	 ds_cde_a_transferer.deleterow (ll_row)
//	 ll_row --
//loop
//ds_cde_a_transferer.update()
//ds_cde_a_transferer.retrieve()

ll_new_row = 0
for ll_row = 1 to dw_1.rowcount()

		ll_new_row ++
		ds_cde_a_transferer.insertrow(ll_new_row)
		ds_cde_a_transferer.setItem(ll_new_row, DBNAME_DATE_CREATION, sqlca.fnv_get_datetime( ))
		if dw_1.getItemString(ll_row,"ctransfert") = "O" then
		      ds_cde_a_transferer.setItem (ll_new_row, DBNAME_CODE_MAJ, CODE_CREATION)
			else
				ds_cde_a_transferer.setItem (ll_new_row, DBNAME_CODE_MAJ, CODE_SUPPRESSION)
	    end if
		ds_cde_a_transferer.setItem(ll_new_row, DBNAME_CODE_VISITEUR, g_s_visiteur)
		 ls_numcde = dw_1.getItemString(ll_row,DBNAME_NUM_CDE)
		ds_cde_a_transferer.setItem(ll_new_row, DBNAME_NUM_CDE, ls_numcde )
		ds_cde_a_transferer.setItem(ll_new_row, DBNAME_DATE_SAISIE_CDE, dw_1.getItemDateTime(ll_row, DBNAME_DATE_SAISIE_CDE))
next
if ds_cde_a_transferer.update() = -1 then
	f_dmc_error ("Commande Object" + BLANK + DB_ERROR_MESSAGE + " " + ds_cde_a_transferer.uf_getdberror() )
end if


if ll_new_row = 0 then
  MessageBox(This.Title, g_nv_traduction.get_traduction ("AUCUNE_CDE_SELECTIONNEEs"), information!,ok!)
   return
end if

i_str_pass.d[1] = dw_1.rowcount()
i_str_pass.d[2] = ll_new_row

i_b_update_status = true
i_b_canceled = TRUE
i_str_pass.s_action = ACTION_OK
Message.fnv_set_str_pass(i_str_pass)
close(this)

end event

event ue_cancel;//overwrite
/* <DESC>
    Permet de quitter l'application sans selection des commandes
   </DESC> */
	
i_str_pass.s_action = ACTION_CANCEL
i_b_canceled = TRUE
i_str_pass.s[1] = "Abandon de la sélection des commandes"
Message.fnv_set_str_pass(i_str_pass)
Close (this)
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

type uo_statusbar from w_a_udim`uo_statusbar within w_selection_commandes
end type

type dw_1 from w_a_udim`dw_1 within w_selection_commandes
string tag = "A_TRADUIRE"
integer width = 2642
integer height = 1324
string dataobject = "d_liste_cde_a_transferer"
boolean vscrollbar = true
end type

event dw_1::we_dwnkey;call super::we_dwnkey;//Captage des touches de fonction par le contrôle et renvoie à l'évènement KEY de la fenêtre
//	f_activation_key() 
	f_key(Parent)
end event

type pb_ok from u_pba_ok within w_selection_commandes
integer x = 521
integer y = 1432
integer taborder = 11
boolean bringtotop = true
string picturename = "C:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_echap from u_pba_echap within w_selection_commandes
integer x = 1787
integer y = 1432
integer taborder = 11
boolean bringtotop = true
string picturename = "C:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

