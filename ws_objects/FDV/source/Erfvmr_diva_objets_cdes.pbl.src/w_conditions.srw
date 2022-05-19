$PBExportHeader$w_conditions.srw
$PBExportComments$Saisir les conditions générales pour les lignes de commande issues de la saisie catalogue, promotion et bon de commande
forward
global type w_conditions from w_a_selection
end type
type cbx_direct_indirect from u_cbxa within w_conditions
end type
type st_direct_indirect from statictext within w_conditions
end type
type sle_grossiste from u_slea within w_conditions
end type
type st_grossiste from statictext within w_conditions
end type
type st_livraison from statictext within w_conditions
end type
type dataepri_t from statictext within w_conditions
end type
type st_echeance from statictext within w_conditions
end type
type st_taux_remise from statictext within w_conditions
end type
type sle_date from u_ema within w_conditions
end type
type sle_remise from u_ema within w_conditions
end type
type em_date_prix from u_ema within w_conditions
end type
type sle_echeance from u_slea within w_conditions
end type
type sle_echeance_intitule from u_slea within w_conditions
end type
type sle_paiement_intitule from u_slea within w_conditions
end type
type st_drop from statictext within w_conditions
end type
type cbx_drop from u_cbxa within w_conditions
end type
type sle_mode_cond from u_slea within w_conditions
end type
type sle_paiement from u_slea within w_conditions
end type
end forward

global type w_conditions from w_a_selection
string tag = "fin_saisie_bon"
integer width = 2798
integer height = 1216
string title = "*Fin de saisie du bon*"
long backcolor = 12632256
event ue_grossiste pbm_custom40
event ue_listes ( )
cbx_direct_indirect cbx_direct_indirect
st_direct_indirect st_direct_indirect
sle_grossiste sle_grossiste
st_grossiste st_grossiste
st_livraison st_livraison
dataepri_t dataepri_t
st_echeance st_echeance
st_taux_remise st_taux_remise
sle_date sle_date
sle_remise sle_remise
em_date_prix em_date_prix
sle_echeance sle_echeance
sle_echeance_intitule sle_echeance_intitule
sle_paiement_intitule sle_paiement_intitule
st_drop st_drop
cbx_drop cbx_drop
sle_mode_cond sle_mode_cond
sle_paiement sle_paiement
end type
global w_conditions w_conditions

type variables
nv_commande_object i_nv_commande_object

String is_colonne

String is_type_ligne
String is_grossiste
String is_echeance
String is_paiement
Decimal id_remise
Date	  i_date_livraison
Date    i_date_prix
Date i_d_lancement

String is_echeance_new = BLANK
String is_paiement_new = BLANK

end variables

event ue_grossiste;/* <DESC>
      Affichage de la liste des grossistes.
	cette liste s'affichae lors de l'activation de la touche F2 si le curseur
	est positionné dans la zone grossiste.
	</DESC> */
// DECLARATION DES VARIABLES LOCALES
	Str_pass		str_work


// LISTE DES CODES GROSSISTES
	str_work.s[1] = " "
	str_work.s[4] = " "
	str_work.s[7] = " "
	
	OpenWithParm(w_liste_grossiste,str_work)

	str_work = Message.fnv_get_str_pass()
	Message.fnv_clear_str_pass()

//	str_work = Message.PowerObjectParm

	CHOOSE CASE str_work.s_action
		CASE "ok"
			sle_grossiste.Text = str_work.s[1]
		CASE ELSE
	END CHOOSE
end event

event ue_listes();/* <DESC>
    Affichage des listes correspondantes au champ en cours de saisie et
	 ceci lors de l'activation de la touche F2. Option accessible en modificaiton de client
	 va permettre d'afficher la liste de valeur des codes echeance et mode de paiement
</DESC> */ 
Str_pass		str_work

nv_control_manager nv_check_value 
nv_check_value = CREATE nv_control_manager

