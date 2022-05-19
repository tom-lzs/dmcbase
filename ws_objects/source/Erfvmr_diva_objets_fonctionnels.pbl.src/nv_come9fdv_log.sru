$PBExportHeader$nv_come9fdv_log.sru
$PBExportComments$Permet de creer les donnes de suivi de l'activite des portables
forward
global type nv_come9fdv_log from nonvisualobject
end type
end forward

global type nv_come9fdv_log from nonvisualobject
end type
global nv_come9fdv_log nv_come9fdv_log

type variables
Datastore i_ds_come9fdv_log    // Datatsore contenat les données de la log

boolean ib_retrieve
boolean ib_retrieve_ok
end variables

forward prototypes
private function boolean retrieve (transaction a_tr)
public subroutine set_log_recup_cde (string as_numcde, string as_cetcde, string as_codemaj, transaction a_tr)
public function boolean updatelog ()
public subroutine set_log_transfert (datetime ad_date_deb, transaction a_tr)
public subroutine set_log_erreur_maj_portable (datetime ad_date_deb, transaction a_tr, string as_message)
public subroutine set_log_erreur_transfert_cde (datetime ad_date_deb, transaction a_tr, string as_message)
public subroutine set_log_maj_portable (datetime ad_date_deb, transaction a_tr, decimal adec_numcde_port, decimal adec_numcde_serv)
public subroutine set_cde_ntrf (string as_numcde, string as_cetcde, string as_codemaj, transaction a_tr, datetime ad_datesaisie, datetime ad_datecde, string as_client)
end prototypes

private function boolean retrieve (transaction a_tr);ib_retrieve = true
i_ds_come9fdv_log.SetTransObject (a_tr)

if i_ds_come9fdv_log.retrieve() = -1 then
	ib_retrieve_ok = false
	return false
else
	ib_retrieve_ok = true
	return true
end if
end function

public subroutine set_log_recup_cde (string as_numcde, string as_cetcde, string as_codemaj, transaction a_tr);if not ib_retrieve  then
	retrieve(a_tr)
end if

if not ib_retrieve_ok then
	return
end if

Long ll_row
ll_row = i_ds_come9fdv_log.insertrow (0)
i_ds_come9fdv_log.setItem (ll_row,1, g_s_visiteur)
i_ds_come9fdv_log.setItem (ll_row,2, sqlca.fnv_get_datetime ())
i_ds_come9fdv_log.setItem (ll_row,3, "RECUP_CDE_PORT")
i_ds_come9fdv_log.setItem (ll_row,4,as_numcde)
i_ds_come9fdv_log.setItem (ll_row,5, as_cetcde)
i_ds_come9fdv_log.setItem (ll_row,6, as_codemaj)
return
end subroutine

public function boolean updatelog ();if i_ds_come9fdv_log.update() = -1 then
	return false
else
	return true
end if
end function

public subroutine set_log_transfert (datetime ad_date_deb, transaction a_tr);
if not ib_retrieve  then
	retrieve(a_tr)
end if

if not ib_retrieve_ok then
	return
end if

Long ll_row
ll_row = i_ds_come9fdv_log.insertrow (0)
i_ds_come9fdv_log.setItem (ll_row,1, g_s_visiteur)
i_ds_come9fdv_log.setItem (ll_row,2, sqlca.fnv_get_datetime ())
i_ds_come9fdv_log.setItem (ll_row,3, "TRANSFERT_CDE_PORT")
i_ds_come9fdv_log.setItem (ll_row,4,'')
i_ds_come9fdv_log.setItem (ll_row,5, '')
i_ds_come9fdv_log.setItem (ll_row,7, ad_date_deb)
i_ds_come9fdv_log.setItem (ll_row,8, sqlca.fnv_get_datetime ())
updateLog()

return


end subroutine

public subroutine set_log_erreur_maj_portable (datetime ad_date_deb, transaction a_tr, string as_message);if not ib_retrieve  then
	retrieve(a_tr)
end if

if not ib_retrieve_ok then
	return
end if

