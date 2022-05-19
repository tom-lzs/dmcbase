$PBExportHeader$nv_attr.sru
$PBExportComments$Ancêtre des Attributs d'Objets .
forward
global type nv_attr from nv_attr_pt
end type
end forward

global type nv_attr from nv_attr_pt
end type
global nv_attr nv_attr

on nv_attr.create
TriggerEvent( this, "constructor" )
end on

on nv_attr.destroy
TriggerEvent( this, "destructor" )
end on

