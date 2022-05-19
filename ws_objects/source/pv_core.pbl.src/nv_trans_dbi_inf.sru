$PBExportHeader$nv_trans_dbi_inf.sru
$PBExportComments$Ancêtre des objets d'interface de transaction de base de données pour Informix .
forward
global type nv_trans_dbi_inf from nv_trans_dbi_inf_pt
end type
end forward

global type nv_trans_dbi_inf from nv_trans_dbi_inf_pt
end type
global nv_trans_dbi_inf nv_trans_dbi_inf

on nv_trans_dbi_inf.create
TriggerEvent(this, 'constructor')
end on

on nv_trans_dbi_inf.destroy
TriggerEvent(this, 'destructor')
end on

