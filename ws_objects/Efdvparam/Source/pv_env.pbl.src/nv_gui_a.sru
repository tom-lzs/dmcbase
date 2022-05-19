$PBExportHeader$nv_gui_a.sru
$PBExportComments$GUI Services.
forward
global type nv_gui_a from nv_gui_a_pt
end type
end forward

global type nv_gui_a from nv_gui_a_pt
end type
global nv_gui_a nv_gui_a

on nv_gui_a.create
TriggerEvent( this, "constructor" )
end on

on nv_gui_a.destroy
TriggerEvent( this, "destructor" )
end on

