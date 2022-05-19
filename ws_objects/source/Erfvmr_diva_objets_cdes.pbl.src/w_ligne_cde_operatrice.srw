$PBExportHeader$w_ligne_cde_operatrice.srw
$PBExportComments$Saisie et modification des lignes de commande en mode rapide
forward
global type w_ligne_cde_operatrice from w_a_udim_su
end type
type r_2 from rectangle within w_ligne_cde_operatrice
end type
type pb_ok from u_pba_ok within w_ligne_cde_operatrice
end type
type pb_echap from u_pba_echap within w_ligne_cde_operatrice
end type
type pb_supprim from u_pba_supprim within w_ligne_cde_operatrice
end type
type dw_mas from u_dwa within w_ligne_cde_operatrice
end type
type pb_fin_page from u_pba_fin_page within w_ligne_cde_operatrice
end type
type sle_num_page from u_sle_num within w_ligne_cde_operatrice
end type
type numaepag_10_t from statictext within w_ligne_cde_operatrice
end type
type cbx_toutes from u_cbxa within w_ligne_cde_operatrice
end type
type cb_aller from u_cba within w_ligne_cde_operatrice
end type
type pb_art_nua from u_pba within w_ligne_cde_operatrice
end type
type pb_nuance from u_pba within w_ligne_cde_operatrice
end type
end forward

global type w_ligne_cde_operatrice from w_a_udim_su
string tag = "SAISIE_MODE_OPERATRICE"
integer x = 0
integer y = 0
integer width = 3182
integer height = 2288
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = child!
windowstate windowstate = maximized!
long backcolor = 12632256
boolean ib_statusbar_visible = true
event ue_validation pbm_custom58
event ue_workflow pbm_custom56
event ue_appro ( )
event ue_fin_page ( )
event ue_changer_page ( )
event ue_article_dimension pbm_custom40
r_2 r_2
pb_ok pb_ok
pb_echap pb_echap
pb_supprim pb_supprim
dw_mas dw_mas
pb_fin_page pb_fin_page
sle_num_page sle_num_page
numaepag_10_t numaepag_10_t
cbx_toutes cbx_toutes
cb_aller cb_aller
pb_art_nua pb_art_nua
pb_nuance pb_nuance
end type
global w_ligne_cde_operatrice w_ligne_cde_operatrice

type variables
nv_commande_object 	i_nv_commande_object
nv_ligne_cde_object 	i_nv_ligne_cde_object
boolean				 	i_b_mode_dimension 			= false
n_tooltip_mgr itooltip

boolean		i_b_controle = false
boolean     i_b_delete_ligne = false

// 1 ere colonne dans l'odre de tabulation
String		i_s_tab_one
Double     i_d_page_mini = 0
Double     i_d_page_maxi = 999

end variables

forward prototypes
public subroutine fw_suppression_ligne_qte_zero ()
public subroutine fw_clear_lignes ()
end prototypes

event ue_validation;/* <DESC>
     Validation des lignes de commande en fin de page en en validation.
	<LI>Cette validation s'effectue par la fenetre d'attent à laquelle il est necessaire de passer les paramètres suivant:
	     Object commande, Object ligne de commande, la datawindow des lignes de commandes, le n° de commande
		 et le mode de saisie positionné à rapide
	<LI> En fin de validation , toutes les lignes dont le code mise à jour a été positionné
	à supprimer, seront supprimées physiquement. Le positionnement des lignes de
	commande supprimées est effectué lors du contrôle des doublons
   </DESC> */
// ==================================================================================
// Validation des lignes de commande
// ===================================================================================
Boolean lb_validation_ok
Boolean lb_lignes_supprimees = false
setPointer(Hourglass!)

// Suppression des lignes de commande dont la quantite est = 0
fw_suppression_ligne_qte_zero()
IF dw_1.RowCount () = 0 THEN
	messagebox (this.title, g_nv_traduction.get_traduction(PAS_LIGNE_SAISIE) + "~r " + g_nv_traduction.get_traduction(ECHAP), & 
					Information!,Ok!,1)
	dw_1.InsertRow (0)
	dw_1.SetFocus ()
	RETURN -1
