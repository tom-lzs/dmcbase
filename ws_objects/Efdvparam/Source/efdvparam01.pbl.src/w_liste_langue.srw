$PBExportHeader$w_liste_langue.srw
forward
global type w_liste_langue from w_a_liste
end type
end forward

global type w_liste_langue from w_a_liste
end type
global w_liste_langue w_liste_langue

on w_liste_langue.create
call super::create
end on

on w_liste_langue.destroy
call super::destroy
end on

type cb_cancel from w_a_liste`cb_cancel within w_liste_langue
end type

type cb_ok from w_a_liste`cb_ok within w_liste_langue
end type

type dw_1 from w_a_liste`dw_1 within w_liste_langue
string dataobject = "d_liste_langue"
end type

