$PBExportHeader$w_liste_reference_tarifs.srw
$PBExportComments$Permet l'affichage de la liste des références (informations stock et tarif)
forward
global type w_liste_reference_tarifs from w_a_pick_list_det
end type
type rr_1 from roundrectangle within w_liste_reference_tarifs
end type
type pb_ok from u_pba_ok within w_liste_reference_tarifs
end type
type pb_echap from u_pba_echap within w_liste_reference_tarifs
end type
type pb_changer from u_pba_chge_ref within w_liste_reference_tarifs
end type
type liste_prix_t from statictext within w_liste_reference_tarifs
end type
type devise_t from statictext within w_liste_reference_tarifs
end type
type sle_liste_prix from singlelineedit within w_liste_reference_tarifs
end type
type sle_devise from singlelineedit within w_liste_reference_tarifs
end type
type st_designation from statictext within w_liste_reference_tarifs
end type
end forward

global type w_liste_reference_tarifs from w_a_pick_list_det
string tag = "INFO_REFERENCE_TARIF"
integer x = 837
integer y = 512
integer width = 4681
integer height = 2304
string title = "Information référence & Tarif"
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
long backcolor = 12632256
boolean ib_statusbar_visible = true
event ue_chge_ref pbm_custom41
event ue_workflow ( )
rr_1 rr_1
pb_ok pb_ok
pb_echap pb_echap
pb_changer pb_changer
liste_prix_t liste_prix_t
devise_t devise_t
sle_liste_prix sle_liste_prix
sle_devise sle_devise
st_designation st_designation
end type
global w_liste_reference_tarifs w_liste_reference_tarifs

type variables
String is_sql_origine_article
String is_sql_origine_dimension
Str_pass  i_str_pass_specifique
String is_fenetre_origine = BLANK
String is_marche
end variables

forward prototypes
public subroutine fw_retrieve_article ()
public subroutine fw_controle_parametre ()
end prototypes

event ue_chge_ref;/* <DESC>
     Permet d'afficher la fenetre de sélection des références
	  a affiché en lui passant les élements tarifs par défaut à afficher.
	  En retour de la sélection, extraction des références à afficher.
   </DESC> */
//
// DECLARATION DES VARIABLE LOCALES
Long			l_retrieve
Str_pass		str_work

str_work.s[4] = i_str_pass_specifique.s[4]
str_work.s[5] = i_str_pass_specifique.s[5]
str_work.s[6] = i_str_pass_specifique.s[6]

str_work.b[1] = i_str_pass_specifique.b[1]
// SELECTION DES CRITERES
OpenWithParm (w_sel_ref, str_work)
str_work = Message.fnv_get_str_pass()
Message.fnv_clear_str_pass()
//
//
//// TRAITEMENT SELON L'ACTION CHOISIE
if str_work.s_action = ACTION_CANCEL then
	IF dw_pick.GetRow() = 0 THEN
			This.TriggerEvent ("ue_cancel")
	ELSE
			dw_pick.SetFocus()
	END IF
	return
end if

i_str_pass_specifique.s[1] = str_work.s[1]
i_str_pass_specifique.s[2] = str_work.s[2]
i_str_pass_specifique.s[3] = str_work.s[3]
i_str_pass_specifique.s[4] = str_work.s[4]
i_str_pass_specifique.s[5] = str_work.s[5]
i_str_pass_specifique.s[6] = str_work.s[6]
//i_str_pass_specifique.s[7] = str_work.s[7]

sle_liste_prix.text = str_work.s[5]
sle_devise.text = str_work.s[6]

fw_retrieve_article()

end event

event ue_workflow();/* <DESC>
    Cet evenement est appelé lors de la sélection d'une option dans le menu alors que cette
	 fenetre est la fenetre active et va lancer le workflow manager pour effectuer l'enchainement.
</DESC> */
g_nv_workflow_manager.fu_check_workflow(FENETRE_REFERENCE_TARIF, i_str_pass)
g_nv_workflow_manager.fu_set_fenetre_origine( DONNEE_VIDE)
end event

