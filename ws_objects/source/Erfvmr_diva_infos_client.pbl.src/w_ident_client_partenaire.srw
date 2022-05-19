$PBExportHeader$w_ident_client_partenaire.srw
$PBExportComments$Permet la sélection d'un client partenaire (Livre,payeur,..) à partir de plusieurs critères
forward
global type w_ident_client_partenaire from w_a_ident
end type
type sel_numaeclf_t from statictext within w_ident_client_partenaire
end type
type sel_abnaeclf_t from statictext within w_ident_client_partenaire
end type
type sel_abvaeclf_t from statictext within w_ident_client_partenaire
end type
type sel_codaereg_t from statictext within w_ident_client_partenaire
end type
type sle_code from u_slea_key within w_ident_client_partenaire
end type
type sle_nom from u_slea_key within w_ident_client_partenaire
end type
type sle_ville from u_slea_key within w_ident_client_partenaire
end type
type sle_region from u_slea_key within w_ident_client_partenaire
end type
type sel_codaepay_t from statictext within w_ident_client_partenaire
end type
type dw_pays from u_dw_udis within w_ident_client_partenaire
end type
end forward

global type w_ident_client_partenaire from w_a_ident
string tag = "IDENT_CLIENT_PART"
integer width = 1751
integer height = 1116
boolean controlmenu = false
long backcolor = 12632256
sel_numaeclf_t sel_numaeclf_t
sel_abnaeclf_t sel_abnaeclf_t
sel_abvaeclf_t sel_abvaeclf_t
sel_codaereg_t sel_codaereg_t
sle_code sle_code
sle_nom sle_nom
sle_ville sle_ville
sle_region sle_region
sel_codaepay_t sel_codaepay_t
dw_pays dw_pays
end type
global w_ident_client_partenaire w_ident_client_partenaire

type variables
DataWindowChild i_ds_liste_des_pays
boolean i_d_retour_direct = false
boolean i_b_liste_client_livre = false
boolean i_b_liste_client_payeur = false
end variables

forward prototypes
public function integer fw_liste_client ()
end prototypes

public function integer fw_liste_client ();/* <DESC>
     Cette fonction est appelée pour valider la sélection et afficher la liste des clients
	Un critère de sélection minimum est obligatoire
   </DESC>  	*/
	
string s_code_pays
s_code_pays = dw_pays.GetText()

// Contrôle au moins un critère sélectionné
IF 		RightTrim (sle_code.text) 	= DONNEE_VIDE &
	AND	RightTrim (sle_nom.text) 	= DONNEE_VIDE &
	AND	RightTrim (sle_ville.text) = DONNEE_VIDE &
	AND   RightTrim (s_code_pays) 	= DONNEE_VIDE &
	AND	RightTrim (sle_region.text) 	= DONNEE_VIDE THEN 
			messagebox(this.title ,g_nv_traduction.get_traduction(CRITERES_NON_RENSEIGNE),Information!,Ok!,1)
			RETURN -1
END IF

i_str_pass.s[1] = sle_code.text
i_str_pass.s[2] = sle_nom.text
i_str_pass.s[3] = sle_ville.text
i_str_pass.s[4] = s_code_pays
i_str_pass.s[5] = sle_region.text
i_str_pass.b[1] = i_b_liste_client_livre
i_str_pass.b[2] = false
i_str_pass.b[3] = i_b_liste_client_payeur

OpenWithParm (w_liste_client, i_str_pass)

i_str_pass = Message.fnv_get_str_pass()

Message.fnv_clear_str_pass()
RETURN 0


end function

event ue_ok;call super::ue_ok;/* <DEF>
    Permet de valider la saisie de la sélection en passant par la fenêtre d'affichage de la liste client. Si un seul client
    répond aux critéres, la validation du client est effectuée et on retourne sur la fiche client ou en saisie de commande.
	Par contre , si plusieurs clients repondent, La liste des clients s'affichera pour permettre d'effectuer la sélection.
   </DEF> */
	
