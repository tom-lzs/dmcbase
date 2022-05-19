$PBExportHeader$w_gestion_minimum_cde.srw
$PBExportComments$Permet la gestion des minimum de commande
forward
global type w_gestion_minimum_cde from w_a_udim_su
end type
type cb_2 from u_cba within w_gestion_minimum_cde
end type
type sle_marche from u_slea within w_gestion_minimum_cde
end type
type sle_devise from u_slea within w_gestion_minimum_cde
end type
type st_1 from statictext within w_gestion_minimum_cde
end type
type st_2 from statictext within w_gestion_minimum_cde
end type
type st_4 from statictext within w_gestion_minimum_cde
end type
type dw_devise from u_dw_udim within w_gestion_minimum_cde
end type
type dw_liste_mini_cde from u_dw_udim within w_gestion_minimum_cde
end type
type cb_3 from u_cba within w_gestion_minimum_cde
end type
type sle_mini_cde from u_sle_num within w_gestion_minimum_cde
end type
type cb_4 from u_cba within w_gestion_minimum_cde
end type
type rr_1 from roundrectangle within w_gestion_minimum_cde
end type
end forward

global type w_gestion_minimum_cde from w_a_udim_su
integer width = 4343
integer height = 2024
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = child!
windowstate windowstate = maximized!
long backcolor = 12632256
event ue_marche ( )
event ue_devise ( )
event ue_validation ( )
cb_2 cb_2
sle_marche sle_marche
sle_devise sle_devise
st_1 st_1
st_2 st_2
st_4 st_4
dw_devise dw_devise
dw_liste_mini_cde dw_liste_mini_cde
cb_3 cb_3
sle_mini_cde sle_mini_cde
cb_4 cb_4
rr_1 rr_1
end type
global w_gestion_minimum_cde w_gestion_minimum_cde

type variables

end variables

event ue_marche();/* <DESC>
    Alimentaion de la zone de saisie Marche a partir du marche selectionne
	 Declencher lors du double click sur la liste des marches
	 </DESC> */
sle_marche.text = dw_1.getItemString(dw_1.getRow(),DBNAME_CODE_MARCHE)

end event

event ue_devise();/* <DESC>
	Initialisation de la devise sélectionnée dans la zone de saisie
	</DESC> */
sle_devise.text = dw_devise.getItemString(dw_devise.getRow(),DBNAME_CODE_DEVISE)

end event

event ue_validation();/* <DESC>
    Permet la validaiton de la saisie 
	<LI> Le marche , la devise et le minimum de commande sont obligatoires
	<LI> Le marche doit être existant
	<LI> La devise doit etre existante
	<LI> Si minimum deja existant pour le marche et la devise , mise à jour du mninmum de commande
	sinon creation d'une nouvelle ligne
	 </DESC> */
// Validation de la saisie
double ld_mini_cde
long	 ll_row
datastore ds_controle
ds_controle = CREATE datastore
ds_controle.dataobject = "d_liste_minimum_cde"
ds_controle.SetTransObject(i_tr_sql)

if isNull(sle_marche.text ) or trim(sle_marche.text) = "" then
	messagebox (this.title, "Marché obligatoire", Information!,Ok!,1)	
	sle_marche.SetFocus ()
	RETURN	
end if

if isNull(sle_devise.text ) or trim(sle_devise.text) = "" then
	messagebox (this.title, "Devise obligatoire", Information!,Ok!,1)	
	sle_devise.SetFocus ()
	RETURN	
end if

if isNull(sle_mini_cde.text ) or trim(sle_mini_cde.text) = "" then
	messagebox (this.title, "Minimun de commande obligatoire", Information!,Ok!,1)	
	sle_mini_cde.SetFocus ()
	RETURN	
end if

ld_mini_cde = double(sle_mini_cde.text)
if ld_mini_cde = 0 then
	messagebox (this.title, "Minimun de commande obligatoire", Information!,Ok!,1)	
	sle_mini_cde.SetFocus ()
	RETURN		
end if
// Controle du code marche et de la devise
ll_row = dw_1.find (DBNAME_CODE_MARCHE + " = '" + sle_marche.text + "'" ,1, dw_1.rowCount())
if ll_row = 0 then
	messagebox (this.title, "Marché inexistant", Information!,Ok!,1)	
	sle_marche.SetFocus ()
	RETURN	
end if

