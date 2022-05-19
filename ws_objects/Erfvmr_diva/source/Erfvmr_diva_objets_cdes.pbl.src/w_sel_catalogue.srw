$PBExportHeader$w_sel_catalogue.srw
$PBExportComments$Permet la sélection du catalogue et du type de tarif pour la saisie des lignes de commande à partir de catalogue.
forward
global type w_sel_catalogue from w_a_selection
end type
type numaepag_10_t from statictext within w_sel_catalogue
end type
type mot_cle_t from statictext within w_sel_catalogue
end type
type artae000_t from statictext within w_sel_catalogue
end type
type codaectg_t from statictext within w_sel_catalogue
end type
type sle_numpage from u_slea_key within w_sel_catalogue
end type
type sle_mot_cle from u_slea_key within w_sel_catalogue
end type
type sle_reference from u_slea_key within w_sel_catalogue
end type
type dw_catalogue from u_dwa within w_sel_catalogue
end type
type rb_normal from u_rba within w_sel_catalogue
end type
type rb_prevente from u_rba within w_sel_catalogue
end type
type gb_type_tarif from groupbox within w_sel_catalogue
end type
type ln_1 from line within w_sel_catalogue
end type
type ln_2 from line within w_sel_catalogue
end type
end forward

global type w_sel_catalogue from w_a_selection
string tag = "SELECTION_CATALOGUE"
integer x = 763
integer y = 684
integer width = 2002
integer height = 1424
string title = "*Sélection Catalogue*"
boolean controlmenu = true
long backcolor = 12632256
numaepag_10_t numaepag_10_t
mot_cle_t mot_cle_t
artae000_t artae000_t
codaectg_t codaectg_t
sle_numpage sle_numpage
sle_mot_cle sle_mot_cle
sle_reference sle_reference
dw_catalogue dw_catalogue
rb_normal rb_normal
rb_prevente rb_prevente
gb_type_tarif gb_type_tarif
ln_1 ln_1
ln_2 ln_2
end type
global w_sel_catalogue w_sel_catalogue

type variables
nv_commande_object  inv_commande
end variables

event ue_ok;call super::ue_ok;/* <DESC>
      <LI>Permet de contrôler la saisie du type de tarif. Cette information est obligatoire et affichage d'un message de demande
		de confirmation de la sélection du tarif.
	<LI>Initialisation de la structure avec les paramètres et fermeture de la fenêtre
   </DESC> */
String ls_message 

IF  rb_normal.checked = false and  &
     rb_prevente.checked = false then
	 MessageBox (This.title,g_nv_traduction.get_traduction(TYPE_TARIF_OBLIGATOIRE),Information!,Ok!,1)
	RETURN
end if

if rb_normal.checked = true then
	ls_message = g_nv_traduction.get_traduction(CONFIRMAT_TYPE_TARIF_NORMAL)
else
	ls_message = g_nv_traduction.get_traduction(CONFIRMAT_TYPE_TARIF_CATALOGUE)
end if

if  MessageBox (This.title,ls_message,Information!,YesNo!,1) = 2 then
	return
end if

// ---------------------------------------
// RENVOIE DES PARAMETRES SAISIS
// ---------------------------------------
i_str_pass.s[1] = Trim (dw_catalogue.GetText ())
i_str_pass.s[2] = sle_numpage.Text
i_str_pass.s[3] = sle_mot_cle.Text
i_str_pass.s[4] = sle_reference.Text
i_str_pass.b[1] = rb_normal.checked

Message.fnv_set_str_pass(i_str_pass)
Close (This)

	
end event

event ue_init;call super::ue_init;/* <DESC>
     Initialisation de l'affichage de la fenêtre en alimantant la comboxbox de la liste des catalogues
	  et de l'objet nv_commande
   </DESC> */
// DECLARATION DES VARIABLES LOCALES
Long					l_insert
DataWindowChild	dwc_catalogue

 inv_commande = i_str_pass.po[01]

dw_catalogue.SetTransObject (i_tr_sql)
IF dw_catalogue.GetChild (DBNAME_CODE_CATALOGUE, dwc_catalogue) = -1 then
	messagebox (this.title, g_nv_traduction.get_traduction(ERR_GETCHILD_W_SEL_CATALOGUE),Information!,Ok!,1)
	close(this)		
