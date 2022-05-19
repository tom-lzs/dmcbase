$PBExportHeader$w_dw_printpreview_pt.srw
$PBExportComments$[RESPONSE] Fenêtre Aperçu avant impression
forward
global type w_dw_printpreview_pt from w_a_q
end type
type cbx_ruler from u_cbxa within w_dw_printpreview_pt
end type
type cb_close from u_cb_close within w_dw_printpreview_pt
end type
type cb_next from u_cb_next within w_dw_printpreview_pt
end type
type cb_print from u_cb_print within w_dw_printpreview_pt
end type
type cb_prior from u_cb_prior within w_dw_printpreview_pt
end type
type cb_saveas from u_cb_save_as within w_dw_printpreview_pt
end type
type cb_printsetup from u_cb_printsetup within w_dw_printpreview_pt
end type
type cb_zoom from u_cba within w_dw_printpreview_pt
end type
type st_1 from statictext within w_dw_printpreview_pt
end type
end forward

global type w_dw_printpreview_pt from w_a_q
int Width=2981
int Height=1393
WindowType WindowType=response!
boolean TitleBar=true
string Title="Aperçu avant impression"
long BackColor=79741120
boolean MinBox=false
boolean MaxBox=false
event ue_ruler pbm_custom40
event ue_zoom pbm_custom41
cbx_ruler cbx_ruler
cb_close cb_close
cb_next cb_next
cb_print cb_print
cb_prior cb_prior
cb_saveas cb_saveas
cb_printsetup cb_printsetup
cb_zoom cb_zoom
st_1 st_1
end type
global w_dw_printpreview_pt w_dw_printpreview_pt

type variables
PROTECTED:

DataWindow i_dw_print	// Source DataWindow
Integer i_i_return		// -1 = Error encountered
			//  0 = "Previewed Only",
			//  1 = "Printed"
end variables

on ue_ruler;call w_a_q::ue_ruler;// Turn rulers on/off based on value of CheckBox.

SetPointer(HourGlass!)

IF cbx_ruler.checked THEN
	dw_1.Modify ("DataWindow.Print.Preview.rulers=YES")
ELSE
	dw_1.Modify ("DataWindow.Print.Preview.rulers=NO")
END IF
end on

event ue_zoom;call super::ue_zoom;// Open the Zoom response window with the DataWindow to zoom.

SetPointer(HourGlass!)

i_str_pass.po [1] = dw_1
i_str_pass.s_win_title = this.title


message.fnv_set_str_pass (i_str_pass)

Open (w_dw_printpreview_zoom)
end event

on ue_printsetup;call w_a_q::ue_printsetup;// Trigger ruler event on parent window to force a redraw if
// orientation was changed.

this.TriggerEvent ("ue_ruler")
end on

on ue_cancel;call w_a_q::ue_cancel;// Close window with return code.

str_pass str_pass


str_pass.d [1] = i_i_return

message.fnv_set_str_pass (str_pass)

Close (this)
end on

on ue_next;//Override!

// Scroll to Next page (not next row).

dw_1.ScrollNextPage ()
end on

event ue_init;call w_a_q::ue_init;String s_dwsyntax, s_dwmod, s_col_name
Integer i_col_cnt , i_col_num 
Datawindowchild dwc_source_column, dwc_target_column

// Bail out of Open script did not terminate successfully.

IF i_i_return < 0 THEN
	RETURN
END IF


// Create DataWindow for the preview DataWindow, dw_1, dynamically,
// from the definition of the source DataWindow, i_dw_print.

dw_1.Create (i_dw_print.Describe ("DataWindow.Syntax"))

i_dw_print.ShareData (dw_1)


// Modify the preview DataWindow, dw_1, to set printpreview on and
// change the tab order of each column to 0.  

s_dwmod = "DataWindow.Print.Preview=YES"

i_col_cnt = Integer (dw_1.Describe ("DataWindow.Column.Count"))

FOR i_col_num = 1 TO i_col_cnt 
	s_dwmod = s_dwmod + "~t#" + String (i_col_num) + ".TabSequence=0"
	
	// Find out if any columns are drop down datawindows. If so, share data
	// with the child datawindows on the source datawindow.
	
	s_col_name = dw_1.Describe ("#" + String(i_col_num) + ".Name")
	
	IF dw_1.Describe (s_col_name + ".Edit.Style") = "dddw" THEN
		i_dw_print.GetChild(s_col_name, dwc_source_column)
		dw_1.GetChild(s_col_name, dwc_target_column)
		dwc_source_column.ShareData(dwc_target_column)
	END IF

NEXT

dw_1.Modify (s_dwmod)


// Post event to turn rulers on/off.

PostEvent ("ue_ruler")
end event