END IF

Str_pass l_str_pass
l_str_pass.po[1] = i_nv_commande_object
l_str_pass.po[2] = i_nv_ligne_cde_object
l_str_pass.po[3] = dw_1
l_str_pass.s[1] = i_nv_commande_object.fu_get_numero_cde()
l_str_pass.s[2] = CODE_MODE_RAPIDE

openwithparm(w_fenetre_attente,l_str_pass)
l_str_pass = Message.fnv_get_str_pass()
Message.fnv_clear_str_pass()

lb_validation_ok = l_str_pass.b[1]

i_nv_commande_object.fu_positionne_cde_a_valider()

long ll_row 
ll_row = dw_1.RowCount()
do while ll_row > 0
	if dw_1.getItemString(ll_row,DBNAME_CODE_MAJ) =  CODE_SUPPRESSION then
		dw_1.deleteRow(ll_row)
		lb_lignes_supprimees = true
	end if
	ll_row --
loop

if lb_lignes_supprimees then
	dw_1.update()
	dw_1.setRow(dw_1.insertRow(0)) 
end if

SetPointer(Arrow!)

if lb_validation_ok then
	return 0
else
	return -1
end if
end event

event ue_workflow;/* <DESC>
    Cet evenement est appelé lors de la sélection d'une option dans le menu alors que cette
	 fenetre est la fenetre active et va lancer le workflow manager pour effectuer l'enchainement.
</DESC> */
dw_1.TriggerEvent (RowFocusChanged!)
dw_1.Update (TRUE)

String ls_return
ls_return = g_nv_workflow_manager.fu_check_workflow(FENETRE_LIGNE_CDE_OPERATRICE, i_str_pass)
if ls_return <> ACTION_CANCEL then
	close(this)
end if
end event

event ue_fin_page();/* <DESC>
    Permet de valider la saisie de la page encours et de rafraichir la page après contrôle
   </DESC> */
i_d_page_mini = i_nv_ligne_cde_object.fu_get_max_page()
i_d_page_maxi = i_d_page_mini

i_nv_ligne_cde_object.fu_incremente_num_page()
if triggerevent("ue_validation") = 0 then
	fw_clear_lignes()
else
	 dw_1.Retrieve (i_nv_commande_object.fu_get_numero_cde(),i_d_page_mini,i_d_page_maxi) 
end if

dw_1.setFocus()


end event

event ue_changer_page();/* <DESC>
     Permet de  rechercher une page dans le cadre de gestion des pages
	  ou d'afficher toutes les pages et ceci aprés avoir effectuer le contrôle
	  de la saisie des paramétres
   </DESC> */
	
Double ld_page_mini
Double ld_page_maxi
Double ld_num_page_defaut
Long   ll_row

ld_page_mini = 0
ld_page_maxi = 999
ld_num_page_defaut = i_nv_ligne_cde_object.fu_get_max_page()

if isNull(sle_num_page.text) and & 
   sle_num_page.text = String (0) and &
	not cbx_toutes.checked then
	messageBox(this.title,g_nv_traduction.get_traduction(SEL_OPTION),information!,ok!)
	return
end if

if sle_num_page.text > String(i_nv_ligne_cde_object.fu_get_max_page()) then
	messageBox(this.title,g_nv_traduction.get_traduction( PAGE_ERRONE),information!,ok!)
	return
end if

if not cbx_toutes.checked then
	ld_page_mini = Double(sle_num_page.text)
	ld_page_maxi = Double(sle_num_page.text)
	ld_num_page_defaut = Double(sle_num_page.text)
end if

if dw_1.Retrieve (i_nv_commande_object.fu_get_numero_cde(),ld_page_mini,ld_page_maxi) = -1 then
	f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
end if

