$PBExportHeader$nv_trans_dbi.sru
$PBExportComments$Ancêtre des objets d'interface de transaction de base de données.
forward
global type nv_trans_dbi from nv_trans_dbi_pt
end type
end forward

global type nv_trans_dbi from nv_trans_dbi_pt
end type
global nv_trans_dbi nv_trans_dbi

on nv_trans_dbi.create
TriggerEvent(this, 'constructor')
end on

on nv_trans_dbi.destroy
TriggerEvent(this, 'destructor')
end on

