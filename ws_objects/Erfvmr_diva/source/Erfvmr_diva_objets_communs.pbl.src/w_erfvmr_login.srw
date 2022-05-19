$PBExportHeader$w_erfvmr_login.srw
$PBExportComments$Fenêtre d'identification du visiteur
forward
global type w_erfvmr_login from w_a
end type
type p_1 from picture within w_erfvmr_login
end type
type st_password from statictext within w_erfvmr_login
end type
type sle_password from u_slea_key within w_erfvmr_login
end type
type em_visiteur from u_ema within w_erfvmr_login
end type
type st_visiteur from statictext within w_erfvmr_login
end type
type p_logo from picture within w_erfvmr_login
end type
type p_2 from picture within w_erfvmr_login
end type
type r_1 from rectangle within w_erfvmr_login
end type
end forward

global type w_erfvmr_login from w_a
integer x = 5
integer y = 428
integer width = 1906
integer height = 968
string title = "User identification"
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
long backcolor = 12632256
boolean center = true
p_1 p_1
st_password st_password
sle_password sle_password
em_visiteur em_visiteur
st_visiteur st_visiteur
p_logo p_logo
p_2 p_2
r_1 r_1
end type
global w_erfvmr_login w_erfvmr_login

type variables
Integer		i_i_essai     /* Va permettre de comptabiliser le nombre d'essai */
end variables

event ue_ok;call super::ue_ok;/*<DESC>
 Validation de la saisie du code utilisateur et de son mot de passe
     1- Controle que le code visiteur a bient été renseigné
     2- Controle de l'existence du code visiteur dans la base de données
     3- Controle de la validité du mot de passe
     4- Creation de l'objet (nv_come9par) contenant les informations du visteur
 </DESC> */

Long		    l_retrieve, ll_row
String		s_visiteur
str_pass    l_str_pass
String        ls_message
nv_datastore lds_datastore
nv_control_manager lnv_control_manager

lnv_control_manager = CREATE nv_control_manager

ls_message = " It is your first use of the application.  " + &
                           " First of all it is necessary that your data are updated. ~r~n"+ &
					   " For that, it is necessary to be to connect to the network to allow these updates. ~r~n" + & 
						"               - Once to connect, click on Yes.  ~r~n "  +  &
						"               - If you wish to carry out this setting later on, to click on No"

i_i_essai  = i_i_essai + 1


/*  CONTROLE CODE VISITEUR */
s_visiteur = em_visiteur.Text
if trim(s_visiteur) = DONNEE_VIDE then
	MessageBox (This.title, "User ID is mandatory", StopSign!,YesNo!,1)
	return
end if

g_s_visiteur = s_visiteur
g_nv_come9par = CREATE nv_come9par
l_retrieve = g_nv_come9par.get_return_code()

/*  Controle de l'accès aux données*/
	CHOOSE CASE l_retrieve
		CASE DB_ERROR
			f_dmc_error (this.title + BLANK +  DB_ERROR_MESSAGE)
			
		CASE NOT_FOUND
			IF i_i_essai = 3 THEN
				MessageBox (This.title, "User ID doesn't exist", StopSign!,Ok!,1)
				This.TriggerEvent ("ue_cancel")
				
			ELSE
				MessageBox (This.title, "User ID doesn't exist" , Information!,Ok!,1)
				DESTROY g_nv_come9par
			END IF
			
			RETURN
	END CHOOSE
	
/* Contrôle du mot de passe */
	IF upper(Trim (sle_password.Text)) <> upper(Trim (g_nv_come9par.get_password())) THEN
			IF i_i_essai = 3 THEN 
					MessageBox (this.title, "Incorrect Password", StopSign!,Ok!,1)
					This.TriggerEvent ("ue_cancel")
				ELSE
					MessageBox (this.title, "Incorrect Password" , Information!,Ok!,1)
					sle_password.SetFocus ()
			END IF
			DESTROY g_nv_come9par
			RETURN
	END IF
		
/*  Controle si le visiteur connecte est bien celui qui a initialisé le portable et ceci uniquement
	en mode portable */
if  upper(g_nv_ini.fnv_profile_string("Param","ModePortable","NON")) = "OUI" then
	lds_datastore = create nv_datastore
	lds_datastore .dataobject = "d_visiteur_autorise"
	lds_datastore.setTrans (SQLCA)
	lds_datastore.retrieve(g_s_visiteur)
	if lds_datastore.rowcount() =  0 then
		ll_row = lds_datastore.insertrow( 0)
		lds_datastore.setItem(ll_row,DBNAME_CODE_VISITEUR,g_s_visiteur)
		lds_datastore.update()
	else
		String toto
		toto = lds_datastore.GetItemString(1,DBNAME_CODE_VISITEUR)
		  if lds_datastore.GetItemString(1,DBNAME_CODE_VISITEUR) <> g_s_visiteur then
				MessageBox (this.title, "Your user id is not authorized to use this application", StopSign!,Ok!,1)
			 This.TriggerEvent ("ue_cancel")
			 return
		end if
	end if
	destroy lds_datastore
end if

g_nv_traduction = Create nv_traduction
	
if not g_nv_traduction.is_traduction_chargee() then
     if messagebox ("Application Setup",ls_message,Stopsign!,YesNo!) = 2 then
		triggerevent("ue_cancel")
		return
	 end if
	openwithparm (w_mise_a_jour_base_locale,l_str_pass)
	l_str_pass = Message.fnv_get_str_pass()
	Message.fnv_clear_str_pass()
	if l_str_pass.s_action = ACTION_CANCEL then
		Close (This)
		return
	end if
	destroy nv_traduction
	g_nv_traduction = Create nv_traduction	
end if

