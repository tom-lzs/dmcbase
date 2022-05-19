$PBExportHeader$w_suivi_visite.srw
forward
global type w_suivi_visite from w_a_udim_su
end type
type st_dtevis from statictext within w_suivi_visite
end type
type em_date_visite from u_ema_pt within w_suivi_visite
end type
type pb_validation_suivi from u_pba within w_suivi_visite
end type
type pb_supprim from u_pba_supprim within w_suivi_visite
end type
type pb_echap from u_pba_echap within w_suivi_visite
end type
type pb_impression from u_pba within w_suivi_visite
end type
type em_date_deb from u_ema_pt within w_suivi_visite
end type
type em_date_fin from u_ema_pt within w_suivi_visite
end type
type st_du from statictext within w_suivi_visite
end type
type st_au from statictext within w_suivi_visite
end type
type st_impression_dte_visite from statictext within w_suivi_visite
end type
type st_maj_date_visite from statictext within w_suivi_visite
end type
type pb_consult from u_pba within w_suivi_visite
end type
type dw_km from u_dw_udis within w_suivi_visite
end type
type pb_km from u_pba within w_suivi_visite
end type
type st_kilometrage from statictext within w_suivi_visite
end type
type em_kilometre from u_ema_pt within w_suivi_visite
end type
type r_1 from rectangle within w_suivi_visite
end type
type r_2 from rectangle within w_suivi_visite
end type
type r_3 from rectangle within w_suivi_visite
end type
end forward

global type w_suivi_visite from w_a_udim_su
integer width = 6277
integer height = 3284
string title = "Suivi des visites clients"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
long backcolor = 12632256
boolean ib_a_traduire = true
boolean ib_statusbar_visible = true
event ue_change_km ( )
st_dtevis st_dtevis
em_date_visite em_date_visite
pb_validation_suivi pb_validation_suivi
pb_supprim pb_supprim
pb_echap pb_echap
pb_impression pb_impression
em_date_deb em_date_deb
em_date_fin em_date_fin
st_du st_du
st_au st_au
st_impression_dte_visite st_impression_dte_visite
st_maj_date_visite st_maj_date_visite
pb_consult pb_consult
dw_km dw_km
pb_km pb_km
st_kilometrage st_kilometrage
em_kilometre em_kilometre
r_1 r_1
r_2 r_2
r_3 r_3
end type
global w_suivi_visite w_suivi_visite

type variables
boolean i_b_erreur_sur_ligne
end variables

event ue_change_km();long l_row

if em_kilometre.text ="0" or isnull(em_kilometre.text) or em_kilometre.text = ""  then
	return
end if

if dw_km.rowcount()= 0 then
	l_row = dw_km.insertrow(0)
end if

dw_km.setitem(l_row,"timefcre",i_tr_sql.fnv_get_datetime( ))
dw_km.setitem(l_row,"codeemaj","C")
dw_km.setitem(l_row,"codeevis", g_s_visiteur)
dw_km.setitem(l_row,"dataevis",date(em_date_visite.text))
dw_km.setitem(l_row,"numaecpt",999)

dw_km.SetItem(l_row,"numaeclf","")
dw_km.SetItem(l_row,"nomaeclt","")
dw_km.setitem(l_row,"prospect","N")
dw_km.SetItem(l_row,"ville","")
dw_km.SetItem(l_row,"dept","")
dw_km.setitem(l_row,"objectif","")
dw_km.setitem(l_row,"visiter","N")
dw_km.setitem(l_row,"commande","N")
dw_km.setitem(l_row,"montant",0)
dw_km.setitem(l_row,"resultat","")
dw_km.setitem(l_row,"kilometre",integer(em_kilometre.text))





dw_km.fu_update ()





end event