str_work.s[1] = DBNAME_CODE_ECHEANCE
str_work = g_nv_liste_manager.get_list_of_column(str_work)

if str_work.s_action =  ACTION_CANCEL then
	return
end if

is_echeance_new = str_work.s[1]
sle_echeance.text = str_work.s[1]	
sle_echeance_intitule.text = str_work.s[2]
sle_paiement.text = mid(sle_echeance.text,1,1)

// RECHERCHE du mode de paiement  
str_work.s[1] =sle_paiement.text 
str_work.s[2] = BLANK
str_work = nv_check_value.is_mode_paiement_valide (str_work)
sle_paiement.text = is_paiement
sle_paiement_intitule.text = str_work.s[2]

sle_mode_cond.text = trim(sle_paiement_intitule.text) + " -  " + trim(sle_echeance_intitule.text)

destroy nv_check_value
end event

event ue_ok;call super::ue_ok;/* <DESC>
    Validation de la saisie des conditions, passage des paramètres saisis à al fenetre
	 d'appel et fermeture de la fenêtre.
	 <LI>La date de livraison doit être supérieure à la date de la commande et de saisie 
	         et supérieure à la date de lancement de la promotion si renseignée
	 <LI> Code échéance doit être existant
	 <LI> Mode de paiement doit être existant
   </DESC> */
SetPointer (HourGlass!)

// Controle des codes
nv_control_manager nv_check_value 
nv_check_value = CREATE nv_control_manager
Str_pass l_str_work
Date     ld_date_livraison
Date  ld_date

// DECLARATION DES VARIABLES LOCALES
String		s_code_retour
String		s_code_manquant
String		s_lib_manquant
String		s_code_echeance
String		s_mode_paiement
String		s_nom
String		s_ville

s_code_retour = space (3)

// -------------------------------------------------------
// CONTRÔLE DE LA VALIDITE DU CODE GROSSISTE SAISI
// si on passe en livraison indirecte et si le code grossiste
// n'est pas sur l'entête de commande
// -------------------------------------------------------
IF cbx_direct_indirect.Checked = FALSE THEN
	IF trim(sle_grossiste.text) <> DONNEE_VIDE  and not isNull(sle_grossiste.text) THEN
		l_str_work.s[1] = sle_grossiste.text
		l_str_work.s[2] = BLANK
		l_str_work = nv_check_value.is_grossiste_valide (l_str_work)
		if not l_str_work.b[1] then	
			MessageBox (This.title,g_nv_traduction.get_traduction(GROSSISTE_INEXISTANT) + g_nv_traduction.get_traduction(OBTENIR_LISTE),StopSign!,Ok!,1)
			sle_grossiste.SetFocus ()
			RETURN
		end if	
	else
		MessageBox (This.title,g_nv_traduction.get_traduction(GROSSISTE_OBLIGATOIRE) + g_nv_traduction.get_traduction(OBTENIR_LISTE),StopSign!,Ok!,1)		
		sle_grossiste.SetFocus ()		
	end if
END IF

// ------------------------------------------------------
// CONTRÔLE DE LA VALIDITE DE LA DATE DE LIVRAISON SAISIE
// ------------------------------------------------------
	// La zone date de livraison a été supprimée
IF sle_date.Text = DONNEE_VIDE &
OR IsNull (sle_date.Text) THEN
	sle_date.Text = String (i_date_livraison)
END IF

ld_date_livraison = date(sle_date.text)
if not isnull(ld_date_livraison ) and ld_date_livraison <>date( DATE_DEFAULT_SYBASE) then
	if not nv_check_value.is_date_valide(sle_date.text) then
		messagebox (this.title,g_nv_traduction.get_traduction(DATE_LIVRAISON_ERRONEE3),StopSign!,Ok!,1)
		sle_date.SetFocus()	
		return
	end if
end if