ll_row = dw_devise.find (DBNAME_CODE_DEVISE + " = '" + sle_devise.text + "'" ,1, dw_devise.rowCount())
if ll_row = 0 then
	messagebox (this.title, "Devise inexistante", Information!,Ok!,1)	
	sle_marche.SetFocus ()
	RETURN	
end if

// Control si existence du minimum de cde pour le marche et devise
if ds_controle.retrieve(sle_marche.text, sle_devise.text +'%') > 0 then
	ds_controle.SetItem(1,DBNAME_MINIMUM_CDE, double(sle_mini_cde.text))
	ds_controle.update()
else
	ds_controle.insertRow(0)
	ds_controle.setItem(1, DBNAME_DATE_CREATION ,i_tr_sql.fnv_get_datetime ())
	ds_controle.setItem(1, DBNAME_CODE_MAJ ,"C")
	ds_controle.setItem(1, DBNAME_CODE_MARCHE ,sle_marche.text)
	ds_controle.setItem(1, DBNAME_CODE_DEVISE, sle_devise.text)
	ds_controle.setItem(1, DBNAME_MINIMUM_CDE, double(sle_mini_cde.text))
end if
ds_controle.update()

for ll_row = 1 to dw_1.RowCount()
	if dw_1.getItemString(ll_row, DBNAME_CODE_MARCHE) = sle_marche.text then
		dw_1.scrollToRow(ll_row)
		dw_1.setRow(ll_row)
		exit
	end if
next

triggerEvent("ue_fileopen")
	

end event

event ue_init;call super::ue_init;/* <DESC>
   Initialisation de l'affichage de la fenetre en affichant la liste des articles et des devises
	et affichage des minimum de commande defini pour le premier article de la liste
   </DESC> */
integer l_retrieve

dw_1.fu_set_selection_mode (1)
dw_devise.fu_set_selection_mode (1)

dw_devise.setTransObject(i_tr_sql)
dw_devise.fu_set_selection_mode (1)

dw_liste_mini_cde.setTransObject(i_tr_sql)
dw_1.retrieve()
dw_devise.retrieve()

if dw_1.RowCount() > 0 then
	dw_1.setRow(1)
	triggerEvent("ue_fileopen")
end if


end event

on w_gestion_minimum_cde.create
int iCurrent
call super::create
this.cb_2=create cb_2
this.sle_marche=create sle_marche
this.sle_devise=create sle_devise
this.st_1=create st_1
this.st_2=create st_2
this.st_4=create st_4
this.dw_devise=create dw_devise
this.dw_liste_mini_cde=create dw_liste_mini_cde
this.cb_3=create cb_3
this.sle_mini_cde=create sle_mini_cde
this.cb_4=create cb_4
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.sle_marche
this.Control[iCurrent+3]=this.sle_devise
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.dw_devise
this.Control[iCurrent+8]=this.dw_liste_mini_cde
this.Control[iCurrent+9]=this.cb_3
this.Control[iCurrent+10]=this.sle_mini_cde
this.Control[iCurrent+11]=this.cb_4
this.Control[iCurrent+12]=this.rr_1
end on

on w_gestion_minimum_cde.destroy
call super::destroy
destroy(this.cb_2)
destroy(this.sle_marche)
destroy(this.sle_devise)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_4)
destroy(this.dw_devise)
destroy(this.dw_liste_mini_cde)
destroy(this.cb_3)
destroy(this.sle_mini_cde)
destroy(this.cb_4)
destroy(this.rr_1)
end on

event ue_delete;/* <DESC>
    Permet la suppression du minimum de commande pour la/les lignes selectionnees.
   </DESC> */
// overwrite Ancestor script
integer l_nb_select
integer l_row

l_nb_select = dw_liste_mini_cde.fu_get_selected_count ()

IF l_nb_select = 0 THEN
	messagebox (this.title, "Vous devez sélectionner au moins une ligne", Information!,Ok!,1)
	dw_liste_mini_cde.SetFocus ()
	RETURN
END IF

// SUPPRESSION DES  ENREGISTREMENTS
l_row = dw_liste_mini_cde.GetSelectedRow (0)
DO UNTIL l_row = 0 
	dw_liste_mini_cde.DeleteRow (l_row)
	l_row = dw_liste_mini_cde.GetSelectedRow (0)
LOOP	

dw_liste_mini_cde.Update ()
dw_liste_mini_cde.SetFocus ()
dw_liste_mini_cde.ScrollToRow(dw_liste_mini_cde.RowCount())
end event

