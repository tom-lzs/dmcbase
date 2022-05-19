$PBExportHeader$w_selection_visiteurs.srw
$PBExportComments$Permet de sélectionner les visiteurs pour lesqueles les commqndes seront récupérées sur le portable.
forward
global type w_selection_visiteurs from w_a_udim
end type
type pb_ok from u_pba_ok within w_selection_visiteurs
end type
type pb_echap from u_pba_echap within w_selection_visiteurs
end type
type tout_visiteur_t from statictext within w_selection_visiteurs
end type
type visiteur_selection_t from statictext within w_selection_visiteurs
end type
type cbx_tous from u_cbxa within w_selection_visiteurs
end type
type recup_cdes from statictext within w_selection_visiteurs
end type
end forward

global type w_selection_visiteurs from w_a_udim
string tag = "SELECTION_VISITEUR"
integer x = 769
integer y = 461
integer width = 1952
integer height = 2024
string title = "Liste des visiteurs pour récupération des commandes"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
long backcolor = 12632256
event ue_tous_les_visiteurs ( )
pb_ok pb_ok
pb_echap pb_echap
tout_visiteur_t tout_visiteur_t
visiteur_selection_t visiteur_selection_t
cbx_tous cbx_tous
recup_cdes recup_cdes
end type
global w_selection_visiteurs w_selection_visiteurs

type variables
TRANSACTION  isqlca_serveur
end variables

event ue_tous_les_visiteurs();/* <DESC> 
    Permet de sélectionner ou déslectionner tous les visiteurs
</DESC> */ 

String ls_selection
long  ll_indice

if cbx_tous.checked then
	ls_selection = 'O'
else
	ls_selection = 'N'
end if

for ll_indice = 1 to dw_1.RowCount()
	if dw_1.getitemstring(ll_indice,DBNAME_CODE_VISITEUR) <>  g_s_visiteur then
		dw_1.setItem(ll_indice,"cselection",ls_selection)
	end if
next
end event

event ue_init;call super::ue_init;/* <DESC>
    Affichage de la liste des visiteurs en complétant la sélection en fonction de la dernière sélection effectuée.
	 La ligne du visiteur est positionnée à sélectionner et est inaccessible
   </DESC> */

nv_datastore ld_come9acvd

isqlca_serveur = CREATE TRANSACTION

isqlca_serveur = i_str_pass.po[1]

dw_1.SetTransObject (isqlca_serveur)
dw_1.SetRowFocusIndicator (FocusRect!)
dw_1.fu_set_error_title (this.title)
dw_1.retrieve ()
if dw_1.rowcount() = 0 then
	pb_ok.visible = false
end if

/* Recherche de la ligne du visiteur pour pouvoir positionner la case à cocher à coher */
Long ll_row 
ll_row = dw_1.find (DBNAME_CODE_VISITEUR + "= '"  + g_s_visiteur + "'" ,1, dw_1.rowcount())
if ll_row = 0 then
	 return
end if

dw_1.setitem(ll_row,"cselection","O")
dw_1.setitem(ll_row,"cvisiteur",g_s_visiteur)
dw_1.sort()

ld_come9acvd = create nv_datastore
ld_come9acvd.dataobject = "d_come9acvd"
ld_come9acvd.settransobject (isqlca_serveur)
ld_come9acvd.retrieve (g_s_visiteur)

/*   Ceci ne se fait plus pour obliger les assistantes à reselectionner les visiteurs */
/* Recherche de la derniere selection effectuée */
ld_come9acvd.retrieve (g_s_visiteur)
if ld_come9acvd.rowCount() = 0 then
	return
end if

long li_indice

for li_indice = 1 to ld_come9acvd.rowCount()
	ll_row = dw_1.find (DBNAME_CODE_VISITEUR + "= '" + ld_come9acvd.getitemString (li_indice,DBNAME_CODE_VISITEUR) + "'",1, dw_1.rowcount())
     if ll_row > 0 then
  	   dw_1.setitem(ll_row,"cselection",'O')
     end if
next

dw_1.sort()
end event

on w_selection_visiteurs.create
int iCurrent
call super::create
this.pb_ok=create pb_ok
this.pb_echap=create pb_echap
this.tout_visiteur_t=create tout_visiteur_t
this.visiteur_selection_t=create visiteur_selection_t
this.cbx_tous=create cbx_tous
this.recup_cdes=create recup_cdes
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_ok
this.Control[iCurrent+2]=this.pb_echap
this.Control[iCurrent+3]=this.tout_visiteur_t
this.Control[iCurrent+4]=this.visiteur_selection_t
this.Control[iCurrent+5]=this.cbx_tous
this.Control[iCurrent+6]=this.recup_cdes
end on

on w_selection_visiteurs.destroy
call super::destroy
destroy(this.pb_ok)
destroy(this.pb_echap)
destroy(this.tout_visiteur_t)
destroy(this.visiteur_selection_t)
destroy(this.cbx_tous)
destroy(this.recup_cdes)
end on

event ue_ok;/*<DESC>
  Validation de la sélection des visiteurs à transférer.
  <LI> Controle du nombre de visiteur sélectionné et si aucune sélection affichage d'un message
  d'anomalie
  <LI> Controle que le visiteur connecté soit bien sélectionner
  <LI> Suppression du contenu de la table come9svi
  <LI> Creation d'une ligne pour chaque visiteur sélectionné
 </DESC> */