END IF
 
dwc_catalogue.SetTransObject (i_tr_sql)

if dwc_catalogue.Retrieve (SQLCA.fnv_get_datetime ()) = -1 then
	f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
end if
	
if dw_catalogue.Retrieve (SQLCA.fnv_get_datetime ()) = -1 then
	f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
end if

sle_numpage.fu_set_autoselect (TRUE)
sle_mot_cle.fu_set_autoselect (TRUE)
sle_reference.fu_set_autoselect (TRUE)
end event

event key;call super::key;/* <DESC>
      Permet de trapper les touches de fonction activées et déclencher l'évènement associé
	à la touche.
	  F11 = validation de la sélection
   </DESC> */

	IF KeyDown (KeyF11!) THEN
		This.PostEvent ("ue_ok")
	END IF
	
end event

on w_sel_catalogue.create
int iCurrent
call super::create
this.numaepag_10_t=create numaepag_10_t
this.mot_cle_t=create mot_cle_t
this.artae000_t=create artae000_t
this.codaectg_t=create codaectg_t
this.sle_numpage=create sle_numpage
this.sle_mot_cle=create sle_mot_cle
this.sle_reference=create sle_reference
this.dw_catalogue=create dw_catalogue
this.rb_normal=create rb_normal
this.rb_prevente=create rb_prevente
this.gb_type_tarif=create gb_type_tarif
this.ln_1=create ln_1
this.ln_2=create ln_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.numaepag_10_t
this.Control[iCurrent+2]=this.mot_cle_t
this.Control[iCurrent+3]=this.artae000_t
this.Control[iCurrent+4]=this.codaectg_t
this.Control[iCurrent+5]=this.sle_numpage
this.Control[iCurrent+6]=this.sle_mot_cle
this.Control[iCurrent+7]=this.sle_reference
this.Control[iCurrent+8]=this.dw_catalogue
this.Control[iCurrent+9]=this.rb_normal
this.Control[iCurrent+10]=this.rb_prevente
this.Control[iCurrent+11]=this.gb_type_tarif
this.Control[iCurrent+12]=this.ln_1
this.Control[iCurrent+13]=this.ln_2
end on

on w_sel_catalogue.destroy
call super::destroy
destroy(this.numaepag_10_t)
destroy(this.mot_cle_t)
destroy(this.artae000_t)
destroy(this.codaectg_t)
destroy(this.sle_numpage)
destroy(this.sle_mot_cle)
destroy(this.sle_reference)
destroy(this.dw_catalogue)
destroy(this.rb_normal)
destroy(this.rb_prevente)
destroy(this.gb_type_tarif)
destroy(this.ln_1)
destroy(this.ln_2)
end on

type uo_statusbar from w_a_selection`uo_statusbar within w_sel_catalogue
end type

type pb_ok from w_a_selection`pb_ok within w_sel_catalogue
integer x = 489
integer y = 1096
string picturename = "c:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_echap from w_a_selection`pb_echap within w_sel_catalogue
integer x = 1061
integer y = 1096
string picturename = "c:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type numaepag_10_t from statictext within w_sel_catalogue
integer x = 69
integer y = 268
integer width = 471
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 12632256
boolean enabled = false
string text = "N° page  "
boolean focusrectangle = false
end type

type mot_cle_t from statictext within w_sel_catalogue
integer x = 73
integer y = 400
integer width = 453
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 12632256
boolean enabled = false
string text = "Mot clé  "
boolean focusrectangle = false
end type

type artae000_t from statictext within w_sel_catalogue
integer x = 78
integer y = 540
integer width = 448
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 12632256
boolean enabled = false
string text = "Article   "
boolean focusrectangle = false
end type

type codaectg_t from statictext within w_sel_catalogue
integer x = 73
integer y = 144
integer width = 480
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 12632256
boolean enabled = false
string text = "Catalogue  "
boolean focusrectangle = false
end type

