$PBExportHeader$nv_dw_dbiu_pl.sru
$PBExportComments$Interface Générale Datawindows/Bases de Données possédant un langage procédural pour les Update .
forward
global type nv_dw_dbiu_pl from nv_dw_dbiu_pl_pt
end type
end forward

global type nv_dw_dbiu_pl from nv_dw_dbiu_pl_pt
end type
global nv_dw_dbiu_pl nv_dw_dbiu_pl

on nv_dw_dbiu_pl.create
TriggerEvent(this, 'constructor')
end on

on nv_dw_dbiu_pl.destroy
TriggerEvent(this, 'destructor')
end on