// LISTE DES CLIENTS
IF This.fw_liste_client() = -1 THEN
		sle_code.SetFocus ()
	ELSE

	CHOOSE CASE i_str_pass.s_action
			CASE ACTION_OK
				Message.fnv_set_str_pass(i_str_pass)
				Close(This)
			CASE ACTION_CANCEL
				sle_code.SetFocus()
	END CHOOSE
END IF

end event

event ue_init;call super::ue_init;/* <DESC>
    Initialise l'affichage de la fenêtre en alimentant la liste déroulante de la liste des pays. 
	</DESC> */

dw_pays.getChild(DBNAME_PAYS, i_ds_liste_des_pays)

i_ds_liste_des_pays.setTransObject(i_tr_sql)
i_ds_liste_des_pays.retrieve(g_nv_come9par.get_code_langue())

dw_pays.SetTransObject(i_tr_sql)
dw_pays.Retrieve (g_nv_come9par.get_code_langue())
dw_pays.InsertRow(1)
i_ds_liste_des_pays.InsertRow(1)
dw_pays.setRow(1)


i_b_liste_client_livre = i_str_pass.b[1]
i_b_liste_client_payeur = i_str_pass.b[3]
end event

event ue_cancel;call super::ue_cancel;/* <DESC>
    Permet de quitter sans effectuer de sélection.
	 </DESC> */
	Message.fnv_set_str_pass(i_str_pass)
	Close (This)
end event

on w_ident_client_partenaire.create
int iCurrent
call super::create
this.sel_numaeclf_t=create sel_numaeclf_t
this.sel_abnaeclf_t=create sel_abnaeclf_t
this.sel_abvaeclf_t=create sel_abvaeclf_t
this.sel_codaereg_t=create sel_codaereg_t
this.sle_code=create sle_code
this.sle_nom=create sle_nom
this.sle_ville=create sle_ville
this.sle_region=create sle_region
this.sel_codaepay_t=create sel_codaepay_t
this.dw_pays=create dw_pays
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sel_numaeclf_t
this.Control[iCurrent+2]=this.sel_abnaeclf_t
this.Control[iCurrent+3]=this.sel_abvaeclf_t
this.Control[iCurrent+4]=this.sel_codaereg_t
this.Control[iCurrent+5]=this.sle_code
this.Control[iCurrent+6]=this.sle_nom
this.Control[iCurrent+7]=this.sle_ville
this.Control[iCurrent+8]=this.sle_region
this.Control[iCurrent+9]=this.sel_codaepay_t
this.Control[iCurrent+10]=this.dw_pays
end on

on w_ident_client_partenaire.destroy
call super::destroy
destroy(this.sel_numaeclf_t)
destroy(this.sel_abnaeclf_t)
destroy(this.sel_abvaeclf_t)
destroy(this.sel_codaereg_t)
destroy(this.sle_code)
destroy(this.sle_nom)
destroy(this.sle_ville)
destroy(this.sle_region)
destroy(this.sel_codaepay_t)
destroy(this.dw_pays)
end on

event ue_liste;call super::ue_liste;/* <DESC>
    Executer par l'activation de la touche F2 ou par le clique sur le bouton Liste.
    Ouverture de la fenêtre d'affichage de la liste des clients en fonction des
	paramétres saisis.
   </DESC> */
	
IF This.fw_liste_client() = -1 THEN
		sle_code.SetFocus ()
 ELSE
	CHOOSE CASE i_str_pass.s_action
			CASE ACTION_OK
				Message.fnv_set_str_pass(i_str_pass)
				Close(This)
			CASE ACTION_CANCEL
				sle_code.SetFocus()
	END CHOOSE
END IF

end event

event open;call super::open;/* <DESC>
    Cette fenêtre est utilisée lors de la création d'une entête de commande ou lors de la création d'un client
	prosect.
	
	Si l'on vient de la saisie d'entête de commande et que le visiteur est une assistante, affichage de la fenêtre
	des partenaires livrés du client donneur d'ordre puis retour à la saisie avec la sélection du client effectué sur la liste
	et cette fenêtre ne sera en aucun affiché
	
	Dans les autres cas, le fenêtre de sélection sera affichée.
     </DESC> */
