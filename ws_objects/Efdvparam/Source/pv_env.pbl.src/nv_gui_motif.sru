$PBExportHeader$nv_gui_motif.sru
$PBExportComments$API Motifes.
forward
global type nv_gui_motif from nv_gui_motif_pt
end type
end forward

global type nv_gui_motif from nv_gui_motif_pt
end type
global nv_gui_motif nv_gui_motif

on nv_gui_motif.create
TriggerEvent( this, "constructor" )
end on

on nv_gui_motif.destroy
TriggerEvent( this, "destructor" )
end on

