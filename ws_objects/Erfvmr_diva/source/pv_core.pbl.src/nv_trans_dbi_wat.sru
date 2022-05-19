$PBExportHeader$nv_trans_dbi_wat.sru
$PBExportComments$Ancêtre des objets d'interface de transaction de base de données pour Watcom .
forward
global type nv_trans_dbi_wat from nv_trans_dbi_wat_pt
end type
end forward

global type nv_trans_dbi_wat from nv_trans_dbi_wat_pt
end type
global nv_trans_dbi_wat nv_trans_dbi_wat

on nv_trans_dbi_wat.create
TriggerEvent(this, 'constructor')
end on

on nv_trans_dbi_wat.destroy
TriggerEvent(this, 'destructor')
end on

