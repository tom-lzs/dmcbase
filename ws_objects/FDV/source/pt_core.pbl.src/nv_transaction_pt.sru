$PBExportHeader$nv_transaction_pt.sru
$PBExportComments$Objet transaction PowerTOOL
forward
global type nv_transaction_pt from transaction
end type
end forward

global type nv_transaction_pt from transaction
end type
global nv_transaction_pt nv_transaction_pt

type prototypes

end prototypes

type variables
Boolean i_b_connected	// Is transaction connected?

nv_trans_dbi  i_nv_dbi	// Database interface object

String i_s_datasource	// Description of data source (from .INI file)

String i_s_role		// Name of Oracle Role for connected user
String i_s_role_pw		// Password for Oracle Role for connected user
end variables

forward prototypes
public subroutine fnv_sql_error (string a_s_object, string a_s_script)
public function long fnv_get_next_key (string a_s_seq_ctrl_tbl, string a_s_seq_ctrl_id_col, string a_s_seq_ctrl_key_col, string a_s_seq_ctrl_id, long a_l_key_cnt)
public function integer fnv_connect ()
public function integer fnv_db_connect (string a_s_dbms, string a_s_app_name, string a_s_logid, string a_s_logpass, boolean a_b_autocommit)
public function long fnv_next_in_sequence (string a_s_table_name)
public function string fnv_get_dbms ()
public function string fnv_get_datasource_browse ()
public function integer fnv_ini_connect (string a_s_datasource, string a_s_userid, string a_s_password)
public function datetime fnv_get_datetime ()
public function boolean fnv_is_datasource_valid (string a_s_datasource)
public function nv_trans_dbi fnv_get_trans_dbi ()
public function string fnv_get_datasource_directed (string a_s_direction)
public function string fnv_get_datasource (string a_s_direction)
end prototypes

public subroutine fnv_sql_error (string a_s_object, string a_s_script);// Rollback passed transaction, if a database transaction exists, and
// call message manager to display and/or log message.

String s_sql_code, s_sql_err_text
Transaction tr_bogus


// Save transaction SQL Code and error text.

s_sql_code = String (this.SQLDBCode)

s_sql_err_text = this.SQLErrText


// Rollback transaction, if one exists.

IF NOT this.autocommit THEN
	tr_bogus = this
	ROLLBACK &
	   USING tr_bogus;
END IF


// Invoke message manager to display/log message.

g_nv_msg_mgr.fnv_process_msg ("pt", "SQL Error", &
														s_sql_code + ", " + &
														a_s_script + ", " + &
														a_s_object + ", " + &
														s_sql_err_text, "", 0, 0)
end subroutine

public function long fnv_get_next_key (string a_s_seq_ctrl_tbl, string a_s_seq_ctrl_id_col, string a_s_seq_ctrl_key_col, string a_s_seq_ctrl_id, long a_l_key_cnt);// Assign and return the next a_l_key_cnt key(s) for table (or column)
// a_s_seq_ctrl_id, as maintained in table a_s_seq_ctrl_tbl.

Boolean b_autocommit
String s_sql
Long l_seq_key
Transaction tr_bogus

 DECLARE seq_ctrl_cursor &
 DYNAMIC CURSOR FOR SQLSA;


// If transaction autocommit is TRUE, then set it to false for the
// duration of this transaction.

tr_bogus = this

b_autocommit = this.autocommit

IF b_autocommit THEN
	this.autocommit = FALSE
END IF


// Build and execute SQL to update the next sequential key - this
// will obtain an exclusive lock.

s_sql =  "  UPDATE " + a_s_seq_ctrl_tbl + " " + &
			"     SET " + a_s_seq_ctrl_key_col + " = " + &
								a_s_seq_ctrl_key_col + " + " + &
								String (a_l_key_cnt) + " " + &
			"   WHERE " + a_s_seq_ctrl_id_col + " = '" + &
								a_s_seq_ctrl_id + "' "

 EXECUTE IMMEDIATE :s_sql &
   USING tr_bogus;

IF this.SQLCode <> 0 THEN
	this.fnv_sql_error ("nv_transaction_pt", "fnv_get_next_key")
	IF b_autocommit THEN
		this.autocommit = TRUE
	END IF
	RETURN -1
END IF