// Overwrite
Long ll_row,ll_row_new
integer li_nombre
li_nombre = 0
nv_datastore ld_come9svi

/* Controle du nombre de visiteur selectionne */
for ll_row = 1 to dw_1.RowCount()
	 if dw_1.getItemString(ll_row,"cselection")  = "O" then
		li_nombre = li_nombre + 1
	 end if
next

if li_nombre = 0 then
  MessageBox(This.Title, "Aucun visiteur de sélectionné", information!,ok!)
   return
end if

/* suppression des lignes de la table des visiteurs sélectionnés */
ld_come9svi = create nv_datastore
ld_come9svi.dataobject = "d_come9svi"
ld_come9svi.settransobject (isqlca_serveur)
ld_come9svi.retrieve (g_s_visiteur)
ld_come9svi.rowsmove( 1, ld_come9svi.rowCount(), Primary!, ld_come9svi, 1, Delete!)

/* creation des lignes des visiteurs sélectionnés */
ll_row_new = 0
for ll_row = 1 to dw_1.RowCount()
	ll_row_new ++
	ld_come9svi.insertrow( ll_row_new)
	ld_come9svi.setItem(ll_row_new, DBNAME_DATE_CREATION, sqlca.fnv_get_datetime( ))
	ld_come9svi.setItem (ll_row_new, DBNAME_CODE_MAJ, CODE_CREATION)
 	ld_come9svi.setItem(ll_row_new, DBNAME_VISITEUR_MAJ, g_s_visiteur)		
	ld_come9svi.setItem(ll_row_new, DBNAME_CODE_VISITEUR, dw_1.GetItemString(ll_row,DBNAME_CODE_VISITEUR))
	ld_come9svi.setItem(ll_row_new, DBNAME_CODE_SELECTION, dw_1.GetItemString(ll_row,"cselection"))	
next

if ld_come9svi.update() = -1 then
	f_dmc_error ("Commande Object" + BLANK + DB_ERROR_MESSAGE)
end if

i_str_pass.d[1] = dw_1.rowcount()
i_str_pass.d[2] = ll_row_new

i_str_pass.s_action = ACTION_OK
i_b_canceled = TRUE
Message.fnv_set_str_pass(i_str_pass)
destroy ld_come9svi
close(this)

end event

event ue_cancel;//overwrite
/* <DESC>
    Permet de quitter l'application sans selection de visiteurs
   </DESC> */
	
i_str_pass.s_action = ACTION_CANCEL
i_b_canceled = TRUE
i_str_pass.s[1] = "Abandon de la sélection des visiteurs"
Message.fnv_set_str_pass(i_str_pass)
Close (this)
end event

event open;call super::open;/* <DESC>
   overwrite
   </DESC> */
end event

event key;call super::key;/* <DESC>
      Permet de trapper les touches de fonction activées et déclencher l'évènement associé
	à la touche.
	  F11 = Fin de validation de la saisie
   </DESC> */
	IF KeyDown (KeyF11!)  THEN
		This.PostEvent ("ue_ok")
	END IF
end event

type uo_statusbar from w_a_udim`uo_statusbar within w_selection_visiteurs
end type

type dw_1 from w_a_udim`dw_1 within w_selection_visiteurs
string tag = "A_TRADUIRE"
integer x = 73
integer y = 344
integer width = 1815
integer height = 1324
string dataobject = "d_liste_visiteur_pour_selection"
boolean vscrollbar = true
end type

event dw_1::we_dwnkey;call super::we_dwnkey;//Captage des touches de fonction par le contrôle et renvoie à l'évènement KEY de la fenêtre
//	f_activation_key() 
	f_key(Parent)
end event

type pb_ok from u_pba_ok within w_selection_visiteurs
integer x = 215
integer y = 1764
integer taborder = 11
boolean bringtotop = true
end type

type pb_echap from u_pba_echap within w_selection_visiteurs
integer x = 1481
integer y = 1764
integer taborder = 11
boolean bringtotop = true
end type

type tout_visiteur_t from statictext within w_selection_visiteurs
boolean visible = false
integer x = 443
integer y = 176
integer width = 549
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 12632256
string text = "- Tous les visiteurs :"
alignment alignment = center!
boolean focusrectangle = false
end type

type visiteur_selection_t from statictext within w_selection_visiteurs
string tag = "VISITEUR_SELECTION_T"
integer x = 443
integer y = 252
integer width = 896
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 12632256
string text = "- Pour les visiteurs sélectionnés :"
alignment alignment = center!
boolean focusrectangle = false
end type

type cbx_tous from u_cbxa within w_selection_visiteurs
string tag = "NO_TEXT"
boolean visible = false
integer x = 1024
integer y = 144
integer width = 119
integer height = 92
boolean bringtotop = true
long backcolor = 12632256
end type

event clicked;call super::clicked;parent.triggerEvent("ue_tous_les_visiteurs")
end event

type recup_cdes from statictext within w_selection_visiteurs
integer x = 96
integer y = 48
integer width = 1266
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 12632256
string text = "Récupération des commandes pour "
boolean focusrectangle = false
end type

