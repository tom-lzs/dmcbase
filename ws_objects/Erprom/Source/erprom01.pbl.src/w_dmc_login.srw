$PBExportHeader$w_dmc_login.srw
$PBExportComments$Login
forward
global type w_dmc_login from w_a
end type
type cb_cancel from u_cb_cancel within w_dmc_login
end type
type cb_ok from u_cb_ok within w_dmc_login
end type
type sle_useefrid from u_slea within w_dmc_login
end type
type sle_moteepas from u_slea within w_dmc_login
end type
type st_moteepas from statictext within w_dmc_login
end type
type st_useefrid from statictext within w_dmc_login
end type
type p_logo from picture within w_dmc_login
end type
type cb_moteepas from u_cba within w_dmc_login
end type
type dw_cache_utilisateur from datawindow within w_dmc_login
end type
end forward

global type w_dmc_login from w_a
integer width = 1829
integer height = 628
string title = "Connexion"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
long backcolor = 12632256
event ue_password pbm_custom40
cb_cancel cb_cancel
cb_ok cb_ok
sle_useefrid sle_useefrid
sle_moteepas sle_moteepas
st_moteepas st_moteepas
st_useefrid st_useefrid
p_logo p_logo
cb_moteepas cb_moteepas
dw_cache_utilisateur dw_cache_utilisateur
end type
global w_dmc_login w_dmc_login

type variables
// Nombre de tentative
Integer	i_i_essai


end variables

forward prototypes
public function boolean fw_controle ()
end prototypes

event ue_password;// ----------------------------------------------
// CHANGEMENT DU MOT DE PASSE APRES CONTROLE
// ----------------------------------------------
	IF fw_controle () THEN
		OpenWithParm (w_changement_password, i_str_pass)

		i_str_pass = Message.fnv_get_str_pass()
		Message.fnv_clear_str_pass()

		CHOOSE CASE i_str_pass.s_action
			CASE ACTION_OK
				sle_moteepas.Text = i_str_pass.s[1]
				cb_ok.SetFocus()
			CASE ACTION_CANCEL
				cb_ok.SetFocus()
			CASE ELSE
				f_dmc_error ("Action invalide dans ue_password de w_dmc_login")
		END CHOOSE

	ELSE
		IF i_i_essai = 3 THEN
			i_str_pass.s_action = ACTION_CANCEL
			Message.fnv_set_str_pass(i_str_pass)
			Close (This)
		END IF
	END IF

end event

public function boolean fw_controle ();
// ------------------------------------------
// DECLARATION DES VARIABLES LOCALES
// ------------------------------------------
Long			l_retrieve
Datastore 	ds_cache_utilisateur
DateTime		dt_dteefxpr

ds_cache_utilisateur = CREATE DATASTORE
ds_cache_utilisateur.dataobject = 'd_cache_utilisateur'
ds_cache_utilisateur.SetTransObject (i_tr_sql)

// ------------------------------------------
// CONTRÔLE DES CHAMPS SAISIS
// ------------------------------------------
IF Trim (sle_useefrid.Text) = "" THEN
	MessageBox ("Attention!","Veuillez saisir votre code utilisateur.",Information!,Ok!,1)
	sle_useefrid.SetFocus ()
	RETURN FALSE
END IF

IF Trim (sle_moteepas.Text) = "" THEN
	MessageBox ("Attention!","Veuillez saisir votre mot de passe.",Information!,Ok!,1)
	sle_moteepas.SetFocus ()
	RETURN FALSE
END IF

l_retrieve = ds_cache_utilisateur.Retrieve ('erprom', UPPER(sle_useefrid.Text))

CHOOSE CASE l_retrieve
	CASE -1
		f_dmc_error ("Erreur Retrieve i_ds_cache_utilisateur dans ue_init de w_login")
	CASE 0
		MessageBox ("Message","Code incorrect !",StopSign!,Ok!,1)
		i_i_essai = i_i_essai + 1
		sle_useefrid.SetFocus ()
		destroy ds_cache_utilisateur
		RETURN FALSE
	CASE ELSE
		IF sle_moteepas.Text <> ds_cache_utilisateur.GetItemString (1,DBNAME_PASSWORD) THEN
			MessageBox ("Message","Mot de passe incorrect !",StopSign!,Ok!,1)
			i_i_essai = i_i_essai + 1
			sle_moteepas.SetFocus ()
			destroy ds_cache_utilisateur			
			RETURN FALSE
		END IF
END CHOOSE


i_str_pass.s[1] = sle_useefrid.Text
i_str_pass.s[2] = ds_cache_utilisateur.GetItemString (1, DBNAME_NOM_USER) + " " + &
				      ds_cache_utilisateur.GetItemString (1, DBNAME_PRENOM)
i_str_pass.s[3] = ds_cache_utilisateur.GetItemString (1, DBNAME_USER_FONCTION)
destroy ds_cache_utilisateur
RETURN TRUE
end function

