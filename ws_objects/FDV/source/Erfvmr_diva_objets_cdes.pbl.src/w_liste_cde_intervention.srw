$PBExportHeader$w_liste_cde_intervention.srw
$PBExportComments$Affiche la liste des commandes du visiteur connecté
forward
global type w_liste_cde_intervention from w_a_liste
end type
type rb_val_ntrf from u_rba within w_liste_cde_intervention
end type
type rb_annulees from u_rba within w_liste_cde_intervention
end type
type mle_texte_inter from multilineedit within w_liste_cde_intervention
end type
type gb_visu_cde from groupbox within w_liste_cde_intervention
end type
end forward

global type w_liste_cde_intervention from w_a_liste
string tag = "CDES_INTERVENTION"
integer x = 0
integer y = 0
integer width = 4215
integer height = 2336
boolean resizable = false
boolean center = true
boolean ib_statusbar_visible = true
event ue_workflow ( )
rb_val_ntrf rb_val_ntrf
rb_annulees rb_annulees
mle_texte_inter mle_texte_inter
gb_visu_cde gb_visu_cde
end type
global w_liste_cde_intervention w_liste_cde_intervention

type variables
Boolean		i_b_ouverture = TRUE
n_tooltip_mgr itooltip



end variables

forward prototypes
public subroutine fw_retrieve_donnee ()
end prototypes

public subroutine fw_retrieve_donnee ();/* <DESC> 
     Permet d'extraire toutes les commandes validées ou supprimées du visiteur connecté
	 et d'appliquer le filtre en fonction  du type de visualisation	
   </DESC> */
// Chargement des données
Long l_retrieve
l_retrieve = dw_1.Retrieve (g_s_visiteur)

CHOOSE CASE l_retrieve
	CASE -1
		f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
	CASE 0
		return
	CASE ELSE
		i_b_ouverture = FALSE
		dw_1.fu_set_sort_on_label(True)
		dw_1.SetFocus ()		
END CHOOSE
end subroutine

event ue_init;/* <DESC>
    Permet d'initialiser l'affichage initiale de la fenetre et d'afficher la fenetre de selection 
	 des commandes.
   </DESC> */
// Déclaration des variables locales
Long		l_retrieve
	
mle_texte_inter.text =   g_nv_traduction.get_traduction('MLE_TEXT_INTER_01')	+ "~r~n" +  & 
                                         g_nv_traduction.get_traduction('MLE_TEXT_INTER_02')	+ "~r~n"  + &
                                         g_nv_traduction.get_traduction('MLE_TEXT_INTER_03')
	
	
dw_1.fu_set_selection_mode(1)
dw_1.fu_set_sort_on_label(True)

// Chargement des données
fw_retrieve_donnee()

i_str_pass.b[2]	= false
itooltip = CREATE n_tooltip_mgr

dw_1.Object.DataWindow.HorizontalScrollSplit = 400

Choose case g_i_option_liste_cde_visiteur
	case 1
		rb_val_ntrf.checked = true
		rb_val_ntrf.triggerevent("clicked")
	case 2
		rb_annulees.checked = true		
		rb_annulees.triggerevent("clicked")
end choose


end event

event ue_ok;/* <DESC>
      Permet la dévalidation d'une commande validée mais non transférées dans SAP.
   </DESC> */
long ll_row

ll_row = dw_1.getRow()
if  ll_row = 0 then
	return
end if	

IF messagebox (This.title,g_nv_traduction.get_traduction("VALIDE_INTERVENTION") + " " +dw_1.GetItemString(ll_row, "numaecde") + " ?",Question!,YesNo!,2) = 2 THEN
	dw_1.SetFocus ()
	RETURN
End if

if  dw_1.GetItemString(ll_row,DBNAME_ETAT_CDE) = COMMANDE_VALIDEE then
	dw_1.SetItem (ll_row, DBNAME_ETAT_CDE, COMMANDE_SUSPENDUE)
     dw_1.SetItem (ll_row, DBNAME_DATE_CREATION,i_tr_sql.fnv_get_datetime ())
     dw_1.SetItem (ll_row, DBNAME_VISITEUR_MAJ, g_s_visiteur)
     dw_1.Update ()
