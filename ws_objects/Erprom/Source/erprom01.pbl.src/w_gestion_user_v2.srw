$PBExportHeader$w_gestion_user_v2.srw
forward
global type w_gestion_user_v2 from w_a_udis
end type
type cb_fermer from u_cb_close within w_gestion_user_v2
end type
end forward

global type w_gestion_user_v2 from w_a_udis
integer x = 769
integer y = 461
integer width = 2917
integer height = 1572
string menuname = "m_multi_ligne"
long backcolor = 12632256
cb_fermer cb_fermer
end type
global w_gestion_user_v2 w_gestion_user_v2

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

on w_gestion_user_v2.create
int iCurrent
call super::create
if this.MenuName = "m_multi_ligne" then this.MenuID = create m_multi_ligne
this.cb_fermer=create cb_fermer
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_fermer
end on

on w_gestion_user_v2.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_fermer)
end on

event ue_presave;call super::ue_presave;// ----------------------------------
// CONTRÔLES AVANT SAUVEGARDE
// ----------------------------------
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
	l_row = dw_1.getrow()

	IF l_row = 0 THEN
		RETURN
	END IF

// ----------------------------------
// Boucle de contrôle
// ----------------------------------
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



end event

event ue_insert;call super::ue_insert;long ll_row
ll_row = dw_1.insertRow (0)

dw_1.setrow(ll_row)
end event

event ue_delete;long l_row
i_b_canceled = TRUE

l_row = dw_1.getRow()
if l_row = 0 then
	return
end if

dw_1.deleterow (l_row)
end event

event closequery;// overwrite

end event

type dw_1 from w_a_udis`dw_1 within w_gestion_user_v2
integer x = 69
integer y = 44
integer width = 2683
integer height = 1024
string dataobject = "d_acces_user"
end type

type cb_fermer from u_cb_close within w_gestion_user_v2
integer x = 1458
integer y = 1252
integer width = 352
integer height = 96
integer taborder = 120
boolean bringtotop = true
integer textsize = -8
fontcharset fontcharset = ansi!
string facename = "MS Sans Serif"
boolean cancel = true
end type

