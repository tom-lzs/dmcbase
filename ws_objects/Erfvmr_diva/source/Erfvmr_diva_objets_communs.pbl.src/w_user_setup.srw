$PBExportHeader$w_user_setup.srw
forward
global type w_user_setup from w_a
end type
type cb_2 from u_cb_cancel within w_user_setup
end type
type cb_1 from u_cb_ok within w_user_setup
end type
type p_logo from picture within w_user_setup
end type
type st_visiteur from statictext within w_user_setup
end type
type em_visiteur from u_slea within w_user_setup
end type
type r_1 from rectangle within w_user_setup
end type
end forward

global type w_user_setup from w_a
integer width = 1664
integer height = 612
string title = "User Setup Connexion"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
long backcolor = 12632256
boolean center = true
cb_2 cb_2
cb_1 cb_1
p_logo p_logo
st_visiteur st_visiteur
em_visiteur em_visiteur
r_1 r_1
end type
global w_user_setup w_user_setup

on w_user_setup.create
int iCurrent
call super::create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.p_logo=create p_logo
this.st_visiteur=create st_visiteur
this.em_visiteur=create em_visiteur
this.r_1=create r_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.p_logo
this.Control[iCurrent+4]=this.st_visiteur
this.Control[iCurrent+5]=this.em_visiteur
this.Control[iCurrent+6]=this.r_1
end on

on w_user_setup.destroy
call super::destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.p_logo)
destroy(this.st_visiteur)
destroy(this.em_visiteur)
destroy(this.r_1)
end on

event ue_cancel;call super::ue_cancel;i_str_pass.s_action = "cancel"
Message.fnv_set_str_pass(i_str_pass)
Close (This)
end event

event ue_ok;call super::ue_ok;long ll_row
string ls_langue

if len(trim(em_visiteur.text)) = 0 then
	messagebox ( "Setup Error", "User Id is mandatory",information!)
	return
end if

/* creation du visieur dans la table come9par */
nv_datastore  lds_datastore
lds_datastore = create nv_datastore

lds_datastore .dataobject = "d_parametres_visiteur"
lds_datastore.setTrans (SQLCA)
lds_datastore.retrieve(em_visiteur.text)
ll_row = lds_datastore.insertrow( 0)
lds_datastore.setItem(ll_row,DBNAME_CODE_VISITEUR,em_visiteur.text)
lds_datastore.setItem(ll_row,DBNAME_MOT_PASSE,em_visiteur.text)

ls_langue = 'F'

lds_datastore.setItem(ll_row,DBNAME_CODE_LANGUE,ls_langue)
if lds_datastore.update() = DB_ERROR then
	f_dmc_error(lds_datastore.uf_getdberror( ))
end if

/* creation du visiteur dans la table come9020 qui contiendra le visiteur ayant le droit
   de se connecter  */
lds_datastore .dataobject = "d_visiteur_autorise"
lds_datastore.setTrans (SQLCA)
lds_datastore.retrieve(em_visiteur.text)
if lds_datastore.rowcount() > 0 then
	lds_datastore.rowsmove( 1, lds_datastore.rowcount(), Primary!,lds_datastore,1, Delete!)
end if
ll_row = lds_datastore.insertrow( 0)
lds_datastore.setItem(ll_row,DBNAME_CODE_VISITEUR,em_visiteur.text)
lds_datastore.update()

destroy lds_datastore
i_str_pass.s_action = "ok"
i_str_pass.s[1] = em_visiteur.text
i_str_pass.s[2] = 'F'

Message.fnv_set_str_pass(i_str_pass)
Close (This)
end event

type uo_statusbar from w_a`uo_statusbar within w_user_setup
end type

type cb_2 from u_cb_cancel within w_user_setup
integer x = 1070
integer y = 384
integer width = 352
integer height = 96
integer taborder = 40
string text = "Cancel"
end type

type cb_1 from u_cb_ok within w_user_setup
integer x = 283
integer y = 388
integer width = 352
integer height = 96
integer taborder = 30
end type

type p_logo from picture within w_user_setup
integer x = 123
integer y = 80
integer width = 293
integer height = 212
string picturename = "c:\appscir\Erfvmr_diva\Image\KEY.BMP"
boolean focusrectangle = false
end type

type st_visiteur from statictext within w_user_setup
integer x = 562
integer y = 120
integer width = 485
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 12632256
boolean enabled = false
string text = "User Id :"
boolean focusrectangle = false
end type

type em_visiteur from u_slea within w_user_setup
integer x = 987
integer y = 96
integer width = 366
integer height = 96
integer taborder = 10
boolean bringtotop = true
end type

type r_1 from rectangle within w_user_setup
long linecolor = 16711680
integer linethickness = 4
long fillcolor = 12632256
integer x = 37
integer y = 64
integer width = 1536
integer height = 256
end type

