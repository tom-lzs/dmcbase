$PBExportHeader$w_sel_ref.srw
$PBExportComments$Sélection des réferences à consulter
forward
global type w_sel_ref from w_a_selection
end type
type art_t from statictext within w_sel_ref
end type
type dim_t from statictext within w_sel_ref
end type
type mot_cle_t from statictext within w_sel_ref
end type
type sle_dimension from u_slea_key within w_sel_ref
end type
type sle_article from u_slea_key within w_sel_ref
end type
type sle_ref from u_slea_key within w_sel_ref
end type
type liste_prix_t from statictext within w_sel_ref
end type
type devise_t from statictext within w_sel_ref
end type
type sle_liste_prix from singlelineedit within w_sel_ref
end type
type sle_devise from singlelineedit within w_sel_ref
end type
type sel_tarif_t from statictext within w_sel_ref
end type
type sel_ref_t from statictext within w_sel_ref
end type
type rr_1 from roundrectangle within w_sel_ref
end type
type rr_2 from roundrectangle within w_sel_ref
end type
end forward

global type w_sel_ref from w_a_selection
string tag = "RECHERCHE_REFERENCE"
integer x = 763
integer y = 684
integer width = 2121
integer height = 1396
string title = "*Recherche d~'une référence*"
long backcolor = 12632256
event ue_listes ( )
art_t art_t
dim_t dim_t
mot_cle_t mot_cle_t
sle_dimension sle_dimension
sle_article sle_article
sle_ref sle_ref
liste_prix_t liste_prix_t
devise_t devise_t
sle_liste_prix sle_liste_prix
sle_devise sle_devise
sel_tarif_t sel_tarif_t
sel_ref_t sel_ref_t
rr_1 rr_1
rr_2 rr_2
end type
global w_sel_ref w_sel_ref

type variables
string is_colonne
end variables

event ue_listes();/* <DESC>
    Affichage des listes correspondantes au champ en cours de saisie et
	 ceci lors de l'activation de la touche F2. 
	 Va permettre d''afficher la liste des marchés, des listes de prix et des devises
</DESC> */ 

// Listes proposées quand F2 sur une colonne
// -----------------------------------------
// DECLARATION DES VARIABLES LOCALES
String		s_colonne
String 		s_code_colonne
Str_pass		str_work


if not i_str_pass.b[1] then
	return
end if

s_colonne = is_colonne
str_work.s[1] = s_colonne
str_work.s[2] = BLANK
str_work.s[3] = i_str_pass.s[1]

str_work = g_nv_liste_manager.get_list_of_column(str_work)

	
// cette action provient de la fenetre de selection appelée
// prédemment - click sur cancel
if str_work.s_action =  ACTION_CANCEL then
	return
end if

// Mise à jour de la datawindow correspondante à la liste selectionnee
choose case s_colonne
	case DBNAME_CODE_DEVISE
		sle_devise.text = str_work.s[1]
end choose


end event

event key;call super::key;/* <DESC>
   Permet de trapper les touches de fonction activées et déclencher l'évènement associé
	à la touche.
	  F11 = Validation de la sélecion et retour sur la fenetre d'affichage
	        du résultat de la sélection.
	  F2 = Affichage de la liste des codes - utilisée lors de la modification

   </DESC> */

	IF KeyDown (KeyF11!) THEN
		This.TriggerEvent ("ue_ok")
	END IF
		
	IF KeyDown (KeyF2!) THEN
		This.PostEvent ("ue_listes")
	END IF
	
end event

event ue_ok;call super::ue_ok;/* <DESC>
     Validation de la saisie de la sélection.
	  Un critère minimum est obligatoire pour pouvoir sélectionner une
	  référence.
	  Controle de la validité des codes marché,liste de prix,devise pour les
	  éléments de sélection du tarif.
	  Si tout est ok , quitte cette fenêtre pour retourner sur la fenetre
	  affichant le résultat de la séelection en lui passant les critères
	  saisis.
   </DESC> */
	
Str_pass    l_str_work
nv_control_manager nv_check_value 
nv_check_value = CREATE nv_control_manager

// ----------------------------------------
// AU MOINS UN CRITERE DOIT ETRE RENSEIGNE
// ----------------------------------------

IF		Trim (sle_article.Text)		= "" &
AND	Trim (sle_dimension.Text) 	= "" &
AND 	Trim (sle_ref.Text)			= "" THEN
	messagebox (This.title,g_nv_traduction.get_traduction(RENSEIGNER_CRITERE_REFERENCE) + "~r" + g_nv_traduction.get_traduction(VALIDER_MERCI),  & 
						Information!,Ok!,1)
	sle_article.SetFocus()
	RETURN
end if

if Trim(sle_liste_prix.text) = DONNEE_VIDE or isNull(sle_liste_prix.text) then
	MessageBox (This.title,g_nv_traduction.get_traduction(LISTE_PRIX_OBLIGATOIRE) + g_nv_traduction.get_traduction(OBTENIR_LISTE),StopSign!,Ok!,1)
	sle_liste_prix.SetFocus ()
	Message.ReturnValue = -1	
end if

// Contrôle du code Devise
	l_str_work.s[1] = sle_devise.text
	l_str_work.s[2] = BLANK
   l_str_work = nv_check_value.is_devise_valide (l_str_work)
	if not l_str_work.b[1] then	
		MessageBox (This.title,g_nv_traduction.get_traduction( DEVISE_INEXISTANTE) + g_nv_traduction.get_traduction(OBTENIR_LISTE),StopSign!,Ok!,1)
		sle_devise.SetFocus ()
		Message.ReturnValue = -1
		RETURN
	end if	
	destroy nv_check_value

