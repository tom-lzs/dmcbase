$PBExportHeader$w_a_udim_su.srw
$PBExportComments$[MAIN] Ancêtre des fenêtres de Gestion Multi-lignes avec Update Mono-ligne.
forward
global type w_a_udim_su from w_a_udim_su_pt
end type
end forward

global type w_a_udim_su from w_a_udim_su_pt
end type
global w_a_udim_su w_a_udim_su

on w_a_udim_su.create
call w_a_udim_su_pt::create
end on

on w_a_udim_su.destroy
call w_a_udim_su_pt::destroy
end on