// La date de livraison a été modifiée
IF ld_date_livraison <> i_date_livraison THEN
	// Elle doit être supérieure ou égale à la date de commande
	IF ld_date_livraison < i_nv_commande_object.fu_get_date_cde() THEN
		MessageBox (this.title,g_nv_traduction.get_traduction(DATE_LIVRAISON_ERRONEE),StopSign!,Ok!,1)
		sle_date.SetFocus()
		RETURN
	END IF

	// Elle doit être supérieure à la date de saisie de la commande
	IF ld_date_livraison <=  i_nv_commande_object.fu_get_date_saisie_cde() THEN
		MessageBox (this.title,g_nv_traduction.get_traduction(DATE_LIVRAISON_ERRONEE2),StopSign!,Ok!,1)
		sle_date.SetFocus()
		RETURN
	END IF 
	
    if not  nv_check_value.is_date_liv_valide(sle_date.text) then
	    sle_date.SetFocus()
	    RETURN
   END IF	
	
END IF

ld_date = ld_date_livraison
if isnull( ld_date) or  ld_date_livraison = date( DATE_DEFAULT_SYBASE) then
   ld_date = i_nv_commande_object.fu_get_date_cde()
end if

// la date de livraison doit être supérieure à la date de lancement de la promotion
if not isnull(i_d_lancement) then
	if ld_date <= i_d_lancement  then
		ld_date_livraison = i_d_lancement
		sle_date.text = string(ld_date_livraison)
	end if
end if


// ---------------------------------------------------------------------
// CONTRÔLE DE LA VALIDITE DU CODE ECHEANCE 
// ---------------------------------------------------------------------
s_code_echeance  	= sle_echeance.text
IF IsNull (s_code_echeance) OR s_code_echeance = ""  or s_code_echeance = "EC" THEN
	s_code_echeance = is_echeance
	IF IsNull (s_code_echeance) OR s_code_echeance = ""  THEN
		MessageBox (This.title,g_nv_traduction.get_traduction(ECHEANCE_INEXISTANTE) + g_nv_traduction.get_traduction(OBTENIR_LISTE),StopSign!,Ok!,1)
		sle_echeance.SetFocus ()
		RETURN
	end if
END IF

// RECHERCHE du code echeance
l_str_work.s[1] = s_code_echeance
l_str_work.s[2] = BLANK
l_str_work = nv_check_value.is_echeance_valide (l_str_work)
if not l_str_work.b[1] then
	MessageBox (This.title,g_nv_traduction.get_traduction(ECHEANCE_INEXISTANTE) + g_nv_traduction.get_traduction(OBTENIR_LISTE),StopSign!,Ok!,1)
	sle_echeance.SetFocus ()
	RETURN
end if	
sle_echeance_intitule.text = l_str_work.s[2]

// ------------------------------------------------------------------------
// recherche intitule du MODE DE PAIEMENT 
// ------------------------------------------------------------------------
sle_paiement.text =  mid(s_code_echeance,1,1)
s_mode_paiement = mid(s_code_echeance,1,1)

l_str_work.s[1] = sle_paiement.text
l_str_work.s[2] = BLANK
l_str_work = nv_check_value.is_mode_paiement_valide (l_str_work)

if not l_str_work.b[1] then
	sle_paiement_intitule.text = ""
else
     sle_paiement_intitule.text = l_str_work.s[2]
end if	  

sle_mode_cond.text = trim( sle_paiement_intitule.text) + " "+ trim( sle_echeance_intitule.text)

// ---------------------------------
// INITIALISATION DES CODES SAISIS
// ---------------------------------
i_str_pass.s_action = ACTION_OK


IF Date (sle_date.Text) = i_nv_commande_object.fu_get_date_livraison() THEN
	sle_date.Text = DATE_DEFAULT_SYBASE
end if
IF Date (em_date_prix.Text) = i_nv_commande_object.fu_get_date_prix() THEN
	em_date_prix.Text = DATE_DEFAULT_SYBASE
end if

if not nv_check_value.is_date_valide(em_date_prix.Text) then
	messagebox (this.title,g_nv_traduction.get_traduction(DATE_PRIX_ERRONEE),StopSign!,Ok!,1)
	em_date_prix.SetFocus()
	return