public subroutine fw_retrieve_article ();/* <DESC>
	  
	  Extraction de la liste des Articles et des dimensions pour le premier article
	  de la liste.
   </DESC> */

dw_pick.setTransObject(sqlca)

if dw_pick.retrieve(i_str_pass_specifique.s[1] + "%", i_str_pass_specifique.s[3] + "%",g_nv_come9par.get_code_langue( ) ) = -1 then
		f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
end if

if dw_pick.RowCount() = 0 then
	This.TriggerEvent ("ue_chge_ref")
	return
end if

// extraction du tarif pour mettre à jour les infos au niveau de l'article
datastore ds_tarif 
ds_tarif = create datastore
ds_tarif.Dataobject = "d_dimension_tarif"
ds_tarif.SetTransObject (i_tr_sql)

Long l_row

for l_row = 1 to dw_pick.RowCount() 
	ds_tarif.retrieve(dw_pick.GetItemString (l_row, DBNAME_ARTICLE),i_str_pass_specifique.s[5],i_str_pass_specifique.s[6])
	if ds_tarif.RowCount() = 0 then
   	     dw_pick.setItem(l_row, DBNAME_PRIX_ARTICLE,0)		
   	     dw_pick.setItem(l_row, DBNAME_UNIPAR,0)				  
	else
		dw_pick.setItem(l_row, DBNAME_PRIX_ARTICLE, ds_tarif.getItemDecimal(1,DBNAME_PRIX_ARTICLE))
     	dw_pick.setItem(l_row, DBNAME_UNIPAR, ds_tarif.getItemDecimal(1,DBNAME_UNIPAR))			  		
	end if
next

dw_pick.SetFocus ()
dw_pick.triggerEvent("rowfocuschanged")

end subroutine

public subroutine fw_controle_parametre ();/* <DESC> 
     Préparation de la structure des paramètres qui sera passée   à la fenêtre de sélection en 
	  fonction de l'origine de l'appel de la fenêtre.
	  Les éléments tarfis sont soit ceux de la commande, du client ou  du visiteur
   </DESC> */
	
// Information provenant de la commande
if upperBound(i_str_pass.po,2) > 0 then
	nv_commande_object l_commande
	l_commande = i_str_pass.po[2]
	i_str_pass_specifique.s[1] = DONNEE_VIDE
	i_str_pass_specifique.s[2] = DONNEE_VIDE
	i_str_pass_specifique.s[3] = DONNEE_VIDE
	i_str_pass_specifique.s[4] = l_commande.fu_get_marche()
	i_str_pass_specifique.s[5] = l_commande.fu_get_liste_prix()
	i_str_pass_specifique.s[6] = l_commande.fu_get_devise()
	i_str_pass_specifique.b[1] = true	
	return
end if

// Information provenant du client
if upperBound(i_str_pass.po,1) > 0 then
     nv_client_object l_client
	l_client = i_str_pass.po[1]	  
	i_str_pass_specifique.s[1] = DONNEE_VIDE
	i_str_pass_specifique.s[2] = DONNEE_VIDE
	i_str_pass_specifique.s[3] = DONNEE_VIDE
	i_str_pass_specifique.s[4] = l_client.fu_get_code_marche()
	i_str_pass_specifique.s[5] = l_client.fu_get_liste_prix()
	i_str_pass_specifique.s[6] = l_client.fu_get_code_devise()
	i_str_pass_specifique.b[1] = true	
	return
end if


if upperBound(i_str_pass.s,1) > 0 then
	i_str_pass_specifique = i_str_pass
	return
end if

i_str_pass.s_action = ACTION_OK

// Recherche du tarif de l'article
i_str_pass_specifique.s[1] = DONNEE_VIDE
i_str_pass_specifique.s[2] = DONNEE_VIDE
i_str_pass_specifique.s[3] = DONNEE_VIDE
i_str_pass_specifique.s[4] = g_nv_come9par.get_code_marche()
i_str_pass_specifique.s[5] = g_nv_come9par.get_liste_prix()
i_str_pass_specifique.s[6] = g_nv_come9par.get_devise()	
i_str_pass_specifique.b[1] = true
	