IF this.SQLNRows < 1 THEN
	g_nv_msg_mgr.fnv_process_msg ("pt", "Sequence Not Found", &
													a_s_seq_ctrl_id, "", 0, 0)
	IF b_autocommit THEN
		this.autocommit = TRUE
	END IF
	RETURN -1
END IF

IF this.SQLNRows > 1 THEN
	g_nv_msg_mgr.fnv_process_msg ("pt", "Too Many Sequences", &
													a_s_seq_ctrl_id, "", 0, 0)
	IF b_autocommit THEN
		this.autocommit = TRUE
	END IF
	RETURN -1
END IF


// Build and execute SQL to retrieve the next sequential key

s_sql =  "  SELECT " + a_s_seq_ctrl_key_col + " " + &
			"    FROM " + a_s_seq_ctrl_tbl + " " + &
			"   WHERE " + a_s_seq_ctrl_id_col + " = '" + &
								a_s_seq_ctrl_id + "' "

 PREPARE SQLSA
    FROM :s_sql
   USING tr_bogus;

IF this.SQLCode <> 0 THEN
	this.fnv_sql_error ("nv_transaction_pt", "fnv_get_next_key")
	IF b_autocommit THEN
		this.autocommit = TRUE
	END IF
	RETURN -1
END IF

    OPEN DYNAMIC seq_ctrl_cursor;

IF this.SQLCode <> 0 THEN
	this.fnv_sql_error ("nv_transaction_pt", "fnv_get_next_key")
	IF b_autocommit THEN
		this.autocommit = TRUE
	END IF
	RETURN -1
END IF

   FETCH seq_ctrl_cursor
    INTO :l_seq_key;

IF this.SQLCode <> 0 THEN
	this.fnv_sql_error ("nv_transaction_pt", "fnv_get_next_key")
	IF b_autocommit THEN
		this.autocommit = TRUE
	END IF
	RETURN -1
END IF

   CLOSE seq_ctrl_cursor;

IF this.SQLCode <> 0 THEN
	this.fnv_sql_error ("nv_transaction_pt", "fnv_get_next_key")
	IF b_autocommit THEN
		this.autocommit = TRUE
	END IF
	RETURN -1
END IF


// Commit the transaction and return the first next sequential key.

  COMMIT &
   USING tr_bogus;

IF this.SQLCode <> 0 THEN
	this.fnv_sql_error ("nv_transaction_pt", "fnv_get_next_key")
	IF b_autocommit THEN
		this.autocommit = TRUE
	END IF
	RETURN -1
END IF

IF b_autocommit THEN
	this.autocommit = TRUE
END IF

RETURN l_seq_key + 1 - a_l_key_cnt
end function

public function integer fnv_connect ();// Connect to the database using the transaction as it is currently
// populated after first disconnecting.
// Returns
//  0	success
// -1	failure

String s_dbms
Integer i_rc
Transaction tr_bogus


// Disconnecting from the database first, to free up memory.

tr_bogus = this

DISCONNECT &
   USING tr_bogus;

this.i_b_connected = FALSE


// Make the connection.

 CONNECT &
   USING tr_bogus;

IF this.SQLCode <> 0 THEN
	g_nv_msg_mgr.fnv_process_msg ("pt", "Connect Error", &
											String (this.SQLDBCode) + ", " + &
											this.i_s_datasource + ", " + &
											this.SQLErrText, "", 0, 0)
	RETURN -1
END IF

this.i_b_connected = TRUE


// Instantiate the appropriate database interface protocol non-visual
// user object.

IF IsValid (i_nv_dbi) THEN
	DESTROY i_nv_dbi
END IF

s_dbms = Upper (this.fnv_get_dbms ())

IF Left (s_dbms, 6) = "TRACE " THEN		// remove trace request
	s_dbms = Trim (Mid (s_dbms, 6))
END IF

s_dbms = Left (s_dbms, 2)					// check first two chars

CHOOSE CASE s_dbms

	CASE "IN"

		i_nv_dbi = CREATE nv_trans_dbi_inf

	CASE "OR", "O7"

		i_nv_dbi = CREATE nv_trans_dbi_ora

	CASE "SY", "MS"

		i_nv_dbi = CREATE nv_trans_dbi_syb

	CASE "WA", "SQ"

		i_nv_dbi = CREATE nv_trans_dbi_wat

	CASE ELSE

		i_nv_dbi = CREATE nv_trans_dbi

