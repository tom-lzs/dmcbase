$PBExportHeader$nv_datastore.sru
$PBExportComments$Objet heritant de l'objet Datastore de PowerBuilder mais extension de la methode DBError pour extraite l'erreur retournée par la base de donnee
forward
global type nv_datastore from datastore
end type
end forward

global type nv_datastore from datastore
end type
global nv_datastore nv_datastore

type variables
String  is_sqlsyntax
dwBuffer  i_buffer
Long il_dberror_row
long il_sqlcode
String is_sqlerrtext

end variables

forward prototypes
public function string uf_getdberror ()
end prototypes

public function string uf_getdberror ();/* <DESC>
     Permet de retourner le code erreur et le message associée initialisés par l'évènement DBError
   </DESC> */
String ls_msg
string ls_sqlerrtext, ls_sqlsyntax
Long ll_sqldbcode

if isnull(il_sqlcode) then
	ll_sqldbcode = 0
else
	ll_sqldbcode = il_sqlcode
end if

if isnull(is_sqlerrtext) then
	ls_sqlerrtext = DONNEE_VIDE
else
	ls_sqlerrtext = is_sqlerrtext
end if

if isnull(is_sqlsyntax) then
	ls_sqlsyntax = DONNEE_VIDE
else
	ls_sqlsyntax = is_sqlsyntax
end if

ls_msg = "Erreur n° :"  + String (ll_sqldbcode) + " "
ls_msg = ls_msg + " Erreur message : " + ls_sqlerrtext + " "

return ls_msg
end function

on nv_datastore.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nv_datastore.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event dberror;/* <DESC>
    Declencher lors d'une anomalie rencontrée lors de l'accés à la base de donnée
	 Permet d'initialiser les variables d'instance contenant les différentes informations retrounées par
	 la base de données
   </DESC> */
is_sqlsyntax = sqlsyntax
i_buffer = buffer
il_dberror_row = row
il_sqlcode = sqldbcode
is_sqlerrtext = sqlerrtext
end event

