$PBExportHeader$uo_mise_a_jour_messages.sru
$PBExportComments$Permet la gestion de l'affichage d'une ligne par texte et la gestion des différents textes
forward
global type uo_mise_a_jour_messages from userobject
end type
type st_message_instruction_cde from u_slea within uo_mise_a_jour_messages
end type
type st_message_marquage_caisse from u_slea within uo_mise_a_jour_messages
end type
type st_message_transitaire from u_slea within uo_mise_a_jour_messages
end type
type st_message_transporteur from u_slea within uo_mise_a_jour_messages
end type
type st_message_facture from u_slea within uo_mise_a_jour_messages
end type
type st_message_bordereau from u_slea within uo_mise_a_jour_messages
end type
type pb_instruction_cde from picturebutton within uo_mise_a_jour_messages
end type
type marquage_t from statictext within uo_mise_a_jour_messages
end type
type pb_marquage_caisse from picturebutton within uo_mise_a_jour_messages
end type
type pb_transitaire from picturebutton within uo_mise_a_jour_messages
end type
type pb_transporteur from picturebutton within uo_mise_a_jour_messages
end type
type pb_facture from picturebutton within uo_mise_a_jour_messages
end type
type pb_bordereau from picturebutton within uo_mise_a_jour_messages
end type
type instruction_t from statictext within uo_mise_a_jour_messages
end type
type transitaire_t from statictext within uo_mise_a_jour_messages
end type
type transporteur_t from statictext within uo_mise_a_jour_messages
end type
type facture_t from statictext within uo_mise_a_jour_messages
end type
type bordereau_t from statictext within uo_mise_a_jour_messages
end type
type rr_1 from roundrectangle within uo_mise_a_jour_messages
end type
end forward

global type uo_mise_a_jour_messages from userobject
integer width = 2153
integer height = 604
long backcolor = 12632256
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
st_message_instruction_cde st_message_instruction_cde
st_message_marquage_caisse st_message_marquage_caisse
st_message_transitaire st_message_transitaire
st_message_transporteur st_message_transporteur
st_message_facture st_message_facture
st_message_bordereau st_message_bordereau
pb_instruction_cde pb_instruction_cde
marquage_t marquage_t
pb_marquage_caisse pb_marquage_caisse
pb_transitaire pb_transitaire
pb_transporteur pb_transporteur
pb_facture pb_facture
pb_bordereau pb_bordereau
instruction_t instruction_t
transitaire_t transitaire_t
transporteur_t transporteur_t
facture_t facture_t
bordereau_t bordereau_t
rr_1 rr_1
end type
global uo_mise_a_jour_messages uo_mise_a_jour_messages

type variables
str_pass i_str_pass
boolean  ib_update = false

/*
		s1 = Valeur du code client ou n° de cde
		
		s2 = nom du champ cle pour message bordereau
		s3 = code table message bordereau
		
		s4 = nom du champ cle pour message facture
		s5 = code table message facture
		
		s6 = nom du champ cle pour message transporteur		
		s7 = code table message transporteur
		
		s8 = nom du champ cle pour message transitaire		
		s9 = code table message transitaire
		
		s10 = nom du champ cle pour message marquage caisse		
		s11 = code table message marquage caisse
		
		s12 = nom de la datawindow pour entete
	*/

end variables

forward prototypes
public subroutine fu_init_param (any as_structure)
public subroutine fu_update_flag (boolean as_boolean)
public subroutine fu_refresh ()
end prototypes

public subroutine fu_init_param (any as_structure);/* <DESC>
      Pour chacune des lignes de texte, récupération de la première dans la table
	 correspondante et pour le client ou par la commande. Pour effectuer l'accés
	 aux données, une datatsore est créée et la datawindow associée est composée
	 de "d_texte_" + du nom de la table stockée dans la structure.
	Ces paramètres sont passés en paramètres dans la structure str-pass qui est
	structurée de la façcon suivante :
		s1 = Valeur du code client ou n° de cde
		
		s2 = nom du champ cle pour message bordereau
		s3 = code table message bordereau
		
		s4 = nom du champ cle pour message facture
		s5 = code table message facture
		
		s6 = nom du champ cle pour message transporteur		
		s7 = code table message transporteur
		
		s8 = nom du champ cle pour message transitaire		
		s9 = code table message transitaire
		
		s10 = nom du champ cle pour message marquage caisse		
		s11 = code table message marquage caisse
		
		s12 = nom de la datawindow pour entete
   </DESC> */
i_str_pass = as_structure

