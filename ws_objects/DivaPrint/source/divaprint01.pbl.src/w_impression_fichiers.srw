$PBExportHeader$w_impression_fichiers.srw
forward
global type w_impression_fichiers from w_a
end type
type sle_facture_from from u_slea within w_impression_fichiers
end type
type st_3 from statictext within w_impression_fichiers
end type
type st_4 from statictext within w_impression_fichiers
end type
type sle_pays from u_slea within w_impression_fichiers
end type
type st_1 from statictext within w_impression_fichiers
end type
type cbx_select from u_cbxa within w_impression_fichiers
end type
type sle_facture_to from u_slea within w_impression_fichiers
end type
type st_date_from from statictext within w_impression_fichiers
end type
type r_param from rectangle within w_impression_fichiers
end type
type st_facture from statictext within w_impression_fichiers
end type
type em_date_to from u_ema within w_impression_fichiers
end type
type cbx_facture from u_cbxa within w_impression_fichiers
end type
type dw_document from u_dw_udim within w_impression_fichiers
end type
type em_date_from from u_ema within w_impression_fichiers
end type
type st_date_to from statictext within w_impression_fichiers
end type
type sle_code_client from u_slea within w_impression_fichiers
end type
type st_2 from statictext within w_impression_fichiers
end type
type sle_lines from u_slea within w_impression_fichiers
end type
type cb_ok from u_cba within w_impression_fichiers
end type
type rb_cc from u_rba within w_impression_fichiers
end type
type gb_doc from groupbox within w_impression_fichiers
end type
type rb_fa from u_rba within w_impression_fichiers
end type
type ln_1 from line within w_impression_fichiers
end type
end forward

global type w_impression_fichiers from w_a
integer x = 769
integer y = 461
integer width = 3959
integer height = 2680
string title = "Divaprint - Impression PDF / Print PDF"
string menuname = "m_menu"
long backcolor = 12632256
string icon = "C:\donnees\PowerBuilder\DivaPrint\Images\SC_Reader.ico"
event ue_mail ( )
sle_facture_from sle_facture_from
st_3 st_3
st_4 st_4
sle_pays sle_pays
st_1 st_1
cbx_select cbx_select
sle_facture_to sle_facture_to
st_date_from st_date_from
r_param r_param
st_facture st_facture
em_date_to em_date_to
cbx_facture cbx_facture
dw_document dw_document
em_date_from em_date_from
st_date_to st_date_to
sle_code_client sle_code_client
st_2 st_2
sle_lines sle_lines
cb_ok cb_ok
rb_cc rb_cc
gb_doc gb_doc
rb_fa rb_fa
ln_1 ln_1
end type
global w_impression_fichiers w_impression_fichiers

type variables
String is_type_document
Long ii_liste_fichier[]
Long ii_ind_liste
long ii_num_rectangle

String is_path_fichier
end variables

forward prototypes
public function boolean fw_confirmation_impression ()
public subroutine fw_maj_statut ()
public subroutine fw_maj_ligne ()
end prototypes

event ue_mail();str_pass l_str_pass
integer  li_indice
integer li_indice2

For li_indice = 1 to dw_document.RowCount()
		if dw_document.getItemString(li_indice,"selection") = "O" then
             li_indice2 ++
		   l_str_pass.s[li_indice2] =  dw_document.getItemString(li_indice,"nom_document")
		end if
next

if li_indice2 = 0 then
	messagebox ( "Controle / Control", "Veuillez sélectionner au moins un document ~r~n Please select one or more document(s)",Information!)
	return
end if

l_str_pass.d[1] = li_indice2
openwithparm(w_envoi_mail, l_str_pass)
end event

public function boolean fw_confirmation_impression ();integer li_return

li_return = messagebox ("Confirmation","Veuillez confirmer m'impression du/des document(s) ~r~n Please confirm that the document(s) is/are printed",Information!,YesNo!)

if li_return = 1 then
	return true
else 
	return false
end if


end function

public subroutine fw_maj_statut ();

