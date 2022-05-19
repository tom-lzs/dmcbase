$PBExportHeader$nv_trans_dbi_inf_pt.sru
$PBExportComments$Ancêtre des objets d'interface de transaction de base de données pour Informix
forward
global type nv_trans_dbi_inf_pt from nv_trans_dbi
end type
end forward

global type nv_trans_dbi_inf_pt from nv_trans_dbi
end type
global nv_trans_dbi_inf_pt nv_trans_dbi_inf_pt

forward prototypes
public function datetime fnv_get_datetime ()
public function string fnv_get_item (u_dwa a_dw, long a_l_row_num, string a_s_col_name, string a_s_col_type)
end prototypes

public function datetime fnv_get_datetime ();// Return the datetime supplied by Watcom.

DateTime dt_server


// Bail out if transaction isn't set.

IF NOT IsValid (i_tr_parent) THEN
	RETURN dt_server
END IF


// Retrieve current date/time from Informix.

  SELECT EXTEND (CURRENT)
    INTO :dt_server  
    FROM sysusers
   USING i_tr_parent;

RETURN dt_server
end function

public function string fnv_get_item (u_dwa a_dw, long a_l_row_num, string a_s_col_name, string a_s_col_type);// Return the DataWindow item as a string in the proper form to be
// pass as part of a SQL statement to a server, based on data type.

String s_coltype, s_coltype4, s_return, s_item
Date dte_item
Decimal dec_item
Double d_item
DateTime dt_item
Time tme_item


// Bail out if the datawindow isn't valid.

IF NOT IsValid (a_dw) THEN
	RETURN ""
END IF


// Convert column number to column name.

IF IsNumber (a_s_col_name) THEN
	a_s_col_name = a_dw.Describe ("#" + a_s_col_name + ".Name")
END IF


// Get the data item from the passed datawindow.

s_coltype = Upper (a_dw.Describe ( a_s_col_name + ".ColType" ))

s_coltype4 = Left (s_coltype, 4)

CHOOSE CASE s_coltype4

	CASE "CHAR"
		s_item = a_dw.GetItemString (a_l_row_num, a_s_col_name)
		IF IsNull (s_item) THEN
			s_return = "null"
		ELSE
			s_return = Trim (s_item)
		END IF

	CASE "NUMB", "LONG", "ULON", "REAL"
		d_item = a_dw.GetItemNumber (a_l_row_num, a_s_col_name)
		IF IsNull (d_item) THEN
			s_return = "null"
		ELSE
			s_return = String (d_item)
		END IF

	CASE "DECI"
		dec_item = a_dw.GetItemDecimal (a_l_row_num, a_s_col_name)
		IF IsNull (dec_item) THEN
			s_return = "null"
		ELSE
			s_return = String (dec_item)
		END IF
			
	CASE "DATE"
		IF s_coltype = "DATETIME" THEN
			dt_item = a_dw.GetItemDateTime (a_l_row_num, a_s_col_name)
			IF IsNull (dt_item) THEN
				s_return = "null"
			ELSE
				s_return = String (dt_item, "dd/mm/yyyy hh:mm:ss.fff")
			END IF
		ELSE
			dte_item = a_dw.GetItemDate (a_l_row_num, a_s_col_name)
			IF IsNull (dte_item) THEN
				s_return = "null"
			ELSE
				s_return = String (dte_item, "dd/mm/yyyy")
			END IF
		END IF

	CASE "TIME"
		IF s_coltype = "TIME" THEN
			tme_item = a_dw.GetItemTime (a_l_row_num, a_s_col_name)
			IF IsNull (tme_item) THEN
				s_return = "null"
			ELSE
				s_return = String (tme_item, "hh:mm:ss.fff")
			END IF
		ELSE
			RETURN ""
		END IF

	CASE ELSE
		RETURN ""

END CHOOSE


// Return the null, if that's what was retrieved.

IF s_return = "null" THEN
	RETURN s_return
END IF


// Perform Date and Time conversions, as necessary.

s_coltype = Upper (a_s_col_type)

CHOOSE CASE s_coltype

	CASE "STRING"	// double up single quotes
		s_return = f_str_transform (s_return, "'", "''")
		s_return = "'" + s_return + "'"

	CASE "NUMBER"
		IF NOT IsNumber (s_return) THEN
			s_return = ""
		END IF

	CASE "DATE"
		IF NOT IsDate (s_return) THEN
			RETURN ""
		END IF
		s_return = "DATE( '" + s_return + "' )"

	CASE "DATETIME"
		IF NOT f_isdatetime (s_return) THEN
			RETURN ""
		END IF
		s_return = "DATETIME( '" + s_return + "' )"

	CASE "TIME"
		IF NOT IsTime (s_return) THEN
			RETURN ""
		END IF
		s_return = "DATETIME( '" + s_return + "' )"

END CHOOSE


RETURN s_return

end function

on nv_trans_dbi_inf_pt.create
TriggerEvent( this, "constructor" )
end on

on nv_trans_dbi_inf_pt.destroy
TriggerEvent( this, "destructor" )
end on