end if

IF s_mode_paiement = i_nv_commande_object.fu_get_mode_paiement() THEN
	s_mode_paiement = DONNEE_VIDE
end if
IF s_code_echeance = i_nv_commande_object.fu_get_code_echeance() THEN
	s_code_echeance = DONNEE_VIDE
end if

IF cbx_direct_indirect.checked THEN
	i_str_pass.s[1] = TYPE_LIGNE_DIRECT
	i_str_pass.s[2] = BLANK
ELSE
	i_str_pass.s[1] = TYPE_LIGNE_INDIRECT
	i_str_pass.s[2] = sle_grossiste.Text
END IF

i_str_pass.s[3] = s_mode_paiement
i_str_pass.s[4] = s_code_echeance

i_str_pass.d[1] 		= double (sle_remise.Text)
i_str_pass.dates[1] 	= Date (sle_date.Text)
i_str_pass.dates[2] 	= Date (em_date_prix.Text)

if cbx_drop.checked then
	i_str_pass.s[5] = i_nv_commande_object.fu_get_keepdrop_commande()
else
	i_str_pass.s[5] = CODE_MQT_KEEP
end if


Message.fnv_set_str_pass(i_str_pass)
Close (This)
end event

event key;call super::key;/* <DESC>
      Permet de trapper les touches de fonction activées et déclencher l'évènement associé
	à la touche.
	  F11 = Validation de la saisie et retour à la fenetre d'origine
   </DESC> */

IF KeyDown(KeyF11!) THEN
	This.PostEvent ("ue_ok")
END IF
end event

event ue_init;call super::ue_init;/* <DESC>
     Affichage initiale de la fenêtre.
	  <LI> Initialisation des zones de saisies avec les valeurs passées en entrée
	 qui sont les valeur par defaut des lignes de commandes et de l'entete de la
	 commande
	 <LI> l'affichage du grossiste n'est possible que lors de la saisie à partir
	 des promotions
	 L'affichage du Drop eceptionnel n'est possible que lors de la saisie à partir 
	 des promotions et uniquement si la strategie de lancement de l'entete de la
	 commande est DROP
	 <LI> Pour chaque code recherche et affichage de l'intitulé 
 
   </DESC> */
// DECLARATION DES VARIABLES LOCALES
Long					l_retrieve
Long					l_nb_lignes	
integer				li_indice
integer                 li_nbr_dates
int					i_rc
str_pass				l_str_work

nv_control_manager nv_check_value 
nv_check_value = CREATE nv_control_manager

is_type_ligne	= i_str_pass.s[1]
is_grossiste	= i_str_pass.s[2]
is_echeance	= i_str_pass.s[3]
is_paiement	= i_str_pass.s[4]
id_remise	= i_str_pass.d[1]
i_date_livraison	= i_str_pass.dates[1]
i_date_prix	= i_str_pass.dates[2]

li_nbr_dates = upperbound(i_str_pass.dates)
if li_nbr_dates = 3  then
	i_d_lancement = i_str_pass.dates[3]	
end if

i_nv_commande_object = i_str_pass.po[1]

// Si le visiteur est un Vendeur , les zones remises sont non visibles
if g_nv_come9par.is_vendeur( ) and not i_str_pass.b[1] then
	st_taux_remise.visible = false
	sle_remise.visible = false
end if

// Permet de rendre non visible les info livraison directe
// Cette option est positionnée par les promo
if i_str_pass.b[1] then
	if  i_nv_commande_object.fu_is_commande_drop() then
		  cbx_drop.visible = true
	       st_drop.visible = true
	end if
    if i_nv_commande_object.fu_is_promotion_drop() then
		cbx_drop.checked = true
	end if
end if

// RECHERCHE du mode de paiement  
l_str_work.s[1] = is_paiement
l_str_work.s[2] = BLANK
l_str_work = nv_check_value.is_mode_paiement_valide (l_str_work)
sle_paiement.text = is_paiement
sle_paiement_intitule.text = l_str_work.s[2]

