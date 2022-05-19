$PBExportHeader$w_compte_rendu.srw
$PBExportComments$Permet l'affichage de la liste des niveaux de responsabilité
forward
global type w_compte_rendu from w_a_liste
end type
type pb_impression from u_pba within w_compte_rendu
end type
end forward

global type w_compte_rendu from w_a_liste
string tag = "COMPTE_RENDU"
integer x = 769
integer y = 461
integer width = 2629
integer height = 2064
string title = "Compte rendu dernier transfert"
boolean vscrollbar = true
pb_impression pb_impression
end type
global w_compte_rendu w_compte_rendu

on w_compte_rendu.create
int iCurrent
call super::create
this.pb_impression=create pb_impression
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_impression
end on

on w_compte_rendu.destroy
call super::destroy
destroy(this.pb_impression)
end on

event open;call super::open;
/* appel de la fonction qui permet de ne pas traduire les libellés */

fu_ne_pas_traduire()

end event

event ue_ok;call super::ue_ok;Close (This)
end event

event ue_init;transaction  l_tr_sql

l_tr_sql = i_str_pass.po[1]

dw_1.SetTransObject (l_tr_sql)
dw_1.retrieve(g_s_visiteur)
end event

event ue_print;call super::ue_print;dw_1.print( )
end event

type uo_statusbar from w_a_liste`uo_statusbar within w_compte_rendu
integer x = 512
integer y = 116
end type

type cb_cancel from w_a_liste`cb_cancel within w_compte_rendu
integer y = 576
end type

type cb_ok from w_a_liste`cb_ok within w_compte_rendu
end type

type dw_1 from w_a_liste`dw_1 within w_compte_rendu
string tag = "A_TRADUIRE"
integer width = 2345
integer height = 1520
string dataobject = "d_compte_rendu_transfret"
richtexttoolbaractivation richtexttoolbaractivation = richtexttoolbaractivationalways!
end type

type pb_ok from w_a_liste`pb_ok within w_compte_rendu
integer x = 146
integer y = 1676
string picturename = "C:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_echap from w_a_liste`pb_echap within w_compte_rendu
boolean visible = false
integer x = 1088
integer y = 892
end type

type pb_impression from u_pba within w_compte_rendu
integer x = 832
integer y = 1676
integer width = 366
integer height = 168
integer taborder = 20
boolean bringtotop = true
string facename = "Arial"
string text = "&Impression"
string picturename = "C:\appscir\Erfvmr_diva\Image\PB_IMP.BMP"
end type

on constructor;call u_pba::constructor;
// ------------------------------------------------------
// DECLENCHEMENT DE L'EVENEMENT AU NIVEAU DE LA FENÊTRE
// ------------------------------------------------------
	fu_setevent ("ue_print")

// ------------------------------------------------------
// TEXTE DE LA MICROHELP
// ------------------------------------------------------
	fu_set_microhelp ("Impression du bon de commande")
end on