long ll_nbr = 0
long li_indice

SQLCA.fnv_connect( )

For li_indice = 1 to ii_ind_liste
    UPDATE divaprint_documents 
        SET statu = 'O'
        WHERE num_piece  = :ii_liste_fichier[li_indice] 
        USING SQLCA ;
next

dw_document.setTransObject (sqlca)
postevent("ue_ok")
end subroutine

public subroutine fw_maj_ligne ();long ll_nbr = 0
long li_indice
long li_nbr

li_nbr = 0

For li_indice = 1 to dw_document.RowCount()
		if dw_document.getItemString(li_indice,"selection") = "O" then
			li_nbr++
			ii_liste_fichier[li_nbr]=dw_document.getItemNumber (li_indice,"num_piece")
		end if
next

sle_lines.text = string(li_nbr) + " / " + string(dw_document.RowCount())
ii_ind_liste = li_nbr

end subroutine

on w_impression_fichiers.create
int iCurrent
call super::create
if this.MenuName = "m_menu" then this.MenuID = create m_menu
this.sle_facture_from=create sle_facture_from
this.st_3=create st_3
this.st_4=create st_4
this.sle_pays=create sle_pays
this.st_1=create st_1
this.cbx_select=create cbx_select
this.sle_facture_to=create sle_facture_to
this.st_date_from=create st_date_from
this.r_param=create r_param
this.st_facture=create st_facture
this.em_date_to=create em_date_to
this.cbx_facture=create cbx_facture
this.dw_document=create dw_document
this.em_date_from=create em_date_from
this.st_date_to=create st_date_to
this.sle_code_client=create sle_code_client
this.st_2=create st_2
this.sle_lines=create sle_lines
this.cb_ok=create cb_ok
this.rb_cc=create rb_cc
this.gb_doc=create gb_doc
this.rb_fa=create rb_fa
this.ln_1=create ln_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_facture_from
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.sle_pays
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.cbx_select
this.Control[iCurrent+7]=this.sle_facture_to
this.Control[iCurrent+8]=this.st_date_from
this.Control[iCurrent+9]=this.r_param
this.Control[iCurrent+10]=this.st_facture
this.Control[iCurrent+11]=this.em_date_to
this.Control[iCurrent+12]=this.cbx_facture
this.Control[iCurrent+13]=this.dw_document
this.Control[iCurrent+14]=this.em_date_from
this.Control[iCurrent+15]=this.st_date_to
this.Control[iCurrent+16]=this.sle_code_client
this.Control[iCurrent+17]=this.st_2
this.Control[iCurrent+18]=this.sle_lines
this.Control[iCurrent+19]=this.cb_ok
this.Control[iCurrent+20]=this.rb_cc
this.Control[iCurrent+21]=this.gb_doc
this.Control[iCurrent+22]=this.rb_fa
this.Control[iCurrent+23]=this.ln_1
end on

on w_impression_fichiers.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_facture_from)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.sle_pays)
destroy(this.st_1)
destroy(this.cbx_select)
destroy(this.sle_facture_to)
destroy(this.st_date_from)
destroy(this.r_param)
destroy(this.st_facture)
destroy(this.em_date_to)
destroy(this.cbx_facture)
destroy(this.dw_document)
destroy(this.em_date_from)
destroy(this.st_date_to)
destroy(this.sle_code_client)
destroy(this.st_2)
destroy(this.sle_lines)
destroy(this.cb_ok)
destroy(this.rb_cc)
destroy(this.gb_doc)
destroy(this.rb_fa)
destroy(this.ln_1)
end on

event ue_close;call super::ue_close;close(this)
end event

event ue_ok;call super::ue_ok;date ld_date_deb
date ld_date_fin
long ll_return
string ls_deja_imprimer
string ls_facture_from
string ls_facture_to