Long ll_row
ll_row = i_ds_come9fdv_log.insertrow (0)
i_ds_come9fdv_log.setItem (ll_row,1, g_s_visiteur)
i_ds_come9fdv_log.setItem (ll_row,2, sqlca.fnv_get_datetime ())
i_ds_come9fdv_log.setItem (ll_row,3, "ERR_MAJ_PORTABLE")
i_ds_come9fdv_log.setItem (ll_row,4, " ")
i_ds_come9fdv_log.setItem (ll_row,5, " ")
i_ds_come9fdv_log.setItem (ll_row,6, "C ")
i_ds_come9fdv_log.setItem (ll_row,7, ad_date_deb)
i_ds_come9fdv_log.setItem (ll_row,8, sqlca.fnv_get_datetime ())
i_ds_come9fdv_log.setItem (ll_row,11,as_message)
updateLog()
return
end subroutine

public subroutine set_log_erreur_transfert_cde (datetime ad_date_deb, transaction a_tr, string as_message);if not ib_retrieve  then
	retrieve(a_tr)
end if

if not ib_retrieve_ok then
	return
end if

Long ll_row
ll_row = i_ds_come9fdv_log.insertrow (0)
i_ds_come9fdv_log.setItem (ll_row,1, g_s_visiteur)
i_ds_come9fdv_log.setItem (ll_row,2, sqlca.fnv_get_datetime ())
i_ds_come9fdv_log.setItem (ll_row,3, "ERR_TRANSFERT_CDE_PORT")
i_ds_come9fdv_log.setItem (ll_row,4, " ")
i_ds_come9fdv_log.setItem (ll_row,5, " ")
i_ds_come9fdv_log.setItem (ll_row,6, "C ")
i_ds_come9fdv_log.setItem (ll_row,7, ad_date_deb)
i_ds_come9fdv_log.setItem (ll_row,8, sqlca.fnv_get_datetime ())
i_ds_come9fdv_log.setItem (ll_row,11,as_message)
updateLog()
return
end subroutine

public subroutine set_log_maj_portable (datetime ad_date_deb, transaction a_tr, decimal adec_numcde_port, decimal adec_numcde_serv);if not ib_retrieve  then
	retrieve(a_tr)
end if

if not ib_retrieve_ok then
	return
end if

Long ll_row
nv_control_manager  lnv_control_manager
lnv_control_manager = CREATE nv_control_manager

ll_row = i_ds_come9fdv_log.insertrow (0)
i_ds_come9fdv_log.setItem (ll_row,1, g_s_visiteur)
i_ds_come9fdv_log.setItem (ll_row,2, sqlca.fnv_get_datetime ())
i_ds_come9fdv_log.setItem (ll_row,3, "MAJ_PORTABLE")
i_ds_come9fdv_log.setItem (ll_row,4, " ")
i_ds_come9fdv_log.setItem (ll_row,5, " ")
i_ds_come9fdv_log.setItem (ll_row,6, "C ")
i_ds_come9fdv_log.setItem (ll_row,7, ad_date_deb)
i_ds_come9fdv_log.setItem (ll_row,8, sqlca.fnv_get_datetime ())
i_ds_come9fdv_log.setItem (ll_row,9, adec_numcde_port)
i_ds_come9fdv_log.setItem (ll_row,10, adec_numcde_serv)
i_ds_come9fdv_log.setItem (ll_row,11,"Version : " + g_s_version + g_s_patch  )
updateLog()
return
end subroutine

public subroutine set_cde_ntrf (string as_numcde, string as_cetcde, string as_codemaj, transaction a_tr, datetime ad_datesaisie, datetime ad_datecde, string as_client);if not ib_retrieve  then
	retrieve(a_tr)
end if

if not ib_retrieve_ok then
	return
end if

Long ll_row
ll_row = i_ds_come9fdv_log.insertrow (0)
i_ds_come9fdv_log.setItem (ll_row,1, g_s_visiteur)
i_ds_come9fdv_log.setItem (ll_row,2, sqlca.fnv_get_datetime ())
i_ds_come9fdv_log.setItem (ll_row,3, "CDE_NCOPIE_SUR_SRV")
i_ds_come9fdv_log.setItem (ll_row,4,as_numcde)
i_ds_come9fdv_log.setItem (ll_row,5, as_cetcde)
i_ds_come9fdv_log.setItem (ll_row,6, as_codemaj)
i_ds_come9fdv_log.setItem (ll_row,7, ad_datesaisie)
i_ds_come9fdv_log.setItem (ll_row,8, ad_datecde)
i_ds_come9fdv_log.setItem (ll_row,11, as_client)
updateLog()
return
end subroutine

event constructor;
i_ds_come9fdv_log = CREATE DATASTORE
i_ds_come9fdv_log.DataObject = 'd_come9fdv_log'


end event

on nv_come9fdv_log.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nv_come9fdv_log.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

