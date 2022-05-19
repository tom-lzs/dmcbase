$PBExportHeader$w_a_chg_password_pt.srw
$PBExportComments$Ancêtre des fenêtres de changement de mot de passe
forward
global type w_a_chg_password_pt from w_a
end type
type sle_oldpass from u_slea within w_a_chg_password_pt
end type
type sle_newpass1 from u_slea within w_a_chg_password_pt
end type
type sle_newpass2 from u_slea within w_a_chg_password_pt
end type
type cb_ok from u_cb_ok within w_a_chg_password_pt
end type
type cb_cancel from u_cb_cancel within w_a_chg_password_pt
end type
type st_1 from statictext within w_a_chg_password_pt
end type
type st_2 from statictext within w_a_chg_password_pt
end type
type st_3 from statictext within w_a_chg_password_pt
end type
end forward

global type w_a_chg_password_pt from w_a
int Width=1249
int Height=593
WindowType WindowType=response!
boolean TitleBar=true
string Title="Change le mot de passe"
long BackColor=1090519039
boolean MinBox=false
boolean MaxBox=false
sle_oldpass sle_oldpass
sle_newpass1 sle_newpass1
sle_newpass2 sle_newpass2
cb_ok cb_ok
cb_cancel cb_cancel
st_1 st_1
st_2 st_2
st_3 st_3
end type
global w_a_chg_password_pt w_a_chg_password_pt

type variables

end variables

event ue_ok;call super::ue_ok;// Change the password for the current user and close the Response!
// Window if successful.

String s_userid, s_password, s_newpass1, s_newpass2, s_dbms, s_command_sql
Boolean b_pw_changed = TRUE
DateTime	dt_datetime


// Verify that old and new passwords are entered.

s_userid = g_str_user.s_userid
s_password = g_str_user.s_password

s_newpass1 = Trim (sle_newpass1.text)
s_newpass2 = Trim (sle_newpass2.text)

IF sle_oldpass.Text <> s_password THEN
	g_nv_msg_mgr.fnv_process_msg ("pt", "Old Pass Not Matched", "", "", 0, 0)
	sle_oldpass.SetFocus ()
	RETURN
END IF

IF Len (s_newpass1) < 1 THEN
	g_nv_msg_mgr.fnv_process_msg ("pt", "New Pass Required", "", "", 0, 0)
	sle_newpass1.SetFocus ()
	RETURN
END IF

IF s_newpass1 <> s_newpass2 THEN
	g_nv_msg_mgr.fnv_process_msg ("pt", "New Pass Mismatch", "", "", 0, 0)
	sle_newpass1.SetFocus ()
	RETURN
END IF


// Update the password in the user table if it is in control of
// validating the password. If the DBMS is validating, then
// issue the appropriate procedure to change the password.

SetPointer (HourGlass!)

s_dbms = Upper (i_tr_sql.dbms)

IF Left (s_dbms, 6) = "TRACE " THEN		// remove trace option
	s_dbms = Trim (Mid (s_dbms, 6))
END IF

s_dbms = Left (s_dbms, 3)

CHOOSE CASE s_dbms

	CASE "SYB", "SYC", "MSS"

		DISCONNECT USING i_tr_sql;

		IF i_tr_sql.fnv_ini_connect (i_tr_sql.i_s_datasource, &
							s_userid, s_password) <> 0 THEN
			RETURN
		END IF

		s_command_sql = " EXECUTE sp_password ~"" + s_password + &
							"~", ~"" + s_newpass1 + "~""

		EXECUTE IMMEDIATE :s_command_sql
			USING i_tr_sql;

		IF i_tr_sql.sqlcode <> 0 THEN
			i_tr_sql.fnv_sql_error ("w_a_chg_password_pt", "ue_ok")
			RETURN
		END IF

		DISCONNECT USING i_tr_sql;

		g_str_user.s_password = s_newpass1

		IF i_tr_sql.fnv_ini_connect (i_tr_sql.i_s_datasource, &
								s_userid, s_newpass1) <> 0 THEN
			RETURN
		END IF

	CASE "ORA", "OR6", "OR7", "O71", "O72"

		s_command_sql = "ALTER USER " + s_userid + &
						" IDENTIFIED BY " + s_newpass1

		EXECUTE IMMEDIATE :s_command_sql 
		   USING i_tr_sql;

		IF i_tr_sql.sqlcode <> 0 THEN
			i_tr_sql.fnv_sql_error ("w_a_chg_password_pt", "ue_ok")
			b_pw_changed = FALSE
		END IF

		g_str_user.s_password = s_newpass1

	CASE ELSE

		dt_datetime = i_tr_sql.fnv_get_datetime ()

		  UPDATE pc_user_def
		     SET password = :s_newpass1,
		         maint_date = :dt_datetime
		   WHERE user_id = :s_userid
		   USING i_tr_sql;

		IF i_tr_sql.SQLCode = 0 THEN
			COMMIT USING i_tr_sql;
			g_str_user.s_password = s_newpass1
		ELSE
			i_tr_sql.fnv_sql_error ("w_a_chg_password_pt", "ue_ok")
			b_pw_changed = FALSE
		END IF

