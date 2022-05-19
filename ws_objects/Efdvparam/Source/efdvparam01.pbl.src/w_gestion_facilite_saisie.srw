$PBExportHeader$w_gestion_facilite_saisie.srw
$PBExportComments$Permet la gestion du facilite de saisie
forward
global type w_gestion_facilite_saisie from w_a_udim_su
end type
type cb_1 from u_cba within w_gestion_facilite_saisie
end type
type cb_2 from u_cba within w_gestion_facilite_saisie
end type
type sle_artae000 from u_slea within w_gestion_facilite_saisie
end type
type sle_dimaeequ from u_slea within w_gestion_facilite_saisie
end type
type sle_dimaeart from u_slea within w_gestion_facilite_saisie
end type
type sle_artaeequ from u_slea within w_gestion_facilite_saisie
end type
type st_1 from statictext within w_gestion_facilite_saisie
end type
type st_2 from statictext within w_gestion_facilite_saisie
end type
type st_3 from statictext within w_gestion_facilite_saisie
end type
type st_4 from statictext within w_gestion_facilite_saisie
end type
type dw_facilite from u_dw_udim within w_gestion_facilite_saisie
end type
type dw_liste_facilite from u_dw_udim within w_gestion_facilite_saisie
end type
type cb_3 from u_cba within w_gestion_facilite_saisie
end type
type sle_recherche_article from u_slea within w_gestion_facilite_saisie
end type
type st_5 from statictext within w_gestion_facilite_saisie
end type
type st_6 from statictext within w_gestion_facilite_saisie
end type
type rr_1 from roundrectangle within w_gestion_facilite_saisie
end type
type rr_2 from roundrectangle within w_gestion_facilite_saisie
end type
end forward

global type w_gestion_facilite_saisie from w_a_udim_su
integer width = 4370
integer height = 2104
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = child!
windowstate windowstate = maximized!
long backcolor = 12632256
event ue_article ( )
event ue_validation ( )
event ue_positionne_article ( )
cb_1 cb_1
cb_2 cb_2
sle_artae000 sle_artae000
sle_dimaeequ sle_dimaeequ
sle_dimaeart sle_dimaeart
sle_artaeequ sle_artaeequ
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
dw_facilite dw_facilite
dw_liste_facilite dw_liste_facilite
cb_3 cb_3
sle_recherche_article sle_recherche_article
st_5 st_5
st_6 st_6
rr_1 rr_1
rr_2 rr_2
end type
global w_gestion_facilite_saisie w_gestion_facilite_saisie

type variables
Constant String DBNAME_ART_EQUIV = "artaeequ"
Constant String DBNAME_DIM_EQUIV = "dimaeequ"
Constant String DBNAME_ART 		= "artae000"
Constant String DBNAME_DIM			= "dimaeart"

String is_article_vente
String is_article_facilite

end variables

forward prototypes
public function boolean fw_controle_reference (string as_article, string as_dimension)
public function boolean fw_controle_reference_equivalente (string as_article, string as_dimension)
end prototypes

event ue_article();/* <DESC>
    Permet l'alimentation de la zone article de vente lors du double click sur la liste des articles
	et d'afficher la liste des dimensions associées
   </DESC> */
sle_artae000.text = dw_1.getItemString(dw_1.getRow(),DBNAME_ART)
sle_dimaeart.text = DONNEE_VIDE
sle_dimaeequ.text = DONNEE_VIDE
sle_artaeequ.text = DONNEE_VIDE

triggerEvent("ue_fileopen")
end event

event ue_validation();/* <DESC>
Declencher lors de l'activation du bouton Validation
Permet la validation et la creation du faclite de saisie
<LI> Article de reference et equivalent obligatoires
<LI> Controle de la reference de vente
<LI> Controle que la reference equivalente n'est pas deja affectée à une autre reference
<LI> Creation du facilite de saisie
   </DESC> */
// Validation de la saisie

if isNull(sle_artae000.text ) or trim(sle_artae000.text) = DONNEE_VIDE then
	messagebox (this.title, "Article obligatoire", Information!,Ok!,1)	
	sle_artae000.SetFocus ()
	RETURN	
end if

if isNull(sle_artaeequ.text ) or trim(sle_artaeequ.text) = DONNEE_VIDE then
	messagebox (this.title, "Article équivalence obligatoire", Information!,Ok!,1)	
	sle_artaeequ.SetFocus ()
	RETURN	
end if

String ls_artae000
String ls_dimaeart
String ls_artaeequ
String ls_dimaeequ

