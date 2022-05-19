$PBExportHeader$u_sle_num_pt.sru
$PBExportComments$SingleLineEdit qui n'autorise que les caractères numériques
forward
global type u_sle_num_pt from u_slea
end type
end forward

global type u_sle_num_pt from u_slea
int TextSize=-10
end type
global u_sle_num_pt u_sle_num_pt

type variables

end variables

on we_char;call u_slea::we_char;// Reject any characters other than '0' thru '9'.

IF KeyDown (keyNumpad0!) OR &
	KeyDown (keyNumpad1!) OR &
	KeyDown (keyNumpad2!) OR &
	KeyDown (keyNumpad3!) OR &
	KeyDown (keyNumpad4!) OR &
	KeyDown (keyNumpad5!) OR &
	KeyDown (keyNumpad6!) OR &
	KeyDown (keyNumpad7!) OR &
	KeyDown (keyNumpad8!) OR &
	KeyDown (keyNumpad9!) THEN			// Check for Numpad 0-9
	RETURN
ELSE
	IF KeyDown (key0!) OR &
		KeyDown (key1!) OR &
		KeyDown (key2!) OR &
		KeyDown (key3!) OR &
		KeyDown (key4!) OR &
		KeyDown (key5!) OR &
		KeyDown (key6!) OR &
		KeyDown (key7!) OR &
		KeyDown (key8!) OR &
		KeyDown (key9!) THEN				// Check for 0-9 key WITHOUT shift
		IF NOT KeyDown (keyShift!) THEN
			RETURN
		END IF
	ELSE
		IF KeyDown (keyBack!) OR &
			KeyDown (keyTab!) OR &
			KeyDown (keyEnter!) OR &
			KeyDown (keyAlt!) OR &
			KeyDown (keyPause!) OR &
			KeyDown (keyEscape!) OR &
			KeyDown (keyEnd!) OR &
			KeyDown (keyHome!) OR &
			KeyDown (keyLeftArrow!) OR &
			KeyDown (keyRightArrow!) OR &
			KeyDown (keyPrintScreen!) OR &
			KeyDown (keyInsert!) OR &
			KeyDown (keyDelete!) OR &
			KeyDown (keyF1!) OR &
			KeyDown (keyF2!) OR &
			KeyDown (keyF3!) OR &
			KeyDown (keyF4!) OR &
			KeyDown (keyF5!) OR &
			KeyDown (keyF6!) OR &
			KeyDown (keyF7!) OR &
			KeyDown (keyF8!) OR &
			KeyDown (keyF9!) OR &
			KeyDown (keyF10!) OR &
			KeyDown (keyF11!) OR &
			KeyDown (keyF12!) OR &
			KeyDown (keyNumLock!) OR &
			KeyDown (keyScrollLock!) THEN		// Check for valid special keys
			RETURN
		END IF
	END IF
END IF


// Fallthrough - invalid key encountered.

Beep(1)

message.processed = TRUE
end on