// RECHERCHE du code echeance
l_str_work.s[1] = is_echeance
l_str_work.s[2] = BLANK
l_str_work = nv_check_value.is_echeance_valide (l_str_work)
sle_echeance.text = is_echeance
sle_echeance_intitule.text = l_str_work.s[2]

sle_mode_cond.text = trim(sle_paiement_intitule.text) + " - " + trim (sle_echeance_intitule.text)

// INITIALISATION DES CHAMPS
sle_date.Text 			= String (i_str_pass.dates[1])
em_date_prix.Text		= String (i_str_pass.dates[2])
sle_remise.Text		= String (i_str_pass.d[1])

sle_grossiste.fu_set_autoselect (TRUE)
end event

on w_conditions.create
int iCurrent
call super::create
this.cbx_direct_indirect=create cbx_direct_indirect
this.st_direct_indirect=create st_direct_indirect
this.sle_grossiste=create sle_grossiste
this.st_grossiste=create st_grossiste
this.st_livraison=create st_livraison
this.dataepri_t=create dataepri_t
this.st_echeance=create st_echeance
this.st_taux_remise=create st_taux_remise
this.sle_date=create sle_date
this.sle_remise=create sle_remise
this.em_date_prix=create em_date_prix
this.sle_echeance=create sle_echeance
this.sle_echeance_intitule=create sle_echeance_intitule
this.sle_paiement_intitule=create sle_paiement_intitule
this.st_drop=create st_drop
this.cbx_drop=create cbx_drop
this.sle_mode_cond=create sle_mode_cond
this.sle_paiement=create sle_paiement
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_direct_indirect
this.Control[iCurrent+2]=this.st_direct_indirect
this.Control[iCurrent+3]=this.sle_grossiste
this.Control[iCurrent+4]=this.st_grossiste
this.Control[iCurrent+5]=this.st_livraison
this.Control[iCurrent+6]=this.dataepri_t
this.Control[iCurrent+7]=this.st_echeance
this.Control[iCurrent+8]=this.st_taux_remise
this.Control[iCurrent+9]=this.sle_date
this.Control[iCurrent+10]=this.sle_remise
this.Control[iCurrent+11]=this.em_date_prix
this.Control[iCurrent+12]=this.sle_echeance
this.Control[iCurrent+13]=this.sle_echeance_intitule
this.Control[iCurrent+14]=this.sle_paiement_intitule
this.Control[iCurrent+15]=this.st_drop
this.Control[iCurrent+16]=this.cbx_drop
this.Control[iCurrent+17]=this.sle_mode_cond
this.Control[iCurrent+18]=this.sle_paiement
end on

on w_conditions.destroy
call super::destroy
destroy(this.cbx_direct_indirect)
destroy(this.st_direct_indirect)
destroy(this.sle_grossiste)
destroy(this.st_grossiste)
destroy(this.st_livraison)
destroy(this.dataepri_t)
destroy(this.st_echeance)
destroy(this.st_taux_remise)
destroy(this.sle_date)
destroy(this.sle_remise)
destroy(this.em_date_prix)
destroy(this.sle_echeance)
destroy(this.sle_echeance_intitule)
destroy(this.sle_paiement_intitule)
destroy(this.st_drop)
destroy(this.cbx_drop)
destroy(this.sle_mode_cond)
destroy(this.sle_paiement)
end on

type uo_statusbar from w_a_selection`uo_statusbar within w_conditions
integer x = 0
integer y = 1164
end type

type pb_ok from w_a_selection`pb_ok within w_conditions
integer x = 512
integer y = 920
string picturename = "c:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_echap from w_a_selection`pb_echap within w_conditions
integer x = 1477
integer y = 924
integer taborder = 30
string picturename = "c:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type cbx_direct_indirect from u_cbxa within w_conditions
event we_keydown pbm_keydown
integer x = 763
integer y = 76
integer width = 64
integer height = 68
integer taborder = 20
integer textsize = -8
fontcharset fontcharset = ansi!
string pointer = "IBeam!"
long textcolor = 0
boolean checked = true
borderstyle borderstyle = stylebox!
end type