i_str_pass.s[1] = sle_article.Text
i_str_pass.s[2] = sle_dimension.Text
i_str_pass.s[3] = sle_ref.Text
i_str_pass.s[5] = sle_liste_prix.Text
i_str_pass.s[6] = sle_devise.Text

Message.fnv_set_str_pass(i_str_pass)
Close (This)

end event

on w_sel_ref.create
int iCurrent
call super::create
this.art_t=create art_t
this.dim_t=create dim_t
this.mot_cle_t=create mot_cle_t
this.sle_dimension=create sle_dimension
this.sle_article=create sle_article
this.sle_ref=create sle_ref
this.liste_prix_t=create liste_prix_t
this.devise_t=create devise_t
this.sle_liste_prix=create sle_liste_prix
this.sle_devise=create sle_devise
this.sel_tarif_t=create sel_tarif_t
this.sel_ref_t=create sel_ref_t
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.art_t
this.Control[iCurrent+2]=this.dim_t
this.Control[iCurrent+3]=this.mot_cle_t
this.Control[iCurrent+4]=this.sle_dimension
this.Control[iCurrent+5]=this.sle_article
this.Control[iCurrent+6]=this.sle_ref
this.Control[iCurrent+7]=this.liste_prix_t
this.Control[iCurrent+8]=this.devise_t
this.Control[iCurrent+9]=this.sle_liste_prix
this.Control[iCurrent+10]=this.sle_devise
this.Control[iCurrent+11]=this.sel_tarif_t
this.Control[iCurrent+12]=this.sel_ref_t
this.Control[iCurrent+13]=this.rr_1
this.Control[iCurrent+14]=this.rr_2
end on

on w_sel_ref.destroy
call super::destroy
destroy(this.art_t)
destroy(this.dim_t)
destroy(this.mot_cle_t)
destroy(this.sle_dimension)
destroy(this.sle_article)
destroy(this.sle_ref)
destroy(this.liste_prix_t)
destroy(this.devise_t)
destroy(this.sle_liste_prix)
destroy(this.sle_devise)
destroy(this.sel_tarif_t)
destroy(this.sel_ref_t)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event ue_init;call super::ue_init;/* <DESC>
    Initialisation de la fenêtre en alimentant les éléments tarifs à partir
	 de ceux passés en paramètre 
	 Si l'appel a été effectué par la saisie de commande, les éléments tarifs
	 sont affichés en lecture uniquement.
   </DESC> */
sle_liste_prix.text 	= i_str_pass.s[5]
sle_devise.text 		= i_str_pass.s[6]

if not i_str_pass.b[1] then
	sle_liste_prix.DisplayOnly = true		
	sle_devise.DisplayOnly = true	
end if

end event

type uo_statusbar from w_a_selection`uo_statusbar within w_sel_ref
end type

type pb_ok from w_a_selection`pb_ok within w_sel_ref
integer x = 590
integer y = 984
integer taborder = 80
string picturename = "c:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_echap from w_a_selection`pb_echap within w_sel_ref
integer x = 1202
integer y = 984
integer taborder = 90
string picturename = "c:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type art_t from statictext within w_sel_ref
integer x = 146
integer y = 160
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
boolean focusrectangle = false
end type

type dim_t from statictext within w_sel_ref
integer x = 146
integer y = 264
integer width = 466
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 12632256
boolean enabled = false
string text = "Dimension     :"
boolean focusrectangle = false
end type

type mot_cle_t from statictext within w_sel_ref
integer x = 160
integer y = 368
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
boolean focusrectangle = false
end type

type sle_dimension from u_slea_key within w_sel_ref
integer x = 608
integer y = 252
integer width = 430
integer height = 72
integer taborder = 20
integer weight = 700
textcase textcase = upper!
integer limit = 8
end type

type sle_article from u_slea_key within w_sel_ref
integer x = 608
integer y = 148
integer width = 754
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer weight = 700
textcase textcase = upper!
integer limit = 18
end type

type sle_ref from u_slea_key within w_sel_ref
integer x = 617
integer y = 360
integer width = 1061
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer weight = 700
textcase textcase = upper!
end type

type liste_prix_t from statictext within w_sel_ref
integer x = 146
integer y = 668
integer width = 448
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

type devise_t from statictext within w_sel_ref
string tag = "liste"
integer x = 146
integer y = 760
integer width = 448
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
string text = "° Devise :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_liste_prix from singlelineedit within w_sel_ref
integer x = 658
integer y = 668
integer width = 274
integer height = 68
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
end type

event getfocus;is_colonne = BLANK
end event

type sle_devise from singlelineedit within w_sel_ref
integer x = 658
integer y = 760
integer width = 279
integer height = 64
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
end type

event getfocus;is_colonne = DBNAME_CODE_DEVISE
end event

type sel_tarif_t from statictext within w_sel_ref
integer x = 343
integer y = 548
integer width = 1385
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 12632256
string text = "Sélection Tarifs"
alignment alignment = center!
boolean focusrectangle = false
end type

type sel_ref_t from statictext within w_sel_ref
integer x = 302
integer y = 24
integer width = 1417
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 12632256
string text = "Sélection références"
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_sel_ref
integer linethickness = 4
long fillcolor = 12632256
integer x = 110
integer y = 608
integer width = 1829
integer height = 288
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_sel_ref
integer linethickness = 4
long fillcolor = 12632256
integer x = 119
integer y = 104
integer width = 1806
integer height = 408
integer cornerheight = 40
integer cornerwidth = 46
end type

