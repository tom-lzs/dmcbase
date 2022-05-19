$PBExportHeader$nv_dw_dbi.sru
$PBExportComments$Ancêtre des objets interface DataWindow/Base de données .
forward
global type nv_dw_dbi from nv_dw_dbi_pt
end type
end forward

global type nv_dw_dbi from nv_dw_dbi_pt
end type
global nv_dw_dbi nv_dw_dbi

on nv_dw_dbi.create
TriggerEvent(this, 'constructor')
end on

on nv_dw_dbi.destroy
TriggerEvent(this, 'destructor')
end on

