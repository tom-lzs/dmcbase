$PBExportHeader$w_gestion_des_messages.srw
$PBExportComments$Permet la gestion des différents textes associés à un client ou à une commande.
forward
global type w_gestion_des_messages from w_a_udim_su
end type
type dw_mas from u_dwa within w_gestion_des_messages
end type
type pb_echap from u_pba_echap within w_gestion_des_messages
end type
type pb_ok from u_pba_ok within w_gestion_des_messages
end type
type pb_suppression from u_pba within w_gestion_des_messages
end type
type pb_impression from u_pba within w_gestion_des_messages
end type
end forward

global type w_gestion_des_messages from w_a_udim_su
integer x = 0
integer y = 0
integer width = 3451
integer height = 2148
string title = "Gestion du message"
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
long backcolor = 12632256
boolean center = true
event ue_message_cde pbm_custom41
event ue_suppression pbm_custom52
dw_mas dw_mas
pb_echap pb_echap
pb_ok pb_ok
pb_suppression pb_suppression
pb_impression pb_impression
end type
global w_gestion_des_messages w_gestion_des_messages

type variables
// Dernier numéro de ligne
Long	i_l_num_ligne

end variables

event ue_suppression;/* <DESC>
Suppression de toutes les lignes constituant le texte
   </DESC> */
Long	l_row

l_row	=	Dw_1.RowCount()

DO WHILE l_row > 0
  dw_1.DeleteRow(l_row)
  l_row --
LOOP

dw_1.Update()



end event

event ue_ok;/* <DESC>
  Validation finale de la saisie:
    - Sauvegarde de la dernière ligne
    - Retour sur la fenêtre d''appel en passant le texte de la première ligne saisie.
</DESC> */
// OVERRIDE SCRIPT ANCESTOR
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

if dw_1.rowCount() > 0 then
	i_str_pass.s[5] = dw_1.getItemString(1, DBNAME_MESSAGE)
else
	i_str_pass.s[5] = DONNEE_VIDE
end if

Message.fnv_set_str_pass(i_str_pass)
Close(this)
end event

event ue_presave;call super::ue_presave;/* <DESC>
  Controle de la saisie de la ligne.  Si le texte est à blanc, suppression de la ligne, sinon création de la ligne en completant par
  par la date de création, le code mise à jour à 'C', le code langue , du code client ou le n° de la commande
  (dépend de l'origine de l'appel) et du n° de ligne qui sera égale au n° de la ligne dans la datawindow.
   </DESC> */ 
// DECLARATION DES VARIABLES LOCALES
long			l_row
String		s_num

l_row			 = dw_1.fu_get_itemchanged_row_num ()
IF l_row = 0 Or l_row > dw_1.RowCount() THEN
	Message.ReturnValue = -1
	RETURN
END IF

dw_1.SetItem (l_row, DBNAME_DATE_CREATION, SQLCA.fnv_get_datetime ())
dw_1.SetItem (l_row, DBNAME_CODE_MAJ, CODE_CREATION)
dw_1.SetItem (l_row, i_str_pass.s[2], i_str_pass.s[1])
dw_1.SetItem (l_row, DBNAME_CODE_LANGUE, " ")

s_num = String(l_row)
do until len (String(s_num)) = 3
	s_num = "0" + String(s_num)
loop

dw_1.SetItem (l_row, DBNAME_MESSAGE_NUM_LIGNE, s_num)



end event

event key;call super::key;/* <DESC>
      Permet de trapper les touches de fonction activées et déclencher l'évènement associé
	à la touche.
	  F11 =Validation de la saisie
   </DESC> */

	IF KeyDown (KeyF11!) THEN
		This.PostEvent ("ue_ok")
	END IF
end event

on w_gestion_des_messages.create
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

on w_gestion_des_messages.destroy
call super::destroy
destroy(this.dw_mas)
destroy(this.pb_echap)
destroy(this.pb_ok)
destroy(this.pb_suppression)
destroy(this.pb_impression)
end on

event open;call super::open;/* <DESC>
 Positionnement de la fenetre 
 </DESC> */
	This.X = 0
	this.Y = 0
	


	
end event

event ue_init;call super::ue_init;/* <DESC>
    Initialisation des objets datawindows à partir des paramétres passés ,
	 - Le nom de la table à mettre à jour
	- Le code du client ou du n° de la commande
	- Le code langue
	- La datawindow d'entête qui contient soit les informations du client ou de la commande.
	- Le titre de la fenêtre

	remarque:
	Le nom des datawindow contenant les textes, ont été codifées de la façon suivantes
	'd_texte_' + nom de la table à mettre à jour.
</DESC> */
g_nv_trace.fu_write_trace( this.classname( ), "ue_ini",i_str_pass.s[01], i_str_pass.s[02], this.classname( ) , g_s_fenetre_destination)

