$PBExportHeader$w_set_toolbars_pt.srw
$PBExportComments$[RESPONSE] Gestion de la barre d'icônes
forward
global type w_set_toolbars_pt from w_a
end type
type rb_sheet from radiobutton within w_set_toolbars_pt
end type
type rb_frame from radiobutton within w_set_toolbars_pt
end type
type cbx_showtext from checkbox within w_set_toolbars_pt
end type
type rb_floating from radiobutton within w_set_toolbars_pt
end type
type rb_left from radiobutton within w_set_toolbars_pt
end type
type rb_right from radiobutton within w_set_toolbars_pt
end type
type rb_bottom from radiobutton within w_set_toolbars_pt
end type
type rb_top from radiobutton within w_set_toolbars_pt
end type
type gb_2 from groupbox within w_set_toolbars_pt
end type
type gb_1 from groupbox within w_set_toolbars_pt
end type
type cb_done from u_cb_cancel within w_set_toolbars_pt
end type
type cb_visible from u_cb_ok within w_set_toolbars_pt
end type
end forward

global type w_set_toolbars_pt from w_a
int X=737
int Y=645
int Width=1386
int Height=613
WindowType WindowType=response!
boolean TitleBar=true
string Title="Gestion de la barre d'icônes"
long BackColor=79741120
boolean MinBox=false
boolean MaxBox=false
rb_sheet rb_sheet
rb_frame rb_frame
cbx_showtext cbx_showtext
rb_floating rb_floating
rb_left rb_left
rb_right rb_right
rb_bottom rb_bottom
rb_top rb_top
gb_2 gb_2
gb_1 gb_1
cb_done cb_done
cb_visible cb_visible
end type
global w_set_toolbars_pt w_set_toolbars_pt

type variables
Window i_w_current	// Current sheet or Window
end variables

forward prototypes
private subroutine fw_set_state ()
end prototypes

private subroutine fw_set_state ();CHOOSE CASE i_w_current.toolbaralignment
	CASE alignatbottom! 
		rb_bottom.checked = TRUE
	CASE alignatleft! 
		rb_left.checked = TRUE
	CASE alignatright! 
		rb_right.checked = TRUE
	CASE alignattop! 
		rb_top.checked = TRUE
	CASE ELSE
		rb_floating.checked = TRUE
END CHOOSE

IF i_w_current.toolbarvisible THEN
	cb_visible.text = "&Cacher"
ELSE
	cb_visible.text = "&Montrer"
END IF

cbx_showtext.checked = GetApplication ().toolbartext


end subroutine

on open;call w_a::open;// Bail out if the Frame wasn't passed or if it isn't an MDI frame.

IF NOT IsValid (i_str_pass.w_frame) THEN
	Close (this)
	RETURN
END IF

i_w_frame = i_str_pass.w_frame

IF i_w_frame.windowtype <> MDIHelp! AND &
	i_w_frame.windowtype <> MDI! THEN
	Close (this)
	RETURN
END IF


// Actions currently reference frame.  Is there a sheet?

i_w_current = i_w_frame

IF NOT IsValid (i_w_frame.GetActiveSheet ())  THEN
	rb_sheet.enabled = FALSE
END IF

this.fw_set_state ()
end on

event ue_ok;call super::ue_ok;IF cb_visible.text = "&Cacher" THEN
	i_w_current.toolbarvisible = FALSE
	cb_visible.text = "&Montrer"
ELSE
	i_w_current.toolbarvisible = TRUE
	cb_visible.text = "&Cacher"
END IF

end event

on ue_cancel;call w_a::ue_cancel;Close (this)
end on

on w_set_toolbars_pt.create
int iCurrent
call w_a::create
this.rb_sheet=create rb_sheet
this.rb_frame=create rb_frame
this.cbx_showtext=create cbx_showtext
this.rb_floating=create rb_floating
this.rb_left=create rb_left
this.rb_right=create rb_right
this.rb_bottom=create rb_bottom
this.rb_top=create rb_top
this.gb_2=create gb_2
this.gb_1=create gb_1
this.cb_done=create cb_done
this.cb_visible=create cb_visible
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=rb_sheet
this.Control[iCurrent+2]=rb_frame
this.Control[iCurrent+3]=cbx_showtext
this.Control[iCurrent+4]=rb_floating
this.Control[iCurrent+5]=rb_left
this.Control[iCurrent+6]=rb_right
this.Control[iCurrent+7]=rb_bottom
this.Control[iCurrent+8]=rb_top
this.Control[iCurrent+9]=gb_2
this.Control[iCurrent+10]=gb_1
this.Control[iCurrent+11]=cb_done
this.Control[iCurrent+12]=cb_visible
end on