Datastore ds_message
ds_message = CREATE Datastore
ds_message.dataobject = "d_texte_" + i_str_pass.s[3]
ds_message.setTransObject(sqlca)
ds_message.retrieve(i_str_pass.s[1])
if ds_message.RowCount() > 0 then
	st_message_bordereau.text = ds_message.getItemString(1, DBNAME_MESSAGE)
end if

ds_message.dataobject = "d_texte_" + i_str_pass.s[6]
ds_message.setTransObject(sqlca)
ds_message.retrieve(i_str_pass.s[1])
if ds_message.RowCount() > 0 then
	st_message_facture.text = ds_message.getItemString(1, DBNAME_MESSAGE)
end if

ds_message.dataobject = "d_texte_" + i_str_pass.s[9]
ds_message.setTransObject(sqlca)
ds_message.retrieve(i_str_pass.s[1])
if ds_message.RowCount() > 0 then
	st_message_transporteur.text = ds_message.getItemString(1, DBNAME_MESSAGE)
end if

ds_message.dataobject = "d_texte_" + i_str_pass.s[12]
ds_message.setTransObject(sqlca)
ds_message.retrieve(i_str_pass.s[1])
if ds_message.RowCount() > 0 then
	st_message_transitaire.text = ds_message.getItemString(1, DBNAME_MESSAGE)
end if

ds_message.dataobject = "d_texte_" + i_str_pass.s[15]
ds_message.setTransObject(sqlca)
ds_message.retrieve(i_str_pass.s[1])
if ds_message.RowCount() > 0 then
	st_message_marquage_caisse.text = ds_message.getItemString(1, DBNAME_MESSAGE)
end if

ds_message.dataobject = "d_texte_" + i_str_pass.s[19]
ds_message.setTransObject(sqlca)
ds_message.retrieve(i_str_pass.s[1])
if ds_message.RowCount() > 0 then
	st_message_instruction_cde.text = ds_message.getItemString(1, DBNAME_MESSAGE)
end if


end subroutine

public subroutine fu_update_flag (boolean as_boolean);/* <DESC> 
     Permet de spécifier si la fenêtre abritant cette object est en cours de mise à jour ou non
	Lors de l'activation d'un bouton pour aller en mise à jour du message, on controle
	que la mise à jour a été effectuée. Cette fonction est appelée par la fenêtre abritant
	cet object */
ib_update = as_boolean
end subroutine

public subroutine fu_refresh ();/* <DESC>
      Permet de rafraichir les premières lignes après mise à jour des textes
   </DESC> */
Datastore ds_message
ds_message = CREATE Datastore
ds_message.dataobject = "d_texte_" + i_str_pass.s[3]
ds_message.setTransObject(sqlca)
ds_message.retrieve(i_str_pass.s[1], " ")
st_message_bordereau.text = DONNEE_VIDE
if ds_message.RowCount() > 0 then
	st_message_bordereau.text = ds_message.getItemString(1, DBNAME_MESSAGE)
end if

ds_message.dataobject = "d_texte_" + i_str_pass.s[6]
ds_message.setTransObject(sqlca)
ds_message.retrieve(i_str_pass.s[1], i_str_pass.s[7])
st_message_facture.text = DONNEE_VIDE
if ds_message.RowCount() > 0 then
	st_message_facture.text = ds_message.getItemString(1, DBNAME_MESSAGE)
end if

ds_message.dataobject = "d_texte_" + i_str_pass.s[9]
ds_message.setTransObject(sqlca)
ds_message.retrieve(i_str_pass.s[1], " ")
st_message_transporteur.text = DONNEE_VIDE
if ds_message.RowCount() > 0 then
	st_message_transporteur.text = ds_message.getItemString(1, DBNAME_MESSAGE)
end if

ds_message.dataobject = "d_texte_" + i_str_pass.s[12]
ds_message.setTransObject(sqlca)
ds_message.retrieve(i_str_pass.s[1], i_str_pass.s[13])
st_message_transitaire.text = DONNEE_VIDE
if ds_message.RowCount() > 0 then
	st_message_transitaire.text = ds_message.getItemString(1, DBNAME_MESSAGE)
end if

ds_message.dataobject = "d_texte_" + i_str_pass.s[15]
ds_message.setTransObject(sqlca)
ds_message.retrieve(i_str_pass.s[1]," ")
st_message_marquage_caisse.text = DONNEE_VIDE
if ds_message.RowCount() > 0 then
	st_message_marquage_caisse.text = ds_message.getItemString(1, DBNAME_MESSAGE)