end subroutine

event ue_init;call super::ue_init;/* <DESC> 
    Initialisation des paramétres tarifs à partir de ceux receptionnés.
	 L'oringe des élements tarifs (liste prix,devise) sont soit ceux
	 du visiteur si l'on vient directement du menu, sinon ceux de la
	 commande si l'on vient par la saisie de commande. 
	 
	 Sauvegarde de la syntaxe SQL des datawindow Article et Dimension
	 qui sera utilisé pour completer la syntaxe avec les critères de 
	 sélection
   </DESC> */
fw_controle_parametre()

if i_str_pass_specifique.b[1] then
	pb_ok.visible = false
else
	i_str_pass_specifique.s[2] = DONNEE_VIDE
end if

is_sql_origine_article 		    =    dw_pick.getSqlSelect()
is_sql_origine_dimension 	= dw_1.getSqlSelect()

sle_liste_prix.text 	     = i_str_pass_specifique.s[5]
sle_devise.text 		= i_str_pass_specifique.s[6]
//is_marche = g_nv_come9par.get_code_marche()
is_marche = i_str_pass_specifique.s[4]

// INITIALISATION DES DATAWINDOW
dw_1.fu_set_selection_mode (1)

if not i_str_pass_specifique.b[1] then
	fw_retrieve_article()
else
	This.TriggerEvent ("ue_chge_ref")
end if



end event

event ue_cancel;/* <DESC>
      Permet de quitter la fenetre.
		Si l'appel de cette fenêtre n'a pas été effectué par le menu
		   retour à la fenêtre d'origine
   </DESC> */
// OVERRIDE SCRIPT ANCESTOR

i_str_pass_specifique.s_action = ACTION_CANCEL
Message.fnv_set_str_pass(i_str_pass_specifique)

if trim(is_fenetre_origine) <> DONNEE_VIDE then
	g_s_fenetre_destination = is_fenetre_origine
	triggerEvent("ue_workflow")
end if	
Close (This)
end event

event ue_ok;/* <DESC>
    Permet de valider la sélection de la dimension et de retouner la sélection
	 à la saisie de commande.
	 Les éléments retournées sont la dimension, le tarif
   </DESC> */
	
// Override Ancestor Script
// DECLARATION DES VARIABLES LOCALES
Long		l_row

// REPRISE DU CODE ARTICLE SELECTIONNE
l_row = dw_1.GetRow ()

IF l_row = 0 THEN
	messagebox (This.title,g_nv_traduction.get_traduction(SELECTION_OBLIGATOIRE), Information!,Ok!,1)
	RETURN
end if

i_str_pass_specifique.s[1] = dw_pick.GetItemString (dw_pick.GetRow(), DBNAME_ARTICLE)
i_str_pass_specifique.s[2] = dw_1.GetItemString (dw_1.GetRow(), DBNAME_DIMENSION)
i_str_pass_specifique.d[1] = dw_1.GetItemDecimal (dw_1.GetRow(), DBNAME_PRIX_ARTICLE)
i_str_pass_specifique.d[2] = dw_1.GetItemDecimal (dw_1.GetRow(),DBNAME_UNIPAR)

if isNull(i_str_pass_specifique.d[1]) then
	i_str_pass_specifique.d[1] = 0
end if

if not isNull(i_str_pass_specifique.d[2]) and i_str_pass_specifique.d[2] > 0 then
	i_str_pass_specifique.d[1] = Round(dw_1.GetItemDecimal (dw_1.GetRow(), DBNAME_PRIX_ARTICLE) / &
 	                        								 dw_1.getItemDecimal(1, DBNAME_UNIPAR),2)
end if

i_str_pass_specifique.s_action = ACTION_OK
Message.fnv_set_str_pass(i_str_pass_specifique)

IF not i_str_pass.b[1] then
	Close (this)
	return	
end if

