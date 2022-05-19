$PBExportHeader$nv_transaction.sru
$PBExportComments$Objet transaction PowerTOOL .
forward
global type nv_transaction from nv_transaction_pt
end type
end forward

global type nv_transaction from nv_transaction_pt
end type
global nv_transaction nv_transaction

on nv_transaction.create
call transaction::create
TriggerEvent( this, "constructor" )
end on

on nv_transaction.destroy
call transaction::destroy
TriggerEvent( this, "destructor" )
end on