end if

ds_message.dataobject = "d_texte_" + i_str_pass.s[19]
ds_message.setTransObject(sqlca)
ds_message.retrieve(i_str_pass.s[1], i_str_pass.s[20])
st_message_instruction_cde.text = DONNEE_VIDE
if ds_message.RowCount() > 0 then
	st_message_instruction_cde.text = ds_message.getItemString(1, DBNAME_MESSAGE)
end if


end subroutine

on uo_mise_a_jour_messages.create
this.st_message_instruction_cde=create st_message_instruction_cde
this.st_message_marquage_caisse=create st_message_marquage_caisse
this.st_message_transitaire=create st_message_transitaire
this.st_message_transporteur=create st_message_transporteur
this.st_message_facture=create st_message_facture
this.st_message_bordereau=create st_message_bordereau
this.pb_instruction_cde=create pb_instruction_cde
this.marquage_t=create marquage_t
this.pb_marquage_caisse=create pb_marquage_caisse
this.pb_transitaire=create pb_transitaire
this.pb_transporteur=create pb_transporteur
this.pb_facture=create pb_facture
this.pb_bordereau=create pb_bordereau
this.instruction_t=create instruction_t
this.transitaire_t=create transitaire_t
this.transporteur_t=create transporteur_t
this.facture_t=create facture_t
this.bordereau_t=create bordereau_t
this.rr_1=create rr_1
this.Control[]={this.st_message_instruction_cde,&
this.st_message_marquage_caisse,&
this.st_message_transitaire,&
this.st_message_transporteur,&
this.st_message_facture,&
this.st_message_bordereau,&
this.pb_instruction_cde,&
this.marquage_t,&
this.pb_marquage_caisse,&
this.pb_transitaire,&
this.pb_transporteur,&
this.pb_facture,&
this.pb_bordereau,&
this.instruction_t,&
this.transitaire_t,&
this.transporteur_t,&
this.facture_t,&
this.bordereau_t,&
this.rr_1}
end on

on uo_mise_a_jour_messages.destroy
destroy(this.st_message_instruction_cde)
destroy(this.st_message_marquage_caisse)
destroy(this.st_message_transitaire)
destroy(this.st_message_transporteur)
destroy(this.st_message_facture)
destroy(this.st_message_bordereau)
destroy(this.pb_instruction_cde)
destroy(this.marquage_t)
destroy(this.pb_marquage_caisse)
destroy(this.pb_transitaire)
destroy(this.pb_transporteur)
destroy(this.pb_facture)
destroy(this.pb_bordereau)
destroy(this.instruction_t)
destroy(this.transitaire_t)
destroy(this.transporteur_t)
destroy(this.facture_t)
destroy(this.bordereau_t)
destroy(this.rr_1)
end on

type st_message_instruction_cde from u_slea within uo_mise_a_jour_messages
integer x = 608
integer y = 488
integer width = 1335
integer height = 72
integer taborder = 70
boolean border = false
boolean displayonly = true
borderstyle borderstyle = stylebox!
end type

type st_message_marquage_caisse from u_slea within uo_mise_a_jour_messages
integer x = 608
integer y = 388
integer width = 1335
integer height = 72
integer taborder = 50
boolean border = false
boolean displayonly = true
borderstyle borderstyle = stylebox!
end type

type st_message_transitaire from u_slea within uo_mise_a_jour_messages
integer x = 608
integer y = 296
integer width = 1335
integer height = 72
integer taborder = 40
boolean border = false
boolean displayonly = true
borderstyle borderstyle = stylebox!
end type

type st_message_transporteur from u_slea within uo_mise_a_jour_messages
integer x = 603
integer y = 204
integer width = 1335
integer height = 72
integer taborder = 20
boolean border = false
boolean displayonly = true
borderstyle borderstyle = stylebox!
end type

type st_message_facture from u_slea within uo_mise_a_jour_messages
integer x = 608
integer y = 112
integer width = 1335
integer height = 72
integer taborder = 10
boolean border = false
boolean displayonly = true
borderstyle borderstyle = stylebox!
end type

type st_message_bordereau from u_slea within uo_mise_a_jour_messages
integer x = 608
integer y = 20
integer width = 1335
integer height = 72
integer taborder = 0
boolean border = false
boolean displayonly = true
borderstyle borderstyle = stylebox!
end type

type pb_instruction_cde from picturebutton within uo_mise_a_jour_messages
integer x = 1975
integer y = 476
integer width = 101
integer height = 88
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "none"
string picturename = "DosEdit!"
alignment htextalign = right!
end type