event ue_fileopen;call super::ue_fileopen;/* <DESC>
    Permet d'afficher la liste des minimum de commandes définis pour le marche sélectionné
	 Declencher lors du click sur la liste des articles
   </DESC> */
dw_liste_mini_cde.retrieve(dw_1.getItemString(dw_1.getRow(),DBNAME_CODE_MARCHE),'%')
end event

type dw_1 from w_a_udim_su`dw_1 within w_gestion_minimum_cde
integer x = 32
integer y = 604
integer width = 997
integer height = 1080
integer taborder = 60
boolean titlebar = true
string title = "                        Liste des marchés"
string dataobject = "d_liste_marche"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event dw_1::we_dwnkey;call super::we_dwnkey;// SELECTION DE LA LIGNE EN COURS
	IF KeyDown(KeyF5!) THEN
		dw_1.SelectRow(dw_1.GetRow(),TRUE)
	END IF

// DESELECTION DE LA LIGNE EN COURS
	IF KeyDown(KeyF6!) THEN
		dw_1.SelectRow(dw_1.GetRow(),FALSE)
	END IF
end event

event dw_1::doubleclicked;call super::doubleclicked;parent.triggerEvent("ue_marche")


end event

event dw_1::clicked;call super::clicked;parent.triggerEvent("ue_fileopen")
end event

type uo_statusbar from w_a_udim_su`uo_statusbar within w_gestion_minimum_cde
end type

type cb_2 from u_cba within w_gestion_minimum_cde
integer x = 864
integer y = 1796
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

type sle_marche from u_slea within w_gestion_minimum_cde
event ue_positionne_article ( )
integer x = 594
integer y = 192
integer width = 293
integer height = 72
integer taborder = 10
boolean bringtotop = true
textcase textcase = upper!
integer limit = 3
end type

event we_keydown;call super::we_keydown;if KeyDown(KeyEnter!) then
	parent.triggerEvent("ue_positionne_article")
end if
end event

type sle_devise from u_slea within w_gestion_minimum_cde
integer x = 594
integer y = 276
integer width = 288
integer height = 72
integer taborder = 20
boolean bringtotop = true
textcase textcase = upper!
integer limit = 4
end type

type st_1 from statictext within w_gestion_minimum_cde
integer x = 219
integer y = 200
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
string text = "Marché :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_gestion_minimum_cde
integer x = 219
integer y = 292
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
string text = "Devise :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within w_gestion_minimum_cde
integer x = 1138
integer y = 188
integer width = 613
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
string text = "Minimum de commande"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_devise from u_dw_udim within w_gestion_minimum_cde
integer x = 1038
integer y = 604
integer width = 1111
integer height = 1084
integer taborder = 70
boolean bringtotop = true
boolean titlebar = true
string title = "                                      Liste des devises"
string dataobject = "d_liste_devise"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;call super::doubleclicked;parent.triggerEvent("ue_devise") 
end event

type dw_liste_mini_cde from u_dw_udim within w_gestion_minimum_cde
integer x = 2181
integer y = 60
integer width = 1339
integer height = 1632
integer taborder = 80
boolean bringtotop = true
boolean titlebar = true
string title = "                   Minimum de cde existant"
string dataobject = "d_liste_minimum_cde"
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

type cb_3 from u_cba within w_gestion_minimum_cde
event ue_validation ( )
integer x = 731
integer y = 396
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

type sle_mini_cde from u_sle_num within w_gestion_minimum_cde
integer x = 1106
integer y = 256
integer width = 690
integer height = 76
integer taborder = 11
boolean bringtotop = true
end type

type cb_4 from u_cba within w_gestion_minimum_cde
integer x = 2624
integer y = 1788
integer width = 425
integer height = 96
integer taborder = 110
boolean bringtotop = true
string text = "&Suppression"
end type

event constructor;call super::constructor;// ------------------------------------------
// Déclenche l'évenement de la fenêtre
// ------------------------------------------
	fu_setevent("ue_delete")
	fu_set_microhelp("Suppression")
end event

type rr_1 from roundrectangle within w_gestion_minimum_cde
long linecolor = 33554432
integer linethickness = 4
long fillcolor = 12632256
integer x = 215
integer y = 88
integer width = 1618
integer height = 428
integer cornerheight = 40
integer cornerwidth = 46
end type

