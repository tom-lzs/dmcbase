$PBExportHeader$w_a_propos.srw
$PBExportComments$Fenetre d'affichage de la version et de la connection associée à l'application.
forward
global type w_a_propos from w_a
end type
type titre_appli from statictext within w_a_propos
end type
type sle_nom from u_slea within w_a_propos
end type
type welcome from statictext within w_a_propos
end type
type p_1 from picture within w_a_propos
end type
type p_2 from picture within w_a_propos
end type
type rr_1 from roundrectangle within w_a_propos
end type
end forward

global type w_a_propos from w_a
string tag = "A_PROPOS"
integer width = 3397
integer height = 1344
boolean minbox = false
boolean maxbox = false
long backcolor = 67108864
boolean toolbarvisible = false
boolean clientedge = true
boolean center = true
string i_s_microhelp = ""
boolean ib_statusbar_visible = true
titre_appli titre_appli
sle_nom sle_nom
welcome welcome
p_1 p_1
p_2 p_2
rr_1 rr_1
end type
global w_a_propos w_a_propos

event ue_init;call super::ue_init;sle_nom.text = g_nv_come9par.get_nom_visiteur()

timer(8)
end event

on w_a_propos.create
int iCurrent
call super::create
this.titre_appli=create titre_appli
this.sle_nom=create sle_nom
this.welcome=create welcome
this.p_1=create p_1
this.p_2=create p_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.titre_appli
this.Control[iCurrent+2]=this.sle_nom
this.Control[iCurrent+3]=this.welcome
this.Control[iCurrent+4]=this.p_1
this.Control[iCurrent+5]=this.p_2
this.Control[iCurrent+6]=this.rr_1
end on

on w_a_propos.destroy
call super::destroy
destroy(this.titre_appli)
destroy(this.sle_nom)
destroy(this.welcome)
destroy(this.p_1)
destroy(this.p_2)
destroy(this.rr_1)
end on

event ue_cancel;call super::ue_cancel;close(this)
end event

event timer;call super::timer;
timer(0)
close (this)
end event

event ue_close;call super::ue_close;close(this)
end event

type uo_statusbar from w_a`uo_statusbar within w_a_propos
integer x = 0
integer y = 1664
end type

type titre_appli from statictext within w_a_propos
integer x = 178
integer y = 76
integer width = 2112
integer height = 140
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
boolean focusrectangle = false
end type

type sle_nom from u_slea within w_a_propos
string tag = "NO_TEXT"
integer x = 1070
integer y = 264
integer width = 1701
integer height = 112
integer taborder = 10
boolean bringtotop = true
integer textsize = -14
integer weight = 700
long textcolor = 16711680
long backcolor = 67108864
boolean border = false
boolean displayonly = true
borderstyle borderstyle = styleraised!
end type

type welcome from statictext within w_a_propos
integer x = 119
integer y = 268
integer width = 919
integer height = 108
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 67108864
string text = "none"
alignment alignment = right!
boolean focusrectangle = false
end type

type p_1 from picture within w_a_propos
integer x = 219
integer y = 616
integer width = 873
integer height = 396
boolean bringtotop = true
string picturename = "c:\appscir\Erfvmr_diva\Image\logo.jpg"
boolean focusrectangle = false
end type

type p_2 from picture within w_a_propos
integer x = 2304
integer y = 544
integer width = 544
integer height = 552
boolean bringtotop = true
boolean originalsize = true
string picturename = "c:\appscir\Erfvmr_diva\Image\LogoPegasus.jpg"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_a_propos
integer linethickness = 4
long fillcolor = 67108864
integer x = 37
integer y = 36
integer width = 3255
integer height = 416
integer cornerheight = 40
integer cornerwidth = 46
end type