dw_mas.Dataobject = i_str_pass.s[6]
dw_mas.setTransObject(sqlca)
dw_1.DataObject = "d_texte_" + i_str_pass.s[3]
dw_1.setTransObject(sqlca)
g_nv_traduction.set_traduction_datawindow( dw_mas)
g_nv_traduction.set_traduction_datawindow( dw_1)

this.title = g_nv_traduction.get_traduction(i_str_pass.s[4])

if dw_mas.retrieve(i_str_pass.s[1],g_nv_come9par.get_code_langue()) = -1 then
	f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)	
end if

if dw_1.retrieve(i_str_pass.s[1],i_str_pass.s[7]) = -1 then
	f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
end if

if dw_1.rowCount() = 0 then
	dw_1.fu_insert(0)
end if

end event

event ue_cancel;/* <DESC> 
      Permet de quitter la fenêtre sans effectuer de modification 
   </DESC> */
if dw_1.rowCount() > 0 then
	i_str_pass.s[5] = dw_1.getItemString(1, DBNAME_MESSAGE)
else
	i_str_pass.s[5] = DONNEE_VIDE
end if

Message.fnv_set_str_pass(i_str_pass)

Close(this)
end event

event ue_print;/* <DESC>
  Permet d'imprimer le texte
  Initialisation du datastore d'impression en fonction de l'oringe et de la table message
  a imprimer.
  
  Extraction du message et impression.
   </DESC> */

Datastore ds_print

ds_print = CREATE Datastore
ds_print.dataobject = "d_impression_texte"

if dw_mas.dataobject = "d_entete_saisie_cde" then
	ds_print.object.dw_entete.dataobject = "d_entete_saisie_cde_impress"
else
	ds_print.object.dw_entete.dataobject = dw_mas.dataobject
end if
ds_print.object.dw_message.dataobject = dw_1.dataobject

g_nv_traduction.set_traduction_datastore(ds_print)
ds_print.object.t_titre.text = this.title

ds_print.setTransObject(sqlca)
ds_print.retrieve(i_str_pass.s[1],i_str_pass.s[7])
ds_print.print()

destroy  ds_print
end event

event closequery;/* <DESC> Overwrite le script de l'ancetre */
// overwrite
end event

type uo_statusbar from w_a_udim_su`uo_statusbar within w_gestion_des_messages
integer x = 2267
integer y = 0
end type

type dw_1 from w_a_udim_su`dw_1 within w_gestion_des_messages
string tag = "A_TRADUIRE"
integer x = 366
integer y = 640
integer width = 2450
integer height = 928
integer taborder = 20
string dataobject = "d_texte_come9086"
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

event dw_1::we_dwnprocessenter;call super::we_dwnprocessenter;/*   Permet en fin de ligne d'insérer une nouvel ligne si la ligne en cours n'est pa vide */
	dw_1.AcceptText ()

	IF	 dw_1.GetRow () = dw_1.RowCount () THEN
		IF Not IsNull (dw_1.GetItemString (dw_1.GetRow(), DBNAME_MESSAGE)) and  & 
		     trim(dw_1.GetItemString (dw_1.GetRow(), DBNAME_MESSAGE)) <>  "" THEN
			dw_1.fu_insert (0)
		END IF
	ELSE
		Send(Handle(This),256,9,Long(0,0))
		Return 1
	END IF
end event

event dw_1::we_dwnkey;call super::we_dwnkey;/* 
Appel de la fonction de controle des touches de fonction autorisées dans l'application
et de déclencher l'évènement KEY de la fenêtre qui contient le code correspond à la
touche.
*/
	f_key(parent)
end event

type dw_mas from u_dwa within w_gestion_des_messages
string tag = "A_TRADUIRE"
integer x = 50
integer y = 28
integer width = 2967
integer height = 492
integer taborder = 0
borderstyle borderstyle = styleshadowbox!
end type

type pb_echap from u_pba_echap within w_gestion_des_messages
integer x = 1819
integer y = 1692
integer taborder = 0
string picturename = "C:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type pb_ok from u_pba_ok within w_gestion_des_messages
integer x = 594
integer y = 1692
integer width = 334
integer taborder = 0
string text = "Valid.  F11"
boolean default = false
string picturename = "C:\appscir\Erfvmr_diva\Image\pbok.bmp"
alignment htextalign = left!
end type

type pb_suppression from u_pba within w_gestion_des_messages
integer x = 1097
integer y = 1692
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

type pb_impression from u_pba within w_gestion_des_messages
integer x = 2267
integer y = 1692
integer width = 334
integer height = 168
integer taborder = 21
boolean bringtotop = true
string facename = "Arial"
string text = "Impression"
string picturename = "C:\appscir\Erfvmr_diva\Image\PB_IMP.BMP"
end type

event constructor;call super::constructor;i_s_event = "ue_print"
end event

