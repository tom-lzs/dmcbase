$PBExportHeader$w_gestion_come9clt_alerte.srw
forward
global type w_gestion_come9clt_alerte from w_a_udim_su
end type
type cb_fermer from u_cba within w_gestion_come9clt_alerte
end type
type cb_1 from u_cba within w_gestion_come9clt_alerte
end type
type cb_2 from u_cba within w_gestion_come9clt_alerte
end type
type pb_filtre_alerte from picturebutton within w_gestion_come9clt_alerte
end type
type pb_filtre_client from picturebutton within w_gestion_come9clt_alerte
end type
end forward

global type w_gestion_come9clt_alerte from w_a_udim_su
integer width = 2665
integer height = 2016
string title = "Gestion des alertes clients"
windowstate windowstate = maximized!
long backcolor = 12632256
cb_fermer cb_fermer
cb_1 cb_1
cb_2 cb_2
pb_filtre_alerte pb_filtre_alerte
pb_filtre_client pb_filtre_client
end type
global w_gestion_come9clt_alerte w_gestion_come9clt_alerte

on w_gestion_come9clt_alerte.create
int iCurrent
call super::create
this.cb_fermer=create cb_fermer
this.cb_1=create cb_1
this.cb_2=create cb_2
this.pb_filtre_alerte=create pb_filtre_alerte
this.pb_filtre_client=create pb_filtre_client
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_fermer
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.pb_filtre_alerte
this.Control[iCurrent+5]=this.pb_filtre_client
end on

on w_gestion_come9clt_alerte.destroy
call super::destroy
destroy(this.cb_fermer)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.pb_filtre_alerte)
destroy(this.pb_filtre_client)
end on

event ue_init;call super::ue_init;
//  Chargement des données de la table des intitulés

dw_1.Retrieve()

if dw_1.RowCount() = 0 then
	dw_1.insertRow(0)
end if

end event

event ue_print;open (w_select_impression)
end event

event ue_presave;call super::ue_presave;// controle existence du code client

datastore ds_data
dw_1.accepttext( )
ds_data = create datastore
ds_data.dataobject = "d_controle_client"
ds_data.settrans( i_tr_sql)
ds_data.retrieve (dw_1.getitemstring(dw_1.getrow(),"numaeclf"))

if ds_data.rowcount() < 1 then
	MessageBox (This.title,"Client " + dw_1.getitemstring(dw_1.getrow(),"numaeclf") + " inexistant :"  ,StopSign!,Ok!,1)
	dw_1.SetColumn ("numaeclf")
  	dw_1.SetFocus ()
	Message.ReturnValue = -1
	RETURN	
end if

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

event ue_search;call super::ue_search;string ls_Filename, named[]

integer value
integer li_FileNum
integer li_return
String ls_enreg
Long ll_row
datastore ds_data, ds_controle
String ls_client_en_erreur
boolean lb_erreur
str_pass l_str_work

value = GetFileOpenName("Select File", &
									    + ls_Filename, named[], "DOC", &
   										+ "Text Files (*.csv),*.csv,")
IF value <> 1 THEN
	return
end if

li_FileNum =FileOpen(ls_Filename, LineMode!)
li_return = FileRead(li_FileNum,ls_enreg)

if li_return = -100 then 
	Fileclose(li_FileNum)
	MessageBox (This.title,"Le fichier sélectionné est vide " ,Information!,Ok!,1)
	return
end if

openwithparm (w_import_alerte,l_str_work)
l_str_work = Message.fnv_get_str_pass()
Message.fnv_clear_str_pass()

if l_str_work.s_action = ACTION_CANCEL then
	return
end if

ds_data = create datastore
ds_data.dataobject = "d_come9clt_alerte"
ds_data.settrans (i_tr_sql)
ds_data.retrieve()
do 
	//*  Controle du n° de client
	//         Doit être existant
	//         Controle doublon
	ds_controle = create datastore
	ds_controle.dataobject = "d_controle_client"
	ds_controle.settrans( i_tr_sql)
	ds_controle.retrieve (ls_enreg)
	
	if ds_controle.rowcount() < 1 then
		ls_client_en_erreur = ls_client_en_erreur + ls_enreg + " / "
		lb_erreur = true
		li_return = FileRead(li_FileNum,ls_enreg)
		continue
	end if
	
	ll_row = ds_data.Find("numaeclf = '" + ls_enreg + "'",1,ds_data.RowCount())
	if ll_row = 0 then
		ll_row = ds_data.InsertRow(0)
		ds_data.setitem(ll_row,"numaeclf",trim(ls_enreg))
	end if

	ds_data.setitem(ll_row,"alerte",trim(l_str_work.s[1]))
	ds_data.setitem(ll_row,"timefcre" ,i_tr_sql.fnv_get_datetime( )  )
	ds_data.setitem(ll_row,"codeemaj" ,'C' )
	li_return = FileRead(li_FileNum,ls_enreg)