END CHOOSE

i_nv_dbi.fnv_set_transaction (this)


// Call database interface protocol non-visual user object to set
// user role.

i_rc = i_nv_dbi.fnv_set_role ()

IF i_rc < 0 THEN
	tr_bogus = this
	DISCONNECT &
	   USING tr_bogus;
	this.i_b_connected = FALSE
	RETURN -1
END IF


// Success!

RETURN 0


end function

public function integer fnv_db_connect (string a_s_dbms, string a_s_app_name, string a_s_logid, string a_s_logpass, boolean a_b_autocommit);// Connect to the database after reading the old PowerTOOL style of
// .INI file - included for compatibility.
// Returns:
//	 1	success
//	-1	failure
//
//	Prototype
//		Integer fnv_db_connect (this, a_s_dbms, a_s_app_name, &
//									 a_s_logid, a_s_logpass, a_b_autocommit)
//
//		a_s_dbms			String	The database engine/type.
//		a_s_app_name	String	Application name.
//		a_s_logid		String	Database login (override .INI).
//		a_s_logpass		String	Database password (override .INI).
//		a_b_autocommit	Boolean	FALSE => PB build DBMS transaction.

String s_ini_file, s_dbms


// Attempt to open the win.ini file and retreive the application
// initialization file name, if one exists.

IF NOT g_nv_ini.fnv_check_and_open (a_s_app_name) THEN
	RETURN -1
END IF


// If we get here, we've found the INI file, and its name is in
// g_nv_ini.i_s_path.

s_ini_file = g_nv_ini.fnv_get_name ()


// If the DBMS is not specified on the command line (argument is
// empty string), retrieve the DBMS from the INI file under
// [DefaultDBMS].

IF Trim (a_s_dbms) = "" THEN
	a_s_dbms = g_nv_ini.fnv_profile_string ("DefaultDBMS", &
														"DBMS", &
														"NoDBMS")
END IF

this.i_s_datasource = "DefaultDBMS"

this.dbms = Upper (a_s_dbms)

this.autocommit = a_b_autocommit


// Based on the DBMS, read the remaining values for the transaction
// object out of the INI file.

s_dbms = Upper (Left (this.dbms, 2))	// check first three chars