if  trim(sle_code_client.text) = "" and &
   trim(sle_pays.text)= "" and &
  ( trim(em_date_from.text) = "00/00/0000" or trim(em_date_from.text) = "")and  &
  ( trim(em_date_to.text) = "00/00/0000" or trim(em_date_to.text) = "")and  &  
   not cbx_facture.checked  and &
	rb_fa.checked   	then
        messagebox("Controle/Control", "Veuillez renseigner au moins un critère de recherche ~r~n Please complete at least one search criteria",Information!)
    return
end if

if  trim(em_date_from.text) = "00/00/0000" then
	 ld_date_deb = date("2009-01-01")
else
	ld_date_deb = date(em_date_from.text)
end if

if  trim(em_date_to.text) = "00/00/0000" then
	 ld_date_fin  = date("2999-01-01")
else
	ld_date_fin = date(em_date_to.text)
end if

if cbx_facture.checked then
	 ls_deja_imprimer = "N"
else
	ls_deja_imprimer = "O"
end if

ls_facture_from = "00000000"
ls_facture_to     = "99999999"

if trim(sle_facture_from.text) <> "" and not  isnull(sle_facture_from.text) then
	ls_facture_from = sle_facture_from.text
     if trim(sle_facture_to.text) = "" or isnull(sle_facture_to.text) then
          ls_facture_to = sle_facture_from.text
		else 
		ls_facture_to = sle_facture_to.text
      end if
end if

if rb_fa .checked then 
    ll_return = dw_document.retrieve(g_s_etab,is_type_document,trim(sle_pays.text)+"%", trim(sle_code_client.text)+"%", ld_date_deb, ld_date_fin,ls_deja_imprimer,ls_facture_from,ls_facture_to)
else
    ll_return = dw_document.retrieve(g_s_etab,is_type_document,"%", "%", ld_date_deb, ld_date_fin,"%","0000-00-00","2999-12-31")	
end if

if ll_return = -1 then
  messageBox("Erreur acces / Access Error","Problême lors de la recherche des factures ~r~n Error during search invoices",stopsign!)
  disconnect;
end if

sle_lines.text = "0 / "+String (dw_document.Rowcount())
postevent("ue_selectall")
//for ll_return = 2  to dw_document.rowCount()
//	dw_document.SetItem (ll_return,"cnum_ligne",ll_return)
//next

end event

event ue_init;call super::ue_init;dw_document.setTransObject (sqlca)

//is_path_fichier = g_s_path_fichier_fac
is_path_fichier = i_str_pass.s[12]
end event

event ue_print;call super::ue_print;// overwrite script
Integer li_indice
String ls_fileToPrint

Datastore lds_data
Long ll_row,ll_row2
integer  ll_nbrex


String ls_client
String ll_liste_fichier_par_client[]
Long ll_nbr_fichier
String ls_commande


lds_data = CREATE Datastore
lds_data.dataobject = "d_liste_document_imprime"
lds_data.Settrans(SQLCA)
lds_data.retrieve()

ii_ind_liste = 0

ll_nbr_fichier = 0
if dw_document.RowCount() > 0 then
	ls_client = dw_document.getItemString(1,"code_tiers") 
end if


