$PBExportHeader$w_a_udim.srw
$PBExportComments$[MAIN] Ancêtre des fenêtres de Gestion Multi-lignes.
forward
global type w_a_udim from w_a_udim_pt
end type
end forward

global type w_a_udim from w_a_udim_pt
integer width = 1152
integer height = 792
end type
global w_a_udim w_a_udim

on w_a_udim.create
call super::create
end on

on w_a_udim.destroy
call super::destroy
end on

type dw_1 from w_a_udim_pt`dw_1 within w_a_udim
end type

