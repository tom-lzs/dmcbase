$PBExportHeader$w_suivi_visite_rc.srw
forward
global type w_suivi_visite_rc from w_a_udim_su
end type
type pb_echap from u_pba_echap within w_suivi_visite_rc
end type
type pb_impression from u_pba within w_suivi_visite_rc
end type
type em_date_deb from u_ema_pt within w_suivi_visite_rc
end type
type em_date_fin from u_ema_pt within w_suivi_visite_rc
end type
type st_du from statictext within w_suivi_visite_rc
end type
type st_au from statictext within w_suivi_visite_rc
end type
type st_impression_dte_visite from statictext within w_suivi_visite_rc
end type
type pb_consult from u_pba within w_suivi_visite_rc
end type
type dw_visiteur from u_dwa within w_suivi_visite_rc
end type
type codeevis_t from statictext within w_suivi_visite_rc
end type
type r_1 from rectangle within w_suivi_visite_rc
end type
end forward

global type w_suivi_visite_rc from w_a_udim_su
integer width = 6277
integer height = 3284
string title = "Suivi des visites clients"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
long backcolor = 12632256
boolean ib_a_traduire = true
boolean ib_statusbar_visible = true
pb_echap pb_echap
pb_impression pb_impression
em_date_deb em_date_deb
em_date_fin em_date_fin
st_du st_du
st_au st_au
st_impression_dte_visite st_impression_dte_visite
pb_consult pb_consult
dw_visiteur dw_visiteur
codeevis_t codeevis_t
r_1 r_1
end type
global w_suivi_visite_rc w_suivi_visite_rc

type variables
DataWindowChild		i_dwc_liste

end variables

on w_suivi_visite_rc.create
int iCurrent
call super::create
this.pb_echap=create pb_echap
this.pb_impression=create pb_impression
this.em_date_deb=create em_date_deb
this.em_date_fin=create em_date_fin
this.st_du=create st_du
this.st_au=create st_au
this.st_impression_dte_visite=create st_impression_dte_visite
this.pb_consult=create pb_consult
this.dw_visiteur=create dw_visiteur
this.codeevis_t=create codeevis_t
this.r_1=create r_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_echap
this.Control[iCurrent+2]=this.pb_impression
this.Control[iCurrent+3]=this.em_date_deb
this.Control[iCurrent+4]=this.em_date_fin
this.Control[iCurrent+5]=this.st_du
this.Control[iCurrent+6]=this.st_au
this.Control[iCurrent+7]=this.st_impression_dte_visite
this.Control[iCurrent+8]=this.pb_consult
this.Control[iCurrent+9]=this.dw_visiteur
this.Control[iCurrent+10]=this.codeevis_t
this.Control[iCurrent+11]=this.r_1
end on

on w_suivi_visite_rc.destroy
call super::destroy
destroy(this.pb_echap)
destroy(this.pb_impression)
destroy(this.em_date_deb)
destroy(this.em_date_fin)
destroy(this.st_du)
destroy(this.st_au)
destroy(this.st_impression_dte_visite)
destroy(this.pb_consult)
destroy(this.dw_visiteur)
destroy(this.codeevis_t)
destroy(this.r_1)
end on

event ue_init;call super::ue_init;i_str_pass.b[1]				=  true

// ----------------------------------------
// RETRIEVE DE LA LISTE DES CODES visiteur
// ----------------------------------------
	IF dw_visiteur.GetChild (DBNAME_CODE_VISITEUR,i_dwc_liste) = -1 THEN
		messagebox (this.title,g_nv_traduction.get_traduction(ERR_GETCHILD_W_SEL_CDE),Information!,Ok!,1)
		close (This)
	END IF
	
	i_dwc_liste.SetTransObject(SQLCA)
	dw_visiteur.SetTransObject(SQLCA)
	
	if i_dwc_liste.Retrieve() = -1 then
		f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
	END if
	
	if dw_visiteur.Retrieve () = -1 then
		f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
   End if
	dw_visiteur.InsertRow (1)
	dw_visiteur.SetFocus()
	dw_Visiteur.SetRow(1)
	dw_visiteur.visible	=	True

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

event ue_retrieve;call super::ue_retrieve;/* <DESC>
     Permet d'imprimer le bon de commande pour la commande sélectionnée
	  </DESC> */
// DECLARATION DES VARIABLES LOCALES
Long		l_retrieve
if isnull(em_date_deb.text) or isnull(em_date_fin.text) then
	  messageBox ("Controle","période obligatoire",stopsign!)
end if

if isnull(dw_visiteur.GetText()) then
		  messageBox ("Controle","visiteur obligatoire",stopsign!)
end if

l_retrieve = dw_1.Retrieve (dw_visiteur.GetText(), date(em_date_deb.text), date(em_date_fin.text))


end event

type uo_statusbar from w_a_udim_su`uo_statusbar within w_suivi_visite_rc
integer taborder = 30
end type

type dw_1 from w_a_udim_su`dw_1 within w_suivi_visite_rc
integer y = 724
integer width = 4873
integer height = 1804
integer taborder = 10
string dataobject = "d_compte_rendu_visite_semaine"
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

type pb_echap from u_pba_echap within w_suivi_visite_rc
integer x = 2981
integer y = 2604
integer width = 384
integer height = 188
integer taborder = 80
boolean bringtotop = true
string picturename = "C:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type pb_impression from u_pba within w_suivi_visite_rc
integer x = 1979
integer y = 2616
integer width = 334
integer height = 168
integer taborder = 70
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

type em_date_deb from u_ema_pt within w_suivi_visite_rc
integer x = 1189
integer y = 344
integer width = 425
integer taborder = 40
boolean bringtotop = true
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type em_date_fin from u_ema_pt within w_suivi_visite_rc
integer x = 1815
integer y = 348
integer width = 425
integer taborder = 50
boolean bringtotop = true
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type st_du from statictext within w_suivi_visite_rc
integer x = 983
integer y = 360
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

type st_au from statictext within w_suivi_visite_rc
integer x = 1623
integer y = 356
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

type st_impression_dte_visite from statictext within w_suivi_visite_rc
integer x = 1138
integer y = 88
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

type pb_consult from u_pba within w_suivi_visite_rc
integer x = 1591
integer y = 476
integer width = 192
integer height = 128
integer taborder = 60
boolean bringtotop = true
string text = " "
string picturename = "C:\appscir\Erfvmr_diva\Image\pbok.bmp"
string disabledname = "C:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

event constructor;call super::constructor;	fu_setevent ("ue_retrieve")

	fu_set_microhelp ("consultation periode de visite")
this.text=""
end event

type dw_visiteur from u_dwa within w_suivi_visite_rc
string tag = "A_TRADUIRE"
integer x = 1408
integer y = 208
integer width = 965
integer height = 92
integer taborder = 20
boolean bringtotop = true
string dataobject = "dd_visiteur"
boolean border = false
end type

event we_dwnkey;call super::we_dwnkey;parent.triggerEvent("key")
end event

type codeevis_t from statictext within w_suivi_visite_rc
integer x = 1088
integer y = 216
integer width = 297
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Visiteur :"
alignment alignment = right!
boolean focusrectangle = false
end type

type r_1 from rectangle within w_suivi_visite_rc
integer linethickness = 4
long fillcolor = 12632256
integer x = 951
integer y = 56
integer width = 1458
integer height = 616
end type