event we_keydown;call super::we_keydown;
// PASSAGE AU CHAMPS SUIVANT
	IF KeyDown (KeyEnter!) THEN
		IF This.checked THEN
			sle_date.SetFocus ()
		ELSE
			sle_grossiste.SetFocus ()
		END IF
	END IF
end event

event clicked;call super::clicked;
// AFFICHAGE DU CODE GROSSISTE
	IF This.checked THEN
		st_grossiste.visible = FALSE
		sle_grossiste.visible = FALSE
		sle_grossiste.Text = space(6)
		sle_date.SetFocus ()
	ELSE
		IF not i_nv_commande_object.fu_is_grossiste_saisie() THEN
			st_grossiste.visible = TRUE
			sle_grossiste.visible = TRUE
			sle_grossiste.SetFocus ()
		END IF
	END IF
end event

type st_direct_indirect from statictext within w_conditions
integer x = 82
integer y = 72
integer width = 544
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
string text = "Direct"
boolean focusrectangle = false
end type

type sle_grossiste from u_slea within w_conditions
boolean visible = false
integer x = 1321
integer y = 72
integer width = 315
integer height = 72
integer taborder = 40
string facename = "Arial"
integer limit = 6
borderstyle borderstyle = stylebox!
end type

event we_keydown;call super::we_keydown;
// RENVOIE A L'EVENEMENT KEY DE LA FENÊTRE
	IF KeyDown (KeyEnter!) THEN
		sle_date.SetFocus ()
	END IF

	IF KeyDown(KeyF2!) THEN
		Parent.PostEvent ("ue_grossiste")
	END IF
end event

type st_grossiste from statictext within w_conditions
string tag = "liste"
boolean visible = false
integer x = 910
integer y = 72
integer width = 384
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
string text = "Grossiste° :"
boolean focusrectangle = false
end type

type st_livraison from statictext within w_conditions
integer x = 82
integer y = 172
integer width = 599
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
string text = "Date de livraison :"
boolean focusrectangle = false
end type

type dataepri_t from statictext within w_conditions
integer x = 82
integer y = 440
integer width = 379
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
string text = "Date prix :"
boolean focusrectangle = false
end type

type st_echeance from statictext within w_conditions
string tag = "liste"
integer x = 82
integer y = 312
integer width = 599
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
string text = "°Code échéance"
boolean focusrectangle = false
end type

type st_taux_remise from statictext within w_conditions
integer x = 73
integer y = 548
integer width = 567
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
string text = "Taux de remise  :"
boolean focusrectangle = false
end type

type sle_date from u_ema within w_conditions
event we_keydown pbm_keydown
event we_dwnprocessenter pbm_dwnprocessenter
integer x = 763
integer y = 160
integer width = 343
integer height = 84
integer taborder = 50
integer textsize = -8
fontcharset fontcharset = ansi!
borderstyle borderstyle = stylebox!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
string displaydata = "~b"
end type

event we_keydown;
// RENVOIE A L'EVENEMENT KEY DE LA FENÊTRE
//	f_activation_key ()
	f_key(Parent)

	IF Keydown (KeyEnter!) THEN
		sle_paiement.SetFocus ()
	END IF
end event

type sle_remise from u_ema within w_conditions
event we_dwnprocessenter pbm_dwnprocessenter
event we_keydown pbm_keydown
integer x = 763
integer y = 556
integer width = 251
integer height = 68
integer taborder = 90
integer textsize = -8
fontcharset fontcharset = ansi!
alignment alignment = right!
borderstyle borderstyle = stylebox!
maskdatatype maskdatatype = numericmask!
string mask = "#0.00"
end type

