$PBExportHeader$w_sel_cde.srw
$PBExportComments$Permet la sélection des commandes à afficher sur la fenêtre des dernières commandes
forward
global type w_sel_cde from w_a_selection
end type
type libaecor_t from statictext within w_sel_cde
end type
type numaeclf_t from statictext within w_sel_cde
end type
type abnaeclf_t from statictext within w_sel_cde
end type
type buraedis_t from statictext within w_sel_cde
end type
type codeevis_t from statictext within w_sel_cde
end type
type sle_client from u_slea_key within w_sel_cde
end type
type sle_nom from u_slea_key within w_sel_cde
end type
type sle_ville from u_slea_key within w_sel_cde
end type
type dw_visiteur from u_dwa within w_sel_cde
end type
type codaepay_t from statictext within w_sel_cde
end type
type dw_pays from u_dw_udis within w_sel_cde
end type
type dw_corresp from u_dwa within w_sel_cde
end type
end forward

global type w_sel_cde from w_a_selection
string tag = "SELECTION_DERNIERE_COMMANDE"
integer width = 1943
integer height = 1124
string title = "*Sélection des dernières commandes*"
boolean controlmenu = true
long backcolor = 12632256
event we_dwnprocessenter pbm_dwnprocessenter
libaecor_t libaecor_t
numaeclf_t numaeclf_t
abnaeclf_t abnaeclf_t
buraedis_t buraedis_t
codeevis_t codeevis_t
sle_client sle_client
sle_nom sle_nom
sle_ville sle_ville
dw_visiteur dw_visiteur
codaepay_t codaepay_t
dw_pays dw_pays
dw_corresp dw_corresp
end type
global w_sel_cde w_sel_cde

type variables
// DataWindow Child (DropDownDataWindow)
DataWindowChild		i_dwc_liste
DataWindowChild		i_dwc_liste_pays
DataWindowChild		i_dwc_liste_corresp
end variables

event ue_init;call super::ue_init;/* <DESC>
    Permet l'initialisation de la fenêtre lors de l'affichage initial.
    Alimentation des combobox contenant les listes des correspondancières, code pays et des codes visiteurs.
      <DESC/> */
	
// ------------------------------------
// DECLARATION DES VARIABLES LOCALES
// ------------------------------------
	Long					l_retrieve	
	int					i_rc

// ----------------------------------------
// RETRIEVE DE LA LISTE DES CODES CORRESPONDANCIERES
// ----------------------------------------
	IF dw_corresp.GetChild (DBNAME_CODE_CORREPONDANTE,i_dwc_liste_corresp) = -1 THEN
		messagebox (this.title,g_nv_traduction.get_traduction(ERR_GETCHILD_W_SEL_CDE),Information!,Ok!,1)
		close (This)
	END IF
	
	i_dwc_liste_corresp.SetTransObject(SQLCA)
	dw_corresp.SetTransObject(SQLCA)	
	
	if i_dwc_liste_corresp.Retrieve(g_nv_come9par.get_code_langue( ) ) = -1 then
		f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
	END if

	if dw_corresp.Retrieve (g_nv_come9par.get_code_langue( )) = -1 then
		f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
   End if
	dw_corresp.InsertRow (1)
	dw_corresp.SetFocus()
	dw_corresp.SetRow(1)
	dw_corresp.visible	=	True	
	
// ----------------------------------------
// RETRIEVE DE LA LISTE DES CODES PAYS
// ----------------------------------------
	IF dw_pays.GetChild (DBNAME_PAYS,i_dwc_liste_pays) = -1 THEN
		messagebox (this.title,g_nv_traduction.get_traduction(ERR_GETCHILD_W_SEL_CDE),Information!,Ok!,1)
		close (This)
	END IF

	i_dwc_liste_pays.SetTransObject(SQLCA)
	dw_pays.SetTransObject(SQLCA)
	
	if i_dwc_liste_pays.Retrieve(g_nv_come9par.get_code_langue()) = -1 then
		f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
	END if

	if dw_pays.Retrieve (g_nv_come9par.get_code_langue()) = -1 then
		f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
   End if
	dw_pays.InsertRow (1)
	dw_pays.SetFocus()
	dw_pays.SetRow(1)
	dw_pays.visible	=	True	
	
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

	dw_corresp.SetFocus()

end event

event ue_ok;call super::ue_ok;/* <DESC> 
    Permet d'initialiser la structure a passé à la fenêtre affichant la liste des commandes 
	 à partir des paramètres sélectionnés
   <DESC/> */

	i_str_pass.s[1]  = dw_corresp.GetText() + "%"
	i_str_pass.s[2]  = sle_client.Text + "%"
	i_str_pass.s[3]  = sle_nom.Text
	i_str_pass.s[4]  = sle_ville.Text 
	i_str_pass.s[5]  = dw_pays.GetText()
	i_str_pass.s[6] = dw_visiteur.GetText() + "%"

	Message.fnv_set_str_pass(i_str_pass)
	Close (This)
end event