CHOOSE CASE s_dbms

  CASE "IN" //informix
		this.dbms		= g_nv_ini.fnv_profile_string (a_s_dbms, &
																	"DBMS", &
																	this.dbms)
		this.servername= g_nv_ini.fnv_profile_string (a_s_dbms, &
																	"ServerName","")
		this.database	= g_nv_ini.fnv_profile_string (a_s_dbms, &
																	"Database","")
		IF Len (Trim (a_s_logid)) > 0 THEN
			this.logid	= a_s_logid
			this.logpass	= a_s_logpass
		ELSE
			this.logid	= g_nv_ini.fnv_profile_string (a_s_dbms, &
																	"LogID","")
			this.logpass	= g_nv_ini.fnv_profile_string (a_s_dbms, &
																	"LogPass","")
		END IF
		this.dbparm		= g_nv_ini.fnv_profile_string (a_s_dbms, &
																	"DBParm","")
	
  CASE "OD" //ODBC
		this.dbms		= g_nv_ini.fnv_profile_string (a_s_dbms, &
																	"DBMS", &
																	this.dbms)
		this.database	= g_nv_ini.fnv_profile_string (a_s_dbms, &
																	"Database", "")
		this.dbparm		= g_nv_ini.fnv_profile_string (a_s_dbms, &
																	"DBParm","")

  CASE "XD" //XDB
		this.dbms		= g_nv_ini.fnv_profile_string (a_s_dbms, &
																	"DBMS", &
																	this.dbms)
		this.database	= g_nv_ini.fnv_profile_string (a_s_dbms, &
																	"Database","")
		IF Len (Trim (a_s_logid)) > 0 THEN
			this.userid	= a_s_logid
			this.dbpass	= a_s_logpass
		ELSE
			this.userid	= g_nv_ini.fnv_profile_string (a_s_dbms, &
																	"LogID","")
			this.dbpass	= g_nv_ini.fnv_profile_string (a_s_dbms, &
																	"LogPass","")
		END IF
		this.logid		= g_nv_ini.fnv_profile_string (a_s_dbms, &
																	"LogID","")

  CASE "GU" //gupta
		this.dbms		= g_nv_ini.fnv_profile_string (a_s_dbms, &
																	"DBMS", &
																	this.dbms)
		this.database	= g_nv_ini.fnv_profile_string (a_s_dbms, &
																	"Database","")
		IF Len (Trim (a_s_logid)) > 0 THEN
			this.userid	= a_s_logid
			this.dbpass	= a_s_logpass
		ELSE
			this.userid	= g_nv_ini.fnv_profile_string (a_s_dbms, &
																	"LogID","")
			this.dbpass	= g_nv_ini.fnv_profile_string (a_s_dbms, &
																	"LogPass","")
		END IF
		this.lock		= g_nv_ini.fnv_profile_string (a_s_dbms, &
																	"Lock","")

  CASE "SY", "MS" //Sybase, MSS
		this.dbms		= g_nv_ini.fnv_profile_string (a_s_dbms, &
																	"DBMS", &
																	this.dbms)
		this.servername= g_nv_ini.fnv_profile_string (a_s_dbms, &
																	"ServerName","")
		this.database	= g_nv_ini.fnv_profile_string (a_s_dbms, &
																	"Database","")
		IF Len (Trim (a_s_logid)) > 0 THEN
			this.logid	= a_s_logid
			this.logpass	= a_s_logpass
		ELSE
			this.logid	= g_nv_ini.fnv_profile_string (a_s_dbms, &
																	"LogID","")
			this.logpass= g_nv_ini.fnv_profile_string (a_s_dbms, &
																	"LogPass","")
		END IF
		this.dbparm		= g_nv_ini.fnv_profile_string (a_s_dbms, &
																	"DBParm","")
		this.dbparm = "host='Erfvmr " +g_s_visiteur + " '"														

  CASE "OR", "O7" //Oracle
		this.dbms		= g_nv_ini.fnv_profile_string (a_s_dbms, &
																	"DBMS", &
																	this.dbms)
		this.servername= g_nv_ini.fnv_profile_string (a_s_dbms, &
																	"ServerName","")
		this.database	= g_nv_ini.fnv_profile_string (a_s_dbms, &
																	"Database","")
		IF Len (Trim (a_s_logid)) > 0 THEN
			this.logid	= a_s_logid
			this.logpass	= a_s_logpass
		ELSE
			this.logid	= g_nv_ini.fnv_profile_string (a_s_dbms, &
																	"LogID","")
			this.logpass= g_nv_ini.fnv_profile_string (a_s_dbms, &
																	"LogPass","")
		END IF
		this.dbparm		= g_nv_ini.fnv_profile_string (a_s_dbms, &
																	"DBParm","")

  CASE "NOD"
		g_nv_msg_mgr.fnv_process_msg ("pt", "No DBMS", &
												s_ini_file, &
												"", 0, 0)
		RETURN -1

  CASE ELSE
		g_nv_msg_mgr.fnv_process_msg ("pt", "Unknown DBMS", &
												this.dbms, &
												"", 0, 0)
		HALT CLOSE

END CHOOSE


// Transaction object is now set up.  Call fnv_connect to make the
// connection.

RETURN this.fnv_connect ()
end function

public function long fnv_next_in_sequence (string a_s_table_name);// Function to return the next sequential key from table pc_seqctl.

Long l_next_key


// Call transaction function to get the next key.

RETURN this.fnv_get_next_key ("pc_seqctl", "seq_id", &
								"current_skey", a_s_table_name, 1)
end function

public function string fnv_get_dbms ();
// Return the DBMS Vendor, and version if necessary, that this
// transaction is actually connected to.

string	s_dbms

// Bail out if this transaction isn't connected.

IF NOT i_b_connected THEN
	RETURN ""
END IF

// Examine transaction.dbms.  We can return the DBMS if it it's other
// than ODBC.  Otherwise, we need to dig into ODBC.INI.

s_dbms = Trim (this.dbms)

IF Upper (Left (s_dbms, 4)) <> "ODBC" THEN
	RETURN s_dbms
END IF

// if ODBC use SQLReturnData which has vendor-specific identifier
// ie. Watcom returns 'WATCOM SQL'