event we_keydown;call super::we_keydown;
// RENVOIE A L'EVENEMENT KEY DE LA FENÊTRE
//	f_activation_key ()
	f_key(Parent)

	IF Keydown (KeyEnter!) THEN
		cbx_direct_indirect.SetFocus ()
	END IF
end event

type em_date_prix from u_ema within w_conditions
event we_keydown pbm_keydown
event we_dwnprocessenter pbm_dwnprocessenter
integer x = 763
integer y = 444
integer width = 334
integer height = 72
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
fontcharset fontcharset = ansi!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
string displaydata = "~b"
end type

event we_keydown;
// RENVOIE A L'EVENEMENT KEY DE LA FENÊTRE
//	f_activation_key ()
	f_key(Parent)

	IF Keydown (KeyEnter!) THEN
		sle_remise.SetFocus ()
	END IF
end event

type sle_echeance from u_slea within w_conditions
integer x = 731
integer y = 320
integer width = 366
integer height = 64
integer taborder = 70
boolean bringtotop = true
string facename = "Arial"
textcase textcase = upper!
end type

event we_keydown;call super::we_keydown;
IF KeyDown(KeyF2!) THEN
	is_colonne = DBNAME_CODE_ECHEANCE
	Parent.triggerEvent ("ue_listes")
END IF
end event

type sle_echeance_intitule from u_slea within w_conditions
boolean visible = false
integer x = 987
integer y = 768
integer width = 366
integer height = 64
integer taborder = 0
boolean bringtotop = true
string facename = "Arial"
long backcolor = 12632256
boolean displayonly = true
borderstyle borderstyle = stylebox!
end type

event we_keydown;call super::we_keydown;
IF KeyDown(KeyF2!) THEN
	is_colonne = DBNAME_CODE_ECHEANCE
	Parent.triggerEvent ("ue_listes")
END IF
end event

type sle_paiement_intitule from u_slea within w_conditions
boolean visible = false
integer x = 1353
integer y = 768
integer width = 256
integer height = 64
integer taborder = 0
boolean bringtotop = true
string facename = "Arial"
long backcolor = 12632256
boolean displayonly = true
borderstyle borderstyle = stylebox!
end type

event we_keydown;call super::we_keydown;
IF KeyDown(KeyF2!) THEN
	is_colonne = DBNAME_MODE_PAIEMENT
	Parent.triggerEvent ("ue_listes")
END IF
end event

type st_drop from statictext within w_conditions
boolean visible = false
integer x = 78
integer y = 772
integer width = 658
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
string text = "Drop exceptionnel :"
boolean focusrectangle = false
end type

type cbx_drop from u_cbxa within w_conditions
event we_keydown pbm_keydown
boolean visible = false
integer x = 759
integer y = 776
integer width = 82
integer height = 68
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
fontcharset fontcharset = ansi!
string pointer = "IBeam!"
long textcolor = 0
long backcolor = 12632256
borderstyle borderstyle = stylebox!
end type

type sle_mode_cond from u_slea within w_conditions
integer x = 1134
integer y = 320
integer width = 1536
integer height = 64
integer taborder = 30
boolean bringtotop = true
string facename = "Arial"
long backcolor = 12632256
boolean border = false
boolean displayonly = true
borderstyle borderstyle = stylebox!
end type

event we_keydown;call super::we_keydown;
IF KeyDown(KeyF2!) THEN
	is_colonne = DBNAME_CODE_ECHEANCE
	Parent.triggerEvent ("ue_listes")
END IF
end event

type sle_paiement from u_slea within w_conditions
boolean visible = false
integer x = 1609
integer y = 768
integer width = 366
integer height = 64
integer taborder = 80
boolean bringtotop = true
string facename = "Arial"
textcase textcase = upper!
end type

event we_keydown;call super::we_keydown;
IF KeyDown(KeyF2!) THEN
	is_colonne = DBNAME_CODE_ECHEANCE
	Parent.triggerEvent ("ue_listes")
END IF
end event