on w_suivi_visite.create
int iCurrent
call super::create
this.st_dtevis=create st_dtevis
this.em_date_visite=create em_date_visite
this.pb_validation_suivi=create pb_validation_suivi
this.pb_supprim=create pb_supprim
this.pb_echap=create pb_echap
this.pb_impression=create pb_impression
this.em_date_deb=create em_date_deb
this.em_date_fin=create em_date_fin
this.st_du=create st_du
this.st_au=create st_au
this.st_impression_dte_visite=create st_impression_dte_visite
this.st_maj_date_visite=create st_maj_date_visite
this.pb_consult=create pb_consult
this.dw_km=create dw_km
this.pb_km=create pb_km
this.st_kilometrage=create st_kilometrage
this.em_kilometre=create em_kilometre
this.r_1=create r_1
this.r_2=create r_2
this.r_3=create r_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_dtevis
this.Control[iCurrent+2]=this.em_date_visite
this.Control[iCurrent+3]=this.pb_validation_suivi
this.Control[iCurrent+4]=this.pb_supprim
this.Control[iCurrent+5]=this.pb_echap
this.Control[iCurrent+6]=this.pb_impression
this.Control[iCurrent+7]=this.em_date_deb
this.Control[iCurrent+8]=this.em_date_fin
this.Control[iCurrent+9]=this.st_du
this.Control[iCurrent+10]=this.st_au
this.Control[iCurrent+11]=this.st_impression_dte_visite
this.Control[iCurrent+12]=this.st_maj_date_visite
this.Control[iCurrent+13]=this.pb_consult
this.Control[iCurrent+14]=this.dw_km
this.Control[iCurrent+15]=this.pb_km
this.Control[iCurrent+16]=this.st_kilometrage
this.Control[iCurrent+17]=this.em_kilometre
this.Control[iCurrent+18]=this.r_1
this.Control[iCurrent+19]=this.r_2
this.Control[iCurrent+20]=this.r_3
end on

on w_suivi_visite.destroy
call super::destroy
destroy(this.st_dtevis)
destroy(this.em_date_visite)
destroy(this.pb_validation_suivi)
destroy(this.pb_supprim)
destroy(this.pb_echap)
destroy(this.pb_impression)
destroy(this.em_date_deb)
destroy(this.em_date_fin)
destroy(this.st_du)
destroy(this.st_au)
destroy(this.st_impression_dte_visite)
destroy(this.st_maj_date_visite)
destroy(this.pb_consult)
destroy(this.dw_km)
destroy(this.pb_km)
destroy(this.st_kilometrage)
destroy(this.em_kilometre)
destroy(this.r_1)
destroy(this.r_2)
destroy(this.r_3)
end on

event ue_retrieve;call super::ue_retrieve;If  em_date_visite.Text = ""  or em_date_visite.Text = "00/00/0000" then
	messageBox ("Controle","Date de visite obligatoire",stopsign!)
	em_date_visite.SetFocus()
	return
end if
dw_1.dataobject = "d_compte_rendu_visite"
dw_1.setTransObject (sqlca)
dw_1.retrieve (g_s_visiteur, date(em_date_visite.text))
dw_1.insertrow(0)
dw_1.setfocus()
pb_supprim.visible = true
pb_impression.visible = false

dw_km.setTransObject (sqlca)
dw_km.retrieve(g_s_visiteur, date(em_date_visite.text))
if dw_km.rowcount( ) = 0 then
	em_kilometre.text = string(0)
else
	em_kilometre.text = String( dw_km.getitemnumber(1,"kilometre"))
end if
end event

event ue_presave;call super::ue_presave;long l_row 
String ls_client

l_row = dw_1.fu_get_itemchanged_row_num ()

// controle existence du client, si code renseigné

if not isnull(dw_1.getitemstring(l_row,"numaeclf")) then
         nv_client_object lu_client
		lu_client = create  nv_client_object
          if not lu_client.fu_retrieve_client( dw_1.getitemstring(l_row,"numaeclf") ) then
			   messageBox ("Controle","Code client inexistant ",stopsign!)
	           dw_1.SetFocus()
			   destroy lu_client
                Message.ReturnValue = -1
	            RETURN
		end if
		dw_1.SetItem(l_row,"nomaeclt",lu_client.fu_get_abrege_nom( ))
		dw_1.SetItem(l_row,"ville",lu_client.fu_get_abrege_ville( ))
		dw_1.SetItem(l_row,"dept",mid(lu_client.fu_get_codepostal(),1,2))
		destroy lu_client
	else
		
		if isnull(dw_1.Getitemstring(l_row,"nomaeclt")) then
			    messageBox ("Controle","nom client obligatoire ",stopsign!)
				dw_1.setcolumn( "nomaeclt")							
	             dw_1.SetFocus()
                 Message.ReturnValue = -1
	            RETURN
		end if
		
		if isnull(dw_1.Getitemstring(l_row,"ville")) then
			   messageBox ("Controle","ville obligatoire ",stopsign!)
				dw_1.setcolumn( "ville")				
	            dw_1.SetFocus()
                Message.ReturnValue = -1
	            RETURN
		end if
		
		if isnull(dw_1.Getitemstring(l_row,"dept")) then
			   messageBox ("Controle","departement obligatoire ",stopsign!)
				dw_1.setcolumn( "dept")
	            dw_1.SetFocus()
                Message.ReturnValue = -1
	            RETURN
		end if