ls_artae000 = sle_artae000.text
ls_dimaeart = sle_dimaeart.text
ls_artaeequ = sle_artaeequ.text
ls_dimaeequ = sle_dimaeequ.text
if isNull(ls_dimaeart) or trim(ls_dimaeart) = DONNEE_VIDE then
	ls_dimaeart = BLANK
end if
if isNull(ls_dimaeequ) or trim(ls_dimaeequ) = DONNEE_VIDE then
	ls_dimaeequ = BLANK
end if

if not fw_controle_reference(ls_artae000, ls_dimaeart) then
	return
end if

if not fw_controle_reference_equivalente(ls_artaeequ, ls_dimaeequ) then
	return	
end if

dw_liste_facilite.setFilter(DBNAME_CODE_MAJ +" =  'A'")
dw_liste_facilite.filter()

if dw_liste_facilite.RowCount() = 0 then
	dw_liste_facilite.fu_insert(1)
end if

dw_liste_facilite.setItem(1, "timefcre" ,i_tr_sql.fnv_get_datetime ())
dw_liste_facilite.setItem(1, DBNAME_CODE_MAJ ,"C")
dw_liste_facilite.setItem(1, DBNAME_ART ,ls_artae000)
dw_liste_facilite.setItem(1, DBNAME_DIM, ls_dimaeart)
dw_liste_facilite.setItem(1, DBNAME_ART_EQUIV, ls_artaeequ)
dw_liste_facilite.setItem(1, DBNAME_DIM_EQUIV, ls_dimaeequ)
dw_liste_facilite.update()

dw_1.Retrieve()
dw_facilite.retrieve()
end event

event ue_positionne_article();/* <DESC>
   Est declenche lors de la touche Entree sur la zone de saisie de l'article de vente
	Permet de positionner l'article dans la liste des articles et d'afficher la liste des dimensions
	de l'article
	</DESC> */
if trim(sle_artae000.text) = DONNEE_VIDE then
	return
end if

integer li_indice 
long		ll_row

for li_indice = 1  to dw_1.RowCount()
	if dw_1.getItemString(li_indice, DBNAME_ART) = sle_artae000.text then
		ll_row = li_indice		
	end if
next

dw_1.scrollToRow(ll_row)
triggerEvent("ue_article")
end event

public function boolean fw_controle_reference (string as_article, string as_dimension);/* <DESC>
    Permet de controler l'existence de la reference de vente saisie  pour creation d'un nouveau
	 facilite de saisie
   </DESC> */
Datastore d_controle
integer l_retrieve
boolean b_return

b_return = true 
d_controle = CREATE Datastore
if trim(as_dimension) <> DONNEE_VIDE  then
	d_controle.DataObject = 'd_controle_reference'
	d_controle.SetTransObject (SQLCA)		
	l_retrieve = d_controle.retrieve(as_article, as_dimension)		
else
	d_controle.DataObject = 'd_controle_article'
	d_controle.SetTransObject (SQLCA)		
	l_retrieve = d_controle.retrieve(as_article)		
end if

if l_retrieve = -1 then
	f_dmc_error (this.title + " : Erreur accès aux donnees")
end if

if l_retrieve = 0 then
	messagebox (this.title, "Article ou Référence de vente inexistant(e)", Information!,Ok!,1)			
	sle_artae000.setFocus()
	b_return = false 
end if

return b_return
end function

public function boolean fw_controle_reference_equivalente (string as_article, string as_dimension);/* <DESC>
    Permet de controler que la reference equivalente saisie n'est pas deja existante
   </DESC> */
Datastore d_controle
integer l_retrieve
		
d_controle = CREATE Datastore
d_controle.DataObject = 'd_liste_facilite_saisie_par_facilite'
d_controle.SetTransObject (SQLCA)		

l_retrieve = d_controle.retrieve(as_article, as_dimension)
if l_retrieve = -1 then
	f_dmc_error (this.title + " : Erreur accès aux donnees")
end if

d_controle.setFilter(DBNAME_CODE_MAJ +" <> 'A'")
d_controle.filter()

if l_retrieve = 0 then
	return true
end if

messagebox (this.title, "Référence équivalente déjà affectée", Information!,Ok!,1)
sle_artaeequ.setFocus()
dw_liste_facilite.DataObject = 'd_liste_facilite_saisie_par_facilite'
dw_liste_facilite.SetTransObject (SQLCA)		
dw_liste_facilite.retrieve(as_article, as_dimension)

return false
end function

event ue_init;call super::ue_init;/* <DESC>
     Permet l'initialisation de la fenetre en affichant la liste des articles et la liste des
	  dimension du premier article de la liste
   </DESC> */
