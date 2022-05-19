$PBExportHeader$nv_param_informatique.sru
forward
global type nv_param_informatique from nonvisualobject
end type
end forward

global type nv_param_informatique from nonvisualobject
end type
global nv_param_informatique nv_param_informatique

type variables
Datastore ids_param
end variables

forward prototypes
private subroutine retrieve_data (string as_param)
public function string fu_get_repertoire_help ()
public function string fu_get_prefixe_fichier_version ()
public function string fu_get_version_precedente ()
public function string fu_get_page_alerte ()
public function string fu_get_cde_ouvrir_page ()
public function string fu_get_page_install ()
public subroutine fu_ouvrir_page_alerte ()
public subroutine fu_ouvrir_page_installe ()
public function string fu_get_cde_fin_transfert ()
public function string fu_get_commande_ping ()
public function string fu_get_ping_file ()
public function string fu_check_directory (string as_directory, string as_subdirectory)
public function string fu_get_version_autorisee ()
public subroutine fu_apres_maj_portable ()
public function string fu_get_cde_fin_transfert_2 ()
public function boolean fu_transfert_interdit ()
public function boolean fu_recup_interdite ()
public function string fu_get_dernier_patch ()
public subroutine fu_install_patch ()
public function string fu_get_page_install_patch ()
public function string fu_type_integration ()
end prototypes

private subroutine retrieve_data (string as_param); ids_param.retrieve(as_param)
end subroutine

public function string fu_get_repertoire_help ();String ls_value

retrieve_data("REPERTOIRE_NEWS")

if ids_param.RowCount() = 0 then
	ls_value = ""
else
	ls_value = ids_param.getItemString(1,"valeur_alpha")
end if

return  ls_value

end function

public function string fu_get_prefixe_fichier_version ();String ls_value

retrieve_data("PREFIX_FICHIER_VERSION")

if ids_param.RowCount() = 0 then
	ls_value = ""
else
	ls_value = ids_param.getItemString(1,"valeur_alpha")
end if

return  ls_value
end function

public function string fu_get_version_precedente ();String ls_value

retrieve_data("VERSION_PRECEDENTE")

if ids_param.RowCount() = 0 then
	ls_value = "???"
else
	ls_value = ids_param.getItemString(1,"valeur_alpha")
end if

if isnull(ls_value) then
	ls_value = "???"
end if

return  ls_value

end function

public function string fu_get_page_alerte ();String ls_value

retrieve_data(g_nv_come9par.get_type_visiteur( ) +  "_ALERTE")

if ids_param.RowCount() = 0 then
	ls_value = "???"
else
	ls_value = ids_param.getItemString(1,"valeur_alpha")
end if

if isnull(ls_value) then
	ls_value = "???"
end if

return  ls_value

end function

public function string fu_get_cde_ouvrir_page ();String ls_value

retrieve_data("CDE_OUVRIR_PAGE")

if ids_param.RowCount() = 0 then
	ls_value = ""
else
	ls_value = ids_param.getItemString(1,"valeur_alpha")
end if

return  ls_value
end function

public function string fu_get_page_install ();String ls_value

retrieve_data('PAGE_INSTALLATION_VERSION')

if ids_param.RowCount() = 0 then
	ls_value = "???"
else
	ls_value = ids_param.getItemString(1,"valeur_alpha")
end if

if isnull(ls_value) then
	ls_value = "???"
end if

return  ls_value
end function

public subroutine fu_ouvrir_page_alerte ();String ls_page_html
String ls_cmd

ls_page_html = fu_get_page_alerte()
ls_cmd			= fu_get_cde_ouvrir_page( )
ls_cmd			= ls_cmd + " " + ls_page_html

run ( ls_cmd)
end subroutine

public subroutine fu_ouvrir_page_installe ();String ls_cmd
String ls_page_html


ls_page_html = fu_get_page_install()
ls_cmd			= fu_get_cde_ouvrir_page( )
ls_cmd			= ls_cmd + " " + ls_page_html

run ( ls_cmd)
	
end subroutine

public function string fu_get_cde_fin_transfert ();String ls_value

retrieve_data("CDE_FIN_TRANSFERT_V2")

if ids_param.RowCount() = 0 then
	ls_value = ""
else
	ls_value = ids_param.getItemString(1,"valeur_alpha")
end if

return  ls_value

end function

public function string fu_get_commande_ping ();String ls_value1, ls_value2, ls_value

retrieve_data("PING")
if ids_param.RowCount() = 0 then
	ls_value1 = "???"
else
	ls_value1 = ids_param.getItemString(1,"valeur_alpha")
end if

ls_value2 = fu_get_ping_file()

if isnull(ls_value1) or isnull(ls_value2)  then
	return "???"
end if

ls_value = ls_value1 + ls_value2
return  ls_value
end function

public function string fu_get_ping_file ();String ls_value 

retrieve_data("PING_FILE")
if ids_param.RowCount() = 0 then
	ls_value = "???"