event clicked;
/*  Permet d'aller en mise à jour du texte en affichant la fenêtre de gestion
des textes mais uniquement après avoir effectuer la mise à jour de la fenêtre parent
en lancant l'évènemetn ue_save.
Aprés avoir mise à jour le texte, affichage de la première du texte saisi
*/
str_pass l_str_work

parent.getParent().TriggerEvent ("ue_save")

if ib_update then
	
	l_str_work.s[1] = i_str_pass.s[1]
	l_str_work.s[2] = i_str_pass.s[18]
	l_str_work.s[3] = i_str_pass.s[19]
	l_str_work.s[4] = "TRAITEMENT_CDE"
	l_str_work.s[5] = DONNEE_VIDE
	l_str_work.s[6] = i_str_pass.s[17]
	l_str_work.s[7] = i_str_pass.s[20]
	
	openwithParm(w_gestion_des_messages, l_str_work)
	
	l_str_work = Message.fnv_get_str_pass()	
	
	
	st_message_instruction_cde.text = l_str_work.s[5]
	
end if
end event

type marquage_t from statictext within uo_mise_a_jour_messages
integer x = 9
integer y = 404
integer width = 567
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 12632256
string text = "Marquage Caisse (LI)"
alignment alignment = right!
boolean focusrectangle = false
end type

type pb_marquage_caisse from picturebutton within uo_mise_a_jour_messages
integer x = 1975
integer y = 388
integer width = 101
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "none"
string picturename = "DosEdit!"
alignment htextalign = right!
end type

event clicked;
/*  Permet d'aller en mise à jour du texte en affichant la fenêtre de gestion
des textes mais uniquement après avoir effectuer la mise à jour de la fenêtre parent
en lancant l'évènemetn ue_save.
Aprés avoir mise à jour le texte, affichage de la première du texte saisi
*/
str_pass l_str_work

parent.getParent().TriggerEvent ("ue_save")

if ib_update then
	
	l_str_work.s[1] = i_str_pass.s[1]
	l_str_work.s[2] = i_str_pass.s[14]
	l_str_work.s[3] = i_str_pass.s[15]
	l_str_work.s[4] = "MARQUAGE_CAISSE"
	l_str_work.s[5] = DONNEE_VIDE
	l_str_work.s[6] = i_str_pass.s[17]
	l_str_work.s[7] = i_str_pass.s[16]
	
	openwithParm(w_gestion_des_messages, l_str_work)
	
	l_str_work = Message.fnv_get_str_pass()	
	
	
	st_message_marquage_caisse.text = l_str_work.s[5]
	
end if
end event

type pb_transitaire from picturebutton within uo_mise_a_jour_messages
integer x = 1975
integer y = 296
integer width = 101
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "none"
string picturename = "DosEdit!"
alignment htextalign = right!
end type

event clicked;
/*  Permet d'aller en mise à jour du texte en affichant la fenêtre de gestion
des textes mais uniquement après avoir effectuer la mise à jour de la fenêtre parent
en lancant l'évènemetn ue_save.
Aprés avoir mise à jour le texte, affichage de la première du texte saisi
*/
str_pass l_str_work
parent.getParent().TriggerEvent ("ue_save")

if ib_update then

	l_str_work.s[1] = i_str_pass.s[1]
	l_str_work.s[2] = i_str_pass.s[11]
	l_str_work.s[3] = i_str_pass.s[12]
	l_str_work.s[4] = "TRANSITAIRE"
	l_str_work.s[5] = DONNEE_VIDE
	l_str_work.s[6] = i_str_pass.s[17]
	l_str_work.s[7] = i_str_pass.s[13]
	openwithParm(w_gestion_des_messages, l_str_work)
	
	l_str_work = Message.fnv_get_str_pass()	
	
	
	st_message_transitaire.text = l_str_work.s[5]
	
end if
end event

type pb_transporteur from picturebutton within uo_mise_a_jour_messages
integer x = 1975
integer y = 204
integer width = 101
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "none"
string picturename = "DosEdit!"
alignment htextalign = right!
end type

event clicked;
/*  Permet d'aller en mise à jour du texte en affichant la fenêtre de gestion
des textes mais uniquement après avoir effectuer la mise à jour de la fenêtre parent
en lancant l'évènemetn ue_save.
Aprés avoir mise à jour le texte, affichage de la première du texte saisi
*/
str_pass l_str_work

