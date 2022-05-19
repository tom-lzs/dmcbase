$PBExportHeader$w_gestion_pays_pour_gratuit.srw
$PBExportComments$Permet de gerer les pays pour lequelles il faudra eclater les commandes contenant des lignes  gratuites
forward
global type w_gestion_pays_pour_gratuit from w_a_udim
end type
type cb_ok from u_cba within w_gestion_pays_pour_gratuit
end type
type cb_fermer from u_cba within w_gestion_pays_pour_gratuit
end type
type rb_tous from radiobutton within w_gestion_pays_pour_gratuit
end type
type rb_select from radiobutton within w_gestion_pays_pour_gratuit
end type
type rb_nonselect from radiobutton within w_gestion_pays_pour_gratuit
end type
type gb_1 from groupbox within w_gestion_pays_pour_gratuit
end type
end forward

global type w_gestion_pays_pour_gratuit from w_a_udim
integer width = 2341
integer height = 2540
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = child!
windowstate windowstate = maximized!
long backcolor = 12632256
cb_ok cb_ok
cb_fermer cb_fermer
rb_tous rb_tous
rb_select rb_select
rb_nonselect rb_nonselect
gb_1 gb_1
end type
global w_gestion_pays_pour_gratuit w_gestion_pays_pour_gratuit

type variables
datastore ids_pays_pour_eclatement
end variables

event ue_ok;/* <DESC>
    Mise à jour de la table des pays pour eclatement à partir des pays sélectionnés.
    Cette mmise à jour s'effectue par annule et remplace
   </DESC> */
	
// OverWrite 
long ll_indice
long ll_row

ids_pays_pour_eclatement.retrieve()
ids_pays_pour_eclatement.RowsMove(1,ids_pays_pour_eclatement.RowCount(),Primary!, ids_pays_pour_eclatement,1,Delete!)
ids_pays_pour_eclatement.update()

for ll_indice = 1 to dw_1.rowCount()
	if dw_1.getitemString(ll_indice,"cselection") = "O" then
		ll_row = ids_pays_pour_eclatement.insertRow(0)
		ids_pays_pour_eclatement.SetItem(ll_row,DBNAME_DATE_CREATION, i_tr_sql.fnv_get_datetime( ))
		ids_pays_pour_eclatement.SetItem(ll_row,DBNAME_CODE_MAJ,"C")
		ids_pays_pour_eclatement.SetItem(ll_row,DBNAME_PAYS, dw_1.getitemString(ll_indice, DBNAME_PAYS) )		
	end if
next

ids_pays_pour_eclatement.update()


end event

event ue_init;call super::ue_init;/* <DESC>
   Extraction de la liste des pays et mise à jour de l'indicateur de
	selection pour les pays dejaseletionés 
 </DESC> */
ids_pays_pour_eclatement = create datastore
ids_pays_pour_eclatement.dataobject = "d_maj_pays_gratuit"
ids_pays_pour_eclatement.setTransObject (i_tr_sql)


dw_1.retrieve()
ids_pays_pour_eclatement.retrieve()

Long ll_indice
Long ll_row
String ls_find

for ll_indice = 1 to ids_pays_pour_eclatement.rowcount()
	 ls_find =  DBNAME_PAYS     + "  = '" + ids_pays_pour_eclatement.getItemString(ll_indice, DBNAME_PAYS ) + "'"
	  ll_row =	dw_1.Find (  ls_find, 1,dw_1.RowCount())
	  if ll_row <> 0 then
		 dw_1.setItem(ll_row,"cselection","O")
	  end if
next

end event

event ue_close;i_b_canceled = TRUE
Close (this)
end event

on w_gestion_pays_pour_gratuit.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.cb_fermer=create cb_fermer
this.rb_tous=create rb_tous
this.rb_select=create rb_select
this.rb_nonselect=create rb_nonselect
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.cb_fermer
this.Control[iCurrent+3]=this.rb_tous
this.Control[iCurrent+4]=this.rb_select
this.Control[iCurrent+5]=this.rb_nonselect
this.Control[iCurrent+6]=this.gb_1
end on

on w_gestion_pays_pour_gratuit.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.cb_fermer)
destroy(this.rb_tous)
destroy(this.rb_select)
destroy(this.rb_nonselect)
destroy(this.gb_1)
end on

type dw_1 from w_a_udim`dw_1 within w_gestion_pays_pour_gratuit
integer x = 78
integer y = 40
integer width = 1518
integer height = 2224
string dataobject = "d_liste_pays_pour_selection"
boolean vscrollbar = true
end type

type uo_statusbar from w_a_udim`uo_statusbar within w_gestion_pays_pour_gratuit
end type

type cb_ok from u_cba within w_gestion_pays_pour_gratuit
integer x = 247
integer y = 2364
integer width = 352
integer height = 96
integer taborder = 11
boolean bringtotop = true
string text = "OK"
end type

event constructor;call super::constructor;i_s_event = "ue_ok"
end event

type cb_fermer from u_cba within w_gestion_pays_pour_gratuit
integer x = 1042
integer y = 2372
integer width = 352
integer height = 96
integer taborder = 11
boolean bringtotop = true
string text = "Fermer"
end type

event constructor;call super::constructor;i_s_event = "ue_cancel"
end event

type rb_tous from radiobutton within w_gestion_pays_pour_gratuit
integer x = 1691
integer y = 344
integer width = 421
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Toute la liste"
end type

event clicked;dw_1.setFilter("")
dw_1.filter()

end event

type rb_select from radiobutton within w_gestion_pays_pour_gratuit
integer x = 1691
integer y = 416
integer width = 338
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Sélection"
end type

event clicked;dw_1.setFilter("cselection = 'O'")
dw_1.filter()
end event

type rb_nonselect from radiobutton within w_gestion_pays_pour_gratuit
integer x = 1691
integer y = 488
integer width = 507
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Non sélectionné"
end type

event clicked;dw_1.setFilter("cselection = 'N'")
dw_1.filter()
end event

type gb_1 from groupbox within w_gestion_pays_pour_gratuit
integer x = 1646
integer y = 264
integer width = 599
integer height = 340
integer taborder = 11
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
end type

