$PBExportHeader$nv_ds_udi.sru
$PBExportComments$Datastore Ancêtre pour la mise à jour .
forward
global type nv_ds_udi from nv_ds_udi_pt
end type
end forward

global type nv_ds_udi from nv_ds_udi_pt
end type
global nv_ds_udi nv_ds_udi

on nv_ds_udi.create
call datastore::create
TriggerEvent( this, "constructor" )
end on

on nv_ds_udi.destroy
call datastore::destroy
TriggerEvent( this, "destructor" )
end on

