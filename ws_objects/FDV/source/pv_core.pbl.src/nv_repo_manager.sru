$PBExportHeader$nv_repo_manager.sru
$PBExportComments$Gestionnaire de répertoire de messages PowerTOOL .
forward
global type nv_repo_manager from nv_repo_manager_pt
end type
end forward

global type nv_repo_manager from nv_repo_manager_pt
end type
global nv_repo_manager nv_repo_manager

on nv_repo_manager.create
TriggerEvent(this, 'constructor')
end on

on nv_repo_manager.destroy
TriggerEvent(this, 'destructor')
end on

