$PBExportHeader$u_slea_key.sru
$PBExportComments$Ancêtre - Sle utilisable avec les touches de fonctions
forward
global type u_slea_key from u_slea
end type
end forward

global type u_slea_key from u_slea
end type
global u_slea_key u_slea_key

event we_keydown;call super::we_keydown;
// POUR LES TOUCHES DE F1 A F12 RENVOIE A L'EVENEMENT KEY DE LA FENÊTRE
//	f_activation_key() 
	f_key(Parent)

// TOUCHE ENTER SIMULE LA TOUCHE TAB POUR PASSER A LA ZONE SUIVANTE
	IF KeyDown (KeyEnter!) THEN
		Send(Handle(This),256,9,Long(0,0))
	END IF
end event

event getfocus;call super::getfocus;
//Mise à jour de la micro help
	g_w_frame.SetMicroHelp (GetFocus().Tag)
end event

