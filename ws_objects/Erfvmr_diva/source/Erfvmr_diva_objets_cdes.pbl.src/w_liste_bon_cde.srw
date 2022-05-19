$PBExportHeader$w_liste_bon_cde.srw
$PBExportComments$Selectionner un bon de commande
forward
global type w_liste_bon_cde from w_a_liste
end type
type artae000_t from statictext within w_liste_bon_cde
end type
type sle_article from u_slea_key within w_liste_bon_cde
end type
type mot_cle_t from statictext within w_liste_bon_cde
end type
type sle_ref from u_slea_key within w_liste_bon_cde
end type
type cb_select from u_cba within w_liste_bon_cde
end type
type qt_par_def_t from statictext within w_liste_bon_cde
end type
type sle_qte from u_sle_num within w_liste_bon_cde
end type
type rr_1 from roundrectangle within w_liste_bon_cde
end type
end forward

global type w_liste_bon_cde from w_a_liste
string tag = "LISTE_BON_CDE"
integer width = 2235
integer height = 1948
string title = "*Liste des bons de commande *"
artae000_t artae000_t
sle_article sle_article
mot_cle_t mot_cle_t
sle_ref sle_ref
cb_select cb_select
qt_par_def_t qt_par_def_t
sle_qte sle_qte
rr_1 rr_1
end type
global w_liste_bon_cde w_liste_bon_cde

type variables
String is_ucc
end variables

event key;call super::key;/* <DESC>
      Permet de trapper les touches de fonction activées et déclencher l'évènement associé
	à la touche.
	  F11 = Validation de la sélection du bon de commande
   </DESC> */
	IF KeyDown (KeyF11!) THEN
		This.PostEvent ("ue_ok")
	END IF
end event

event ue_ok;/* <DESC>
     Permet de valider la sélection et de retourner sur la fenetre de saisie des lignes
	  de commande par le bon de commande
	  <LI>Un bon de commande doit être slélectionné
	  <LI>La quantité par défaut doit être renseignée, la valeur zéro est acceptée
	  <LI> Retour à ala saisie en passant en paramètre l'article et sa désignation
  </DESC> */

if dw_1.getRow() = 0 then
	MessageBox(this.title,g_nv_traduction.get_traduction(SELECTION_OBLIGATOIRE),information!, ok!)
	dw_1.setFocus()
	return
end if

if TRim(sle_qte.text) = DONNEE_VIDE or &
   isNull(sle_qte.text) then
	MessageBox (This.title,g_nv_traduction.get_traduction(QUANTITE_OBLIGATOIRE), information!,ok!)
	sle_qte.setFocus()
	return
end if

i_str_pass.s[1] = dw_1.GetItemString (dw_1.GetSelectedRow (0), DBNAME_ARTICLE)	
i_str_pass.s[2] = dw_1.GetItemString (dw_1.GetSelectedRow (0), DBNAME_DESCRIPTION_REF)
i_str_pass.d[1] = double(sle_qte.text)
i_str_pass.s_action = ACTION_OK
Message.fnv_set_str_pass(i_str_pass)
Close (This)

end event

on w_liste_bon_cde.create
int iCurrent
call super::create
this.artae000_t=create artae000_t
this.sle_article=create sle_article
this.mot_cle_t=create mot_cle_t
this.sle_ref=create sle_ref
this.cb_select=create cb_select
this.qt_par_def_t=create qt_par_def_t
this.sle_qte=create sle_qte
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.artae000_t
this.Control[iCurrent+2]=this.sle_article
this.Control[iCurrent+3]=this.mot_cle_t
this.Control[iCurrent+4]=this.sle_ref
this.Control[iCurrent+5]=this.cb_select
this.Control[iCurrent+6]=this.qt_par_def_t
this.Control[iCurrent+7]=this.sle_qte
this.Control[iCurrent+8]=this.rr_1
end on