end if

if isnull(dw_1.Getitemstring(l_row,"objectif")) then
			   messageBox ("Controle","objectif obligatoire ",stopsign!)
				dw_1.setcolumn( "objectif")
	            dw_1.SetFocus()
                Message.ReturnValue = -1
	            RETURN
end if

if dw_1.getitemstring(l_row,"visiter") = "O" and isnull(dw_1.getitemstring(l_row,"resultat")) then
				messageBox ("Controle","résultat de la visite  obligatoire ",stopsign!)
				dw_1.setcolumn( "resultat")
	            dw_1.SetFocus()
                Message.ReturnValue = -1
	            RETURN
end if

if dw_1.getitemstring(l_row,"commande") = "O" and isnull(dw_1.getitemdecimal(l_row,"montant")) then
				messageBox ("Controle","montant commandé  obligatoire ",stopsign!)
				dw_1.setcolumn( "montant")
	            dw_1.SetFocus()
                Message.ReturnValue = -1
	            RETURN
end if

if isnull(dw_1.getitemdatetime( l_row,"dataevis")) then
	dw_1.setitem(l_row,"dataevis",date(em_date_visite.text))
end if

dw_1.setitem(l_row,"codeemaj","C")
 
if not isnull(dw_1.getitemstring(l_row,"codeevis") )  then
       dw_1.setitem(l_row,"codeemaj","M")
end if

ls_client = dw_1.getitemstring(l_row,"numaeclf")
if dw_1.getitemstring(l_row,"prospect") = "N"  and  isnull(dw_1.getitemstring(l_row,"numaeclf"))  then
	       dw_1.setitem(l_row,"prospect","O")
end if

if  dw_1.getitemstring(l_row,"prospect") = "O" and not  isnull(dw_1.getitemstring(l_row,"numaeclf"))  then
	       dw_1.setitem(l_row,"prospect","N")
end if

if isnull(dw_1.getitemstring(l_row,"commande")) then
	       dw_1.setitem(l_row,"commande","N")
		   dw_1.setitem(l_row,"montant","")
end if
if isnull(dw_1.getitemstring(l_row,"visiter")) then
	       dw_1.setitem(l_row,"visiter","N")
end if


dw_1.setitem(l_row,"codeevis", g_s_visiteur)
dw_1.setitem(l_row,"timefcre",i_tr_sql.fnv_get_datetime( ))




end event

event ue_init;call super::ue_init;em_date_visite.text = string(today())
triggerevent("ue_retrieve")
	i_str_pass.b[1]				=  true

end event

event ue_delete;/* <DESC>
     Permet de supprimer les lignes de commande sélectionnées et de revaloriser la commande.
   </DESC> */
// OVERRIDE SCRIPT ANCESTOR

// DECLARATION DES VARIABLES LOCALES
Long	l_row,			&
		l_nb_select

// CONTROLE NBR DE LIGNES SELECTIONNEES
l_nb_select = dw_1.fu_get_selected_count ()
IF l_nb_select = 0 THEN
	messagebox (This.title, g_nv_traduction.get_traduction(SELECTION_OBLIGATOIRE), Information!,Ok!,1)
	dw_1.SetFocus ()
	RETURN
END IF

// SUPPRESSION DE L'ENREGISTREMEN
dw_1.SetRow(1)
l_row = dw_1.GetSelectedRow (0)
DO WHILE l_row > 0
	dw_1.DeleteRow (l_row)
	l_row = dw_1.GetSelectedRow (0)
LOOP	

dw_1.Update ()

dw_1.SetFocus ()
if dw_1.rowCount() = 0 then
	dw_1.insertRow(0)
end if

end event

event ue_print;/* <DESC>
     Permet d'imprimer le bon de commande pour la commande sélectionnée
	  </DESC> */
// DECLARATION DES VARIABLES LOCALES
//Long		l_retrieve
//nv_datastore ds_datastore
//
//ds_datastore = create nv_datastore
//ds_datastore.dataobject = "d_compte_rendu_visite_semaine"
//ds_datastore.setTransObject (sqlca)
//
//if isnull(em_date_deb.text) or isnull(em_date_fin.text) then
//	  messageBox ("Controle","période obligatoire",stopsign!)
//end if
//
//
//l_retrieve = ds_datastore.Retrieve (g_s_visiteur, date(em_date_deb.text), date(em_date_fin.text))
//
//CHOOSE CASE l_retrieve
//	CASE -1
//		f_dmc_error (this.title + BLANK + ds_datastore.uf_getdberror( ) )
//	CASE 0
//	CASE ELSE
//		triggerEvent("ue_printsetup")
//		ds_datastore.print () 
//END CHOOSE
//
//destroy ds_datastore
//
//dw_1.dataobject = "d_compte_rendu_visite_semaine"
//dw_1.setTransObject (sqlca)
//l_retrieve = dw_1.Retrieve (g_s_visiteur, date(em_date_deb.text), date(em_date_fin.text))
//pb_supprim.visible = false
//

		triggerEvent("ue_printsetup")
		dw_1.print () 
