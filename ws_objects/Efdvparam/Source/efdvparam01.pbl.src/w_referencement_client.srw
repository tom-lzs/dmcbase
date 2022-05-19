$PBExportHeader$w_referencement_client.srw
forward
global type w_referencement_client from w_a_udim_su
end type
type cb_fermer from u_cba within w_referencement_client
end type
type cb_1 from u_cba within w_referencement_client
end type
type cb_2 from u_cba within w_referencement_client
end type
type pb_filtre_article from picturebutton within w_referencement_client
end type
type pb_filtre_client from picturebutton within w_referencement_client
end type
type pb_filtre_enseigne from picturebutton within w_referencement_client
end type
type dw_2 from u_dw_udim within w_referencement_client
end type
end forward

global type w_referencement_client from w_a_udim_su
integer width = 3648
integer height = 2256
string title = "Référencement client"
windowstate windowstate = maximized!
long backcolor = 12632256
cb_fermer cb_fermer
cb_1 cb_1
cb_2 cb_2
pb_filtre_article pb_filtre_article
pb_filtre_client pb_filtre_client
pb_filtre_enseigne pb_filtre_enseigne
dw_2 dw_2
end type
global w_referencement_client w_referencement_client

on w_referencement_client.create
int iCurrent
call super::create
this.cb_fermer=create cb_fermer
this.cb_1=create cb_1
this.cb_2=create cb_2
this.pb_filtre_article=create pb_filtre_article
this.pb_filtre_client=create pb_filtre_client
this.pb_filtre_enseigne=create pb_filtre_enseigne
this.dw_2=create dw_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_fermer
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.pb_filtre_article
this.Control[iCurrent+5]=this.pb_filtre_client
this.Control[iCurrent+6]=this.pb_filtre_enseigne
this.Control[iCurrent+7]=this.dw_2
end on

on w_referencement_client.destroy
call super::destroy
destroy(this.cb_fermer)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.pb_filtre_article)
destroy(this.pb_filtre_client)
destroy(this.pb_filtre_enseigne)
destroy(this.dw_2)
end on

event ue_init;call super::ue_init;
//  Chargement des données de la table des intitulés

dw_1.Retrieve()
dw_1.insertRow(0)


end event

event ue_print;open (w_select_impression)
end event

event ue_presave;call super::ue_presave;// controle existence du code client

datastore ds_data
long ll_row 

dw_1.accepttext( )
ds_data = create datastore

ll_row = dw_1.getrow()
// controle existence du code enseigne
if len(trim(dw_1.getitemstring(ll_row,1))) > 0 then
	  ds_data.dataobject = "d_controle_enseigne"
	  ds_data.settrans( i_tr_sql)
	  ds_data.retrieve (dw_1.getitemstring(ll_row,1))
	  if ds_data.rowcount() < 1 then
		messagebox(this.title,"Enseigne inexistante : " +dw_1.getitemstring(ll_row,1),	StopSign!,Ok!,1)
		dw_1.setcolumn(1)
		Message.ReturnValue = -1
		return
	 end if
end if

// controle existence du client
if len(trim(dw_1.getitemstring(ll_row,2))) > 0 then
	  ds_data.dataobject = "d_controle_client"
	  ds_data.settrans( i_tr_sql)
	  ds_data.retrieve (dw_1.getitemstring(ll_row,2))
	  if ds_data.rowcount() < 1 then
		messagebox(this.title,"Client inexistant : " +dw_1.getitemstring(ll_row,2),	StopSign!,Ok!,1)
		dw_1.setcolumn( 2)
		Message.ReturnValue = -1
		return
	 end if
end if
	
// controle saisie de l'article
 if len(trim(dw_1.getitemstring(ll_row,3))) = 0 then
	messagebox(this.title,"Article obligatoire",	StopSign!,Ok!,1)
	dw_1.setcolumn(3)
	Message.ReturnValue = -1	
	 return
end if
	
ds_data.dataobject = "d_controle_article"
ds_data.settrans( i_tr_sql)
ds_data.retrieve (dw_1.getitemstring(ll_row,3))
if ds_data.rowcount() < 1 then
	 messagebox(this.title,"Article inexistant : " + dw_1.getitemstring(ll_row,3),	StopSign!,Ok!,1)
	dw_1.setcolumn(3)	 
     Message.ReturnValue = -1	 
	 return
