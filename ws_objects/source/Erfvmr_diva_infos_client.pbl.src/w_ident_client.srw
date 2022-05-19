$PBExportHeader$w_ident_client.srw
$PBExportComments$Permet la sélection d'un client donneur d'ordre ou interne
forward
global type w_ident_client from w_a_ident
end type
type sel_numaeclf_t from statictext within w_ident_client
end type
type sel_abnaeclf_t from statictext within w_ident_client
end type
type sel_abvaeclf_t from statictext within w_ident_client
end type
type sel_codaereg_t from statictext within w_ident_client
end type
type sle_code from u_slea_key within w_ident_client
end type
type sle_nom from u_slea_key within w_ident_client
end type
type sle_ville from u_slea_key within w_ident_client
end type
type sle_region from u_slea_key within w_ident_client
end type
type sel_codaepay_t from statictext within w_ident_client
end type
type dw_pays from u_dw_udis within w_ident_client
end type
end forward

global type w_ident_client from w_a_ident
string tag = "IDENT_CLIENT"
integer width = 1801
integer height = 1160
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
global w_ident_client w_ident_client

type variables
DataWindowChild i_ds_liste_des_pays

//permet apres selection du client de retourner directement sur la fenetre d'appel sans
// d'abord passer par l'affichage des infos clients. Ceci est vrai lors de la creation d'une nouvelle commande
boolean i_d_retour_direct = false 
boolean i_affiche_cliliv 
boolean i_affiche_clido
boolean i_affiche_clipa
boolean i_affiche_tous

end variables

forward prototypes
public function integer fw_liste_client ()
end prototypes

public function integer fw_liste_client ();/* <DESC>
     Permet de valider la saisie de la sélection et afficher la liste des clients
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

i_str_pass.b[1] = i_affiche_cliliv //false 
i_str_pass.b[2] = i_affiche_clido //true 
i_str_pass.b[3] = i_affiche_clipa //false
i_str_pass.b[4] = i_affiche_tous //false

OpenWithParm (w_liste_client, i_str_pass)

i_str_pass = Message.fnv_get_str_pass()
Message.fnv_clear_str_pass()
RETURN 0


end function

event ue_ok;call super::ue_ok;/* <DESC>
    Permet de valider la saisie de la sélection en passant par la fenêtre d'affichage de la liste client. Si un seul client
    répond aux critéres, la validation du client est effectuée et on retourne sur la fiche client ou en saisie de commande.
	Par contre , si plusieurs clients repondent, La liste des clients s'affichera pour permettre d'effectuer la sélection.
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

event ue_init;call super::ue_init;/* <DESC>
    Initialise l'affichage de la fenetre en alimentant la liste déroulante de la liste des pays. 
	 Si l'appel est effectué en mode saisie de commande, le bouton de création d'un
	 client prospect sera rendu visible.
   </DESC> */
     
i_affiche_cliliv = i_str_pass.b[20]
i_affiche_clido = i_str_pass.b[21]
i_affiche_clipa = i_str_pass.b[22]
i_affiche_tous = i_str_pass.b[23]

// AFFICHAGE DU BOUTON NOUVEAU
If upperBound(i_str_pass.b,1) <> 0 then
	If i_str_pass.b[1]	=	True then
		pb_nouveau.Visible = TRUE
	End if
END IF

if upperBound(i_str_pass.s,1) <> 0 then
	this.title = this.title + BLANK + i_str_pass.s[1]
end if

 if upperBound(i_str_pass.b,20) <> 0 then
	i_d_retour_direct = i_str_pass.b[20]
end if

dw_pays.getChild(DBNAME_PAYS, i_ds_liste_des_pays)

i_ds_liste_des_pays.setTransObject(i_tr_sql)
i_ds_liste_des_pays.retrieve(g_nv_come9par.get_code_langue())
dw_pays.SetTransObject(i_tr_sql)
dw_pays.Retrieve (g_nv_come9par.get_code_langue())
dw_pays.InsertRow(1)
i_ds_liste_des_pays.InsertRow(1)
dw_pays.setRow(1)

g_nv_traduction.set_traduction_datawindow(dw_pays)



end event

event ue_new;call super::ue_new;/* <DESC>
     Ouverture de la fenetre de création d'un client prospect
  </DESC> */
	  
	i_str_pass.s_action = ACTION_NEW
     OpenWithParm (w_nouveau_client, i_str_pass)
	i_str_pass = Message.fnv_get_str_pass()
	Message.fnv_set_str_pass(i_str_pass)
	Close (This)
