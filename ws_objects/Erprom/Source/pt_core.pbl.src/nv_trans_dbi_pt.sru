$PBExportHeader$nv_trans_dbi_pt.sru
$PBExportComments$Ancêtre des objets d'interface de transaction de base de données
forward
global type nv_trans_dbi_pt from nonvisualobject
end type
end forward

global type nv_trans_dbi_pt from nonvisualobject
end type
global nv_trans_dbi_pt nv_trans_dbi_pt

type variables
PROTECTED:

nv_transaction i_tr_parent	// Parent transaction
end variables

forward prototypes
public function datetime fnv_get_datetime ()
public function string fnv_get_item (u_dwa a_dw, long a_l_row, string a_s_column, string a_s_return_data_type)
public function integer fnv_set_role ()
public function nv_transaction fnv_get_parent ()
public subroutine fnv_set_transaction (nv_transaction a_tr_parent)
end prototypes

public function datetime fnv_get_datetime ();// Function stub - return the local date/time value.

RETURN DateTime (Today (), Now ())
end function

public function string fnv_get_item (u_dwa a_dw, long a_l_row, string a_s_column, string a_s_return_data_type);// Stub Function.

RETURN ""
end function

public function integer fnv_set_role ();// Function stub.
// This will be specialized by the Oracle non-visual user object.

RETURN 0
end function

public function nv_transaction fnv_get_parent ();// Return current value of instance variable.

RETURN i_tr_parent
end function

public subroutine fnv_set_transaction (nv_transaction a_tr_parent);// Set value of instance variable.

i_tr_parent = a_tr_parent
end subroutine

on nv_trans_dbi_pt.create
TriggerEvent( this, "constructor" )
end on

on nv_trans_dbi_pt.destroy
TriggerEvent( this, "destructor" )
end on