dw_1.Modify (DBNAME_CODE_PAGE + ".Initial ='" + String(ld_num_page_defaut) + "'")
ll_row = dw_1.insertRow(0)
dw_1.ScrollToRow(ll_row)	
dw_1.SetColumn (i_s_tab_one)
dw_1.setFocus()
end event

event ue_article_dimension;/* <DESC> 
Passage de la saisie Article,Dimension et inversement
 Ceci permet de forcer le positionnement du curseur lors de la création 
 d'une nouvelle sur l'article ou la dimension
</DESC> */
IF i_b_mode_dimension THEN
	pb_art_nua.visible = True
	pb_nuance.visible = false
	i_b_mode_dimension			=	False
	dw_1.SetColumn(DBNAME_ARTICLE)
	i_s_tab_one 				= DBNAME_ARTICLE
else
	pb_art_nua.visible = false
	pb_nuance.visible = True
	i_b_mode_dimension		  =	True
	dw_1.SetColumn(DBNAME_DIMENSION)
	i_s_tab_one 			  = DBNAME_DIMENSION		
END IF

dw_1.SetFocus ()
end event

public subroutine fw_suppression_ligne_qte_zero ();/* <DESC> 
     Permet la suppression des lignes de commande ayant une quantité à zéro
   </DESC> */
long l_row
long l_nb_row
l_nb_row = dw_1.RowCount()
l_row = 1

Do While l_row <= l_nb_row
	IF dw_1.GetItemDecimal (l_row, DBNAME_QTE) = 0  or & 
	   isNull(dw_1.GetItemDecimal (l_row, DBNAME_QTE)) THEN
		dw_1.DeleteRow (l_row)
		l_nb_row = l_nb_row - 1
	ELSE
		l_row = l_row + 1
	END IF
LOOP

end subroutine

public subroutine fw_clear_lignes ();/* <DESC>
    Permet d'afficher une datatwindow vide pour permettre la saisie d'une nouvelle page
   </DESC> */
dw_1.reset()
i_nv_ligne_cde_object.fu_init_num_page(dw_1)
dw_1.insertRow(0)
dw_1.SetColumn (i_s_tab_one)

end subroutine

event ue_delete;/* <DESC> 
    Permet de supprimer la ou les lignes sélectionnées.
	 <LI>Une au minimum doit être sélectionnée
	<LI> La suppression s'effectuera aprés avoir sauvegarder les données de la ligne en cours.
	   </DESC> */
	
// OVERRIDE SCRIPT ANCESTOR

Long	l_row,			&
		l_nb_select,	&
		i
// Controle du nbr de lignes sélectionnées
l_nb_select = dw_1.fu_get_selected_count ()
IF l_nb_select = 0 THEN
	messagebox (This.title, g_nv_traduction.get_traduction(SELECTION_OBLIGATOIRE), Information!,Ok!,1)
	dw_1.SetFocus ()
	RETURN
END IF

// Sauvegarde de la ligne en cours
dw_1.TriggerEvent ("ue_presave")
dw_1.SetRow(1)

// Suppression des lignes sélectionnées.
i_b_delete_ligne = TRUE
l_row = dw_1.GetSelectedRow (0)
DO WHILE l_row > 0
	dw_1.DeleteRow (l_row)
	l_row = dw_1.GetSelectedRow (0)
LOOP	

dw_1.Update ()
i_b_delete_ligne = FALSE

i_nv_commande_object.fu_validation_commande_par_lignes_cde()
dw_mas.retrieve(i_nv_commande_object.fu_get_numero_cde(), g_nv_come9par.get_code_langue())

dw_1.SetFocus ()
if dw_1.rowCount() = 0 then
	dw_1.insertRow(0)
end if
dw_1.ScrollToRow(dw_1.RowCount())
end event

