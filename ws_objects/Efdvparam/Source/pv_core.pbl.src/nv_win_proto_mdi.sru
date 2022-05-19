$PBExportHeader$nv_win_proto_mdi.sru
$PBExportComments$Objet protocole des fenêtres MDI .
forward
global type nv_win_proto_mdi from nv_win_proto_mdi_pt
end type
end forward

global type nv_win_proto_mdi from nv_win_proto_mdi_pt
end type
global nv_win_proto_mdi nv_win_proto_mdi

on nv_win_proto_mdi.create
TriggerEvent(this, 'constructor')
end on

on nv_win_proto_mdi.destroy
TriggerEvent(this, 'destructor')
end on