if trim(is_fenetre_origine) <> DONNEE_VIDE then
	g_s_fenetre_destination = is_fenetre_origine
	triggerEvent("ue_workflow")
end if

Close (This)

end event

event ue_retrieve;/* <DESC> 
    Permet d'extraire les dimensions de l'article sélectionné.
	 Sur chacune des dimensions, on report le tarif et le Par qui se trouve
	 sur la ligne de l'article sélectionné.
   </DESC> */
// DECLARATION DES VARIABLES LOCALES
Long		l_retrieve
Long		l_row
String 	ls_sql

// RECHERCHE DE L'ARTICLE SELECTIONNE
l_row = dw_pick.GetRow ()
IF l_row = 0 THEN
	RETURN
end if

st_designation.text = dw_pick.getItemString(l_row,DBNAME_DESCRIPTION_REF)

dw_1.Reset ()
dw_1.setTransObject(sqlca)

if dw_1.Retrieve (dw_pick.GetItemString (l_row, DBNAME_ARTICLE), i_str_pass_specifique.s[2] + "%") = -1 then	
	f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
end if


long l_row_dimension
for l_row_dimension = 1 to dw_1.RowCount()
	dw_1.setItem(l_row_dimension, DBNAME_PRIX_ARTICLE, dw_pick.getItemDecimal(dw_pick.getRow(),DBNAME_PRIX_ARTICLE))
	dw_1.setItem(l_row_dimension, DBNAME_UNIPAR, dw_pick.getItemDecimal(dw_pick.getRow(),DBNAME_UNIPAR))	
next

// extraction date de ispo ciale pour mettre à jour les infos au niveau de l'article
datastore ds_dispo
ds_dispo = create datastore
ds_dispo.Dataobject = "d_dtdispo_ciale"
ds_dispo.SetTransObject (i_tr_sql)

for l_row = 1 to dw_1.RowCount() 
	ds_dispo.retrieve (dw_1.getitemString(l_row,"artae000"),dw_1.getitemString(l_row,"dimaeart"),is_marche)
	if ds_dispo.Rowcount() = 1 then
             dw_1.setItem(l_row, "dtdispo_ciale",mid(string(ds_dispo.GetItemDatetime(1,1)),1,10))
   end if
next
end event

event key;call super::key;/* <DESC>
      Permet de trapper les touches de fonction activées et déclencher l'évènement associé
	à la touche.
	  F11 = Pour valider la sélection de la dimension 
   </DESC> */

	IF KeyDown (KeyF11!) THEN
		This.TriggerEvent ("ue_ok")
	END IF

end event

on w_liste_reference_tarifs.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.pb_ok=create pb_ok
this.pb_echap=create pb_echap
this.pb_changer=create pb_changer
this.liste_prix_t=create liste_prix_t
this.devise_t=create devise_t
this.sle_liste_prix=create sle_liste_prix
this.sle_devise=create sle_devise
this.st_designation=create st_designation
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.pb_ok
this.Control[iCurrent+3]=this.pb_echap
this.Control[iCurrent+4]=this.pb_changer
this.Control[iCurrent+5]=this.liste_prix_t
this.Control[iCurrent+6]=this.devise_t
this.Control[iCurrent+7]=this.sle_liste_prix
this.Control[iCurrent+8]=this.sle_devise
this.Control[iCurrent+9]=this.st_designation
end on

on w_liste_reference_tarifs.destroy
call super::destroy
destroy(this.rr_1)
destroy(this.pb_ok)
destroy(this.pb_echap)
destroy(this.pb_changer)
destroy(this.liste_prix_t)
destroy(this.devise_t)
destroy(this.sle_liste_prix)
destroy(this.sle_devise)
destroy(this.st_designation)
end on

event open;call super::open;/* <DESC>
      Sauvegarde de la fenêtre à l'origine de l'ouverture
   </DESC> */
is_fenetre_origine = i_str_pass.s[7]


end event

event closequery;/* <DESC>
     Overwrite du script
   </DESC> */
