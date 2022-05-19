$PBExportHeader$w_confirmation_integration.srw
forward
global type w_confirmation_integration from w_a
end type
type st_1 from statictext within w_confirmation_integration
end type
type st_2 from statictext within w_confirmation_integration
end type
type st_3 from statictext within w_confirmation_integration
end type
type st_4 from statictext within w_confirmation_integration
end type
type st_5 from statictext within w_confirmation_integration
end type
type pb_echap from u_pba_echap within w_confirmation_integration
end type
type p_1 from picture within w_confirmation_integration
end type
end forward

global type w_confirmation_integration from w_a
integer width = 3890
integer height = 2084
windowstate windowstate = maximized!
long backcolor = 25755647
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
st_5 st_5
pb_echap pb_echap
p_1 p_1
end type
global w_confirmation_integration w_confirmation_integration

on w_confirmation_integration.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.pb_echap=create pb_echap
this.p_1=create p_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.st_5
this.Control[iCurrent+6]=this.pb_echap
this.Control[iCurrent+7]=this.p_1
end on

on w_confirmation_integration.destroy
call super::destroy
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.pb_echap)
destroy(this.p_1)
end on

event ue_cancel;call super::ue_cancel;Close (this)
end event

type uo_statusbar from w_a`uo_statusbar within w_confirmation_integration
integer x = 5
integer y = 1888
end type

type st_1 from statictext within w_confirmation_integration
string tag = "NO_TEXT"
integer x = 997
integer y = 528
integer width = 1783
integer height = 100
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 25755647
string text = "F D V Application"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_confirmation_integration
string tag = "NO_TEXT"
integer x = 960
integer y = 792
integer width = 1861
integer height = 88
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 25755647
string text = "Le transfert de vos commandes est réalisé"
alignment alignment = center!
end type

type st_3 from statictext within w_confirmation_integration
string tag = "NO_TEXT"
integer x = 965
integer y = 944
integer width = 1847
integer height = 88
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 25755647
string text = "The transfer of your orders is carried out"
alignment alignment = center!
end type

type st_4 from statictext within w_confirmation_integration
string tag = "NO_TEXT"
integer x = 974
integer y = 1108
integer width = 1842
integer height = 88
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 25755647
string text = "Il trasferimento dei vostri ordini è effettuato"
alignment alignment = center!
end type

type st_5 from statictext within w_confirmation_integration
string tag = "NO_TEXT"
integer x = 983
integer y = 1272
integer width = 1801
integer height = 88
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 25755647
string text = "La transferencia de tus órdenes se realiza"
alignment alignment = center!
end type

type pb_echap from u_pba_echap within w_confirmation_integration
integer x = 1582
integer y = 1556
integer width = 549
integer height = 208
integer taborder = 11
boolean bringtotop = true
string picturename = "C:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type p_1 from picture within w_confirmation_integration
integer x = 105
integer y = 68
integer width = 3643
integer height = 392
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\appscir\Erfvmr_diva\Image\FdvCireInstall.JPG"
boolean focusrectangle = false
end type

