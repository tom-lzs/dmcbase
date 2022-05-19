$PBExportHeader$w_liste_client.srw
$PBExportComments$Permet l'affichage de la liste des clients donneur d'ordre, clients payeur, clients livrés pour les vendeurs.
forward
global type w_liste_client from w_a_liste
end type
end forward

global type w_liste_client from w_a_liste
string tag = "LISTE_CLIENT"
integer width = 3264
integer height = 1492
end type
global w_liste_client w_liste_client

event ue_init;/* <DESC>
    Initialise la datawindow qui doit être affichée en fonction de l'origine de l'appel de la fenêtre :
     - Donneur Ordre  dans le cas de création d'une nouvelle commande ou pour accéder à la fiche client
 	- Payeur dans le cas d'une création d'un nouveau client
	- Livré pour les vendeurs dans le cas  de la création de l'entête d'une commande vendeur.
     En fonction des critères saisis lors de l'identification du client, préparation des paramètres pour filtrer les
     clients.
	Extraction de la liste des clients . Si aucun client ne répond aux critères, retour sur la fenêtre de sélection
     </DESC> */
	
	String	s_client_deb
	String	s_client_fin
	String	s_nom_deb
	String	s_nom_fin
	String	s_ville_deb
	String	s_ville_fin
	String	s_dept_deb
	String	s_dept_fin
	String	s_natclf_deb
	String	s_natclf_fin
	String   s_pays_deb
	String   s_pays_fin
	Long		l_retrieve
     String   s_visiteur
	  
// INITIALISATION DES ARGUMENTS
	s_client_deb	= i_str_pass.s[1]
	s_client_fin	= i_str_pass.s[1] + f_get_max_value_of_string(LONG_CLIENT_CODE)
 	s_nom_deb		= i_str_pass.s[2]
	s_nom_fin		= i_str_pass.s[2] + f_get_max_value_of_string(LONG_CLIENT_NOM)
 	s_ville_deb		= i_str_pass.s[3]
	s_ville_fin		= i_str_pass.s[3] + f_get_max_value_of_string(LONG_CLIENT_VILLE)
 	s_pays_deb		= i_str_pass.s[4]
	s_pays_fin		= i_str_pass.s[4] + f_get_max_value_of_string(LONG_CLIENT_PAYS)		
 	s_dept_deb		= i_str_pass.s[5]
	s_dept_fin		= i_str_pass.s[5] + f_get_max_value_of_string(LONG_CLIENT_DEPT)
	s_visiteur          = "%"
   
	if g_nv_come9par.is_vendeur_multi_carte() then
		 s_visiteur = g_s_visiteur  + "%"
	end if
// Chargement de la liste des clients répondants aux critères de sélection
	l_retrieve = dw_1.Retrieve(s_client_deb, s_nom_deb, s_ville_deb, s_dept_deb, &
										s_pays_deb,g_nv_come9par.get_code_langue(),s_client_fin, s_nom_fin, &
										s_ville_fin, s_dept_fin, s_pays_fin,s_visiteur)
	CHOOSE CASE l_retrieve
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
     Validation de la sélection d'un client sur la liste et retour à la fenêtre de sélection en passant les éléments pour affichage.
   </DESC> */
i_str_pass.s_action = "ok"

	Long		l_row

   dw_1.DBCancel ()

	l_row = dw_1.GetRow ()
	i_str_pass.s[1] = dw_1.GetItemString (l_row, DBNAME_CLIENT_CODE)
	
	nv_client_object lu_client
	lu_client = CREATE nv_client_object
	lu_client.fu_retrieve_client(i_str_pass.s[1])
	i_str_pass.po[1] = lu_client

	nv_commande_object l_commande
	l_commande = CREATE nv_commande_object
	i_str_pass.po[2] = l_commande	
	i_str_pass.s[2] = BLANK
	
	Message.fnv_set_str_pass(i_str_pass)
	Close (This)
end event

event open;call super::open;/* <DESC> 
    Permet de rendre la fenêtre non visible à l'ouverture. celle ci ne sera visible que lorsque toutes
    les données seront extraites
	</DESC> */
	
	This.hide()
	if i_str_pass.b[1] then
		dw_1.DataObject  = "d_liste_client_livre_pour_vendeur"
		dw_1.SetTransObject (i_tr_sql)
	elseif i_str_pass.b[2] then
		dw_1.DataObject  = "d_liste_client_donneur_ordre"
		dw_1.SetTransObject (i_tr_sql)
	elseif i_str_pass.b[3] then
		dw_1.DataObject  = "d_liste_client_payeur"
		dw_1.SetTransObject (i_tr_sql)
	else
		dw_1.DataObject  = "d_liste_client_all"
		dw_1.SetTransObject (i_tr_sql)
	end if
	
     g_nv_traduction.set_traduction_datawindow(dw_1)

end event

event ue_cancel;  /* <DESC>
       Permet de quitter la fenêtre sans sélectionner de client
	</DESC> */

	dw_1.DBCancel ()
	Message.fnv_set_str_pass(i_str_pass)
	Close (This)
end event

on w_liste_client.create
call super::create
end on

on w_liste_client.destroy
call super::destroy
end on

type uo_statusbar from w_a_liste`uo_statusbar within w_liste_client
end type

type cb_cancel from w_a_liste`cb_cancel within w_liste_client
end type

type cb_ok from w_a_liste`cb_ok within w_liste_client
end type

type dw_1 from w_a_liste`dw_1 within w_liste_client
string tag = "A_TRADUIRE"
integer x = 41
integer y = 68
integer width = 3104
integer height = 1100
integer taborder = 10
end type

type pb_ok from w_a_liste`pb_ok within w_liste_client
integer x = 539
integer y = 1188
integer taborder = 0
string picturename = "C:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_echap from w_a_liste`pb_echap within w_liste_client
integer x = 1481
integer y = 1188
integer taborder = 0
string picturename = "C:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

