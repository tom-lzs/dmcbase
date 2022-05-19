$PBExportHeader$w_dw_printpreview_zoom_pt.srw
$PBExportComments$Fenêtre de zoom d'une DataWindow en aperçu avant impression
forward
global type w_dw_printpreview_zoom_pt from w_a
end type
type cb_2 from u_cb_cancel within w_dw_printpreview_zoom_pt
end type
type cb_1 from u_cb_ok within w_dw_printpreview_zoom_pt
end type
type rb_custom from radiobutton within w_dw_printpreview_zoom_pt
end type
type rb_75 from radiobutton within w_dw_printpreview_zoom_pt
end type
type rb_100 from radiobutton within w_dw_printpreview_zoom_pt
end type
type rb_200 from radiobutton within w_dw_printpreview_zoom_pt
end type
type rb_50 from radiobutton within w_dw_printpreview_zoom_pt
end type
type dw_custom from datawindow within w_dw_printpreview_zoom_pt
end type
type gb_1 from groupbox within w_dw_printpreview_zoom_pt
end type
end forward

shared variables
Integer s_i_zoom_factor	// last custom zoom factor
Integer s_i_button		// last RadioButton pressed
end variables

global type w_dw_printpreview_zoom_pt from w_a
int Width=1230
int Height=733
WindowType WindowType=response!
boolean TitleBar=true
string Title="Zoom"
long BackColor=79741120
boolean MinBox=false
boolean MaxBox=false
boolean Resizable=false
cb_2 cb_2
cb_1 cb_1
rb_custom rb_custom
rb_75 rb_75
rb_100 rb_100
rb_200 rb_200
rb_50 rb_50
dw_custom dw_custom
gb_1 gb_1
end type
global w_dw_printpreview_zoom_pt w_dw_printpreview_zoom_pt

type variables
PRIVATE:

DataWindow i_dw_zoom	// DataWindow to zoom
end variables

forward prototypes
public subroutine fw_clear_custom ()
end prototypes

public subroutine fw_clear_custom ();// reset value in custom
dw_custom.SetItem(1, "zoom_factor", 100 )

end subroutine

on ue_ok;call w_a::ue_ok;// Save values of zoom factor button pressed to shared variables and
// return those values in i_str_pass.


SetPointer(HourGlass!)


// Bail out if an invalid custom zoom factor was entered.

IF dw_custom.AcceptText () < 0 THEN
	dw_custom.SetFocus ()
	RETURN
END IF


// Determine button pressed and zoom factor.

CHOOSE CASE TRUE
	CASE rb_200.checked
		s_i_zoom_factor = 200
		s_i_button = 1
	CASE rb_100.checked
		s_i_zoom_factor = 100
		s_i_button = 2
	CASE rb_75.checked
		s_i_zoom_factor = 75
		s_i_button = 3
	CASE rb_50.checked
		s_i_zoom_factor = 50
		s_i_button = 4
	CASE rb_custom.checked
	 	s_i_zoom_factor = dw_custom.GetItemNumber (1, 1)
		s_i_button = 5
	CASE ELSE
		s_i_zoom_factor = 100
		s_i_button = 2
END CHOOSE


// Modify the zoom DataWindow with the new zoom factor.

i_dw_zoom.Modify ("datawindow.print.preview.zoom=" + &
								String (s_i_zoom_factor))


// Return the zoom factor.

i_str_pass.d [1] = s_i_zoom_factor

message.fnv_set_str_pass (i_str_pass)

Close (this)
end on

on ue_reserved4powertool;call w_a::ue_reserved4powertool;//
//	Maintenance
//		2/24/95		#11	Changed spin increment of em_custom to 5.
//		2/28/95		#22	Changed em_custom to a DataWindow, dw_custom.
end on

event open;call super::open;// Extract the DataWindow to zoom from i_str_pass.

IF UpperBound (i_str_pass.po) < 1 THEN
	this.PostEvent ("ue_cancel")
	RETURN
END IF

IF NOT IsValid (i_str_pass.po [1]) THEN
	this.PostEvent ("ue_cancel")
	RETURN
END IF

i_dw_zoom = i_str_pass.po [1]


// Reset RadioButton zoom factor previous value.
 
IF s_i_zoom_factor > 0 THEN
	dw_custom.SetItem (1, 1, s_i_zoom_factor)
ELSE
	dw_custom.SetItem (1, 1, 100)