integer l_retrieve

dw_1.fu_set_selection_mode (1)
dw_facilite.setTransObject(i_tr_sql)
dw_facilite.fu_set_selection_mode (1)

dw_liste_facilite.setTransObject(i_tr_sql)
dw_1.retrieve()
if dw_1.RowCount() > 0 then
	dw_1.setRow(1)
end if

dw_facilite.retrieve()

if dw_facilite.RowCount() > 0 then
	dw_facilite.setRow(1)
	triggerEvent("ue_fileopen")
end if


end event

on w_gestion_facilite_saisie.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.cb_2=create cb_2
this.sle_artae000=create sle_artae000
this.sle_dimaeequ=create sle_dimaeequ
this.sle_dimaeart=create sle_dimaeart
this.sle_artaeequ=create sle_artaeequ
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.dw_facilite=create dw_facilite
this.dw_liste_facilite=create dw_liste_facilite
this.cb_3=create cb_3
this.sle_recherche_article=create sle_recherche_article
this.st_5=create st_5
this.st_6=create st_6
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.sle_artae000
this.Control[iCurrent+4]=this.sle_dimaeequ
this.Control[iCurrent+5]=this.sle_dimaeart
this.Control[iCurrent+6]=this.sle_artaeequ
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.st_4
this.Control[iCurrent+11]=this.dw_facilite
this.Control[iCurrent+12]=this.dw_liste_facilite
this.Control[iCurrent+13]=this.cb_3
this.Control[iCurrent+14]=this.sle_recherche_article
this.Control[iCurrent+15]=this.st_5
this.Control[iCurrent+16]=this.st_6
this.Control[iCurrent+17]=this.rr_1
this.Control[iCurrent+18]=this.rr_2
end on

on w_gestion_facilite_saisie.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.sle_artae000)
destroy(this.sle_dimaeequ)
destroy(this.sle_dimaeart)
destroy(this.sle_artaeequ)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.dw_facilite)
destroy(this.dw_liste_facilite)
destroy(this.cb_3)
destroy(this.sle_recherche_article)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event ue_delete;/* <DESC>
      permet la suppression du faclite de saisie pour la/les references sélectionnées
   </DESC> */
// overwrite Ancestor script
integer l_nb_select
integer l_row

l_nb_select = dw_liste_facilite.fu_get_selected_count ()

IF l_nb_select = 0 THEN
	messagebox (this.title, "Vous devez sélectionner au moins une ligne", Information!,Ok!,1)
	dw_liste_facilite.SetFocus ()
	RETURN
END IF
 
// SUPPRESSION DES  ENREGISTREMENTS
l_row = dw_liste_facilite.GetSelectedRow (0)
dw_liste_facilite.SetItem(l_row,DBNAME_CODE_MAJ, 'A')
dw_liste_facilite.SetItem(l_row,DBNAME_DATE_CREATION, i_tr_sql.fnv_get_datetime ())
//DO UNTIL l_row = 0 
//	dw_liste_facilite.DeleteRow (l_row)
//	l_row = dw_liste_facilite.GetSelectedRow (0)
//LOOP	
//
dw_liste_facilite.Update ()
dw_liste_facilite.SetFocus ()
dw_liste_facilite.ScrollToRow(dw_liste_facilite.RowCount())

dw_1.Retrieve()
dw_facilite.retrieve()
postevent("ue_fileopen")
end event

event ue_fileopen;call super::ue_fileopen;/* <DESC> 
    Permet l'affichage du facilite de saisie associé a l'article et a la dimension selectionne
	 Ce declenche lors du double click sur la liste des dimensions
   <DESC> */
	
//dw_liste_facilite.DataObject = 'd_liste_facilite_saisie_par_ref_vente'
//dw_liste_facilite.SetTransObject (SQLCA)		
dw_liste_facilite.retrieve (is_article_vente,is_article_facilite)
dw_liste_facilite.setFilter(DBNAME_CODE_MAJ +" <> 'A'")
dw_liste_facilite.filter()
end event

event ue_search;call super::ue_search;/* <DESC>
  Declencher lors de la saisie de l'article de recherche et ceci au fur et a mesure de la saisie des caractères
  Permet de se potionner sur l'article correspondant à la saisie
   </DESC> */
long l_row

dw_1.Setsort("#1")
dw_facilite.Setsort("#1")

String ls_expression 
ls_expression = "Mid (" + DBNAME_ART + ",1," + String(len(sle_recherche_article.text)) + ") = '" + sle_recherche_article.text + "' "
l_row	=	dw_1.find (ls_expression, 1 , dw_1.RowCount())
If l_row > 0 then
	dw_1.ScrollToRow(l_row)
	dw_1.SelectRow(l_row,TRUE)