// Overwrite
end event

type uo_statusbar from w_a_pick_list_det`uo_statusbar within w_liste_reference_tarifs
end type

type dw_1 from w_a_pick_list_det`dw_1 within w_liste_reference_tarifs
string tag = "A_TRADUIRE"
integer x = 677
integer y = 576
integer width = 3662
integer height = 1284
integer taborder = 30
string dataobject = "d_liste_dimension"
boolean vscrollbar = true
end type

event dw_1::rowfocuschanged;
// ---------------------------------
// RETRIEVE DE LA DTW NUANCE
// ---------------------------------
//	Parent.TriggerEvent ("ue_fileopen")
this.SelectRow (0, FALSE)
this.SelectRow (getRow(), TRUE)
end event

event dw_1::we_dwnkey;call super::we_dwnkey;/* Appel de la fonction de controle des touches de fonction autorisées dans l'application
et de déclencher l'évènement KEY de la fenêtre qui contient le code correspond à la
touche.
*/
	f_key(Parent)

end event

type dw_pick from w_a_pick_list_det`dw_pick within w_liste_reference_tarifs
string tag = "A_TRADUIRE"
integer x = 50
integer y = 36
integer width = 585
integer height = 1820
integer taborder = 10
string dataobject = "d_liste_article"
boolean vscrollbar = true
end type

event dw_pick::getfocus;call super::getfocus;
// VISUALISATION DE LA RECEPTION DU FOCUS
	This.BorderStyle = StyleLowered!
end event

event dw_pick::we_dwnkey;call super::we_dwnkey;/* Appel de la fonction de controle des touches de fonction autorisées dans l'application
et de déclencher l'évènement KEY de la fenêtre qui contient le code correspond à la
touche.
*/
	f_key(Parent)

end event

event dw_pick::losefocus;call super::losefocus;
// VISUALISATION DE LA PERTE DU FOCUS
	This.BorderStyle = StyleBox!
end event

event dw_pick::rowfocuschanged;
this.SelectRow(0,FALSE)
this.SelectRow ( this.GetRow (), TRUE)

parent.TriggerEvent ("ue_retrieve")
		
end event

type rr_1 from roundrectangle within w_liste_reference_tarifs
integer linethickness = 4
long fillcolor = 12632256
integer x = 951
integer y = 96
integer width = 1829
integer height = 224
integer cornerheight = 40
integer cornerwidth = 46
end type

type pb_ok from u_pba_ok within w_liste_reference_tarifs
integer x = 448
integer y = 1904
integer width = 402
integer height = 172
integer taborder = 0
string text = "Valid. "
boolean default = false
string picturename = "C:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_echap from u_pba_echap within w_liste_reference_tarifs
integer x = 1623
integer y = 1904
integer width = 439
integer height = 172
integer taborder = 0
boolean cancel = false
string picturename = "C:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type pb_changer from u_pba_chge_ref within w_liste_reference_tarifs
integer x = 1056
integer y = 1904
integer width = 416
integer height = 172
integer taborder = 0
string text = "C&hange réf"
string picturename = "C:\appscir\Erfvmr_diva\Image\pbchgart.bmp"
end type

type liste_prix_t from statictext within w_liste_reference_tarifs
integer x = 1015
integer y = 144
integer width = 471
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Liste de prix :"
alignment alignment = right!
boolean focusrectangle = false
end type

type devise_t from statictext within w_liste_reference_tarifs
integer x = 1015
integer y = 236
integer width = 471
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Devise :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_liste_prix from singlelineedit within w_liste_reference_tarifs
integer x = 1550
integer y = 144
integer width = 274
integer height = 68
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean displayonly = true
end type

type sle_devise from singlelineedit within w_liste_reference_tarifs
integer x = 1550
integer y = 236
integer width = 279
integer height = 64
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean displayonly = true
end type

type st_designation from statictext within w_liste_reference_tarifs
string tag = "NO_TEXT"
integer x = 1051
integer y = 448
integer width = 1728
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean focusrectangle = false
end type

