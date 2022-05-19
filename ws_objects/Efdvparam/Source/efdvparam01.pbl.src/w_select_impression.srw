$PBExportHeader$w_select_impression.srw
$PBExportComments$Permet la sélection de l'impression de la traduction
forward
global type w_select_impression from w_a
end type
type rb_de_fr from radiobutton within w_select_impression
end type
type rb_de_en from radiobutton within w_select_impression
end type
type rb_de_es from radiobutton within w_select_impression
end type
type rb_de_it from radiobutton within w_select_impression
end type
type cb_2 from u_cba within w_select_impression
end type
type cb_1 from u_cba within w_select_impression
end type
type gb_2 from groupbox within w_select_impression
end type
type rb_or_it from radiobutton within w_select_impression
end type
type rb_or_es from radiobutton within w_select_impression
end type
type rb_or_en from radiobutton within w_select_impression
end type
type rb_or_fr from radiobutton within w_select_impression
end type
type gb_1 from groupbox within w_select_impression
end type
end forward

global type w_select_impression from w_a
integer x = 769
integer y = 461
integer width = 1669
integer height = 1056
string title = "Selection Impression"
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
long backcolor = 12632256
rb_de_fr rb_de_fr
rb_de_en rb_de_en
rb_de_es rb_de_es
rb_de_it rb_de_it
cb_2 cb_2
cb_1 cb_1
gb_2 gb_2
rb_or_it rb_or_it
rb_or_es rb_or_es
rb_or_en rb_or_en
rb_or_fr rb_or_fr
gb_1 gb_1
end type
global w_select_impression w_select_impression

event ue_ok;call super::ue_ok;/* <DESC>
     Permet la validation de la saisie de l'article et quitter la fenetre en passant l'article saisi
   </DESC> */

datastore ds_impression
String        ls_langue_origine
String	   ls_langue_destination

ds_impression = CREATE datastore
ds_impression.dataobject = "d_impr_traduction"
ds_impression.settrans( i_tr_sql)

if rb_or_fr.checked then
	ls_langue_origine = 'F'
elseif rb_or_en.checked then
	ls_langue_origine = 'E' 
elseif rb_or_es.checked then
	ls_langue_origine = 'S' 
else 	
	ls_langue_origine = 'I'
end if

if rb_de_fr.checked then
	ls_langue_destination = 'F'
elseif rb_de_en.checked then
	ls_langue_destination = 'E' 
elseif rb_de_es.checked then
	ls_langue_destination = 'S' 
else 	
	ls_langue_destination = 'I'
end if

ds_impression.retrieve( ls_langue_origine, ls_langue_destination)
ds_impression.print()
i_str_pass.s_action = ACTION_OK
Message.fnv_set_str_pass(i_str_pass)
Close (this)
end event

event ue_cancel;call super::ue_cancel;/* <DESC> 
     Permet de quitter la fenetre sans effectuer de selection
   </DESC> */
	i_str_pass.s_action = ACTION_CANCEL
	Message.fnv_set_str_pass(i_str_pass)
	Close (this)

end event

on w_select_impression.create
int iCurrent
call super::create
this.rb_de_fr=create rb_de_fr
this.rb_de_en=create rb_de_en
this.rb_de_es=create rb_de_es
this.rb_de_it=create rb_de_it
this.cb_2=create cb_2
this.cb_1=create cb_1
this.gb_2=create gb_2
this.rb_or_it=create rb_or_it
this.rb_or_es=create rb_or_es
this.rb_or_en=create rb_or_en
this.rb_or_fr=create rb_or_fr
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_de_fr
this.Control[iCurrent+2]=this.rb_de_en
this.Control[iCurrent+3]=this.rb_de_es
this.Control[iCurrent+4]=this.rb_de_it
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.gb_2
this.Control[iCurrent+8]=this.rb_or_it
this.Control[iCurrent+9]=this.rb_or_es
this.Control[iCurrent+10]=this.rb_or_en
this.Control[iCurrent+11]=this.rb_or_fr
this.Control[iCurrent+12]=this.gb_1
end on

on w_select_impression.destroy
call super::destroy
destroy(this.rb_de_fr)
destroy(this.rb_de_en)
destroy(this.rb_de_es)
destroy(this.rb_de_it)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.gb_2)
destroy(this.rb_or_it)
destroy(this.rb_or_es)
destroy(this.rb_or_en)
destroy(this.rb_or_fr)
destroy(this.gb_1)
end on

type rb_de_fr from radiobutton within w_select_impression
integer x = 873
integer y = 304
integer width = 402
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Francais"
boolean checked = true
end type

type rb_de_en from radiobutton within w_select_impression
integer x = 873
integer y = 376
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Anglais"
end type

type rb_de_es from radiobutton within w_select_impression
integer x = 873
integer y = 448
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Espagnol"
end type

type rb_de_it from radiobutton within w_select_impression
integer x = 873
integer y = 524
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Italien"
end type

type cb_2 from u_cba within w_select_impression
integer x = 910
integer y = 700
integer width = 352
integer height = 96
integer taborder = 20
string text = "Fermer"
end type

event constructor;call super::constructor;i_s_event = "ue_cancel"
end event

type cb_1 from u_cba within w_select_impression
integer x = 430
integer y = 700
integer width = 352
integer height = 96
integer taborder = 20
string text = "OK"
end type

event constructor;call super::constructor;i_s_event = "ue_ok"
end event

type gb_2 from groupbox within w_select_impression
integer x = 823
integer y = 212
integer width = 613
integer height = 400
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Destination"
end type

type rb_or_it from radiobutton within w_select_impression
integer x = 224
integer y = 516
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Italien"
end type

type rb_or_es from radiobutton within w_select_impression
integer x = 224
integer y = 440
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Espagnol"
end type

type rb_or_en from radiobutton within w_select_impression
integer x = 224
integer y = 368
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Anglais"
end type

type rb_or_fr from radiobutton within w_select_impression
integer x = 224
integer y = 296
integer width = 402
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Francais"
boolean checked = true
end type

type gb_1 from groupbox within w_select_impression
integer x = 114
integer y = 220
integer width = 613
integer height = 400
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Origine"
end type

