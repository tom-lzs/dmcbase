$PBExportHeader$w_a_udim_su.srw
$PBExportComments$[MAIN] Ancêtre des fenêtres de Gestion Multi-lignes avec Update Mono-ligne.
forward
global type w_a_udim_su from w_a_udim_su_pt
end type
end forward

global type w_a_udim_su from w_a_udim_su_pt
integer width = 1449
integer height = 828
long i_l_save_row_num = 154064560
end type
global w_a_udim_su w_a_udim_su

on w_a_udim_su.create
call super::create
end on

on w_a_udim_su.destroy
call super::destroy
end on

type dw_1 from w_a_udim_su_pt`dw_1 within w_a_udim_su
end type

