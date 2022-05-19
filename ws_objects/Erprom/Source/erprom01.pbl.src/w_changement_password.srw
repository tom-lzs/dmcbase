$PBExportHeader$w_changement_password.srw
$PBExportComments$Changement de mot passe de l'utilisateur
forward
global type w_changement_password from w_a
end type
type sle_password from u_slea within w_changement_password
end type
type sle_confirmation from u_slea within w_changement_password
end type
type st_1 from statictext within w_changement_password
end type
type st_2 from statictext within w_changement_password
end type
type cb_ok from u_cb_ok within w_changement_password
end type
type cb_annuler from u_cb_cancel within w_changement_password
end type
end forward

global type w_changement_password from w_a
integer x = 769
integer y = 461
integer width = 1778
integer height = 572
string title = "Password modification"
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
long backcolor = 12632256
sle_password sle_password
sle_confirmation sle_confirmation
st_1 st_1
st_2 st_2
cb_ok cb_ok
cb_annuler cb_annuler
end type
global w_changement_password w_changement_password

event ue_ok;call super::ue_ok;// --------------------------------------
// Déclaration des variables locales
// --------------------------------------
	String		s_password
	String		s_confirmation
	String		s_old_password
	Long			l_retrieve
	Datastore	ds_password
	
	ds_password = CREATE DATASTORE
	ds_password.dataobject = 'd_cache_utilisateur'

// ------------------------------------
// Recherche du précedent mot de passe
// ------------------------------------
	ds_password.SetTransObject(i_tr_sql)

	l_retrieve = ds_password.Retrieve (g_app.appname, i_str_pass.s[1])
	CHOOSE CASE l_retrieve
		CASE -1
			f_dmc_error ("Retrieval error in ue_init of w_changement_password")
		CASE 0
			f_dmc_error ("Null retrieval of ds_password in ue_init of w_changement_password")
		CASE ELSE
	END CHOOSE

// --------------------------------------
//  C O N T R O L E S
// --------------------------------------
	s_password 		= Trim (sle_password.Text)
	s_confirmation = Trim (sle_confirmation.Text)

// --------------------------------------
// 1. Saisie obligatoire
// --------------------------------------
	IF s_password = DONNEE_VIDE THEN
		MessageBox (This.title, &
							"Entrer un nouveau mot de passe",&
							StopSign!,Ok!,1)
		sle_password.SetFocus()
		RETURN
	END IF

	IF s_confirmation = DONNEE_VIDE THEN
		MessageBox (This.title, &
							"Confirmer votre nouveau mot de passe",&
							StopSign!,Ok!,1)
		sle_confirmation.SetFocus()
		RETURN
	END IF

// ----------------------------------------------------------------
// 2. Nouveau mot de passe et confirmation doivent être identiques
// ----------------------------------------------------------------
	IF s_confirmation <> s_password THEN
		MessageBox (this.title, &
							"La confirmation de votre mot de passe est érronée", &
							StopSign!,Ok!,1)
		sle_confirmation.SetFocus ()
		RETURN
	END IF

// ---------------------------------------
// 3. Mot de passe différent de l'ancien
// ---------------------------------------
	s_old_password = Trim (ds_password.GetItemString (1, DBNAME_PASSWORD))

	IF s_old_password = s_confirmation THEN
		MessageBox (This.Title, &
							"Le nouveau mot de passe doit être différent de l'ancien", &
							StopSign!,Ok!,1)
		sle_password.SetFocus ()
		RETURN
	END IF

// ---------------------------------------
// MISE A JOUR DU MOT DE PASSE
// ---------------------------------------
	ds_password.SetItem (1, DBNAME_PASSWORD, s_password)

	IF ds_password.Update () = -1 THEN
		f_dmc_error ("An error occur during the update of the password in ue_ok of w_changement_password")
	END IF

	i_str_pass.s_action = ACTION_OK
	i_str_pass.s[1] = s_password
//	CloseWithReturn (This, i_str_pass)
Message.fnv_set_str_pass(i_str_pass)
Close (This)

DESTROY ds_password
end event

event ue_init;call super::ue_init;// ------------------------------------
// Divers
// ------------------------------------
	sle_password.SetFocus()
	sle_password.fu_set_autoselect(TRUE)
	sle_confirmation.fu_set_autoselect(TRUE)

end event

event ue_cancel;call super::ue_cancel;
// ----------------------------
// Fermeture de la fenêtre
// ----------------------------
	i_str_pass.s_action = ACTION_CANCEL
	Message.fnv_set_str_pass(i_str_pass)
	Close (This)

end event

on w_changement_password.create
int iCurrent
call super::create
this.sle_password=create sle_password
this.sle_confirmation=create sle_confirmation
this.st_1=create st_1
this.st_2=create st_2
this.cb_ok=create cb_ok
this.cb_annuler=create cb_annuler
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_password
this.Control[iCurrent+2]=this.sle_confirmation
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.cb_ok
this.Control[iCurrent+6]=this.cb_annuler
end on

on w_changement_password.destroy
call super::destroy
destroy(this.sle_password)
destroy(this.sle_confirmation)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.cb_ok)
destroy(this.cb_annuler)
end on

type sle_password from u_slea within w_changement_password
integer x = 800
integer y = 108
integer width = 366
integer height = 96
integer taborder = 10
boolean password = true
textcase textcase = upper!
integer limit = 10
end type

type sle_confirmation from u_slea within w_changement_password
integer x = 800
integer y = 224
integer width = 366
integer height = 96
integer taborder = 20
boolean password = true
textcase textcase = upper!
integer limit = 10
end type

type st_1 from statictext within w_changement_password
integer x = 46
integer y = 112
integer width = 713
integer height = 72
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "New password :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_changement_password
integer x = 366
integer y = 232
integer width = 393
integer height = 72
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Confirmation :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_ok from u_cb_ok within w_changement_password
integer x = 1344
integer y = 100
integer width = 352
integer height = 96
integer taborder = 0
integer textsize = -8
fontcharset fontcharset = ansi!
string facename = "MS Sans Serif"
string text = "&Ok"
end type

on constructor;call u_cb_ok::constructor;
fu_set_microhelp ("Save and close the window")
end on

type cb_annuler from u_cb_cancel within w_changement_password
integer x = 1344
integer y = 216
integer width = 352
integer height = 96
integer taborder = 0
integer textsize = -8
fontcharset fontcharset = ansi!
string facename = "MS Sans Serif"
string text = "&Cancel"
end type

on constructor;call u_cb_cancel::constructor;
fu_set_microhelp ("Cancel without saving the changes")
end on

