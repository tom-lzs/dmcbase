$PBExportHeader$w_liste_client_partenaire.srw
$PBExportComments$Permet l'affichage de la liste des clients livrés partenaire du client donneur d'ordre passé en paramètre lors de la sisie de l'entete de commande et si le visiteur est une assistante clientèle
forward
global type w_liste_client_partenaire from w_a_liste
end type
end forward

global type w_liste_client_partenaire from w_a_liste
string tag = "LISTE_CLIENT_PARTENAIRE"
integer width = 3003
integer height = 1340
string title = "Liste des partenaires livrés"
end type
global w_liste_client_partenaire w_liste_client_partenaire

type variables
String is_dbname_client_code
String is_dbname_client_abrege_nom
String is_dbname_client_abrege_ville
end variables

event ue_init;/* <DEF>
    Initialise l'affichage de la fenetre. Extraction de la liste des clients partenaires
    associés au client passé en paramètre.
   </DEF> */
integer li_retrieve
// DECLARATION DES VARIABLES LOCALES

is_dbname_client_code			= DBNAME_CLIENT_LIVRE_CODE
is_dbname_client_abrege_nom	= DBNAME_CLIENT_LIVRE_ABREGE_NOM
is_dbname_client_abrege_ville	= DBNAME_CLIENT_LIVRE_ABREGE_VILLE

dw_1.SetTransObject (i_tr_sql)	

// Chargement de la liste des clients associés au client 
li_retrieve = dw_1.Retrieve(i_str_pass.s[4],g_nv_come9par.get_code_langue())
CHOOSE CASE li_retrieve
	CASE -1
		f_dmc_error (this.title + & 
						 BLANK + &
						 DB_ERROR_MESSAGE)			
	CASE 0
		messagebox(this.title, g_nv_traduction.get_traduction(CLIENT_INEXISTANT), Information!,OK!,1)
		This.TriggerEvent ("ue_cancel")
	CASE 1
		This.TriggerEvent("ue_ok")		
	CASE ELSE
		dw_1.fu_set_sort_on_label (True)
		This.Show()
END CHOOSE

end event

event ue_ok;/* <DESC>
     Permet de valider la sélection du client en initialisant la structure en retour
	 avec le code, l'abrégé nom et ville
   </DESC< */
i_str_pass.s_action = ACTION_OK

i_str_pass.s[1] = dw_1.GetItemString (dw_1.GetRow (), is_dbname_client_code)
i_str_pass.s[2] = dw_1.GetItemString (dw_1.GetRow (), is_dbname_client_abrege_nom)	
i_str_pass.s[3] = dw_1.GetItemString (dw_1.GetRow (), is_dbname_client_abrege_ville)		

Message.fnv_set_str_pass(i_str_pass)
Close (This)
end event

event open;call super::open;/* <DESC> 
    Permet de rendre la fenetre non visible à l'ouverture. celle ci ne sera visible que lorsque toutes
	les données seront extraites
	</DESC> */
	This.hide()
	
	

end event

event ue_cancel;  /* <DESC>
       permet de quitter la fenetre sans sélectionner de client
	</DESC> */
Message.fnv_set_str_pass(i_str_pass)
Close (This)
end event

on w_liste_client_partenaire.create
call super::create
end on

on w_liste_client_partenaire.destroy
call super::destroy
end on

type uo_statusbar from w_a_liste`uo_statusbar within w_liste_client_partenaire
end type

type cb_cancel from w_a_liste`cb_cancel within w_liste_client_partenaire
end type

type cb_ok from w_a_liste`cb_ok within w_liste_client_partenaire
end type

type dw_1 from w_a_liste`dw_1 within w_liste_client_partenaire
string tag = "A_TRADUIRE"
integer x = 41
integer y = 68
integer width = 2857
integer height = 876
integer taborder = 10
string dataobject = "d_liste_client_livre"
end type

type pb_ok from w_a_liste`pb_ok within w_liste_client_partenaire
integer x = 686
integer y = 996
integer taborder = 0
string picturename = "C:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_echap from w_a_liste`pb_echap within w_liste_client_partenaire
integer x = 1627
integer y = 996
integer taborder = 0
string picturename = "C:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