type sle_numpage from u_slea_key within w_sel_catalogue
event we_dwnprocessenter pbm_dwnprocessenter
integer x = 585
integer y = 252
integer width = 279
integer height = 76
integer taborder = 20
integer limit = 3
borderstyle borderstyle = stylebox!
end type

on we_dwnprocessenter;call u_slea_key::we_dwnprocessenter;
// ---------------
// CHAMPS SUIVANT
// ---------------
	sle_mot_cle.SetFocus ()
end on

type sle_mot_cle from u_slea_key within w_sel_catalogue
event we_dwnprocessenter pbm_dwnprocessenter
integer x = 581
integer y = 392
integer width = 1211
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer limit = 40
borderstyle borderstyle = stylebox!
end type

on we_dwnprocessenter;call u_slea_key::we_dwnprocessenter;
// ---------------
// CHAMPS SUIVANT
// ---------------
	sle_reference.SetFocus ()

end on

type sle_reference from u_slea_key within w_sel_catalogue
event we_dwnprocessenter pbm_dwnprocessenter
integer x = 590
integer y = 528
integer width = 910
integer height = 72
integer taborder = 40
boolean bringtotop = true
borderstyle borderstyle = stylebox!
end type

on we_dwnprocessenter;call u_slea_key::we_dwnprocessenter;
// ---------------
// CHAMPS SUIVANT
// ---------------
	dw_catalogue.SetFocus ()
end on

type dw_catalogue from u_dwa within w_sel_catalogue
integer x = 581
integer y = 136
integer width = 1033
integer height = 80
integer taborder = 10
string dataobject = "dd_sel_catalogue"
boolean border = false
end type

event we_dwnprocessenter;/* <DESC>
     Permet de positionner le curseur sur le n° de page lors de l'activation de la touche
	  Entrée 
   </DESC> */
	sle_numpage.SetFocus()
	Return 1
end event

event we_dwnkey;call super::we_dwnkey;/* <DESC>
      Permet lors de l'activation d'une touche de fonction, d'effectuer le trigger KEY de la fenêtre
   </DESC> */
	f_key(Parent)
end event

event rowfocuschanged;// OverWrite
/* <DESC> 
     Permet d'effectuer le controle d'existence de la saisie de lignes de commande pour le catalogue
	  sélectionné
	 </DESC> */
this.PostEvent ("ue_postitemchanged")

end event

event ue_postitemchanged;call super::ue_postitemchanged;/* <DESC<>
     Permet de controler l'existence de ligne de commande pour le catalogue sélectionné et
	  d'initialiser la type de tarif à partir de celui utiliser lors de la saisie précédente et
	  de verrouiller en modification la sélection du type de tarif.
	</DESC> */

string ls_type_tarif

if inv_commande.fu_existe_ligne_cde_catalogue(getItemString(getrow(),DBNAME_CODE_CATALOGUE),ls_type_tarif) then
	 if ls_type_tarif = 'V' then
		rb_prevente.checked= true
	 else
		rb_normal.checked= true
	 end if
	 rb_normal.enabled = false
      rb_prevente.enabled= false
else
  rb_prevente.checked= false
  rb_normal.checked= false
  rb_normal.enabled = true
  rb_prevente.enabled= true
end if

end event

type rb_normal from u_rba within w_sel_catalogue
integer x = 507
integer y = 808
integer width = 411
integer height = 72
boolean bringtotop = true
integer weight = 700
long backcolor = 12632256
string text = "&Normal"
end type

type rb_prevente from u_rba within w_sel_catalogue
integer x = 983
integer y = 804
integer width = 421
integer height = 72
boolean bringtotop = true
integer weight = 700
long backcolor = 12632256
string text = "&Pré-vente"
end type

type gb_type_tarif from groupbox within w_sel_catalogue
integer x = 443
integer y = 716
integer width = 992
integer height = 228
integer taborder = 20
integer textsize = -9
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 12632256
string text = "Type de tarif "
end type

type ln_1 from line within w_sel_catalogue
integer linethickness = 4
integer beginx = 5
integer beginy = 676
integer endx = 1957
integer endy = 676
end type

type ln_2 from line within w_sel_catalogue
integer linethickness = 4
integer beginx = 18
integer beginy = 992
integer endx = 1970
integer endy = 992
end type

