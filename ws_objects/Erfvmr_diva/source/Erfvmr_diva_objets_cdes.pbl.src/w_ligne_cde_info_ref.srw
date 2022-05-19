$PBExportHeader$w_ligne_cde_info_ref.srw
$PBExportComments$Affichage des informations générales et tarif de la référence passés en paramètre.
forward
global type w_ligne_cde_info_ref from w_a_q
end type
type dw_cde from u_dw_q within w_ligne_cde_info_ref
end type
type inf_cde_t from statictext within w_ligne_cde_info_ref
end type
type dw_edi from u_dw_q within w_ligne_cde_info_ref
end type
type pb_ok from u_pba_ok within w_ligne_cde_info_ref
end type
type pb_echap from u_pba_echap within w_ligne_cde_info_ref
end type
end forward

global type w_ligne_cde_info_ref from w_a_q
string tag = "INFO_REF"
integer width = 3003
integer height = 2396
string title = "*Info Référence*"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
long backcolor = 12632256
boolean contexthelp = true
boolean center = true
dw_cde dw_cde
inf_cde_t inf_cde_t
dw_edi dw_edi
pb_ok pb_ok
pb_echap pb_echap
end type
global w_ligne_cde_info_ref w_ligne_cde_info_ref

event ue_init;call super::ue_init;/* <DESC>
     Affichage des données de la référence
   </DESC> */
dw_cde.SetTransObject (i_tr_sql)
dw_edi.SetTransObject (i_tr_sql)
dw_1.retrieve (i_str_pass.s[01], i_str_pass.s[2], i_str_pass.s[3], i_str_pass.s[4], i_str_pass.s[5])

// extraction du tarif pour mettre à jour les infos au niveau de l'article
datastore ds_tarif 
ds_tarif = create datastore
ds_tarif.Dataobject = "d_dimension_tarif"
ds_tarif.SetTransObject (i_tr_sql)

ds_tarif.retrieve(i_str_pass.s[01], i_str_pass.s[2], i_str_pass.s[3], i_str_pass.s[4])
if ds_tarif.RowCount() = 0 then
      dw_1.setItem(1, DBNAME_PRIX_ARTICLE,0)		
else
	dw_1.setItem(1, DBNAME_PRIX_ARTICLE, ds_tarif.getItemDecimal(1,DBNAME_PRIX_ARTICLE))
end if

if not g_nv_come9par.is_francais() then
	dw_cde.object.compute_e.visible = 1
	dw_cde.object.compute_f.visible = 0
end if


dw_cde.retrieve(i_str_pass.s[6],i_str_pass.s[01] )
dw_edi.retrieve(i_str_pass.s[6],i_str_pass.s[08] )
//sle_ref_clt.text = i_str_pass.s[7]
end event

on w_ligne_cde_info_ref.create
int iCurrent
call super::create
this.dw_cde=create dw_cde
this.inf_cde_t=create inf_cde_t
this.dw_edi=create dw_edi
this.pb_ok=create pb_ok
this.pb_echap=create pb_echap
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cde
this.Control[iCurrent+2]=this.inf_cde_t
this.Control[iCurrent+3]=this.dw_edi
this.Control[iCurrent+4]=this.pb_ok
this.Control[iCurrent+5]=this.pb_echap
end on

on w_ligne_cde_info_ref.destroy
call super::destroy
destroy(this.dw_cde)
destroy(this.inf_cde_t)
destroy(this.dw_edi)
destroy(this.pb_ok)
destroy(this.pb_echap)
end on

event ue_ok;call super::ue_ok;/* =====================================
         Mise à jour de la ligne de commande 
    ===================================== */
	 
	 dw_edi.SetItem (1, DBNAME_DATE_CREATION, sqlca.fnv_get_datetime ())
	 dw_edi.update()
	 triggerevent("ue_close")
	 
end event

event ue_cancel;call super::ue_cancel;	 triggerevent("ue_close")
end event

type uo_statusbar from w_a_q`uo_statusbar within w_ligne_cde_info_ref
integer x = 5
integer y = 2336
end type

type dw_1 from w_a_q`dw_1 within w_ligne_cde_info_ref
string tag = "A_TRADUIRE"
integer x = 485
integer y = 20
integer width = 2048
integer height = 432
string dataobject = "d_info_reference"
end type

type dw_cde from u_dw_q within w_ligne_cde_info_ref
string tag = "A_TRADUIRE"
integer x = 768
integer y = 580
integer width = 1458
integer height = 228
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_qte_par_article"
end type

type inf_cde_t from statictext within w_ligne_cde_info_ref
integer x = 887
integer y = 500
integer width = 1147
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 15793151
string text = "????Infos Commande - Total Article"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_edi from u_dw_q within w_ligne_cde_info_ref
string tag = "A_TRADUIRE"
integer x = 119
integer y = 856
integer width = 2706
integer height = 1220
integer taborder = 21
boolean bringtotop = true
string dataobject = "d_ligne_cde_info_edi"
end type

type pb_ok from u_pba_ok within w_ligne_cde_info_ref
integer x = 731
integer y = 2088
integer width = 361
integer height = 152
integer taborder = 31
boolean bringtotop = true
string text = "Valid. F11"
boolean default = false
string picturename = "c:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_echap from u_pba_echap within w_ligne_cde_info_ref
integer x = 1285
integer y = 2088
integer width = 320
integer height = 152
integer taborder = 41
boolean bringtotop = true
string picturename = "c:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

