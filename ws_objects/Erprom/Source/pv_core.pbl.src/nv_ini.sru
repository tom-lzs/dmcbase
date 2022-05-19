$PBExportHeader$nv_ini.sru
$PBExportComments$Fonctions de sauvegarde et de lecture des fichiers .INI.
forward
global type nv_ini from nv_ini_pt
end type
end forward

global type nv_ini from nv_ini_pt
end type
global nv_ini nv_ini

on nv_ini.create
TriggerEvent(this, 'constructor')
end on

on nv_ini.destroy
TriggerEvent(this, 'destructor')
end on

