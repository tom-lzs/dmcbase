$PBExportHeader$nv_dw_dbiu_wat.sru
$PBExportComments$Interface Générale Datawindows/Bases de Données pour les Update Watcom .
forward
global type nv_dw_dbiu_wat from nv_dw_dbiu_wat_pt
end type
end forward

global type nv_dw_dbiu_wat from nv_dw_dbiu_wat_pt
end type
global nv_dw_dbiu_wat nv_dw_dbiu_wat

on nv_dw_dbiu_wat.create
TriggerEvent(this, 'constructor')
end on

on nv_dw_dbiu_wat.destroy
TriggerEvent(this, 'destructor')
end on

