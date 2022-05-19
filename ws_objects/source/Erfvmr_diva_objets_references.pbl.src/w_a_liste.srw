$PBExportHeader$w_a_liste.srw
$PBExportComments$Ancêtre - Fenêtre de liste
forward
global type w_a_liste from w_a_pick_one
end type
type pb_ok from u_pba_ok within w_a_liste
end type
type pb_echap from u_pba_echap within w_a_liste
end type
end forward

global type w_a_liste from w_a_pick_one
integer width = 1344
integer height = 988
long backcolor = 12632256
pb_ok pb_ok
pb_echap pb_echap
end type
global w_a_liste w_a_liste

type variables
String is_colonne_prec = BLANK
String is_ordre_tri    = "A"
String is_codtab
String is_code
String is_lib
String is_argument
Boolean ib_liste_a_traduire = True
Boolean ib_arg_a_passer = False

nv_commande_object  inv_commande
nv_client_object    inv_client
long			il_row_encours = 1
end variables

forward prototypes
public subroutine fw_complete_structure ()
public function boolean fw_controle_cde (string as_event)
public subroutine fu_ini_param (string a_s_codtab, string a_s_code, string a_s_lib)
public subroutine fu_ne_pas_traduire ()
public subroutine fu_ini_retrieve_arg (string a_s_argument)
end prototypes

public subroutine fw_complete_structure ();/* <DESC>
   Cette fonction est utilisée par 2 fenêtres de liste des commandes
    Permet d'initialiser la structure str-pass avec l'objet client et de l'objet commande
   de la commande sélectionnée.
   </DESC> */
inv_client = CREATE nv_client_object
inv_commande = CREATE nv_commande_object

if dw_1.GetRow() = 0 then
	il_row_encours= 0
	i_str_pass.po[1] = inv_client
     i_str_pass.s[1] = ""
     i_str_pass.po[2] = inv_commande		  
      i_str_pass.s[2] = ""
		return
end if
if dw_1.GetItemString (dw_1.getRow(), "etat") <>"I" then
	inv_client.fu_retrieve_client(dw_1.GetItemString (dw_1.GetRow(), DBNAME_CLIENT_CODE))
	i_str_pass.po[1] = inv_client
	i_str_pass.s[1] = inv_client.fu_get_code_client()
end if

inv_commande = CREATE nv_commande_object
inv_commande.fu_set_numero_cde(dw_1.GetItemString (dw_1.GetRow(), DBNAME_NUM_CDE))
inv_commande.fu_controle_numero_cde(inv_client)
i_str_pass.po[2] = inv_commande	
i_str_pass.s[2] = (dw_1.GetItemString (dw_1.GetRow(), DBNAME_NUM_CDE))

il_row_encours = dw_1.GetRow()
end subroutine

public function boolean fw_controle_cde (string as_event);/* <DESC> 
    Permet d'effectuer des contrôles de la commande sélectionnée sur les fenêtre de liste des commandes et
    ceci en fonction du code état de la commande et en fonction de l'opération a effectuée.
	Cette fonction est appelée lors de la suppression d'une commande, de l'impression du bon de commande,
	de la modification du client, du traitement des lignes indirectes, modification de la commande.
	  Si suppression d 'une commande sur un client inexistant, aucune controle n'est à effectuer
	  Si client inexistant et fonction autre que suppression et modification client,
	       affichage d'un message d'anomalie et fin du controle
	  Si impression ou affichage message commande, aucun controle n'est effectué.
	  Controle que la commande ne soit pas validée et ni transférée, sinon affichage de message d'anomalie et fin du controle
   </DESC> */
integer li_reponse

 if as_event = "ue_delete" and  dw_1.GetItemString (dw_1.getRow(), "etat") = "I"  then
	 return true
end if

if as_event <> "ue_delete" and as_event <> "ue_modif_client" then
	IF dw_1.GetItemString (dw_1.getRow(), "etat") = "I" THEN
		messagebox (This.title,g_nv_traduction.get_traduction(OPERATION_CLIENT_INEXISTANT),StopSign!,Ok!,1)
		dw_1.SetFocus ()
		RETURN false
	END IF
end if

fw_complete_structure()

if as_event = "ue_print" or  as_event = "ue_message"  or as_event = "ue_lignes_indirectes"  then
	return true
end if

IF inv_commande.fu_is_commande_validee() THEN
	messagebox (this.title, g_nv_traduction.get_traduction(ACCES_COMMANDE_IMPOSSIBLE),StopSign!,Ok!,1)
	dw_1.SetFocus ()
	RETURN false
END IF

IF  inv_commande.fu_is_commande_transferee() THEN
	messagebox (This.title,g_nv_traduction.get_traduction(ACCES_COMMANDE_IMPOSSIBLE),StopSign!,Ok!,1)
	dw_1.SetFocus ()
	RETURN false
END IF
return true
end function

public subroutine fu_ini_param (string a_s_codtab, string a_s_code, string a_s_lib);is_codtab = a_s_codtab
is_code = a_s_code
is_lib = a_s_lib
end subroutine

public subroutine fu_ne_pas_traduire ();ib_liste_a_traduire = False
end subroutine

public subroutine fu_ini_retrieve_arg (string a_s_argument);is_argument = a_s_argument
ib_arg_a_passer = True
end subroutine

on w_a_liste.create
int iCurrent
call super::create
this.pb_ok=create pb_ok
this.pb_echap=create pb_echap
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_ok
this.Control[iCurrent+2]=this.pb_echap
end on

on w_a_liste.destroy
call super::destroy
destroy(this.pb_ok)
destroy(this.pb_echap)
end on

