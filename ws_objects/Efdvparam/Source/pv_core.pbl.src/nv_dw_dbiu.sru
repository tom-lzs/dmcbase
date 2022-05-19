$PBExportHeader$nv_dw_dbiu.sru
$PBExportComments$Interface Générale Datawindows/Bases de Données possédant un langage procédural pour les Update .
forward
global type nv_dw_dbiu from nv_dw_dbiu_pt
end type
end forward

global type nv_dw_dbiu from nv_dw_dbiu_pt
end type
global nv_dw_dbiu nv_dw_dbiu

on nv_dw_dbiu.create
TriggerEvent(this, 'constructor')
end on

on nv_dw_dbiu.destroy
TriggerEvent(this, 'destructor')
end on