s_dbms = Trim (this.SQLReturnData)

//To distingush between Sybase and Sybase SQLAnywhere Lose the 
//sybase prefix of Sybase SQLAnywhere DBMS.

if upper( left(s_dbms, 10) ) = 'SYBASE SQL' THEN
	RETURN MID( s_dbms, 8, len(s_dbms))
ELSE
	RETURN s_dbms
END IF
end function

public function string fnv_get_datasource_browse ();// Open the datasource selection dialog to select .INI file data source.

str_pass str_pass


// Attempt to open the application .INI file and retrieve the list
// of available datasources from it.

IF NOT g_nv_ini.fnv_check_and_open (GetApplication ().appname) THEN
	g_nv_msg_mgr.fnv_process_msg ("pt", "No Datasources", "", "", 0, 0)
	RETURN ""
END IF

str_pass.s [1] = g_nv_ini.fnv_profile_string ("DBMS_PROFILES", &
																"PROFILES", "")

IF Len (str_pass.s [1]) < 1 THEN
	g_nv_msg_mgr.fnv_process_msg ("pt", "No Datasources", "", "", 0, 0)
	RETURN ""
END IF


// Open the datasource selection dialog and return the selected data
// source.

message.fnv_push ()

message.fnv_set_str_pass (str_pass)

Open (w_datasource_list)

str_pass = message.fnv_get_str_pass ()

message.fnv_pop ()

IF str_pass.s_action <> "ok" THEN
	RETURN ""
END IF

IF UpperBound (str_pass.s) < 1 THEN
	RETURN ""
END IF

RETURN str_pass.s [1]
end function

public function integer fnv_ini_connect (string a_s_datasource, string a_s_userid, string a_s_password);// Connect to the database after selecting a datasource from the
// .INI file.  A directed data source will be selected if parm
// a_s_datasource is set to '&<directive>' where <directive> is
// an entry under [DBMS_PROFILES] that points to a valid datasource.
// Returns:
//	 0	success
//	-1	failure


// Select a directed data source if the first character of
// a_s_datasource is '&.'

a_s_datasource = Trim (a_s_datasource)

IF Len (a_s_datasource) > 0 THEN
	IF Left (a_s_datasource, 1) = "&" THEN
		a_s_datasource = this.fnv_get_datasource (Mid (a_s_datasource, 2))
	ELSE
		IF NOT this.fnv_is_datasource_valid (a_s_datasource) THEN
			a_s_datasource = this.fnv_get_datasource ("")
		END IF
	END IF
ELSE
	a_s_datasource = this.fnv_get_datasource ("")
END IF

IF Len (a_s_datasource) < 1 THEN
	RETURN -1
END IF


// Populate the transaction with .INI file settings for data source.

this.i_s_datasource = a_s_datasource

this.dbms = g_nv_ini.fnv_profile_string ("Profile " + a_s_datasource, &
															"DBMS", &
															"")

this.servername = g_nv_ini.fnv_profile_string ("Profile " + a_s_datasource, &
															"ServerName", &
															"")

this.database = g_nv_ini.fnv_profile_string ("Profile " + a_s_datasource, &
															"DataBase", &
															"")

this.logid = g_nv_ini.fnv_profile_string ("Profile " + a_s_datasource, &
															"LogID", &
															"")

this.logpass = g_nv_ini.fnv_profile_string ("Profile " + a_s_datasource, &
															"LogPassword", &
															"")

this.userid = g_nv_ini.fnv_profile_string ("Profile " + a_s_datasource, &
															"UserID", &
															"")

this.dbpass = g_nv_ini.fnv_profile_string ("Profile " + a_s_datasource, &
															"DatabasePassword", &
															"")

this.lock = g_nv_ini.fnv_profile_string ("Profile " + a_s_datasource, &
															"Lock", &
															"")

IF g_nv_ini.fnv_profile_int ("Profile " + a_s_datasource, "AutoCommit", &
																	1) > 0 THEN
	this.autocommit = TRUE
ELSE
	this.autocommit = FALSE
END IF

this.dbparm = g_nv_ini.fnv_profile_string ("Profile " + a_s_datasource, &
															"dbParm", &
															"")

this.i_s_role = g_nv_ini.fnv_profile_string ("Profile " + a_s_datasource, &
															"Role", &
															"")