end event

event ue_search;call super::ue_search;/* <DESC>
     Permet d'imprimer le bon de commande pour la commande sélectionnée
	  </DESC> */
// DECLARATION DES VARIABLES LOCALES
Long		l_retrieve
if isnull(em_date_deb.text) or isnull(em_date_fin.text) then
	  messageBox ("Controle","période obligatoire",stopsign!)
end if

dw_1.dataobject = "d_compte_rendu_visite_semaine"
dw_1.setTransObject (sqlca)
l_retrieve = dw_1.Retrieve (g_s_visiteur, date(em_date_deb.text), date(em_date_fin.text))
pb_supprim.visible = false
pb_impression.visible = true

end event

type uo_statusbar from w_a_udim_su`uo_statusbar within w_suivi_visite
end type

type dw_1 from w_a_udim_su`dw_1 within w_suivi_visite
integer x = 73
integer y = 724
integer width = 5618
integer height = 1828
string dataobject = "d_compte_rendu_visite"
boolean vscrollbar = true
end type

event dw_1::we_dwnprocessenter;call super::we_dwnprocessenter;
If dw_1.GetColumnName () <> "montant" then
	Send(Handle(This),256,9,Long(0,0))
	Return 1
End if

if fu_changed() then
	parent.triggerEvent("ue_save")
	if i_b_update_status then
		return 1
	end if
end if

IF dw_1.GetRow () < dw_1.RowCount() THEN
	Send(Handle(This),256,9,Long(0,0))
	dw_1.SetColumn (1)
	Return 1
END IF

dw_1.fu_insert (0)
dw_1.SetColumn (1)


end event

event dw_1::we_dwnkey;call super::we_dwnkey;/* <DESC> 
     Permet d'effectuer le traitement en fonction de la touche de fonction activée.
	F5 --> Sélection de la ligne positionnée
	F6 --> Déselection de la ligne sélectionnée
	F7 --> Sélection de toutes les lignes  
	F8 --> Désélectin de toutes les lignes sélectionnées
	F11 --> validation compléte de la saisie des lignes de commandes
	F1 --> Affichage du détail de la référence
	F2 -->  Recherche de référence
	Tabulation --> positionne sur le champ suivant
   </DESC> */
	
// SELECTION DE LA LIGNE EN COURS
// Si on se trouve en mode affichage ligne en anomalie, sélection de la ligne
// Si mode normal et que la ligne sélectionnée n'est pas la dernière , sélection de la ligne.
//             ( la dernière ligne est une ligne vide ou encours de création)
	IF KeyDown(KeyF5!) THEN
		if not i_str_pass.b[1] then
			if dw_1.getRow() < dw_1.RowCount()  then
 			  dw_1.SelectRow(dw_1.GetRow(),TRUE)
  		     end if
		else
 			  dw_1.SelectRow(dw_1.GetRow(),TRUE)			
		end if
	END IF

// DESELECTION DE LA LIGNE EN COURS
	IF KeyDown(KeyF6!) THEN
		dw_1.SelectRow(dw_1.GetRow(),FALSE)
	END IF

// SELECTION DE TOUTES LES LIGNES 
	IF KeyDown(KeyF7!) THEN
		dw_1.SelectRow(0,TRUE)
		if not i_str_pass.b[1] then
			dw_1.SelectRow(dw_1.RowCount(),FALSE)
		end if
	END IF

// DESELECTION DE TOUTES LES LIGNES
	IF KeyDown(KeyF8!) THEN
		dw_1.SelectRow(0,FALSE)
	END IF
end event

type st_dtevis from statictext within w_suivi_visite
integer x = 338
integer y = 260
integer width = 485
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 553648127
string text = "Date de la visite"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_date_visite from u_ema_pt within w_suivi_visite
integer x = 846
integer y = 240
integer width = 425
integer taborder = 10
boolean bringtotop = true
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type pb_validation_suivi from u_pba within w_suivi_visite
integer x = 1376
integer y = 228
integer width = 192
integer height = 128
integer taborder = 10
boolean bringtotop = true
string text = " "
string picturename = "C:\appscir\Erfvmr_diva\Image\pbok.bmp"
string disabledname = "C:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

