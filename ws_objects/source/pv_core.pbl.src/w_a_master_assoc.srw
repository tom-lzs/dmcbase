$PBExportHeader$w_a_master_assoc.srw
$PBExportComments$[MAIN] Fenêtre associative Maître/Détail.
forward
global type w_a_master_assoc from w_a_master_assoc_pt
end type
end forward

global type w_a_master_assoc from w_a_master_assoc_pt
end type
global w_a_master_assoc w_a_master_assoc

on w_a_master_assoc.create
call w_a_master_assoc_pt::create
end on

on w_a_master_assoc.destroy
call w_a_master_assoc_pt::destroy
end on

