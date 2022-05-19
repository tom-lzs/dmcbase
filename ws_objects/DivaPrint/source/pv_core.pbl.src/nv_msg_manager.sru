$PBExportHeader$nv_msg_manager.sru
$PBExportComments$Gestionnaire de messages (affichage et connexion) PowerTOOL .
forward
global type nv_msg_manager from nv_msg_manager_pt
end type
end forward

global type nv_msg_manager from nv_msg_manager_pt
end type
global nv_msg_manager nv_msg_manager

on nv_msg_manager.create
TriggerEvent(this, 'constructor')
end on

on nv_msg_manager.destroy
TriggerEvent(this, 'destructor')
end on