END IF

CHOOSE CASE s_i_button
	CASE 1
		rb_200.checked = TRUE
	CASE 2
		rb_100.checked = TRUE
	CASE 3
		rb_75.checked = TRUE
	CASE 4
		rb_50.checked = TRUE
	CASE 5
		rb_custom.checked = TRUE
		dw_custom.Show ()
	CASE ELSE
		rb_100.checked = TRUE
END CHOOSE
end event

on ue_cancel;call w_a::ue_cancel;// Return the unaltered i_str_pass.

message.fnv_set_str_pass (i_str_pass)

Close (this)
end on

on w_dw_printpreview_zoom_pt.create
int iCurrent
call w_a::create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.rb_custom=create rb_custom
this.rb_75=create rb_75
this.rb_100=create rb_100
this.rb_200=create rb_200
this.rb_50=create rb_50
this.dw_custom=create dw_custom
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=cb_2
this.Control[iCurrent+2]=cb_1
this.Control[iCurrent+3]=rb_custom
this.Control[iCurrent+4]=rb_75
this.Control[iCurrent+5]=rb_100
this.Control[iCurrent+6]=rb_200
this.Control[iCurrent+7]=rb_50
this.Control[iCurrent+8]=dw_custom
this.Control[iCurrent+9]=gb_1
end on

on w_dw_printpreview_zoom_pt.destroy
call w_a::destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.rb_custom)
destroy(this.rb_75)
destroy(this.rb_100)
destroy(this.rb_200)
destroy(this.rb_50)
destroy(this.dw_custom)
destroy(this.gb_1)
end on

event ue_close;call super::ue_close;this.postevent("ue_close")
end event

type cb_2 from u_cb_cancel within w_dw_printpreview_zoom_pt
int X=759
int Y=197
int TabOrder=30
end type

type cb_1 from u_cb_ok within w_dw_printpreview_zoom_pt
int X=759
int Y=77
int TabOrder=10
end type

type rb_custom from radiobutton within w_dw_printpreview_zoom_pt
int X=74
int Y=465
int Width=302
int Height=69
string Text="&Autre"
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=79741120
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;// Show the custom zoom control and set focus to it if this
// RadioButton is checked.

IF this.checked THEN
	dw_custom.Show ()
	dw_custom.SetFocus ()
END IF
end on

type rb_75 from radiobutton within w_dw_printpreview_zoom_pt
int X=74
int Y=297
int Width=243
int Height=69
string Text="&75%"
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=79741120
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;// Hide the custom zoom control if this RadioButton is checked.

IF this.checked THEN
	parent.fw_clear_custom()
	dw_custom.Hide ()
END IF
end event

type rb_100 from radiobutton within w_dw_printpreview_zoom_pt
int X=74
int Y=213
int Width=257
int Height=69
string Text="&100%"
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=79741120
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;// Hide the custom zoom control if this RadioButton is checked.

IF this.checked THEN
	parent.fw_clear_custom()
	dw_custom.Hide ()
END IF
end event

type rb_200 from radiobutton within w_dw_printpreview_zoom_pt
int X=74
int Y=129
int Width=257
int Height=69
string Text="&200%"
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=79741120
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;// Hide the custom zoom control if this RadioButton is checked.

IF this.checked THEN
	parent.fw_clear_custom()
	dw_custom.Hide ()
END IF
end event

type rb_50 from radiobutton within w_dw_printpreview_zoom_pt
int X=74
int Y=381
int Width=243
int Height=69
string Text="&50%"
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=79741120
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;// Hide the custom zoom control if this RadioButton is checked.

IF this.checked THEN
	parent.fw_clear_custom()
	dw_custom.Hide ()
END IF
end event

type dw_custom from datawindow within w_dw_printpreview_zoom_pt
int X=398
int Y=445
int Width=266
int Height=117
int TabOrder=40
boolean Visible=false
string DataObject="d_printpreview_zoom"
boolean Border=false
boolean LiveScroll=true
end type

on constructor;this.InsertRow (0)

this.Modify ("DataWindow.Message.Title = 'Custom Zoom Factor'")

this.SetRowFocusIndicator (Off!)
end on

type gb_1 from groupbox within w_dw_printpreview_zoom_pt
int X=42
int Y=53
int Width=654
int Height=525
int TabOrder=20
string Text="Zoom"
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=79741120
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