if i_str_pass.s[2] <> OPTION_CLIENT then
	openwithParm(w_liste_client_partenaire, i_str_pass)
	i_str_pass = Message.fnv_get_str_pass()
	Message.fnv_set_str_pass(i_str_pass)
	Close(This)
	return
end if
end event

type uo_statusbar from w_a_ident`uo_statusbar within w_ident_client_partenaire
end type

type pb_ok from w_a_ident`pb_ok within w_ident_client_partenaire
integer x = 37
integer y = 740
integer taborder = 0
string text = "Valid.  F11"
boolean default = false
string picturename = "C:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_liste from w_a_ident`pb_liste within w_ident_client_partenaire
integer x = 791
integer y = 740
integer taborder = 0
string picturename = "C:\appscir\Erfvmr_diva\Image\pbliste.bmp"
string disabledname = "C:\appscir\Erfvmr_diva\Image\pbliste.bmp"
end type

type pb_echap from w_a_ident`pb_echap within w_ident_client_partenaire
integer x = 1166
integer y = 740
integer taborder = 0
string picturename = "C:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type pb_nouveau from w_a_ident`pb_nouveau within w_ident_client_partenaire
boolean visible = false
integer x = 416
integer y = 740
integer taborder = 0
string picturename = "C:\appscir\Erfvmr_diva\Image\pbnouv.bmp"
string disabledname = "C:\appscir\Erfvmr_diva\Image\pbnouv.bmp"
end type

type sel_numaeclf_t from statictext within w_ident_client_partenaire
integer x = 64
integer y = 112
integer width = 535
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "N° client            :"
boolean focusrectangle = false
end type

type sel_abnaeclf_t from statictext within w_ident_client_partenaire
integer x = 64
integer y = 232
integer width = 544
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Nom client        :"
boolean focusrectangle = false
end type

type sel_abvaeclf_t from statictext within w_ident_client_partenaire
integer x = 64
integer y = 476
integer width = 539
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Ville                  :"
boolean focusrectangle = false
end type

type sel_codaereg_t from statictext within w_ident_client_partenaire
integer x = 64
integer y = 600
integer width = 549
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Région             :"
boolean focusrectangle = false
end type

type sle_code from u_slea_key within w_ident_client_partenaire
string tag = "Tapez le numéro du client"
integer x = 663
integer y = 100
integer width = 475
integer height = 96
integer taborder = 10
integer textsize = -10
textcase textcase = upper!
integer limit = 10
end type

type sle_nom from u_slea_key within w_ident_client_partenaire
string tag = "Tapez le nom du client"
integer x = 663
integer y = 220
integer width = 471
integer height = 96
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
textcase textcase = upper!
integer limit = 10
end type

type sle_ville from u_slea_key within w_ident_client_partenaire
string tag = "Tapez la ville du client"
integer x = 663
integer y = 464
integer width = 805
integer height = 96
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
textcase textcase = upper!
integer limit = 20
end type

type sle_region from u_slea_key within w_ident_client_partenaire
string tag = "Tapez le département du client"
integer x = 663
integer y = 588
integer width = 183
integer height = 96
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
textcase textcase = upper!
integer limit = 3
end type

type sel_codaepay_t from statictext within w_ident_client_partenaire
integer x = 69
integer y = 360
integer width = 526
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Pays                 :"
boolean focusrectangle = false
end type

type dw_pays from u_dw_udis within w_ident_client_partenaire
integer x = 663
integer y = 348
integer width = 978
integer height = 96
integer taborder = 11
boolean bringtotop = true
string dataobject = "dd_pays"
boolean border = false
end type

event we_dwnkey;call super::we_dwnkey;
IF KeyDown(KeyF2!) THEN
		parent.PostEvent ("ue_liste")
END IF

IF KeyDown(KeyF11!) THEN
		parent.PostEvent ("ue_ok")
END IF
end event