event ue_init;call super::ue_init;
// ------------------------------------------
// INITIALISATION DE LA FENÊTRE
// ------------------------------------------
	Integer	i_file
	String	s_code
// CBE TO DELETE
	RETURN
	// CBE END
	i_file = FileOpen ("c:\usractif.dat", LineMode!, Read!)
	FileRead (i_file, s_code)
	FileClose (i_file)

	s_code = Trim (s_code)
	IF IsNull(s_code) OR s_code = DONNEE_VIDE THEN
		sle_useefrid.SetFocus()
	ELSE
		sle_useefrid.Text = s_code
		sle_moteepas.SetFocus()
	END IF

	sle_moteepas.fu_set_autoselect (TRUE)
	sle_useefrid.fu_set_autoselect (TRUE)

end event

event ue_ok;// ----------------------------------------------
// FERMETURE DE LA FENÊTRE APRES CONTROLE
// ----------------------------------------------
	IF fw_controle () THEN
		i_str_pass.s_action = ACTION_OK
		Message.fnv_set_str_pass(i_str_pass)
		Close (This)

	ELSE
		IF i_i_essai = 3 THEN
			i_str_pass.s_action = ACTION_CANCEL
			Message.fnv_set_str_pass(i_str_pass)
			Close (This)
		END IF

	END IF
	
	
end event

on w_dmc_login.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.sle_useefrid=create sle_useefrid
this.sle_moteepas=create sle_moteepas
this.st_moteepas=create st_moteepas
this.st_useefrid=create st_useefrid
this.p_logo=create p_logo
this.cb_moteepas=create cb_moteepas
this.dw_cache_utilisateur=create dw_cache_utilisateur
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.sle_useefrid
this.Control[iCurrent+4]=this.sle_moteepas
this.Control[iCurrent+5]=this.st_moteepas
this.Control[iCurrent+6]=this.st_useefrid
this.Control[iCurrent+7]=this.p_logo
this.Control[iCurrent+8]=this.cb_moteepas
this.Control[iCurrent+9]=this.dw_cache_utilisateur
end on

on w_dmc_login.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.sle_useefrid)
destroy(this.sle_moteepas)
destroy(this.st_moteepas)
destroy(this.st_useefrid)
destroy(this.p_logo)
destroy(this.cb_moteepas)
destroy(this.dw_cache_utilisateur)
end on

event ue_cancel;call super::ue_cancel;// --------------------------------------
// FERMETURE DE LA FENÊTRE
// --------------------------------------
	i_str_pass.s_action = ACTION_CANCEL
	Message.fnv_set_str_pass(i_str_pass)
	Close (This)
end event

type cb_cancel from u_cb_cancel within w_dmc_login
integer x = 1294
integer y = 220
integer width = 416
integer height = 104
integer taborder = 0
integer textsize = -8
fontcharset fontcharset = ansi!
string facename = "MS Sans Serif"
string text = "&Annuler"
end type

type cb_ok from u_cb_ok within w_dmc_login
integer x = 1294
integer y = 108
integer width = 416
integer height = 104
integer taborder = 0
integer textsize = -8
fontcharset fontcharset = ansi!
string facename = "MS Sans Serif"
string text = "&OK"
end type

type sle_useefrid from u_slea within w_dmc_login
integer x = 768
integer y = 212
integer width = 379
integer height = 84
integer taborder = 10
long backcolor = 16777215
textcase textcase = upper!
integer limit = 8
end type

type sle_moteepas from u_slea within w_dmc_login
integer x = 768
integer y = 328
integer width = 379
integer height = 84
integer taborder = 20
integer weight = 700
long backcolor = 16777215
boolean password = true
textcase textcase = upper!
integer limit = 10
end type

type st_moteepas from statictext within w_dmc_login
integer x = 174
integer y = 336
integer width = 489
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 8388608
long backcolor = 12632256
boolean enabled = false
string text = "Mot de passe :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_useefrid from statictext within w_dmc_login
integer x = 110
integer y = 220
integer width = 553
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 8388608
long backcolor = 12632256
boolean enabled = false
string text = "Code utilisateur :"
alignment alignment = right!
boolean focusrectangle = false
end type

type p_logo from picture within w_dmc_login
integer x = 128
integer y = 16
integer width = 293
integer height = 256
boolean originalsize = true
string picturename = "C:\appscir\Erprom\Source\KEY.BMP"
boolean focusrectangle = false
end type

type cb_moteepas from u_cba within w_dmc_login
integer x = 1294
integer y = 360
integer width = 416
integer height = 104
integer taborder = 0
integer textsize = -8
fontcharset fontcharset = ansi!
string facename = "MS Sans Serif"
string text = "&Mot de passe"
end type

on constructor;call u_cba::constructor;
fu_setevent ("ue_password")

fu_set_microhelp ("Changement du mot de passe")
end on

type dw_cache_utilisateur from datawindow within w_dmc_login
boolean visible = false
integer x = 608
integer y = 12
integer width = 494
integer height = 104
string dataobject = "d_cache_utilisateur"
boolean livescroll = true
end type