event constructor;call super::constructor;	fu_setevent ("ue_retrieve")

	fu_set_microhelp ("Validation et sauvegarde des modifications")
this.text=""
end event

type pb_supprim from u_pba_supprim within w_suivi_visite
integer x = 2377
integer y = 2604
integer width = 402
integer height = 192
integer taborder = 11
boolean bringtotop = true
string picturename = "C:\appscir\Erfvmr_diva\Image\pb_suppr.bmp"
end type

type pb_echap from u_pba_echap within w_suivi_visite
integer x = 2981
integer y = 2604
integer width = 384
integer height = 188
integer taborder = 11
boolean bringtotop = true
string picturename = "C:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type pb_impression from u_pba within w_suivi_visite
boolean visible = false
integer x = 1979
integer y = 2616
integer width = 334
integer height = 168
integer taborder = 30
boolean bringtotop = true
string facename = "Arial"
string text = "&Impression"
string picturename = "C:\appscir\Erfvmr_diva\Image\PB_IMP.BMP"
end type

on constructor;call u_pba::constructor;
// ------------------------------------------------------
// DECLENCHEMENT DE L'EVENEMENT AU NIVEAU DE LA FENÊTRE
// ------------------------------------------------------
	fu_setevent ("ue_print")

// ------------------------------------------------------
// TEXTE DE LA MICROHELP
// ------------------------------------------------------
	fu_set_microhelp ("Impression du bon de commande")
end on

type em_date_deb from u_ema_pt within w_suivi_visite
integer x = 2734
integer y = 244
integer width = 425
integer taborder = 20
boolean bringtotop = true
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type em_date_fin from u_ema_pt within w_suivi_visite
integer x = 3360
integer y = 248
integer width = 425
integer taborder = 30
boolean bringtotop = true
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type st_du from statictext within w_suivi_visite
integer x = 2528
integer y = 260
integer width = 187
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 553648127
string text = "Du"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_au from statictext within w_suivi_visite
integer x = 3168
integer y = 256
integer width = 187
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 553648127
string text = "Au"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_impression_dte_visite from statictext within w_suivi_visite
integer x = 2683
integer y = 64
integer width = 1143
integer height = 80
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 553648127
string text = "Visualisation période de visite"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_maj_date_visite from statictext within w_suivi_visite
integer x = 430
integer y = 104
integer width = 1143
integer height = 80
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 553648127
string text = "Mise à jour des visites"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_consult from u_pba within w_suivi_visite
integer x = 3154
integer y = 396
integer width = 192
integer height = 128
integer taborder = 20
boolean bringtotop = true
string text = " "
string picturename = "C:\appscir\Erfvmr_diva\Image\pbok.bmp"
string disabledname = "C:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

event constructor;call super::constructor;	fu_setevent ("ue_search")

	fu_set_microhelp ("consultation periode de visite")
this.text=""
end event

type dw_km from u_dw_udis within w_suivi_visite
boolean visible = false
integer x = 398
integer y = 1836
integer width = 443
integer height = 272
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_compte_rendu_visite_kim"
end type

type pb_km from u_pba within w_suivi_visite
integer x = 1381
integer y = 480
integer width = 192
integer height = 128
integer taborder = 10
boolean bringtotop = true
string text = " "
string picturename = "C:\appscir\Erfvmr_diva\Image\pbok.bmp"
string disabledname = "C:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

event constructor;call super::constructor;	fu_setevent ("ue_change_km")

	fu_set_microhelp ("Validation et sauvegarde des modifications")
this.text=""
end event

type st_kilometrage from statictext within w_suivi_visite
integer x = 343
integer y = 496
integer width = 590
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 553648127
string text = "Kilométrage effectué :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_kilometre from u_ema_pt within w_suivi_visite
integer x = 937
integer y = 492
integer width = 425
integer taborder = 20
boolean bringtotop = true
maskdatatype maskdatatype = numericmask!
string mask = "#####"
end type

type r_1 from rectangle within w_suivi_visite
integer linethickness = 4
long fillcolor = 12632256
integer x = 2505
integer y = 48
integer width = 1376
integer height = 548
end type

type r_2 from rectangle within w_suivi_visite
integer linethickness = 4
long fillcolor = 12632256
integer x = 306
integer y = 56
integer width = 1376
integer height = 340
end type

type r_3 from rectangle within w_suivi_visite
integer linethickness = 4
long fillcolor = 12632256
integer x = 311
integer y = 432
integer width = 1381
integer height = 240
end type

