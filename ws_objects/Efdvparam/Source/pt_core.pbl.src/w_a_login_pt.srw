$PBExportHeader$w_a_login_pt.srw
$PBExportComments$Ancêtre des fenêtres de connexion application
forward
global type w_a_login_pt from w_a
end type
type sle_userid from u_slea within w_a_login_pt
end type
type sle_password from u_slea within w_a_login_pt
end type
type st_1 from statictext within w_a_login_pt
end type
type st_2 from statictext within w_a_login_pt
end type
type cb_login from u_cba within w_a_login_pt
end type
type cb_close from u_cba within w_a_login_pt
end type
type cb_changepw from u_cba within w_a_login_pt
end type
end forward

global type w_a_login_pt from w_a
int Width=1450
int Height=545
WindowType WindowType=response!
boolean TitleBar=true
string Title="Connexion à l'application"
long BackColor=1090519039
boolean MinBox=false
boolean MaxBox=false
event ue_login ( unsignedlong wparam,  long lparam )
event ue_changepw ( unsignedlong wparam,  long lparam )
sle_userid sle_userid
sle_password sle_password
st_1 st_1
st_2 st_2
cb_login cb_login
cb_close cb_close
cb_changepw cb_changepw
end type
global w_a_login_pt w_a_login_pt

type variables
PROTECTED:

Boolean i_b_connected	// Successfully connected

Integer i_i_retry_cnt	// Number of login attempts allowed
Integer i_i_attempts	// Number of attempts at login

String i_s_chg_pwd_class	// Classname of password maintenance window
end variables

forward prototypes
public function boolean fw_set_password ()
public subroutine fw_set_chg_pwd_class (string a_s_chg_pwd_class)
public function string fw_get_chg_pwd_class ()
public function boolean fw_validate_user_criteria ()
public function integer fw_get_retry_cnt ()
public subroutine fw_set_retry_cnt (integer a_i_retry_cnt)
public function boolean fw_login ()
end prototypes

on ue_login;call w_a::ue_login;// Log into DBMS and return 'ok' if successful.

SetPointer (HourGlass!)

IF NOT fw_login () THEN
	RETURN
END IF


// Return 'ok' to caller.

i_str_pass.s_action = "ok"

message.fnv_set_str_pass (i_str_pass)

Close (this)
end on

on ue_changepw;call w_a::ue_changepw;// Open the password maintenance dialog only after a successful
// login.  After successfully changing the password, the normal
// login process occurs.


// Bail out the login fails.

IF NOT fw_login () THEN
	RETURN
END IF


// Bail out if the password is not successfully changed.

IF NOT fw_set_password () THEN
	RETURN
END IF


// Trigger normal login processing after resetting the retry count.

i_i_attempts = 0

sle_password.text = g_str_user.s_password

this.TriggerEvent ("ue_login")
end on

public function boolean fw_set_password ();// Open the new password window and return TRUE
// if the password was successfully changed.

Window w_chg_pswd
str_pass str_pass


// Open the password change Window and check the returned action.

Open (w_chg_pswd, this.fw_get_chg_pwd_class ())

str_pass = message.fnv_get_str_pass ()

message.fnv_clear_str_pass ()

IF str_pass.s_action = "ok" THEN
	RETURN TRUE
END IF

RETURN FALSE
end function

public subroutine fw_set_chg_pwd_class (string a_s_chg_pwd_class);
//*****************************************************************************
// Set value of instance variable to value passed.

i_s_chg_pwd_class = a_s_chg_pwd_class
end subroutine

public function string fw_get_chg_pwd_class ();
//*****************************************************************************
// Return value of instance variable.

RETURN i_s_chg_pwd_class
end function

public function boolean fw_validate_user_criteria ();// Stub.  Defined in descendent.

RETURN TRUE
end function

public function integer fw_get_retry_cnt ();// Return value of instance variable.

RETURN i_i_retry_cnt
end function

public subroutine fw_set_retry_cnt (integer a_i_retry_cnt);// Set value of instance variable.

i_i_retry_cnt = a_i_retry_cnt
end subroutine

public function boolean fw_login ();//*****************************************************************************
// Log into DBMS specified in application .INI file.
// Returns:
//	 TRUE	Login successful
//	FALSE	Login unsuccessful
//*****************************************************************************

string s_userid, s_password, s_first, s_mi, s_last, s_active_ind, s_dbms
long	l_user_skey, l_profile_skey


// The user has i_i_retry_cnt attempts to log in.

i_i_attempts ++