this.i_s_role_pw = g_nv_ini.fnv_profile_string ("Profile " + a_s_datasource, &
															"RolePassword", &
															this.i_s_role)

// Replace &userid in logid and/or userid and &password in logpass
// and/or dbpass with parameters passed.

IF Lower (Trim (this.logid)) = "&userid" THEN
	this.logid = a_s_userid
END IF

IF Lower (Trim (this.userid)) = "&userid" THEN
	this.userid = a_s_userid
END IF

IF Lower (Trim (this.logpass)) = "&password" THEN
	this.logpass = a_s_password
END IF

IF Lower (Trim (this.dbpass)) = "&password" THEN
	this.dbpass = a_s_password
END IF


// Transaction object is now set up.  Call fnv_connect to make the
// connection.

RETURN this.fnv_connect ()
end function

public function datetime fnv_get_datetime ();// Return the date/time provided by the DBMS server to which the
// transaction is connected.  The default is local date/time.

IF NOT i_b_connected THEN
	RETURN DateTime (Today (), Now ())
END IF

RETURN this.i_nv_dbi.fnv_get_datetime ()
end function

public function boolean fnv_is_datasource_valid (string a_s_datasource);// Determine whether the data source name passed is in the data source list.

String s_datasource_list, s_datasource
Integer i_pos


// Validate the passed data source name.

a_s_datasource = Lower (Trim (a_s_datasource))

IF NOT Len (a_s_datasource) > 0 THEN
	RETURN FALSE
END IF


// Get list of data sources from application INI file.

IF NOT g_nv_ini.fnv_check_and_open (GetApplication ().appname) THEN
	RETURN FALSE
END IF

s_datasource_list = g_nv_ini.fnv_profile_string ("DBMS_PROFILES", &
																"PROFILES", "")

IF Len (s_datasource_list) < 1 THEN
	RETURN FALSE
END IF

s_datasource_list = "'" + Trim (s_datasource_list) + "'"


// Loop through each data source, one at a time, from the datasource list,
// and determine whether it matches the data source name passed.

i_pos = Pos (s_datasource_list, "'")

DO WHILE i_pos > 0
	s_datasource_list = Mid (s_datasource_list, i_pos + 1)
	i_pos = Pos (s_datasource_list, "'")
	IF i_pos < 1 THEN
		EXIT
	END IF
	s_datasource = Lower (Trim (Left (s_datasource_list, i_pos - 1)))
	IF s_datasource = a_s_datasource THEN
		RETURN TRUE
	END IF
	s_datasource_list = Mid (s_datasource_list, i_pos + 1)
	i_pos = Pos (s_datasource_list, "'")
LOOP


// Fell out of loop -- datasource not found.

RETURN FALSE
end function

public function nv_trans_dbi fnv_get_trans_dbi ();// Return the current transaction database interface protocol object.

RETURN i_nv_dbi
end function

public function string fnv_get_datasource_directed (string a_s_direction);// Open the application .INI file to retrieve the data source
// identified as a_s_direction.

IF NOT g_nv_ini.fnv_check_and_open (GetApplication ().appname) THEN
	RETURN ""
END IF

RETURN g_nv_ini.fnv_profile_string ("DBMS_PROFILES", a_s_direction, "")
end function

public function string fnv_get_datasource (string a_s_direction);// Get a data source, form the applcation's .INI file, for transaction
// connection.  IF a_s_direction is specified then the function will
// attempt to get the directed datasource.

String s_datasource


// Attempt to get the directed data source, if a_s_direction is set.

a_s_direction = Trim (a_s_direction)

IF Len (a_s_direction) > 0 THEN
	s_datasource = this.fnv_get_datasource_directed (a_s_direction)
	IF Len (s_datasource) > 0 THEN
		RETURN s_datasource
	END IF
END IF


// Call the selection dialog to get a data source.

RETURN fnv_get_datasource_browse ()
end function

on destructor;// Destroy the database interface object.

IF IsValid ( i_nv_dbi ) THEN

	DESTROY i_nv_dbi

END IF
end on

on nv_transaction_pt.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nv_transaction_pt.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;// Create the default database interface object.

i_nv_dbi = CREATE nv_trans_dbi

i_nv_dbi.fnv_set_transaction (this)
end event

