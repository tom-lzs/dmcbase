$PBExportHeader$w_selection_type_edition_anomalie.srw
$PBExportComments$Saisie du type d'édition à effectuer : Standard ou à destination du client
forward
global type w_selection_type_edition_anomalie from w_a_selection
end type
type rb_standard_t from radiobutton within w_selection_type_edition_anomalie
end type
type rb_client_t from radiobutton within w_selection_type_edition_anomalie
end type
type gb_1 from groupbox within w_selection_type_edition_anomalie
end type
end forward

global type w_selection_type_edition_anomalie from w_a_selection
string tag = "SELECTION_TYPE_EDITION_ANOM"
integer width = 1312
integer height = 780
string title = "*Sélection type edition des anomalies*"
boolean controlmenu = true
long backcolor = 12632256
rb_standard_t rb_standard_t
rb_client_t rb_client_t
gb_1 gb_1
end type
global w_selection_type_edition_anomalie w_selection_type_edition_anomalie

on w_selection_type_edition_anomalie.create
int iCurrent
call super::create
this.rb_standard_t=create rb_standard_t
this.rb_client_t=create rb_client_t
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_standard_t
this.Control[iCurrent+2]=this.rb_client_t
this.Control[iCurrent+3]=this.gb_1
end on

on w_selection_type_edition_anomalie.destroy
call super::destroy
destroy(this.rb_standard_t)
destroy(this.rb_client_t)
destroy(this.gb_1)
end on

event ue_ok;call super::ue_ok;/* <DESC>
      Ferme la fenêtre en passant le type d'impression sélectionner.
   </DESC> */
if rb_standard_t.checked then
	i_str_pass.b[1] = true
else
	i_str_pass.b[1] = false
end if
Message.fnv_set_str_pass(i_str_pass)
Close (This)

end event

type uo_statusbar from w_a_selection`uo_statusbar within w_selection_type_edition_anomalie
end type

type pb_ok from w_a_selection`pb_ok within w_selection_type_edition_anomalie
integer x = 133
integer y = 480
string picturename = "c:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_echap from w_a_selection`pb_echap within w_selection_type_edition_anomalie
integer x = 704
integer y = 480
string picturename = "c:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type rb_standard_t from radiobutton within w_selection_type_edition_anomalie
integer x = 329
integer y = 148
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Standard"
boolean checked = true
end type

type rb_client_t from radiobutton within w_selection_type_edition_anomalie
integer x = 338
integer y = 248
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Client"
end type

type gb_1 from groupbox within w_selection_type_edition_anomalie
string tag = "NO_TEXT"
integer x = 110
integer y = 60
integer width = 951
integer height = 308
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
end type