end if

if  dw_1.GetItemString(ll_row,DBNAME_CODE_MAJ) = COMMANDE_SUPPRIMEE then
	dw_1.SetItem (ll_row, DBNAME_CODE_MAJ, COMMANDE_REACTIVEE)
     dw_1.SetItem (ll_row, DBNAME_DATE_CREATION,i_tr_sql.fnv_get_datetime ())
     dw_1.SetItem (ll_row, DBNAME_VISITEUR_MAJ, g_s_visiteur)
     dw_1.Update ()
end if

dw_1.retrieve(g_s_visiteur)
end event

on w_liste_cde_intervention.create
int iCurrent
call super::create
this.rb_val_ntrf=create rb_val_ntrf
this.rb_annulees=create rb_annulees
this.mle_texte_inter=create mle_texte_inter
this.gb_visu_cde=create gb_visu_cde
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_val_ntrf
this.Control[iCurrent+2]=this.rb_annulees
this.Control[iCurrent+3]=this.mle_texte_inter
this.Control[iCurrent+4]=this.gb_visu_cde
end on

on w_liste_cde_intervention.destroy
call super::destroy
destroy(this.rb_val_ntrf)
destroy(this.rb_annulees)
destroy(this.mle_texte_inter)
destroy(this.gb_visu_cde)
end on

event ue_cancel;/* <DESC>
   Permet de quitter la fenetre
   </DESC> */
   destroy itooltip
	Message.fnv_set_str_pass(i_str_pass)
	Close (This)
end event

type uo_statusbar from w_a_liste`uo_statusbar within w_liste_cde_intervention
end type

type cb_cancel from w_a_liste`cb_cancel within w_liste_cde_intervention
integer taborder = 0
end type

type cb_ok from w_a_liste`cb_ok within w_liste_cde_intervention
integer taborder = 0
end type

type dw_1 from w_a_liste`dw_1 within w_liste_cde_intervention
event mousemove pbm_mousemove
string tag = "A_TRADUIRE"
integer x = 142
integer y = 292
integer width = 3058
integer height = 1280
string dataobject = "d_liste_cde_intervention"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type pb_ok from w_a_liste`pb_ok within w_liste_cde_intervention
integer x = 1362
integer y = 1628
integer width = 366
integer taborder = 0
string text = "Valid.  F11"
boolean default = false
string picturename = "c:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_echap from w_a_liste`pb_echap within w_liste_cde_intervention
integer x = 645
integer y = 1628
integer width = 366
integer taborder = 0
string picturename = "c:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type rb_val_ntrf from u_rba within w_liste_cde_intervention
integer x = 2135
integer y = 92
integer width = 736
integer height = 72
boolean bringtotop = true
string facename = "Arial"
long backcolor = 12632256
string text = "Validée non transférée"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.setFilter(DBNAME_ETAT_CDE +" <> '" +COMMANDE_TRANSFEE +  "' and " +  DBNAME_ETAT_CDE + " = '" +COMMANDE_VALIDEE +  "'")
dw_1.filter()
g_i_option_liste_cde_visiteur = 1
end event

type rb_annulees from u_rba within w_liste_cde_intervention
integer x = 2135
integer y = 168
integer width = 741
integer height = 72
boolean bringtotop = true
string facename = "Arial"
long backcolor = 12632256
string text = "Annulées"
end type

event clicked;call super::clicked;dw_1.setFilter(DBNAME_CODE_MAJ +" = '" +COMMANDE_SUPPRIMEE +  "'")
dw_1.Filter( )
g_i_option_liste_cde_visiteur = 2
end event

type mle_texte_inter from multilineedit within w_liste_cde_intervention
integer x = 69
integer y = 40
integer width = 1783
integer height = 192
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Cette option va permettre de :dévalider un commande validée mais non transférées dans DIVALTO et de réactiver une commande supprimée."
borderstyle borderstyle = styleshadowbox!
end type

type gb_visu_cde from groupbox within w_liste_cde_intervention
integer x = 2094
integer y = 24
integer width = 818
integer height = 248
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Visualisation Cde"
end type