on w_liste_bon_cde.destroy
call super::destroy
destroy(this.artae000_t)
destroy(this.sle_article)
destroy(this.mot_cle_t)
destroy(this.sle_ref)
destroy(this.cb_select)
destroy(this.qt_par_def_t)
destroy(this.sle_qte)
destroy(this.rr_1)
end on

event ue_init;// overWrite
/* <DESC>
     Initialisation de la fenetre en initialisant la quantité par defaut à 1
   </DESC> */
is_ucc = i_str_pass.s[1]

if is_ucc <> CODE_UCC_UC then
	sle_qte.text = String(1)
end if

end event

event ue_retrieve;call super::ue_retrieve;/* <DESC>
    Extraction des bons de commande correspondant à la sélection.
	 Déclencher lors de l'activation de la touche sélection.
   </DESC> */
if dw_1.retrieve(sle_article.text + "%", sle_ref.text + "%",g_nv_come9par.get_code_langue( ) ) = -1 then
	f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)	
end if
end event

type uo_statusbar from w_a_liste`uo_statusbar within w_liste_bon_cde
end type

type cb_cancel from w_a_liste`cb_cancel within w_liste_bon_cde
integer x = 878
integer y = 1688
integer taborder = 0
end type

type cb_ok from w_a_liste`cb_ok within w_liste_bon_cde
integer x = 878
integer y = 1596
integer taborder = 0
end type

type dw_1 from w_a_liste`dw_1 within w_liste_bon_cde
string tag = "A_TRADUIRE"
integer x = 55
integer y = 624
integer width = 2062
integer height = 972
integer taborder = 50
string dataobject = "d_liste_bon_cde"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;Decimal ldec_qte 

if is_ucc <> CODE_UCC_UC then
	sle_qte.text = String(1)
else
	ldec_qte = getItemDecimal(currentrow,DBNAME_PCB)
	sle_qte.text = String( ldec_qte )
end if

end event

type pb_ok from w_a_liste`pb_ok within w_liste_bon_cde
integer x = 448
integer y = 1624
integer taborder = 60
string picturename = "c:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_echap from w_a_liste`pb_echap within w_liste_bon_cde
integer x = 1394
integer y = 1624
integer taborder = 70
string picturename = "c:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type artae000_t from statictext within w_liste_bon_cde
integer x = 192
integer y = 72
integer width = 416
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 12632256
boolean enabled = false
string text = "Article        :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_article from u_slea_key within w_liste_bon_cde
integer x = 658
integer y = 60
integer width = 754
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer weight = 700
textcase textcase = upper!
integer limit = 18
end type

type mot_cle_t from statictext within w_liste_bon_cde
integer x = 201
integer y = 164
integer width = 411
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 12632256
boolean enabled = false
string text = "Mot clé        :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_ref from u_slea_key within w_liste_bon_cde
integer x = 658
integer y = 156
integer width = 1061
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer weight = 700
textcase textcase = upper!
end type

type cb_select from u_cba within w_liste_bon_cde
integer x = 1312
integer y = 280
integer width = 384
integer height = 96
integer taborder = 30
boolean bringtotop = true
string text = "Sélectionner"
end type

event constructor;call super::constructor;
// ------------------------------------------
// Déclenche l'évènement de la fenêtre
// ------------------------------------------
	fu_setevent ("ue_retrieve")
	fu_set_microhelp ("Recherche des articles")
end event

type qt_par_def_t from statictext within w_liste_bon_cde
integer x = 1093
integer y = 504
integer width = 672
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "*Quantité par défaut :*"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_qte from u_sle_num within w_liste_bon_cde
integer x = 1797
integer y = 496
integer width = 297
integer height = 68
integer taborder = 40
boolean bringtotop = true
boolean autohscroll = true
integer limit = 3
boolean hideselection = false
end type

type rr_1 from roundrectangle within w_liste_bon_cde
integer linethickness = 4
long fillcolor = 12632256
integer x = 146
integer y = 24
integer width = 1746
integer height = 372
integer cornerheight = 40
integer cornerwidth = 46
end type