end if

ds_data.dataobject = "d_controle_reference"
ds_data.settrans( i_tr_sql)
ds_data.retrieve (dw_1.getitemstring(ll_row,3),dw_1.getitemstring(ll_row,4))
if ds_data.rowcount() < 1 then
   messagebox(this.title,"Reference inexistante : " + dw_1.getitemstring(ll_row,3) + " - " + dw_1.getitemstring(ll_row,4),	StopSign!,Ok!,1)
	dw_1.setcolumn(3)	
   Message.ReturnValue = -1			 
   return
end if
end event

event ue_delete;long l_row

IF dw_1.fu_get_selected_count() = 0 THEN
	messagebox (this.title, "Vous devez sélectionner au moins une ligne", Information!,Ok!,1)
	dw_1.SetFocus ()
	RETURN
END IF

l_row = dw_1.GetSelectedRow (0)
DO WHILE l_row > 0
	dw_1.DeleteRow (l_row)
	l_row = dw_1.GetSelectedRow (0)
LOOP	

dw_1.update( )

If dw_1.rowcount( ) = 0 then
	dw_1.insertrow( 0)
end if
end event

event ue_search;call super::ue_search;string ls_Filename, named

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
									    + ls_Filename, named, "DOC", &
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

ds_data = create datastore
ds_data.dataobject = "d_controle_edi"
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

event ue_paste;call super::ue_paste;string ls_copie,ls_value ,ls_liste_client, ls_liste_ref
integer pos_cr
integer pos_tab
integer li_column
integer li_indice

datastore ds_data
ds_data = create datastore

dw_2.settrans (i_tr_sql)
dw_2.insertrow( 0)

// Ajout des lignes copiées dans le presse papier, dans la datastore de travail
ls_copie = Clipboard()
li_column = 1
for li_indice = 1 to len(ls_copie)
	if mid(ls_copie,li_indice,1) =  "~t" then
		dw_2.setitem( dw_2.rowcount(),li_column,ls_value)
		ls_value = ""
		li_column ++
		continue
	end if
	
	if mid(ls_copie,li_indice,1) = "~r" then
		dw_2.setitem( dw_2.rowcount(),li_column,ls_value)
		li_column = 1
		dw_2.insertrow( 0)
		ls_value = ""
		continue
	end if	
	
	if mid(ls_copie,li_indice,1) = "~n" then
		continue
	end if	
	
	ls_value = ls_value + mid(ls_copie,li_indice,1)
next


// controle du contenu de la datastore de travail
for li_indice = 1 to dw_2.rowcount( )
	if li_indice = dw_2.rowcount()  then
		exit
	end if
	
	// controle existence du code enseigne
	if len(trim(dw_2.getitemstring(li_indice,1))) > 0 then
		  ds_data.dataobject = "d_controle_enseigne"
           ds_data.settrans( i_tr_sql)
           ds_data.retrieve (dw_2.getitemstring(li_indice,1))
		  if ds_data.rowcount() < 1 then
			messagebox(this.title,"Enseigne inexistante : " + dw_2.getitemstring(li_indice,1) + " : corriger la ligne et refaite le copie",	StopSign!,Ok!,1)
			return
		 end if
	end if
	
	// controle existence du client
	if len(trim(dw_2.getitemstring(li_indice,2))) > 0 then
		  ds_data.dataobject = "d_controle_client"
           ds_data.settrans( i_tr_sql)
           ds_data.retrieve (dw_2.getitemstring(li_indice,2))
		  if ds_data.rowcount() < 1 then
			messagebox(this.title,"Client inexistant : " + dw_2.getitemstring(li_indice,2) + " : corriger la ligne et refaite le copie",	StopSign!,Ok!,1)
			return
		 end if
	end if
	
	// controle saisie de l'article
    if len(trim(dw_2.getitemstring(li_indice,3))) = 0 then
	   messagebox(this.title,"Article manquant sur la ligne " + string(li_indice) + " : corriger la ligne et refaite le copie",	StopSign!,Ok!,1)
       return
	end if
	
	  ds_data.dataobject = "d_controle_article"
	  ds_data.settrans( i_tr_sql)
	  ds_data.retrieve (dw_2.getitemstring(li_indice,3))
  	  if ds_data.rowcount() < 1 then
	       messagebox(this.title,"Article inexistant : " + dw_2.getitemstring(li_indice,3) + " : corriger la ligne et refaite le copie",	StopSign!,Ok!,1)
	       return
      end if

       ds_data.dataobject = "d_controle_reference"
	  ds_data.settrans( i_tr_sql)
	  ds_data.retrieve (dw_2.getitemstring(li_indice,3),dw_2.getitemstring(li_indice,4))
  	  if ds_data.rowcount() < 1 then
	       messagebox(this.title,"Reference inexistante : " + dw_2.getitemstring(li_indice,3) + " - " + dw_2.getitemstring(li_indice,4)+ " : corriger la ligne et refaite le copie",	StopSign!,Ok!,1)
	       return
      end if
