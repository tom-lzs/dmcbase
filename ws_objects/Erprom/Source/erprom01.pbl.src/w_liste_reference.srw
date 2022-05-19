$PBExportHeader$w_liste_reference.srw
forward
global type w_liste_reference from w_a_pick_list_det
end type
type cb_cancel from u_cb_cancel within w_liste_reference
end type
type cb_ok from u_cb_ok within w_liste_reference
end type
type cb_1 from u_cba within w_liste_reference
end type
end forward

global type w_liste_reference from w_a_pick_list_det
integer width = 2743
integer height = 1604
string title = "Liste des références"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
long backcolor = 12632256
event ue_chge_ref ( )
cb_cancel cb_cancel
cb_ok cb_ok
cb_1 cb_1
end type
global w_liste_reference w_liste_reference

type variables
String is_sql_origine_article
String is_sql_origine_dimension
end variables

forward prototypes
public subroutine fw_retrieve_article ()
end prototypes

event ue_chge_ref();//
// DECLARATION DES VARIABLE LOCALES
Long			l_retrieve
Str_pass		str_work

// SELECTION DES CRITERES
OpenWithParm (w_selection_reference, str_work)
str_work = Message.fnv_get_str_pass()
Message.fnv_clear_str_pass()
//
//
//// TRAITEMENT SELON L'ACTION CHOISIE
if str_work.s_action = ACTION_CANCEL then
	IF dw_pick.GetRow() = 0 THEN
			This.TriggerEvent ("ue_cancel")
	ELSE
			dw_pick.SetFocus()
	END IF
	return
end if

i_str_pass.s[1] = str_work.s[1]
i_str_pass.s[2] = str_work.s[2]
i_str_pass.s[3] = str_work.s[3]
fw_retrieve_article()

end event

public subroutine fw_retrieve_article ();String ls_sql
Boolean lb_modif_sql = false

ls_sql = is_sql_origine_article

if trim(i_str_pass.s[1]) <>  DONNEE_VIDE then
	ls_sql = ls_sql + " AND " + DBNAME_ARTICLE + " like'" + i_str_pass.s[1] + "%' "
	lb_modif_sql = true
end if

if trim(i_str_pass.s[2]) <>  DONNEE_VIDE then
	ls_sql = ls_sql + " AND " + DBNAME_DESCRIPTION_REF + " like '" + i_str_pass.s[2] + "%' "
	lb_modif_sql = true	
end if

if	lb_modif_sql then
	dw_pick.SetSqlSelect(ls_sql)
	dw_pick.setTransObject(sqlca)
end if

if dw_pick.retrieve() = -1 then
		f_dmc_error (this.title + BLANK + "Erreur acces liste article")
end if

if dw_pick.RowCount() = 0 then
	This.TriggerEvent ("ue_chge_ref")
	return
end if

dw_pick.SetFocus ()

end subroutine

event ue_cancel;	i_str_pass.s_action = ACTION_CANCEL
	Message.fnv_set_str_pass(i_str_pass)
	Close (This)
end event

event ue_init;call super::ue_init;
is_sql_origine_article 		= dw_pick.getSqlSelect()
is_sql_origine_dimension 	= dw_1.getSqlSelect()

// INITIALISATION DES DATAWINDOW
dw_1.fu_set_selection_mode (1)

// RECEPTION DES PARAMETRES
IF UpperBound(i_str_pass.s) = 0 THEN
	This.TriggerEvent ("ue_chge_ref")
	return
end if

fw_retrieve_article()


end event

on w_liste_reference.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.cb_1
end on

on w_liste_reference.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.cb_1)
end on

event ue_ok;// Override Ancestor Script
// DECLARATION DES VARIABLES LOCALES
Long		l_row

// REPRISE DU CODE ARTICLE SELECTIONNE
l_row = dw_1.GetRow ()

IF l_row = 0 THEN
	messagebox (This.title,"Sélectionner une référence", Information!,Ok!,1)
	RETURN
end if

i_str_pass.s[1] = dw_pick.GetItemString (dw_pick.GetRow(), DBNAME_ARTICLE)
i_str_pass.s[2] = dw_1.GetItemString (dw_1.GetRow(), DBNAME_DIMENSION)

i_str_pass.s_action = ACTION_OK
Message.fnv_set_str_pass(i_str_pass)
Close (This)

end event

event ue_retrieve;call super::ue_retrieve;
// DECLARATION DES VARIABLES LOCALES
Long		l_retrieve
Long		l_row
String 	ls_sql

// RECHERCHE DE L'ARTICLE SELECTIONNE
//	dw_1.SetRedraw (FALSE)

l_row = dw_pick.GetRow ()
IF l_row = 0 THEN
	RETURN
end if

dw_1.Reset ()
ls_sql = is_sql_origine_dimension
ls_sql = ls_sql  + " AND " + DBNAME_ARTICLE+ " ='" + dw_pick.GetItemString (l_row, DBNAME_ARTICLE) + "' "

// RETRIEVE DE LA DTW
if trim(i_str_pass.s[2]) <>  DONNEE_VIDE then
	ls_sql = ls_sql + " AND " + DBNAME_DIMENSION + " ='" + i_str_pass.s[2] + "' "
end if

dw_1.setSqlSelect(ls_sql)
dw_1.setTransObject(sqlca)

if dw_1.Retrieve ( ) = -1 then
	f_dmc_error (this.title + BLANK + "Erreur acces reference")
end if

if dw_1.RowCount() = 0 then
	ls_sql = is_sql_origine_dimension
	ls_sql = ls_sql  + " AND " + DBNAME_ARTICLE + " ='" + dw_pick.GetItemString (l_row, DBNAME_ARTICLE) + "' "
	dw_1.setSqlSelect(ls_sql)
	dw_1.setTransObject(sqlca)
	dw_1.retrieve()	
end if


end event

type dw_1 from w_a_pick_list_det`dw_1 within w_liste_reference
integer x = 809
integer y = 340
integer width = 1595
integer height = 844
string dataobject = "d_liste_reference"
boolean vscrollbar = true
end type

type uo_statusbar from w_a_pick_list_det`uo_statusbar within w_liste_reference
end type

type dw_pick from w_a_pick_list_det`dw_pick within w_liste_reference
integer x = 50
integer y = 116
integer width = 672
integer height = 1072
string dataobject = "d_selection_article"
boolean vscrollbar = true
end type

type cb_cancel from u_cb_cancel within w_liste_reference
integer x = 727
integer y = 1260
integer width = 352
integer height = 96
integer taborder = 40
boolean bringtotop = true
end type

type cb_ok from u_cb_ok within w_liste_reference
integer x = 302
integer y = 1260
integer width = 352
integer height = 96
integer taborder = 50
boolean bringtotop = true
end type

type cb_1 from u_cba within w_liste_reference
integer x = 1161
integer y = 1256
integer width = 357
integer height = 96
integer taborder = 11
boolean bringtotop = true
string text = "Changer réf"
end type

event clicked;call super::clicked;parent.triggerEvent("ue_chge_ref")
end event

