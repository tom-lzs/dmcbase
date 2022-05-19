$PBExportHeader$nv_sqlca.sru
$PBExportComments$Objet non visuel de type transaction , ajoute des fonctions à SQLCA
forward
global type nv_sqlca from nv_transaction
end type
end forward

global type nv_sqlca from nv_transaction
end type
global nv_sqlca nv_sqlca

type prototypes

end prototypes

on nv_sqlca.create
call super::create
end on

on nv_sqlca.destroy
call super::destroy
end on

