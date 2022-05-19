$PBExportHeader$w_liste_client_a_valider.srw
$PBExportComments$Permet l'affichage de la liste des clients prospects créés ou bien  les modifications des informations génerales de client existant
forward
global type w_liste_client_a_valider from w_a_liste
end type
end forward

global type w_liste_client_a_valider from w_a_liste
string tag = "MODIF_CLIENT_A_VALIDER"
integer width = 2533
integer height = 1108
end type
global w_liste_client_a_valider w_liste_client_a_valider

on w_liste_client_a_valider.create
call super::create
end on

on w_liste_client_a_valider.destroy
call super::destroy
end on

event ue_ok;/* <DESC>
    Permet de valider la sélection et d'aller en affichage des infos du client
    Si le client est un prospect, on affiche la fenêtre de création d'un nouveau client sinon la fenêtre fiche client .
   </DESC> */
Str_pass		str_work
Long			l_row

str_work = Message.fnv_get_str_pass()
Message.fnv_clear_str_pass()

l_row						=	dw_1.GetRow()
if l_row = 0 then
	return
end if
str_work.s[01]			=	dw_1.GetItemString(l_row, DBNAME_CLIENT_CODE)
Str_work.s[20]			=	ORIGINE_VALIDATION_CLIENT
Str_work.b[1]			=	True

If dw_1.GetItemString(l_row, DBNAME_CODE_PROSPECT) = CODE_PREFIX_PROSPECT then
	OpenWithParm (w_nouveau_client, str_work)
Else
	i_str_pass.s_action 	= 	ACTION_OK 
	i_str_pass.s[01] 		= 	str_work.S[01]
	i_str_pass.b[10]		= 	False
	
	nv_client_object lu_client
	lu_client = CREATE nv_client_object
	lu_client.fu_retrieve_client(i_str_pass.s[01])
	i_str_pass.po[1] = lu_client

	g_s_valide				=	ORIGINE_VALIDATION_CLIENT
	g_w_frame.fw_open_sheet (FENETRE_CLIENT, 0, 1, i_str_pass)
End if

This.PostEvent ("ue_cancel")

end event

event ue_cancel;call super::ue_cancel;/* <DESC>
     Fermeture de la fenetre lors de l'activation de la touche Echap
   </DESC> */
Close(this)
end event

event ue_init;// Overwrite

dw_1.Retrieve()
end event

type uo_statusbar from w_a_liste`uo_statusbar within w_liste_client_a_valider
end type

type cb_cancel from w_a_liste`cb_cancel within w_liste_client_a_valider
end type

type cb_ok from w_a_liste`cb_ok within w_liste_client_a_valider
end type

type dw_1 from w_a_liste`dw_1 within w_liste_client_a_valider
string tag = "A_TRADUIRE"
integer width = 2322
integer height = 604
string dataobject = "d_liste_client_a_valider"
end type

type pb_ok from w_a_liste`pb_ok within w_liste_client_a_valider
integer x = 283
integer y = 692
string picturename = "C:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_echap from w_a_liste`pb_echap within w_liste_client_a_valider
integer x = 1157
integer y = 692
string picturename = "C:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