event ue_presave;call super::ue_presave;/* <DESC>
     Mise en forme et mise à jour de la ligne en cours de saisie .
	<LI>Si l'article ou la dimension ne sont pas alimentés, aucune mise à jour n'est effectuée et on
	reste positionner sur la ligne
	<LI>Si Mode Dimension, alimentation de l'article avec celui de la ligne précédente
	<LI>Si N° de la ligne non renseigné, il s'agit d'une nouvelle ligne donc mise à jour du n° de la ligne
     <LI> Si quantité non alimentée, initialisation à 1
   </DESC> */
	
// ceci est du au fait que lorsque l'on supprime une ligne, 
// cet evenement est automatiquement déclenché pour la ligne supprimée
long l_row 
l_row = dw_1.fu_get_itemchanged_row_num ()
 
if i_b_delete_ligne or &
	l_row = 0 		  or & 
	l_row > dw_1.RowCount() then
	i_b_delete_ligne = False
	Message.ReturnValue = -1
	RETURN
end if

dw_1.AcceptText()
String ls_article
String ls_dimension

ls_article = Trim(dw_1.GetItemString (l_row, DBNAME_ARTICLE))
ls_dimension = Trim(dw_1.GetItemString (l_row, DBNAME_DIMENSION))

If IsNull (ls_article) Or trim(ls_article) = DONNEE_VIDE  then
	ls_article =	BLANK
End if	

If IsNull(ls_dimension) Or trim(ls_dimension) = DONNEE_VIDE  then
	ls_dimension = BLANK
End if

If ls_article	=	BLANK	and ls_dimension	=	BLANK	then
	Message.ReturnValue = -1
	RETURN
end if

if i_b_mode_dimension and l_row > 1 then
	dw_1.SetItem (l_row, DBNAME_ARTICLE, dw_1.getItemString(l_row - 1, DBNAME_ARTICLE))
end if

// Recherche du dernier de ligne et mise à jour de celui ci
IF IsNull (dw_1.GetItemString (l_row, DBNAME_NUM_LIGNE)) THEN
	dw_1.SetItem (l_row, DBNAME_NUM_LIGNE, i_nv_ligne_cde_object.fu_get_nouveau_numero_ligne())
end if

if isNull(dw_1.GetItemDecimal (l_row, DBNAME_QTE)) or & 
	dw_1.GetItemDecimal (l_row, DBNAME_QTE) = 0 then
		dw_1.setItem (l_row, DBNAME_QTE,1)
end if
dw_1.SetItem (l_row, DBNAME_DATE_CREATION, sqlca.fnv_get_datetime ())
end event

event ue_init;call super::ue_init;/* <DESC>
     Initialisation de la fenêtre
	- Controle si identification du client
	- Création de l'object commande et extraction des informations de l'entête de la commande
	- Extraction de toute lignes de la commande sasie en mode opératrice
	- Initailisation de l'object nv_ligne_cde_object
	- Si mode gestion des lignes en anomalie, rendre visible le bouton affichage des lignes et cacher le bouton
	   Article/Dimension sinon création d'une ligne vide et rendre visible le bouton affichage ligne
   </DESC> */

Long			l_retrieve
Long			l_insert
Long			l_row
Long			l_nb_row
Decimal{2}	dec_total_remise
Decimal{2}	dec_montant_ligne

Str_pass		str_work

dw_mas.SetTransObject (i_tr_sql)

i_str_pass = g_nv_workflow_manager.fu_ident_client(true, i_str_pass)
if  i_str_pass.s_action = ACTION_CANCEL then
	close(this)
	RETURN
end if
g_nv_trace.fu_write_trace( this.classname( ), "ue_ini",i_str_pass.s[01], i_str_pass.s[02], this.classname( ) , g_s_fenetre_destination)
dw_mas.SetRedraw (False)
dw_1.SetRedraw (False)

i_nv_commande_object = CREATE nv_commande_object
i_nv_commande_object.fu_set_numero_cde(i_str_pass.s[2])

IF dw_mas.Retrieve (i_nv_commande_object.fu_controle_numero_cde(i_str_pass.po[1]), g_nv_come9par.get_code_langue()) = -1 THEN
 	f_dmc_error (this.title +  BLANK + DB_ERROR_MESSAGE)