end if

ls_expression = "Mid (" + DBNAME_ART_EQUIV + ",1," + String(len(sle_recherche_article.text)) + ") = '" + sle_recherche_article.text + "' "
l_row	=	dw_facilite.find (ls_expression, 1 , dw_facilite.RowCount())
If l_row > 0 then
	dw_facilite.ScrollToRow(l_row)
	dw_facilite.SelectRow(l_row,TRUE)
end if
end event

type dw_1 from w_a_udim_su`dw_1 within w_gestion_facilite_saisie
integer x = 169
integer y = 804
integer width = 590
integer height = 1184
integer taborder = 60
string title = "Liste des articles"
string dataobject = "d_liste_article"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event dw_1::we_dwnprocessenter;call super::we_dwnprocessenter;
IF dw_1.GetRow () < dw_1.RowCount() THEN
		Send(Handle(This),256,9,Long(0,0))
		Return 1
END IF

If dw_1.GetColumnName () <> DBNAME_DIM_EQUIV then
		Send(Handle(This),256,9,Long(0,0))
		Return 1
End if

IF  		isNull(dw_1.Getitemstring(dw_1.rowcount(),   DBNAME_ART_EQUIV)) &
	AND   isNull(dw_1.Getitemstring(dw_1.rowcount(),DBNAME_DIM_EQUIV)) &
	AND   isNull(dw_1.Getitemstring(dw_1.rowcount(),DBNAME_ART)) 		&
	AND   isNull(dw_1.Getitemstring(dw_1.rowcount(),DBNAME_DIM)) THEN	
		dw_1.SetColumn (1)
		return
end if
	

if dw_1.GetItemStatus(dw_1.rowcount(), DBNAME_ART_EQUIV,Primary!) = NotModified! AND  &
   dw_1.GetItemStatus(dw_1.rowcount(), DBNAME_DIM_EQUIV,Primary!) = NotModified!  AND &
   dw_1.GetItemStatus(dw_1.rowcount(), DBNAME_ART,Primary!) = NotModified! AND	&
   dw_1.GetItemStatus(dw_1.rowcount(), DBNAME_DIM,Primary!) = NotModified! then		
		dw_1.fu_insert (0)
		dw_1.SetColumn (1)
		return
end if


parent.triggerevent("ue_save")
if i_b_update_status then
	dw_1.fu_insert (0)
	dw_1.SetColumn (1)
end if

end event

event dw_1::we_dwnkey;call super::we_dwnkey;// SELECTION DE LA LIGNE EN COURS
	IF KeyDown(KeyF5!) THEN
		dw_1.SelectRow(dw_1.GetRow(),TRUE)
	END IF

// DESELECTION DE LA LIGNE EN COURS
	IF KeyDown(KeyF6!) THEN
		dw_1.SelectRow(dw_1.GetRow(),FALSE)
	END IF
end event

event dw_1::clicked;call super::clicked;is_article_vente  = getitemstring(getrow(),1)
is_article_facilite = ''
parent.triggerEvent("ue_fileopen")
end event

type uo_statusbar from w_a_udim_su`uo_statusbar within w_gestion_facilite_saisie
integer x = 0
integer y = 2036
end type

type cb_1 from u_cba within w_gestion_facilite_saisie
integer x = 2825
integer y = 1732
integer width = 425
integer height = 96
integer taborder = 100
boolean bringtotop = true
string text = "&Suppression"
end type

event constructor;call super::constructor;// ------------------------------------------
// Déclenche l'évenement de la fenêtre
// ------------------------------------------
	fu_setevent("ue_delete")
	fu_set_microhelp("Suppression")
end event

type cb_2 from u_cba within w_gestion_facilite_saisie
integer x = 1714
integer y = 1736
integer width = 352
integer height = 96
integer taborder = 90
boolean bringtotop = true
string text = "&Fermer"
end type

event constructor;call super::constructor;// ------------------------------------------
// Déclenche l'évenement de la fenêtre
// ------------------------------------------
	fu_setevent("ue_cancel")

	fu_set_microhelp("Quitter")
end event

type sle_artae000 from u_slea within w_gestion_facilite_saisie
event ue_positionne_article ( )
integer x = 425
integer y = 176
integer width = 585
integer height = 72
integer taborder = 10
boolean bringtotop = true
textcase textcase = upper!
integer limit = 18
end type

event we_keydown;call super::we_keydown;if KeyDown(KeyEnter!) then
	parent.triggerEvent("ue_positionne_article")
