$PBExportHeader$w_message_cde_response.srw
$PBExportComments$Permet la gestion du message associé à une commande.
forward
global type w_message_cde_response from w_a_udim_su
end type
type dw_mas from u_dwa within w_message_cde_response
end type
type pb_echap from u_pba_echap within w_message_cde_response
end type
type pb_ok from u_pba_ok within w_message_cde_response
end type
type pb_suppression from u_pba within w_message_cde_response
end type
type pb_impression from u_pba within w_message_cde_response
end type
end forward

global type w_message_cde_response from w_a_udim_su
string tag = "CDE_MESSAGE"
integer x = 0
integer y = 0
integer width = 3803
integer height = 2124
string title = "Message de la commande "
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
long backcolor = 12632256
boolean center = true
event ue_message_cde pbm_custom41
event ue_suppression pbm_custom52
event ue_workflow ( )
dw_mas dw_mas
pb_echap pb_echap
pb_ok pb_ok
pb_suppression pb_suppression
pb_impression pb_impression
end type
global w_message_cde_response w_message_cde_response

type variables
nv_commande_object 	i_nv_commande_object
String is_fenetre_origine
end variables

forward prototypes
public subroutine fw_init_message ()
end prototypes

event ue_suppression;Long	l_row

l_row	=	Dw_1.RowCount()

DO WHILE l_row > 0
  dw_1.DeleteRow(l_row)
  l_row --
LOOP

dw_1.Update()
i_nv_commande_object.fu_reactualise_les_blocages()
Message.fnv_set_str_pass(i_str_pass)

if is_fenetre_origine = BLANK then
	g_s_fenetre_destination = FENETRE_LISTE_CDE
else	
	g_s_fenetre_destination = is_fenetre_origine
end if

triggerEvent("ue_workflow")



end event

event ue_workflow();i_str_pass.po[2] = i_nv_commande_object

g_nv_workflow_manager.fu_check_workflow(FENETRE_MESSAGE_CDE, i_str_pass)
close(this)
end event

public subroutine fw_init_message ();if dw_1.rowCount() > 0 then
	i_str_pass.s[5] = dw_1.getItemString(1, DBNAME_MESSAGE)
else
	i_str_pass.s[5] = DONNEE_VIDE
end if
end subroutine

event ue_init;call super::ue_init;// ================================================================================== 
// DECLARATION DES VARIABLES LOCALES
long			l_retrieve
Str_pass		str_work
String		s_cde_ter

dw_mas.SetTransObject (i_tr_sql)

// SELECTION DU CLIENT
i_str_pass = g_nv_workflow_manager.fu_ident_client(true, i_str_pass)
if  i_str_pass.s_action = ACTION_CANCEL then
	This.TriggerEvent ("ue_cancel")
	RETURN
end if

g_nv_trace.fu_write_trace( this.classname( ), "ue_ini",i_str_pass.s[01], i_str_pass.s[02], this.classname( ) , g_s_fenetre_destination)
i_nv_commande_object = CREATE nv_commande_object
i_nv_commande_object.fu_set_numero_cde(i_str_pass.s[2])

// CHARGEMENT DE LA DTW DW_MAS
IF dw_mas.Retrieve (i_nv_commande_object.fu_controle_numero_cde(i_str_pass.po[1]),g_nv_come9par.get_code_langue()) = -1 THEN
 	f_dmc_error (this.title +  BLANK + DB_ERROR_MESSAGE)
END IF

// CHARGEMENT DE LA DTW DW_1
if dw_1.Retrieve (i_nv_commande_object.fu_get_numero_cde()) = -1 then
		f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
end if


if dw_1.rowCount() = 0 and not i_nv_commande_object.fu_is_commande_transferee() then
	dw_1.fu_insert(0)
end if

if  i_nv_commande_object.fu_is_commande_transferee() then
	dw_1.enabled = false
	pb_ok.visible = false
	pb_suppression.visible = false
end if

dw_1.setFocus()

end event

event ue_ok;// OVERRIDE SCRIPT ANCESTOR
Long ll_indice
i_b_canceled = TRUE
IF dw_1.fu_changed() THEN
	THIS.Triggerevent("ue_save")
END IF

	// Suppression des lignes vides 
ll_indice = dw_1.RowCount()
DO WHILE ll_indice > 0
	if dw_1.getitemstring(ll_indice,DBNAME_MESSAGE) = "" then
		dw_1.DeleteRow (ll_indice)
	  end if

	ll_indice -- 
LOOP	
dw_1.update()	

i_nv_commande_object.fu_reactualise_les_blocages()
i_nv_commande_object.fu_update_entete( )
Message.fnv_set_str_pass(i_str_pass)

if is_fenetre_origine = BLANK then
	g_s_fenetre_destination = FENETRE_LISTE_CDE
else	
	g_s_fenetre_destination = is_fenetre_origine
end if

triggerEvent("ue_workflow")

end event

event ue_presave;call super::ue_presave;// DECLARATION DES VARIABLES LOCALES
long			l_row
String		s_num

l_row			 = dw_1.fu_get_itemchanged_row_num ()
IF l_row = 0 Or l_row > dw_1.RowCount() THEN
	Message.ReturnValue = -1
	RETURN
END IF