loop while li_return >= 0

ds_data.Update()
dw_1.retrieve()

MessageBox (This.title,"Import du fichier terminé " ,Information!,Ok!,1)

if lb_erreur then
    MessageBox (This.title,"Des clients sont inexistants : " + ls_client_en_erreur ,StopSign!,Ok!,1)
end if

Fileclose(li_FileNum)

end event

type dw_1 from w_a_udim_su`dw_1 within w_gestion_come9clt_alerte
integer x = 215
integer y = 128
integer width = 2144
integer height = 1608
string dataobject = "d_come9clt_alerte"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event dw_1::we_dwnprocessenter;call super::we_dwnprocessenter;IF  Trim(dw_1.Getitemstring(dw_1.getRow(),"numaeclf")) = "" then
	return 1
end if

If dw_1.GetColumnName () <> "alerte"  then
	Send(Handle(This),256,9,Long(0,0))
	Return 1
End if

parent.triggerEvent("ue_save")
if not i_b_update_status  then
	return 1
end if

dw_1.fu_insert (0)
dw_1.setColumn(1)


end event

event dw_1::we_dwnkey;call super::we_dwnkey;// SELECTION DE LA LIGNE EN COURS
	IF KeyDown(KeyF5!) THEN
		SelectRow(GetRow(),TRUE)
	END IF

// DESELECTION DE LA LIGNE EN COURS
	IF KeyDown(KeyF6!) THEN
		SelectRow(GetRow(),FALSE)
	END IF

end event

type uo_statusbar from w_a_udim_su`uo_statusbar within w_gestion_come9clt_alerte
end type

type cb_fermer from u_cba within w_gestion_come9clt_alerte
integer x = 512
integer y = 1792
integer width = 352
integer height = 96
integer taborder = 31
boolean bringtotop = true
string text = "&Fermer"
end type

event constructor;call super::constructor;i_s_event = "ue_cancel"
end event

type cb_1 from u_cba within w_gestion_come9clt_alerte
integer x = 1120
integer y = 1792
integer width = 421
integer height = 96
integer taborder = 41
boolean bringtotop = true
string text = "&Importer"
end type

event constructor;call super::constructor;i_s_event = "ue_search"
end event

type cb_2 from u_cba within w_gestion_come9clt_alerte
integer x = 1701
integer y = 1792
integer width = 425
integer height = 96
integer taborder = 10
boolean bringtotop = true
string text = "&Suppression"
end type

event constructor;call super::constructor;i_s_event = "ue_delete"
end event

type pb_filtre_alerte from picturebutton within w_gestion_come9clt_alerte
integer x = 1614
integer y = 136
integer width = 110
integer height = 96
integer taborder = 11
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "none"
boolean originalsize = true
string picturename = "Find!"
alignment htextalign = left!
end type

event clicked;str_pass l_str_work

openwithparm(w_import_alerte,l_str_work )
l_str_work = Message.fnv_get_str_pass()
Message.fnv_clear_str_pass()


if l_str_work.s_action = ACTION_CANCEL then
	dw_1.setFilter("")
	dw_1.Filter( )
	return
end if

dw_1.setFilter("alerte" +" = '" +l_str_work.s[1] + "'")
dw_1.Filter( )

end event

type pb_filtre_client from picturebutton within w_gestion_come9clt_alerte
integer x = 590
integer y = 136
integer width = 101
integer height = 88
integer taborder = 21
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "none"
string picturename = "Find!"
alignment htextalign = left!
end type

event clicked;str_pass l_str_work

openwithparm(w_select_client,l_str_work )
l_str_work = Message.fnv_get_str_pass()
Message.fnv_clear_str_pass()


if l_str_work.s_action = ACTION_CANCEL then
	dw_1.setFilter("")
	dw_1.Filter( )
	return
end if

dw_1.setFilter("numaeclf" +" = '" +l_str_work.s[1] + "'")
dw_1.Filter( )

end event