triggerEvent("ue_printsetup")
For ll_row = 1 to dw_document.RowCount()
	
	// si rupture sur code client, si nbr de document sélectionné > 1, fusionne les fichiers avant impression
	// sinon impression du fichier
	// 04/10/2016  == remplacement de la rupture sur le tiers par le client payeur
	//  if dw_document.getItemString(ll_row,"code_tiers")  <> ls_client then
    if dw_document.getItemString(ll_row,"cltpayeur")  <> ls_client then
	//		 si un seul fichier, imprime directement le fichier
			if ll_nbr_fichier = 1 then
     			ls_fileToPrint = g_s_commande_print_pdf + is_path_fichier + "\" +  ll_liste_fichier_par_client[1]
  		 	     run ( ls_fileToPrint)
			end if
			
			// si plusieurs fichiers, fusion des fichiers et impression du fichier
           if ll_nbr_fichier > 1 then
 				ls_commande =  "C:\Appscir\pb125\divaprint\pdftk "
				for li_indice = 1 to ll_nbr_fichier
					ls_commande = ls_commande + '"' + is_path_fichier + '\' + ll_liste_fichier_par_client[li_indice] +'" '
				next
 				ls_commande = ls_commande +  'cat output "C:\Appscir\pb125\divaprint\' + ls_client +'.pdf"'
				run(ls_commande) 
				sleep(ll_nbr_fichier*2)
				 ls_fileToPrint = g_s_commande_print_pdf + "C:\Appscir\pb125\divaprint\" + ls_client +".pdf"
  		 	     run ( ls_fileToPrint)
			end if
			ll_nbr_fichier = 0
				// 04/10/2016  == remplacement de la rupture sur le tiers par le client payeur
			   // ls_client = dw_document.getItemString(ll_row,"code_tiers") 
			ls_client = dw_document.getItemString(ll_row,"cltpayeur")
		end if	
	 
		if dw_document.getItemString(ll_row,"selection") = "O" then
//			//ls_fileToPrint = g_s_commande_print_pdf + g_s_path_fichier + "\" + dw_document.GetItemString(ll_row,"nom_document")
//			ls_fileToPrint = g_s_commande_print_pdf + is_path_fichier + "\" + dw_document.GetItemString(ll_row,"nom_document")
//			 run ( ls_fileToPrint)
//			
			ll_row2 = lds_data.InsertRow(0)
			lds_data.setItem(ll_row2,"cltpayeur",dw_document.GetItemString(ll_row,"cltpayeur"))
			lds_data.setItem(ll_row2,"num_piece",dw_document.GetItemDecimal(ll_row,"num_piece"))
      		lds_data.setItem(ll_row2,"code_tiers",dw_document.GetItemString(ll_row,"code_tiers"))
      		lds_data.setItem(ll_row2,"nom_tiers",dw_document.GetItemString(ll_row,"nom_tiers"))		
      		lds_data.setItem(ll_row2,"nbrex",dw_document.GetItemDecimal(ll_row,"nbrex"))						
			
//			// stockage des fichiers dans la table des fichiers par client
			ll_nbrex	= dw_document.getItemDecimal(ll_row,"nbrex")
			for li_indice = 1 to ll_nbrex
				ll_nbr_fichier ++
  		 	     ll_liste_fichier_par_client[ll_nbr_fichier] = dw_document.GetItemString(ll_row,"nom_document")
				if  Mod( dw_document.GetItemDecimal(ll_row,"nbr_page") , 2) <> 0 then
					 ll_nbr_fichier ++
					 ll_liste_fichier_par_client[ll_nbr_fichier] = "emptyfile.pdf"
				end if
			next
			
			ii_ind_liste ++
			ii_liste_fichier[ii_ind_liste] = dw_document.GetItemDecimal(ll_row,"num_piece")
		end if
	Next	
	
	// traitement de la dernière rupture
if ll_nbr_fichier = 1 then
     			ls_fileToPrint = g_s_commande_print_pdf + is_path_fichier + "\" +  ll_liste_fichier_par_client[1]
  		 	     run ( ls_fileToPrint)
end if
			
			// si plusieurs fichiers, fusion des fichiers et impression du fichier
if ll_nbr_fichier > 1 then
 				ls_commande =  "C:\Appscir\pb125\divaprint\pdftk "
				for li_indice = 1 to ll_nbr_fichier
					ls_commande = ls_commande + '"' + is_path_fichier + '\' + ll_liste_fichier_par_client[li_indice] +'" '
				next
 				ls_commande = ls_commande +  'cat output "C:\Appscir\pb125\divaprint\' + ls_client +'.pdf"'
				run(ls_commande) 
				sleep(ll_nbr_fichier*2)
				 ls_fileToPrint = g_s_commande_print_pdf + "C:\Appscir\pb125\divaprint\" + ls_client +".pdf"
  		 	     run ( ls_fileToPrint)
end if

lds_data.print( )