next

dw_2.update()
dw_1.retrieve( )

end event

type dw_1 from w_a_udim_su`dw_1 within w_referencement_client
integer x = 238
integer y = 136
integer width = 2263
integer height = 1840
string dataobject = "d_referencement_client"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event dw_1::we_dwnprocessenter;call super::we_dwnprocessenter;IF  Trim(dw_1.Getitemstring(dw_1.getRow(),"artae000")) = "" and &
     Trim(dw_1.Getitemstring(dw_1.getRow(),"katr6")) = "" and  &
    Trim(dw_1.Getitemstring(dw_1.getRow(),"numaeclf")) = ""  and &
	Trim(dw_1.Getitemstring(dw_1.getRow(),"dimaeart")) = "" then 
	return 1
end if

If dw_1.GetColumnName () <> "dimaeart"  then
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

type uo_statusbar from w_a_udim_su`uo_statusbar within w_referencement_client
end type

type cb_fermer from u_cba within w_referencement_client
integer x = 507
integer y = 2000
integer width = 352
integer height = 96
integer taborder = 31
boolean bringtotop = true
string text = "&Fermer"
end type

event constructor;call super::constructor;i_s_event = "ue_cancel"
end event

type cb_1 from u_cba within w_referencement_client
integer x = 1115
integer y = 2000
integer width = 421
integer height = 96
integer taborder = 41
boolean bringtotop = true
string text = "&Coller"
end type

event constructor;call super::constructor;i_s_event = "ue_paste"
end event

type cb_2 from u_cba within w_referencement_client
integer x = 1696
integer y = 2000
integer width = 425
integer height = 96
integer taborder = 10
boolean bringtotop = true
string text = "&Suppression"
end type

event constructor;call super::constructor;i_s_event = "ue_delete"
end event

type pb_filtre_article from picturebutton within w_referencement_client
integer x = 1344
integer y = 168
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
boolean originalsize = true
string picturename = "Find!"
alignment htextalign = left!
end type

event clicked;str_pass l_str_work

l_str_work.s[1] = "article"
openwithparm(w_critere_recherche,l_str_work )
l_str_work = Message.fnv_get_str_pass()
Message.fnv_clear_str_pass()


if l_str_work.s_action = ACTION_CANCEL then
	dw_1.setFilter("")
	dw_1.Filter( )
	return
end if

dw_1.setFilter("artae000" +" = '" +l_str_work.s[1] + "'")
dw_1.Filter( )

end event

type pb_filtre_client from picturebutton within w_referencement_client
integer x = 910
integer y = 168
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
string picturename = "Find!"
alignment htextalign = left!
end type

event clicked;str_pass l_str_work

l_str_work.s[1] = "client"
openwithparm(w_critere_recherche,l_str_work )
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

type pb_filtre_enseigne from picturebutton within w_referencement_client
integer x = 517
integer y = 172
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
string picturename = "Find!"
alignment htextalign = left!
end type

event clicked;str_pass l_str_work

l_str_work.s[1] = "enseigne"
openwithparm(w_critere_recherche,l_str_work )
l_str_work = Message.fnv_get_str_pass()
Message.fnv_clear_str_pass()


if l_str_work.s_action = ACTION_CANCEL then
	dw_1.setFilter("")
	dw_1.Filter( )
	return
end if

dw_1.setFilter("katr6" +" = '" +l_str_work.s[1] + "'")
dw_1.Filter( )

end event

type dw_2 from u_dw_udim within w_referencement_client
boolean visible = false
integer x = 2533
integer y = 288
integer height = 420
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_referencement_client"
end type

