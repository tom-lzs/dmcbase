$PBExportHeader$nv_trans_dbi_ora.sru
$PBExportComments$Ancêtre des objets d'interface de transaction de base de données pour Oracle .
forward
global type nv_trans_dbi_ora from nv_trans_dbi_ora_pt
end type
end forward

global type nv_trans_dbi_ora from nv_trans_dbi_ora_pt
end type
global nv_trans_dbi_ora nv_trans_dbi_ora

on nv_trans_dbi_ora.create
TriggerEvent(this, 'constructor')
end on

on nv_trans_dbi_ora.destroy
TriggerEvent(this, 'destructor')
end on

