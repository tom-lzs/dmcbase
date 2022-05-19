$PBExportHeader$nv_error_pt.sru
$PBExportComments$Objet erreur PowerTOOL
forward
global type nv_error_pt from error
end type
end forward

global type nv_error_pt from error
end type
global nv_error_pt nv_error_pt

forward prototypes
public subroutine fnv_process_error ()
end prototypes

public subroutine fnv_process_error ();// Call the PowerTOOL message manager, if it's loaded, to process the
// error described.

String s_msg_id


// PowerBuilder errors range from 1 through 51.  If no error number
// is specified, default to 100.

IF this.number > 0 THEN
	IF this.number > 51 THEN
		s_msg_id = "Application Error"
	ELSE
		s_msg_id = "System Error"
	END IF
ELSE
	this.number = 100
	s_msg_id = "Application Error"
END IF


// Utilize the PowerTOOL message manager if it exists.

IF IsValid (g_nv_msg_mgr) THEN
	g_nv_msg_mgr.fnv_process_msg ("pt", s_msg_id, &
											String (this.number) + ", " + &
											String (this.line) + ", " + &
											this.objectevent + ", " + &
											this.object + ", " + &
											this.windowmenu + ", " + &
											g_nv_msg_mgr.fnv_translate (this.text), &
											"", 0, 0)
	RETURN
END IF


// Display a message box and halt the application unless otherwise
// instructed.
// Decode system error and display error dialog.

IF MessageBox ("Internal " + s_msg_id + ": " + &
									GetApplication ().appname, &
					"Error Number~t" + String (this.number) + "~r~n" + &
					"at line number~t" + String (this.line) + "~r~n" + &
					"of Event~t~t" + this.objectevent + "~r~n" + &
					"in Object~t~t" + this.object + "~r~n" + &
					"in Window~t" + this.windowmenu + "~r~n~r~n" + &
					this.text + "~r~n~r~nAbort Application?", &
					StopSign!, YesNo!) = 1 THEN
	HALT CLOSE
END IF
end subroutine

on nv_error_pt.create
TriggerEvent( this, "constructor" )
end on

on nv_error_pt.destroy
TriggerEvent( this, "destructor" )
end on

