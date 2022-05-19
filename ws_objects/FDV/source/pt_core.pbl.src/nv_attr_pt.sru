$PBExportHeader$nv_attr_pt.sru
$PBExportComments$Ancêtre des Attributs d'Objets
forward
global type nv_attr_pt from nonvisualobject
end type
end forward

global type nv_attr_pt from nonvisualobject
end type
global nv_attr_pt nv_attr_pt

type variables
PROTECTED:

any i_any_key[]	// Item key(s)
any i_any_data[]	// Item data item(s)
any i_any_sortkey[]	// Item sort key(s)
end variables

forward prototypes
public subroutine fnv_set_key (any a_any_key[])
public subroutine fnv_set_sortkey (any a_any_sortkey[])
public subroutine fnv_set_data (any a_any_data[])
public subroutine fnv_get_data (ref any a_any_data[])
public subroutine fnv_get_key (ref any a_any_key[])
public subroutine fnv_get_sortkey (ref any a_any_sortkey[])
end prototypes

public subroutine fnv_set_key (any a_any_key[]);// Save the passed key(s) to the instance variable.

i_any_key = a_any_key
end subroutine

public subroutine fnv_set_sortkey (any a_any_sortkey[]);// Save the passed sort key(s) to the instance variable.

i_any_sortkey = a_any_sortkey
end subroutine

public subroutine fnv_set_data (any a_any_data[]);// Save the passed data item(s) to the instance variable.

i_any_data = a_any_data
end subroutine

public subroutine fnv_get_data (ref any a_any_data[]);// Return the data item(s) from the instance variable.

a_any_data = i_any_data
end subroutine

public subroutine fnv_get_key (ref any a_any_key[]);// Return the key(s) from the instance variable.

a_any_key = i_any_key
end subroutine

public subroutine fnv_get_sortkey (ref any a_any_sortkey[]);// Return the sort key(s) from the instance variable.

a_any_sortkey = i_any_sortkey
end subroutine

on nv_attr_pt.create
TriggerEvent( this, "constructor" )
end on

on nv_attr_pt.destroy
TriggerEvent( this, "destructor" )
end on