END IF

if dw_1.Retrieve (i_nv_commande_object.fu_get_numero_cde(),i_d_page_mini,i_d_page_maxi) = -1 then
		f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
end if

i_nv_ligne_cde_object = CREATE nv_ligne_cde_object
i_nv_ligne_cde_object.fu_init_info_commande(i_nv_commande_object)
i_nv_ligne_cde_object.fu_init_valeur_ligne_cde_operatrice(dw_1)

dw_mas.SetRedraw (True) 
dw_1.SetRedraw (True)
dw_1.fu_set_selection_mode (0)
dw_1.SetFocus ()

i_s_tab_one		 = DBNAME_ARTICLE

l_insert = dw_1.InsertRow (0)
dw_1.ScrollToRow (l_insert)
dw_1.SetColumn (i_s_tab_one)

end event

event ue_ok;/* <DESC>
     Permet de valider la page en cours et la création d'une nouvelle page avec affichage
	  d'un nouvel écran vierge our permettre la saisie.
   </DESC> */

// OVERRIDE SCRIPT ANCESTOR

dw_1.AcceptText ()
This.TriggerEvent ("ue_validation")
fw_clear_lignes()
dw_1.setFocus()

end event

event ue_cancel;/* <DESC>
    Permet de quitter l'application sans effectuer de prendre en compte les éventuelles
	 modifications non validées et de retourner à la liste d'origine.
   </DESC> */

// Déclaration des variables locales
Long		l_row
Long		l_nb_row

i_b_canceled = TRUE
dw_1.AcceptText()
dw_1.SetRow(1)

// Suppression des lignes de commande dont la quantite est = 0
fw_suppression_ligne_qte_zero()

i_str_pass.po[2] = i_nv_commande_object
i_str_pass.s[2] = i_nv_commande_object.fu_get_numero_cde()
g_nv_workflow_manager.fu_affiche_liste_origine(i_str_pass)
Close (this)
end event

event key;call super::key;/* <DESC>
      Permet de trapper les touches de fonction activées et déclencher l'évènement associé
	à la touche.
	  F2 = Fin de page
	  F11 = Fin de page
   </DESC> */
	IF KeyDown (KeyF11!) THEN
		This.PostEvent ("ue_ok")
	END IF
	
	IF KeyDown (KeyF2!) THEN
		This.PostEvent ("ue_fin_page")
	END IF
end event

on w_ligne_cde_operatrice.create
int iCurrent
call super::create
this.r_2=create r_2
this.pb_ok=create pb_ok
this.pb_echap=create pb_echap
this.pb_supprim=create pb_supprim
this.dw_mas=create dw_mas
this.pb_fin_page=create pb_fin_page
this.sle_num_page=create sle_num_page
this.numaepag_10_t=create numaepag_10_t
this.cbx_toutes=create cbx_toutes
this.cb_aller=create cb_aller
this.pb_art_nua=create pb_art_nua
this.pb_nuance=create pb_nuance
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.r_2
this.Control[iCurrent+2]=this.pb_ok
this.Control[iCurrent+3]=this.pb_echap
this.Control[iCurrent+4]=this.pb_supprim
this.Control[iCurrent+5]=this.dw_mas
this.Control[iCurrent+6]=this.pb_fin_page
this.Control[iCurrent+7]=this.sle_num_page
this.Control[iCurrent+8]=this.numaepag_10_t
this.Control[iCurrent+9]=this.cbx_toutes
this.Control[iCurrent+10]=this.cb_aller
this.Control[iCurrent+11]=this.pb_art_nua
this.Control[iCurrent+12]=this.pb_nuance
end on

on w_ligne_cde_operatrice.destroy
call super::destroy
destroy(this.r_2)
destroy(this.pb_ok)
destroy(this.pb_echap)
destroy(this.pb_supprim)
destroy(this.dw_mas)
destroy(this.pb_fin_page)
destroy(this.sle_num_page)
destroy(this.numaepag_10_t)
destroy(this.cbx_toutes)
destroy(this.cb_aller)
destroy(this.pb_art_nua)
destroy(this.pb_nuance)
end on

