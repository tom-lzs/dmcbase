$PBExportHeader$w_dmc_login.srw
$PBExportComments$Permet le controle de l'identification demande dans le cas de la suppression d'un visiteur
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
type dw_cache_utilisateur from datawindow within w_dmc_login
end type
end forward

global type w_dmc_login from w_a
integer width = 1829
integer height = 492
string title = "Connexion"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
long backcolor = 12632256
cb_cancel cb_cancel
cb_ok cb_ok
sle_useefrid sle_useefrid
sle_moteepas sle_moteepas
st_moteepas st_moteepas
st_useefrid st_useefrid
p_logo p_logo
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

public function boolean fw_controle ();/* <DESC>
      Permet d'effectuer le controle des informations saisies:
		Le code utilisateur et le mot de passe sont obligatoires
		Le code utilisateur doit être existant et le mot de passe valide
		Le niveau d'acces doit être de niveau Administrateur
   </DESC> */
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

l_retrieve = ds_cache_utilisateur.Retrieve (GetApplication().AppName, UPPER(sle_useefrid.Text))

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
		IF sle_moteepas.Text <> ds_cache_utilisateur.GetItemString (1,"moteepas") THEN
			MessageBox ("Message","Mot de passe incorrect !",StopSign!,Ok!,1)
			i_i_essai = i_i_essai + 1
			sle_moteepas.SetFocus ()
			destroy ds_cache_utilisateur			
			RETURN FALSE
		END IF
END CHOOSE

if  ds_cache_utilisateur.GetItemString (1, "cdeeefct") <> "999" then
	MessageBox ("Message","Vous n'êtes pas autorisé à effectuer cet opération!",StopSign!,Ok!,1)
	i_i_essai = i_i_essai + 1
	sle_moteepas.SetFocus ()
	destroy ds_cache_utilisateur			
	RETURN FALSE	
end if

destroy ds_cache_utilisateur
RETURN TRUE
end function

event ue_init;call super::ue_init;/* <DESC>
       Permet l'initialisation de la fenetre en affichante dans le code utilistauer le code utilise pour
		 l'ouverture de la session Windows
   </DESC> */ 
	Integer	i_file
	String	s_code
	
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

event ue_ok;/* <DESC> 
     Permet la validation des données saisies
	  Si la saisie n'est pas valide au bout de 3 essais, fermeture de la fenetre
   </DESC> */
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
this.dw_cache_utilisateur=create dw_cache_utilisateur
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.sle_useefrid
this.Control[iCurrent+4]=this.sle_moteepas
this.Control[iCurrent+5]=this.st_moteepas
this.Control[iCurrent+6]=this.st_useefrid
this.Control[iCurrent+7]=this.p_logo
this.Control[iCurrent+8]=this.dw_cache_utilisateur
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
destroy(this.dw_cache_utilisateur)
end on

event ue_cancel;call super::ue_cancel;/* <DESC>  
     Permet de quitter la saisie de l'identification sans validation 
   </DESC> */
	i_str_pass.s_action = ACTION_CANCEL
	Message.fnv_set_str_pass(i_str_pass)
	Close (This)
end event

type cb_cancel from u_cb_cancel within w_dmc_login
integer x = 1024
integer y = 288
integer width = 416
integer height = 104
integer taborder = 0
integer textsize = -8
fontcharset fontcharset = ansi!
string facename = "MS Sans Serif"
string text = "&Annuler"
end type

type cb_ok from u_cb_ok within w_dmc_login
integer x = 567
integer y = 288
integer width = 416
integer height = 104
integer taborder = 0
integer textsize = -8
fontcharset fontcharset = ansi!
string facename = "MS Sans Serif"
string text = "&OK"
end type

type sle_useefrid from u_slea within w_dmc_login
integer x = 1221
integer y = 32
integer width = 485
integer height = 84
integer taborder = 10
long backcolor = 16777215
textcase textcase = upper!
integer limit = 8
end type

type sle_moteepas from u_slea within w_dmc_login
integer x = 1221
integer y = 136
integer width = 485
integer height = 84
integer taborder = 20
integer weight = 700
long backcolor = 16777215
boolean password = true
textcase textcase = upper!
integer limit = 10
end type

type st_moteepas from statictext within w_dmc_login
integer x = 626
integer y = 144
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
integer x = 553
integer y = 40
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
integer height = 208
string picturename = "C:\appscir\Efdvparam\Image\KEY.BMP"
boolean focusrectangle = false
end type

type dw_cache_utilisateur from datawindow within w_dmc_login
boolean visible = false
integer x = 9
integer y = 272
integer width = 494
integer height = 68
string dataobject = "d_cache_utilisateur"
boolean livescroll = true
end type

