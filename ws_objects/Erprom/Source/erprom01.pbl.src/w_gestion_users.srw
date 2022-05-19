$PBExportHeader$w_gestion_users.srw
$PBExportComments$Gestion des accès à l'application
forward
global type w_gestion_users from w_a_udim
end type
type cb_ok from u_cb_ok within w_gestion_users
end type
type cb_annuler from u_cb_cancel within w_gestion_users
end type
end forward

global type w_gestion_users from w_a_udim
integer width = 2894
integer height = 1584
string menuname = "m_multi_ligne"
long backcolor = 12632256
cb_ok cb_ok
cb_annuler cb_annuler
end type
global w_gestion_users w_gestion_users

on ue_close;
// OVERRIDE SCRIPT ANCESTOR
	Close(This)
end on

event ue_init;call super::ue_init;
// -------------------------------------
// DECLARATION DES VARIABLES LOCALES
// -------------------------------------
	Long		l_retrieve

	i_b_canceled = TRUE

	l_retrieve = dw_1.Retrieve (g_app.appname)
	CHOOSE CASE l_retrieve
		CASE -1
			f_dmc_error ("Erreur Retrieve dw_1 dans ue_init de w_gestion_user")
		CASE 0
			dw_1.InsertRow(0)
		CASE ELSE
	END CHOOSE

	dw_1.SetFocus()
	dw_1.fu_set_selection_mode(1)
		
end event

event ue_presave;call super::ue_presave;
// ----------------------------------
// CONTRÔLES AVANT SAUVEGARDE
// ----------------------------------
	Long		l_nb_row
	Long		l_row
	Long		l_find

	String	s_useefrid
	String	s_nomefusr
	String	s_prneeusr
	String	s_moteepas
	String	s_cdeeefct


// ----------------------------------
// Nombre de lignes
// ----------------------------------
	dw_1.AcceptText()
	dw_1.SelectRow(0, FALSE)

	l_nb_row = dw_1.RowCount()

	IF l_nb_row = 0 THEN
		RETURN
	END IF


// ----------------------------------
// Boucle de contrôle
// ----------------------------------
	FOR l_row = 1 TO l_nb_row
		s_useefrid = Trim (dw_1.GetItemString(l_row, DBNAME_USERID))
		s_nomefusr = Trim (dw_1.GetItemString(l_row, DBNAME_NOM_USER))
		s_prneeusr = Trim (dw_1.GetItemString(l_row, DBNAME_PRENOM))
		s_cdeeefct = Trim (dw_1.GetItemString(l_row, DBNAME_USER_FONCTION))
		s_moteepas = Trim (dw_1.GetItemString(l_row, DBNAME_PASSWORD))

	// Code utilisateur obligatoire
		IF IsNull (s_useefrid) OR s_useefrid = DONNEE_VIDE THEN
			dw_1.SetFocus()
			dw_1.ScrollToRow(l_row)
			dw_1.SetColumn (DBNAME_USERID)
			MessageBox ("Contrôle zone obligatoire", &
								"Vous devez indiquer le code utilisateur.", &
								StopSign!, Ok!, 1)
			Message.ReturnValue = -1
			RETURN
		END IF


	// Contrôle clé en double (on ne contrôle pas la première ligne)
		IF l_row > 1 THEN		
			l_find = dw_1.Find (DBNAME_USERID + "='" + s_useefrid + "'",0, l_row -1)
			IF l_find > 0 THEN
				dw_1.SetFocus()
				dw_1.SelectRow(l_find, TRUE)
				dw_1.ScrollToRow(l_row)
				dw_1.SetColumn (DBNAME_USERID)
				MessageBox ("Controle des doublons", &
									"Attention ce code utilisateur est déjà saisi," + &
									"~rsupprimez la ligne ou modifiez le code utilisateur.", &
									StopSign!, Ok!, 1)
				Message.ReturnValue = -1
				RETURN
			END IF
		END IF

	// Nom de l'utilisateur obligatoire
		IF IsNull (s_nomefusr) OR s_nomefusr = DONNEE_VIDE THEN
			dw_1.SetFocus()
			dw_1.ScrollToRow(l_row)
			dw_1.SetColumn (DBNAME_NOM_USER)
			MessageBox ("Contrôle zone obligatoire", &
								"Vous devez indiquer le nom de l'utilisateur.", &
								StopSign!, Ok!, 1)
			Message.ReturnValue = -1
			RETURN
		END IF

		IF IsNull (s_prneeusr) OR s_prneeusr = DONNEE_VIDE THEN
			dw_1.SetFocus()
			dw_1.ScrollToRow(l_row)
			dw_1.SetColumn (DBNAME_PRENOM)	
			MessageBox ("Contrôle zone obligatoire", &
								"Vous devez indiquer le prénom de l'utilisateur.", &
								StopSign!, Ok!, 1)
			Message.ReturnValue = -1
			RETURN
		END IF

		IF IsNull (s_cdeeefct) OR s_cdeeefct = DONNEE_VIDE THEN
			dw_1.SetFocus()
			dw_1.ScrollToRow(l_row)
			dw_1.SetColumn (DBNAME_USER_FONCTION)
			MessageBox ("Contrôle zone obligatoire", &
								"Vous devez indiquer le profil de l'utilisateur.", &
								StopSign!, Ok!, 1)
			Message.ReturnValue = -1
			RETURN
		END IF

		IF IsNull (s_moteepas) OR s_moteepas = DONNEE_VIDE THEN
			dw_1.SetFocus()
			dw_1.ScrollToRow(l_row)
			dw_1.SetColumn (DBNAME_PASSWORD)
			MessageBox ("Contrôle zone obligatoire", &
								"Vous devez initialiser le mot de passe de l'utilisateur.", &
								StopSign!, Ok!, 1)
			Message.ReturnValue = -1
			RETURN
		END IF

		dw_1.SetItem (l_row, DBNAME_CODE_APPLICATION, g_app.appname)

	NEXT



end event

on w_gestion_users.create
int iCurrent
call super::create
if this.MenuName = "m_multi_ligne" then this.MenuID = create m_multi_ligne
this.cb_ok=create cb_ok
this.cb_annuler=create cb_annuler
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.cb_annuler
end on

on w_gestion_users.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_ok)
destroy(this.cb_annuler)
end on

type dw_1 from w_a_udim`dw_1 within w_gestion_users
integer x = 119
integer y = 136
integer width = 2665
integer height = 984
integer taborder = 20
string dataobject = "d_acces_user"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type uo_statusbar from w_a_udim`uo_statusbar within w_gestion_users
end type

type cb_ok from u_cb_ok within w_gestion_users
integer x = 763
integer y = 1228
integer width = 352
integer height = 96
integer taborder = 30
integer textsize = -8
fontcharset fontcharset = ansi!
string facename = "MS Sans Serif"
string text = "&Ok"
boolean default = false
end type

type cb_annuler from u_cb_cancel within w_gestion_users
integer x = 1513
integer y = 1228
integer width = 352
integer height = 96
integer taborder = 10
integer textsize = -8
fontcharset fontcharset = ansi!
string facename = "MS Sans Serif"
string text = "&Annuler"
end type