on w_set_toolbars_pt.destroy
call w_a::destroy
destroy(this.rb_sheet)
destroy(this.rb_frame)
destroy(this.cbx_showtext)
destroy(this.rb_floating)
destroy(this.rb_left)
destroy(this.rb_right)
destroy(this.rb_bottom)
destroy(this.rb_top)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.cb_done)
destroy(this.cb_visible)
end on

type rb_sheet from radiobutton within w_set_toolbars_pt
int X=74
int Y=197
int Width=321
int Height=69
string Text="Fenêtre"
BorderStyle BorderStyle=StyleLowered!
long BackColor=79741120
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;i_w_current = i_w_frame.GetActiveSheet ()
fw_set_state ()




end on

type rb_frame from radiobutton within w_set_toolbars_pt
int X=74
int Y=109
int Width=343
int Height=69
string Text="Principale"
BorderStyle BorderStyle=StyleLowered!
boolean Checked=true
long BackColor=79741120
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;i_w_current = i_w_frame
fw_set_state ( )
end on

type cbx_showtext from checkbox within w_set_toolbars_pt
int X=28
int Y=369
int Width=471
int Height=69
int TabOrder=30
string Text="&Afficher texte"
BorderStyle BorderStyle=StyleLowered!
long BackColor=79741120
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;Application app


app = GetApplication ()

app.toolbartext = this.checked
end on

type rb_floating from radiobutton within w_set_toolbars_pt
int X=531
int Y=385
int Width=343
int Height=69
string Text="&Flottant"
BorderStyle BorderStyle=StyleLowered!
long BackColor=79741120
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;i_w_current.toolbaralignment = floating!
end on

type rb_left from radiobutton within w_set_toolbars_pt
int X=531
int Y=97
int Width=330
int Height=69
string Text="&Gauche"
BorderStyle BorderStyle=StyleLowered!
long BackColor=79741120
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;i_w_current.toolbaralignment = alignatleft!
end on

type rb_right from radiobutton within w_set_toolbars_pt
int X=531
int Y=169
int Width=289
int Height=69
string Text="&Droite"
BorderStyle BorderStyle=StyleLowered!
long BackColor=79741120
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;i_w_current.toolbaralignment = alignatright!
end on

type rb_bottom from radiobutton within w_set_toolbars_pt
int X=531
int Y=313
int Width=343
int Height=69
string Text="&Bas"
BorderStyle BorderStyle=StyleLowered!
long BackColor=79741120
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;i_w_current.toolbaralignment = alignatbottom!
end on

type rb_top from radiobutton within w_set_toolbars_pt
int X=531
int Y=241
int Width=247
int Height=69
string Text="&Haut"
BorderStyle BorderStyle=StyleLowered!
long BackColor=79741120
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;i_w_current.toolbaralignment = alignattop!
end on

type gb_2 from groupbox within w_set_toolbars_pt
int X=37
int Y=33
int Width=412
int Height=301
int TabOrder=20
string Text="Sélectionner"
BorderStyle BorderStyle=StyleLowered!
long BackColor=79741120
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type gb_1 from groupbox within w_set_toolbars_pt
int X=499
int Y=33
int Width=403
int Height=445
int TabOrder=50
string Text="Déplacer"
BorderStyle BorderStyle=StyleLowered!
long BackColor=79741120
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_done from u_cb_cancel within w_set_toolbars_pt
int X=947
int Y=193
int TabOrder=40
string Text="&Appliquer"
end type

event constructor;call super::constructor;// Set button microhelp.

this.fu_set_microhelp ("Ferme la fenêtre de gestion de la barre d~'icônes")
end event

type cb_visible from u_cb_ok within w_set_toolbars_pt
int X=947
int Y=65
int TabOrder=10
string Text="&Cacher"
end type

event constructor;call super::constructor;// Set button microhelp.

this.fu_set_microhelp ("Cache la barre d~'icônes")
end event