IF i_i_attempts > i_i_retry_cnt THEN
	g_nv_msg_mgr.fnv_process_msg ("pt", "Max Login Attempts", &
												String (i_i_retry_cnt), "", 0, 0)
	Close (this)
	RETURN FALSE
END IF


// Validate UserID and Password entered.

IF Len (sle_userid.Text) < 1 THEN
	g_nv_msg_mgr.fnv_process_msg ("pt", "UserID Required", "", "", 0, 0)
	sle_userid.SetFocus ()
	RETURN FALSE
END IF

IF Len (sle_password.Text) < 1 THEN
	g_nv_msg_mgr.fnv_process_msg ("pt", "Password Required", "", "", 0, 0)
	sle_password.SetFocus ()
	RETURN FALSE
END IF


// The USERID and PASSWORD are passed to fnv_ini_connect to connect
// to the current datasource in the user's INI file (&current).

SetPointer (HourGlass!)

sle_userid.text = Trim (sle_userid.text)
sle_password.text = Trim (sle_password.text)

IF NOT i_b_connected THEN
	IF i_tr_sql.fnv_ini_connect ("&current", sle_userid.text, &
													sle_password.text ) <> 0 THEN
		RETURN FALSE
	ELSE
		i_b_connected = TRUE
	END IF
END IF


// Retrieve user info from user table.

s_userid = sle_userid.text

  SELECT	pc_user_def.password,
			pc_user_def.user_skey,
			pc_user_def.profile_skey,
			pc_user_def.first_name,
			pc_user_def.mi,
			pc_user_def.last_name,
			pc_user_def.active_ind
    INTO	:s_password,
			:l_user_skey,
			:l_profile_skey,
			:s_first,
			:s_mi,
			:s_last,
			:s_active_ind
    FROM	pc_user_def
   WHERE	pc_user_def.user_id = :s_userid
   USING	i_tr_sql;

IF i_tr_sql.SQLCode = 100 THEN
	g_nv_msg_mgr.fnv_process_msg ("pt", "UserID Not Found", "", "", 0, 0)
	sle_userid.SetFocus ()
	i_b_connected = FALSE
	DISCONNECT &
		USING i_tr_sql;
	RETURN FALSE
END IF

IF i_tr_sql.SQLCode < 0 THEN
	i_tr_sql.fnv_sql_error ("w_a_login_pt", "fw_login")
	RETURN FALSE
END IF

  COMMIT &
	USING i_tr_sql;

//	Add the following trims to support Informix padding

s_first = trim (s_first)
s_mi = trim (s_mi)
s_last =	trim (s_last)
s_active_ind =	trim (s_active_ind)

// For Oracle and Sybase, the ID and PASSWORD are validated by the
// DBMS.  For all others, validate against the application's user table.

s_dbms = Upper (i_tr_sql.DBMS)

IF Left (s_dbms, 6) = "TRACE " THEN		// bypass trace option
	s_dbms = Trim (Mid (s_dbms, 6))
END IF

s_dbms = Left (s_dbms, 2)					// check first two chars

CHOOSE CASE s_dbms

	CASE "OR", "O7", "07", "MS", "SY", "IN"

		// ID and PASSWORD are validated by the DBMS.

	CASE ELSE

		IF sle_password.text <> s_password THEN
			g_nv_msg_mgr.fnv_process_msg ("pt", "Password Not Matched", "", "", 0, 0)
			sle_password.SetFocus ()
			RETURN FALSE
		END IF

END CHOOSE

// Test active indicator

IF Lower (s_active_ind) <> "a" THEN
	g_nv_msg_mgr.fnv_process_msg ("pt", "UserID Not Active", "", "", 0, 0)
	sle_userid.SetFocus ()
	i_b_connected = FALSE
	DISCONNECT &
		USING i_tr_sql;
	RETURN FALSE
END IF


// Populate user info structure with data retrieved from user table.

g_str_user.s_userid = sle_userid.text

g_str_user.s_password = sle_password.text

g_str_user.l_user_skey = l_user_skey

g_str_user.l_profile_skey = l_profile_skey

IF Len (Trim (s_mi)) > 0 THEN
	g_str_user.s_username = Trim (s_first) + " " + Trim (s_mi) + &
							" " + Trim (s_last)
ELSE
	g_str_user.s_username = Trim (s_first) + " " + Trim (s_last)
END IF


// Update the application .INI file with the last user id entered.

g_nv_ini.fnv_set_profile_string (GetApplication ().AppName, &
													"LoginID", sle_userid.text)


// Perform additional validation as required.

RETURN (fw_validate_user_criteria ())
end function