event ue_close;//override ancestor script
/* <DESC>
    Permet de fermer la fenêtre aprsé avoir effectuer la validation de la page en cours
	 et de retourner à la liste d'origine.
   </DESC> */
i_b_canceled = TRUE

IF dw_1.fu_changed() THEN
	THIS.Triggerevent("ue_save")
END IF
g_nv_workflow_manager.fu_affiche_liste_origine(i_str_pass)
Close(THIS)
end event

type uo_statusbar from w_a_udim_su`uo_statusbar within w_ligne_cde_operatrice
end type

type dw_1 from w_a_udim_su`dw_1 within w_ligne_cde_operatrice
string tag = "A_TRADUIRE"
integer x = 448
integer y = 228
integer width = 1783
integer height = 1628
integer taborder = 10
string title = "Gestion des anomalies"
string dataobject = "d_ligne_cde_operatrice"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event dw_1::we_dwnprocessenter;call super::we_dwnprocessenter;/* <DESC>
      Executer lors de l'activation de la touche Entrée
	Si la colonne en cours n'est pas la quantité, passage à la zone suivante
	Si l'article et la dimension ne sont pas renseignés et que l'on est en mode article, repositionnement du curseur
		sur l'article
	Si la ligne en cours n'est pas la dernière ligne de saisie, on se positionne sur la ligne suivante
	Si  création d'une nouvelle ligne
   </DESC> */

string	s_article, &
			s_dimension

IF dw_1.GetRow () < dw_1.RowCount() THEN
	Send(Handle(This),256,9,Long(0,0))
	Return 1
END IF

If dw_1.GetColumnName () <> DBNAME_QTE then
	Send(Handle(This),256,9,Long(0,0))
	Return 1
End if

s_article	=	Trim(dw_1.Getitemstring(dw_1.rowcount(),DBNAME_ARTICLE))
s_dimension	=	Trim(dw_1.Getitemstring(dw_1.rowcount(),DBNAME_DIMENSION))

IF  (IsNull(s_article)  OR s_article = DONNEE_VIDE ) &
AND (IsNull(s_dimension)	OR s_dimension = DONNEE_VIDE ) THEN
	dw_1.SetColumn (i_s_tab_one)
ELSE
	dw_1.fu_insert (0)
	dw_1.SetColumn (i_s_tab_one)
END IF
end event

event dw_1::we_dwnkey;call super::we_dwnkey;/* <DESC> 
     Permet d'effectuer le traitement en fonction de la touche de fonction activée.
	F5 --> Sélection de la ligne positionnée
	F6 --> Déselection de la ligne sélectionnée
	F7 --> Sélection de toutes les lignes  
	F8 --> Désélectin de toutes les lignes sélectionnées
	F11 --> validation de la page et page à une nouvelle page
	F2 -->  Fin de page
	Tabulation --> positionne sur le champ suivant
   </DESC> */

// SELECTION DE LA LIGNE EN COURS
	IF KeyDown(KeyF5!) THEN
		dw_1.SelectRow(dw_1.GetRow(),TRUE)
	END IF

// DESELECTION DE LA LIGNE EN COURS
	IF KeyDown(KeyF6!) THEN
		dw_1.SelectRow(dw_1.GetRow(),FALSE)
	END IF

// SELECTION DE TOUTES LES LIGNES 
	IF KeyDown(KeyF7!) THEN
		dw_1.SelectRow(0,TRUE)
	END IF

// DESELECTION DE TOUTES LES LIGNES
	IF KeyDown(KeyF8!) THEN
		dw_1.SelectRow(0,FALSE)
	END IF