end event

event ue_cancel;call super::ue_cancel;/* <DESC>
    Permet de quitter sans effectuer de sélection.
	 </DESC> */
	 
// FERMETURE DE LA FENÊTRE
	Message.fnv_set_str_pass(i_str_pass)
	Close (This)
end event

on w_ident_client.create
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

on w_ident_client.destroy
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
		
	 En retour de la liste des clients, affichage du code client, de son nom, de son pays, de sa ville et de sa région
	 pour validation par la touche F11
	 
	 Si un seul client répond aux critères, on actualise directement la fenetre à partir des elements du client sans afficher la liste des clients
   </DESC> */

i_str_pass.s_action = ACTION_OK

 IF This.fw_liste_client() = -1 THEN
	sle_code.SetFocus ()
	return
end if

// La variable i_action peut modifié dans la fonction précédemment
// appelée lors de l'appel de la liste des client
CHOOSE CASE i_str_pass.s_action
	CASE ACTION_OK
		if i_d_retour_direct then
			Message.fnv_set_str_pass(i_str_pass)
			Close(This)
			return
		end if
		
		nv_client_object lu_client
		lu_client = i_str_pass.po[1]
		sle_code.text	= i_str_pass.s[1]
		sle_nom.text 	= lu_client.fu_get_abrege_nom( )
		sle_ville.text 	= lu_client.fu_get_abrege_ville()

		integer l_indice
		for l_indice = 1 to dw_pays.RowCount()
			if lu_client.fu_get_code_pays()  = dw_pays.getItemString(l_indice, DBNAME_PAYS) then
				dw_pays.scrollToRow(l_indice)
			end if
		next
		sle_region.text 		= lu_client.fu_get_region()
		
	CASE ACTION_CANCEL
		sle_code.SetFocus()
	CASE ELSE
END CHOOSE


end event

type uo_statusbar from w_a_ident`uo_statusbar within w_ident_client
integer y = 832
integer height = 88
end type

type pb_ok from w_a_ident`pb_ok within w_ident_client
integer x = 37
integer y = 740
integer taborder = 0
string text = "Valid.  F11"
string picturename = "C:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_liste from w_a_ident`pb_liste within w_ident_client
integer x = 791
integer y = 740
integer taborder = 0
boolean enabled = false
string picturename = "C:\appscir\Erfvmr_diva\Image\pbliste.bmp"
string disabledname = "C:\appscir\Erfvmr_diva\Image\pbliste.bmp"
end type

type pb_echap from w_a_ident`pb_echap within w_ident_client
integer x = 1166
integer y = 740
integer taborder = 0
string picturename = "C:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type pb_nouveau from w_a_ident`pb_nouveau within w_ident_client
boolean visible = false
integer x = 416
integer y = 740
integer taborder = 0
boolean default = false
string picturename = "C:\appscir\Erfvmr_diva\Image\pbnouv.bmp"
string disabledname = "C:\appscir\Erfvmr_diva\Image\pbnouv.bmp"
end type

type sel_numaeclf_t from statictext within w_ident_client
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

type sel_abnaeclf_t from statictext within w_ident_client
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

type sel_abvaeclf_t from statictext within w_ident_client
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

type sel_codaereg_t from statictext within w_ident_client
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

type sle_code from u_slea_key within w_ident_client
string tag = "Tapez le numéro du client"
integer x = 663
integer y = 100
integer width = 475
integer height = 96
integer taborder = 10
textcase textcase = upper!
integer limit = 10
end type

type sle_nom from u_slea_key within w_ident_client
string tag = "Tapez le nom du client"
integer x = 663
integer y = 220
integer width = 983
integer height = 96
integer taborder = 20
boolean bringtotop = true
textcase textcase = upper!
integer limit = 10
end type

type sle_ville from u_slea_key within w_ident_client
string tag = "Tapez la ville du client"
integer x = 663
integer y = 464
integer width = 805
integer height = 96
integer taborder = 40
boolean bringtotop = true
textcase textcase = upper!
integer limit = 20
end type

type sle_region from u_slea_key within w_ident_client
string tag = "Tapez le département du client"
integer x = 663
integer y = 588
integer width = 183
integer height = 96
integer taborder = 50
boolean bringtotop = true
textcase textcase = upper!
integer limit = 3
end type

type sel_codaepay_t from statictext within w_ident_client
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

type dw_pays from u_dw_udis within w_ident_client
string tag = "A_TRADUIRE"
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

