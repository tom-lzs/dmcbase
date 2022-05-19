$PBExportHeader$nv_dw_dbiu_syb.sru
$PBExportComments$Interface Générale Datawindows/Bases de Données pour les Update Sybase .
forward
global type nv_dw_dbiu_syb from nv_dw_dbiu_syb_pt
end type
end forward

global type nv_dw_dbiu_syb from nv_dw_dbiu_syb_pt
end type
global nv_dw_dbiu_syb nv_dw_dbiu_syb

on nv_dw_dbiu_syb.create
TriggerEvent(this, 'constructor')
end on

on nv_dw_dbiu_syb.destroy
TriggerEvent(this, 'destructor')
end on

