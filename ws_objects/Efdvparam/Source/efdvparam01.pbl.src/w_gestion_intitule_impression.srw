$PBExportHeader$w_gestion_intitule_impression.srw
forward
global type w_gestion_intitule_impression from w_a
end type
type cb_1 from u_cb_close within w_gestion_intitule_impression
end type
type cb_2 from u_cb_print within w_gestion_intitule_impression
end type
type rb_allemand from radiobutton within w_gestion_intitule_impression
end type
type rb_italien from radiobutton within w_gestion_intitule_impression
end type
type rb_espagnol from radiobutton within w_gestion_intitule_impression
end type
type rb_anglais from radiobutton within w_gestion_intitule_impression
end type
type gb_rb from groupbox within w_gestion_intitule_impression
end type
end forward

global type w_gestion_intitule_impression from w_a
integer width = 1161
integer height = 1040
string title = "Sélection impression traduction"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
long backcolor = 12632256
cb_1 cb_1
cb_2 cb_2
rb_allemand rb_allemand
rb_italien rb_italien
rb_espagnol rb_espagnol
rb_anglais rb_anglais
gb_rb gb_rb
end type
global w_gestion_intitule_impression w_gestion_intitule_impression

on w_gestion_intitule_impression.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.cb_2=create cb_2
this.rb_allemand=create rb_allemand
this.rb_italien=create rb_italien
this.rb_espagnol=create rb_espagnol
this.rb_anglais=create rb_anglais
this.gb_rb=create gb_rb
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.rb_allemand
this.Control[iCurrent+4]=this.rb_italien
this.Control[iCurrent+5]=this.rb_espagnol
this.Control[iCurrent+6]=this.rb_anglais
this.Control[iCurrent+7]=this.gb_rb
end on

on w_gestion_intitule_impression.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.rb_allemand)
destroy(this.rb_italien)
destroy(this.rb_espagnol)
destroy(this.rb_anglais)
destroy(this.gb_rb)
end on

event ue_print;call super::ue_print;datastore lnv_datastore
String   ls_dataobject
lnv_datastore = create datastore

if rb_anglais.checked then
	ls_dataobject = "d_impr_tradu_anglais"
elseif rb_espagnol.checked then
	ls_dataobject = "d_impr_tradu_espagnol"
elseif rb_italien.checked then
	ls_dataobject = "d_impr_tradu_italien"
else
	ls_dataobject = "d_impr_tradu_allemand"
end if 
lnv_datastore.dataobject = ls_dataobject
lnv_datastore.setTrans(sqlca)
lnv_datastore.retrieve()
lnv_datastore.print()
end event

event ue_close;call super::ue_close;close(this)
end event

type cb_1 from u_cb_close within w_gestion_intitule_impression
integer x = 128
integer y = 832
integer width = 352
integer height = 96
integer taborder = 40
end type

type cb_2 from u_cb_print within w_gestion_intitule_impression
integer x = 731
integer y = 832
integer width = 352
integer height = 96
integer taborder = 30
end type

type rb_allemand from radiobutton within w_gestion_intitule_impression
integer x = 274
integer y = 532
integer width = 402
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Portugais"
end type

type rb_italien from radiobutton within w_gestion_intitule_impression
integer x = 274
integer y = 424
integer width = 402
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Italien"
end type

type rb_espagnol from radiobutton within w_gestion_intitule_impression
integer x = 274
integer y = 308
integer width = 402
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Espagnol"
end type

type rb_anglais from radiobutton within w_gestion_intitule_impression
integer x = 274
integer y = 192
integer width = 402
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Anglais"
end type

type gb_rb from groupbox within w_gestion_intitule_impression
integer x = 114
integer y = 84
integer width = 946
integer height = 632
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Sélection langue"
end type

