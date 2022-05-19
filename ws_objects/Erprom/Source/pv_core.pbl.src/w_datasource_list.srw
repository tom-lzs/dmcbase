$PBExportHeader$w_datasource_list.srw
$PBExportComments$Boite de dialogue de sélection des sources de données.
forward
global type w_datasource_list from w_datasource_list_pt
end type
end forward

global type w_datasource_list from w_datasource_list_pt
end type
global w_datasource_list w_datasource_list

on w_datasource_list.create
call w_datasource_list_pt::create
end on

on w_datasource_list.destroy
call w_datasource_list_pt::destroy
end on