end if
end event

type sle_dimaeequ from u_slea within w_gestion_facilite_saisie
integer x = 1047
integer y = 260
integer width = 288
integer height = 68
integer taborder = 40
boolean bringtotop = true
textcase textcase = upper!
integer limit = 8
end type

type sle_dimaeart from u_slea within w_gestion_facilite_saisie
integer x = 425
integer y = 260
integer width = 288
integer height = 72
integer taborder = 20
boolean bringtotop = true
textcase textcase = upper!
integer limit = 8
end type

type sle_artaeequ from u_slea within w_gestion_facilite_saisie
integer x = 1042
integer y = 180
integer width = 581
integer height = 68
integer taborder = 30
boolean bringtotop = true
textcase textcase = upper!
integer limit = 18
end type

type st_1 from statictext within w_gestion_facilite_saisie
integer x = 50
integer y = 184
integer width = 325
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 12632256
string text = "Article"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_gestion_facilite_saisie
integer x = 50
integer y = 276
integer width = 320
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 12632256
string text = "Dimension"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_gestion_facilite_saisie
integer x = 425
integer y = 108
integer width = 590
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 12632256
string text = "Vente"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_gestion_facilite_saisie
integer x = 1056
integer y = 108
integer width = 581
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 12632256
string text = "Facilité saisie"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_facilite from u_dw_udim within w_gestion_facilite_saisie
integer x = 841
integer y = 808
integer width = 571
integer height = 1184
integer taborder = 70
boolean bringtotop = true
string title = "Liste des dimensions"
string dataobject = "d_liste_article_facilite"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event clicked;call super::clicked;is_article_facilite  = getitemstring(getrow(),1)
is_article_vente = ''
parent.triggerEvent("ue_fileopen")
end event

type dw_liste_facilite from u_dw_udim within w_gestion_facilite_saisie
integer x = 1719
integer y = 56
integer width = 1819
integer height = 1652
integer taborder = 80
boolean bringtotop = true
boolean titlebar = true
string title = "Le Facilté de saisie"
string dataobject = "d_liste_facilite_saisie_par_ref_vente"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event we_dwnkey;call super::we_dwnkey;// SELECTION DE LA LIGNE EN COURS
	IF KeyDown(KeyF5!) THEN
		SelectRow(GetRow(),TRUE)
	END IF

// DESELECTION DE LA LIGNE EN COURS
	IF KeyDown(KeyF6!) THEN
		SelectRow(GetRow(),FALSE)
	END IF

// SELECTION DE TOUTES LES LIGNES 
	IF KeyDown(KeyF7!) THEN
		SelectRow(0,TRUE)
	END IF

// DESELECTION DE TOUTES LES LIGNES
	IF KeyDown(KeyF8!) THEN
		SelectRow(0,FALSE)
	END IF


end event

type cb_3 from u_cba within w_gestion_facilite_saisie
event ue_validation ( )
integer x = 562
integer y = 380
integer width = 521
integer height = 96
integer taborder = 50
boolean bringtotop = true
string text = "&Validation"
end type

event constructor;call super::constructor;// ------------------------------------------
// Déclenche l'évenement de la fenêtre
// ------------------------------------------
	fu_setevent("ue_validation")

	fu_set_microhelp("Valider la création")
end event

type sle_recherche_article from u_slea within w_gestion_facilite_saisie
integer x = 521
integer y = 680
integer width = 603
integer height = 80
integer taborder = 11
boolean bringtotop = true
textcase textcase = upper!
end type

event we_char;call super::we_char;// On va rechercher l'article sur la longueur saisie
parent.postevent("ue_search")
end event

type st_5 from statictext within w_gestion_facilite_saisie
integer x = 425
integer y = 624
integer width = 878
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 12632256
string text = "Recherche article dans le facilité"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_6 from statictext within w_gestion_facilite_saisie
integer x = 366
integer y = 44
integer width = 869
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
boolean underline = true
long textcolor = 16711680
long backcolor = 12632256
string text = "Création d~'un facilité de saisie"
alignment alignment = center!
long bordercolor = 16777215
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_gestion_facilite_saisie
long linecolor = 33554432
integer linethickness = 4
long fillcolor = 12632256
integer x = 46
integer y = 40
integer width = 1618
integer height = 460
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_gestion_facilite_saisie
long linecolor = 33554432
integer linethickness = 4
long fillcolor = 12632256
integer x = 87
integer y = 608
integer width = 1408
integer height = 1408
integer cornerheight = 40
integer cornerwidth = 46
end type