END CHOOSE

IF NOT b_pw_changed THEN
	RETURN
END IF


// Close this window if the password was successfully changed.

i_str_pass.s_action = "ok"

message.fnv_set_str_pass (i_str_pass)

Close (this)
end event

on open;call w_a::open;this.fw_center_window ()

this.title = "Change Password for " + g_str_user.s_userid

sle_oldpass.SetFocus ()
end on

on ue_cancel;call w_a::ue_cancel;// Pass 'cancel' action back to the caller.

i_str_pass.s_action = "cancel"

message.fnv_set_str_pass (i_str_pass)

Close (this)
end on

on w_a_chg_password_pt.create
int iCurrent
call w_a::create
this.sle_oldpass=create sle_oldpass
this.sle_newpass1=create sle_newpass1
this.sle_newpass2=create sle_newpass2
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=sle_oldpass
this.Control[iCurrent+2]=sle_newpass1
this.Control[iCurrent+3]=sle_newpass2
this.Control[iCurrent+4]=cb_ok
this.Control[iCurrent+5]=cb_cancel
this.Control[iCurrent+6]=st_1
this.Control[iCurrent+7]=st_2
this.Control[iCurrent+8]=st_3
end on

on w_a_chg_password_pt.destroy
call w_a::destroy
destroy(this.sle_oldpass)
destroy(this.sle_newpass1)
destroy(this.sle_newpass2)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
end on

type sle_oldpass from u_slea within w_a_chg_password_pt
int X=549
int Y=37
int Width=618
int Height=77
int TabOrder=30
boolean PassWord=true
int Limit=10
end type

on constructor;call u_slea::constructor;// Set autoselection on.

this.fu_set_autoselect (TRUE)
end on

type sle_newpass1 from u_slea within w_a_chg_password_pt
int X=549
int Y=133
int Width=618
int Height=77
int TabOrder=40
boolean PassWord=true
int Limit=10
end type

on constructor;call u_slea::constructor;// Set autoselection on.

this.fu_set_autoselect (TRUE)
end on

type sle_newpass2 from u_slea within w_a_chg_password_pt
int X=545
int Y=229
int Width=618
int Height=77
int TabOrder=50
boolean PassWord=true
int Limit=10
end type

on constructor;call u_slea::constructor;// Set autoselection on.

this.fu_set_autoselect (TRUE)
end on

type cb_ok from u_cb_ok within w_a_chg_password_pt
int X=449
int Y=357
int TabOrder=10
end type

type cb_cancel from u_cb_cancel within w_a_chg_password_pt
int X=833
int Y=357
int TabOrder=20
end type

type st_1 from statictext within w_a_chg_password_pt
int X=19
int Y=37
int Width=513
int Height=69
boolean Enabled=false
string Text="Ancien:"
Alignment Alignment=Right!
boolean FocusRectangle=false
long TextColor=33554432
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_2 from statictext within w_a_chg_password_pt
int X=19
int Y=133
int Width=513
int Height=69
boolean Enabled=false
string Text="Nouveau:"
Alignment Alignment=Right!
boolean FocusRectangle=false
long TextColor=33554432
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_3 from statictext within w_a_chg_password_pt
int X=19
int Y=229
int Width=513
int Height=69
boolean Enabled=false
string Text="Confirmation:"
Alignment Alignment=Right!
boolean FocusRectangle=false
long TextColor=33554432
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

