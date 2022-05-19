$PBExportHeader$w_compte_rendu_visite.srw
forward
global type w_compte_rendu_visite from w_a_liste
end type
type em_date_visite from u_ema_pt within w_compte_rendu_visite
end type
type st_dtevis from statictext within w_compte_rendu_visite
end type
type cbx_prospect from u_cbxa_pt within w_compte_rendu_visite
end type
type sle_client from u_slea_pt within w_compte_rendu_visite
end type
type st_numclt from statictext within w_compte_rendu_visite
end type
type cbx_commande from u_cbxa_pt within w_compte_rendu_visite
end type
type em_valeur from u_ema_pt within w_compte_rendu_visite
end type
type st_valeur_cde from statictext within w_compte_rendu_visite
end type
type mle_remarque from u_mlea_pt within w_compte_rendu_visite
end type
type st_remarques from statictext within w_compte_rendu_visite
end type
type rr_1 from roundrectangle within w_compte_rendu_visite
end type
end forward

global type w_compte_rendu_visite from w_a_liste
integer width = 4585
integer height = 2776
string title = "Compte rendu de visite"
boolean controlmenu = false
boolean resizable = false
windowtype windowtype = child!
em_date_visite em_date_visite
st_dtevis st_dtevis
cbx_prospect cbx_prospect
sle_client sle_client
st_numclt st_numclt
cbx_commande cbx_commande
em_valeur em_valeur
st_valeur_cde st_valeur_cde
mle_remarque mle_remarque
st_remarques st_remarques
rr_1 rr_1
end type
global w_compte_rendu_visite w_compte_rendu_visite

on w_compte_rendu_visite.create
int iCurrent
call super::create
this.em_date_visite=create em_date_visite
this.st_dtevis=create st_dtevis
this.cbx_prospect=create cbx_prospect
this.sle_client=create sle_client
this.st_numclt=create st_numclt
this.cbx_commande=create cbx_commande
this.em_valeur=create em_valeur
this.st_valeur_cde=create st_valeur_cde
this.mle_remarque=create mle_remarque
this.st_remarques=create st_remarques
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_date_visite
this.Control[iCurrent+2]=this.st_dtevis
this.Control[iCurrent+3]=this.cbx_prospect
this.Control[iCurrent+4]=this.sle_client
this.Control[iCurrent+5]=this.st_numclt
this.Control[iCurrent+6]=this.cbx_commande
this.Control[iCurrent+7]=this.em_valeur
this.Control[iCurrent+8]=this.st_valeur_cde
this.Control[iCurrent+9]=this.mle_remarque
this.Control[iCurrent+10]=this.st_remarques
this.Control[iCurrent+11]=this.rr_1
end on

on w_compte_rendu_visite.destroy
call super::destroy
destroy(this.em_date_visite)
destroy(this.st_dtevis)
destroy(this.cbx_prospect)
destroy(this.sle_client)
destroy(this.st_numclt)
destroy(this.cbx_commande)
destroy(this.em_valeur)
destroy(this.st_valeur_cde)
destroy(this.mle_remarque)
destroy(this.st_remarques)
destroy(this.rr_1)
end on

event ue_ok;long l_row
String s_prospect
String s_commande
Decimal d_valeur

// Validation de la saisie des donnees

If  em_date_visite.Text = ""  or em_date_visite.Text = "00/00/0000" then
	messageBox ("Controle","Date de visite obligatoire",stopsign!)
	em_date_visite.SetFocus()
	return
end if

If  not cbx_prospect.checked  then 
	if  sle_client.text = "" then
	    messageBox ("Controle","Code client obligatoire ",stopsign!)
	    sle_client.SetFocus()
	    return
	else
		nv_client_object lu_client
		lu_client = create  nv_client_object
          if not lu_client.fu_retrieve_client( sle_client.text ) then
			   messageBox ("Controle","Code client inexistant ",stopsign!)
	            sle_client.SetFocus()
			   destroy lu_client
	            return
		end if
		destroy lu_client
		end if
end if

If  cbx_commande.checked  and em_valeur.text = "" then
	messageBox ("Controle","Valeur commande obligatoire ",stopsign!)
	em_valeur.SetFocus()
	return
end if

