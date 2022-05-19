$PBExportHeader$nv_trace.sru
$PBExportComments$Permet de créer une ligne dans le fichier trace si on est en mode debug.
forward
global type nv_trace from nonvisualobject
end type
end forward

global type nv_trace from nonvisualobject
end type
global nv_trace nv_trace

type variables
String is_file_name
Boolean ib_ModeDebug
end variables

forward prototypes
public subroutine fu_write_trace (string as_object_name, string as_event, string as_client, string as_cde, string as_origine, string as_destination)
end prototypes

public subroutine fu_write_trace (string as_object_name, string as_event, string as_client, string as_cde, string as_origine, string as_destination);integer li_file_number
String ls_line

if not ib_modeDebug then
	return
end if

li_file_number = FileOpen ( is_file_name, LineMode!, Write!, LockReadWrite!, Append!)

IF li_file_number < 0 THEN
	RETURN
END IF

ls_line = String(today(),  "dd/mm/yy hh:mm:ss- " )
ls_line = ls_line + as_object_name + space(25 - len( as_object_name) ) + " - " + trim(as_event) + space(20 - len(trim(as_event)))
if trim(as_client) = DONNEE_VIDE then
	ls_line = ls_line + " - " + space(20)
else
   ls_line = ls_line + " - N° Clt = " + trim(as_client) + space (11 - len(trim(as_client)))
end if
if trim(as_cde) = DONNEE_VIDE  then
	ls_line = ls_line + " - " + space(20)
else
   ls_line = ls_line + "  - N° cde = " + trim(as_cde) + space (11 - len(trim(as_cde)))
end if
ls_line = ls_line + "  - Origine " + trim(as_origine) + space (30 - len(trim(as_origine)))
ls_line = ls_line + "  - Dest " + trim(as_destination)
FileWrite (li_file_number,ls_line)

FileClose (li_file_number)
end subroutine

event constructor;// creation de l'object trace si mode debug positionne
if  upper(g_nv_ini.fnv_profile_string("PowerTool","ModeDebug","NON")) = "OUI" then
	ib_ModeDebug = true
     is_file_name = g_nv_ini.fnv_profile_string("PowerTool","TraceFile",GetApplication().AppName +"Trace")
     is_file_name = g_nv_ini.fnv_profile_string("PowerTool","ErrorLogDir","c:") + "\" +  is_file_name
else
	ib_ModeDebug = false
end if
end event

on nv_trace.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nv_trace.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

