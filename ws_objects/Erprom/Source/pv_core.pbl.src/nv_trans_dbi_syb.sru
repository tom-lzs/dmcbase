$PBExportHeader$nv_trans_dbi_syb.sru
$PBExportComments$Ancêtre des objets d'interface de transaction de base de données pour Sybase .
forward
global type nv_trans_dbi_syb from nv_trans_dbi_syb_pt
end type
end forward

global type nv_trans_dbi_syb from nv_trans_dbi_syb_pt
end type
global nv_trans_dbi_syb nv_trans_dbi_syb

on nv_trans_dbi_syb.create
TriggerEvent(this, 'constructor')
end on

on nv_trans_dbi_syb.destroy
TriggerEvent(this, 'destructor')
end on

