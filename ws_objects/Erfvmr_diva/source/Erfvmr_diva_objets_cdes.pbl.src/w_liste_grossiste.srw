$PBExportHeader$w_liste_grossiste.srw
$PBExportComments$Affichage de la liste des grossistes pour sélection
forward
global type w_liste_grossiste from w_a_liste
end type
end forward

global type w_liste_grossiste from w_a_liste
string tag = "LISTE_GROSSISTE"
integer width = 1902
integer height = 1124
string title = "*Liste des grossistes*"
boolean controlmenu = false
end type
global w_liste_grossiste w_liste_grossiste

event ue_ok;/* <DESC>
      Fermeture de la fenêtre en passant le code du grossiste ainsi que le nom abrégé et
		la ville
   </DESC> */
// Déclaration des variables locales
	Long		l_row

i_str_pass.s_action = ACTION_OK

if dw_1.RowCount() = 0 then
	i_str_pass.s[1] = BLANK
	i_str_pass.s[2] = BLANK
	i_str_pass.s[3] = BLANK
else
	l_row = dw_1.GetRow()
	i_str_pass.s[1] = dw_1.GetItemString (l_row, DBNAME_CLIENT_CODE)
	i_str_pass.s[2] = dw_1.GetItemString (l_row, DBNAME_CLIENT_ABREGE_NOM)
	i_str_pass.s[3] = dw_1.GetItemString (l_row, DBNAME_CLIENT_ABREGE_VILLE)
end if

Message.fnv_set_str_pass(i_str_pass)
Close (This)
end event

event ue_init;/* <DESC>
      Affichage de la liste des grossistes
   </DESC> */
if dw_1.Retrieve(g_nv_come9par.get_code_langue()) = -1 then
 	f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
end if


end event

on w_liste_grossiste.create
call super::create
end on

on w_liste_grossiste.destroy
call super::destroy
end on

type uo_statusbar from w_a_liste`uo_statusbar within w_liste_grossiste
end type

type cb_cancel from w_a_liste`cb_cancel within w_liste_grossiste
integer taborder = 30
end type

type cb_ok from w_a_liste`cb_ok within w_liste_grossiste
integer taborder = 20
end type

type dw_1 from w_a_liste`dw_1 within w_liste_grossiste
string tag = "A_TRADUIRE"
integer y = 104
integer width = 1755
integer height = 664
integer taborder = 10
string dataobject = "d_liste_grossiste"
end type

type pb_ok from w_a_liste`pb_ok within w_liste_grossiste
integer x = 133
integer y = 820
integer taborder = 0
string picturename = "c:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_echap from w_a_liste`pb_echap within w_liste_grossiste
integer x = 1157
integer y = 828
integer taborder = 0
string picturename = "c:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