event key;call super::key;/* <DESC>
      Permet de trapper les touches de fonction activées et déclencher l'évènement associé
	à la touche.
		F11 permet de valider la sélection
   </DESC> */

	IF KeyDown (KeyF11!) THEN
		This.PostEvent ("ue_ok")
	END IF
	
end event

on w_sel_cde.create
int iCurrent
call super::create
this.libaecor_t=create libaecor_t
this.numaeclf_t=create numaeclf_t
this.abnaeclf_t=create abnaeclf_t
this.buraedis_t=create buraedis_t
this.codeevis_t=create codeevis_t
this.sle_client=create sle_client
this.sle_nom=create sle_nom
this.sle_ville=create sle_ville
this.dw_visiteur=create dw_visiteur
this.codaepay_t=create codaepay_t
this.dw_pays=create dw_pays
this.dw_corresp=create dw_corresp
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.libaecor_t
this.Control[iCurrent+2]=this.numaeclf_t
this.Control[iCurrent+3]=this.abnaeclf_t
this.Control[iCurrent+4]=this.buraedis_t
this.Control[iCurrent+5]=this.codeevis_t
this.Control[iCurrent+6]=this.sle_client
this.Control[iCurrent+7]=this.sle_nom
this.Control[iCurrent+8]=this.sle_ville
this.Control[iCurrent+9]=this.dw_visiteur
this.Control[iCurrent+10]=this.codaepay_t
this.Control[iCurrent+11]=this.dw_pays
this.Control[iCurrent+12]=this.dw_corresp
end on

on w_sel_cde.destroy
call super::destroy
destroy(this.libaecor_t)
destroy(this.numaeclf_t)
destroy(this.abnaeclf_t)
destroy(this.buraedis_t)
destroy(this.codeevis_t)
destroy(this.sle_client)
destroy(this.sle_nom)
destroy(this.sle_ville)
destroy(this.dw_visiteur)
destroy(this.codaepay_t)
destroy(this.dw_pays)
destroy(this.dw_corresp)
end on

type uo_statusbar from w_a_selection`uo_statusbar within w_sel_cde
end type

type pb_ok from w_a_selection`pb_ok within w_sel_cde
integer x = 457
integer y = 772
integer taborder = 20
string picturename = "c:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_echap from w_a_selection`pb_echap within w_sel_cde
integer x = 1029
integer y = 772
integer taborder = 40
string picturename = "c:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type libaecor_t from statictext within w_sel_cde
integer x = 128
integer y = 60
integer width = 667
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
string text = "    Correspondante :"
alignment alignment = right!
boolean focusrectangle = false
end type

type numaeclf_t from statictext within w_sel_cde
integer x = 466
integer y = 176
integer width = 329
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
string text = "N° Client :"
alignment alignment = right!
boolean focusrectangle = false
end type

type abnaeclf_t from statictext within w_sel_cde
integer x = 549
integer y = 276
integer width = 247
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
string text = "Nom :"
alignment alignment = right!
boolean focusrectangle = false
end type

type buraedis_t from statictext within w_sel_cde
integer x = 549
integer y = 376
integer width = 247
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
string text = "Ville :"
alignment alignment = right!
boolean focusrectangle = false
end type

type codeevis_t from statictext within w_sel_cde
integer x = 498
integer y = 612
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

type sle_client from u_slea_key within w_sel_cde
integer x = 818
integer y = 164
integer width = 421
integer height = 72
integer taborder = 50
boolean bringtotop = true
integer weight = 700
textcase textcase = upper!
end type

type sle_nom from u_slea_key within w_sel_cde
integer x = 818
integer y = 264
integer width = 558
integer height = 72
integer taborder = 60
boolean bringtotop = true
integer weight = 700
textcase textcase = upper!
end type

type sle_ville from u_slea_key within w_sel_cde
integer x = 818
integer y = 364
integer width = 558
integer height = 72
integer taborder = 70
boolean bringtotop = true
integer weight = 700
textcase textcase = upper!
end type

type dw_visiteur from u_dwa within w_sel_cde
string tag = "A_TRADUIRE"
integer x = 818
integer y = 604
integer width = 965
integer height = 92
integer taborder = 90
string dataobject = "dd_visiteur"
boolean border = false
end type

event we_dwnkey;call super::we_dwnkey;parent.triggerEvent("key")
end event

type codaepay_t from statictext within w_sel_cde
integer x = 270
integer y = 500
integer width = 526
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
string text = "Pays :"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_pays from u_dw_udis within w_sel_cde
string tag = "A_TRADUIRE"
integer x = 818
integer y = 484
integer width = 978
integer height = 92
integer taborder = 80
boolean bringtotop = true
string dataobject = "dd_pays"
boolean border = false
end type

event we_dwnkey;call super::we_dwnkey;parent.triggerEvent("key")
end event

type dw_corresp from u_dwa within w_sel_cde
string tag = "A_TRADUIRE"
integer x = 818
integer y = 56
integer width = 1024
integer height = 92
integer taborder = 30
boolean bringtotop = true
string dataobject = "dd_correspondanciere"
boolean border = false
end type

event we_dwnkey;call super::we_dwnkey;parent.triggerEvent("key")
end event