parent.getParent().TriggerEvent ("ue_save")
if ib_update then
	
	l_str_work.s[1] = i_str_pass.s[1]
	l_str_work.s[2] = i_str_pass.s[8]
	l_str_work.s[3] = i_str_pass.s[9]
	l_str_work.s[4] = "TRANSPORTEUR"
	l_str_work.s[5] = DONNEE_VIDE
	l_str_work.s[6] = i_str_pass.s[17]
	l_str_work.s[7] = i_str_pass.s[10]
	
	openwithParm(w_gestion_des_messages, l_str_work)
	
	l_str_work = Message.fnv_get_str_pass()	
	
	
	st_message_transporteur.text = l_str_work.s[5]
	
end if
end event

type pb_facture from picturebutton within uo_mise_a_jour_messages
integer x = 1979
integer y = 112
integer width = 101
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "none"
string picturename = "DosEdit!"
alignment htextalign = right!
end type

event clicked;
/*  Permet d'aller en mise à jour du texte en affichant la fenêtre de gestion
des textes mais uniquement après avoir effectuer la mise à jour de la fenêtre parent
en lancant l'évènemetn ue_save.
Aprés avoir mise à jour le texte, affichage de la première du texte saisi
*/
str_pass l_str_work

parent.getParent().TriggerEvent ("ue_save")

if ib_update then
	
	l_str_work.s[1] = i_str_pass.s[1]
	l_str_work.s[2] = i_str_pass.s[5]
	l_str_work.s[3] = i_str_pass.s[6]
	l_str_work.s[4] = "FACTURE"
	l_str_work.s[5] = DONNEE_VIDE
	l_str_work.s[6] = i_str_pass.s[17]
	l_str_work.s[7] = i_str_pass.s[7]	
	
	
	openwithParm(w_gestion_des_messages, l_str_work)
	
	l_str_work = Message.fnv_get_str_pass()	
	
	st_message_facture.text = l_str_work.s[5]
	
end if
end event

type pb_bordereau from picturebutton within uo_mise_a_jour_messages
integer x = 1979
integer y = 20
integer width = 105
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "none"
string picturename = "DosEdit!"
alignment htextalign = right!
end type

event clicked;
/*  Permet d'aller en mise à jour du texte en affichant la fenêtre de gestion
des textes mais uniquement après avoir effectuer la mise à jour de la fenêtre parent
en lancant l'évènemetn ue_save.
Aprés avoir mise à jour le texte, affichage de la première du texte saisi
*/
str_pass l_str_work

parent.getParent().TriggerEvent ("ue_save")

if ib_update then
	l_str_work.s[1] = i_str_pass.s[1]
	l_str_work.s[2] = i_str_pass.s[2]
	l_str_work.s[3] = i_str_pass.s[3]
	l_str_work.s[4] = "BORDEREAU_PREPARATION"
	l_str_work.s[5] = DONNEE_VIDE
	l_str_work.s[6] = i_str_pass.s[17]
	l_str_work.s[7] = i_str_pass.s[4]	
	
//	openwithParm(w_gestion_des_messages, l_str_work)
    openwithParm(w_message_9086, i_str_pass)	
	
	i_str_pass = Message.fnv_get_str_pass()	
	

	st_message_bordereau.text = i_str_pass.s[5]

end if

end event

type instruction_t from statictext within uo_mise_a_jour_messages
integer x = 9
integer y = 472
integer width = 581
integer height = 112
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 12632256
string text = "Instruction traitement Cde (DO)"
alignment alignment = right!
boolean focusrectangle = false
end type

type transitaire_t from statictext within uo_mise_a_jour_messages
integer x = 18
integer y = 288
integer width = 576
integer height = 96
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 12632256
string text = "Transitaire (DO)"
alignment alignment = right!
boolean focusrectangle = false
end type

type transporteur_t from statictext within uo_mise_a_jour_messages
integer x = 18
integer y = 220
integer width = 553
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 12632256
string text = "Transporteur (LI)"
alignment alignment = right!
boolean focusrectangle = false
end type

type facture_t from statictext within uo_mise_a_jour_messages
integer x = 229
integer y = 128
integer width = 343
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
string text = "Facture (FA)"
alignment alignment = right!
boolean focusrectangle = false
end type

type bordereau_t from statictext within uo_mise_a_jour_messages
integer x = 73
integer y = 40
integer width = 498
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
string text = "Bordereau (LI)"
alignment alignment = right!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within uo_mise_a_jour_messages
integer linethickness = 4
long fillcolor = 12632256
integer width = 2139
integer height = 604
integer cornerheight = 40
integer cornerwidth = 46
end type

