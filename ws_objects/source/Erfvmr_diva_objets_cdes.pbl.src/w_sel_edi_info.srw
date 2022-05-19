$PBExportHeader$w_sel_edi_info.srw
$PBExportComments$SAisir les infos EDI magasin et commande magasin pour mise à jour de masse des lignes sélectionnées
forward
global type w_sel_edi_info from w_a_selection
end type
type numaemag_t from statictext within w_sel_edi_info
end type
type ncdaemag_t from statictext within w_sel_edi_info
end type
type sle_numaemag from u_slea within w_sel_edi_info
end type
type sle_ncdaemag from u_slea within w_sel_edi_info
end type
end forward

global type w_sel_edi_info from w_a_selection
string tag = "MODIFICATION_INFO_EDI"
integer x = 1248
integer y = 700
integer width = 2213
integer height = 692
string title = "*Modification données EDI*"
long backcolor = 12632256
numaemag_t numaemag_t
ncdaemag_t ncdaemag_t
sle_numaemag sle_numaemag
sle_ncdaemag sle_ncdaemag
end type
global w_sel_edi_info w_sel_edi_info

event ue_ok;call super::ue_ok;i_str_pass.s[1] = sle_numaemag.text
i_str_pass.s[2] = sle_ncdaemag.text

Message.fnv_set_str_pass(i_str_pass)
Close (This)

end event

on w_sel_edi_info.create
int iCurrent
call super::create
this.numaemag_t=create numaemag_t
this.ncdaemag_t=create ncdaemag_t
this.sle_numaemag=create sle_numaemag
this.sle_ncdaemag=create sle_ncdaemag
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.numaemag_t
this.Control[iCurrent+2]=this.ncdaemag_t
this.Control[iCurrent+3]=this.sle_numaemag
this.Control[iCurrent+4]=this.sle_ncdaemag
end on

on w_sel_edi_info.destroy
call super::destroy
destroy(this.numaemag_t)
destroy(this.ncdaemag_t)
destroy(this.sle_numaemag)
destroy(this.sle_ncdaemag)
end on

event key;call super::key;/* <DESC>
      Permet de trapper les touches de fonction activées et déclencher l'évènement associé
	à la touche.
	  F11 = Validation de la saisie
   </DESC> */
	IF KeyDown (KeyF11!) THEN
		This.TriggerEvent ("ue_ok")
	END IF
	
end event

type uo_statusbar from w_a_selection`uo_statusbar within w_sel_edi_info
integer x = 434
integer y = 684
end type

type pb_ok from w_a_selection`pb_ok within w_sel_edi_info
integer x = 603
integer y = 380
integer taborder = 40
string picturename = "c:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_echap from w_a_selection`pb_echap within w_sel_edi_info
integer x = 1125
integer y = 380
integer taborder = 50
string picturename = "c:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type numaemag_t from statictext within w_sel_edi_info
integer x = 183
integer y = 108
integer width = 635
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
string text = "N° Magasin "
boolean focusrectangle = false
end type

type ncdaemag_t from statictext within w_sel_edi_info
integer x = 183
integer y = 208
integer width = 635
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
string text = "N° Cde magasin"
boolean focusrectangle = false
end type

type sle_numaemag from u_slea within w_sel_edi_info
integer x = 914
integer y = 100
integer width = 457
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer limit = 15
end type

type sle_ncdaemag from u_slea within w_sel_edi_info
integer x = 914
integer y = 208
integer width = 462
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer limit = 15
end type