event ue_init;call super::ue_init;/* <DESC>
     Initialisation de l'affichage de la fenêtre en affichant la liste des données
   </DESC> */
long ll_indice
long ll_row


//nv_datastore ds_traduction
//ds_traduction = CREATE nv_datastore
//ds_traduction.dataobject = "d_param_langue"
//ds_traduction.settrans( i_tr_sql)
//
 dw_1.visible = false
 
If not ib_arg_a_passer then
   if dw_1.Retrieve (g_nv_come9par.get_code_langue()) = -1 then
	f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
   end if
else 
   if dw_1.Retrieve (is_argument,g_nv_come9par.get_code_langue()) = -1 then
	f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
   end if
end if

if not ib_liste_a_traduire then
	goto fin
end if

// ds_traduction.retrieve(is_codtab,g_nv_come9par.get_code_langue())
// 
//
//if dw_1.rowCount() > 0 then
//	for ll_indice = 1 to dw_1.rowcount()
//		ll_row = ds_traduction.find ("CODPARAM = '" + dw_1.getItemstring(ll_indice,is_code) + "'",1,ds_traduction.rowcount())
//		if ll_row > 0 then
//			dw_1.setitem(ll_indice, is_lib, ds_traduction.getitemstring(ll_row,"VALPARAM"))
//		end if
//	
//	next
//end if

Fin:
dw_1.visible = true
	
if dw_1.rowCount() > 0 then
	dw_1.setRow(1)
	dw_1.setfocus()
	dw_1.fu_set_sort_on_label (True)		
end if
		
end event

event ue_cancel;call super::ue_cancel;/* <DESC>
    Permet de quitter la fenêtre sans effectuer de sélection
   </DESC> */
	Message.fnv_set_str_pass(i_str_pass)
	Close (This)
end event

event ue_ok;call super::ue_ok;/* <DESC>
      Validation de la sélection. Alimentation de la structure du code sélectionné ainsi que de l'intitulé.
   </DESC> */
Long		l_row
l_row		= dw_1.GetRow()

if l_row = 0 then
	return
end if

i_str_pass.s[1] = dw_1.GetItemString (l_row, 1)
i_str_pass.s[2] = dw_1.GetItemString (l_row, 2) 

Message.fnv_set_str_pass(i_str_pass)
Close (This)
end event

event key;call super::key;	IF KeyDown(KeyF11!) THEN
		This.PostEvent ("ue_ok")
	END IF

end event

type uo_statusbar from w_a_pick_one`uo_statusbar within w_a_liste
end type

type cb_cancel from w_a_pick_one`cb_cancel within w_a_liste
boolean visible = false
integer taborder = 50
boolean enabled = false
boolean cancel = false
end type

type cb_ok from w_a_pick_one`cb_ok within w_a_liste
boolean visible = false
integer x = 119
integer y = 576
integer taborder = 30
boolean enabled = false
boolean default = false
end type

type dw_1 from w_a_pick_one`dw_1 within w_a_liste
integer x = 46
integer width = 1280
integer height = 584
integer taborder = 20
end type

event dw_1::we_dwnkey;call super::we_dwnkey;
//Captage des touches de fonction par le contrôle et renvoie à l'évènement KEY de la fenêtre
//	f_activation_key() 
	f_key(Parent)
end event

event dw_1::we_dwnprocessenter;call super::we_dwnprocessenter;// Double click is equivalent to pressing the OK button

IF this.getselectedrow(0) > 0 THEN
	parent.TriggerEvent ("ue_ok")
END IF
end event

event dw_1::clicked;// Add the column whose label was clicked on (as identified by
// <column name> + _t) to the sort criteria and sort.

String s_object, s_col_name, s_ordre_tri,s_object_origine,s_object_picture
//

IF not i_b_sort_on_label THEN
	return
end if

IF Left (this.GetBandAtPointer ( ), 7) <> "header~t" THEN
	return
end if

s_object_origine = this.GetObjectAtPointer ()

// Correspond a l'image contenant l'ordre de tri
if pos(s_object_origine, "~p") > 0 then
	return
end if

if pos(s_object_origine, "~t") = 0 then
	return
end if

s_object = Left (s_object_origine, Pos (s_object_origine, "~t") - 1)
s_col_name = Left (s_object,Len (s_object) - 2)

if s_col_name = is_colonne_prec then
	if is_ordre_tri = "A" then
		s_ordre_tri = "D"
	else
		s_ordre_tri = "A"
	end if
else
	s_ordre_tri = "A"
	this.modify(is_colonne_prec + "_p_asc.visible='0'")
	this.modify(is_colonne_prec + "_p_desc.visible='0'")	
end if

this.modify(s_col_name + "_p_desc.visible='0'")		
this.modify(s_col_name + "_p_asc.visible='0'")		

if s_ordre_tri = "A" then
	this.modify(s_col_name + "_p_asc.visible='1'")	
else
	this.modify(s_col_name + "_p_desc.visible='1'")	
end if

	// 3d lowered border
this.SetSort (s_col_name + " " + s_ordre_tri + ", " + i_s_original_sort)
this.Sort ()

is_colonne_prec = s_col_name
is_ordre_tri = s_ordre_tri


this.PostEvent (RowFocusChanged!)

end event

type pb_ok from u_pba_ok within w_a_liste
integer x = 46
integer y = 688
integer width = 334
integer taborder = 10
string picturename = "C:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_echap from u_pba_echap within w_a_liste
integer x = 992
integer y = 688
integer taborder = 40
string picturename = "C:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