// VALIDATION DES LIGNES DE COMMANDE
	IF KeyDown (KeyF11!) THEN
		Parent.PostEvent ("ue_ok")
	END IF
	
	IF KeyDown (KeyF2!) THEN
		Parent.PostEvent ("ue_fin_page")
	END IF
end event

type r_2 from rectangle within w_ligne_cde_operatrice
integer linethickness = 4
long fillcolor = 12632256
integer x = 2322
integer y = 952
integer width = 745
integer height = 484
end type

type pb_ok from u_pba_ok within w_ligne_cde_operatrice
integer x = 978
integer y = 1888
integer width = 320
integer height = 164
integer taborder = 0
string text = "Valid. F11"
boolean default = false
string picturename = "c:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_echap from u_pba_echap within w_ligne_cde_operatrice
integer x = 1806
integer y = 1888
integer width = 320
integer height = 152
integer taborder = 0
string picturename = "c:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type pb_supprim from u_pba_supprim within w_ligne_cde_operatrice
integer x = 1440
integer y = 1892
integer width = 320
integer height = 152
integer taborder = 0
string text = "S&upprim"
string picturename = "c:\appscir\Erfvmr_diva\Image\pb_suppr.bmp"
end type

type dw_mas from u_dwa within w_ligne_cde_operatrice
event mousemove pbm_mousemove
string tag = "A_TRADUIRE"
integer x = 69
integer y = 24
integer width = 2949
integer height = 164
integer taborder = 0
string dataobject = "d_entete_saisie_cde"
borderstyle borderstyle = styleshadowbox!
end type

event mousemove;if not isvalid(itooltip) then
	itooltip = create n_tooltip_mgr
end if
itooltip.of_mousemove_notify(parent, this, getobjectatpointer(), this.x + xpos, this.y + ypos)
end event

type pb_fin_page from u_pba_fin_page within w_ligne_cde_operatrice
integer x = 521
integer y = 1884
integer width = 357
integer height = 164
integer taborder = 20
boolean bringtotop = true
string picturename = "c:\appscir\Erfvmr_diva\Image\pb_fin_page.bmp"
alignment htextalign = right!
boolean map3dcolors = false
end type

type sle_num_page from u_sle_num within w_ligne_cde_operatrice
integer x = 2793
integer y = 1020
integer width = 219
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer weight = 700
string facename = "Arial"
end type

event we_char;call super::we_char;cbx_toutes.checked = false
end event

type numaepag_10_t from statictext within w_ligne_cde_operatrice
integer x = 2341
integer y = 1032
integer width = 343
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "N° Page :"
alignment alignment = center!
boolean focusrectangle = false
end type

type cbx_toutes from u_cbxa within w_ligne_cde_operatrice
integer x = 2386
integer y = 1140
integer width = 626
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
long backcolor = 12632256
string text = "Toutes les pages"
boolean lefttext = true
end type

event clicked;call super::clicked;if this.checked then
	sle_num_page.text = DONNEE_VIDE
end if
end event

type cb_aller from u_cba within w_ligne_cde_operatrice
integer x = 2533
integer y = 1304
integer width = 352
integer height = 96
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
string text = "A&ller à"
end type

event clicked;call super::clicked;parent.triggerEvent("ue_changer_page")
end event

type pb_art_nua from u_pba within w_ligne_cde_operatrice
integer x = 2391
integer y = 364
integer width = 311
integer height = 176
integer taborder = 11
boolean bringtotop = true
string text = "&Article"
string picturename = "c:\appscir\Erfvmr_diva\Image\PB_ART.BMP"
end type

event constructor;call super::constructor;i_s_event = "ue_article_dimension"
end event

type pb_nuance from u_pba within w_ligne_cde_operatrice
boolean visible = false
integer x = 2386
integer y = 364
integer width = 311
integer height = 176
integer taborder = 21
boolean bringtotop = true
string text = "&Nuance"
string picturename = "c:\appscir\Erfvmr_diva\Image\PB_NUA.BMP"
end type

event constructor;call super::constructor;i_s_event = "ue_article_dimension"
end event