else
	ls_value = ids_param.getItemString(1,"valeur_alpha")
end if

if isnull(ls_value) then
	ls_value = "???"
end if

return ls_value
end function

public function string fu_check_directory (string as_directory, string as_subdirectory);String ls_directory

ls_directory = GetCurrentDirectory ( )
ls_directory = ls_directory + "\" + as_directory

if not  DirectoryExists ( ls_directory ) Then
	CreateDirectory(ls_directory)
end if

if len(as_subdirectory) > 0 then
	ls_directory = ls_directory + "\" + as_subdirectory
	if not  DirectoryExists ( ls_directory ) Then
		CreateDirectory(ls_directory)
	end if
end if

return ls_directory
end function

public function string fu_get_version_autorisee ();String ls_value
String ls_param

Choose case g_nv_come9par.get_type_visiteur( )
	case 'RC'
		ls_param = 'VERSION_RC'
	case 'VD'
		ls_param = 'VERSION_VD'
	case'FI'
		ls_param = 'VERSION_FI'
	case'MA'
		ls_param = 'VERSION_MA'
	case'VM'
		ls_param = 'VERSION_VD'
		
end choose

retrieve_data(ls_param)

if ids_param.RowCount() = 0 then
	ls_value = "???"
else
	ls_value = ids_param.getItemString(1,"valeur_alpha")
end if

if isnull(ls_value) then
	ls_value = "???"
end if

return  ls_value

end function

public subroutine fu_apres_maj_portable ();String ls_value

retrieve_data("CdeApMajPortable")
if ids_param.RowCount() = 0 then
	return
else
	ls_value = ids_param.getItemString(1,"valeur_alpha")
end if

if isnull(ls_value) then
	return
end if

run ( ls_value)
end subroutine

public function string fu_get_cde_fin_transfert_2 ();String ls_value

retrieve_data("CDE_FIN_TRANSFERT_V2_2")

if ids_param.RowCount() = 0 then
	ls_value = ""
else
	ls_value = ids_param.getItemString(1,"valeur_alpha")
end if

return  ls_value

end function

public function boolean fu_transfert_interdit ();String ls_param, ls_value
Constant String TRANSFERT_INTERDIT = 'TRF_INTERDIT_'

ls_param = TRANSFERT_INTERDIT + g_nv_come9par.get_type_visiteur( )
retrieve_data(ls_param)

if ids_param.RowCount() = 0 then
	return false
else
	ls_value = ids_param.getItemString(1,"valeur_alpha")
end if

if isnull(ls_value) then
	return false
end if

if upper(ls_value) = "O" then
	return true
end if
return false
end function

public function boolean fu_recup_interdite ();String ls_param, ls_value
Constant String RECUP_INTERDIT = 'RECUP_INTERDIT_'

ls_param = RECUP_INTERDIT + g_nv_come9par.get_type_visiteur( )
retrieve_data(ls_param)

if ids_param.RowCount() = 0 then
	return false
else
	ls_value = ids_param.getItemString(1,"valeur_alpha")
end if

if isnull(ls_value) then
	return false
end if

if upper(ls_value) = "O" then
	return true
end if
return false
end function

public function string fu_get_dernier_patch ();String ls_value
String ls_param
ls_param = 'PATCH'
retrieve_data(ls_param)

if ids_param.RowCount() = 0 then
	ls_value = "???"
else
	ls_value = ids_param.getItemString(1,"valeur_alpha")
end if

if isnull(ls_value) then
	ls_value = "???"
end if

return  ls_value

end function

public subroutine fu_install_patch ();String ls_cmd
String ls_page_html


ls_page_html   = fu_get_page_install_patch()
ls_cmd			= fu_get_cde_ouvrir_page( )
ls_cmd			= ls_cmd + " " + ls_page_html

run ( ls_cmd)
	
end subroutine

public function string fu_get_page_install_patch ();String ls_value

retrieve_data('PAGE_INSTALLATION_PATCH')

if ids_param.RowCount() = 0 then
	ls_value = "???"
else
	ls_value = ids_param.getItemString(1,"valeur_alpha")
end if

if isnull(ls_value) then
	ls_value = "???"
end if

return  ls_value
end function

public function string fu_type_integration ();String ls_value 

retrieve_data("TYPE_INTEGRATION")
if ids_param.RowCount() = 0 then
	ls_value = "???"
else
	ls_value = ids_param.getItemString(1,"valeur_alpha")
end if

if isnull(ls_value) then
	ls_value = "???"
end if

return ls_value
end function

event constructor;/* <DESC>
   Initialisation des données du visteur connecté à partir des informatiosn stockées dans
  la base de données
  </DESC> */

 ids_param = CREATE DATASTORE
 ids_param.DataObject = 'd_object_param_informatique'
 ids_param.SetTransObject (SQLCA)

end event

on nv_param_informatique.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nv_param_informatique.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

