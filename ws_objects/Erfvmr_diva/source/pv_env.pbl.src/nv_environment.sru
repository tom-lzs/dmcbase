$PBExportHeader$nv_environment.sru
$PBExportComments$Services d'Environnements .
forward
global type nv_environment from nv_environment_pt
end type
end forward

global type nv_environment from nv_environment_pt
end type
global nv_environment nv_environment

on nv_environment.create
TriggerEvent( this, "constructor" )
end on

on nv_environment.destroy
TriggerEvent( this, "destructor" )
end on

