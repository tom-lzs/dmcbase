$PBExportHeader$w_message_9086.srw
$PBExportComments$Permet la gestion du message associé à une commande.
forward
global type w_message_9086 from w_message_cde_response
end type
type dw_2 from u_dwa within w_message_9086
end type
type ln_1 from line within w_message_9086
end type
end forward

global type w_message_9086 from w_message_cde_response
integer width = 3776
integer height = 2224
string title = ""
boolean resizable = false
boolean ib_statusbar_visible = true
dw_2 dw_2
ln_1 ln_1
end type
global w_message_9086 w_message_9086

on w_message_9086.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.ln_1=create ln_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.ln_1
end on

on w_message_9086.destroy
call super::destroy
destroy(this.dw_2)
destroy(this.ln_1)
end on

event closequery;// overwrite
end event

event ue_presave;// DECLARATION DES VARIABLES LOCALES
long			l_row
String		s_num

l_row			 = dw_1.fu_get_itemchanged_row_num ()
IF l_row = 0 Or l_row > dw_1.RowCount() THEN
	Message.ReturnValue = -1
	RETURN
END IF

dw_1.SetItem (l_row, DBNAME_DATE_CREATION, SQLCA.fnv_get_datetime ())
dw_1.SetItem (l_row, DBNAME_CODE_MAJ, CODE_CREATION)
dw_1.SetItem (l_row, DBNAME_NUM_CDE, i_nv_commande_object.fu_get_numero_cde())
dw_1.SetItem (l_row, DBNAME_CODE_LANGUE, " ")


s_num = String(l_row)
do until len (String(s_num)) = 2
	s_num = "0" + String(s_num)
loop

s_num = "9" + s_num
dw_1.SetItem (l_row, DBNAME_MESSAGE_NUM_LIGNE, s_num)

end event

event ue_init;call super::ue_init;dw_2.SetTransObject (i_tr_sql)
//dw_2.retrieve()// CHARGEMENT DE LA DTW DW_1
if dw_2.Retrieve (i_nv_commande_object.fu_get_numero_cde()) = -1 then
		f_dmc_error (this.title + BLANK + DB_ERROR_MESSAGE)
end if

this.title = g_nv_traduction.get_traduction('BORDEREAU_PREPARATION')
end event

event ue_workflow;close(this)
end event

event ue_ok;/* <DESC>
  Validation finale de la saisie:
    - Sauvegarde de la dernière ligne
    - Retour sur la fenêtre d''appel en passant le texte de la première ligne saisie.
</DESC> */
// OVERRIDE SCRIPT ANCESTOR
Long ll_indice

i_b_canceled = TRUE
IF dw_1.fu_changed() THEN
	THIS.Triggerevent("ue_save")
END IF

	// Suppression des lignes vides 
ll_indice = dw_1.RowCount()
DO WHILE ll_indice > 0
	if dw_1.getitemstring(ll_indice,DBNAME_MESSAGE) = "" then
		dw_1.DeleteRow (ll_indice)
	  end if
	ll_indice -- 
LOOP	
dw_1.update()	

if dw_1.rowCount() > 0 then
	i_str_pass.s[5] = dw_1.getItemString(1, DBNAME_MESSAGE)
else
	i_str_pass.s[5] = DONNEE_VIDE
end if

Message.fnv_set_str_pass(i_str_pass)
Close(this)
end event

event ue_cancel;i_b_canceled = FALSE
fw_init_message()
Message.fnv_set_str_pass(i_str_pass)
close(this)
end event

type uo_statusbar from w_message_cde_response`uo_statusbar within w_message_9086
integer x = 2478
integer y = 308
end type

type dw_1 from w_message_cde_response`dw_1 within w_message_9086
string tag = "A_TRADUIRE"
integer x = 439
integer y = 1216
integer width = 2085
integer height = 512
string dataobject = "d_texte_come9086_complement"
borderstyle borderstyle = stylelowered!
end type

type dw_mas from w_message_cde_response`dw_mas within w_message_9086
string tag = "A_TRADUIRE"
integer height = 512
end type

type pb_echap from w_message_cde_response`pb_echap within w_message_9086
integer y = 1804
string picturename = "C:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type pb_ok from w_message_cde_response`pb_ok within w_message_9086
integer y = 1812
string picturename = "C:\appscir\Erfvmr_diva\Image\pbok.bmp"
end type

type pb_suppression from w_message_cde_response`pb_suppression within w_message_9086
integer y = 1808
string picturename = "C:\appscir\Erfvmr_diva\Image\PB_SUPPR.BMP"
end type

type pb_impression from w_message_cde_response`pb_impression within w_message_9086
integer y = 1808
string picturename = "C:\appscir\Erfvmr_diva\Image\PB_IMP.BMP"
end type

type dw_2 from u_dwa within w_message_9086
string tag = "A_TRADUIRE"
integer x = 475
integer y = 640
integer width = 2011
integer height = 448
integer taborder = 11
boolean bringtotop = true
boolean enabled = false
string dataobject = "d_texte_come9086"
boolean hscrollbar = true
borderstyle borderstyle = styleshadowbox!
end type

type ln_1 from line within w_message_9086
integer linethickness = 4
integer beginx = 256
integer beginy = 1184
integer endx = 2816
integer endy = 1184
end type

