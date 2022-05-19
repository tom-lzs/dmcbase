$PBExportHeader$nv_components_mac.sru
$PBExportComments$PowerCerv Macintosh components versioning (from nv_components_ext_a)
forward
global type nv_components_mac from nv_components_ext_a
end type
end forward

global type nv_components_mac from nv_components_ext_a
end type
global nv_components_mac nv_components_mac

on nv_components_mac.create
TriggerEvent( this, "constructor" )
end on

on nv_components_mac.destroy
TriggerEvent( this, "destructor" )
end on

