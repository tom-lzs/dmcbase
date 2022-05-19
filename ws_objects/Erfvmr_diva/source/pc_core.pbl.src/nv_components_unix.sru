$PBExportHeader$nv_components_unix.sru
$PBExportComments$PowerCerv Unix components versioning (from nv_components_ext_a)
forward
global type nv_components_unix from nv_components_ext_a
end type
end forward

global type nv_components_unix from nv_components_ext_a
end type
global nv_components_unix nv_components_unix

on nv_components_unix.create
TriggerEvent( this, "constructor" )
end on

on nv_components_unix.destroy
TriggerEvent( this, "destructor" )
end on

