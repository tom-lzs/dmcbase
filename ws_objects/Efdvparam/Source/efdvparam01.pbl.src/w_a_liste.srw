$PBExportHeader$w_a_liste.srw
$PBExportComments$Ancêtre - Fenêtre de liste
forward
global type w_a_liste from w_a_pick_one
end type
end forward

global type w_a_liste from w_a_pick_one
integer x = 769
integer y = 461
integer width = 1381
integer height = 988
long backcolor = 12632256
end type
global w_a_liste w_a_liste

type variables
String is_colonne_prec = ""
String is_ordre_tri    = "A"
end variables

on w_a_liste.create
call super::create
end on

on w_a_liste.destroy
call super::destroy
end on

event ue_init;call super::ue_init;/* <DESC>
     Initialisation de l'affichage de la fenêtre en affichant la liste des données
   </DESC> */
	if dw_1.Retrieve () = -1 then
		f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
	end if
	
	if dw_1.rowCount() > 0 then
		dw_1.setRow(1)
		dw_1.setfocus()
		dw_1.fu_set_sort_on_label (True)		
	end if
		 
end event

event ue_cancel;call super::ue_cancel;/* <DESC>
     Permet de quitter la fenetre sans effectuer de selection
   </DESC> */
	Message.fnv_set_str_pass(i_str_pass)
	Close (This)
end event

event ue_ok;call super::ue_ok;/* <DESC>
      Validation de la sélection. Alimentation de la structure du code sélectionné ainsi que de l'intitulé.
   </DESC> */
Long		l_row
l_row		= dw_1.GetRow()

if l_row = 0 then
	return
end if

i_str_pass.s[1] = dw_1.GetItemString (l_row, 1)
i_str_pass.s[2] = dw_1.GetItemString (l_row, 2) 

Message.fnv_set_str_pass(i_str_pass)
Close (This)
end event

type cb_cancel from w_a_pick_one`cb_cancel within w_a_liste
integer x = 800
integer y = 740
integer taborder = 50
boolean cancel = false
end type

type cb_ok from w_a_pick_one`cb_ok within w_a_liste
integer x = 215
integer y = 740
integer taborder = 30
boolean default = false
end type

type dw_1 from w_a_pick_one`dw_1 within w_a_liste
integer x = 46
integer width = 1280
integer height = 584
integer taborder = 20
end type

event dw_1::we_dwnprocessenter;call super::we_dwnprocessenter;// Double click is equivalent to pressing the OK button

IF this.getselectedrow(0) > 0 THEN
	parent.TriggerEvent ("ue_ok")
END IF
end event

event dw_1::clicked;// Add the column whose label was clicked on (as identified by
// <column name> + _t) to the sort criteria and sort.

String s_object, s_col_name, s_ordre_tri,s_object_origine,s_object_picture
//

IF not i_b_sort_on_label THEN
	return
end if

IF Left (this.GetBandAtPointer ( ), 7) <> "header~t" THEN
	return
end if

s_object_origine = this.GetObjectAtPointer ()

// Correspond a l'image contenant l'ordre de tri
if pos(s_object_origine, "~p") > 0 then
	return
end if

if pos(s_object_origine, "~t") = 0 then
	return
end if

s_object = Left (s_object_origine, Pos (s_object_origine, "~t") - 1)
s_col_name = Left (s_object,Len (s_object) - 2)

if s_col_name = is_colonne_prec then
	if is_ordre_tri = "A" then
		s_ordre_tri = "D"
	else
		s_ordre_tri = "A"
	end if
else
	s_ordre_tri = "A"
	this.modify(is_colonne_prec + "_p_asc.visible='0'")
	this.modify(is_colonne_prec + "_p_desc.visible='0'")	
end if

this.modify(s_col_name + "_p_desc.visible='0'")		
this.modify(s_col_name + "_p_asc.visible='0'")		

if s_ordre_tri = "A" then
	this.modify(s_col_name + "_p_asc.visible='1'")	
else
	this.modify(s_col_name + "_p_desc.visible='1'")	
end if

	// 3d lowered border
this.SetSort (s_col_name + " " + s_ordre_tri + ", " + i_s_original_sort)
this.Sort ()

is_colonne_prec = s_col_name
is_ordre_tri = s_ordre_tri


this.PostEvent (RowFocusChanged!)


end event

