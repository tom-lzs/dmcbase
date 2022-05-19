$PBExportHeader$nv_os_api_a.sru
$PBExportComments$Services API System .
forward
global type nv_os_api_a from nv_os_api_a_pt
end type
end forward

global type nv_os_api_a from nv_os_api_a_pt
end type
global nv_os_api_a nv_os_api_a

on nv_os_api_a.create
TriggerEvent( this, "constructor" )
end on

on nv_os_api_a.destroy
TriggerEvent( this, "destructor" )
end on