dw_1.SetItem (l_row, DBNAME_DATE_CREATION, SQLCA.fnv_get_datetime ())
dw_1.SetItem (l_row, DBNAME_CODE_MAJ, CODE_CREATION)
dw_1.SetItem (l_row, DBNAME_NUM_CDE, i_nv_commande_object.fu_get_numero_cde())

s_num = String(l_row)
do until len (String(s_num)) = 3
	s_num = "0" + String(s_num)
loop

dw_1.SetItem (l_row, DBNAME_MESSAGE_NUM_LIGNE, s_num)

end event

event key;call super::key;
	IF KeyDown (KeyF11!) THEN
		This.PostEvent ("ue_ok")
	END IF 
end event

on w_message_cde_response.create
int iCurrent
call super::create
this.dw_mas=create dw_mas
this.pb_echap=create pb_echap
this.pb_ok=create pb_ok
this.pb_suppression=create pb_suppression
this.pb_impression=create pb_impression
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_mas
this.Control[iCurrent+2]=this.pb_echap
this.Control[iCurrent+3]=this.pb_ok
this.Control[iCurrent+4]=this.pb_suppression
this.Control[iCurrent+5]=this.pb_impression
end on

on w_message_cde_response.destroy
call super::destroy
destroy(this.dw_mas)
destroy(this.pb_echap)
destroy(this.pb_ok)
destroy(this.pb_suppression)
destroy(this.pb_impression)
end on

event open;call super::open;
	This.X = 0
	this.Y = 0
	
	is_fenetre_origine = g_nv_workflow_manager.fu_get_fenetre_origine()

end event

event ue_print;Datastore ds_print

ds_print = CREATE Datastore
ds_print.dataobject = "d_impression_texte_come90pb"

ds_print.setTransObject(sqlca)
ds_print.retrieve(i_nv_commande_object.fu_get_numero_cde(), g_nv_come9par.get_code_langue())
g_nv_traduction.set_traduction_datastore(ds_print)
ds_print.print()

destroy  ds_print
end event

event ue_cancel(unsignedlong wparam, long lparam);// Overwrite
i_b_canceled = TRUE
if is_fenetre_origine = BLANK then
	g_s_fenetre_destination = FENETRE_LISTE_CDE
else	
	g_s_fenetre_destination = is_fenetre_origine
end if
triggerEvent("ue_workflow")

end event

type uo_statusbar from w_a_udim_su`uo_statusbar within w_message_cde_response
integer x = 0
integer y = 1952
end type

type dw_1 from w_a_udim_su`dw_1 within w_message_cde_response
integer x = 471
integer y = 708
integer width = 2057
integer height = 788
integer taborder = 20
string dataobject = "d_texte_come90pb"
boolean vscrollbar = true
end type

event dw_1::editchanged;call super::editchanged;
If Len(dw_1.GetText()) < LONG_MESSAGE then
	REturn
Else
	beep(10)
	dw_1.fu_insert (0)
End if

end event

event dw_1::we_dwnprocessenter;call super::we_dwnprocessenter;
// --------------------------------------------------------------------------------
// EN FIN DE LIGNE INSERTION D'UNE NOUVELLE LIGNE SI LA LIGNE PRECEDENTE EST SAISIE
// --------------------------------------------------------------------------------
	dw_1.AcceptText ()

	IF	 dw_1.GetRow () = dw_1.RowCount () THEN
		IF Not IsNull (dw_1.GetItemString (dw_1.GetRow(), DBNAME_MESSAGE)) THEN
			dw_1.fu_insert (0)
		END IF
	ELSE
		Send(Handle(This),256,9,Long(0,0))
		Return 1
	END IF
end event

event dw_1::we_dwnkey;call super::we_dwnkey;
// ACTIVATION DE L'EVENEMENT AU NIVEAU DE LA FENÊTRE
//	f_activation_key ()
	f_key(parent)
end event

type dw_mas from u_dwa within w_message_cde_response
integer x = 64
integer y = 48
integer width = 2962
integer height = 536
integer taborder = 0
string dataobject = "d_entete_saisie_cde"
borderstyle borderstyle = styleshadowbox!
end type

type pb_echap from u_pba_echap within w_message_cde_response
integer x = 1499
integer y = 1532
integer taborder = 0
string picturename = "C:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type pb_ok from u_pba_ok within w_message_cde_response
integer x = 562
integer y = 1540
integer width = 334
integer taborder = 0
string text = "Valid.  F11"
boolean default = false
string picturename = "C:\appscir\Erfvmr_diva\Image\pbok.bmp"
alignment htextalign = left!
end type

type pb_suppression from u_pba within w_message_cde_response
integer x = 1051
integer y = 1536
integer width = 334
integer height = 168
integer taborder = 10
string facename = "Arial"
string text = "S&upprim."
string picturename = "C:\appscir\Erfvmr_diva\Image\PB_SUPPR.BMP"
end type

on constructor;call u_pba::constructor;
// -----------------------------------
// Déclenche l'évènement de la fenêtre
// -----------------------------------
	fu_setevent ("ue_suppression")
	fu_set_microhelp ("Suppression complète du message")
end on

type pb_impression from u_pba within w_message_cde_response
integer x = 1938
integer y = 1536
integer width = 334
integer height = 168
integer taborder = 11
boolean bringtotop = true
string facename = "Arial"
string text = "Impression"
string picturename = "C:\appscir\Erfvmr_diva\Image\PB_IMP.BMP"
end type

event constructor;call super::constructor;i_s_event = "ue_print"
end event

