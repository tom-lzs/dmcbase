$PBExportHeader$nv_dsa.sru
$PBExportComments$Datastore Ancêtre .
forward
global type nv_dsa from nv_dsa_pt
end type
end forward

global type nv_dsa from nv_dsa_pt
end type
global nv_dsa nv_dsa

on nv_dsa.create
call datastore::create
TriggerEvent( this, "constructor" )
end on

on nv_dsa.destroy
call datastore::destroy
TriggerEvent( this, "destructor" )
end on

