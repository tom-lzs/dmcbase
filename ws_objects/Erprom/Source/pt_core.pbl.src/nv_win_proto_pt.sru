$PBExportHeader$nv_win_proto_pt.sru
$PBExportComments$Objet protocole des fenêtres SDI [DEFAULT]
forward
global type nv_win_proto_pt from nonvisualobject
end type
end forward

global type nv_win_proto_pt from nonvisualobject
end type
global nv_win_proto_pt nv_win_proto_pt

type variables
PROTECTED:

Boolean i_b_init	// Is this object intialized?
w_a i_w_win	// Parent Window of this NVO
end variables

forward prototypes
public function boolean fnv_opening (w_a a_window, ref str_pass a_str_pass)
public function boolean fnv_closing ()
public function boolean fnv_initializing ()
public function int fnv_get_win_idx ()
public function int fnv_set_win_idx (int a_i_dummy)
end prototypes

public function boolean fnv_opening (w_a a_window, ref str_pass a_str_pass);// Verify passed Window is valid.

IF NOT IsValid (a_window) THEN
	i_b_init = FALSE
	RETURN FALSE
END IF


// Save parent Window.

i_w_win = a_window

i_b_init = TRUE

RETURN TRUE
end function

public function boolean fnv_closing ();// Function stub.

IF NOT i_b_init THEN
	RETURN FALSE
END IF

RETURN TRUE
end function

public function boolean fnv_initializing ();// Function stub

RETURN TRUE
end function

public function int fnv_get_win_idx ();// Function stub
// This function should not be called for this type of object.
// However, since all windows inherit an instance variable of
// this type, the function must be declared so other scripts 
// will compile

RETURN -1
end function

public function int fnv_set_win_idx (int a_i_dummy);// Function stub
// This function should not be called for this type of object.
// However, since all windows inherit an instance variable of
// this type, the function must be declared so other scripts 
// will compile

RETURN -1
end function

on nv_win_proto_pt.create
TriggerEvent( this, "constructor" )
end on

on nv_win_proto_pt.destroy
TriggerEvent( this, "destructor" )
end on