l_row = dw_1.Insertrow(0)
dw_1.SetItem (l_row, DBNAME_DATE_CREATION, i_tr_sql.fnv_get_datetime ())
dw_1.setitem(l_row,DBNAME_CODE_MAJ,'C')
dw_1.setitem(l_row,DBNAME_CODE_VISITEUR,g_s_visiteur)
dw_1.setitem(l_row,"DATAEVIS",date(em_date_visite.text))
dw_1.setitem(l_row,"NUMAECLF",sle_client.text)

if cbx_prospect.checked then
	s_prospect = 'O'
else
	s_prospect = 'N'
end if

dw_1.setitem(l_row,"PROSPECT", s_prospect)

if cbx_commande.checked then
	s_commande = 'O'
else
	s_commande = 'N'
end if
dw_1.setitem(l_row,"COMMANDE",s_commande)
em_valeur.getdata(d_valeur)
dw_1.setitem(l_row,"MONTANT",d_valeur)
dw_1.setitem(l_row,"REMARQUE", mle_remarque.text)
dw_1.update()



end event

type uo_statusbar from w_a_liste`uo_statusbar within w_compte_rendu_visite
end type

type cb_cancel from w_a_liste`cb_cancel within w_compte_rendu_visite
integer x = 1486
integer y = 1612
integer taborder = 100
end type

type cb_ok from w_a_liste`cb_ok within w_compte_rendu_visite
integer x = 1070
integer y = 1620
integer taborder = 80
end type

type dw_1 from w_a_liste`dw_1 within w_compte_rendu_visite
integer x = 59
integer y = 1240
integer width = 4215
integer height = 1324
integer taborder = 70
boolean enabled = false
string dataobject = "d_compte_rendu_visite"
end type

type pb_ok from w_a_liste`pb_ok within w_compte_rendu_visite
integer x = 3081
integer y = 352
integer taborder = 90
string picturename = "C:\appscir\Erfvmr_diva\Image\PBOK.BMP"
end type

type pb_echap from w_a_liste`pb_echap within w_compte_rendu_visite
integer x = 3099
integer y = 664
integer taborder = 100
string picturename = "C:\appscir\Erfvmr_diva\Image\PBECHAP.BMP"
end type

type em_date_visite from u_ema_pt within w_compte_rendu_visite
integer x = 837
integer y = 196
integer width = 425
integer taborder = 30
boolean bringtotop = true
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type st_dtevis from statictext within w_compte_rendu_visite
integer x = 247
integer y = 216
integer width = 544
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

type cbx_prospect from u_cbxa_pt within w_compte_rendu_visite
integer x = 1335
integer y = 216
integer width = 370
integer height = 80
integer taborder = 40
boolean bringtotop = true
long backcolor = 553648127
string text = "Prospect ?"
boolean lefttext = true
end type

type sle_client from u_slea_pt within w_compte_rendu_visite
integer x = 2295
integer y = 200
integer width = 535
integer height = 96
integer taborder = 50
boolean bringtotop = true
end type

type st_numclt from statictext within w_compte_rendu_visite
integer x = 1755
integer y = 216
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
string text = "N° de Client"
alignment alignment = right!
boolean focusrectangle = false
end type

type cbx_commande from u_cbxa_pt within w_compte_rendu_visite
integer x = 832
integer y = 392
integer width = 736
integer height = 80
integer taborder = 60
boolean bringtotop = true
long backcolor = 553648127
string text = "Prise d~'une commande ?"
boolean lefttext = true
end type

type em_valeur from u_ema_pt within w_compte_rendu_visite
integer x = 2290
integer y = 372
integer width = 544
integer taborder = 70
boolean bringtotop = true
maskdatatype maskdatatype = decimalmask!
end type

type st_valeur_cde from statictext within w_compte_rendu_visite
integer x = 1646
integer y = 384
integer width = 626
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
string text = "Valeur commandée"
alignment alignment = right!
boolean focusrectangle = false
end type

type mle_remarque from u_mlea_pt within w_compte_rendu_visite
integer x = 855
integer y = 544
integer width = 1993
integer height = 356
integer taborder = 80
boolean bringtotop = true
integer limit = 250
end type

type st_remarques from statictext within w_compte_rendu_visite
integer x = 270
integer y = 556
integer width = 539
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
string text = "Remarques"
alignment alignment = right!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_compte_rendu_visite
integer linethickness = 4
long fillcolor = 12632256
integer x = 206
integer y = 108
integer width = 3557
integer height = 920
integer cornerheight = 40
integer cornerwidth = 46
end type

