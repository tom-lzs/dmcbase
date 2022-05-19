$PBExportHeader$nv_win_proto.sru
$PBExportComments$Objet protocole des fenêtres SDI [DEFAULT] .
forward
global type nv_win_proto from nv_win_proto_pt
end type
end forward

global type nv_win_proto from nv_win_proto_pt
end type
global nv_win_proto nv_win_proto

on nv_win_proto.create
TriggerEvent(this, 'constructor')
end on

on nv_win_proto.destroy
TriggerEvent(this, 'destructor')
end on

