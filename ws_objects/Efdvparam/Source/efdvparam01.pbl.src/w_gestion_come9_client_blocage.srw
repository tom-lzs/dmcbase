$PBExportHeader$w_gestion_come9_client_blocage.srw
forward
global type w_gestion_come9_client_blocage from w_a_udim_su
end type
type cb_fermer from u_cba within w_gestion_come9_client_blocage
end type
type cb_2 from u_cba within w_gestion_come9_client_blocage
end type
end forward

global type w_gestion_come9_client_blocage from w_a_udim_su
integer x = 769
integer y = 461
integer width = 2327
integer height = 2016
string title = "Gestion des blocages clients"
windowstate windowstate = maximized!
long backcolor = 12632256
event ue_listes ( )
cb_fermer cb_fermer
cb_2 cb_2
end type
global w_gestion_come9_client_blocage w_gestion_come9_client_blocage

event ue_listes();/* <DESC>
   Permet d'afficher la liste correspondante a la zone selectionnee pour permettre la selection d'une valeur
	</DESC> */

String		s_colonne
String 		s_code_colonne
Str_pass		str_work
nv_list_manager s_nv_liste_manager
s_nv_liste_manager = CREATE nv_list_manager

s_colonne = dw_1.GetColumnName()	
if s_colonne <> DBNAME_BLOCAGE_CDE then
	return
end if

str_work.s[1] = s_colonne
str_work.s[3] = dw_1.getItemString(1,DBNAME_BLOCAGE_CDE)
str_work = s_nv_liste_manager.get_list_of_column(str_work)
	
// cette action provient de la fenetre de selection appelée
// prédemment - click sur cancel
if str_work.s_action =  ACTION_CANCEL then
	return
end if

// Mise à jour de la datawindow correspondante à la liste selectionnee
dw_1.SetItem (dw_1.getRow(), s_colonne, str_work.s[1])
destroy s_nv_liste_manager
end event

on w_gestion_come9_client_blocage.create
int iCurrent
call super::create
this.cb_fermer=create cb_fermer
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_fermer
this.Control[iCurrent+2]=this.cb_2
end on

on w_gestion_come9_client_blocage.destroy
call super::destroy
destroy(this.cb_fermer)
destroy(this.cb_2)
end on

event ue_init;call super::ue_init;dw_1.Retrieve()

if dw_1.RowCount() = 0 then
	dw_1.insertRow(0)
end if

end event

event ue_presave;call super::ue_presave;// controle existence du code client

datastore ds_data
Long ll_row
long ll_row_travail
String ls_client

dw_1.accepttext( )
ds_data = create datastore
ds_data.dataobject = "d_controle_client"
ds_data.settrans( i_tr_sql)
ds_data.retrieve (dw_1.getitemstring(dw_1.getrow(),"numaeclf"))

// controle existence du client
if ds_data.rowcount() < 1 then
	MessageBox (This.title,"Client " + dw_1.getitemstring(dw_1.getrow(),"numaeclf") + " inexistant :"  ,StopSign!,Ok!,1)
	dw_1.SetColumn ("numaeclf")
  	dw_1.SetFocus ()
	Message.ReturnValue = -1
	RETURN	
end if

// controle existence du code blocage
ds_data.dataobject = "d_controle_blocage"
ds_data.settrans( i_tr_sql)
ds_data.retrieve (dw_1.getitemstring(dw_1.getrow(),"cblaesap"))
if ds_data.rowcount() < 1 then
	MessageBox (This.title,"Code Blocage " + dw_1.getitemstring(dw_1.getrow(),"numaeclf") + " déjà existant :"  ,StopSign!,Ok!,1)
	dw_1.SetColumn ("numaeclf")
  	dw_1.SetFocus ()
	Message.ReturnValue = -1
	RETURN	
end if

// controle que le client n'a pas déjà été saisi
ll_row_travail  = dw_1.getrow()
ls_client =  dw_1.getitemstring(dw_1.getrow(),"numaeclf")

for ll_row = 1 to dw_1.Rowcount( )
	 if ll_row = ll_row_travail then
		continue
	 end if
	 
	 if  dw_1.getitemstring(ll_row,"numaeclf") = ls_client then
			MessageBox (This.title,"Blocage pour le Client " + dw_1.getitemstring(dw_1.getrow(),"numaeclf") + " déjà existant :"  ,StopSign!,Ok!,1)
		  	dw_1.SetColumn ("numaeclf")
  			dw_1.SetFocus ()
			Message.ReturnValue = -1
			RETURN		
	 end if 
next


dw_1.setitem(dw_1.getrow(),"timefcre",i_tr_sql.fnv_get_datetime( ))
dw_1.setitem(dw_1.getrow(),"codeemaj",'C')
end event

event ue_delete;IF dw_1.fu_get_selected_count() = 0 THEN
	messagebox (this.title, "Vous devez sélectionner au moins une ligne", Information!,Ok!,1)
	dw_1.SetFocus ()
	RETURN
END IF
 
// SUPPRESSION DES  ENREGISTREMENTS
dw_1.deleterow( dw_1.GetSelectedRow (0))
dw_1.update()
if dw_1.rowcount() = 0 then
	dw_1.insertrow(0)
end if
end event

event key;call super::key;	IF KeyDown (KeyF2!) THEN
		This.PostEvent ("ue_listes")
	END IF
end event

type dw_1 from w_a_udim_su`dw_1 within w_gestion_come9_client_blocage
integer x = 215
integer y = 128
integer width = 1655
integer height = 1608
string dataobject = "d_come9_client_blocage"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event dw_1::we_dwnprocessenter;call super::we_dwnprocessenter;IF  Trim(dw_1.Getitemstring(dw_1.getRow(),"numaeclf")) = "" then
	return 1
end if

If dw_1.GetColumnName () <> "cblaesap"  then
	Send(Handle(This),256,9,Long(0,0))
	Return 1
End if

parent.triggerEvent("ue_save")
if not i_b_update_status  then
	return 1
end if

dw_1.fu_insert (0)
dw_1.setColumn("numaeclf")


end event

event dw_1::we_dwnkey;call super::we_dwnkey;// SELECTION DE LA LIGNE EN COURS
	IF KeyDown(KeyF5!) THEN
		SelectRow(GetRow(),TRUE)
		return
	END IF

// DESELECTION DE LA LIGNE EN COURS
	IF KeyDown(KeyF6!) THEN
		SelectRow(GetRow(),FALSE)
		return
	END IF
	
	
	parent.triggerEvent("key")

end event

type uo_statusbar from w_a_udim_su`uo_statusbar within w_gestion_come9_client_blocage
end type

type cb_fermer from u_cba within w_gestion_come9_client_blocage
integer x = 539
integer y = 1792
integer width = 352
integer height = 96
integer taborder = 31
boolean bringtotop = true
string text = "&Fermer"
end type

event constructor;call super::constructor;i_s_event = "ue_cancel"
end event

type cb_2 from u_cba within w_gestion_come9_client_blocage
integer x = 1106
integer y = 1792
integer width = 425
integer height = 96
integer taborder = 10
boolean bringtotop = true
string text = "&Suppression"
end type

event constructor;call super::constructor;i_s_event = "ue_delete"
end event

