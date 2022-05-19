$PBExportHeader$w_set_toolbars.srw
$PBExportComments$[RESPONSE] Gestion de la barre d'icônes.
forward
global type w_set_toolbars from w_set_toolbars_pt
end type
end forward

global type w_set_toolbars from w_set_toolbars_pt
end type
global w_set_toolbars w_set_toolbars

on w_set_toolbars.create
call w_set_toolbars_pt::create
end on

on w_set_toolbars.destroy
call w_set_toolbars_pt::destroy
end on