if not fw_confirmation_impression() then
	return
end if

// Mise à jour du statu à déjà imprimer pour les documents sélectionnés
fw_maj_statut()

end event

event ue_printpreview;call super::ue_printpreview;//* overwrite script

Integer li_indice
String ls_fileToPrint

For li_indice = 1 to dw_document.RowCount()
	if dw_document.getItemString(li_indice,"selection") = "O" then
//     	ls_fileToPrint =  g_s_commande_open_pdf + g_s_path_fichier + "\" + dw_document.GetItemString(li_indice,"nom_document")
		 ls_fileToPrint = g_s_commande_print_pdf + is_path_fichier + "\" + dw_document.GetItemString(li_indice,"nom_document")
		run ( ls_fileToPrint)
	end if
next


if not fw_confirmation_impression() then
	return
end if

// Mise à jour du statu à déjà imprimer pour les documents sélectionnés
fw_maj_statut()
end event

event ue_selectall;call super::ue_selectall;// Si tout selectionner est activé , positionner sur toutes les lignes à imprimer sinon à ne pas imprimer

boolean lb_select
String    ls_select
long ll_indice

lb_select =  cbx_select.checked 
if lb_select then
  ls_select = "O"
else
 ls_select = "N"
end if

for ll_indice = 1 to dw_document.rowcount()
	dw_document.setitem(ll_indice,"selection",ls_select)
next

fw_maj_ligne()
end event

type sle_facture_from from u_slea within w_impression_fichiers
integer x = 2240
integer y = 352
integer width = 402
integer height = 64
integer taborder = 30
boolean bringtotop = true
end type

type st_3 from statictext within w_impression_fichiers
integer x = 2981
integer y = 256
integer width = 219
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 12632256
string text = "Au / to"
boolean focusrectangle = false
end type

type st_4 from statictext within w_impression_fichiers
integer x = 37
integer y = 640
integer width = 736
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 12632256
string text = "Number of selected lines"
boolean focusrectangle = false
end type

type sle_pays from u_slea within w_impression_fichiers
integer x = 2345
integer y = 64
integer width = 293
integer height = 64
integer taborder = 20
boolean bringtotop = true
integer limit = 3
end type

type st_1 from statictext within w_impression_fichiers
integer x = 1531
integer y = 64
integer width = 727
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 12632256
string text = "Code Pays / Country code"
boolean focusrectangle = false
end type

type cbx_select from u_cbxa within w_impression_fichiers
integer x = 2743
integer y = 640
integer width = 914
integer height = 64
integer taborder = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
long backcolor = 12632256
string text = "Tout sélectionner / Selection All"
boolean lefttext = true
end type

event clicked;call super::clicked;parent.triggerevent("ue_selectall")
end event

type sle_facture_to from u_slea within w_impression_fichiers
integer x = 2898
integer y = 356
integer width = 402
integer height = 64
integer taborder = 20
boolean bringtotop = true
end type

type st_date_from from statictext within w_impression_fichiers
integer x = 1531
integer y = 256
integer width = 955
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 12632256
string text = "Date facture / Invoice date  du/from"
boolean focusrectangle = false
end type

type r_param from rectangle within w_impression_fichiers
long linecolor = 33554432
integer linethickness = 4
long fillcolor = 12632256
integer x = 1477
integer y = 32
integer width = 2194
integer height = 544
end type

type st_facture from statictext within w_impression_fichiers
integer x = 1531
integer y = 352
integer width = 654
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 12632256
string text = "N° Facture / Invoice Nr."
boolean focusrectangle = false
end type

type em_date_to from u_ema within w_impression_fichiers
integer x = 3200
integer y = 256
integer width = 366
integer height = 72
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
fontcharset fontcharset = ansi!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type cbx_facture from u_cbxa within w_impression_fichiers
integer x = 1609
integer y = 480
integer width = 1207
integer height = 64
integer taborder = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
boolean italic = true
long backcolor = 12632256
string text = "Facture non imprimée / No printed Invoices"
boolean checked = true
boolean lefttext = true
end type