event open;call super::open;// Extract the DataWindow from the message structure.

GraphicObject go_parm

this.fw_center_window()

// Check the validity of the first PowerObject parm and save it to
// an instance variable if it is a DataWindow.

IF UpperBound (i_str_pass.po) > 0 THEN
	IF IsValid (i_str_pass.po [1]) THEN
		go_parm = i_str_pass.po [1]
		IF go_parm.TypeOf () = DataWindow! THEN
			i_dw_print = go_parm
			RETURN
		END IF
	END IF
END IF


// DataWindow was not successfully passed.

i_i_return = -1

this.PostEvent ("ue_close")
end event

on ue_prior;//Override!

// Scroll to Prior page (not prior row).

dw_1.ScrollPriorPage ()
end on

on resize;call w_a_q::resize;// Override!

dw_1.Move (1, 160)

dw_1.Resize (this.WorkSpaceWidth (), this.WorkSpaceHeight () - 159)
end on

on ue_close;// Override!

// Close window with return code.

str_pass str_pass


str_pass.d [1] = i_i_return

message.fnv_set_str_pass (str_pass)

Close (this)
end on

on w_dw_printpreview_pt.create
int iCurrent
call w_a_q::create
this.cbx_ruler=create cbx_ruler
this.cb_close=create cb_close
this.cb_next=create cb_next
this.cb_print=create cb_print
this.cb_prior=create cb_prior
this.cb_saveas=create cb_saveas
this.cb_printsetup=create cb_printsetup
this.cb_zoom=create cb_zoom
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=cbx_ruler
this.Control[iCurrent+2]=cb_close
this.Control[iCurrent+3]=cb_next
this.Control[iCurrent+4]=cb_print
this.Control[iCurrent+5]=cb_prior
this.Control[iCurrent+6]=cb_saveas
this.Control[iCurrent+7]=cb_printsetup
this.Control[iCurrent+8]=cb_zoom
this.Control[iCurrent+9]=st_1
end on

on w_dw_printpreview_pt.destroy
call w_a_q::destroy
destroy(this.cbx_ruler)
destroy(this.cb_close)
destroy(this.cb_next)
destroy(this.cb_print)
destroy(this.cb_prior)
destroy(this.cb_saveas)
destroy(this.cb_printsetup)
destroy(this.cb_zoom)
destroy(this.st_1)
end on

on ue_print;// Override!

// Print the source DataWindow (not the display DataWindow).

i_dw_print.Print ()
end on

type dw_1 from w_a_q`dw_1 within w_dw_printpreview_pt
int X=65
int Y=173
int Width=2826
int Height=1125
int TabOrder=90
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
end type

type cbx_ruler from u_cbxa within w_dw_printpreview_pt
int X=2652
int Y=21
int Width=266
int Height=85
int TabOrder=80
string Text="Règles"
boolean Checked=true
int TextSize=-9
end type

on clicked;call u_cbxa::clicked;// Trigger ruler event on parent window.

Parent.TriggerEvent ("ue_ruler")
end on

event constructor;call super::constructor;// Set CheckBox microhelp.

this.fu_set_microhelp ("Affiche ou non la règle")
end event

type cb_close from u_cb_close within w_dw_printpreview_pt
int X=2282
int Y=21
int Width=343
int TabOrder=70
boolean Cancel=true
end type

type cb_next from u_cb_next within w_dw_printpreview_pt
int X=69
int Y=21
int Width=343
int TabOrder=10
end type

type cb_print from u_cb_print within w_dw_printpreview_pt
int X=778
int Y=21
int Width=343
int TabOrder=30
boolean Default=true
end type

type cb_prior from u_cb_prior within w_dw_printpreview_pt
int X=421
int Y=21
int Width=343
int TabOrder=20
end type

type cb_saveas from u_cb_save_as within w_dw_printpreview_pt
int X=1925
int Y=21
int Width=343
int TabOrder=60
boolean BringToTop=true
end type

type cb_printsetup from u_cb_printsetup within w_dw_printpreview_pt
int X=1134
int Y=21
int Width=417
int TabOrder=40
boolean BringToTop=true
string Text="&Configurer..."
end type

type cb_zoom from u_cba within w_dw_printpreview_pt
int X=1569
int Y=21
int Width=343
int TabOrder=50
boolean BringToTop=true
string Text="&Zoom..."
end type

event constructor;call super::constructor;// Set triggered event and microhelp.

this.fu_setevent ("ue_zoom")

this.fu_set_microhelp ("Réglage du niveau de Zoom")
end event

type st_1 from statictext within w_dw_printpreview_pt
int X=51
int Y=13
int Width=2885
int Height=125
boolean Enabled=false
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=79741120
int TextSize=-8
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

