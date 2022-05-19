$PBExportHeader$nv_dw_dbiu_or7.sru
$PBExportComments$Interface Générale Datawindows/Bases de Données pour les Update Oracle 7.
forward
global type nv_dw_dbiu_or7 from nv_dw_dbiu_or7_pt
end type
end forward

global type nv_dw_dbiu_or7 from nv_dw_dbiu_or7_pt
end type
global nv_dw_dbiu_or7 nv_dw_dbiu_or7

on nv_dw_dbiu_or7.create
TriggerEvent(this, 'constructor')
end on

on nv_dw_dbiu_or7.destroy
TriggerEvent(this, 'destructor')
end on