type dw_document from u_dw_udim within w_impression_fichiers
event ue_select ( )
integer x = 73
integer y = 800
integer width = 3785
integer height = 1536
integer taborder = 80
string dataobject = "d_liste_document"
boolean vscrollbar = true
end type

event ue_select();fw_maj_ligne()
end event

event itemchanged;call super::itemchanged;postevent("ue_select")
end event

type em_date_from from u_ema within w_impression_fichiers
integer x = 2578
integer y = 256
integer width = 366
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
fontcharset fontcharset = ansi!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type st_date_to from statictext within w_impression_fichiers
integer x = 2693
integer y = 356
integer width = 219
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 12632256
string text = "Au / to"
boolean focusrectangle = false
end type

type sle_code_client from u_slea within w_impression_fichiers
integer x = 2345
integer y = 160
integer width = 512
integer height = 64
integer taborder = 30
boolean bringtotop = true
integer limit = 8
end type

type st_2 from statictext within w_impression_fichiers
integer x = 1531
integer y = 160
integer width = 782
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 12632256
string text = "Code client / Customer code"
boolean focusrectangle = false
end type

type sle_lines from u_slea within w_impression_fichiers
integer x = 805
integer y = 640
integer width = 293
integer height = 64
integer taborder = 20
boolean bringtotop = true
long backcolor = 12632256
integer limit = 3
boolean displayonly = true
boolean hideselection = false
end type

type cb_ok from u_cba within w_impression_fichiers
integer x = 402
integer y = 448
integer width = 512
integer height = 96
integer taborder = 70
boolean bringtotop = true
string text = "OK"
end type

event constructor;call super::constructor;	fu_setevent ("ue_ok")
end event

type rb_cc from u_rba within w_impression_fichiers
integer x = 146
integer y = 224
integer width = 1042
integer height = 64
boolean bringtotop = true
integer textsize = -10
long backcolor = 12632256
string text = "Carnet de commande / Order book"
end type

event clicked;call super::clicked;st_1.enabled = false
st_2.enabled = false
st_date_from.enabled = false
st_date_to.enabled = false
st_facture.enabled = false

sle_pays.text = ""
sle_code_client.text = ""
em_date_from.text =  "00/00/0000"
em_date_to.text =  "00/00/0000"
cbx_facture.enabled = false
  
sle_pays.enabled = false
em_date_from.enabled = false
em_date_to.enabled = false
sle_code_client.enabled = false
sle_facture_from.enabled = false
sle_facture_to.enabled = false

is_type_document= "C"
//is_path_fichier = g_s_path_fichier_cde
is_path_fichier = i_str_pass.s[13]
end event

type gb_doc from groupbox within w_impression_fichiers
integer x = 73
integer y = 32
integer width = 1170
integer height = 288
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 12632256
string text = "Type document / Document Type"
end type

type rb_fa from u_rba within w_impression_fichiers
integer x = 146
integer y = 128
integer width = 544
integer height = 64
boolean bringtotop = true
integer textsize = -10
long backcolor = 12632256
string text = "Facture / Invoice"
end type

event clicked;call super::clicked;st_1.enabled = true
st_2.enabled = true
st_date_from.enabled = true
st_date_to.enabled = true
cbx_facture.enabled = true
cbx_facture.checked = true
st_facture.enabled = true

sle_pays.text = ""
sle_code_client.text = ""
em_date_from.text = ""
em_date_to.text = ""

sle_pays.enabled = true
em_date_from.enabled = true
em_date_to.enabled = true
sle_code_client.enabled = true
sle_facture_from.enabled = true
sle_facture_to.enabled = true

is_type_document= "F"
//is_path_fichier = g_s_path_fichier_fac
is_path_fichier = i_str_pass.s[12]
end event

type ln_1 from line within w_impression_fichiers
long linecolor = 33554432
integer linethickness = 4
integer beginy = 736
integer endx = 3877
integer endy = 736
end type