on open;call w_a::open;// Number of login attempts may be passed in str_pass.d [1].
// Change password classname may be passed in str_pass.s [1].


this.fw_center_window ()


// Retrieve login attempts from passing structure.

IF UpperBound (i_str_pass.d) > 0 THEN
	this.fw_set_retry_cnt (i_str_pass.d [1])
ELSE
	this.fw_set_retry_cnt (3)
END IF


// Set default password change window.

IF UpperBound (i_str_pass.s) > 0 THEN
	this.fw_set_chg_pwd_class (i_str_pass.s [1])
ELSE
	this.fw_set_chg_pwd_class ("w_a_chg_password")
END IF


// Retrieve last login id from application .INI file.

sle_userid.text = g_nv_ini.fnv_profile_string &
								(GetApplication ().AppName, "LoginID", "")

IF Len (sle_userid.text) < 1 THEN
	sle_userid.SetFocus ()
ELSE
	sle_password.SetFocus ()
END IF
end on

on ue_cancel;call w_a::ue_cancel;Close (this)
end on

on ue_close;call w_a::ue_close;Close (this)
end on

on w_a_login_pt.create
int iCurrent
call w_a::create
this.sle_userid=create sle_userid
this.sle_password=create sle_password
this.st_1=create st_1
this.st_2=create st_2
this.cb_login=create cb_login
this.cb_close=create cb_close
this.cb_changepw=create cb_changepw
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=sle_userid
this.Control[iCurrent+2]=sle_password
this.Control[iCurrent+3]=st_1
this.Control[iCurrent+4]=st_2
this.Control[iCurrent+5]=cb_login
this.Control[iCurrent+6]=cb_close
this.Control[iCurrent+7]=cb_changepw
end on

on w_a_login_pt.destroy
call w_a::destroy
destroy(this.sle_userid)
destroy(this.sle_password)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.cb_login)
destroy(this.cb_close)
destroy(this.cb_changepw)
end on

type sle_userid from u_slea within w_a_login_pt
int X=682
int Y=49
int Width=682
int TabOrder=10
end type

on ue_postchar;// Login/Change Password enabled only if UserID and Password are entered.

IF Len (this.text) > 0 AND &
	Len (sle_password.text) > 0 THEN
	cb_login.enabled = TRUE
	cb_changepw.enabled = TRUE
ELSE
	cb_login.enabled = FALSE
	cb_changepw.enabled = FALSE
END IF
end on

on constructor;call u_slea::constructor;
//*****************************************************************************
// Set autoselection on.

this.fu_set_autoselect (TRUE)
end on

type sle_password from u_slea within w_a_login_pt
int X=682
int Y=161
int Width=682
int TabOrder=20
boolean PassWord=true
int TextSize=-8
end type

on ue_postchar;// Login/Change Password enabled only if UserID and Password are entered.

IF Len (this.text) > 0 AND &
	Len (sle_userid.text) > 0 THEN
	cb_login.enabled = TRUE
	cb_changepw.enabled = TRUE
ELSE
	cb_login.enabled = FALSE
	cb_changepw.enabled = FALSE
END IF
end on

on constructor;call u_slea::constructor;
//*****************************************************************************
// Set autoselection on.

this.fu_set_autoselect (TRUE)
end on

type st_1 from statictext within w_a_login_pt
int X=375
int Y=69
int Width=298
int Height=61
string Text="Utilisateur:"
Alignment Alignment=Right!
boolean FocusRectangle=false
long TextColor=33554432
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_2 from statictext within w_a_login_pt
int X=284
int Y=181
int Width=394
int Height=77
boolean Enabled=false
string Text="Mot de passe:"
Alignment Alignment=Right!
boolean FocusRectangle=false
long TextColor=33554432
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_login from u_cba within w_a_login_pt
int X=42
int Y=293
int TabOrder=30
boolean Enabled=false
string Text="Connexion"
boolean Default=true
end type

on constructor;call u_cba::constructor;
//*****************************************************************************
this.fu_setevent ("ue_login")
end on

type cb_close from u_cba within w_a_login_pt
int X=1011
int Y=293
int TabOrder=50
string Text="&Fermer"
boolean Cancel=true
end type

on constructor;call u_cba::constructor;
//*****************************************************************************
this.fu_setevent ("ue_close")
end on

type cb_changepw from u_cba within w_a_login_pt
int X=412
int Y=293
int Width=581
int TabOrder=40
boolean Enabled=false
string Text="Nouv. Mot de passe"
end type

on constructor;call u_cba::constructor;
//*****************************************************************************
this.fu_setevent ("ue_changepw")
end on

