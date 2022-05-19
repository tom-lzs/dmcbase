$PBExportHeader$nv_message.sru
$PBExportComments$Objet message PowerTOOL .
forward
global type nv_message from nv_message_pt
end type
end forward

global type nv_message from nv_message_pt
end type
global nv_message nv_message

on nv_message.create
TriggerEvent(this, 'constructor')
end on

on nv_message.destroy
TriggerEvent(this, 'destructor')
end on

