$PBExportHeader$nv_error.sru
$PBExportComments$Objet erreur PowerTOOL .
forward
global type nv_error from nv_error_pt
end type
end forward

global type nv_error from nv_error_pt
end type
global nv_error nv_error

on nv_error.create
TriggerEvent(this, 'constructor')
end on

on nv_error.destroy
TriggerEvent(this, 'destructor')
end on