g_s_version = lnv_control_manager.get_version( )
g_s_patch  = lnv_control_manager.get_patch( )
destroy g_nv_come9par 
destroy lnv_control_manager

g_nv_come9par = CREATE nv_come9par
i_str_pass.s_action = ACTION_OK
Message.fnv_set_str_pass(i_str_pass)
Close (This)
end event

event key;call super::key;/*<DESC>
      Permet de trapper les touches de fonction activées et déclencher l'évènement associé
	à la touche.
	  ESC = Quitter l'application
   </DESC> */

IF KeyDown (KeyEscape!) THEN
	This.TriggerEvent ("ue_cancel")
END IF
end event

event ue_init;call super::ue_init;/*<DESC>
    Permet d'initialiser la fenetre avant son affichage 
 </DESC> */
	sle_password.fu_set_autoselect (TRUE)
	
	/* Accès à la table des visiteurs pour controler l'existence ou non
	   de données. Si aucune donnée, il s'agit de la première connexion à
	   l'application */

 nv_datastore  lnv_datastore
 lnv_datastore = create nv_datastore
 
 lnv_datastore.dataobject  = "d_liste_visiteur"
 lnv_datastore.settrans(sqlca)
 if lnv_datastore.retrieve() = DB_ERROR then
	f_dmc_error (this.title +  BLANK +  DB_ERROR_MESSAGE)
 end if
 
 if lnv_datastore.rowcount( ) = 0 then
	
	str_pass l_str_pass
	openwithparm (w_user_setup,l_str_pass)
	l_str_pass = Message.fnv_get_str_pass()
	Message.fnv_clear_str_pass()

 	if l_str_pass.s_action  = ACTION_CANCEL then
		triggerevent("ue_cancel")
		return
 	end if
	 em_visiteur.text = l_str_pass.s[1] 
	 sle_password.text = l_str_pass.s[1]
	 sle_password.setfocus( )
 end if
 
 this.visible = true
 
end event

event ue_cancel;call super::ue_cancel;/*<DESC>
     Permet de quitter l'application soit par demande de l'utilisateur ou de 3 essais
 </DESC> */
	DESTROY g_nv_come9par
	i_str_pass.s_action = "cancel"
	Message.fnv_set_str_pass(i_str_pass)
	Close (This)
end event

on w_erfvmr_login.create
int iCurrent
call super::create
this.p_1=create p_1
this.st_password=create st_password
this.sle_password=create sle_password
this.em_visiteur=create em_visiteur
this.st_visiteur=create st_visiteur
this.p_logo=create p_logo
this.p_2=create p_2
this.r_1=create r_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
this.Control[iCurrent+2]=this.st_password
this.Control[iCurrent+3]=this.sle_password
this.Control[iCurrent+4]=this.em_visiteur
this.Control[iCurrent+5]=this.st_visiteur
this.Control[iCurrent+6]=this.p_logo
this.Control[iCurrent+7]=this.p_2
this.Control[iCurrent+8]=this.r_1
end on

on w_erfvmr_login.destroy
call super::destroy
destroy(this.p_1)
destroy(this.st_password)
destroy(this.sle_password)
destroy(this.em_visiteur)
destroy(this.st_visiteur)
destroy(this.p_logo)
destroy(this.p_2)
destroy(this.r_1)
end on

event open;call super::open;this.visible = false
end event

type uo_statusbar from w_a`uo_statusbar within w_erfvmr_login
end type

type p_1 from picture within w_erfvmr_login
integer x = 73
integer y = 448
integer width = 823
integer height = 388
string picturename = "c:\appscir\Erfvmr_diva\Image\logo.jpg"
boolean focusrectangle = false
end type

type st_password from statictext within w_erfvmr_login
integer x = 553
integer y = 240
integer width = 489
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 12632256
boolean enabled = false
string text = "Password  :"
boolean focusrectangle = false
end type

type sle_password from u_slea_key within w_erfvmr_login
integer x = 1083
integer y = 236
integer width = 576
integer height = 84
integer taborder = 20
integer textsize = -10
boolean password = true
integer limit = 10
end type

on we_keydown;call u_slea_key::we_keydown;
// ----------------------------------
// DECLENCHEMENT DE UE_OK
// ----------------------------------
	IF KeyDown (KeyEnter!) THEN
		Parent.TriggerEvent ("ue_ok")
	END IF
end on

type em_visiteur from u_ema within w_erfvmr_login
integer x = 1083
integer y = 108
integer width = 576
integer height = 84
integer taborder = 10
textcase textcase = upper!
string mask = "!!!"
boolean autoskip = true
end type

event getfocus;call super::getfocus;
// ----------------------------------
// SELECTION DE LA ZONE
// ----------------------------------
	em_visiteur.SelectText (1, len(em_visiteur.Text))
end event

type st_visiteur from statictext within w_erfvmr_login
integer x = 562
integer y = 120
integer width = 485
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 12632256
boolean enabled = false
string text = "User Id :"
boolean focusrectangle = false
end type

type p_logo from picture within w_erfvmr_login
integer x = 123
integer y = 80
integer width = 293
integer height = 256
boolean originalsize = true
string picturename = "c:\appscir\Erfvmr_diva\Image\KEY.BMP"
boolean focusrectangle = false
end type

type p_2 from picture within w_erfvmr_login
integer x = 1207
integer y = 448
integer width = 439
integer height = 384
boolean bringtotop = true
string picturename = "c:\appscir\Erfvmr_diva\Image\LogoPegasus.jpg"
boolean focusrectangle = false
end type

type r_1 from rectangle within w_erfvmr_login
long linecolor = 16711680
integer linethickness = 4
long fillcolor = 12632256
integer x = 46
integer y = 44
integer width = 1774
integer height = 368
end type

